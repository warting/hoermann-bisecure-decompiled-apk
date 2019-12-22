package refactor.bisecur._1_APP.views.deviceList.renderer
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.stateImages.LightStateImage;
   import refactor.bisecur._1_APP.components.stateImages.StateImageBase;
   import refactor.bisecur._1_APP.skins.stateImage.TransparentStateImageSkin;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._5_UTIL.StateHelper;
   
   public class DeviceListRendererCtrl implements IEventDispatcher
   {
      
      private static const RERENDER_DELAY:int = 1000;
       
      
      private var _2420395Name:String = "";
      
      private var _1747769603StateLabel:String = "";
      
      private var _1757014912StateValue:String = "";
      
      [Bindable("StateTimeUpdated")]
      public var _StateTime:String = "";
      
      private var _248109238stateImage:StateImageBase;
      
      private var _3242771item:DeviceListRendererItem;
      
      public var view:DeviceListRenderer;
      
      private var editChangeWatcher:ChangeWatcher;
      
      private var refreshingChangeWatcher:ChangeWatcher;
      
      private var rerenderTimer:Timer;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function DeviceListRendererCtrl()
      {
         this.rerenderTimer = new Timer(RERENDER_DELAY);
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      [Bindable("StateTimeUpdated")]
      public function get StateTime() : String
      {
         return this._StateTime;
      }
      
      public function set StateTime(param1:String) : void
      {
         this._StateTime = param1;
         this.dispatchEvent(new Event("StateTimeUpdated"));
      }
      
      private function get bindingsInitialized() : Boolean
      {
         return this.editChangeWatcher != null && this.refreshingChangeWatcher != null;
      }
      
      private function initBindings() : void
      {
         if(this.bindingsInitialized)
         {
            return;
         }
         if(this.editChangeWatcher == null)
         {
            this.editChangeWatcher = ChangeWatcher.watch(this.view.btnEdit,"visible",this.onEditVisibleChange,false,true);
         }
         if(this.refreshingChangeWatcher == null && this.item != null)
         {
            this.refreshingChangeWatcher = ChangeWatcher.watch(this.item.rendererState,"isRefreshing",this.refreshingChanged);
            this.onEditVisibleChange(null);
         }
         this.view.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function onInit() : void
      {
         this.initBindings();
      }
      
      public function onCreationComplete() : void
      {
         this.onEditVisibleChange(null);
      }
      
      public function onData(param1:DeviceListRendererItem) : void
      {
         this.rerenderTimer.stop();
         this.rerenderTimer.reset();
         this.rerenderTimer.removeEventListener(TimerEvent.TIMER,this.updateStateLabels);
         if(param1 == null)
         {
            this.item = DeviceListRendererItem.create(new HmGroup());
         }
         else
         {
            this.item = param1;
            this.Name = param1.device.name;
            this.StateLabel = param1.device.state;
            this.StateValue = param1.device.stateValue;
            this.rerenderTimer.addEventListener(TimerEvent.TIMER,this.updateStateLabels);
            this.rerenderTimer.start();
         }
         if(this.item != null)
         {
            this.StateTime = StateHelper.getTransitionTime(this.item.device.id);
         }
         else
         {
            this.StateTime = "";
         }
         this.initBindings();
         this.updateStateimage();
         this.updateStateLabels();
      }
      
      private function updateStateLabels(param1:Event = null) : void
      {
         if(this.item == null)
         {
            this.StateLabel = "";
            this.StateValue = "";
            this.StateTime = "";
         }
         else
         {
            this.StateLabel = StateHelper.getStateLabel(this.item.device);
            this.StateValue = StateHelper.getStateValue(this.item.device);
            this.StateTime = StateHelper.getTransitionTime(this.item.device.id);
            if(this.stateImage.isRefreshing != this.item.rendererState.isRefreshing)
            {
            }
         }
      }
      
      private function updateStateimage() : void
      {
         var _loc1_:HmProcessor = null;
         var _loc2_:HmTransition = null;
         if(this.stateImage != null)
         {
            this.view.icon.removeElement(this.stateImage);
            this.stateImage.dispose();
            this.stateImage = null;
         }
         if(this.item != null)
         {
            this.stateImage = StateHelper.getStateImage(this.item.device);
            _loc1_ = AppCache.sharedCache.hmProcessor;
            _loc2_ = _loc1_.collector.transitions[this.item.device.id];
            this.stateImage.groupId = this.item.device.id;
            this.stateImage.percentWidth = 100;
            this.stateImage.stateHeight = this.view.preferedMinHeight * 0.8 - this.view.borderRadius * 2;
            this.stateImage.imageRectPaddingRight = 0;
            this.stateImage.transition = _loc2_;
            if(this.stateImage is LightStateImage)
            {
               this.stateImage.setStyle("skinClass",TransparentStateImageSkin);
            }
            this.view.icon.addElement(this.stateImage);
         }
      }
      
      private function onEditVisibleChange(param1:Event) : void
      {
         if(this.item.rendererState.editMode)
         {
            this.view.marginRight = this.view.marginLeft + this.view.btnEdit.width;
         }
         else
         {
            this.view.marginRight = this.view.marginLeft;
         }
         this.view.invalidateDisplayList();
      }
      
      public function refreshingChanged(param1:Event) : void
      {
         this.updateStateimage();
         this.updateStateLabels();
         this.view.invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function get Name() : String
      {
         return this._2420395Name;
      }
      
      public function set Name(param1:String) : void
      {
         var _loc2_:Object = this._2420395Name;
         if(_loc2_ !== param1)
         {
            this._2420395Name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Name",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get StateLabel() : String
      {
         return this._1747769603StateLabel;
      }
      
      public function set StateLabel(param1:String) : void
      {
         var _loc2_:Object = this._1747769603StateLabel;
         if(_loc2_ !== param1)
         {
            this._1747769603StateLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"StateLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get StateValue() : String
      {
         return this._1757014912StateValue;
      }
      
      public function set StateValue(param1:String) : void
      {
         var _loc2_:Object = this._1757014912StateValue;
         if(_loc2_ !== param1)
         {
            this._1757014912StateValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"StateValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateImage() : StateImageBase
      {
         return this._248109238stateImage;
      }
      
      public function set stateImage(param1:StateImageBase) : void
      {
         var _loc2_:Object = this._248109238stateImage;
         if(_loc2_ !== param1)
         {
            this._248109238stateImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : DeviceListRendererItem
      {
         return this._3242771item;
      }
      
      public function set item(param1:DeviceListRendererItem) : void
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
