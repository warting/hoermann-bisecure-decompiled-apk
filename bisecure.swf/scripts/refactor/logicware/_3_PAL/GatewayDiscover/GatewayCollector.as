package refactor.logicware._3_PAL.GatewayDiscover
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import refactor.logicware._3_PAL.GatewayDiscover.local.GatewayBroadcast;
   import refactor.logicware._3_PAL.GatewayDiscover.local.GatewayBroadcastEvent;
   import refactor.logicware._3_PAL.GatewayDiscover.remote.RemoteGatewayList;
   import refactor.logicware._3_PAL.GatewayDiscover.remote.RemoteGatewayListEntry;
   import refactor.logicware._5_UTIL.Log;
   
   public class GatewayCollector extends EventDispatcher
   {
      
      private static var singleton:GatewayCollector;
       
      
      private var localScanActive:Boolean;
      
      private var remoteScanActive:Boolean;
      
      private var gatewayList:GatewayList;
      
      public function GatewayCollector(param1:ConstructorLock#138)
      {
         super();
         this.localScanActive = false;
         this.remoteScanActive = false;
         this.gatewayList = new GatewayList();
      }
      
      public static function get collector() : GatewayCollector
      {
         if(singleton == null)
         {
            singleton = new GatewayCollector(null);
         }
         return singleton;
      }
      
      public function getArray() : Array
      {
         return this.gatewayList.toArray();
      }
      
      public function getVector() : Vector.<GatewayInfos>
      {
         return this.gatewayList.toVector();
      }
      
      public function findGateways(param1:String = null, param2:String = null, param3:Function = null) : void
      {
         var self:GatewayCollector = null;
         var completeHandler:Function = null;
         var clientId:String = param1;
         var password:String = param2;
         var callback:Function = param3;
         if(callback != null)
         {
            self = this;
            completeHandler = function(param1:Event):void
            {
               removeEventListener(Event.COMPLETE,completeHandler);
               callback(self);
            };
            addEventListener(Event.COMPLETE,completeHandler);
         }
         this.gatewayList.clearEntries();
         this.findLocal();
         if(clientId != null && password != null)
         {
            this.findRemote(clientId,password);
         }
      }
      
      private function findLocal() : void
      {
         this.localScanActive = true;
         this.local_AddListeners();
         if(!GatewayBroadcast.UDPBroadcast.discover())
         {
            Log.error("[GatewayCollector] GatewayBroadcast failed!");
            this.local_RemoveListeners();
         }
      }
      
      private function local_AddListeners() : void
      {
         var _loc1_:GatewayBroadcast = GatewayBroadcast.UDPBroadcast;
         _loc1_.addEventListener(GatewayBroadcastEvent.GATEWAY_FOUND,this.local_onGatewayFound);
         _loc1_.addEventListener(Event.COMPLETE,this.local_onComplete);
         _loc1_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.local_onError);
      }
      
      private function local_RemoveListeners() : void
      {
         var _loc1_:GatewayBroadcast = GatewayBroadcast.UDPBroadcast;
         _loc1_.removeEventListener(GatewayBroadcastEvent.GATEWAY_FOUND,this.local_onGatewayFound);
         _loc1_.removeEventListener(Event.COMPLETE,this.local_onComplete);
         _loc1_.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.local_onError);
      }
      
      private function local_onGatewayFound(param1:GatewayBroadcastEvent) : void
      {
         var _loc2_:GatewayInfos = this.gatewayList.getEntry(param1.gateway.mac);
         if(_loc2_ != null && _loc2_.isRemote == false)
         {
            return;
         }
         _loc2_ = new GatewayInfos();
         _loc2_.isRemote = false;
         _loc2_.isAvailable = true;
         _loc2_.gateway = param1.gateway;
         _loc2_.address = param1.srcAddress;
         this.gatewayList.setEntry(_loc2_);
      }
      
      private function local_onComplete(param1:Event) : void
      {
         this.local_RemoveListeners();
         this.localScanActive = false;
         this.notifyScanComplete();
      }
      
      private function local_onError(param1:IOErrorEvent) : void
      {
         this.local_RemoveListeners();
         this.localScanActive = false;
         this.notifyScanComplete();
      }
      
      private function findRemote(param1:String, param2:String) : void
      {
         var deviceId:String = param1;
         var password:String = param2;
         this.remoteScanActive = true;
         RemoteGatewayList.instance.requestGateways(deviceId,password,function(param1:RemoteGatewayList, param2:Boolean):void
         {
            var _loc3_:Vector.<RemoteGatewayListEntry> = null;
            var _loc4_:RemoteGatewayListEntry = null;
            var _loc5_:GatewayInfos = null;
            var _loc6_:GatewayInfos = null;
            if(param2)
            {
               _loc3_ = param1.gateways;
               for each(_loc4_ in _loc3_)
               {
                  _loc5_ = gatewayList.getEntry(_loc4_.gateway.mac);
                  if(_loc5_ == null)
                  {
                     _loc6_ = new GatewayInfos();
                     _loc6_.gateway = _loc4_.gateway;
                     _loc6_.isAvailable = _loc4_.isOnline;
                     _loc6_.isRemote = true;
                     _loc6_.address = null;
                     gatewayList.setEntry(_loc6_);
                  }
               }
            }
            remoteScanActive = false;
            notifyScanComplete();
         });
      }
      
      private function notifyScanComplete() : void
      {
         if(!this.localScanActive && !this.remoteScanActive)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}

import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;

class GatewayList
{
    
   
   public var entries:Object;
   
   function GatewayList()
   {
      this.entries = {};
      super();
   }
   
   public function toVector() : Vector.<GatewayInfos>
   {
      var _loc2_:GatewayInfos = null;
      var _loc1_:Vector.<GatewayInfos> = new Vector.<GatewayInfos>(0);
      for each(_loc2_ in this.entries)
      {
         _loc1_.push(_loc2_);
      }
      return _loc1_;
   }
   
   public function toArray() : Array
   {
      var _loc2_:GatewayInfos = null;
      var _loc1_:Array = [];
      for each(_loc2_ in this.entries)
      {
         _loc1_.push(_loc2_);
      }
      return _loc1_;
   }
   
   public function getEntry(param1:String) : GatewayInfos
   {
      return this.entries[param1];
   }
   
   public function setEntry(param1:GatewayInfos) : void
   {
      this.entries[param1.gateway.mac] = param1;
   }
   
   public function clearEntries() : void
   {
      this.entries = {};
   }
}

class ConstructorLock#138
{
    
   
   function ConstructorLock#138()
   {
      super();
   }
}
