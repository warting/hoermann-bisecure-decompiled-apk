package refactor.logicware._2_SAL
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.lw.net.lw_network;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import refactor.logicware._2_SAL.mcp.MCPPackageQueue;
   import refactor.logicware._4_HAL.network.http.HTTPClient;
   
   use namespace lw_network;
   
   public class RemoteConnectionContext extends ConnectionContext
   {
       
      
      private var _host:String;
      
      private var _port:int = 443;
      
      private var _client:HTTPClient;
      
      public function RemoteConnectionContext(param1:String, param2:String, param3:String)
      {
         this._host = Features.portalHostCommunication;
         super();
         this._mac = param3;
         this._clientId = param1;
         this._client = new HTTPClient();
         this._client.httpAuthentication = HTTPClient.createBasicAuth(param1,param2);
         this.packageQueue = new MCPPackageQueue(this,this._client);
      }
      
      override public function get connected() : Boolean
      {
         return this._client.connected;
      }
      
      override public function connect(param1:Function = null) : void
      {
         var self:RemoteConnectionContext = null;
         var connectHandler:Function = null;
         var errorHandler:Function = null;
         var callback:Function = param1;
         if(callback != null)
         {
            self = this;
            connectHandler = function(param1:Event):void
            {
               _client.removeEventListener(Event.CONNECT,connectHandler);
               _client.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               callback(self,true);
            };
            errorHandler = function(param1:IOErrorEvent):void
            {
               _client.removeEventListener(Event.CONNECT,connectHandler);
               _client.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               callback.call(self,false);
            };
            this._client.addEventListener(Event.CONNECT,connectHandler);
            this._client.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
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
            }
         }
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
