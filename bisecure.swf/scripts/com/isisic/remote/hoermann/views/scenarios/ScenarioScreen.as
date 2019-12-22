package com.isisic.remote.hoermann.views.scenarios
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.components.ArrowComponent;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.ScenarioScreenOverlay;
   import com.isisic.remote.hoermann.components.popups.AddScenarioBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.events.ScenarioEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StateSetter;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class ScenarioScreen extends View implements IBindingClient
   {
      
      private static const LOADING_BOX_DURATION:int = 3000;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ScenarioScreen_Group1:Group;
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205678947btnBack:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _1269202576helpAddGW:Label;
      
      private var _1269634376helpArrow:ArrowComponent;
      
      private var _1008381874scenarioList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _706694561scenarioProvider:ArrayList;
      
      private var context:ConnectionContext;
      
      private var groups:Array;
      
      private var groupIds:ArrayList;
      
      private var timeoutTimer:Timer;
      
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
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_scenarios_ScenarioScreenWatcherSetupUtil");
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
      
      private function initComp() : void
      {
         HoermannRemote.app.editMode = false;
         this.context = HoermannRemote.appData.activeConnection;
         this.scenarioList.addEventListener(IndexChangeEvent.CHANGING,this.onSelectScenario);
         this.scenarioList.addEventListener(ScenarioEvent.EDIT,this.onEditScenario);
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            new ScenarioScreenOverlay(btnBack,btnAdd,btnEdit,bbar.callout).open(null);
         });
         if(HoermannRemote.gatewayData.portCount < 0)
         {
            HoermannRemote.gatewayData.updatePortCount(this.context);
         }
      }
      
      private function onCreationComple() : void
      {
         HoermannRemote.loadBox.title = Lang.getString("LOADING_GROUPS_TITLE");
         HoermannRemote.loadBox.contentText = Lang.getString("LOADING_GROUPS_CONTENT");
         HoermannRemote.loadBox.open(null);
         if(HoermannRemote.gatewayData.groups == null)
         {
            HoermannRemote.gatewayData.addEventListener(GatewayData.GROUPS_CHANGED,this.onGroupsCollected);
            HoermannRemote.gatewayData.updateGroups(this.context,HoermannRemote.appData.userId);
         }
         else
         {
            this.onGroupsCollected();
         }
         this.timeoutTimer = new Timer(HoermannRemote.GROUP_LOADING_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         (param1.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         if(!HoermannRemote.loadBox.isOpen)
         {
            return;
         }
         HoermannRemote.loadBox.close();
         HoermannRemote.errorBox.title = Lang.getString("ERROR_TIMEOUT");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
         if(this.navigator)
         {
            this.navigator.popView();
         }
      }
      
      private function onGroupsCollected(param1:Event = null) : void
      {
         var _loc2_:HmGroup = null;
         if(param1)
         {
            param1.target.removeEventListener(GatewayData.GROUPS_CHANGED,this.onGroupsCollected);
         }
         this.groups = HoermannRemote.gatewayData.groups;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
         this.groupIds = new ArrayList();
         for each(_loc2_ in this.groups)
         {
            this.groupIds.addItem(_loc2_.id);
         }
         this.loadScenarios();
         HoermannRemote.loadBox.close();
      }
      
      private function toggleEdit() : void
      {
         if(HoermannRemote.app.editMode)
         {
            this.btnEdit.setStyle("chromeAlpha",0);
         }
         else
         {
            this.btnEdit.setStyle("chromeAlpha",1);
         }
         HoermannRemote.app.editMode = this.btnEdit.getStyle("chromeAlpha");
      }
      
      private function onAdd() : void
      {
         var _loc1_:AddScenarioBox = new AddScenarioBox(this.groups);
         _loc1_.title = Lang.getString("ADD_SCENARIO");
         _loc1_.addEventListener(PopUpEvent.CLOSE,this.onAdded);
         _loc1_.open(null);
      }
      
      protected function onAdded(param1:PopUpEvent) : void
      {
         if(!param1.commit)
         {
            return;
         }
         if(param1.data)
         {
            switch(param1.currentTarget.action)
            {
               case AddScenarioBox.ADD:
                  this.scenarioProvider.addItem(param1.data);
                  HoermannRemote.appData.save();
                  break;
               case AddScenarioBox.EDIT:
                  break;
               case AddScenarioBox.DELETE:
            }
         }
         HoermannRemote.appData.save();
      }
      
      private function loadScenarios() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         this.scenarioProvider = new ArrayList(HoermannRemote.appData.scenarios);
         for each(_loc1_ in this.scenarioProvider.toArray())
         {
            for each(_loc2_ in _loc1_.actions)
            {
               if(this.groupIds.getItemIndex(_loc2_.groupId) < 0)
               {
                  this.scenarioProvider.removeItem(_loc1_);
               }
            }
         }
         HoermannRemote.appData.save();
      }
      
      private function onEditScenario(param1:Event) : void
      {
         var _loc2_:AddScenarioBox = new AddScenarioBox(this.groups,param1.target.data);
         _loc2_.title = Lang.getString("EDIT_GROUP");
         _loc2_.addEventListener(PopUpEvent.CLOSE,this.onEditFinished);
         _loc2_.open(null);
      }
      
      private function onEditFinished(param1:PopUpEvent) : void
      {
         var _loc3_:IFactory = null;
         this.toggleEdit();
         if(!param1.commit)
         {
            return;
         }
         var _loc2_:AddScenarioBox = param1.currentTarget as AddScenarioBox;
         switch(_loc2_.action)
         {
            case AddScenarioBox.ADD:
               break;
            case AddScenarioBox.DELETE:
               this.scenarioProvider.removeItem(param1.data);
               HoermannRemote.appData.save();
               break;
            case AddScenarioBox.EDIT:
               _loc3_ = this.scenarioList.itemRenderer;
               this.scenarioList.itemRenderer = null;
               this.scenarioList.itemRenderer = _loc3_;
               break;
            case AddScenarioBox.NONE:
         }
      }
      
      protected function onSelectScenario(param1:IndexChangeEvent) : void
      {
         param1.preventDefault();
         if(HoermannRemote.app.editMode)
         {
            return;
         }
         HoermannRemote.loadBox.title = Lang.getString("POPUP_SCENARIO_DISPATCHING");
         HoermannRemote.loadBox.contentText = Lang.getString("POPUP_SCENARIO_DISPATCHING_CONTENT");
         HoermannRemote.loadBox.open(null);
         var _loc2_:Timer = new Timer(LOADING_BOX_DURATION,1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCloseLoadBox);
         _loc2_.start();
         var _loc3_:StateSetter = new StateSetter(this.context);
         _loc3_.setScenarios(this.scenarioList.selectedItem.actions);
      }
      
      protected function onCloseLoadBox(param1:TimerEvent) : void
      {
         HoermannRemote.loadBox.close();
         if(this.navigator)
         {
            if(Features.scenarioHotfix)
            {
               HoermannRemote.errorBox.title = "Das Szenario wurde ausgeführt.";
               HoermannRemote.errorBox.contentText = "Sie können sich den aktuellen Status anzeigen lassen, indem Sie die Geräteliste aktualisieren.";
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.open(null);
            }
            else
            {
               HmProcessor.defaultProcessor.requestTransition();
               this.navigator.replaceView(ActorScreen);
            }
         }
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
         this.toggleEdit();
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
         this.onAdd();
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
      
      private function _ScenarioScreen_BottomBar1_i() : BottomBar
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
      
      public function ___ScenarioScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___ScenarioScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComple();
      }
      
      private function _ScenarioScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("SCENARIOS");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgEdit);
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[3] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgAdd);
         },function(param1:Object):void
         {
            btnAdd.setStyle("icon",param1);
         },"btnAdd.icon");
         result[4] = new Binding(this,function():Boolean
         {
            return scenarioProvider.length <= 0;
         },null,"_ScenarioScreen_Group1.visible");
         result[5] = new Binding(this,null,null,"helpArrow.sourcePointer","helpAddGW");
         result[6] = new Binding(this,null,null,"helpArrow.destinationPointer","btnAdd");
         result[7] = new Binding(this,function():Number
         {
            return helpArrow.height;
         },null,"helpArrow.width");
         result[8] = new Binding(this,function():Number
         {
            return helpAddGW.y + helpAddGW.height;
         },null,"helpArrow.height");
         result[9] = new Binding(this,null,null,"helpArrow.controlX","btnAdd");
         result[10] = new Binding(this,null,null,"helpArrow.controlY","helpAddGW");
         result[11] = new Binding(this,function():Number
         {
            return height * 0.05;
         },null,"helpAddGW.y");
         result[12] = new Binding(this,function():Object
         {
            return helpArrow.width;
         },null,"helpAddGW.right");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("SCENARIOS_ADD_HELP");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"helpAddGW.text");
         result[14] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"scenarioList.top");
         result[15] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"scenarioList.bottom");
         result[16] = new Binding(this,function():IList
         {
            return this.scenarioProvider;
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
      
      [Bindable(event="propertyChange")]
      private function get scenarioProvider() : ArrayList
      {
         return this._706694561scenarioProvider;
      }
      
      private function set scenarioProvider(param1:ArrayList) : void
      {
         var _loc2_:Object = this._706694561scenarioProvider;
         if(_loc2_ !== param1)
         {
            this._706694561scenarioProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scenarioProvider",_loc2_,param1));
            }
         }
      }
   }
}
