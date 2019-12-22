package com.isisic.remote.hoermann.net.portal
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.Portal;
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PortalCommunicator extends EventDispatcher
   {
      
      protected static var singleton:PortalCommunicator;
       
      
      public function PortalCommunicator(param1:SingletonEnforcer#133)
      {
         super();
      }
      
      public static function get defaultCommunicator() : PortalCommunicator
      {
         if(!singleton)
         {
            singleton = new PortalCommunicator(new SingletonEnforcer#133());
         }
         return singleton;
      }
      
      public function validatePortalData(param1:Object) : void
      {
         var data:Object = param1;
         var tag:Object = {
            "VALIDATOR":function(param1:Object):Boolean
            {
               if(param1 != null && param1.Gateways != null)
               {
                  dispatchEvent(new PortalDataValidateEvent(PortalDataValidateEvent.VALIDATED));
                  return true;
               }
               dispatchEvent(new PortalDataValidateEvent(PortalDataValidateEvent.AUTH_FAILED));
               return false;
            },
            "FAILED":new PortalDataValidateEvent(PortalDataValidateEvent.VALIDATION_FAILED)
         };
         var request:PortalRequest = this.createRequest(tag,Features.portalHostMeta,data);
         request.send(Portal.COMMAND_VALIDATE_DATA);
      }
      
      public function requestGateways() : void
      {
         var tag:Object = {
            "VALIDATOR":function(param1:Object):Boolean
            {
               var _loc3_:* = undefined;
               var _loc4_:* = undefined;
               Debug.debug("[PortalCommunicator] received gatewayList response");
               if(param1 == null || param1.Gateways == null)
               {
                  dispatchEvent(new PortalGatewayEvent(null,PortalGatewayEvent.LOADING_FAILED));
                  return false;
               }
               var _loc2_:* = new Array();
               for(_loc3_ in param1.Gateways)
               {
                  _loc4_ = new Object();
                  _loc4_.isPortal = true;
                  _loc4_.name = "Gateway " + _loc3_;
                  _loc4_.mac = param1.Gateways[_loc3_];
                  _loc4_.host = Features.portalHostCommunication;
                  _loc4_.port = 443;
                  _loc2_.push(_loc4_);
               }
               dispatchEvent(new PortalGatewayEvent(_loc2_,PortalGatewayEvent.LOADED));
               return true;
            },
            "FAILED":new PortalGatewayEvent(null,PortalGatewayEvent.LOADING_FAILED)
         };
         Debug.debug("[PortalCommunicator] Started Gateway Request");
         this.createRequest(tag,Features.portalHostMeta).send("");
      }
      
      public function requestStatus() : void
      {
         var tag:Object = {
            "VALIDATOR":function(param1:Object):Boolean
            {
               var _loc3_:* = undefined;
               var _loc4_:* = undefined;
               Debug.debug("[PortalCommunicator] received onlineStatus response");
               if(param1 == null || param1.Gatewaystatus == null)
               {
                  dispatchEvent(new PortalGatewayEvent(null,PortalGatewayEvent.LOADING_FAILED));
                  return false;
               }
               var _loc2_:* = new Array();
               for(_loc3_ in param1.Gatewaystatus)
               {
                  _loc4_ = new Object();
                  _loc4_.isPortal = true;
                  _loc4_.name = null;
                  _loc4_.mac = _loc3_;
                  _loc4_.host = Features.portalHostCommunication;
                  _loc4_.port = 443;
                  _loc4_.available = param1.Gatewaystatus[_loc3_] == "online"?true:false;
                  _loc2_.push(_loc4_);
               }
               dispatchEvent(new PortalGatewayEvent(_loc2_,PortalGatewayEvent.LOADED));
               return true;
            },
            "FAILED":new PortalGatewayEvent(null,PortalGatewayEvent.LOADING_FAILED)
         };
         Debug.debug("[PortalCommunicator] Started Status Request");
         this.createRequest(tag,Features.portalHostStatus).send("");
      }
      
      private function createRequest(param1:Object = null, param2:String = null, param3:Object = null) : PortalRequest
      {
         param2 = param2 != null?param2:Features.portalHostCommunication;
         param3 = param3 != null?param3:HoermannRemote.appData.portalData;
         var _loc4_:PortalRequest = new PortalRequest(param3,param2);
         _loc4_.tag = param1;
         _loc4_.addEventListener(PortalRequestEvent.COMPLETE,this.onRequestFinished);
         _loc4_.addEventListener(PortalRequestEvent.FAILED,this.onRequestFailed);
         return _loc4_;
      }
      
      private function destructRequest(param1:PortalRequest) : void
      {
         param1.removeEventListener(PortalRequestEvent.COMPLETE,this.onRequestFinished);
         param1.removeEventListener(PortalRequestEvent.FAILED,this.onRequestFailed);
         param1.destruct();
      }
      
      protected function onRequestFinished(param1:PortalRequestEvent) : void
      {
         var _loc2_:PortalRequest = param1.currentTarget as PortalRequest;
         if(_loc2_.tag != null && _loc2_.tag.VALIDATOR != null && _loc2_.tag.VALIDATOR is Function)
         {
            (_loc2_.tag.VALIDATOR as Function).call(this,param1.json);
         }
         this.destructRequest(_loc2_);
      }
      
      protected function onRequestFailed(param1:PortalRequestEvent) : void
      {
         var _loc2_:PortalRequest = param1.currentTarget as PortalRequest;
         if(_loc2_.tag != null && _loc2_.tag.FAILED != null && _loc2_.tag.FAILED is Event)
         {
            this.dispatchEvent(_loc2_.tag.FAILED);
         }
         this.destructRequest(_loc2_);
      }
   }
}

class SingletonEnforcer#133
{
    
   
   function SingletonEnforcer#133()
   {
      super();
   }
}
