package com.isisic.remote.hoermann.views.channels
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.ValueButton;
   import com.isisic.remote.hoermann.components.overlays.screens.ChannelScreenOverlay;
   import com.isisic.remote.hoermann.components.stateImages.StateImageBase;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.hoermann.global.UserDataStorage;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StateHelper;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.net.HmProcessorEvent;
   import com.isisic.remote.hoermann.net.HmTransition;
   import com.isisic.remote.hoermann.net.TransitionCollector;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.utils.ChangeWatcher;
   import mx.controls.Spacer;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.components.View;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class ChannelScreen extends View implements IBindingClient
   {
      
      public static const SET_STATE_TIMEOUT:int = 3000;
      
      public static const RELOAD_STATE_DELAY:int = 5000;
      
      public static const RELOAD_AUTO_CLOSE_DELAY:int = 5000;
      
      public static const SHOW_BUTTON_IDS:Boolean = false;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ChannelScreen_Spacer1:Spacer;
      
      public var _ChannelScreen_VGroup1:VGroup;
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _1781625235buttonGroup:VGroup;
      
      private var _951530617content:SkinnableContainer;
      
      private var _515659897contentMargin:Number;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _801844101lblState:Label;
      
      private var _870573222lblStateVal:Label;
      
      private var _249793426stateGroup:Group;
      
      private var _1002489247stateMargin:Number;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var timeoutTimer:Timer;
      
      private var watcher:ChangeWatcher;
      
      private var isSetState:Boolean = false;
      
      private var _248109238stateImage:StateImageBase;
      
      private var buttonList:Array;
      
      private var firstBtn:ValueButton;
      
      private var lastBtn:ValueButton;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChannelScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ChannelScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_channels_ChannelScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ChannelScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._ChannelScreen_Button1_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChannelScreen_Array2_c);
         this._ChannelScreen_Number1_i();
         this._ChannelScreen_Number2_i();
         this.addEventListener("initialize",this.___ChannelScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___ChannelScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChannelScreen._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function initComp() : void
      {
         if(!(this.data as HmGroup))
         {
            this.data = new HmGroup();
            this.navigator.popView();
            this.dispose();
         }
         HmProcessor.defaultProcessor.addEventListener(HmProcessorEvent.TRANSITION_LOADED,this.onTransitionLoaded);
         this.bbar.addEventListener(BottomBarEvent.REFRESH,this.onRefresh);
         this.bbar.addEventListener(BottomBarEvent.LOGOUT,this.onLogout);
         this.buttonGroup.enabled = !HoermannRemote.appData.activeConnection.processor.processing;
         this.watcher = ChangeWatcher.watch(HoermannRemote.appData.activeConnection.processor,"processing",this.onMcpProcessingChanged);
         this.createStateImage();
         this.createButtons();
         this.loadTransition();
      }
      
      [Bindable("dataChange")]
      private function get labelWidth() : Number
      {
         var _loc1_:Number = this.stateImage.imageRect.x + this.stateImage.imageRect.width;
         var _loc2_:Number = this.stateImage.width - _loc1_;
         var _loc3_:Number = _loc2_ * 2;
         return this.stateImage.width - this.stateImage.imageRect.width - _loc3_;
      }
      
      private function onComplete() : void
      {
         var box:Popup = null;
         var onBox:Function = null;
         box = InfoCenter.channelScreen(this.data as HmGroup);
         if(box != null)
         {
            box.addEventListener(PopUpEvent.CLOSE,onBox = function(param1:Event):void
            {
               box.removeEventListener(PopUpEvent.CLOSE,onBox);
            });
         }
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            showOverlay();
         });
         if(this.stateImage != null)
         {
            this.stateGroup.x = this.stateMargin + this.stateImage.outlineThickness;
         }
      }
      
      public function dispose() : void
      {
         HmProcessor.defaultProcessor.removeEventListener(HmProcessorEvent.TRANSITION_LOADED,this.onTransitionLoaded);
         this.bbar.removeEventListener(BottomBarEvent.REFRESH,this.onRefresh);
         this.bbar.removeEventListener(BottomBarEvent.LOGOUT,this.onLogout);
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
      
      private function onLogout(param1:BottomBarEvent) : void
      {
         this.dispose();
      }
      
      public function onRefresh(param1:BottomBarEvent) : void
      {
         this.loadTransition();
      }
      
      private function createStateImage() : void
      {
         if(this.stateImage != null)
         {
            this.stateGroup.removeElement(this.stateImage);
            this.stateImage.dispose();
            this.stateImage = null;
         }
         this.stateImage = StateHelper.getStateImage(this.data);
         var _loc1_:HmTransition = HmProcessor.defaultProcessor.transitions[data.id];
         var _loc2_:Number = this.lblState.measureText("Lerum").height + this.lblStateVal.measureText("Ipsum").height + 40;
         var _loc3_:Number = (this.stage.width - this.contentMargin * 2 - this.stateMargin * 2) * 0.15;
         if(MultiDevice.screenSize == ScreenSizes.XXLARGE)
         {
            _loc3_ = (this.stage.width - this.contentMargin * 2 - this.stateMargin * 2) * (50 / 116);
         }
         this.stateImage.groupId = data.id;
         this.stateImage.percentWidth = 100;
         this.stateImage.transition = _loc1_;
         this.stateImage.stateHeight = Math.max(_loc2_,_loc3_);
         this.stateGroup.addElement(this.stateImage);
      }
      
      private function showOverlay() : void
      {
         var _loc1_:Label = null;
         if(this.lblStateVal && this.lblStateVal.text != null && this.lblStateVal.text != "")
         {
            _loc1_ = this.lblStateVal as Label;
         }
         new ChannelScreenOverlay(this.btnBack,_loc1_ as IVisualElement,this.stateImage.imageRect,this.bbar.callout,this.firstBtn,this.lastBtn).open(null);
      }
      
      private function onMcpProcessingChanged(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(HoermannRemote.appData == null || HoermannRemote.appData.activeConnection == null || HoermannRemote.appData.activeConnection.processor == null)
         {
            Popup.closeAll();
         }
         this.buttonGroup.enabled = !HoermannRemote.appData.activeConnection.processor.processing;
         if(HoermannRemote.appData.activeConnection.processor.processing)
         {
            _loc2_ = Lang.getString("STATE_COLLECTING");
            _loc3_ = Lang.getString("STATE_COLLECTING_CONTENT");
            if(this.isSetState)
            {
               _loc2_ = Lang.getString("POPUP_SETTING_STATE");
               _loc3_ = Lang.getString("POPUP_SETTING_STATE_CONTENT");
               this.isSetState = false;
            }
            HoermannRemote.loadBox.title = _loc2_;
            HoermannRemote.loadBox.contentText = _loc3_;
         }
         else
         {
            HoermannRemote.loadBox.close();
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
            HmProcessor.defaultProcessor.requestTransition(data.id,false,true);
            this.stateImage.transition = null;
         }
      }
      
      private function onTransitionLoaded(param1:HmProcessorEvent) : void
      {
         var _loc2_:HmProcessor = HmProcessor.defaultProcessor;
         var _loc3_:HmTransition = _loc2_.transitions[data.id];
         this.stateImage.transition = _loc3_;
         if(_loc3_ != null && _loc3_.autoClose)
         {
            this.loadTransition(RELOAD_AUTO_CLOSE_DELAY);
         }
         this.setupButtons();
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Bindable(event="dataChange")]
      private function get stateName() : String
      {
         return StateHelper.getStateLabel(this.data);
      }
      
      [Bindable(event="dataChange")]
      private function get stateValue() : String
      {
         return StateHelper.getStateValue(this.data);
      }
      
      private function setupButtons() : void
      {
         var _loc1_:ValueButton = null;
         for each(_loc1_ in this.buttonList)
         {
            StateHelper.setupControlButton(_loc1_,_loc1_.value,this.data);
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
         if(!this.data.ports || this.data.ports.length < 1)
         {
            return;
         }
         this.buttonList = new Array();
         var _loc1_:* = this.data.ports.length > 4;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.data.ports)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort(PortTypes.portArraySorting);
         this.firstBtn = ValueButton.fromPort(_loc2_[0],SHOW_BUTTON_IDS);
         this.firstBtn.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.firstBtn.percentWidth = 100;
         this.buttonGroup.addElement(this.firstBtn);
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
               _loc6_.gap = this.buttonGroup.gap;
               this.buttonGroup.addElement(_loc6_);
               _loc6_.addElement(_loc5_);
               _loc4_++;
               if(_loc4_ >= this.data.ports.length)
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
               this.buttonGroup.addElement(_loc5_);
               this.lastBtn = _loc5_;
               this.buttonList.push(_loc5_);
            }
            _loc4_++;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:MouseEvent = param1;
         if(!(event.currentTarget as ValueButton))
         {
            return;
         }
         var port:Object = event.currentTarget.value;
         var context:ConnectionContext = HoermannRemote.appData.activeConnection;
         if(!port)
         {
            Debug.error("[ChannelScreen] sending ChannelCommand failed! Unknown Value (" + event.currentTarget.value + ")");
            return;
         }
         this.isSetState = true;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            if(timeoutTimer)
            {
               timeoutTimer.reset();
            }
            switch(loader.data.command)
            {
               case Commands.ERROR:
                  if(!loader.data.payload || loader.data.payload.length < 1)
                  {
                     Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                     return;
                  }
                  loader.data.payload.position = 0;
                  _loc2_ = loader.data.payload.readUnsignedByte();
                  if(_loc2_ == Errors.ADAPTER_BUSY)
                  {
                     HoermannRemote.errorBox.title = Lang.getString("ERROR_ADAPTER_BUSY");
                     HoermannRemote.errorBox.contentText = Lang.getString("ERROR_ADAPTER_BUSY_CONTENT");
                     HoermannRemote.errorBox.closeable = true;
                     HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
                     HoermannRemote.errorBox.open(null);
                  }
                  break;
               case Commands.HM_GET_TRANSITION:
                  loader.data.payload.position = 0;
                  _loc3_ = TransitionCollector.parseHmTransition(loader.data.payload);
                  HmProcessor.defaultProcessor.transitions[data.id] = _loc3_;
                  stateImage.transition = _loc3_;
                  if(_loc3_ != null)
                  {
                     if(_loc3_.driveTime > 0)
                     {
                        loadTransition(_loc3_.driveTime * 1000);
                     }
                  }
                  else
                  {
                     loadTransition(RELOAD_STATE_DELAY);
                  }
            }
            setupButtons();
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         this.timeoutTimer = new Timer(SET_STATE_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
         this.timeoutTimer.start();
         loader.request(MCPBuilder.buildMCP(Commands.SET_STATE,MCPBuilder.payloadSetState(port.id,255)));
         UserDataStorage.currentStorage.setPortRequest(data.id,port.id);
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
         Debug.info("[ChannelScreen] setState response timeout");
      }
      
      private function _ChannelScreen_Number1_i() : Number
      {
         var _loc1_:Number = 25;
         this.contentMargin = _loc1_;
         BindingManager.executeBindings(this,"contentMargin",this.contentMargin);
         return _loc1_;
      }
      
      private function _ChannelScreen_Number2_i() : Number
      {
         var _loc1_:Number = 40;
         this.stateMargin = _loc1_;
         BindingManager.executeBindings(this,"stateMargin",this.stateMargin);
         return _loc1_;
      }
      
      private function _ChannelScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnBack_click);
         _loc1_.id = "btnBack";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnBack = _loc1_;
         BindingManager.executeBindings(this,"btnBack",this.btnBack);
         return _loc1_;
      }
      
      public function __btnBack_click(param1:MouseEvent) : void
      {
         this.dispose();
         this.navigator.popView();
      }
      
      private function _ChannelScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._ChannelScreen_GatewayDisplay1_i(),this._ChannelScreen_SkinnableContainer1_i(),this._ChannelScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _ChannelScreen_GatewayDisplay1_i() : GatewayDisplay
      {
         var _loc1_:GatewayDisplay = new GatewayDisplay();
         _loc1_.percentWidth = 100;
         _loc1_.id = "gwDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gwDisplay = _loc1_;
         BindingManager.executeBindings(this,"gwDisplay",this.gwDisplay);
         return _loc1_;
      }
      
      private function _ChannelScreen_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "channelContent";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChannelScreen_Array3_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _ChannelScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._ChannelScreen_Group1_i(),this._ChannelScreen_VGroup2_i(),this._ChannelScreen_Spacer1_i()];
         return _loc1_;
      }
      
      private function _ChannelScreen_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.mxmlContent = [this._ChannelScreen_VGroup1_i()];
         _loc1_.id = "stateGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.stateGroup = _loc1_;
         BindingManager.executeBindings(this,"stateGroup",this.stateGroup);
         return _loc1_;
      }
      
      private function _ChannelScreen_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.left = 0;
         _loc1_.top = 30;
         _loc1_.mxmlContent = [this._ChannelScreen_Label1_i(),this._ChannelScreen_Label2_i()];
         _loc1_.id = "_ChannelScreen_VGroup1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChannelScreen_VGroup1 = _loc1_;
         BindingManager.executeBindings(this,"_ChannelScreen_VGroup1",this._ChannelScreen_VGroup1);
         return _loc1_;
      }
      
      private function _ChannelScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "channelContentState";
         _loc1_.minWidth = 50;
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblState";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblState = _loc1_;
         BindingManager.executeBindings(this,"lblState",this.lblState);
         return _loc1_;
      }
      
      private function _ChannelScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "channelContentState";
         _loc1_.minWidth = 50;
         _loc1_.id = "lblStateVal";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblStateVal = _loc1_;
         BindingManager.executeBindings(this,"lblStateVal",this.lblStateVal);
         return _loc1_;
      }
      
      private function _ChannelScreen_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.left = 30;
         _loc1_.right = 30;
         _loc1_.gap = 15;
         _loc1_.percentWidth = 100;
         _loc1_.id = "buttonGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.buttonGroup = _loc1_;
         BindingManager.executeBindings(this,"buttonGroup",this.buttonGroup);
         return _loc1_;
      }
      
      private function _ChannelScreen_Spacer1_i() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.id = "_ChannelScreen_Spacer1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChannelScreen_Spacer1 = _loc1_;
         BindingManager.executeBindings(this,"_ChannelScreen_Spacer1",this._ChannelScreen_Spacer1);
         return _loc1_;
      }
      
      private function _ChannelScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
         _loc1_.showRefresh = true;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___ChannelScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___ChannelScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _ChannelScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = this.data.name;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,null,null,"content.left","contentMargin");
         result[3] = new Binding(this,null,null,"content.right","contentMargin");
         result[4] = new Binding(this,function():Object
         {
            return gwDisplay.height + contentMargin;
         },null,"content.top");
         result[5] = new Binding(this,null,null,"stateGroup.top","stateMargin");
         result[6] = new Binding(this,null,null,"stateGroup.left","stateMargin");
         result[7] = new Binding(this,null,null,"stateGroup.right","stateMargin");
         result[8] = new Binding(this,function():Object
         {
            return stateImage.imageRect.width;
         },null,"_ChannelScreen_VGroup1.right");
         result[9] = new Binding(this,function():Number
         {
            return labelWidth;
         },null,"_ChannelScreen_VGroup1.width");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = stateName;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblState.text");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = stateValue;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblStateVal.text");
         result[12] = new Binding(this,function():Object
         {
            return stateGroup.height + stateGroup.y + 30;
         },null,"buttonGroup.top");
         result[13] = new Binding(this,function():Number
         {
            return buttonGroup.height + buttonGroup.y + 30;
         },null,"_ChannelScreen_Spacer1.y");
         result[14] = new Binding(this,function():Boolean
         {
            return !HmProcessor.defaultProcessor.transitionCollectingActive;
         },null,"bbar.refreshEnabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bbar() : BottomBar
      {
         return this._3016817bbar;
      }
      
      public function set bbar(param1:BottomBar) : void
      {
         var _loc2_:Object = this._3016817bbar;
         if(_loc2_ !== param1)
         {
            this._3016817bbar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bbar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnBack() : Button
      {
         return this._205678947btnBack;
      }
      
      public function set btnBack(param1:Button) : void
      {
         var _loc2_:Object = this._205678947btnBack;
         if(_loc2_ !== param1)
         {
            this._205678947btnBack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnBack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonGroup() : VGroup
      {
         return this._1781625235buttonGroup;
      }
      
      public function set buttonGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._1781625235buttonGroup;
         if(_loc2_ !== param1)
         {
            this._1781625235buttonGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : SkinnableContainer
      {
         return this._951530617content;
      }
      
      public function set content(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contentMargin() : Number
      {
         return this._515659897contentMargin;
      }
      
      public function set contentMargin(param1:Number) : void
      {
         var _loc2_:Object = this._515659897contentMargin;
         if(_loc2_ !== param1)
         {
            this._515659897contentMargin = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentMargin",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gwDisplay() : GatewayDisplay
      {
         return this._1206766158gwDisplay;
      }
      
      public function set gwDisplay(param1:GatewayDisplay) : void
      {
         var _loc2_:Object = this._1206766158gwDisplay;
         if(_loc2_ !== param1)
         {
            this._1206766158gwDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gwDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblState() : Label
      {
         return this._801844101lblState;
      }
      
      public function set lblState(param1:Label) : void
      {
         var _loc2_:Object = this._801844101lblState;
         if(_loc2_ !== param1)
         {
            this._801844101lblState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblStateVal() : Label
      {
         return this._870573222lblStateVal;
      }
      
      public function set lblStateVal(param1:Label) : void
      {
         var _loc2_:Object = this._870573222lblStateVal;
         if(_loc2_ !== param1)
         {
            this._870573222lblStateVal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblStateVal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateGroup() : Group
      {
         return this._249793426stateGroup;
      }
      
      public function set stateGroup(param1:Group) : void
      {
         var _loc2_:Object = this._249793426stateGroup;
         if(_loc2_ !== param1)
         {
            this._249793426stateGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateMargin() : Number
      {
         return this._1002489247stateMargin;
      }
      
      public function set stateMargin(param1:Number) : void
      {
         var _loc2_:Object = this._1002489247stateMargin;
         if(_loc2_ !== param1)
         {
            this._1002489247stateMargin = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateMargin",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get stateImage() : StateImageBase
      {
         return this._248109238stateImage;
      }
      
      private function set stateImage(param1:StateImageBase) : void
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
   }
}
