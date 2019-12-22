package refactor.bisecur._1_APP.views.home
{
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.views.home.HomeListRenderer;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.views.deviceList.DeviceListScreen;
   import refactor.bisecur._1_APP.views.scenarios.ScenarioScreen;
   import refactor.bisecur._1_APP.views.settings.SettingsScreen;
   import spark.components.Button;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   
   use namespace mx_internal;
   
   public class HomeScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _HomeScreen_Button1:Button;
      
      public var _HomeScreen_Object1:Object;
      
      public var _HomeScreen_Object2:Object;
      
      public var _HomeScreen_Object3:Object;
      
      private var _3016817bbar:BottomBar;
      
      private var _3064427ctrl:HomeScreenCtrl;
      
      private var _1233845349gwName:GatewayDisplay;
      
      private var _486436323homeList:HmList;
      
      private var _453515085horizontalPadding:Number;
      
      private var _121291845verticalPadding:Number;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HomeScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._HomeScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_home_HomeScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HomeScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._HomeScreen_Button1_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._HomeScreen_Array2_c);
         this._HomeScreen_HomeScreenCtrl1_i();
         this._HomeScreen_Number1_i();
         this._HomeScreen_Number2_i();
         this.addEventListener("initialize",this.___HomeScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___HomeScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HomeScreen._watcherSetupUtil = param1;
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
      
      private function _HomeScreen_HomeScreenCtrl1_i() : HomeScreenCtrl
      {
         var _loc1_:HomeScreenCtrl = new HomeScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _HomeScreen_Number1_i() : Number
      {
         var _loc1_:Number = 30;
         this.horizontalPadding = _loc1_;
         BindingManager.executeBindings(this,"horizontalPadding",this.horizontalPadding);
         return _loc1_;
      }
      
      private function _HomeScreen_Number2_i() : Number
      {
         var _loc1_:Number = 30;
         this.verticalPadding = _loc1_;
         BindingManager.executeBindings(this,"verticalPadding",this.verticalPadding);
         return _loc1_;
      }
      
      private function _HomeScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "logoutButton";
         _loc1_.setStyle("fontWeight","normal");
         _loc1_.addEventListener("click",this.___HomeScreen_Button1_click);
         _loc1_.id = "_HomeScreen_Button1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._HomeScreen_Button1 = _loc1_;
         BindingManager.executeBindings(this,"_HomeScreen_Button1",this._HomeScreen_Button1);
         return _loc1_;
      }
      
      public function ___HomeScreen_Button1_click(param1:MouseEvent) : void
      {
         this.ctrl.onLogout();
      }
      
      private function _HomeScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._HomeScreen_GatewayDisplay1_i(),this._HomeScreen_HmList1_i(),this._HomeScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _HomeScreen_GatewayDisplay1_i() : GatewayDisplay
      {
         var _loc1_:GatewayDisplay = new GatewayDisplay();
         _loc1_.percentWidth = 100;
         _loc1_.id = "gwName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gwName = _loc1_;
         BindingManager.executeBindings(this,"gwName",this.gwName);
         return _loc1_;
      }
      
      private function _HomeScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.itemRenderer = this._HomeScreen_ClassFactory1_c();
         _loc1_.dataProvider = this._HomeScreen_ArrayList1_c();
         _loc1_.addEventListener("change",this.__homeList_change);
         _loc1_.id = "homeList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.homeList = _loc1_;
         BindingManager.executeBindings(this,"homeList",this.homeList);
         return _loc1_;
      }
      
      private function _HomeScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = HomeListRenderer;
         return _loc1_;
      }
      
      private function _HomeScreen_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._HomeScreen_Object1_i(),this._HomeScreen_Object2_i(),this._HomeScreen_Object3_i()];
         return _loc1_;
      }
      
      private function _HomeScreen_Object1_i() : Object
      {
         var _loc1_:Object = {
            "name":null,
            "view":null
         };
         this._HomeScreen_Object1 = _loc1_;
         BindingManager.executeBindings(this,"_HomeScreen_Object1",this._HomeScreen_Object1);
         return _loc1_;
      }
      
      private function _HomeScreen_Object2_i() : Object
      {
         var _loc1_:Object = {
            "name":null,
            "view":null
         };
         this._HomeScreen_Object2 = _loc1_;
         BindingManager.executeBindings(this,"_HomeScreen_Object2",this._HomeScreen_Object2);
         return _loc1_;
      }
      
      private function _HomeScreen_Object3_i() : Object
      {
         var _loc1_:Object = {
            "name":null,
            "view":null
         };
         this._HomeScreen_Object3 = _loc1_;
         BindingManager.executeBindings(this,"_HomeScreen_Object3",this._HomeScreen_Object3);
         return _loc1_;
      }
      
      public function __homeList_change(param1:IndexChangeEvent) : void
      {
         this.ctrl.onItemSelected(param1);
      }
      
      private function _HomeScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___HomeScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___HomeScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      private function _HomeScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():HomeScreen
         {
            return this;
         },null,"ctrl.view");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.LogoutText;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_HomeScreen_Button1.label");
         result[3] = new Binding(this,function():Object
         {
            return gwName.height;
         },null,"homeList.top");
         result[4] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"homeList.bottom");
         result[5] = new Binding(this,function():*
         {
            return ctrl.ActorsText;
         },null,"_HomeScreen_Object1.name");
         result[6] = new Binding(this,function():*
         {
            return DeviceListScreen;
         },null,"_HomeScreen_Object1.view");
         result[7] = new Binding(this,function():*
         {
            return ctrl.ScenariosText;
         },null,"_HomeScreen_Object2.name");
         result[8] = new Binding(this,function():*
         {
            return ScenarioScreen;
         },null,"_HomeScreen_Object2.view");
         result[9] = new Binding(this,function():*
         {
            return ctrl.OptionsText;
         },null,"_HomeScreen_Object3.name");
         result[10] = new Binding(this,function():*
         {
            return SettingsScreen;
         },null,"_HomeScreen_Object3.view");
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
      public function get ctrl() : HomeScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:HomeScreenCtrl) : void
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
      public function get gwName() : GatewayDisplay
      {
         return this._1233845349gwName;
      }
      
      public function set gwName(param1:GatewayDisplay) : void
      {
         var _loc2_:Object = this._1233845349gwName;
         if(_loc2_ !== param1)
         {
            this._1233845349gwName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gwName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get homeList() : HmList
      {
         return this._486436323homeList;
      }
      
      public function set homeList(param1:HmList) : void
      {
         var _loc2_:Object = this._486436323homeList;
         if(_loc2_ !== param1)
         {
            this._486436323homeList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homeList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get horizontalPadding() : Number
      {
         return this._453515085horizontalPadding;
      }
      
      public function set horizontalPadding(param1:Number) : void
      {
         var _loc2_:Object = this._453515085horizontalPadding;
         if(_loc2_ !== param1)
         {
            this._453515085horizontalPadding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalPadding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get verticalPadding() : Number
      {
         return this._121291845verticalPadding;
      }
      
      public function set verticalPadding(param1:Number) : void
      {
         var _loc2_:Object = this._121291845verticalPadding;
         if(_loc2_ !== param1)
         {
            this._121291845verticalPadding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalPadding",_loc2_,param1));
            }
         }
      }
   }
}
