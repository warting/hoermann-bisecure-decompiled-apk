package com.isisic.remote.hoermann.net.portal
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.Portal;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.net.HTTPClient;
   import com.isisic.remote.lw.net.RawDataEvent;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   
   public class PortalRequest extends EventDispatcher
   {
       
      
      public var tag:Object;
      
      private var client:HTTPClient;
      
      private var auth:URLRequestHeader;
      
      private var deviceId:String;
      
      public function PortalRequest(param1:Object, param2:String = null)
      {
         super();
         if(!param2)
         {
            param2 = Features.portalHostMeta;
         }
         this.client = new HTTPClient();
         this.client.connect(param2,443);
         if(param2 == Features.portalHostMeta || param2 == Features.portalHostStatus)
         {
            this.client.receiveTMCP = false;
            this.client.idleTimeout = 5 * 1000;
         }
         this.client.addEventListener(RawDataEvent.DATA,this.onJSON);
         this.client.addEventListener(RawDataEvent.NO_DATA,this.onJSON);
         this.client.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this.updatePortalData(param1);
      }
      
      public function destruct() : void
      {
         this.client.removeEventListener(RawDataEvent.DATA,this.onJSON);
         this.client.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
      }
      
      public function updatePortalURI(param1:String) : void
      {
         this.client.connect(param1,443);
      }
      
      public function updatePortalData(param1:Object = null) : void
      {
         if(!param1)
         {
            param1 = HoermannRemote.appData.portalData;
         }
         if(!param1)
         {
            return;
         }
         this.auth = HTTPClient.createBasicAuth(param1.deviceId,param1.password);
         this.deviceId = param1.deviceId;
      }
      
      public function send(param1:String, param2:URLVariables = null) : void
      {
         if(!param2)
         {
            param2 = new URLVariables();
         }
         this.client.httpAutentication = this.auth;
         param2[Portal.VAR_DEVICE_ID] = this.deviceId;
         param2[Portal.VAR_COMMAND] = param1;
         this.client.sendVars(param2);
      }
      
      private function onJSON(param1:RawDataEvent) : void
      {
         var json:Object = null;
         var data:String = null;
         var event:RawDataEvent = param1;
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
               Debug.warning("can not parse json from:\n\t" + event.data.readUTFBytes(event.data.bytesAvailable));
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
