package refactor.bisecur._1_APP.views.gateways.renderer
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.GatewayDAO;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class GatewayRendererCtrl implements IDisposable, IEventDispatcher
   {
       
      
      private var _110371416title:String = "";
      
      private var _3208616host:String = "";
      
      private var _107855mac:String = "";
      
      private var _2105594551isEnabled:Boolean = true;
      
      public var renderer:GatewayRenderer;
      
      private var _3242771item:GatewayRendererItem;
      
      private var deleteChangeWatcher:ChangeWatcher;
      
      private var scanStateChangeWatcher:ChangeWatcher;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function GatewayRendererCtrl()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      private function get bindingsInitialized() : Boolean
      {
         return this.deleteChangeWatcher != null;
      }
      
      private function initBindings() : void
      {
         if(this.bindingsInitialized)
         {
            return;
         }
         this.deleteChangeWatcher = ChangeWatcher.watch(this.renderer.btnDelete,"visible",this.onDeleteVisibleChange,false,true);
         this.scanStateChangeWatcher = ChangeWatcher.watch(this.item.rendererState,"isRefreshing",this.onScanStateChanged,false,true);
         this.item.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChanged);
         this.renderer.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         this.onDeleteVisibleChange(null);
      }
      
      private function onItemChanged(param1:Event) : void
      {
         this.onData(this.item);
      }
      
      public function onData(param1:GatewayRendererItem) : void
      {
         this.item = param1;
         this.title = param1.gatewayInfos.gateway.name;
         if(param1.gatewayInfos.isRemote)
         {
            this.host = Lang.getString("GENERAL_PORTAL_SERVER");
         }
         else
         {
            this.host = param1.gatewayInfos.address;
         }
         this.mac = this.formatMac(param1.gatewayInfos.gateway.mac.toUpperCase());
         this.isEnabled = param1.gatewayInfos.isAvailable;
         this.initBindings();
      }
      
      public function onDelete() : void
      {
         var _loc1_:Gateway = this.item.gatewayInfos.gateway;
         var _loc2_:GatewayDAO = DAOFactory.getGatewayDAO();
         if(_loc2_.gatewayExists(_loc1_))
         {
            _loc2_.removeGateway(_loc1_);
         }
         Toast.show("Gatewaydaten wurden gelöscht!",Toast.DURATION_SHORT);
      }
      
      public function calculateUnscaledWidth(param1:Number) : Number
      {
         var _loc2_:Boolean = false;
         if(this.item != null)
         {
            _loc2_ = this.item.rendererState.editMode;
         }
         return param1 - (this.renderer.btnDelete.width + this.renderer.marginRight) * int(_loc2_);
      }
      
      public function dispose() : void
      {
         if(this.item)
         {
            this.item.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onItemChanged);
         }
         if(this.deleteChangeWatcher != null)
         {
            this.deleteChangeWatcher.unwatch();
            this.deleteChangeWatcher = null;
         }
         if(this.scanStateChangeWatcher != null)
         {
            this.scanStateChangeWatcher.unwatch();
            this.scanStateChangeWatcher = null;
         }
      }
      
      private function formatMac(param1:String) : String
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1.substr(_loc3_,2));
            _loc3_ = _loc3_ + 2;
         }
         return _loc2_.join(":");
      }
      
      private function onDeleteVisibleChange(param1:Event) : void
      {
         this.renderer.invalidateDisplayList();
      }
      
      private function onScanStateChanged(param1:Event) : void
      {
         if(this.item == null)
         {
            return;
         }
         this.renderer.setIcon(this.item.gatewayInfos,this.item.rendererState.isRefreshing);
         this.renderer.invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._110371416title;
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get host() : String
      {
         return this._3208616host;
      }
      
      public function set host(param1:String) : void
      {
         var _loc2_:Object = this._3208616host;
         if(_loc2_ !== param1)
         {
            this._3208616host = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"host",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mac() : String
      {
         return this._107855mac;
      }
      
      public function set mac(param1:String) : void
      {
         var _loc2_:Object = this._107855mac;
         if(_loc2_ !== param1)
         {
            this._107855mac = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mac",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isEnabled() : Boolean
      {
         return this._2105594551isEnabled;
      }
      
      public function set isEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._2105594551isEnabled;
         if(_loc2_ !== param1)
         {
            this._2105594551isEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : GatewayRendererItem
      {
         return this._3242771item;
      }
      
      public function set item(param1:GatewayRendererItem) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}
