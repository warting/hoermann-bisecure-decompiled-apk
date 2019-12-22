package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysStateContext;
   import com.isisic.remote.hoermann.views.gateways.loading.local.LoadLocalStateContext;
   import com.isisic.remote.hoermann.views.gateways.loading.portal.appPortal.LoadAppPortalStateContext;
   import com.isisic.remote.lw.IDisposable;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class AdvancedGatewayProvider extends EventDispatcher implements IDisposable
   {
      
      public static var lastInstance:AdvancedGatewayProvider;
       
      
      [Bindable("scanActiveChanged")]
      private var _scanActive:Boolean = false;
      
      private var _339742651dataProvider:ArrayCollection;
      
      private var _enableProviderUpdate:Boolean = true;
      
      private var loadLocalContext:LoadLocalStateContext;
      
      private var loadPortalContext:LoadGatewaysStateContext;
      
      public function AdvancedGatewayProvider()
      {
         super();
         lastInstance = this;
         this.initProvider();
         this.update();
      }
      
      public static function onlyLocalGatewaysFilter(param1:Object) : Boolean
      {
         return param1.localIp != null && param1.localIp != "" && param1.localPort != null;
      }
      
      public function set scanActive(param1:Boolean) : void
      {
         if(this._scanActive == param1)
         {
            return;
         }
         this._scanActive = param1;
         dispatchEvent(new Event("scanActiveChanged"));
      }
      
      public function get scanActive() : Boolean
      {
         return this._scanActive;
      }
      
      public function get enableProviderUpdate() : Boolean
      {
         return this._enableProviderUpdate;
      }
      
      public function set enableProviderUpdate(param1:Boolean) : void
      {
         this._enableProviderUpdate = param1;
         if(this.loadLocalContext != null && this.loadLocalContext.scanFinished && this.loadPortalContext != null && this.loadPortalContext.scanFinished && this.enableProviderUpdate)
         {
            this.updateProvider();
         }
      }
      
      private function initProvider() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in HoermannRemote.appData.gateways)
         {
            _loc1_.available = false;
         }
         this.dataProvider = new ArrayCollection(HoermannRemote.appData.gateways);
      }
      
      public function update() : void
      {
         this.scanActive = true;
         if(this.loadLocalContext != null)
         {
            this.loadLocalContext.reset();
         }
         else
         {
            this.loadLocalContext = new LoadLocalStateContext();
            this.loadLocalContext.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         }
         if(this.loadPortalContext != null)
         {
            this.loadPortalContext.reset();
         }
         else
         {
            this.loadPortalContext = new LoadAppPortalStateContext();
            this.loadPortalContext.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         }
      }
      
      public function dispose() : void
      {
         this.dataProvider.removeAll();
         this.dataProvider = null;
         if(this.loadLocalContext != null)
         {
            this.loadLocalContext.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
            this.loadLocalContext.dispose();
            this.loadLocalContext = null;
         }
         if(this.loadPortalContext != null)
         {
            this.loadPortalContext.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
            this.loadPortalContext.dispose();
            this.loadPortalContext = null;
         }
      }
      
      private function onLoadingComplete(param1:Event) : void
      {
         if(this.loadLocalContext.scanFinished && this.loadPortalContext.scanFinished)
         {
            this.scanActive = false;
            if(this.enableProviderUpdate)
            {
               this.updateProvider();
            }
         }
      }
      
      private function updateProvider() : void
      {
         var _loc1_:Gateway = null;
         var _loc2_:Gateway = null;
         this.dataProvider.removeAll();
         for each(_loc1_ in this.loadLocalContext.gatewayList)
         {
            this.addToProvider(_loc1_);
         }
         _loc1_ = null;
         for each(_loc2_ in this.loadPortalContext.gatewayList)
         {
            _loc1_ = ArrayHelper.findByProperty("mac",_loc2_.mac,this.dataProvider.toArray());
            if(_loc1_ != null && _loc1_.available == false && _loc2_.available == true)
            {
               this.addToProvider(_loc2_,this.dataProvider.getItemIndex(_loc1_));
            }
            else if(_loc1_ == null)
            {
               this.addToProvider(_loc2_);
            }
         }
         HoermannRemote.appData.gateways = this.dataProvider.toArray();
         HoermannRemote.appData.save();
         this.dataProvider.refresh();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function addToProvider(param1:Gateway, param2:int = -1) : void
      {
         this.updateGateway(param1);
         if(param2 < 0)
         {
            this.dataProvider.addItem(param1);
         }
         else
         {
            this.dataProvider.setItemAt(param1,param2);
         }
      }
      
      public function updateGateway(param1:Gateway) : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc4_:Gateway = null;
         var _loc2_:Object = ArrayHelper.findByProperty("mac",param1.mac,HoermannRemote.appData.gateways);
         if(_loc2_ != null)
         {
            _loc3_ = new <String>["available","name","isPortal","host","port"];
            _loc4_ = new Gateway();
            _loc4_.parseObject(_loc2_);
            if(param1.localIp != null && param1.localIp != "")
            {
               _loc3_.push("localIp");
               _loc3_.push("localPort");
            }
            _loc4_.copy(param1,_loc3_);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dataProvider() : ArrayCollection
      {
         return this._339742651dataProvider;
      }
      
      public function set dataProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._339742651dataProvider;
         if(_loc2_ !== param1)
         {
            this._339742651dataProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataProvider",_loc2_,param1));
            }
         }
      }
   }
}
