package refactor.bisecur._1_APP.views.manageUsers
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.collections.ArrayCollection;
   import mx.core.EventPriority;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.EditUsersScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._1_APP.components.popups.users.CreateUserBox;
   import refactor.bisecur._1_APP.views.manageUsers.manageUserRights.UserRightsScreen;
   import refactor.bisecur._1_APP.views.manageUsers.renderer.UserRendererItem;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit.IUserEditFeature;
   import refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit.UserEditFeatures;
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._2_SAL.net.cache.users.GatewayUsers;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._5_UTIL.Log;
   import spark.events.IndexChangeEvent;
   
   public class ManageUsersScreenCtrl implements IEventDispatcher
   {
      
      private static const GROUP_LOADING_TIMEOUT:int = 15000;
       
      
      public var Icon_Back:IVisualElement;
      
      public var Icon_Edit:IVisualElement;
      
      public var Icon_Add:IVisualElement;
      
      private var _80818744Title:String;
      
      private var _96312495listProvider:ArrayCollection;
      
      public var view:ManageUsersScreen;
      
      private var context:ConnectionContext;
      
      private var userEditFeature:IUserEditFeature;
      
      private var editBox:CreateUserBox;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function ManageUsersScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this.Icon_Edit = MultiDevice.getFxg(ImgEdit);
         this.Icon_Add = MultiDevice.getFxg(ImgAdd);
         this._80818744Title = Lang.getString("OPTIONS_EDIT_USERS_TITLE");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onInit() : void
      {
         this.context = AppCache.sharedCache.connection;
         this.openLoadBox();
         Promise.all([this.loadFeatures(),this.loadUsers()]).always(function():*
         {
            LoadBox.sharedBox.close();
         });
         this.editBox = new CreateUserBox();
         this.editBox.addEventListener(Event.COMPLETE,this.onUserAdd,false,EventPriority.DEFAULT,true);
         this.loadUsers();
      }
      
      private function openLoadBox() : void
      {
         var _loc1_:LoadBox = LoadBox.sharedBox;
         _loc1_.title = Lang.getString("LOAD_USERS_TITLE");
         _loc1_.contentText = Lang.getString("LOAD_USERS_CONTENT");
         _loc1_.open(null);
      }
      
      private function loadFeatures() : Promise
      {
         var deferred:Deferred = null;
         deferred = new Deferred();
         UserEditFeatures.loadFeature(function(param1:IUserEditFeature):void
         {
            userEditFeature = param1;
            param1.loadUsersCallback = loadUsers;
            param1.toggleEditCallback = onToggleEdit_Click;
            Log.debug("[ManageUsersScreenCtrl] resolve features");
            deferred.resolve(param1);
         });
         return deferred.promise;
      }
      
      private function loadUsers() : Promise
      {
         var deferred:Deferred = null;
         var timeoutTimer:AutoDisposeTimer = null;
         deferred = new Deferred();
         this.view.btnAdd.enabled = false;
         timeoutTimer = new AutoDisposeTimer(GROUP_LOADING_TIMEOUT,this.onTimeout);
         timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         timeoutTimer.start();
         GatewayUsers.instance.refreshCache(function(param1:Error):void
         {
            var error:Error = param1;
            if(error != null)
            {
               Log.debug("[ManageUsersScreenCtrl] reject users");
               deferred.reject(false);
               return;
            }
            timeoutTimer.reset();
            var listItems:Array = GatewayUsers.instance.getUsers().map(function(param1:User, param2:int, param3:Array):UserRendererItem
            {
               return UserRendererItem.create(param1,userEditFeature);
            });
            listProvider = new ArrayCollection(listItems);
            view.btnAdd.enabled = true;
            Log.debug("[ManageUsersScreenCtrl] resolve users");
            deferred.resolve(true);
         });
         return deferred.promise;
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         (param1.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         var _loc2_:LoadBox = LoadBox.sharedBox;
         if(!_loc2_.isOpen)
         {
            return;
         }
         _loc2_.close();
         var _loc3_:ErrorBox = ErrorBox.sharedBox;
         _loc3_.title = Lang.getString("ERROR_TIMEOUT");
         _loc3_.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         _loc3_.closeable = true;
         _loc3_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc3_.open(null);
         this.view.navigator.popView();
      }
      
      public function onToggleEdit_Click() : void
      {
         if(UserRendererItem.getEditMode())
         {
            this.view.btnEdit.setStyle("chromeAlpha",0);
         }
         else
         {
            this.view.btnEdit.setStyle("chromeAlpha",1);
         }
         UserRendererItem.toggleEditMode();
      }
      
      public function onAddClick(param1:MouseEvent) : void
      {
         var _loc2_:ErrorBox = null;
         if(param1.altKey)
         {
            new BatchUserAdd().batchAdd();
         }
         if(this.listProvider.length >= GatewayUsers.MAX_USER_COUNT)
         {
            _loc2_ = ErrorBox.sharedBox;
            _loc2_.title = Lang.getString("MAX_USERS_REACHED");
            _loc2_.contentText = Lang.getString("MAX_USERSS_REACHED_CONTENT");
            _loc2_.closeable = true;
            _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
            _loc2_.open(null);
            return;
         }
         this.editBox.open(null);
      }
      
      private function onUserAdd(param1:Event) : void
      {
         var event:Event = param1;
         var popup:CreateUserBox = event.currentTarget as CreateUserBox;
         GatewayUsers.instance.createUser(popup.username,popup.password,function(param1:User, param2:Error):void
         {
            if(param2 == null)
            {
               listProvider.refresh();
               if(view.navigator)
               {
                  view.navigator.pushView(UserRightsScreen,param1);
               }
               else
               {
                  Log.warning("[EditUsersScreen] could not change screen (navigator not found!)");
               }
            }
            else if(param2.errorID == NetErrors.NETWORK_TIMEOUT)
            {
               InfoCenter.onNetTimeout();
            }
         });
      }
      
      public function onHelp() : void
      {
         new EditUsersScreenOverlay(this.view.btnBack,this.view.btnAdd,this.view.btnEdit,this.view.bbar.callout).open(null);
      }
      
      public function onSelect(param1:IndexChangeEvent) : void
      {
         var _loc2_:UserRendererItem = null;
         param1.preventDefault();
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(UserRendererItem.getEditMode())
         {
            _loc2_ = this.view.userList.selectedItem;
            this.userEditFeature.onClick(param1,_loc2_.user);
            return;
         }
         this.setRights(this.view.userList.selectedItem);
      }
      
      private function setRights(param1:UserRendererItem) : void
      {
         var _loc2_:ErrorBox = null;
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(param1.user.id > 0)
         {
            this.view.navigator.pushView(UserRightsScreen,param1.user);
         }
         else
         {
            _loc2_ = ErrorBox.sharedBox;
            _loc2_.title = Lang.getString("ERROR_SET_ADMIN_RIGHTS");
            _loc2_.contentText = Lang.getString("ERROR_SET_ADMIN_RIGHTS_CONTENT");
            _loc2_.closeable = true;
            _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
            _loc2_.open(null);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get Title() : String
      {
         return this._80818744Title;
      }
      
      public function set Title(param1:String) : void
      {
         var _loc2_:Object = this._80818744Title;
         if(_loc2_ !== param1)
         {
            this._80818744Title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get listProvider() : ArrayCollection
      {
         return this._96312495listProvider;
      }
      
      public function set listProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._96312495listProvider;
         if(_loc2_ !== param1)
         {
            this._96312495listProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listProvider",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

import refactor.bisecur._2_SAL.gatewayData.User;
import refactor.bisecur._2_SAL.net.cache.users.GatewayUsers;

class BatchUserAdd
{
    
   
   private var usrPointer:int = 0;
   
   private var usr:Array;
   
   function BatchUserAdd()
   {
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
      super();
   }
   
   public function batchAdd() : void
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
               batchAdd();
            }
         });
      }
   }
}
