package refactor.logicware._3_PAL.GatewayDiscover.remote
{
   import com.isisic.remote.hoermann.global.Features;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._5_UTIL.Log;
   
   public class RemoteGatewayList extends EventDispatcher
   {
      
      private static var singleton:RemoteGatewayList;
       
      
      private var _gateways:Vector.<RemoteGatewayListEntry>;
      
      public function RemoteGatewayList(param1:ConstructorLock#171)
      {
         super();
      }
      
      public static function get instance() : RemoteGatewayList
      {
         if(singleton == null)
         {
            singleton = new RemoteGatewayList(null);
         }
         return singleton;
      }
      
      public function get gateways() : Vector.<RemoteGatewayListEntry>
      {
         return this._gateways;
      }
      
      public function requestGateways(param1:String, param2:String, param3:Function = null) : void
      {
         var self:RemoteGatewayList = null;
         var completeHandler:Function = null;
         var errorHandler:Function = null;
         var deviceId:String = param1;
         var password:String = param2;
         var callback:Function = param3;
         this._gateways = null;
         if(callback != null)
         {
            self = this;
            completeHandler = function(param1:Event):void
            {
               removeEventListener(Event.COMPLETE,completeHandler);
               removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               callback(self,true);
            };
            errorHandler = function(param1:IOErrorEvent):void
            {
               removeEventListener(Event.COMPLETE,completeHandler);
               removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
               callback(self,false);
            };
            addEventListener(Event.COMPLETE,completeHandler);
            addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         }
         var tag:Object = {
            "VALIDATOR":function(param1:Object):Boolean
            {
               var _loc2_:* = undefined;
               var _loc3_:* = undefined;
               var _loc4_:* = undefined;
               Log.debug("[RemoteGatewayList] received gatewayList response");
               if(param1 == null || param1.Gatewaystatus == null)
               {
                  dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                  return false;
               }
               _gateways = new Vector.<RemoteGatewayListEntry>(0);
               for(_loc2_ in param1.Gatewaystatus)
               {
                  _loc3_ = new RemoteGatewayListEntry();
                  _loc4_ = new Gateway();
                  _loc4_.name = null;
                  _loc4_.mac = _loc2_;
                  _loc4_.protocolVersion = null;
                  _loc3_.gateway = _loc4_;
                  _loc3_.isOnline = param1.Gatewaystatus[_loc2_] == "online";
                  _gateways.push(_loc3_);
               }
               dispatchEvent(new Event(Event.COMPLETE));
               return true;
            },
            "FAILED":new IOErrorEvent(IOErrorEvent.IO_ERROR)
         };
         Log.debug("[RemoteGatewayList] Started Gateway Request");
         this.createRequest(tag,Features.portalHostStatus,deviceId,password).send("");
      }
      
      private function onReceive(param1:PortalRequestEvent) : void
      {
         var _loc2_:PortalRequest = param1.currentTarget as PortalRequest;
         if(_loc2_.tag != null && _loc2_.tag.VALIDATOR != null && _loc2_.tag.VALIDATOR is Function)
         {
            (_loc2_.tag.VALIDATOR as Function).call(this,param1.json);
         }
         this.disposeRequest(_loc2_);
      }
      
      private function onError(param1:PortalRequestEvent) : void
      {
         var _loc2_:PortalRequest = param1.currentTarget as PortalRequest;
         if(_loc2_.tag != null && _loc2_.tag.FAILED != null && _loc2_.tag.FAILED is Event)
         {
            this.dispatchEvent(_loc2_.tag.FAILED);
         }
         this.disposeRequest(_loc2_);
      }
      
      private function createRequest(param1:Object = null, param2:String = null, param3:String = null, param4:String = null) : PortalRequest
      {
         param2 = param2 != null?param2:Features.portalHostCommunication;
         if(HoermannRemote.appData != null && HoermannRemote.appData.portalData != null)
         {
            if(param3 == null)
            {
               param3 = HoermannRemote.appData.portalData.deviceId;
            }
            if(param4 == null)
            {
               param4 = HoermannRemote.appData.portalData.password;
            }
         }
         var _loc5_:PortalRequest = new PortalRequest(param3,param4,param2);
         _loc5_.tag = param1;
         _loc5_.addEventListener(PortalRequestEvent.COMPLETE,this.onReceive);
         _loc5_.addEventListener(PortalRequestEvent.FAILED,this.onError);
         return _loc5_;
      }
      
      private function disposeRequest(param1:PortalRequest) : void
      {
         param1.removeEventListener(PortalRequestEvent.COMPLETE,this.onReceive);
         param1.removeEventListener(PortalRequestEvent.FAILED,this.onError);
         param1.destruct();
      }
   }
}

class ConstructorLock#171
{
    
   
   function ConstructorLock#171()
   {
      super();
   }
}
