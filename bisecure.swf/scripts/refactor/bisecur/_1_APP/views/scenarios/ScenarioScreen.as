package refactor.bisecur._1_APP.views.scenarios
{
   import com.isisic.remote.hoermann.components.ArrowComponent;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
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
   import refactor.bisecur._1_APP.views.scenarios.renderer.ScenarioRenderer;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   
   use namespace mx_internal;
   
   public class ScenarioScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ScenarioScreen_Group1:Group;
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205678947btnBack:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _3064427ctrl:ScenarioScreenCtrl;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _1269202576helpAddGW:Label;
      
      private var _1269634376helpArrow:ArrowComponent;
      
      private var _1008381874scenarioList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ScenarioScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ScenarioScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_scenarios_ScenarioScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ScenarioScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._ScenarioScreen_Button1_i()];
         this.actionContent = [this._ScenarioScreen_Button2_i(),this._ScenarioScreen_Button3_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ScenarioScreen_Array3_c);
         this._ScenarioScreen_ScenarioScreenCtrl1_i();
         this.addEventListener("initialize",this.___ScenarioScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___ScenarioScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ScenarioScreen._watcherSetupUtil = param1;
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
      
      private function _ScenarioScreen_ScenarioScreenCtrl1_i() : ScenarioScreenCtrl
      {
         var _loc1_:ScenarioScreenCtrl = new ScenarioScreenCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _ScenarioScreen_Button1_i() : Button
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
      
      private function _ScenarioScreen_Button2_i() : Button
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
         this.ctrl.onToggleEdit_Click();
      }
      
      private function _ScenarioScreen_Button3_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnAdd_click);
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
         this.ctrl.onAdd_Click();
      }
      
      private function _ScenarioScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._ScenarioScreen_GatewayDisplay1_i(),this._ScenarioScreen_Group1_i(),this._ScenarioScreen_HmList1_i(),this._ScenarioScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _ScenarioScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _ScenarioScreen_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._ScenarioScreen_ArrowComponent1_i(),this._ScenarioScreen_Label1_i()];
         _loc1_.id = "_ScenarioScreen_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ScenarioScreen_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_ScenarioScreen_Group1",this._ScenarioScreen_Group1);
         return _loc1_;
      }
      
      private function _ScenarioScreen_ArrowComponent1_i() : ArrowComponent
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
      
      private function _ScenarioScreen_Label1_i() : Label
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
      
      private function _ScenarioScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.itemRenderer = this._ScenarioScreen_ClassFactory1_c();
         _loc1_.addEventListener("changing",this.__scenarioList_changing);
         _loc1_.id = "scenarioList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.scenarioList = _loc1_;
         BindingManager.executeBindings(this,"scenarioList",this.scenarioList);
         return _loc1_;
      }
      
      private function _ScenarioScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ScenarioRenderer;
         return _loc1_;
      }
      
      public function __scenarioList_changing(param1:IndexChangeEvent) : void
      {
         this.ctrl.onScenarioSelected(param1);
      }
      
      private function _ScenarioScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
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
         this.ctrl.onHelp_Click();
      }
      
      public function ___ScenarioScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___ScenarioScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      private function _ScenarioScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():ScenarioScreen
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
         result[3] = new Binding(this,function():Object
         {
            return ctrl.Icon_Edit;
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[4] = new Binding(this,function():Object
         {
            return ctrl.Icon_Add;
         },function(param1:Object):void
         {
            btnAdd.setStyle("icon",param1);
         },"btnAdd.icon");
         result[5] = new Binding(this,function():Boolean
         {
            return ctrl.listProvider.length <= 0;
         },null,"_ScenarioScreen_Group1.visible");
         result[6] = new Binding(this,null,null,"helpArrow.sourcePointer","helpAddGW");
         result[7] = new Binding(this,null,null,"helpArrow.destinationPointer","btnAdd");
         result[8] = new Binding(this,function():Number
         {
            return helpArrow.height;
         },null,"helpArrow.width");
         result[9] = new Binding(this,function():Number
         {
            return helpAddGW.y + helpAddGW.height;
         },null,"helpArrow.height");
         result[10] = new Binding(this,null,null,"helpArrow.controlX","btnAdd");
         result[11] = new Binding(this,null,null,"helpArrow.controlY","helpAddGW");
         result[12] = new Binding(this,function():Number
         {
            return height * 0.05;
         },null,"helpAddGW.y");
         result[13] = new Binding(this,function():Object
         {
            return helpArrow.width;
         },null,"helpAddGW.right");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("SCENARIOS_ADD_HELP");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"helpAddGW.text");
         result[15] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"scenarioList.top");
         result[16] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"scenarioList.bottom");
         result[17] = new Binding(this,function():IList
         {
            return ctrl.listProvider;
         },null,"scenarioList.dataProvider");
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
      public function get ctrl() : ScenarioScreenCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:ScenarioScreenCtrl) : void
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
      
      [Bindable(event="propertyChange")]
      public function get scenarioList() : HmList
      {
         return this._1008381874scenarioList;
      }
      
      public function set scenarioList(param1:HmList) : void
      {
         var _loc2_:Object = this._1008381874scenarioList;
         if(_loc2_ !== param1)
         {
            this._1008381874scenarioList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scenarioList",_loc2_,param1));
            }
         }
      }
   }
}
