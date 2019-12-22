package refactor.bisecur._1_APP.views.debug.showDaoData
{
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.TextArea;
   import spark.components.VGroup;
   import spark.components.View;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class ShowDaoDataScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _205678947btnBack:Button;
      
      private var _3064427ctrl:ShowDaoDataScreenCtrl;
      
      private var _1004197030textArea:TextArea;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ShowDaoDataScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ShowDaoDataScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_debug_showDaoData_ShowDaoDataScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ShowDaoDataScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._ShowDaoDataScreen_Button1_i()];
         this.actionContent = [];
         this.layout = this._ShowDaoDataScreen_VerticalLayout1_c();
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ShowDaoDataScreen_Array3_c);
         this._ShowDaoDataScreen_ShowDaoDataScreenCtrl1_i();
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ShowDaoDataScreen._watcherSetupUtil = param1;
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
      
      private function _ShowDaoDataScreen_ShowDaoDataScreenCtrl1_i() : ShowDaoDataScreenCtrl
      {
         var _loc1_:ShowDaoDataScreenCtrl = new ShowDaoDataScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_Button1_i() : Button
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
         navigator.popView();
      }
      
      private function _ShowDaoDataScreen_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._ShowDaoDataScreen_VGroup1_c(),this._ShowDaoDataScreen_TextArea1_i()];
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ShowDaoDataScreen_HGroup1_c(),this._ShowDaoDataScreen_HGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._ShowDaoDataScreen_Button2_c(),this._ShowDaoDataScreen_Button3_c(),this._ShowDaoDataScreen_Button4_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_Button2_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "clr";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button2_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button2_click(param1:MouseEvent) : void
      {
         this.ctrl.onClear();
      }
      
      private function _ShowDaoDataScreen_Button3_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "AppSettings";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button3_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button3_click(param1:MouseEvent) : void
      {
         this.ctrl.onShowAppSettings();
      }
      
      private function _ShowDaoDataScreen_Button4_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "Gateways";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button4_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button4_click(param1:MouseEvent) : void
      {
         this.ctrl.onShowGateways();
      }
      
      private function _ShowDaoDataScreen_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._ShowDaoDataScreen_Button5_c(),this._ShowDaoDataScreen_Button6_c(),this._ShowDaoDataScreen_Button7_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_Button5_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "GW Settings";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button5_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button5_click(param1:MouseEvent) : void
      {
         this.ctrl.onShowGatewaySettings();
      }
      
      private function _ShowDaoDataScreen_Button6_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "Scenarios";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button6_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button6_click(param1:MouseEvent) : void
      {
         this.ctrl.onShowScenarios();
      }
      
      private function _ShowDaoDataScreen_Button7_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "logins";
         _loc1_.addEventListener("click",this.___ShowDaoDataScreen_Button7_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___ShowDaoDataScreen_Button7_click(param1:MouseEvent) : void
      {
         this.ctrl.onShowUserLogins();
      }
      
      private function _ShowDaoDataScreen_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.editable = false;
         _loc1_.id = "textArea";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.textArea = _loc1_;
         BindingManager.executeBindings(this,"textArea",this.textArea);
         return _loc1_;
      }
      
      private function _ShowDaoDataScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():ShowDaoDataScreen
         {
            return this;
         },null,"ctrl.view");
         result[1] = new Binding(this,function():Object
         {
            return ctrl.Icon_Back;
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.txtOut;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"textArea.text");
         return result;
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
      public function get ctrl() : ShowDaoDataScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:ShowDaoDataScreenCtrl) : void
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
      public function get textArea() : TextArea
      {
         return this._1004197030textArea;
      }
      
      public function set textArea(param1:TextArea) : void
      {
         var _loc2_:Object = this._1004197030textArea;
         if(_loc2_ !== param1)
         {
            this._1004197030textArea = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textArea",_loc2_,param1));
            }
         }
      }
   }
}
