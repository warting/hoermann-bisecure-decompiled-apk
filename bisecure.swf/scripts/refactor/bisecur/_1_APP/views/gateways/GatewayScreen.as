package refactor.bisecur._1_APP.views.gateways
{
   import com.isisic.remote.hoermann.components.ArrowComponent;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.IList;
   import mx.controls.Spacer;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.views.gateways.renderer.GatewayRenderer;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   import spark.events.ViewNavigatorEvent;
   
   use namespace mx_internal;
   
   public class GatewayScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _GatewayScreen_Group1:Group;
      
      public var _GatewayScreen_Label2:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _503168488btnPortal:Button;
      
      private var _3064427ctrl:GatewayScreenCtrl;
      
      private var _435574526gatewayList:HmList;
      
      private var _1269202576helpAddGW:Label;
      
      private var _1269634376helpArrow:ArrowComponent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GatewayScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._GatewayScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_gateways_GatewayScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return GatewayScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.actionContent = [this._GatewayScreen_Button1_i(),this._GatewayScreen_Button2_i()];
         this.navigationContent = [this._GatewayScreen_Button3_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._GatewayScreen_Array3_c);
         this._GatewayScreen_GatewayScreenCtrl1_i();
         this.addEventListener("initialize",this.___GatewayScreen_View1_initialize);
         this.addEventListener("viewActivate",this.___GatewayScreen_View1_viewActivate);
         this.addEventListener("viewDeactivate",this.___GatewayScreen_View1_viewDeactivate);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GatewayScreen._watcherSetupUtil = param1;
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
      
      private function _GatewayScreen_GatewayScreenCtrl1_i() : GatewayScreenCtrl
      {
         var _loc1_:GatewayScreenCtrl = new GatewayScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _GatewayScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.styleName = "toggleActionButton";
         _loc1_.setStyle("skinClass",ColorableActionButtonSkin);
         _loc1_.addEventListener("click",this.__btnEdit_click);
         _loc1_.id = "btnEdit";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnEdit = _loc1_;
         BindingManager.executeBindings(this,"btnEdit",this.btnEdit);
         return _loc1_;
      }
      
      public function __btnEdit_click(param1:MouseEvent) : void
      {
         this.ctrl.onEdit_Toggle();
      }
      
      private function _GatewayScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.visible = true;
         _loc1_.addEventListener("click",this.__btnAdd_click);
         _loc1_.addEventListener("buttonDown",this.__btnAdd_buttonDown);
         _loc1_.id = "btnAdd";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnAdd = _loc1_;
         BindingManager.executeBindings(this,"btnAdd",this.btnAdd);
         return _loc1_;
      }
      
      public function __btnAdd_click(param1:MouseEvent) : void
      {
         this.ctrl.onAdd_Click(param1);
      }
      
      public function __btnAdd_buttonDown(param1:FlexEvent) : void
      {
         this.ctrl.onAdd_MouseDown(param1);
      }
      
      private function _GatewayScreen_Button3_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnPortal_click);
         _loc1_.id = "btnPortal";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnPortal = _loc1_;
         BindingManager.executeBindings(this,"btnPortal",this.btnPortal);
         return _loc1_;
      }
      
      public function __btnPortal_click(param1:MouseEvent) : void
      {
         this.ctrl.onPortalSettings_Click(param1);
      }
      
      private function _GatewayScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._GatewayScreen_HmList1_i(),this._GatewayScreen_Group1_i(),this._GatewayScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _GatewayScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.top = 0;
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.itemRenderer = this._GatewayScreen_ClassFactory1_c();
         _loc1_.addEventListener("changing",this.__gatewayList_changing);
         _loc1_.id = "gatewayList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gatewayList = _loc1_;
         BindingManager.executeBindings(this,"gatewayList",this.gatewayList);
         return _loc1_;
      }
      
      private function _GatewayScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = GatewayRenderer;
         return _loc1_;
      }
      
      public function __gatewayList_changing(param1:IndexChangeEvent) : void
      {
         this.ctrl.onSelect(param1);
      }
      
      private function _GatewayScreen_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._GatewayScreen_ArrowComponent1_i(),this._GatewayScreen_Label1_i(),this._GatewayScreen_VGroup1_c()];
         _loc1_.id = "_GatewayScreen_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._GatewayScreen_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayScreen_Group1",this._GatewayScreen_Group1);
         return _loc1_;
      }
      
      private function _GatewayScreen_ArrowComponent1_i() : ArrowComponent
      {
         var _loc1_:ArrowComponent = new ArrowComponent();
         _loc1_.top = 5;
         _loc1_.right = 0;
         _loc1_.setStyle("backgroundColor",11119017);
         _loc1_.setStyle("thickness",5);
         _loc1_.id = "helpArrow";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.helpArrow = _loc1_;
         BindingManager.executeBindings(this,"helpArrow",this.helpArrow);
         return _loc1_;
      }
      
      private function _GatewayScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "listNoteContent";
         _loc1_.percentWidth = 90;
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("color",11119017);
         _loc1_.setStyle("fontFamily","MarkerFelt");
         _loc1_.setStyle("paddingRight",20);
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "helpAddGW";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.helpAddGW = _loc1_;
         BindingManager.executeBindings(this,"helpAddGW",this.helpAddGW);
         return _loc1_;
      }
      
      private function _GatewayScreen_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalCenter = 0;
         _loc1_.mxmlContent = [this._GatewayScreen_Label2_i(),this._GatewayScreen_Spacer1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _GatewayScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 80;
         _loc1_.styleName = "listNoteContent";
         _loc1_.setStyle("color",11119017);
         _loc1_.setStyle("fontFamily","MarkerFelt");
         _loc1_.setStyle("lineBreak","toFit");
         _loc1_.id = "_GatewayScreen_Label2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._GatewayScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayScreen_Label2",this._GatewayScreen_Label2);
         return _loc1_;
      }
      
      private function _GatewayScreen_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.percentHeight = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _GatewayScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.logoutEnabled = false;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___GatewayScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___GatewayScreen_View1_viewActivate(param1:ViewNavigatorEvent) : void
      {
         this.ctrl.onActivate();
      }
      
      public function ___GatewayScreen_View1_viewDeactivate(param1:ViewNavigatorEvent) : void
      {
         this.ctrl.onDeactivate();
      }
      
      private function _GatewayScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():GatewayScreen
         {
            return this;
         },null,"ctrl.view");
         result[2] = new Binding(this,function():Object
         {
            return ctrl.EditIcon;
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[3] = new Binding(this,function():Object
         {
            return ctrl.AddIcon;
         },function(param1:Object):void
         {
            btnAdd.setStyle("icon",param1);
         },"btnAdd.icon");
         result[4] = new Binding(this,function():Object
         {
            return ctrl.PortalSettingsIcon;
         },function(param1:Object):void
         {
            btnPortal.setStyle("icon",param1);
         },"btnPortal.icon");
         result[5] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"gatewayList.bottom");
         result[6] = new Binding(this,function():IList
         {
            return this.ctrl.listProvider;
         },null,"gatewayList.dataProvider");
         result[7] = new Binding(this,function():Boolean
         {
            return this.ctrl.listProvider.length <= 0;
         },null,"_GatewayScreen_Group1.visible");
         result[8] = new Binding(this,null,null,"helpArrow.sourcePointer","helpAddGW");
         result[9] = new Binding(this,null,null,"helpArrow.destinationPointer","btnAdd");
         result[10] = new Binding(this,function():Number
         {
            return helpArrow.height;
         },null,"helpArrow.width");
         result[11] = new Binding(this,function():Number
         {
            return helpAddGW.y + helpAddGW.height;
         },null,"helpArrow.height");
         result[12] = new Binding(this,null,null,"helpArrow.controlX","btnAdd");
         result[13] = new Binding(this,null,null,"helpArrow.controlY","helpAddGW");
         result[14] = new Binding(this,function():Number
         {
            return height * 0.05;
         },null,"helpAddGW.y");
         result[15] = new Binding(this,function():Object
         {
            return helpArrow.width;
         },null,"helpAddGW.right");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Locales["ADD_HELP"];
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"helpAddGW.text");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Locales["NO_GATEWAYS"];
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_GatewayScreen_Label2.text");
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
      public function get btnAdd() : Button
      {
         return this._1378839387btnAdd;
      }
      
      public function set btnAdd(param1:Button) : void
      {
         var _loc2_:Object = this._1378839387btnAdd;
         if(_loc2_ !== param1)
         {
            this._1378839387btnAdd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnAdd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnEdit() : Button
      {
         return this._205771398btnEdit;
      }
      
      public function set btnEdit(param1:Button) : void
      {
         var _loc2_:Object = this._205771398btnEdit;
         if(_loc2_ !== param1)
         {
            this._205771398btnEdit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnEdit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnPortal() : Button
      {
         return this._503168488btnPortal;
      }
      
      public function set btnPortal(param1:Button) : void
      {
         var _loc2_:Object = this._503168488btnPortal;
         if(_loc2_ !== param1)
         {
            this._503168488btnPortal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnPortal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ctrl() : GatewayScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:GatewayScreenCtrl) : void
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
      public function get gatewayList() : HmList
      {
         return this._435574526gatewayList;
      }
      
      public function set gatewayList(param1:HmList) : void
      {
         var _loc2_:Object = this._435574526gatewayList;
         if(_loc2_ !== param1)
         {
            this._435574526gatewayList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gatewayList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpAddGW() : Label
      {
         return this._1269202576helpAddGW;
      }
      
      public function set helpAddGW(param1:Label) : void
      {
         var _loc2_:Object = this._1269202576helpAddGW;
         if(_loc2_ !== param1)
         {
            this._1269202576helpAddGW = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpAddGW",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpArrow() : ArrowComponent
      {
         return this._1269634376helpArrow;
      }
      
      public function set helpArrow(param1:ArrowComponent) : void
      {
         var _loc2_:Object = this._1269634376helpArrow;
         if(_loc2_ !== param1)
         {
            this._1269634376helpArrow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpArrow",_loc2_,param1));
            }
         }
      }
   }
}
