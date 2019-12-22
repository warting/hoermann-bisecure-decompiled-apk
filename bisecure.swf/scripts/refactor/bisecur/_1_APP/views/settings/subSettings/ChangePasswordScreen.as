package refactor.bisecur._1_APP.views.settings.subSettings
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
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
   import refactor.bisecur._1_APP.components.overlays.screens.ChangePasswordScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.TextInput;
   import spark.components.View;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class ChangePasswordScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ChangePasswordScreen_Label1:Label;
      
      public var _ChangePasswordScreen_Label3:Label;
      
      public var _ChangePasswordScreen_Label4:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _117924854btnCancel:Button;
      
      private var _594113940btnSubmit:Button;
      
      private var _951530617content:SkinnableContainer;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _699101090newPasswd:TextInput;
      
      private var _934392851retype:TextInput;
      
      private var _265713450username:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChangePasswordScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ChangePasswordScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_settings_subSettings_ChangePasswordScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ChangePasswordScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangePasswordScreen_Array1_c);
         this.addEventListener("initialize",this.___ChangePasswordScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChangePasswordScreen._watcherSetupUtil = param1;
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
         this.username.text = AppCache.sharedCache.loggedInUser.name;
      }
      
      private function onSubmit(param1:MouseEvent) : void
      {
         var loadBox:LoadBox = null;
         var errorBox:ErrorBox = null;
         var event:MouseEvent = param1;
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         var error:String = null;
         if(!StringValidator.checkPasswd(this.newPasswd.text))
         {
            errorBox = ErrorBox.sharedBox;
            errorBox.title = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID");
            errorBox.contentText = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID_CONTENT");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         if(this.newPasswd.text != this.retype.text)
         {
            errorBox = ErrorBox.sharedBox;
            errorBox.title = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL");
            errorBox.contentText = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL_CONTENT");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         loadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("CHANGE_PWD_SETTING_PASSWORD");
         loadBox.contentText = Lang.getString("CHANGE_PWD_SETTING_PASSWORD_CONTENT");
         loadBox.open(null);
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createChangePassword(this.newPasswd.text,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:ErrorBox = null;
            if(param1.response == null)
            {
               if(HoermannRemote.loadBox.isOpen)
               {
                  HoermannRemote.loadBox.close();
               }
               InfoCenter.onNetTimeout();
               Log.warning("[ChangePasswordScreen] Requesting a password change failed! (NetTimeout)");
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               _loc2_ = ErrorBox.sharedBox;
               _loc2_.title = Lang.getString("CHANGE_PWD_PASSWORD_INVALID");
               _loc2_.contentText = Lang.getString("ERROR_CONNECTION_CLOSED_CONTENT");
               _loc2_.closeable = true;
               _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
               _loc2_.open(null);
               loadBox.close();
            }
            else if(param1.response.command == MCPCommands.CHANGE_PASSWD)
            {
               loadBox.close();
               navigator.popView();
            }
         });
      }
      
      private function onHelp() : void
      {
         new ChangePasswordScreenOverlay(this.username,this.newPasswd,this.retype,this.btnSubmit,this.btnCancel,this.bbar.callout).open(null);
      }
      
      private function _ChangePasswordScreen_Array1_c() : Array
      {
         var _loc1_:Array = [this._ChangePasswordScreen_GatewayDisplay1_i(),this._ChangePasswordScreen_SkinnableContainer1_i(),this._ChangePasswordScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _ChangePasswordScreen_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.layout = this._ChangePasswordScreen_VerticalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangePasswordScreen_Array2_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.paddingLeft = 20;
         _loc1_.paddingRight = 20;
         _loc1_.paddingTop = 20;
         _loc1_.paddingBottom = 20;
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._ChangePasswordScreen_HGroup1_c(),this._ChangePasswordScreen_Spacer2_c(),this._ChangePasswordScreen_Label3_i(),this._ChangePasswordScreen_TextInput1_i(),this._ChangePasswordScreen_Spacer3_c(),this._ChangePasswordScreen_Label4_i(),this._ChangePasswordScreen_TextInput2_i(),this._ChangePasswordScreen_Spacer4_c(),this._ChangePasswordScreen_HGroup2_c()];
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._ChangePasswordScreen_Label1_i(),this._ChangePasswordScreen_Spacer1_c(),this._ChangePasswordScreen_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_ChangePasswordScreen_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangePasswordScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ChangePasswordScreen_Label1",this._ChangePasswordScreen_Label1);
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.width = 10;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "username";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.username = _loc1_;
         BindingManager.executeBindings(this,"username",this.username);
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Spacer2_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_ChangePasswordScreen_Label3";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangePasswordScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_ChangePasswordScreen_Label3",this._ChangePasswordScreen_Label3);
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.maxChars = 10;
         _loc1_.displayAsPassword = true;
         _loc1_.percentWidth = 100;
         _loc1_.returnKeyLabel = "next";
         _loc1_.addEventListener("enter",this.__newPasswd_enter);
         _loc1_.id = "newPasswd";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.newPasswd = _loc1_;
         BindingManager.executeBindings(this,"newPasswd",this.newPasswd);
         return _loc1_;
      }
      
      public function __newPasswd_enter(param1:FlexEvent) : void
      {
         stage.focus = this.retype;
      }
      
      private function _ChangePasswordScreen_Spacer3_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 10;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_ChangePasswordScreen_Label4";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangePasswordScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_ChangePasswordScreen_Label4",this._ChangePasswordScreen_Label4);
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_TextInput2_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.maxChars = 10;
         _loc1_.displayAsPassword = true;
         _loc1_.percentWidth = 100;
         _loc1_.returnKeyLabel = "done";
         _loc1_.addEventListener("enter",this.__retype_enter);
         _loc1_.id = "retype";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.retype = _loc1_;
         BindingManager.executeBindings(this,"retype",this.retype);
         return _loc1_;
      }
      
      public function __retype_enter(param1:FlexEvent) : void
      {
         stage.focus = null;
      }
      
      private function _ChangePasswordScreen_Spacer4_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._ChangePasswordScreen_Button1_i(),this._ChangePasswordScreen_Button2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangePasswordScreen_Button1_i() : Button
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
      
      private function _ChangePasswordScreen_Button2_i() : Button
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
      
      private function _ChangePasswordScreen_BottomBar1_i() : BottomBar
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
      
      public function ___ChangePasswordScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _ChangePasswordScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_CHANGE_PASSWORD");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return gwDisplay.height + 25;
         },null,"content.top");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("CHANGE_PWD_USERNAME");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_ChangePasswordScreen_Label1.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("CHANGE_PWD_NEW_PASSWORD");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_ChangePasswordScreen_Label3.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_RETYPE");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_ChangePasswordScreen_Label4.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_CANCEL");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnCancel.label");
         result[6] = new Binding(this,function():String
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
      
      [Bindable(event="propertyChange")]
      public function get newPasswd() : TextInput
      {
         return this._699101090newPasswd;
      }
      
      public function set newPasswd(param1:TextInput) : void
      {
         var _loc2_:Object = this._699101090newPasswd;
         if(_loc2_ !== param1)
         {
            this._699101090newPasswd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newPasswd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get retype() : TextInput
      {
         return this._934392851retype;
      }
      
      public function set retype(param1:TextInput) : void
      {
         var _loc2_:Object = this._934392851retype;
         if(_loc2_ !== param1)
         {
            this._934392851retype = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"retype",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get username() : Label
      {
         return this._265713450username;
      }
      
      public function set username(param1:Label) : void
      {
         var _loc2_:Object = this._265713450username;
         if(_loc2_ !== param1)
         {
            this._265713450username = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"username",_loc2_,param1));
            }
         }
      }
   }
}
