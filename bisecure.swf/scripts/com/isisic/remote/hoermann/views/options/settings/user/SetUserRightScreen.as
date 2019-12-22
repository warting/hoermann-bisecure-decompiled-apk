package com.isisic.remote.hoermann.views.options.settings.user
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.SetUserRightsScreenOverlay;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
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
   import spark.components.View;
   
   use namespace mx_internal;
   
   public class SetUserRightScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _206185977btnSave:Button;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _1569359654rightList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var context:ConnectionContext;
      
      private var timeoutTimer:Timer;
      
      private var _2081443885rightProvider:ArrayCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SetUserRightScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._SetUserRightScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_settings_user_SetUserRightScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SetUserRightScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._SetUserRightScreen_Button1_i()];
         this.actionContent = [this._SetUserRightScreen_Button2_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SetUserRightScreen_Array3_c);
         this.addEventListener("initialize",this.___SetUserRightScreen_View1_initialize);
         this.addEventListener("creationComplete",this.___SetUserRightScreen_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SetUserRightScreen._watcherSetupUtil = param1;
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
      
      private function initComp(param1:FlexEvent) : void
      {
         var event:FlexEvent = param1;
         this.context = HoermannRemote.appData.activeConnection;
         this.rightProvider = new ArrayCollection();
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            new SetUserRightsScreenOverlay(btnBack,btnSave,bbar.callout).open(null);
         });
      }
      
      private function onCreationComple() : void
      {
         HoermannRemote.loadBox.title = Lang.getString("LOADING_GROUPS_TITLE");
         HoermannRemote.loadBox.contentText = Lang.getString("LOADING_GROUPS_CONTENT");
         HoermannRemote.loadBox.open(null);
         this.timeoutTimer = new Timer(HoermannRemote.GROUP_LOADING_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         if(!HoermannRemote.gatewayData.groups)
         {
            HoermannRemote.gatewayData.addEventListener(GatewayData.GROUPS_CHANGED,this.onGroupsCollected);
            HoermannRemote.gatewayData.updateGroups(this.context,HoermannRemote.appData.userId);
         }
         else
         {
            this.onGroupsCollected();
         }
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
         this.navigator.popView();
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
               HoermannRemote.gatewayData.removeEventListener(GatewayData.VALUES_CHANGED,changed);
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
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
         var _loc1_:Array = new Array();
         this.rightProvider.removeAll();
         for each(_loc2_ in HoermannRemote.gatewayData.groups)
         {
            this.rightProvider.addItem(_loc2_);
            if(this.data.groups)
            {
               for each(_loc3_ in this.data.groups)
               {
                  if(_loc3_ == _loc2_.id)
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
         }
         this.rightList.selectedItems = Vector.<Object>(_loc1_);
         HoermannRemote.loadBox.close();
      }
      
      protected function onSaveClick(param1:MouseEvent) : void
      {
         var group:HmGroup = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:MouseEvent = param1;
         var groupIds:Array = new Array();
         for each(group in this.rightList.selectedItems)
         {
            groupIds.push(group.id);
         }
         HoermannRemote.loadBox.title = Lang.getString("SAVING_USER_RIGHTS");
         HoermannRemote.loadBox.contentText = Lang.getString("SAVING_USER_RIGHTS_CONTENT");
         HoermannRemote.loadBox.open(null);
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(loader.data.command == Commands.SET_USER_RIGHTS)
            {
               HoermannRemote.loadBox.close();
               navigator.popView();
            }
            else if(loader.data.command == Commands.ERROR)
            {
               HoermannRemote.errorBox.title = Lang.getString("ERROR");
               HoermannRemote.errorBox.contentText = Lang.getString("ERROR_SETTING_NAME");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_CLOSE");
               HoermannRemote.errorBox.open(null);
            }
            else
            {
               Debug.warning("[SetUserRightScreen] unexpected respone (for SetUserRights)! mcp:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[SetUserRightScreen] requesting SetUserRights failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_USER_RIGHTS,MCPBuilder.payloadSetUserRights(this.data.id,groupIds)));
      }
      
      private function _SetUserRightScreen_Button1_i() : Button
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
      
      private function _SetUserRightScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
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
         this.onSaveClick(param1);
      }
      
      private function _SetUserRightScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._SetUserRightScreen_GatewayDisplay1_i(),this._SetUserRightScreen_HmList1_i(),this._SetUserRightScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _SetUserRightScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _SetUserRightScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.labelField = "name";
         _loc1_.itemRenderer = this._SetUserRightScreen_ClassFactory1_c();
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
      
      private function _SetUserRightScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = UserRightRenderer;
         return _loc1_;
      }
      
      private function _SetUserRightScreen_BottomBar1_i() : BottomBar
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
      
      public function ___SetUserRightScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp(param1);
      }
      
      public function ___SetUserRightScreen_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComple();
      }
      
      private function _SetUserRightScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_SET_USER_RIGHTS");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_SAVE");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnSave.label");
         result[3] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"rightList.top");
         result[4] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"rightList.bottom");
         result[5] = new Binding(this,function():IList
         {
            return this.rightProvider;
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
      
      [Bindable(event="propertyChange")]
      private function get rightProvider() : ArrayCollection
      {
         return this._2081443885rightProvider;
      }
      
      private function set rightProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2081443885rightProvider;
         if(_loc2_ !== param1)
         {
            this._2081443885rightProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightProvider",_loc2_,param1));
            }
         }
      }
   }
}
