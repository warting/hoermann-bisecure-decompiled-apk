package refactor.bisecur._1_APP.views.manageUsers.manageUserRights
{
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.views.options.settings.user.UserRightRenderer;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import spark.components.Button;
   import spark.components.View;
   
   use namespace mx_internal;
   
   public class UserRightsScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _206185977btnSave:Button;
      
      private var _3064427ctrl:UserRightsScreenCtrl;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _1569359654rightList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function UserRightsScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._UserRightsScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_manageUsers_manageUserRights_UserRightsScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return UserRightsScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._UserRightsScreen_Button1_i()];
         this.actionContent = [this._UserRightsScreen_Button2_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._UserRightsScreen_Array3_c);
         this._UserRightsScreen_UserRightsScreenCtrl1_i();
         this.addEventListener("initialize",this.___UserRightsScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___UserRightsScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         UserRightsScreen._watcherSetupUtil = param1;
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
      
      private function _UserRightsScreen_UserRightsScreenCtrl1_i() : UserRightsScreenCtrl
      {
         var _loc1_:UserRightsScreenCtrl = new UserRightsScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _UserRightsScreen_Button1_i() : Button
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
      
      private function _UserRightsScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.styleName = "logoutButton";
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
         this.ctrl.onSave_Click(param1);
      }
      
      private function _UserRightsScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._UserRightsScreen_GatewayDisplay1_i(),this._UserRightsScreen_HmList1_i(),this._UserRightsScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _UserRightsScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _UserRightsScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.labelField = "name";
         _loc1_.itemRenderer = this._UserRightsScreen_ClassFactory1_c();
         _loc1_.allowMultipleSelection = true;
         _loc1_.id = "rightList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rightList = _loc1_;
         BindingManager.executeBindings(this,"rightList",this.rightList);
         return _loc1_;
      }
      
      private function _UserRightsScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = UserRightRenderer;
         return _loc1_;
      }
      
      private function _UserRightsScreen_BottomBar1_i() : BottomBar
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
         this.ctrl.onHelp();
      }
      
      public function ___UserRightsScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___UserRightsScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      private function _UserRightsScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():UserRightsScreen
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
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Text_Save;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnSave.label");
         result[4] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"rightList.top");
         result[5] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"rightList.bottom");
         result[6] = new Binding(this,function():IList
         {
            return ctrl.listProvider;
         },null,"rightList.dataProvider");
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
      public function get ctrl() : UserRightsScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:UserRightsScreenCtrl) : void
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
      public function get rightList() : HmList
      {
         return this._1569359654rightList;
      }
      
      public function set rightList(param1:HmList) : void
      {
         var _loc2_:Object = this._1569359654rightList;
         if(_loc2_ !== param1)
         {
            this._1569359654rightList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightList",_loc2_,param1));
            }
         }
      }
   }
}
