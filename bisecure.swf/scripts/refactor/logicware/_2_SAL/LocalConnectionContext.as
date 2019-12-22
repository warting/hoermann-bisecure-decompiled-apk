package refactor.logicware._2_SAL
{
   import com.isisic.remote.lw.net.lw_network;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.logicware._2_SAL.mcp.MCPPackageQueue;
   import refactor.logicware._4_HAL.network.IClient;
   import refactor.logicware._4_HAL.network.tcp.Client;
   
   use namespace lw_network;
   
   public class LocalConnectionContext extends ConnectionContext
   {
       
      
      private var _host:String;
      
      private var _port:int;
      
      private var _client:IClient;
      
      public function LocalConnectionContext(param1:String, param2:int, param3:String)
      {
         super();
         this._mac = param3;
         this._clientId = "000000000000";
         this._host = param1;
         this._port = param2;
         this._client = new Client();
         this.packageQueue = new MCPPackageQueue(this,this._client);
      }
      
      override public function get connected() : Boolean
      {
         return this._client != null && this._client.connected;
      }
      
      override public function connect(param1:Function = null) : void
      {
         var self:LocalConnectionContext = null;
         var connectHandler:Function = null;
         var connectErrorHandler:Function = null;
         var callback:Function = param1;
         if(callback != null)
         {
            self = this;
            connectHandler = function(param1:Event):void
            {
               if(_client != null)
               {
                  _client.removeEventListener(Event.CONNECT,connectHandler);
                  _client.removeEventListener(IOErrorEvent.IO_ERROR,connectErrorHandler);
               }
               CallbackHelper.callCallback(callback,[self,true]);
            };
            connectErrorHandler = function(param1:IOErrorEvent):void
            {
               if(_client != null)
               {
                  _client.removeEventListener(Event.CONNECT,connectHandler);
                  _client.removeEventListener(IOErrorEvent.IO_ERROR,connectErrorHandler);
               }
               CallbackHelper.callCallback(callback,[self,false]);
            };
            this._client.addEventListener(Event.CONNECT,connectHandler);
            this._client.addEventListener(IOErrorEvent.IO_ERROR,connectErrorHandler);
            this._client.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         }
         this._client.connect(this._host,this._port);
      }
      
      override public function disconnect() : void
      {
         if(this._client != null)
         {
            if(canDisconnect())
            {
               this._client.close();
               this._client.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
            }
         }
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
         dispatchEvent(new IOErrorEvent(param1.type,param1.bubbles,param1.cancelable,param1.text,param1.errorID));
      }
      
      override protected function onPackageQueue_ProcessingChanged(param1:Event) : void
      {
         super.onPackageQueue_ProcessingChanged(param1);
      }
      
      override public function dispose() : void
      {
         this._packageQueue.dispose();
         this._packageQueue = null;
         this._client.destruct();
         this._client = null;
      }
   }
}
