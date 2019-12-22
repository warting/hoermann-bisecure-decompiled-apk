package refactor.bisecur._1_APP.views.deviceActions
{
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
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.components.View;
   
   use namespace mx_internal;
   
   public class DeviceActionsScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _DeviceActionsScreen_Spacer1:Spacer;
      
      public var _DeviceActionsScreen_VGroup1:VGroup;
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _1781625235buttonGroup:VGroup;
      
      private var _951530617content:SkinnableContainer;
      
      private var _515659897contentMargin:Number;
      
      private var _3064427ctrl:DeviceActionsScreenCtrl;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _801844101lblState:Label;
      
      private var _870573222lblStateVal:Label;
      
      private var _249793426stateGroup:Group;
      
      private var _1002489247stateMargin:Number;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DeviceActionsScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._DeviceActionsScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_deviceActions_DeviceActionsScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DeviceActionsScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._DeviceActionsScreen_Button1_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._DeviceActionsScreen_Array2_c);
         this._DeviceActionsScreen_Number1_i();
         this._DeviceActionsScreen_DeviceActionsScreenCtrl1_i();
         this._DeviceActionsScreen_Number2_i();
         this.addEventListener("initialize",this.___DeviceActionsScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___DeviceActionsScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DeviceActionsScreen._watcherSetupUtil = param1;
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
      
      private function _DeviceActionsScreen_Number1_i() : Number
      {
         var _loc1_:Number = 25;
         this.contentMargin = _loc1_;
         BindingManager.executeBindings(this,"contentMargin",this.contentMargin);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_DeviceActionsScreenCtrl1_i() : DeviceActionsScreenCtrl
      {
         var _loc1_:DeviceActionsScreenCtrl = new DeviceActionsScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_Number2_i() : Number
      {
         var _loc1_:Number = 40;
         this.stateMargin = _loc1_;
         BindingManager.executeBindings(this,"stateMargin",this.stateMargin);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_Button1_i() : Button
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
         this.ctrl.dispose();
         this.navigator.popView();
      }
      
      private function _DeviceActionsScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._DeviceActionsScreen_GatewayDisplay1_i(),this._DeviceActionsScreen_SkinnableContainer1_i(),this._DeviceActionsScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _DeviceActionsScreen_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "channelContent";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._DeviceActionsScreen_Array3_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._DeviceActionsScreen_Group1_i(),this._DeviceActionsScreen_VGroup2_i(),this._DeviceActionsScreen_Spacer1_i()];
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.mxmlContent = [this._DeviceActionsScreen_VGroup1_i()];
         _loc1_.id = "stateGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.stateGroup = _loc1_;
         BindingManager.executeBindings(this,"stateGroup",this.stateGroup);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.left = 0;
         _loc1_.top = 30;
         _loc1_.mxmlContent = [this._DeviceActionsScreen_Label1_i(),this._DeviceActionsScreen_Label2_i()];
         _loc1_.id = "_DeviceActionsScreen_VGroup1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DeviceActionsScreen_VGroup1 = _loc1_;
         BindingManager.executeBindings(this,"_DeviceActionsScreen_VGroup1",this._DeviceActionsScreen_VGroup1);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_Label1_i() : Label
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
      
      private function _DeviceActionsScreen_Label2_i() : Label
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
      
      private function _DeviceActionsScreen_VGroup2_i() : VGroup
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
      
      private function _DeviceActionsScreen_Spacer1_i() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.id = "_DeviceActionsScreen_Spacer1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DeviceActionsScreen_Spacer1 = _loc1_;
         BindingManager.executeBindings(this,"_DeviceActionsScreen_Spacer1",this._DeviceActionsScreen_Spacer1);
         return _loc1_;
      }
      
      private function _DeviceActionsScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
         _loc1_.showRefresh = true;
         _loc1_.addEventListener("BOTTOMBAR_LOGOUT",this.__bbar_BOTTOMBAR_LOGOUT);
         _loc1_.addEventListener("BOTTOMBAR_REFRESH",this.__bbar_BOTTOMBAR_REFRESH);
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
      
      public function __bbar_BOTTOMBAR_LOGOUT(param1:BottomBarEvent) : void
      {
         this.ctrl.onLogout(param1);
      }
      
      public function __bbar_BOTTOMBAR_REFRESH(param1:BottomBarEvent) : void
      {
         this.ctrl.onRefresh(param1);
      }
      
      public function __bbar_BOTTOMBAR_HELP(param1:BottomBarEvent) : void
      {
         this.ctrl.onHelp();
      }
      
      public function ___DeviceActionsScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___DeviceActionsScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      private function _DeviceActionsScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():DeviceActionsScreen
         {
            return this;
         },null,"ctrl.view");
         result[2] = new Binding(this,function():Object
         {
            return ctrl.Icon_Back;
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[3] = new Binding(this,null,null,"content.left","contentMargin");
         result[4] = new Binding(this,null,null,"content.right","contentMargin");
         result[5] = new Binding(this,function():Object
         {
            return gwDisplay.height + contentMargin;
         },null,"content.top");
         result[6] = new Binding(this,null,null,"stateGroup.top","stateMargin");
         result[7] = new Binding(this,null,null,"stateGroup.left","stateMargin");
         result[8] = new Binding(this,null,null,"stateGroup.right","stateMargin");
         result[9] = new Binding(this,function():Object
         {
            return ctrl.stateImage.imageRect.width;
         },null,"_DeviceActionsScreen_VGroup1.right");
         result[10] = new Binding(this,function():Number
         {
            return ctrl.labelWidth;
         },null,"_DeviceActionsScreen_VGroup1.width");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.stateName;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblState.text");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.stateValue;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblStateVal.text");
         result[13] = new Binding(this,function():Object
         {
            return stateGroup.height + stateGroup.y + 30;
         },null,"buttonGroup.top");
         result[14] = new Binding(this,function():Number
         {
            return buttonGroup.height + buttonGroup.y + 30;
         },null,"_DeviceActionsScreen_Spacer1.y");
         result[15] = new Binding(this,function():Boolean
         {
            return ctrl.isRefreshEnabled;
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
      public function get ctrl() : DeviceActionsScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:DeviceActionsScreenCtrl) : void
      {
         var _loc2_:Object = this._3064427ctrl;
         if(_loc2_ !== param1)
         {
            this._3064427ctrl = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ctrl",_loc2_,param1));
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
   }
}
