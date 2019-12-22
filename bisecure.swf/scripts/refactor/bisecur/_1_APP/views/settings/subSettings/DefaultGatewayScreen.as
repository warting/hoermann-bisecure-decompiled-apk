package refactor.bisecur._1_APP.views.settings.subSettings
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.controls.Spacer;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.DefaultGatewayScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.dao.AppSettingDAO;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.UserLoginDAO;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.View;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class DefaultGatewayScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _DefaultGatewayScreen_Label1:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _117924854btnCancel:Button;
      
      private var _594113940btnSubmit:Button;
      
      private var _560068933chkDefault:CheckBox;
      
      private var _951530617content:SkinnableContainer;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var appSettings:AppSettingDAO;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DefaultGatewayScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._DefaultGatewayScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_settings_subSettings_DefaultGatewayScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DefaultGatewayScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._DefaultGatewayScreen_Array1_c);
         this.addEventListener("initialize",this.___DefaultGatewayScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DefaultGatewayScreen._watcherSetupUtil = param1;
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
         this.appSettings = DAOFactory.getAppSettingDAO();
         this.chkDefault.selected = this.isDefault;
      }
      
      private function onSubmit(param1:MouseEvent) : void
      {
         var _loc2_:UserLoginDAO = null;
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(this.chkDefault.selected)
         {
            this.appSettings.setDefaultGateway(AppCache.sharedCache.connectedGateway.gateway);
            _loc2_ = DAOFactory.getUserLoginDAO();
            _loc2_.setUser(AppCache.sharedCache.loggedInUser);
         }
         else
         {
            this.appSettings.setDefaultGateway(null);
         }
         this.navigator.popView();
      }
      
      private function get isDefault() : Boolean
      {
         var _loc1_:Gateway = this.appSettings.getDefaultGateway();
         if(_loc1_ == null)
         {
            return false;
         }
         return _loc1_.mac == AppCache.sharedCache.connectedGateway.gateway.mac;
      }
      
      private function onHelp() : void
      {
         new DefaultGatewayScreenOverlay(this.chkDefault,this.btnSubmit,this.btnCancel,this.bbar.callout).open(null);
      }
      
      private function _DefaultGatewayScreen_Array1_c() : Array
      {
         var _loc1_:Array = [this._DefaultGatewayScreen_GatewayDisplay1_i(),this._DefaultGatewayScreen_SkinnableContainer1_i(),this._DefaultGatewayScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _DefaultGatewayScreen_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.layout = this._DefaultGatewayScreen_VerticalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._DefaultGatewayScreen_Array2_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.paddingLeft = 20;
         _loc1_.paddingRight = 20;
         _loc1_.paddingTop = 20;
         _loc1_.paddingBottom = 20;
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._DefaultGatewayScreen_Label1_i(),this._DefaultGatewayScreen_Spacer1_c(),this._DefaultGatewayScreen_CheckBox1_i(),this._DefaultGatewayScreen_Spacer2_c(),this._DefaultGatewayScreen_HGroup1_c()];
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.height = 250;
         _loc1_.id = "_DefaultGatewayScreen_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DefaultGatewayScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_DefaultGatewayScreen_Label1",this._DefaultGatewayScreen_Label1);
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_CheckBox1_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.id = "chkDefault";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.chkDefault = _loc1_;
         BindingManager.executeBindings(this,"chkDefault",this.chkDefault);
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_Spacer2_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 10;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._DefaultGatewayScreen_Button1_i(),this._DefaultGatewayScreen_Button2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DefaultGatewayScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.percentWidth = 50;
         _loc1_.addEventListener("click",this.__btnCancel_click);
         _loc1_.id = "btnCancel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnCancel = _loc1_;
         BindingManager.executeBindings(this,"btnCancel",this.btnCancel);
         return _loc1_;
      }
      
      public function __btnCancel_click(param1:MouseEvent) : void
      {
         navigator.popView();
      }
      
      private function _DefaultGatewayScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.percentWidth = 50;
         _loc1_.addEventListener("click",this.__btnSubmit_click);
         _loc1_.id = "btnSubmit";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnSubmit = _loc1_;
         BindingManager.executeBindings(this,"btnSubmit",this.btnSubmit);
         return _loc1_;
      }
      
      public function __btnSubmit_click(param1:MouseEvent) : void
      {
         this.onSubmit(param1);
      }
      
      private function _DefaultGatewayScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
         _loc1_.addEventListener("BOTTOMBAR_HELP",this.__bbar_BOTTOMBAR_HELP);
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function __bbar_BOTTOMBAR_HELP(param1:BottomBarEvent) : void
      {
         this.onHelp();
      }
      
      public function ___DefaultGatewayScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _DefaultGatewayScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_SET_DEFAULT_GATEWAY");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return gwDisplay.height + 25;
         },null,"content.top");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_SET_DEFAULT_GATEWAY_CONTENT");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_DefaultGatewayScreen_Label1.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_DEFAULT_GATEWAY");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"chkDefault.label");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_CANCEL");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnCancel.label");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_SUBMIT");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnSubmit.label");
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
      public function get btnCancel() : Button
      {
         return this._117924854btnCancel;
      }
      
      public function set btnCancel(param1:Button) : void
      {
         var _loc2_:Object = this._117924854btnCancel;
         if(_loc2_ !== param1)
         {
            this._117924854btnCancel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCancel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnSubmit() : Button
      {
         return this._594113940btnSubmit;
      }
      
      public function set btnSubmit(param1:Button) : void
      {
         var _loc2_:Object = this._594113940btnSubmit;
         if(_loc2_ !== param1)
         {
            this._594113940btnSubmit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnSubmit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chkDefault() : CheckBox
      {
         return this._560068933chkDefault;
      }
      
      public function set chkDefault(param1:CheckBox) : void
      {
         var _loc2_:Object = this._560068933chkDefault;
         if(_loc2_ !== param1)
         {
            this._560068933chkDefault = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chkDefault",_loc2_,param1));
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
   }
}
