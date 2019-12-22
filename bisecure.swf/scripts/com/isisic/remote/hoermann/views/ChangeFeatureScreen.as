package com.isisic.remote.hoermann.views
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.global.CustomFeatures;
   import com.isisic.remote.hoermann.global.Features;
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.ToggleSwitch;
   import spark.components.View;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalLayout;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class ChangeFeatureScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _170925955_ChangeFeatureScreen_ToggleSwitch1:ToggleSwitch;
      
      private var _1003737261_ChangeFeatureScreen_ToggleSwitch10:ToggleSwitch;
      
      private var _1003737260_ChangeFeatureScreen_ToggleSwitch11:ToggleSwitch;
      
      private var _1003737259_ChangeFeatureScreen_ToggleSwitch12:ToggleSwitch;
      
      private var _170925954_ChangeFeatureScreen_ToggleSwitch2:ToggleSwitch;
      
      private var _170925953_ChangeFeatureScreen_ToggleSwitch3:ToggleSwitch;
      
      private var _170925952_ChangeFeatureScreen_ToggleSwitch4:ToggleSwitch;
      
      private var _170925951_ChangeFeatureScreen_ToggleSwitch5:ToggleSwitch;
      
      private var _170925950_ChangeFeatureScreen_ToggleSwitch6:ToggleSwitch;
      
      private var _170925949_ChangeFeatureScreen_ToggleSwitch7:ToggleSwitch;
      
      private var _170925948_ChangeFeatureScreen_ToggleSwitch8:ToggleSwitch;
      
      private var _170925947_ChangeFeatureScreen_ToggleSwitch9:ToggleSwitch;
      
      private var _205678947btnBack:Button;
      
      private var _206185977btnSave:Button;
      
      private var _456459974honeypot:SkinnableContainer;
      
      private var _110532135toast:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var clickCounter:int = 0;
      
      private var clickTimer:Timer;
      
      private var _814944087showChannelOnButton:Boolean;
      
      private var _487021296presenterVersion:Boolean;
      
      private var _1498672216scenarioHotfix:Boolean;
      
      private var _383743770useDevPortal:Boolean;
      
      private var _1057611171addDevicePortal:Boolean;
      
      private var _1892751976enableDdns:Boolean;
      
      private var _1067401910traceIn:Boolean;
      
      private var _1270285257traceOut:Boolean;
      
      private var _661495372writeDebug:Boolean;
      
      private var _1406654163writeInfo:Boolean;
      
      private var _459135299writeWarning:Boolean;
      
      private var _660169367writeError:Boolean;
      
      private var _embed_mxml__com_isisic_remote_hoermann_assets_images_logos_nothing_to_see_jpg_829832024:Class;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChangeFeatureScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._embed_mxml__com_isisic_remote_hoermann_assets_images_logos_nothing_to_see_jpg_829832024 = ChangeFeatureScreen__embed_mxml__com_isisic_remote_hoermann_assets_images_logos_nothing_to_see_jpg_829832024;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ChangeFeatureScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_ChangeFeatureScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ChangeFeatureScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.title = "";
         this.navigationContent = [this._ChangeFeatureScreen_Button1_i()];
         this.actionContent = [this._ChangeFeatureScreen_Button2_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array3_c);
         this.addEventListener("initialize",this.___ChangeFeatureScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChangeFeatureScreen._watcherSetupUtil = param1;
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
      
      private function onInit() : void
      {
         this.showChannelOnButton = Features.showChannelOnButton;
         this.presenterVersion = Features.presenterVersion;
         this.scenarioHotfix = Features.scenarioHotfix;
         this.addDevicePortal = Features.addDevicePortal;
         this.useDevPortal = Features.useDevPortal;
         this.enableDdns = Features.enableDdnsDialog;
         this.traceIn = Features.traceIn;
         this.traceOut = Features.traceOut;
         this.writeDebug = Features.writeDebug;
         this.writeInfo = Features.writeInfo;
         this.writeWarning = Features.writeWarning;
         this.writeError = Features.writeError;
      }
      
      private function onHoneypotClick(param1:Event) : void
      {
         if(this.clickTimer == null)
         {
            this.clickTimer = new Timer(300,1);
            this.clickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onClickTimeout);
         }
         else
         {
            this.clickTimer.reset();
         }
         this.clickCounter++;
         if(this.clickCounter >= 10)
         {
            this.honeypot.visible = false;
            this.btnSave.visible = true;
         }
         this.clickTimer.start();
      }
      
      private function onClickTimeout(param1:Event) : void
      {
         this.clickCounter = 0;
         this.clickTimer.reset();
      }
      
      private function onSave() : void
      {
         Features.showChannelOnButton = this.showChannelOnButton;
         Features.presenterVersion = this.presenterVersion;
         Features.scenarioHotfix = this.scenarioHotfix;
         Features.addDevicePortal = this.addDevicePortal;
         Features.useDevPortal = this.useDevPortal;
         Features.enableDdnsDialog = this.enableDdns;
         Features.traceIn = this.traceIn;
         Features.traceOut = this.traceOut;
         Features.writeDebug = this.writeDebug;
         Features.writeInfo = this.writeInfo;
         Features.writeWarning = this.writeWarning;
         Features.writeError = this.writeError;
         new CustomFeatures().load().write().dispose();
         this.showToast("done...    Please restart!");
      }
      
      private function showToast(param1:String, param2:Number = 1500) : void
      {
         var text:String = param1;
         var time:Number = param2;
         this.toast.text = text;
         this.toast.visible = true;
         new AutoDisposeTimer(time,function(param1:TimerEvent):void
         {
            toast.text = "";
            toast.visible = false;
         }).start();
      }
      
      private function _ChangeFeatureScreen_Button1_i() : Button
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
         this.navigator.popView();
      }
      
      private function _ChangeFeatureScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "SAVE";
         _loc1_.visible = false;
         _loc1_.addEventListener("click",this.__btnSave_click);
         _loc1_.id = "btnSave";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnSave = _loc1_;
         BindingManager.executeBindings(this,"btnSave",this.btnSave);
         return _loc1_;
      }
      
      public function __btnSave_click(param1:MouseEvent) : void
      {
         this.onSave();
      }
      
      private function _ChangeFeatureScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Scroller1_c(),this._ChangeFeatureScreen_Label13_i(),this._ChangeFeatureScreen_SkinnableContainer13_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.viewport = this._ChangeFeatureScreen_Group1_c();
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.layout = this._ChangeFeatureScreen_VerticalLayout1_c();
         _loc1_.mxmlContent = [this._ChangeFeatureScreen_SkinnableContainer1_c(),this._ChangeFeatureScreen_SkinnableContainer2_c(),this._ChangeFeatureScreen_SkinnableContainer3_c(),this._ChangeFeatureScreen_SkinnableContainer4_c(),this._ChangeFeatureScreen_SkinnableContainer5_c(),this._ChangeFeatureScreen_SkinnableContainer6_c(),this._ChangeFeatureScreen_SkinnableContainer7_c(),this._ChangeFeatureScreen_SkinnableContainer8_c(),this._ChangeFeatureScreen_SkinnableContainer9_c(),this._ChangeFeatureScreen_SkinnableContainer10_c(),this._ChangeFeatureScreen_SkinnableContainer11_c(),this._ChangeFeatureScreen_SkinnableContainer12_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.padding = 15;
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array5_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout1_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array5_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label1_c(),this._ChangeFeatureScreen_ToggleSwitch1_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label1_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Show Channels";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch1_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch1 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch1",this._ChangeFeatureScreen_ToggleSwitch1);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer2_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout2_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array6_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout2_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array6_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label2_c(),this._ChangeFeatureScreen_ToggleSwitch2_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label2_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Presenter Version";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch2_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch2 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch2",this._ChangeFeatureScreen_ToggleSwitch2);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer3_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout3_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array7_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.3);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout3_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array7_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label3_c(),this._ChangeFeatureScreen_ToggleSwitch3_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label3_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Szenario Hotfix aktivieren";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch3_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch3";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch3 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch3",this._ChangeFeatureScreen_ToggleSwitch3);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer4_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout4_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array8_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.4);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout4_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array8_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label4_c(),this._ChangeFeatureScreen_ToggleSwitch4_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label4_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Mit Dev Portal verbinden";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch4_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch4";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch4 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch4",this._ChangeFeatureScreen_ToggleSwitch4);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer5_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout5_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array9_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.5);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout5_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array9_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label5_c(),this._ChangeFeatureScreen_ToggleSwitch5_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label5_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Einlernen über Portal";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch5_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch5";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch5 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch5",this._ChangeFeatureScreen_ToggleSwitch5);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer6_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout6_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array10_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.6);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout6_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array10_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label6_c(),this._ChangeFeatureScreen_ToggleSwitch6_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label6_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "DDNS Dialog aktivieren";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch6_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch6";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch6 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch6",this._ChangeFeatureScreen_ToggleSwitch6);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer7_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout7_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array11_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.7);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout7_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array11_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label7_c(),this._ChangeFeatureScreen_ToggleSwitch7_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label7_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "RX MCP Packete loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch7_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch7";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch7 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch7",this._ChangeFeatureScreen_ToggleSwitch7);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer8_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout8_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array12_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.8);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout8_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array12_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label8_c(),this._ChangeFeatureScreen_ToggleSwitch8_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label8_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "TX MCP Packete loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch8_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch8";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch8 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch8",this._ChangeFeatureScreen_ToggleSwitch8);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer9_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout9_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array13_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",0.9);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout9_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array13_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label9_c(),this._ChangeFeatureScreen_ToggleSwitch9_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label9_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Debug-Meldungen loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch9_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch9";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch9 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch9",this._ChangeFeatureScreen_ToggleSwitch9);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer10_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout10_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array14_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout10_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array14_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label10_c(),this._ChangeFeatureScreen_ToggleSwitch10_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label10_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Info-Meldungen loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch10_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch10";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch10 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch10",this._ChangeFeatureScreen_ToggleSwitch10);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer11_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout11_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array15_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout11_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array15_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label11_c(),this._ChangeFeatureScreen_ToggleSwitch11_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label11_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Warning-Meldungen loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch11_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch11";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch11 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch11",this._ChangeFeatureScreen_ToggleSwitch11);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer12_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.layout = this._ChangeFeatureScreen_HorizontalLayout12_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array16_c);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.setStyle("backgroundAlpha",1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_HorizontalLayout12_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.padding = 5;
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array16_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_Label12_c(),this._ChangeFeatureScreen_ToggleSwitch12_i()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label12_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Error-Meldungen loggen";
         _loc1_.percentWidth = 100;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_ToggleSwitch12_i() : ToggleSwitch
      {
         var _loc1_:ToggleSwitch = new ToggleSwitch();
         _loc1_.id = "_ChangeFeatureScreen_ToggleSwitch12";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeFeatureScreen_ToggleSwitch12 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeFeatureScreen_ToggleSwitch12",this._ChangeFeatureScreen_ToggleSwitch12);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Label13_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("backgroundColor",8421504);
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "toast";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.toast = _loc1_;
         BindingManager.executeBindings(this,"toast",this.toast);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_SkinnableContainer13_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.layout = this._ChangeFeatureScreen_VerticalLayout2_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeFeatureScreen_Array17_c);
         _loc1_.setStyle("backgroundColor",14973);
         _loc1_.addEventListener("click",this.__honeypot_click);
         _loc1_.id = "honeypot";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.honeypot = _loc1_;
         BindingManager.executeBindings(this,"honeypot",this.honeypot);
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_VerticalLayout2_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_Array17_c() : Array
      {
         var _loc1_:Array = [this._ChangeFeatureScreen_BitmapImage1_c()];
         return _loc1_;
      }
      
      private function _ChangeFeatureScreen_BitmapImage1_c() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.percentWidth = 100;
         _loc1_.scaleMode = "letterbox";
         _loc1_.source = this._embed_mxml__com_isisic_remote_hoermann_assets_images_logos_nothing_to_see_jpg_829832024;
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      public function __honeypot_click(param1:MouseEvent) : void
      {
         this.onHoneypotClick(param1);
      }
      
      public function ___ChangeFeatureScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _ChangeFeatureScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[1] = new Binding(this,function():Boolean
         {
            return showChannelOnButton;
         },null,"_ChangeFeatureScreen_ToggleSwitch1.selected");
         result[2] = new Binding(this,function():Boolean
         {
            return presenterVersion;
         },null,"_ChangeFeatureScreen_ToggleSwitch2.selected");
         result[3] = new Binding(this,function():Boolean
         {
            return scenarioHotfix;
         },null,"_ChangeFeatureScreen_ToggleSwitch3.selected");
         result[4] = new Binding(this,function():Boolean
         {
            return useDevPortal;
         },null,"_ChangeFeatureScreen_ToggleSwitch4.selected");
         result[5] = new Binding(this,function():Boolean
         {
            return addDevicePortal;
         },null,"_ChangeFeatureScreen_ToggleSwitch5.selected");
         result[6] = new Binding(this,function():Boolean
         {
            return enableDdns;
         },null,"_ChangeFeatureScreen_ToggleSwitch6.selected");
         result[7] = new Binding(this,function():Boolean
         {
            return traceIn;
         },null,"_ChangeFeatureScreen_ToggleSwitch7.selected");
         result[8] = new Binding(this,function():Boolean
         {
            return traceOut;
         },null,"_ChangeFeatureScreen_ToggleSwitch8.selected");
         result[9] = new Binding(this,function():Boolean
         {
            return writeDebug;
         },null,"_ChangeFeatureScreen_ToggleSwitch9.selected");
         result[10] = new Binding(this,function():Boolean
         {
            return writeInfo;
         },null,"_ChangeFeatureScreen_ToggleSwitch10.selected");
         result[11] = new Binding(this,function():Boolean
         {
            return writeWarning;
         },null,"_ChangeFeatureScreen_ToggleSwitch11.selected");
         result[12] = new Binding(this,function():Boolean
         {
            return writeError;
         },null,"_ChangeFeatureScreen_ToggleSwitch12.selected");
         result[13] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch1.selected;
         },function(param1:*):void
         {
            showChannelOnButton = param1;
         },"showChannelOnButton");
         result[13].twoWayCounterpart = result[1];
         result[1].isTwoWayPrimary = true;
         result[1].twoWayCounterpart = result[13];
         result[14] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch2.selected;
         },function(param1:*):void
         {
            presenterVersion = param1;
         },"presenterVersion");
         result[14].twoWayCounterpart = result[2];
         result[2].isTwoWayPrimary = true;
         result[2].twoWayCounterpart = result[14];
         result[15] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch3.selected;
         },function(param1:*):void
         {
            scenarioHotfix = param1;
         },"scenarioHotfix");
         result[15].twoWayCounterpart = result[3];
         result[3].isTwoWayPrimary = true;
         result[3].twoWayCounterpart = result[15];
         result[16] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch4.selected;
         },function(param1:*):void
         {
            useDevPortal = param1;
         },"useDevPortal");
         result[16].twoWayCounterpart = result[4];
         result[4].isTwoWayPrimary = true;
         result[4].twoWayCounterpart = result[16];
         result[17] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch5.selected;
         },function(param1:*):void
         {
            addDevicePortal = param1;
         },"addDevicePortal");
         result[17].twoWayCounterpart = result[5];
         result[5].isTwoWayPrimary = true;
         result[5].twoWayCounterpart = result[17];
         result[18] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch6.selected;
         },function(param1:*):void
         {
            enableDdns = param1;
         },"enableDdns");
         result[18].twoWayCounterpart = result[6];
         result[6].isTwoWayPrimary = true;
         result[6].twoWayCounterpart = result[18];
         result[19] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch7.selected;
         },function(param1:*):void
         {
            traceIn = param1;
         },"traceIn");
         result[19].twoWayCounterpart = result[7];
         result[7].isTwoWayPrimary = true;
         result[7].twoWayCounterpart = result[19];
         result[20] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch8.selected;
         },function(param1:*):void
         {
            traceOut = param1;
         },"traceOut");
         result[20].twoWayCounterpart = result[8];
         result[8].isTwoWayPrimary = true;
         result[8].twoWayCounterpart = result[20];
         result[21] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch9.selected;
         },function(param1:*):void
         {
            writeDebug = param1;
         },"writeDebug");
         result[21].twoWayCounterpart = result[9];
         result[9].isTwoWayPrimary = true;
         result[9].twoWayCounterpart = result[21];
         result[22] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch10.selected;
         },function(param1:*):void
         {
            writeInfo = param1;
         },"writeInfo");
         result[22].twoWayCounterpart = result[10];
         result[10].isTwoWayPrimary = true;
         result[10].twoWayCounterpart = result[22];
         result[23] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch11.selected;
         },function(param1:*):void
         {
            writeWarning = param1;
         },"writeWarning");
         result[23].twoWayCounterpart = result[11];
         result[11].isTwoWayPrimary = true;
         result[11].twoWayCounterpart = result[23];
         result[24] = new Binding(this,function():*
         {
            return _ChangeFeatureScreen_ToggleSwitch12.selected;
         },function(param1:*):void
         {
            writeError = param1;
         },"writeError");
         result[24].twoWayCounterpart = result[12];
         result[12].isTwoWayPrimary = true;
         result[12].twoWayCounterpart = result[24];
         return result;
      }
      
      private function _ChangeFeatureScreen_bindingExprs() : void
      {
         this.showChannelOnButton = this._ChangeFeatureScreen_ToggleSwitch1.selected;
         this.presenterVersion = this._ChangeFeatureScreen_ToggleSwitch2.selected;
         this.scenarioHotfix = this._ChangeFeatureScreen_ToggleSwitch3.selected;
         this.useDevPortal = this._ChangeFeatureScreen_ToggleSwitch4.selected;
         this.addDevicePortal = this._ChangeFeatureScreen_ToggleSwitch5.selected;
         this.enableDdns = this._ChangeFeatureScreen_ToggleSwitch6.selected;
         this.traceIn = this._ChangeFeatureScreen_ToggleSwitch7.selected;
         this.traceOut = this._ChangeFeatureScreen_ToggleSwitch8.selected;
         this.writeDebug = this._ChangeFeatureScreen_ToggleSwitch9.selected;
         this.writeInfo = this._ChangeFeatureScreen_ToggleSwitch10.selected;
         this.writeWarning = this._ChangeFeatureScreen_ToggleSwitch11.selected;
         this.writeError = this._ChangeFeatureScreen_ToggleSwitch12.selected;
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch1() : ToggleSwitch
      {
         return this._170925955_ChangeFeatureScreen_ToggleSwitch1;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch1(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925955_ChangeFeatureScreen_ToggleSwitch1;
         if(_loc2_ !== param1)
         {
            this._170925955_ChangeFeatureScreen_ToggleSwitch1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch10() : ToggleSwitch
      {
         return this._1003737261_ChangeFeatureScreen_ToggleSwitch10;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch10(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._1003737261_ChangeFeatureScreen_ToggleSwitch10;
         if(_loc2_ !== param1)
         {
            this._1003737261_ChangeFeatureScreen_ToggleSwitch10 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch10",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch11() : ToggleSwitch
      {
         return this._1003737260_ChangeFeatureScreen_ToggleSwitch11;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch11(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._1003737260_ChangeFeatureScreen_ToggleSwitch11;
         if(_loc2_ !== param1)
         {
            this._1003737260_ChangeFeatureScreen_ToggleSwitch11 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch11",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch12() : ToggleSwitch
      {
         return this._1003737259_ChangeFeatureScreen_ToggleSwitch12;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch12(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._1003737259_ChangeFeatureScreen_ToggleSwitch12;
         if(_loc2_ !== param1)
         {
            this._1003737259_ChangeFeatureScreen_ToggleSwitch12 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch12",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch2() : ToggleSwitch
      {
         return this._170925954_ChangeFeatureScreen_ToggleSwitch2;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch2(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925954_ChangeFeatureScreen_ToggleSwitch2;
         if(_loc2_ !== param1)
         {
            this._170925954_ChangeFeatureScreen_ToggleSwitch2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch3() : ToggleSwitch
      {
         return this._170925953_ChangeFeatureScreen_ToggleSwitch3;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch3(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925953_ChangeFeatureScreen_ToggleSwitch3;
         if(_loc2_ !== param1)
         {
            this._170925953_ChangeFeatureScreen_ToggleSwitch3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch4() : ToggleSwitch
      {
         return this._170925952_ChangeFeatureScreen_ToggleSwitch4;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch4(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925952_ChangeFeatureScreen_ToggleSwitch4;
         if(_loc2_ !== param1)
         {
            this._170925952_ChangeFeatureScreen_ToggleSwitch4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch5() : ToggleSwitch
      {
         return this._170925951_ChangeFeatureScreen_ToggleSwitch5;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch5(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925951_ChangeFeatureScreen_ToggleSwitch5;
         if(_loc2_ !== param1)
         {
            this._170925951_ChangeFeatureScreen_ToggleSwitch5 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch5",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch6() : ToggleSwitch
      {
         return this._170925950_ChangeFeatureScreen_ToggleSwitch6;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch6(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925950_ChangeFeatureScreen_ToggleSwitch6;
         if(_loc2_ !== param1)
         {
            this._170925950_ChangeFeatureScreen_ToggleSwitch6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch7() : ToggleSwitch
      {
         return this._170925949_ChangeFeatureScreen_ToggleSwitch7;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch7(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925949_ChangeFeatureScreen_ToggleSwitch7;
         if(_loc2_ !== param1)
         {
            this._170925949_ChangeFeatureScreen_ToggleSwitch7 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch7",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch8() : ToggleSwitch
      {
         return this._170925948_ChangeFeatureScreen_ToggleSwitch8;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch8(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925948_ChangeFeatureScreen_ToggleSwitch8;
         if(_loc2_ !== param1)
         {
            this._170925948_ChangeFeatureScreen_ToggleSwitch8 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch8",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _ChangeFeatureScreen_ToggleSwitch9() : ToggleSwitch
      {
         return this._170925947_ChangeFeatureScreen_ToggleSwitch9;
      }
      
      public function set _ChangeFeatureScreen_ToggleSwitch9(param1:ToggleSwitch) : void
      {
         var _loc2_:Object = this._170925947_ChangeFeatureScreen_ToggleSwitch9;
         if(_loc2_ !== param1)
         {
            this._170925947_ChangeFeatureScreen_ToggleSwitch9 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ChangeFeatureScreen_ToggleSwitch9",_loc2_,param1));
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
      public function get btnSave() : Button
      {
         return this._206185977btnSave;
      }
      
      public function set btnSave(param1:Button) : void
      {
         var _loc2_:Object = this._206185977btnSave;
         if(_loc2_ !== param1)
         {
            this._206185977btnSave = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnSave",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get honeypot() : SkinnableContainer
      {
         return this._456459974honeypot;
      }
      
      public function set honeypot(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._456459974honeypot;
         if(_loc2_ !== param1)
         {
            this._456459974honeypot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"honeypot",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toast() : Label
      {
         return this._110532135toast;
      }
      
      public function set toast(param1:Label) : void
      {
         var _loc2_:Object = this._110532135toast;
         if(_loc2_ !== param1)
         {
            this._110532135toast = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toast",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showChannelOnButton() : Boolean
      {
         return this._814944087showChannelOnButton;
      }
      
      private function set showChannelOnButton(param1:Boolean) : void
      {
         var _loc2_:Object = this._814944087showChannelOnButton;
         if(_loc2_ !== param1)
         {
            this._814944087showChannelOnButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showChannelOnButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get presenterVersion() : Boolean
      {
         return this._487021296presenterVersion;
      }
      
      private function set presenterVersion(param1:Boolean) : void
      {
         var _loc2_:Object = this._487021296presenterVersion;
         if(_loc2_ !== param1)
         {
            this._487021296presenterVersion = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"presenterVersion",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get scenarioHotfix() : Boolean
      {
         return this._1498672216scenarioHotfix;
      }
      
      private function set scenarioHotfix(param1:Boolean) : void
      {
         var _loc2_:Object = this._1498672216scenarioHotfix;
         if(_loc2_ !== param1)
         {
            this._1498672216scenarioHotfix = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scenarioHotfix",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get useDevPortal() : Boolean
      {
         return this._383743770useDevPortal;
      }
      
      private function set useDevPortal(param1:Boolean) : void
      {
         var _loc2_:Object = this._383743770useDevPortal;
         if(_loc2_ !== param1)
         {
            this._383743770useDevPortal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useDevPortal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get addDevicePortal() : Boolean
      {
         return this._1057611171addDevicePortal;
      }
      
      private function set addDevicePortal(param1:Boolean) : void
      {
         var _loc2_:Object = this._1057611171addDevicePortal;
         if(_loc2_ !== param1)
         {
            this._1057611171addDevicePortal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addDevicePortal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get enableDdns() : Boolean
      {
         return this._1892751976enableDdns;
      }
      
      private function set enableDdns(param1:Boolean) : void
      {
         var _loc2_:Object = this._1892751976enableDdns;
         if(_loc2_ !== param1)
         {
            this._1892751976enableDdns = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableDdns",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get traceIn() : Boolean
      {
         return this._1067401910traceIn;
      }
      
      private function set traceIn(param1:Boolean) : void
      {
         var _loc2_:Object = this._1067401910traceIn;
         if(_loc2_ !== param1)
         {
            this._1067401910traceIn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"traceIn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get traceOut() : Boolean
      {
         return this._1270285257traceOut;
      }
      
      private function set traceOut(param1:Boolean) : void
      {
         var _loc2_:Object = this._1270285257traceOut;
         if(_loc2_ !== param1)
         {
            this._1270285257traceOut = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"traceOut",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get writeDebug() : Boolean
      {
         return this._661495372writeDebug;
      }
      
      private function set writeDebug(param1:Boolean) : void
      {
         var _loc2_:Object = this._661495372writeDebug;
         if(_loc2_ !== param1)
         {
            this._661495372writeDebug = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"writeDebug",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get writeInfo() : Boolean
      {
         return this._1406654163writeInfo;
      }
      
      private function set writeInfo(param1:Boolean) : void
      {
         var _loc2_:Object = this._1406654163writeInfo;
         if(_loc2_ !== param1)
         {
            this._1406654163writeInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"writeInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get writeWarning() : Boolean
      {
         return this._459135299writeWarning;
      }
      
      private function set writeWarning(param1:Boolean) : void
      {
         var _loc2_:Object = this._459135299writeWarning;
         if(_loc2_ !== param1)
         {
            this._459135299writeWarning = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"writeWarning",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get writeError() : Boolean
      {
         return this._660169367writeError;
      }
      
      private function set writeError(param1:Boolean) : void
      {
         var _loc2_:Object = this._660169367writeError;
         if(_loc2_ !== param1)
         {
            this._660169367writeError = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"writeError",_loc2_,param1));
            }
         }
      }
   }
}
