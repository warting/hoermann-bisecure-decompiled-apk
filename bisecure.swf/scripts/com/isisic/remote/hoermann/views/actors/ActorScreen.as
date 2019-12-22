package com.isisic.remote.hoermann.views.actors
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.components.ArrowComponent;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.group.AddGroupBox;
   import com.isisic.remote.hoermann.components.popups.group.EditGroupBox;
   import com.isisic.remote.hoermann.components.popups.group.LearnPortsBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.UserDataStorage;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.PortCleaner;
   import com.isisic.remote.hoermann.global.helper.StateHelper;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.net.HmProcessorEvent;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import com.isisic.remote.hoermann.views.channels.ChannelScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.View;
   import spark.events.PopUpEvent;
   import spark.events.ViewNavigatorEvent;
   
   use namespace mx_internal;
   
   public class ActorScreen extends View implements IBindingClient
   {
      
      public static const MAX_CHANNELS:int = AppData.MAX_PORTS;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ActorScreen_Group1:Group;
      
      private var _371838003actorList:HmList;
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205678947btnBack:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _1269202576helpAddGW:Label;
      
      private var _1269634376helpArrow:ArrowComponent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1941352698actorProvider:ArrayCollection;
      
      private var context:ConnectionContext;
      
      private var timeoutTimer:Timer;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ActorScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ActorScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_actors_ActorScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ActorScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._ActorScreen_Button1_i()];
         this.actionContent = [this._ActorScreen_Button2_i(),this._ActorScreen_Button3_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ActorScreen_Array3_c);
         this.addEventListener("initialize",this.___ActorScreen_View1_initialize);
         this.addEventListener("viewActivate",this.___ActorScreen_View1_viewActivate);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ActorScreen._watcherSetupUtil = param1;
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
      
      private function shouldEnableAdd() : Boolean
      {
         if(Features.addDevicePortal)
         {
            return true;
         }
         return HoermannRemote.appData.activeConnection.connectionType == ConnectionTypes.LOCAL;
      }
      
      private function initComp() : void
      {
      }
      
      private function onRefresh(param1:BottomBarEvent) : void
      {
         this.loadTransitions();
      }
      
      private function get portCount() : int
      {
         return HoermannRemote.gatewayData.portCount;
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
         HoermannRemote.app.editMode = this.btnEdit.getStyle("chromeAlpha");
      }
      
      private function loadTransitions() : void
      {
         var _loc1_:HmProcessor = HmProcessor.defaultProcessor;
         _loc1_.addEventListener(HmProcessorEvent.TRANSITIONS_UPDATED,this.onTransitionCollected);
         if(_loc1_.requestTransition())
         {
         }
      }
      
      private function onTransitionCollected(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            param1.currentTarget.removeEventListener(HmProcessorEvent.TRANSITIONS_UPDATED,this.onTransitionCollected);
         }
         for each(_loc2_ in this.actorProvider.toArray())
         {
            _loc2_.state = StateHelper.getStateLabel(_loc2_);
            _loc2_.stateValue = StateHelper.getStateValue(_loc2_);
         }
         this.actorProvider.refresh();
      }
      
      private function onCreationComple() : void
      {
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
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
         var changed:Function = null;
         var event:Event = param1;
         if(event)
         {
            HoermannRemote.gatewayData.removeEventListener(GatewayData.GROUPS_CHANGED,this.onGroupsCollected);
         }
         if(HoermannRemote.gatewayData.values == null)
         {
            HoermannRemote.gatewayData.addEventListener(GatewayData.VALUES_CHANGED,changed = function(param1:Event):void
            {
               mergeGroupValues();
               onGroupsConverted();
            });
            HoermannRemote.gatewayData.updateValues(this.context);
         }
         else
         {
            this.mergeGroupValues();
            this.onGroupsConverted();
         }
      }
      
      private function mergeGroupValues() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in HoermannRemote.gatewayData.groups)
         {
            if(!_loc1_.type || _loc1_.type < 0)
            {
               _loc1_.type = HoermannRemote.gatewayData.values[_loc1_.id];
            }
         }
      }
      
      protected function onGroupsConverted() : void
      {
         var _loc1_:Object = null;
         var _loc2_:HmProcessor = null;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
         this.actorProvider.removeAll();
         for each(_loc1_ in HoermannRemote.gatewayData.groups)
         {
            _loc1_.state = StateHelper.getStateLabel(_loc1_);
            _loc1_.stateValue = StateHelper.getStateValue(_loc1_);
            this.actorProvider.addItem(_loc1_);
         }
         _loc2_ = HmProcessor.defaultProcessor;
         if(_loc2_.transitionCollectingActive)
         {
            _loc2_.addEventListener(HmProcessorEvent.TRANSITIONS_UPDATED,this.onTransitionCollected);
         }
         UserDataStorage.currentStorage.setActors(HoermannRemote.gatewayData.groups);
         HoermannRemote.loadBox.close();
      }
      
      protected function onActorSelect(param1:Event) : void
      {
         if(HoermannRemote.app.editMode)
         {
            param1.preventDefault();
            return;
         }
         HmProcessor.defaultProcessor.cancelCollecting([this.actorList.selectedItem.id]);
         this.navigator.pushView(ChannelScreen,this.actorList.selectedItem);
      }
      
      protected function onActorEdit(param1:Event) : void
      {
         var _loc3_:Object = null;
         var _loc4_:EditGroupBox = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.actorProvider.toArray())
         {
            _loc2_.push(_loc3_.id);
         }
         _loc4_ = new EditGroupBox(param1.target.data,this.context,_loc2_);
         _loc4_.addEventListener(PopUpEvent.CLOSE,this.onGroupEdited);
         _loc4_.open(null);
      }
      
      protected function onGroupEdited(param1:PopUpEvent) : void
      {
         this.toggleEdit();
         if(!param1.commit)
         {
            this.actorProvider.removeItem(param1.data);
            this.loadTransitions();
            ArrayHelper.removeItem(param1.data.id,HoermannRemote.gatewayData.userRights);
            dispatchEvent(new Event("addButtonHelpVisible"));
         }
      }
      
      protected function onAdd() : void
      {
         HoermannRemote.loadBox.title = Lang.getString("CLEANING_PORTS");
         HoermannRemote.loadBox.contentText = Lang.getString("CLEANING_PORTS_CONTENT");
         HoermannRemote.loadBox.open(null);
         var _loc1_:PortCleaner = new PortCleaner(this.context);
         _loc1_.addEventListener(Event.COMPLETE,this.onPortsCleaned);
         _loc1_.searchDeadPorts();
      }
      
      private function onPortsCleaned(param1:Event) : void
      {
         HoermannRemote.loadBox.close();
         if(this.portCount >= MAX_CHANNELS)
         {
            HoermannRemote.errorBox.title = Lang.getString("MAX_PORTS_REACHED");
            HoermannRemote.errorBox.contentText = Lang.getString("MAX_PORTS_REACHED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         var _loc2_:AddGroupBox = new AddGroupBox();
         _loc2_.addEventListener(PopUpEvent.CLOSE,this.onGroupNameSelected);
         _loc2_.open(HoermannRemote.app);
      }
      
      protected function onGroupNameSelected(param1:PopUpEvent) : void
      {
         var isRequestable:Boolean = false;
         var tmrEvent:Function = null;
         var tmr:Timer = null;
         var event:PopUpEvent = param1;
         (event.currentTarget as Popup).removeEventListener(PopUpEvent.CLOSE,this.onGroupNameSelected);
         if(!event.commit)
         {
            return;
         }
         isRequestable = (event.currentTarget as AddGroupBox).shouldRequest;
         var popup:LearnPortsBox = new LearnPortsBox(event.data,this.context,isRequestable);
         popup.addEventListener(PopUpEvent.CLOSE,this.onGroupAdded);
         popup.open(null);
         tmr = new Timer(20,1);
         tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmrEvent = function(param1:Event):void
         {
            tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmrEvent);
            InfoCenter.createGroup(event.data.type,isRequestable);
         });
         tmr.start();
      }
      
      protected function onGroupAdded(param1:PopUpEvent) : void
      {
         if(!param1.commit)
         {
            return;
         }
         var _loc2_:HmGroup = HmGroup.fromObject(param1.data);
         HoermannRemote.gatewayData.groups.push(_loc2_);
         HoermannRemote.gatewayData.userRights.push(_loc2_.id);
         this.actorProvider.addItem(_loc2_);
         dispatchEvent(new Event("addButtonHelpVisible"));
      }
      
      [Bindable("addButtonHelpVisible")]
      protected function addButtonHelpVisible() : Boolean
      {
         return (HoermannRemote.gatewayData.userRights == null || HoermannRemote.gatewayData.userRights.length <= 0) && this.btnAdd.visible && this.btnAdd.enabled;
      }
      
      private function _ActorScreen_Button1_i() : Button
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
      
      private function _ActorScreen_Button2_i() : Button
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
      
      private function _ActorScreen_Button3_i() : Button
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
      
      private function _ActorScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._ActorScreen_GatewayDisplay1_i(),this._ActorScreen_Group1_i(),this._ActorScreen_HmList1_i(),this._ActorScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _ActorScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _ActorScreen_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._ActorScreen_ArrowComponent1_i(),this._ActorScreen_Label1_i()];
         _loc1_.id = "_ActorScreen_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ActorScreen_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_ActorScreen_Group1",this._ActorScreen_Group1);
         return _loc1_;
      }
      
      private function _ActorScreen_ArrowComponent1_i() : ArrowComponent
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
      
      private function _ActorScreen_Label1_i() : Label
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
      
      private function _ActorScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.labelField = "name";
         _loc1_.itemRenderer = this._ActorScreen_ClassFactory1_c();
         _loc1_.id = "actorList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.actorList = _loc1_;
         BindingManager.executeBindings(this,"actorList",this.actorList);
         return _loc1_;
      }
      
      private function _ActorScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ActorRenderer;
         return _loc1_;
      }
      
      private function _ActorScreen_BottomBar1_i() : BottomBar
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
      
      public function ___ActorScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___ActorScreen_View1_viewActivate(param1:ViewNavigatorEvent) : void
      {
         this.onCreationComple();
      }
      
      private function _ActorScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("ACTORS");
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
         result[3] = new Binding(this,function():Boolean
         {
            return HoermannRemote.appData.isAdmin;
         },null,"btnEdit.visible");
         result[4] = new Binding(this,function():Boolean
         {
            return shouldEnableAdd();
         },null,"btnEdit.enabled");
         result[5] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgAdd);
         },function(param1:Object):void
         {
            btnAdd.setStyle("icon",param1);
         },"btnAdd.icon");
         result[6] = new Binding(this,function():Boolean
         {
            return HoermannRemote.appData.isAdmin;
         },null,"btnAdd.visible");
         result[7] = new Binding(this,function():Boolean
         {
            return shouldEnableAdd();
         },null,"btnAdd.enabled");
         result[8] = new Binding(this,function():Boolean
         {
            return addButtonHelpVisible();
         },null,"_ActorScreen_Group1.visible");
         result[9] = new Binding(this,null,null,"helpArrow.sourcePointer","helpAddGW");
         result[10] = new Binding(this,null,null,"helpArrow.destinationPointer","btnAdd");
         result[11] = new Binding(this,function():Number
         {
            return helpArrow.height;
         },null,"helpArrow.width");
         result[12] = new Binding(this,function():Number
         {
            return helpAddGW.y + helpAddGW.height;
         },null,"helpArrow.height");
         result[13] = new Binding(this,null,null,"helpArrow.controlX","btnAdd");
         result[14] = new Binding(this,null,null,"helpArrow.controlY","helpAddGW");
         result[15] = new Binding(this,function():Number
         {
            return height * 0.05;
         },null,"helpAddGW.y");
         result[16] = new Binding(this,function():Object
         {
            return helpArrow.width;
         },null,"helpAddGW.right");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("ACTORS_ADD_HELP");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"helpAddGW.text");
         result[18] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"actorList.top");
         result[19] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"actorList.bottom");
         result[20] = new Binding(this,function():IList
         {
            return this.actorProvider;
         },null,"actorList.dataProvider");
         result[21] = new Binding(this,function():Boolean
         {
            return !HmProcessor.defaultProcessor.transitionCollectingActive;
         },null,"bbar.refreshEnabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get actorList() : HmList
      {
         return this._371838003actorList;
      }
      
      public function set actorList(param1:HmList) : void
      {
         var _loc2_:Object = this._371838003actorList;
         if(_loc2_ !== param1)
         {
            this._371838003actorList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actorList",_loc2_,param1));
            }
         }
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
      private function get actorProvider() : ArrayCollection
      {
         return this._1941352698actorProvider;
      }
      
      private function set actorProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1941352698actorProvider;
         if(_loc2_ !== param1)
         {
            this._1941352698actorProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actorProvider",_loc2_,param1));
            }
         }
      }
   }
}
