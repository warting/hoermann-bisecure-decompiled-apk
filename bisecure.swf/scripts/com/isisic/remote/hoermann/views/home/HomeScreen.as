package com.isisic.remote.hoermann.views.home
{
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.HomeScreenOverlay;
   import com.isisic.remote.hoermann.components.popups.ChangePwdBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import com.isisic.remote.hoermann.views.options.OptionsScreen;
   import com.isisic.remote.hoermann.views.options.settings.user.EditUsersScreen;
   import com.isisic.remote.hoermann.views.scenarios.ScenarioScreen;
   import com.isisic.remote.lw.Debug;
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
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.List;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class HomeScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _HomeScreen_Button1:Button;
      
      public var _HomeScreen_Object1:Object;
      
      public var _HomeScreen_Object2:Object;
      
      public var _HomeScreen_Object3:Object;
      
      private var _3016817bbar:BottomBar;
      
      private var _1233845349gwName:GatewayDisplay;
      
      private var _486436323homeList:HmList;
      
      private var _453515085horizontalPadding:Number;
      
      private var _121291845verticalPadding:Number;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var fwdActive:Boolean = false;
      
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
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_home_HomeScreenWatcherSetupUtil");
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
      
      protected function onItemSelected(param1:IndexChangeEvent) : void
      {
         var _loc2_:Object = (param1.currentTarget as List).selectedItem;
         if(!_loc2_)
         {
            return;
         }
         if(!_loc2_.view)
         {
            return;
         }
         this.navigator.pushView(_loc2_.view);
      }
      
      protected function onInit() : void
      {
         var _loc1_:Object = null;
         HoermannRemote.app.editMode = false;
         GatewayDisplay.description = "";
         if(this.data && this.data.forward)
         {
            this.fwdActive = true;
            _loc1_ = this.data.forward;
            this.data.forward = null;
            this.navigator.pushView(_loc1_ as Class);
         }
         this.bbar.addEventListener(BottomBarEvent.HELP,this.onHelp);
         if(HoermannRemote.appData.isAdmin)
         {
            this.homeList.dataProvider.addItem({
               "name":Lang.getString("OPTIONS_EDIT_USERS"),
               "view":EditUsersScreen
            });
         }
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
         var _loc7_:Object = null;
         var _loc2_:IVisualElement = null;
         var _loc3_:IVisualElement = null;
         var _loc4_:IVisualElement = null;
         var _loc5_:IVisualElement = null;
         var _loc6_:int = 0;
         while(_loc6_ < this.homeList.dataGroup.numElements)
         {
            _loc7_ = this.homeList.dataGroup.getElementAt(_loc6_);
            switch(_loc6_ % 4)
            {
               case 0:
                  _loc2_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 1:
                  _loc3_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 2:
                  _loc4_ = _loc7_.lblTitle as IVisualElement;
                  break;
               case 3:
                  _loc5_ = _loc7_.lblTitle as IVisualElement;
            }
            _loc6_++;
         }
         new HomeScreenOverlay(_loc2_,_loc3_,_loc4_,_loc5_,this.bbar.callout).open(null);
      }
      
      private function onComplete() : void
      {
         var activeGW:Object = null;
         var gw:Object = null;
         var chPwdBox:ChangePwdBox = null;
         if(this.fwdActive)
         {
            return;
         }
         var data:AppData = HoermannRemote.appData;
         if(data.activeLogin.username == "admin" && data.activeLogin.password == "0000")
         {
            for each(gw in data.gateways)
            {
               if(gw.mac == data.activeConnection.mac)
               {
                  activeGW = gw;
                  break;
               }
            }
            if(activeGW == null)
            {
               Debug.warning("Active Gateway not found! (PWChnageBox won\'t be displayed)");
               this.testHelp();
            }
            else if(!activeGW.adminPwdChanged)
            {
               chPwdBox = new ChangePwdBox();
               chPwdBox.addEventListener(PopUpEvent.CLOSE,function(param1:PopUpEvent):void
               {
                  testHelp();
               });
               chPwdBox.open(null);
               activeGW.adminPwdChanged = true;
               data.save();
            }
            else
            {
               this.testHelp();
            }
         }
         else
         {
            this.testHelp();
         }
      }
      
      private function testHelp() : Boolean
      {
         return false;
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
         HoermannRemote.app.logout();
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
         this.onItemSelected(param1);
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
         this.onInit();
      }
      
      public function ___HomeScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _HomeScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("HOME_TITLE");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("LOGOUT");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_HomeScreen_Button1.label");
         result[2] = new Binding(this,function():Object
         {
            return gwName.height;
         },null,"homeList.top");
         result[3] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"homeList.bottom");
         result[4] = new Binding(this,function():*
         {
            return Lang.getString("ACTORS");
         },null,"_HomeScreen_Object1.name");
         result[5] = new Binding(this,function():*
         {
            return ActorScreen;
         },null,"_HomeScreen_Object1.view");
         result[6] = new Binding(this,function():*
         {
            return Lang.getString("SCENARIOS");
         },null,"_HomeScreen_Object2.name");
         result[7] = new Binding(this,function():*
         {
            return ScenarioScreen;
         },null,"_HomeScreen_Object2.view");
         result[8] = new Binding(this,function():*
         {
            return Lang.getString("OPTIONS");
         },null,"_HomeScreen_Object3.name");
         result[9] = new Binding(this,function():*
         {
            return OptionsScreen;
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
