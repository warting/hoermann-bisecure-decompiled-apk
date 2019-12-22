package com.isisic.remote.hoermann.views.options.settings
{
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.overlays.screens.ChangeGatewayNameScreenOverlay;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
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
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.TextInput;
   import spark.components.View;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class ChangeGatewayName extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ChangeGatewayName_Label1:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _117924854btnCancel:Button;
      
      private var _594113940btnSubmit:Button;
      
      private var _951530617content:SkinnableContainer;
      
      private var _435522833gatewayName:TextInput;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChangeGatewayName()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ChangeGatewayName_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_settings_ChangeGatewayNameWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ChangeGatewayName[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeGatewayName_Array1_c);
         this.addEventListener("initialize",this.___ChangeGatewayName_View1_initialize);
         this.addEventListener("creationComplete",this.___ChangeGatewayName_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChangeGatewayName._watcherSetupUtil = param1;
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
         this.gatewayName.text = HoermannRemote.appData.activeGateway.name;
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            new ChangeGatewayNameScreenOverlay(gatewayName,btnSubmit,btnCancel,bbar.callout).open(null);
         });
      }
      
      private function onComplete() : void
      {
      }
      
      private function onSubmit(param1:Event) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:Event = param1;
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(!StringValidator.checkGatewayName(this.gatewayName.text))
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_GW_NAME_NAME_INVALID");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_GW_NAME_NAME_INVALID_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         HoermannRemote.loadBox.title = Lang.getString("CHANGE_GW_NAME_SETTING");
         HoermannRemote.loadBox.contentText = Lang.getString("CHANGE_GW_NAME_SETTING_CONTENT");
         HoermannRemote.loadBox.open(null);
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            HoermannRemote.loadBox.close();
            if(loader.data.command == Commands.SET_NAME)
            {
               if(HoermannRemote.appData.activeGateway)
               {
                  HoermannRemote.appData.activeGateway.name = gatewayName.text;
               }
               navigator.popView();
            }
            else if(loader.data.command == Commands.ERROR)
            {
               HoermannRemote.errorBox.title = Lang.getString("CHANGE_GW_NAME_ERROR");
               HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_GW_NAME_ERROR_CONTENT");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               HoermannRemote.errorBox.open(null);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            HoermannRemote.loadBox.close();
            InfoCenter.onNetTimeout();
            Debug.warning("[ChangeGatewayName] Requesting a name change failed!\n" + param1);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_NAME,MCPBuilder.payloadSetName(this.gatewayName.text)));
      }
      
      private function _ChangeGatewayName_Array1_c() : Array
      {
         var _loc1_:Array = [this._ChangeGatewayName_GatewayDisplay1_i(),this._ChangeGatewayName_SkinnableContainer1_i(),this._ChangeGatewayName_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _ChangeGatewayName_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _ChangeGatewayName_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.layout = this._ChangeGatewayName_VerticalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChangeGatewayName_Array2_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _ChangeGatewayName_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.paddingLeft = 20;
         _loc1_.paddingRight = 20;
         _loc1_.paddingTop = 20;
         _loc1_.paddingBottom = 20;
         return _loc1_;
      }
      
      private function _ChangeGatewayName_Array2_c() : Array
      {
         var _loc1_:Array = [this._ChangeGatewayName_Label1_i(),this._ChangeGatewayName_Spacer1_c(),this._ChangeGatewayName_TextInput1_i(),this._ChangeGatewayName_Spacer2_c(),this._ChangeGatewayName_HGroup1_c()];
         return _loc1_;
      }
      
      private function _ChangeGatewayName_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_ChangeGatewayName_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ChangeGatewayName_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ChangeGatewayName_Label1",this._ChangeGatewayName_Label1);
         return _loc1_;
      }
      
      private function _ChangeGatewayName_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeGatewayName_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.percentWidth = 100;
         _loc1_.returnKeyLabel = "done";
         _loc1_.addEventListener("enter",this.__gatewayName_enter);
         _loc1_.id = "gatewayName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gatewayName = _loc1_;
         BindingManager.executeBindings(this,"gatewayName",this.gatewayName);
         return _loc1_;
      }
      
      public function __gatewayName_enter(param1:FlexEvent) : void
      {
         stage.focus = null;
      }
      
      private function _ChangeGatewayName_Spacer2_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeGatewayName_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._ChangeGatewayName_Button1_i(),this._ChangeGatewayName_Button2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChangeGatewayName_Button1_i() : Button
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
      
      private function _ChangeGatewayName_Button2_i() : Button
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
      
      private function _ChangeGatewayName_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___ChangeGatewayName_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___ChangeGatewayName_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _ChangeGatewayName_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_CHANGE_GATEWAY_NAME");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return gwDisplay.height + 25;
         },null,"content.top");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("CHANGE_GW_NAME_CONTENT");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_ChangeGatewayName_Label1.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_CANCEL");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnCancel.label");
         result[4] = new Binding(this,function():String
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
      public function get gatewayName() : TextInput
      {
         return this._435522833gatewayName;
      }
      
      public function set gatewayName(param1:TextInput) : void
      {
         var _loc2_:Object = this._435522833gatewayName;
         if(_loc2_ !== param1)
         {
            this._435522833gatewayName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gatewayName",_loc2_,param1));
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
