package refactor.bisecur._1_APP.views.deviceList
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.DeviceListScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._1_APP.components.popups.group.AddGroupBox;
   import refactor.bisecur._1_APP.components.popups.group.EditGroupBox;
   import refactor.bisecur._1_APP.components.popups.group.LearnPortsBox;
   import refactor.bisecur._1_APP.views.deviceActions.DeviceActionsScreen;
   import refactor.bisecur._1_APP.views.deviceList.renderer.DeviceListRendererItem;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmProcessorEvent;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.bisecur._5_UTIL.StateHelper;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.LogicwareSettings;
   import spark.events.PopUpEvent;
   
   public class DeviceListScreenCtrl implements IDisposable, IEventDispatcher
   {
       
      
      public var Icon_Back:IVisualElement;
      
      public var Icon_Edit:IVisualElement;
      
      public var Icon_Add:IVisualElement;
      
      private var _80818744Title:String;
      
      private var _1177190458AddButtonHint:String;
      
      private var _96312495listProvider:ArrayCollection;
      
      public var view:DeviceListScreen;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function DeviceListScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this.Icon_Edit = MultiDevice.getFxg(ImgEdit);
         this.Icon_Add = MultiDevice.getFxg(ImgAdd);
         this._80818744Title = Lang.getString("ACTORS");
         this._1177190458AddButtonHint = Lang.getString("ACTORS_ADD_HELP");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.listProvider = new ArrayCollection();
      }
      
      [Bindable]
      public function get isEditVisible() : Boolean
      {
         return AppCache.sharedCache.loggedInUser.isAdmin;
      }
      
      [Bindable]
      public function get isEditEnabled() : Boolean
      {
         if(Features.addDevicePortal)
         {
            return true;
         }
         return !AppCache.sharedCache.connectedGateway.isRemote;
      }
      
      [Bindable("addButtonHelpVisible")]
      public function get addButtonHintVisible() : Boolean
      {
         return this.isEditVisible && this.isEditEnabled && this.listProvider.length <= 0;
      }
      
      [Bindable("refreshEnabledChange")]
      public function get isRefreshEnabled() : Boolean
      {
         return !AppCache.sharedCache.connection.isCommunicating;
      }
      
      public function dispose() : void
      {
         if(AppCache.sharedCache && AppCache.sharedCache.hmProcessor && AppCache.sharedCache.hmProcessor.collector)
         {
            AppCache.sharedCache.hmProcessor.collector.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionCollection_Change);
            AppCache.sharedCache.hmProcessor.collector.removeEventListener("processingChanged",this.onTransitionCollection_Change);
         }
         if(AppCache.sharedCache && AppCache.sharedCache.connection)
         {
            AppCache.sharedCache.connection.removeEventListener("isCommunicatingChanged",this.isCommunicating_Change);
         }
      }
      
      public function onInit() : void
      {
         var loadbox:LoadBox = null;
         var self:DeviceListScreenCtrl = null;
         loadbox = LoadBox.sharedBox;
         loadbox.title = Lang.getString("LOADING_GROUPS_TITLE");
         loadbox.contentText = Lang.getString("LOADING_GROUPS_CONTENT");
         loadbox.open(null);
         self = this;
         GatewayGroups.instance.getAll(function(param1:GatewayGroups, param2:Array, param3:Error):void
         {
            var _loc4_:HmGroup = null;
            for each(_loc4_ in param2)
            {
               listProvider.addItem(DeviceListRendererItem.create(_loc4_));
            }
            self.dispatchEvent(new Event("addButtonHelpVisible"));
            loadbox.close();
         });
      }
      
      private function onTransitionCollection_Change(param1:Event) : void
      {
         var _loc2_:* = AppCache.sharedCache.hmProcessor;
         DeviceListRendererItem.setIsRefreshing(AppCache.sharedCache.hmProcessor.collector.processing);
      }
      
      private function isCommunicating_Change(param1:Event) : void
      {
         this.dispatchEvent(new Event("refreshEnabledChange"));
      }
      
      public function onCreationComplete() : void
      {
         AppCache.sharedCache.hmProcessor.collector.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionCollection_Change);
         AppCache.sharedCache.hmProcessor.collector.addEventListener("processingChanged",this.onTransitionCollection_Change);
         AppCache.sharedCache.connection.addEventListener("isCommunicatingChanged",this.isCommunicating_Change);
      }
      
      public function onBack_Click() : void
      {
         this.view.navigator.popView();
      }
      
      public function onToggleEdit_Click() : void
      {
         var _loc1_:Boolean = DeviceListRendererItem.toggleEditMode();
         if(_loc1_)
         {
            this.view.btnEdit.setStyle("chromeAlpha",1);
         }
         else
         {
            this.view.btnEdit.setStyle("chromeAlpha",0);
         }
      }
      
      public function onAdd_Click() : void
      {
         var _loc1_:LoadBox = LoadBox.sharedBox;
         _loc1_.title = Lang.getString("CLEANING_PORTS");
         _loc1_.contentText = Lang.getString("CLEANING_PORTS_CONTENT");
         _loc1_.open(null);
         var _loc2_:PortCleaner = new PortCleaner(AppCache.sharedCache.connection);
         _loc2_.addEventListener(Event.COMPLETE,this.onPortsCleaned);
         _loc2_.searchDeadPorts();
      }
      
      private function onPortsCleaned(param1:Event) : void
      {
         var event:Event = param1;
         LoadBox.sharedBox.close();
         GatewayPorts.instance.getPortCount(function(param1:GatewayPorts, param2:int, param3:Error):void
         {
            var _loc5_:ErrorBox = null;
            if(param2 >= LogicwareSettings.MAX_PORTS)
            {
               _loc5_ = ErrorBox.sharedBox;
               _loc5_.title = Lang.getString("MAX_PORTS_REACHED");
               _loc5_.contentText = Lang.getString("MAX_PORTS_REACHED_CONTENT");
               _loc5_.closeable = true;
               _loc5_.closeTitle = Lang.getString("GENERAL_SUBMIT");
               _loc5_.open(null);
               return;
            }
            var _loc4_:AddGroupBox = new AddGroupBox();
            _loc4_.addEventListener(PopUpEvent.CLOSE,onGroupNameSelected);
            _loc4_.open(null);
         });
      }
      
      protected function onGroupNameSelected(param1:PopUpEvent) : void
      {
         var isRequestable:Boolean = false;
         var tmrEvent:Function = null;
         var tmr:Timer = null;
         var event:PopUpEvent = param1;
         (event.currentTarget as Popup).removeEventListener(PopUpEvent.CLOSE,this.onGroupNameSelected);
         if(!event.commit)
         {
            return;
         }
         isRequestable = (event.currentTarget as AddGroupBox).shouldRequest;
         var popup:LearnPortsBox = new LearnPortsBox(event.data,AppCache.sharedCache.connection,isRequestable);
         popup.addEventListener(PopUpEvent.CLOSE,this.onGroupAdded);
         popup.open(null);
         tmr = new Timer(20,1);
         tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmrEvent = function(param1:Event):void
         {
            tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmrEvent);
            InfoCenter.createGroup(event.data.type,isRequestable);
         });
         tmr.start();
      }
      
      protected function onGroupAdded(param1:PopUpEvent) : void
      {
         var event:PopUpEvent = param1;
         if(!event.commit)
         {
            return;
         }
         var hmGroup:HmGroup = HmGroup.fromObject(event.data);
         GatewayPorts.instance.invalidateCache();
         GatewayGroups.instance.invalidateCache();
         GatewayGroups.instance.getById(hmGroup.id,function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
         {
            if(param3 != null)
            {
               Log.error("[DeviceListScreen] reloading Groups failed!\n" + param3);
               return;
            }
            listProvider.addItem(DeviceListRendererItem.create(param2));
            dispatchEvent(new Event("addButtonHelpVisible"));
         });
         GatewayPorts.instance.getPortCount();
      }
      
      public function onActorSelect(param1:Event) : void
      {
         var rights:Array = null;
         var item:DeviceListRendererItem = null;
         var event:Event = param1;
         if(DeviceListRendererItem.getEditMode())
         {
            if(Features.presenterVersion)
            {
               Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
               return;
            }
            rights = [];
            for each(item in this.listProvider.toArray())
            {
               rights.push(item.device.id);
            }
            GatewayGroups.instance.getById(this.view.actorList.selectedItem.device.id,function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
            {
               if(param3 != null)
               {
                  InfoCenter.onNetTimeout();
                  return;
               }
               var _loc4_:EditGroupBox = new EditGroupBox(param2,AppCache.sharedCache.connection,rights);
               _loc4_.addEventListener(PopUpEvent.CLOSE,onGroupEdited);
               _loc4_.open(null);
            });
            event.preventDefault();
            return;
         }
         AppCache.sharedCache.hmProcessor.cancelCollecting([this.view.actorList.selectedItem.device.id]);
         this.view.navigator.pushView(DeviceActionsScreen,this.view.actorList.selectedItem.device);
      }
      
      protected function onGroupEdited(param1:PopUpEvent) : void
      {
         var _loc2_:DeviceListRendererItem = null;
         var _loc3_:DeviceListRendererItem = null;
         var _loc4_:DeviceListRendererItem = null;
         this.onToggleEdit_Click();
         if(param1.commit && param1.data != null)
         {
            for each(_loc2_ in this.listProvider.toArray())
            {
               if(_loc2_.device.id == param1.data.id)
               {
                  _loc2_.device = param1.data;
               }
            }
            this.onRefresh();
         }
         GatewayGroups.instance.invalidateCache();
         if(!param1.commit && param1.data != null)
         {
            _loc3_ = null;
            for each(_loc4_ in this.listProvider.toArray())
            {
               if(_loc4_.device.id == param1.data.id)
               {
                  _loc3_ = _loc4_;
                  break;
               }
            }
            this.listProvider.removeItem(_loc3_);
            this.onRefresh();
            GatewayGroups.instance.invalidateCache();
            GatewayGroups.instance.getAll();
            this.dispatchEvent(new Event("addButtonHelpVisible"));
         }
      }
      
      public function onRefresh() : void
      {
         var onCollectionComplete:Function = null;
         var handler:HmProcessor = null;
         handler = AppCache.sharedCache.hmProcessor;
         handler.addEventListener(HmProcessorEvent.TRANSITIONS_UPDATED,onCollectionComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            handler.removeEventListener(HmProcessorEvent.TRANSITIONS_UPDATED,onCollectionComplete);
            for each(_loc2_ in listProvider.toArray())
            {
               _loc2_.device.state = StateHelper.getStateLabel(_loc2_.device);
               _loc2_.device.stateValue = StateHelper.getStateValue(_loc2_.device);
            }
            listProvider.refresh();
         });
         handler.requestTransition();
      }
      
      public function onHelp() : void
      {
         new DeviceListScreenOverlay(this.view.btnBack,this.view.btnAdd,this.view.btnEdit,this.view.bbar.refresh,this.view.bbar.callout).open(null);
      }
      
      [Bindable(event="propertyChange")]
      public function get Title() : String
      {
         return this._80818744Title;
      }
      
      public function set Title(param1:String) : void
      {
         var _loc2_:Object = this._80818744Title;
         if(_loc2_ !== param1)
         {
            this._80818744Title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get AddButtonHint() : String
      {
         return this._1177190458AddButtonHint;
      }
      
      public function set AddButtonHint(param1:String) : void
      {
         var _loc2_:Object = this._1177190458AddButtonHint;
         if(_loc2_ !== param1)
         {
            this._1177190458AddButtonHint = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"AddButtonHint",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get listProvider() : ArrayCollection
      {
         return this._96312495listProvider;
      }
      
      public function set listProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._96312495listProvider;
         if(_loc2_ !== param1)
         {
            this._96312495listProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listProvider",_loc2_,param1));
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
