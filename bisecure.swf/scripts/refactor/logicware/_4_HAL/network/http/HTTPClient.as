package refactor.logicware._4_HAL.network.http
{
   import com.isisic.remote.lw.mcp.MCP;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import mx.utils.Base64Encoder;
   import refactor.logicware._4_HAL.network.ClientEvent;
   import refactor.logicware._4_HAL.network.IClient;
   import refactor.logicware._5_UTIL.Log;
   
   public class HTTPClient extends EventDispatcher implements IClient
   {
      
      private static const REQUEST_METHOD:String = URLRequestMethod.POST;
      
      public static var INSTANCE_COUNT:int = 0;
       
      
      public var idleTimeout:int = 86400000;
      
      public var receiveTMCP:Boolean = true;
      
      public var sendAuth:Boolean = false;
      
      public var httpVarName:String = "mcp";
      
      protected var _httpAuthentication:URLRequestHeader = null;
      
      public var httpRequestProtocol:String = "https://";
      
      public var responseState:int = -1;
      
      protected var host:String;
      
      protected var port:int;
      
      public function HTTPClient()
      {
         super();
         INSTANCE_COUNT++;
      }
      
      public static function createBasicAuth(param1:String = "admin", param2:String = "0000") : URLRequestHeader
      {
         var _loc3_:Base64Encoder = new Base64Encoder();
         _loc3_.encode(param1 + ":" + param2);
         return new URLRequestHeader("Authorization","Basic " + _loc3_.toString());
      }
      
      public function set httpAuthentication(param1:URLRequestHeader) : void
      {
         this._httpAuthentication = param1;
         this.sendAuth = true;
      }
      
      public function get httpAuthentication() : URLRequestHeader
      {
         return this._httpAuthentication;
      }
      
      public function get connected() : Boolean
      {
         return this.host != null;
      }
      
      public function connect(param1:String, param2:int) : void
      {
         this.host = param1;
         this.port = param2;
         dispatchEvent(new Event(Event.CONNECT));
      }
      
      protected function createLoader() : URLLoader
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onData);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecError);
         _loc1_.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onStatusResponse);
         return _loc1_;
      }
      
      protected function releaseLoader(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onData);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecError);
         param1.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,this.onStatusResponse);
         param1 = null;
      }
      
      protected function onData(param1:Event) : void
      {
         var _loc3_:ByteArray = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:String = param1.target.data;
         this.releaseLoader(param1.target as URLLoader);
         if(!this.receiveTMCP)
         {
            _loc3_ = new ByteArray();
            _loc3_.writeUTFBytes(_loc2_);
            dispatchEvent(new ClientEvent(ClientEvent.RECEIVE,false,false,_loc3_));
            return;
         }
         var _loc4_:Boolean = false;
         while(_loc2_.length >= MCP.ADDRESS_SIZE * 2 + MCP.FRAME_SIZE + 2)
         {
            _loc5_ = _loc2_.substr(0,MCP.ADDRESS_SIZE);
            _loc2_ = _loc2_.substr(MCP.ADDRESS_SIZE);
            _loc6_ = _loc2_.substr(0,MCP.ADDRESS_SIZE);
            _loc2_ = _loc2_.substr(MCP.ADDRESS_SIZE);
            _loc7_ = int("0x" + _loc2_.substr(0,MCP.LENGTH_SIZE));
            if(_loc2_.length < (_loc7_ + 1) * MCP.BYTE_MULTIPLIER)
            {
               Log.error("[HttpClient] invalid tmcp Package:\n" + _loc5_ + "\n" + _loc6_ + "\n" + _loc2_);
               break;
            }
            _loc8_ = _loc2_.substr(0,_loc7_ * MCP.BYTE_MULTIPLIER);
            _loc2_ = _loc2_.substr(_loc7_ * MCP.BYTE_MULTIPLIER);
            _loc9_ = _loc2_.substr(0,2);
            _loc2_ = _loc2_.substr(2);
            _loc3_ = new ByteArray();
            _loc3_.writeUTFBytes(_loc5_ + _loc6_ + _loc8_ + _loc9_);
            _loc3_.position = 0;
            dispatchEvent(new ClientEvent(ClientEvent.RECEIVE,false,false,_loc3_));
            _loc4_ = true;
         }
         if(!_loc4_)
         {
            Log.warning("[HttpClient] Empty response! HTTP response: " + _loc2_);
            dispatchEvent(new ClientEvent(ClientEvent.RECEIVE));
            return;
         }
      }
      
      protected function onStatusResponse(param1:HTTPStatusEvent) : void
      {
         this.responseState = param1.status;
         Log.debug("[HTTPClient] Response State: " + param1.status);
         dispatchEvent(param1);
      }
      
      protected function onError(param1:IOErrorEvent) : void
      {
         Log.error("[HttpClient] IOERROR! " + param1);
         dispatchEvent(new IOErrorEvent(param1.type,param1.bubbles,param1.cancelable,param1.text,param1.errorID));
      }
      
      protected function onSecError(param1:SecurityErrorEvent) : void
      {
         Log.error("[HttpClient] SecError! " + param1);
         dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,param1.text,param1.errorID));
      }
      
      public function close() : void
      {
         this.host = null;
         this.port = 80;
      }
      
      public function destruct() : void
      {
         this.close();
         INSTANCE_COUNT--;
      }
      
      public function send(param1:ByteArray) : void
      {
         if(!param1 || !(param1 is ByteArray))
         {
            Log.error("Class HttpClient expects data to be an Bytearray!");
            return;
         }
         param1.position = 0;
         var _loc2_:String = param1.readUTFBytes(param1.bytesAvailable);
         var _loc3_:URLLoader = this.createLoader();
         var _loc4_:URLRequest = new URLRequest();
         var _loc5_:URLVariables = new URLVariables();
         _loc5_[this.httpVarName] = _loc2_;
         this.sendVars(_loc5_);
      }
      
      public function sendVars(param1:URLVariables) : void
      {
         var _loc2_:URLLoader = this.createLoader();
         var _loc3_:URLRequest = new URLRequest();
         _loc3_.url = this.httpRequestProtocol + this.host;
         _loc3_.authenticate = false;
         _loc3_.data = param1;
         _loc3_.method = REQUEST_METHOD;
         _loc3_.cacheResponse = false;
         _loc3_.useCache = false;
         _loc3_.idleTimeout = this.idleTimeout;
         _loc3_.requestHeaders.push(new URLRequestHeader("Connection","Keep-Alive"));
         var _loc4_:URLRequestHeader = new URLRequestHeader("ACCEPT","text/plain");
         _loc3_.requestHeaders.push(_loc4_);
         _loc3_.userAgent = "Bisecur";
         if(this.httpAuthentication)
         {
            _loc3_.requestHeaders.push(this.httpAuthentication);
            this.sendAuth = false;
         }
         _loc2_.load(_loc3_);
      }
   }
}
