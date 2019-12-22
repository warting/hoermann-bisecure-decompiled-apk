package com.isisic.remote.hoermann.views.options.settings.user
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.EditUsersScreenOverlay;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.components.popups.users.CreateUserBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.events.HmUserEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit.UserEditFeatures;
   import com.isisic.remote.hoermann.net.NetErrors;
   import com.isisic.remote.hoermann.net.dao.users.GatewayUsers;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.EventPriority;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class EditUsersScreen extends View implements IBindingClient
   {
      
      public static const MAX_USER_COUNT:int = GatewayUsers.MAX_USER_COUNT;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205678947btnBack:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _266718455userList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _987494927provider:ArrayCollection;
      
      private var _2084580437gatewayProvider:ArrayList;
      
      private var editBox:CreateUserBox;
      
      private var context:ConnectionContext;
      
      private var usrPointer:int = 0;
      
      private var usr:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function EditUsersScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.usr = [{
            "name":"benutzer1",
            "pwd":"1234"
         },{
            "name":"benutzer2",
            "pwd":"1234"
         },{
            "name":"benutzer3",
            "pwd":"1234"
         },{
            "name":"benutzer4",
            "pwd":"1234"
         },{
            "name":"benutzer5",
            "pwd":"1234"
         },{
            "name":"benutzer6",
            "pwd":"1234"
         },{
            "name":"benutzer7",
            "pwd":"1234"
         },{
            "name":"benutzer8",
            "pwd":"1234"
         },{
            "name":"benutzer9",
            "pwd":"1234"
         },{
            "name":"benutzerA",
            "pwd":"1234"
         }];
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._EditUsersScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_settings_user_EditUsersScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return EditUsersScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._EditUsersScreen_Button1_i()];
         this.actionContent = [this._EditUsersScreen_Button2_i(),this._EditUsersScreen_Button3_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._EditUsersScreen_Array3_c);
         this.addEventListener("initialize",this.___EditUsersScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         EditUsersScreen._watcherSetupUtil = param1;
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
         this.context = HoermannRemote.appData.activeConnection;
         UserEditFeatures.feature.loadUsersCallback = this.loadUsers;
         UserEditFeatures.feature.toggleEditCallback = this.toggleEdit;
         this.editBox = new CreateUserBox();
         this.editBox.addEventListener(Event.COMPLETE,this.onUserAdd,false,EventPriority.DEFAULT,true);
         this.userList.addEventListener(IndexChangeEvent.CHANGING,this.onIndexChanging);
         this.userList.addEventListener(HmUserEvent.DELETE,this.onDeleteUser);
         this.loadUsers();
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            new EditUsersScreenOverlay(btnBack,btnAdd,btnEdit,bbar.callout).open(null);
         });
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
      
      private function loadUsers() : void
      {
         var timeoutTimer:AutoDisposeTimer = null;
         var self:EditUsersScreen = null;
         this.btnAdd.enabled = false;
         HoermannRemote.loadBox.title = Lang.getString("LOAD_USERS_TITLE");
         HoermannRemote.loadBox.contentText = Lang.getString("LOAD_USERS_CONTENT");
         HoermannRemote.loadBox.open(HoermannRemote.app,false);
         timeoutTimer = new AutoDisposeTimer(HoermannRemote.GROUP_LOADING_TIMEOUT,this.onTimeout);
         timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         timeoutTimer.start();
         self = this;
         GatewayUsers.instance.refreshCache(function(param1:Error):void
         {
            if(param1 != null)
            {
               return;
            }
            timeoutTimer.reset();
            self.provider = new ArrayCollection(GatewayUsers.instance.getUsers());
            self.btnAdd.enabled = true;
            HoermannRemote.loadBox.close(true);
         });
      }
      
      private function onIndexChanging(param1:IndexChangeEvent) : void
      {
         param1.preventDefault();
         if(HoermannRemote.app.editMode)
         {
            return;
         }
         this.setRights(this.userList.selectedItem);
      }
      
      protected function onDeleteUser(param1:Event) : void
      {
         UserEditFeatures.feature.onClick(param1);
      }
      
      private function onDeleteCommit(param1:PopUpEvent) : void
      {
         var event:PopUpEvent = param1;
         HoermannRemote.confirmBox.removeEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         this.toggleEdit();
         if(!event.commit)
         {
            return;
         }
         if(!event.data)
         {
            return;
         }
         GatewayUsers.instance.deleteUser(event.data,function(param1:User, param2:Error):void
         {
            if(param2.errorID == NetErrors.NETWORK_TIMEOUT)
            {
               InfoCenter.onNetTimeout();
            }
         });
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
      
      private function onAddClick(param1:MouseEvent) : void
      {
         if(param1.altKey)
         {
            this.debuggingAdd();
         }
         if(this.provider.length >= MAX_USER_COUNT)
         {
            HoermannRemote.errorBox.title = Lang.getString("MAX_USERS_REACHED");
            HoermannRemote.errorBox.contentText = Lang.getString("MAX_USERSS_REACHED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         this.editBox.open(null);
      }
      
      private function debuggingAdd() : void
      {
         if(this.usrPointer >= this.usr.length)
         {
            this.usrPointer = 0;
         }
         else
         {
            GatewayUsers.instance.createUser(this.usr[this.usrPointer].name,this.usr[this.usrPointer].pwd,function(param1:User, param2:Error):void
            {
               if(param2 == null)
               {
                  usrPointer++;
                  debuggingAdd();
               }
            });
         }
      }
      
      private function onUserAdd(param1:Event) : void
      {
         var self:EditUsersScreen = null;
         var event:Event = param1;
         var popup:CreateUserBox = event.currentTarget as CreateUserBox;
         self = this;
         GatewayUsers.instance.createUser(popup.username,popup.password,function(param1:User, param2:Error):void
         {
            if(param2 == null)
            {
               provider.refresh();
               if(self.navigator)
               {
                  self.navigator.pushView(SetUserRightScreen,param1);
               }
               else
               {
                  Debug.warning("[EditUsersScreen] could not change screen (navigator not found!)");
               }
            }
            else if(param2.errorID == NetErrors.NETWORK_TIMEOUT)
            {
               InfoCenter.onNetTimeout();
            }
         });
      }
      
      private function setRights(param1:Object) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(param1.id > 0)
         {
            this.navigator.pushView(SetUserRightScreen,param1);
         }
         else
         {
            HoermannRemote.errorBox.title = Lang.getString("ERROR_SET_ADMIN_RIGHTS");
            HoermannRemote.errorBox.contentText = Lang.getString("ERROR_SET_ADMIN_RIGHTS_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
         }
      }
      
      private function _EditUsersScreen_Button1_i() : Button
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
      
      private function _EditUsersScreen_Button2_i() : Button
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
      
      private function _EditUsersScreen_Button3_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.enabled = false;
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
         this.onAddClick(param1);
      }
      
      private function _EditUsersScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._EditUsersScreen_GatewayDisplay1_i(),this._EditUsersScreen_HmList1_i(),this._EditUsersScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _EditUsersScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _EditUsersScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.labelField = "name";
         _loc1_.itemRenderer = this._EditUsersScreen_ClassFactory1_c();
         _loc1_.id = "userList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.userList = _loc1_;
         BindingManager.executeBindings(this,"userList",this.userList);
         return _loc1_;
      }
      
      private function _EditUsersScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = UserRenderer;
         return _loc1_;
      }
      
      private function _EditUsersScreen_BottomBar1_i() : BottomBar
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
      
      public function ___EditUsersScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      private function _EditUsersScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_EDIT_USERS_TITLE");
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
         result[4] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"userList.top");
         result[5] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"userList.bottom");
         result[6] = new Binding(this,function():IList
         {
            return this.provider;
         },null,"userList.dataProvider");
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
      public function get userList() : HmList
      {
         return this._266718455userList;
      }
      
      public function set userList(param1:HmList) : void
      {
         var _loc2_:Object = this._266718455userList;
         if(_loc2_ !== param1)
         {
            this._266718455userList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get provider() : ArrayCollection
      {
         return this._987494927provider;
      }
      
      private function set provider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._987494927provider;
         if(_loc2_ !== param1)
         {
            this._987494927provider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"provider",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get gatewayProvider() : ArrayList
      {
         return this._2084580437gatewayProvider;
      }
      
      private function set gatewayProvider(param1:ArrayList) : void
      {
         var _loc2_:Object = this._2084580437gatewayProvider;
         if(_loc2_ !== param1)
         {
            this._2084580437gatewayProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gatewayProvider",_loc2_,param1));
            }
         }
      }
   }
}
