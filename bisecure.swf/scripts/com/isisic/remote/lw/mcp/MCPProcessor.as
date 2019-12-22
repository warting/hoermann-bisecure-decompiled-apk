package com.isisic.remote.lw.mcp
{
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.global.DebugGlobals;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.Timings;
   import com.isisic.remote.lw.mcp.events.LoginEvent;
   import com.isisic.remote.lw.mcp.events.MCPEvent;
   import com.isisic.remote.lw.net.AsciiClient;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import com.isisic.remote.lw.net.HTTPClient;
   import com.isisic.remote.lw.net.IClient;
   import com.isisic.remote.lw.net.RawDataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class MCPProcessor extends EventDispatcher implements IDisposable
   {
       
      
      protected var _processing:Boolean = false;
      
      protected var _client:IClient;
      
      protected var _context:ConnectionContext;
      
      protected var manager:MCPManager;
      
      protected var loaderBuffer:Array;
      
      protected var timeoutTimer:Timer;
      
      public function MCPProcessor(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this.manager = MCPManager.defaultManager;
         this.loaderBuffer = new Array();
         this.initTimeoutTimer();
         this.initContext(param1,param2,param3,param4,param5,param6);
      }
      
      [Bindable(event="processingChanged")]
      public function get processing() : Boolean
      {
         return this._processing;
      }
      
      public function get client() : IClient
      {
         return this._client;
      }
      
      public function get context() : ConnectionContext
      {
         return this._context;
      }
      
      public function dispose() : void
      {
         this.resetConnection();
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.timeoutTimer = null;
         }
         if(this.manager)
         {
            this.manager = null;
         }
         this.loaderBuffer = null;
         this._context = null;
      }
      
      public function get connected() : Boolean
      {
         if(!this.client)
         {
            return false;
         }
         return this._client.connected;
      }
      
      public function connect() : void
      {
         this.initClient(this.context.host,this.context.port);
      }
      
      public function disconnect() : void
      {
         this.resetConnection();
      }
      
      public function resetConnection() : void
      {
         if(this._client)
         {
            if(this._client.connected)
            {
               this._client.close();
            }
            this._client.removeEventListener(Event.CONNECT,this.onConnect);
            this._client.removeEventListener(Event.CLOSE,this.onClose);
            this._client.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._client.removeEventListener(RawDataEvent.DATA,this.onData);
            this._client.removeEventListener(RawDataEvent.NO_DATA,this.onNoData);
            this._client.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatusResponse);
            this._client.destruct();
            this._client = null;
         }
      }
      
      protected function initClient(param1:String, param2:int) : void
      {
         var _loc3_:HTTPClient = null;
         if(this._client != null)
         {
            this._client.destruct();
            this._client = null;
         }
         switch(this.context.connectionType)
         {
            case ConnectionTypes.LOCAL:
               this._client = new AsciiClient();
               break;
            case ConnectionTypes.PORTAL:
               _loc3_ = new HTTPClient();
               if(this.context.httpAutentication)
               {
                  _loc3_.httpAutentication = this.context.httpAutentication;
               }
               this._client = _loc3_;
               break;
            default:
               Debug.warning("[lw.MCPProcessor] Unexpected connectionType \'" + this.context.connectionType + "\'");
               return;
         }
         this._client.addEventListener(Event.CONNECT,this.onConnect);
         this._client.addEventListener(Event.CLOSE,this.onClose);
         this._client.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this._client.addEventListener(RawDataEvent.DATA,this.onData);
         this._client.addEventListener(RawDataEvent.NO_DATA,this.onNoData);
         this._client.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onHTTPStatusResponse);
         this._client.connect(param1,param2);
      }
      
      protected function initTimeoutTimer() : void
      {
         if(this.timeoutTimer)
         {
            this.timeoutTimer.stop();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.timeoutTimer = null;
         }
         this.timeoutTimer = new Timer(Timings.MCPPROCESSOR_REQUEST_TIMEOUTS.FALLBACK,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
      }
      
      protected function initContext(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String) : void
      {
         this._context = new ConnectionContext(this,param5,param1,param2,param3,param4,param6);
      }
      
      function load(param1:MCPLoader) : void
      {
         if(!this.loaderBuffer)
         {
            Debug.warning("[lw.MCPProcessor] processor seems to be disposed! Last request won\'t be added to queue...\n" + param1);
            return;
         }
         param1.requestPackage.tag = -1;
         this.loaderBuffer.push(param1);
         if(!this.connected)
         {
            Debug.warning("[MCPProcessor] processor not connected => waiting for connection");
            return;
         }
         if(!this.processing)
         {
            this.processBuffer();
         }
      }
      
      protected function processBuffer() : void
      {
         if(this.connected == false || !this.loaderBuffer || this.loaderBuffer.length < 1)
         {
            if(this._processing)
            {
               this._processing = false;
               dispatchEvent(new Event("processingChanged"));
            }
            return;
         }
         if(!this._processing)
         {
            this._processing = true;
            dispatchEvent(new Event("processingChanged"));
         }
         var _loc1_:MCPLoader = this.loaderBuffer[0];
         this.send(_loc1_.requestPackage);
      }
      
      protected function send(param1:MCP) : void
      {
         param1 = this.manager.addProtocol(param1);
         if(!param1)
         {
            Debug.warning("[lw.MCPProcessor] Sending MCP failed! (Package buffer is overloaded)");
            return;
         }
         var _loc2_:String = this.manager.wrapTP(this.context,param1.toString());
         Debug.outPackage(param1,_loc2_.substr(0,MCP.ADDRESS_SIZE),_loc2_.substr(MCP.ADDRESS_SIZE,MCP.ADDRESS_SIZE),this.context.connectionType);
         if(param1.command == Commands.SET_STATE || param1.command == Commands.HM_GET_TRANSITION)
         {
            if(Features.showDebugLabel)
            {
               DebugGlobals.STATE_CRUD_COUNTER++;
               BottomBar.debugLabel.text = "Requests: " + DebugGlobals.STATE_CRUD_COUNTER;
            }
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes(_loc2_);
         var _loc4_:String = Commands.NAMES[param1.command];
         if(Timings.MCPPROCESSOR_REQUEST_TIMEOUTS[_loc4_] != null)
         {
            this.timeoutTimer.delay = Timings.MCPPROCESSOR_REQUEST_TIMEOUTS[_loc4_];
         }
         else
         {
            this.timeoutTimer.delay = Timings.MCPPROCESSOR_REQUEST_TIMEOUTS.FALLBACK;
         }
         this.timeoutTimer.start();
         this.client.send(_loc3_);
      }
      
      protected function processMCP(param1:MCP) : void
      {
         var _loc2_:int = 0;
         if(param1.command == Commands.LOGIN && param1.response)
         {
            param1.payload.position = 0;
            _loc2_ = param1.payload.readUnsignedByte();
            this.manager.token = param1.payload.readUnsignedInt();
            param1.payload.position = 0;
            dispatchEvent(new LoginEvent(LoginEvent.LOGIN,param1));
         }
         else if(param1.command == Commands.LOGOUT)
         {
            this.manager.token = 0;
            dispatchEvent(new LoginEvent(LoginEvent.LOGOUT,param1));
         }
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.reset();
         if(this.loaderBuffer.length < 1)
         {
            if(this._processing)
            {
               this._processing = false;
               dispatchEvent(new Event("processingChanged"));
            }
            return;
         }
         var _loc2_:MCPLoader = this.loaderBuffer.shift();
         Debug.warning("[PkgProcessor] received timeout for:\n" + _loc2_.requestPackage);
         MCPManager.defaultManager.remProtocol(_loc2_.requestPackage.tag);
         _loc2_.onTimeout();
         this.processBuffer();
      }
      
      protected function onData(param1:RawDataEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:MCP = null;
         var _loc7_:MCP = null;
         var _loc8_:MCPLoader = null;
         var _loc9_:MCPLoader = null;
         dispatchEvent(param1);
         var _loc2_:String = param1.data.readUTFBytes(param1.data.bytesAvailable);
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(_loc2_.length > MCP.ADDRESS_SIZE * 2)
         {
            _loc3_ = _loc2_.substr(0,MCP.ADDRESS_SIZE);
            _loc4_ = _loc2_.substr(MCP.ADDRESS_SIZE,MCP.ADDRESS_SIZE);
         }
         if(_loc2_.length >= MCP.TMCP_MIN_SIZE && _loc2_.indexOf(" ") < 0)
         {
            _loc5_ = _loc2_.substr(MCP.ADDRESS_SIZE,MCP.ADDRESS_SIZE);
            this._context.clientId = _loc5_;
            Logicware.API.clientId = _loc5_;
         }
         _loc2_ = this.manager.unwrapTP(_loc2_);
         if(_loc2_)
         {
            _loc6_ = MCP.fromString(_loc2_);
            if(_loc6_)
            {
               _loc6_.validToken = _loc6_.token == this.manager.token || _loc6_.token == 0;
               Debug.inPackage(_loc6_,_loc3_,_loc4_,this.context.connectionType);
               this.processMCP(_loc6_);
               _loc7_ = this.manager.getProtocol(_loc6_.tag);
               this.manager.remProtocol(_loc6_.tag);
               dispatchEvent(new MCPEvent(_loc6_,_loc7_,MCPEvent.RECEIVED));
               if(_loc6_.tag == 255)
               {
                  Debug.info("[lw.MCPProcessor] received package with 0xFF tag => no rerplay to loader\n\t\t\t\t" + _loc6_);
                  return;
               }
               if(!_loc6_.validToken)
               {
                  if(Features.showInvalidToken)
                  {
                     HoermannRemote.errorBox.title = "~DEBUG~";
                     HoermannRemote.errorBox.contentText = "received invalid token!";
                     HoermannRemote.errorBox.closeable = true;
                     HoermannRemote.errorBox.closeTitle = "HIDE";
                  }
                  if(_loc6_.command == Commands.LOGOUT)
                  {
                     Debug.warning("[lw.MCPProcessor] received package with not valid token => token validation will be ignored (logout)!");
                  }
                  else
                  {
                     Debug.info("[lw.MCPProcessor] received package with not valid token => no reply to loader\n\t\t\t\t" + _loc6_);
                     return;
                  }
               }
               if(this.loaderBuffer.length > 0)
               {
                  _loc8_ = null;
                  for each(_loc9_ in this.loaderBuffer)
                  {
                     if(_loc9_.requestPackage.tag == _loc6_.tag)
                     {
                        _loc8_ = _loc9_;
                     }
                  }
                  if(_loc8_ != null)
                  {
                     this.timeoutTimer.reset();
                     ArrayHelper.removeItem(_loc8_,this.loaderBuffer);
                     _loc8_.onRespond(_loc6_);
                  }
                  else
                  {
                     Debug.warning("[MCPProcessor] no request tag does match response tag!\n\t\t\t\tresponse: " + _loc6_);
                  }
               }
            }
         }
         this.processBuffer();
      }
      
      protected function onConnect(param1:Event) : void
      {
         var tmr:Timer = null;
         var tmrComplete:Function = null;
         var event:Event = param1;
         if(!this.processing)
         {
            if(this._processing)
            {
               this._processing = false;
               dispatchEvent(new Event("processingChanged"));
            }
            if(Timings.TCP_CONNECTION_DELAY != 0)
            {
               tmr = new Timer(Timings.TCP_CONNECTION_DELAY,1);
               tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete = function(param1:Event):void
               {
                  tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete);
                  processBuffer();
               });
               tmr.start();
            }
            else
            {
               this.processBuffer();
            }
         }
         dispatchEvent(event);
      }
      
      protected function onClose(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         Debug.warning("[MCPProcessor] IOError! " + param1);
         this.resetConnection();
         dispatchEvent(param1);
      }
      
      protected function onNoData(param1:RawDataEvent) : void
      {
         dispatchEvent(param1);
      }
      
      protected function onHTTPStatusResponse(param1:HTTPStatusEvent) : void
      {
         if(param1.status == 200)
         {
            return;
         }
      }
   }
}
