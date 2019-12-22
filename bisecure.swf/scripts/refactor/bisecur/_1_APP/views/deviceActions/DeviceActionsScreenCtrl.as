package refactor.bisecur._1_APP.views.deviceActions
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.components.ValueButton;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.binding.utils.ChangeWatcher;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.ChannelScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._1_APP.components.stateImages.StateImageBase;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.net.transitionCollecting.states.Parsing;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.bisecur._5_UTIL.StateHelper;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.events.PopUpEvent;
   
   public class DeviceActionsScreenCtrl implements IDisposable, IEventDispatcher
   {
      
      private static const REQUEST_OFFSET:int = 10000;
      
      private static const SET_STATE_TIMEOUT:int = 3000;
      
      private static const RELOAD_STATE_DELAY:int = 5000;
      
      private static const RELOAD_AUTO_CLOSE_DELAY:int = 5000;
      
      private static const SHOW_BUTTON_IDS:Boolean = false;
       
      
      public var Icon_Back:IVisualElement;
      
      private var _80818744Title:String = "";
      
      public var view:DeviceActionsScreen;
      
      private var timeoutTimer:Timer;
      
      private var watcher:ChangeWatcher;
      
      private var isSetState:Boolean = false;
      
      private var _248109238stateImage:StateImageBase;
      
      private var buttonList:Array;
      
      private var firstBtn:ValueButton;
      
      private var lastBtn:ValueButton;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function DeviceActionsScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      [Bindable("refreshEnabledChange")]
      public function get isRefreshEnabled() : Boolean
      {
         return !AppCache.sharedCache.connection.isCommunicating;
      }
      
      [Bindable("dataChange")]
      public function get labelWidth() : Number
      {
         var _loc1_:Number = this.stateImage.imageRect.x + this.stateImage.imageRect.width;
         var _loc2_:Number = this.stateImage.width - _loc1_;
         var _loc3_:Number = _loc2_ * 2;
         return this.stateImage.width - this.stateImage.imageRect.width - _loc3_;
      }
      
      public function get ownTransition() : HmTransition
      {
         var _loc1_:HmProcessor = AppCache.sharedCache.hmProcessor;
         return _loc1_.collector.transitions[this.view.data.id];
      }
      
      private function createStateImage() : void
      {
         if(this.stateImage != null)
         {
            this.view.stateGroup.removeElement(this.stateImage);
            this.stateImage.dispose();
            this.stateImage = null;
         }
         this.stateImage = StateHelper.getStateImage(this.view.data);
         var _loc1_:HmTransition = AppCache.sharedCache.hmProcessor.transitions[this.view.data.id];
         var _loc2_:Number = this.view.lblState.measureText("Lerum").height + this.view.lblStateVal.measureText("Ipsum").height + 40;
         var _loc3_:Number = (this.view.stage.width - this.view.contentMargin * 2 - this.view.stateMargin * 2) * 0.15;
         if(MultiDevice.screenSize == ScreenSizes.XXLARGE)
         {
            _loc3_ = (this.view.stage.width - this.view.contentMargin * 2 - this.view.stateMargin * 2) * (50 / 116);
         }
         this.stateImage.groupId = this.view.data.id;
         this.stateImage.percentWidth = 100;
         this.stateImage.transition = _loc1_;
         this.stateImage.stateHeight = Math.max(_loc2_,_loc3_);
         this.view.stateGroup.addElement(this.stateImage);
      }
      
      public function onInit() : void
      {
         if(!(this.view.data as HmGroup))
         {
            this.view.data = new HmGroup();
            this.view.navigator.popView();
            this.dispose();
         }
         this.Title = this.view.data.name;
         AppCache.sharedCache.hmProcessor.collector.addEventListener("processingChanged",this.onTransitionLoaded);
         AppCache.sharedCache.hmProcessor.collector.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionLoaded);
         AppCache.sharedCache.connection.addEventListener("isCommunicatingChanged",this.isCommunicating_Change);
         this.view.bbar.addEventListener(BottomBarEvent.REFRESH,this.onRefresh);
         this.view.bbar.addEventListener(BottomBarEvent.LOGOUT,this.onLogout);
         this.view.buttonGroup.enabled = !AppCache.sharedCache.connection.isCommunicating;
         this.createStateImage();
         this.createButtons();
         if(this.ownTransition != null)
         {
            if(new Date().time - this.ownTransition.time.time > REQUEST_OFFSET)
            {
               this.loadTransition();
            }
         }
      }
      
      public function dispose() : void
      {
         AppCache.sharedCache.hmProcessor.collector.removeEventListener("processingChanged",this.onTransitionLoaded);
         AppCache.sharedCache.hmProcessor.collector.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionLoaded);
         AppCache.sharedCache.connection.removeEventListener("isCommunicatingChanged",this.isCommunicating_Change);
         this.view.bbar.removeEventListener(BottomBarEvent.REFRESH,this.onRefresh);
         this.view.bbar.removeEventListener(BottomBarEvent.LOGOUT,this.onLogout);
         if(this.watcher)
         {
            this.watcher.unwatch();
            this.watcher = null;
         }
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.timeoutTimer = null;
         }
      }
      
      private function isCommunicating_Change(param1:Event) : void
      {
         this.dispatchEvent(new Event("refreshEnabledChange"));
         this.onMcpProcessingChanged(param1);
      }
      
      public function onCreationComplete() : void
      {
         var box:Popup = null;
         var onBox:Function = null;
         box = InfoCenter.channelScreen(this.view.data as HmGroup);
         if(box != null)
         {
            box.addEventListener(PopUpEvent.CLOSE,onBox = function(param1:Event):void
            {
               box.removeEventListener(PopUpEvent.CLOSE,onBox);
            });
         }
         this.view.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            onHelp();
         });
         if(this.stateImage != null)
         {
            this.view.stateGroup.x = this.view.stateMargin + this.stateImage.outlineThickness;
         }
      }
      
      public function onLogout(param1:BottomBarEvent) : void
      {
         this.dispose();
      }
      
      public function onRefresh(param1:BottomBarEvent) : void
      {
         this.loadTransition();
      }
      
      public function onHelp() : void
      {
         var _loc1_:Label = null;
         if(this.view.lblStateVal && this.view.lblStateVal.text != null && this.view.lblStateVal.text != "")
         {
            _loc1_ = this.view.lblStateVal as Label;
         }
         new ChannelScreenOverlay(this.view.btnBack,_loc1_ as IVisualElement,this.stateImage.imageRect,this.view.bbar.callout,this.firstBtn,this.lastBtn).open(null);
      }
      
      private function onMcpProcessingChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:LoadBox = null;
         if(AppCache.sharedCache || AppCache.sharedCache.connection == null || AppCache.sharedCache.hmProcessor == null)
         {
            LoadBox.sharedBox.close();
         }
         this.view.buttonGroup.enabled = !AppCache.sharedCache.connection.isCommunicating;
         if(AppCache.sharedCache.connection.isCommunicating)
         {
            _loc2_ = Lang.getString("STATE_COLLECTING");
            _loc3_ = Lang.getString("STATE_COLLECTING_CONTENT");
            if(this.isSetState)
            {
               _loc2_ = Lang.getString("POPUP_SETTING_STATE");
               _loc3_ = Lang.getString("POPUP_SETTING_STATE_CONTENT");
               this.isSetState = false;
            }
            _loc4_ = LoadBox.sharedBox;
            _loc4_.title = _loc2_;
            _loc4_.contentText = _loc3_;
         }
         else
         {
            LoadBox.sharedBox.close();
         }
      }
      
      private function loadTransition(param1:int = 0) : void
      {
         var delay:int = param1;
         if(delay > 0)
         {
            new AutoDisposeTimer(delay,function(param1:TimerEvent):void
            {
               loadTransition();
            }).start();
         }
         else
         {
            AppCache.sharedCache.hmProcessor.requestTransition(this.view.data.id,true);
            this.stateImage.transition = null;
         }
      }
      
      private function onTransitionLoaded(param1:Event) : void
      {
         var _loc2_:HmProcessor = AppCache.sharedCache.hmProcessor;
         var _loc3_:HmTransition = _loc2_.collector.transitions[this.view.data.id];
         Log.debug("Presenting Transition: " + _loc3_);
         this.stateImage.transition = _loc3_;
         if(_loc3_ != null && _loc3_.autoClose)
         {
            this.loadTransition(RELOAD_AUTO_CLOSE_DELAY);
         }
         this.setupButtons();
         this.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Bindable(event="dataChange")]
      public function get stateName() : String
      {
         return StateHelper.getStateLabel(this.view.data);
      }
      
      [Bindable(event="dataChange")]
      public function get stateValue() : String
      {
         return StateHelper.getStateValue(this.view.data);
      }
      
      private function setupButtons() : void
      {
         var _loc1_:ValueButton = null;
         for each(_loc1_ in this.buttonList)
         {
            StateHelper.setupControlButton(_loc1_,_loc1_.value,this.view.data);
            _loc1_.skin.invalidateDisplayList();
         }
      }
      
      private function createButtons() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:ValueButton = null;
         var _loc6_:HGroup = null;
         var _loc7_:ValueButton = null;
         if(!this.view.data.ports || this.view.data.ports.length < 1)
         {
            return;
         }
         this.buttonList = [];
         var _loc1_:* = this.view.data.ports.length > 4;
         var _loc2_:Array = [];
         for each(_loc3_ in this.view.data.ports)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort(PortTypes.portArraySorting);
         this.firstBtn = ValueButton.fromPort(_loc2_[0],SHOW_BUTTON_IDS);
         this.firstBtn.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.firstBtn.percentWidth = 100;
         this.view.buttonGroup.addElement(this.firstBtn);
         this.buttonList.push(this.firstBtn);
         _loc4_ = 1;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = ValueButton.fromPort(_loc2_[_loc4_],SHOW_BUTTON_IDS);
            _loc5_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            _loc5_.percentWidth = 100;
            if(_loc1_)
            {
               _loc6_ = new HGroup();
               _loc6_.percentWidth = 100;
               _loc6_.gap = this.view.buttonGroup.gap;
               this.view.buttonGroup.addElement(_loc6_);
               _loc6_.addElement(_loc5_);
               _loc4_++;
               if(_loc4_ >= this.view.data.ports.length)
               {
                  break;
               }
               _loc7_ = ValueButton.fromPort(_loc2_[_loc4_],SHOW_BUTTON_IDS);
               _loc7_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
               _loc7_.percentWidth = 100;
               _loc6_.addElement(_loc7_);
               this.lastBtn = _loc7_;
               this.buttonList.push(_loc5_);
               this.buttonList.push(_loc7_);
            }
            else
            {
               this.view.buttonGroup.addElement(_loc5_);
               this.lastBtn = _loc5_;
               this.buttonList.push(_loc5_);
            }
            _loc4_++;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         if(!(event.currentTarget as ValueButton))
         {
            return;
         }
         var port:Object = event.currentTarget.value;
         var context:ConnectionContext = AppCache.sharedCache.connection;
         if(!port)
         {
            Log.error("[ChannelScreen] sending ChannelCommand failed! Unknown Value (" + event.currentTarget.value + ")");
            return;
         }
         this.isSetState = true;
         this.timeoutTimer = new Timer(SET_STATE_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
         this.timeoutTimer.start();
         new MCPLoader(context).load(MCPBuilder.createSetState(port.id,255,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            var _loc3_:ErrorBox = null;
            var _loc4_:HmTransition = null;
            if(param1.response == null)
            {
               InfoCenter.onNetTimeout();
               return;
            }
            if(timeoutTimer)
            {
               timeoutTimer.reset();
            }
            switch(param1.response.command)
            {
               case MCPCommands.ERROR:
                  if(!param1.response.payload || param1.response.payload.length < 1)
                  {
                     Log.warning("[ChannelScreen] Received MCP.Error without payload!\n" + param1.response);
                     return;
                  }
                  _loc2_ = MCPErrors.getErrorFromPackage(param1.response);
                  InfoCenter.onMCPError(param1.response,_loc2_);
                  if(_loc2_ == MCPErrors.ADAPTER_BUSY)
                  {
                     _loc3_ = ErrorBox.sharedBox;
                     _loc3_.title = Lang.getString("ERROR_ADAPTER_BUSY");
                     _loc3_.contentText = Lang.getString("ERROR_ADAPTER_BUSY_CONTENT");
                     _loc3_.closeable = true;
                     _loc3_.closeTitle = Lang.getString("GENERAL_SUBMIT");
                     _loc3_.open(null);
                  }
                  break;
               case MCPCommands.HM_GET_TRANSITION:
                  param1.response.payload.position = 0;
                  _loc4_ = Parsing.parseHmTransition(param1.response.payload);
                  AppCache.sharedCache.hmProcessor.transitions[view.data.id] = _loc4_;
                  stateImage.transition = _loc4_;
                  if(_loc4_ != null)
                  {
                     if(_loc4_.driveTime > 0)
                     {
                        loadTransition(_loc4_.driveTime * 1000);
                     }
                  }
                  else
                  {
                     loadTransition(RELOAD_STATE_DELAY);
                  }
            }
            setupButtons();
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
         Log.info("[ChannelScreen] setState response timeout");
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
