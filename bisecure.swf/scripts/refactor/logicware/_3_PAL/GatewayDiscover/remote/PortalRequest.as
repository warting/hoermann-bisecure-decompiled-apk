package refactor.logicware._3_PAL.GatewayDiscover.remote
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.Portal;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   import refactor.logicware._4_HAL.network.ClientEvent;
   import refactor.logicware._4_HAL.network.http.HTTPClient;
   import refactor.logicware._5_UTIL.Log;
   
   public class PortalRequest extends EventDispatcher
   {
       
      
      public var tag:Object;
      
      private var client:HTTPClient;
      
      private var auth:URLRequestHeader;
      
      private var deviceId:String;
      
      public function PortalRequest(param1:String, param2:String, param3:String = null)
      {
         super();
         if(!param3)
         {
            param3 = Features.portalHostMeta;
         }
         this.client = new HTTPClient();
         this.client.connect(param3,443);
         if(param3 == Features.portalHostMeta || param3 == Features.portalHostStatus)
         {
            this.client.receiveTMCP = false;
            this.client.idleTimeout = 5 * 1000;
         }
         this.client.addEventListener(ClientEvent.RECEIVE,this.onJSON);
         this.client.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.updatePortalData(param1,param2);
      }
      
      public function destruct() : void
      {
         this.client.removeEventListener(ClientEvent.RECEIVE,this.onJSON);
         this.client.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      public function updatePortalURI(param1:String) : void
      {
         this.client.connect(param1,443);
      }
      
      public function updatePortalData(param1:String, param2:String) : void
      {
         if(HoermannRemote.appData != null && HoermannRemote.appData.portalData != null)
         {
            if(param1 == null)
            {
               param1 = HoermannRemote.appData.portalData.deviceId;
            }
            if(param2 == null)
            {
               param2 = HoermannRemote.appData.portalData.password;
            }
         }
         if(param1 == null || param2 == null)
         {
            return;
         }
         this.auth = HTTPClient.createBasicAuth(param1,param2);
         this.deviceId = param1;
      }
      
      public function send(param1:String, param2:URLVariables = null) : void
      {
         if(!param2)
         {
            param2 = new URLVariables();
         }
         this.client.httpAuthentication = this.auth;
         param2[Portal.VAR_DEVICE_ID] = this.deviceId;
         param2[Portal.VAR_COMMAND] = param1;
         this.client.sendVars(param2);
      }
      
      private function onJSON(param1:ClientEvent) : void
      {
         var json:Object = null;
         var data:String = null;
         var event:ClientEvent = param1;
         if(event.data != null)
         {
            event.data.position = 0;
            try
            {
               data = event.data.readUTFBytes(event.data.bytesAvailable);
               json = JSON.parse(data);
            }
            catch(error:Error)
            {
               event.data.position = 0;
               Log.warning("can not parse json from:\n\t" + event.data.readUTFBytes(event.data.bytesAvailable));
            }
         }
         dispatchEvent(new PortalRequestEvent(json,PortalRequestEvent.COMPLETE));
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new PortalRequestEvent(null,PortalRequestEvent.FAILED));
      }
   }
}
