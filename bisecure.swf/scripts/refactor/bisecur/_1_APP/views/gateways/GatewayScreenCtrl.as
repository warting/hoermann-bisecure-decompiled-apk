package refactor.bisecur._1_APP.views.gateways
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgPrefs;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.GatewayScreenOverlay;
   import refactor.bisecur._1_APP.components.overlays.screens.HelpOverlay;
   import refactor.bisecur._1_APP.components.popups.AgreementBox;
   import refactor.bisecur._1_APP.components.popups.ConfirmBox;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._1_APP.components.popups.portal.SetPortalCredentialsBox;
   import refactor.bisecur._1_APP.views.bootloader.Bootloader;
   import refactor.bisecur._1_APP.views.deviceList.DeviceListScreen;
   import refactor.bisecur._1_APP.views.gateways.renderer.GatewayRendererItem;
   import refactor.bisecur._1_APP.views.home.HomeScreen;
   import refactor.bisecur._1_APP.views.viewActions.forward.ForwardViewAction;
   import refactor.bisecur._1_APP.views.viewActions.forward.ForwardViewActionItem;
   import refactor.bisecur._2_SAL.dao.AppSettingDAO;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.GatewayDAO;
   import refactor.bisecur._2_SAL.dao.UserLoginDAO;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.gwFirmwareFeatures.FirmwareFeatures;
   import refactor.bisecur._2_SAL.portal.PortalCredentials;
   import refactor.logicware._2_SAL.GatewayExplorer;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.StringHelper;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   public class GatewayScreenCtrl implements IDisposable, IEventDispatcher
   {
       
      
      public const Title:String = Lang.getString("SELECT_GATEWAY");
      
      public const EditIcon:IVisualElement = MultiDevice.getFxg(ImgEdit);
      
      public const AddIcon:IVisualElement = MultiDevice.getFxg(ImgAdd);
      
      public const PortalSettingsIcon:IVisualElement = MultiDevice.getFxg(ImgPrefs);
      
      public const Locales:Object = {
         "ADD_HELP":Lang.getString("GATEWAY_SCREEN_ADD_HELP"),
         "NO_GATEWAYS":Lang.getString("GATEWAY_SCREEN_NO_GATEWAYS_CONTENT")
      };
      
      private var _96312495listProvider:ArrayCollection;
      
      public var view:GatewayScreen;
      
      private var explorer:GatewayExplorer;
      
      private var gatewayDAO:GatewayDAO;
      
      private var appSettingDAO:AppSettingDAO;
      
      private var isActive:Boolean = false;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function GatewayScreenCtrl()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.explorer = GatewayExplorer.sharedExplorer;
         this.gatewayDAO = DAOFactory.getGatewayDAO();
         this.appSettingDAO = DAOFactory.getAppSettingDAO();
      }
      
      private function setDemoDefaultLogin() : void
      {
         var _loc1_:GatewayDAO = DAOFactory.getGatewayDAO();
         var _loc2_:UserLoginDAO = DAOFactory.getUserLoginDAO();
         var _loc3_:AppSettingDAO = DAOFactory.getAppSettingDAO();
         var _loc4_:Gateway = new Gateway();
         _loc4_.name = "Zu Hause";
         _loc4_.mac = "D88039BD47D8";
         var _loc5_:User = User.createByCredentials("admin","1234",_loc4_);
         _loc1_.setGateway(_loc4_);
         _loc2_.setUser(_loc5_);
         _loc3_.setDefaultGateway(_loc4_);
      }
      
      private function reloadListProvider() : void
      {
         this.listProvider = new ArrayCollection(this.gatewayDAO.getGateways().map(function(param1:Gateway, param2:int, param3:Array):GatewayRendererItem
         {
            var _loc4_:* = new GatewayInfos();
            _loc4_.gateway = param1;
            _loc4_.isAvailable = false;
            return GatewayRendererItem.create(_loc4_);
         }));
      }
      
      public function onInit() : void
      {
         var _loc1_:AgreementBox = null;
         this.reloadListProvider();
         GatewayDisplay.description = "";
         this.view.bbar.addEventListener(BottomBarEvent.HELP,this.onHelp);
         if(!this.appSettingDAO.getHelpOverlayShown())
         {
            new HelpOverlay(this.view.bbar.help).open(null);
            this.appSettingDAO.setHelpOverlayShown(true);
         }
         if(!this.appSettingDAO.getTermsAccepted())
         {
            _loc1_ = new AgreementBox(true);
            _loc1_.open(null);
         }
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
         new GatewayScreenOverlay(this.view.btnEdit,this.view.btnAdd,this.view.btnPortal,this.view.bbar.email,this.view.bbar.callout).open(null);
      }
      
      public function onActivate() : void
      {
         this.isActive = true;
         this.findGatewaysLoop();
      }
      
      public function onDeactivate() : void
      {
         this.isActive = false;
      }
      
      public function onPortalSettings_Click(param1:MouseEvent, param2:Boolean = false) : void
      {
         var _loc3_:SetPortalCredentialsBox = new SetPortalCredentialsBox();
         _loc3_.addEventListener(PopUpEvent.CLOSE,this.onPortalIdAdded);
         _loc3_.open(null);
         this.onDeactivate();
      }
      
      private function onPortalIdAdded(param1:PopUpEvent) : void
      {
         param1.currentTarget.removeEventListener(PopUpEvent.CLOSE,this.onPortalIdAdded);
         this.onActivate();
      }
      
      public function onAdd_Click(param1:MouseEvent) : void
      {
         var searchBox:SearchGatewaysPopup = null;
         var event:MouseEvent = param1;
         searchBox = new SearchGatewaysPopup();
         searchBox.open(null);
         new AutoDisposeTimer(5000,function(param1:TimerEvent):void
         {
            var _loc3_:* = undefined;
            var _loc2_:* = [];
            for each(_loc3_ in listProvider)
            {
               if(_loc3_.gatewayInfos.isAvailable)
               {
                  _loc2_.push(_loc3_.gatewayInfos.gateway);
               }
            }
            searchBox.presentScanFinidhed(_loc2_);
         }).start();
      }
      
      public function onAdd_MouseDown(param1:Event) : void
      {
      }
      
      public function onEdit_Toggle() : void
      {
         var _loc1_:Boolean = GatewayRendererItem.toggleEditMode();
         if(_loc1_)
         {
            this.view.btnEdit.setStyle("chromeAlpha",1);
         }
         else
         {
            this.view.btnEdit.setStyle("chromeAlpha",0);
         }
      }
      
      public function onSelect(param1:IndexChangeEvent) : void
      {
         var item:GatewayRendererItem = null;
         var event:IndexChangeEvent = param1;
         var editMode:Boolean = GatewayRendererItem.getEditMode();
         item = this.view.gatewayList.selectedItem;
         if(editMode || item == null || item.gatewayInfos.isAvailable == false)
         {
            if(Features.presenterVersion)
            {
               Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
               event.preventDefault();
               return;
            }
            if(editMode && item != null)
            {
               this.tryDelete(item);
            }
            event.preventDefault();
            return;
         }
         this.onDeactivate();
         LoginHelper#1598.login(item.gatewayInfos,function(param1:Boolean):void
         {
            if(param1)
            {
               onLoginSuccess(item.gatewayInfos.gateway,false);
            }
            else
            {
               onActivate();
            }
            event.preventDefault();
            view.gatewayList.selectedItem = null;
         });
      }
      
      private function onLoginSuccess(param1:Gateway, param2:Boolean) : void
      {
         FirmwareFeatures.resetFeatures();
         var _loc3_:GatewayDAO = DAOFactory.getGatewayDAO();
         _loc3_.setGateway(param1);
         GatewayRendererItem.setEditMode(false);
         var _loc4_:ForwardViewAction = null;
         if(param2)
         {
            _loc4_ = new ForwardViewAction().followPath(new <ForwardViewActionItem>[new ForwardViewActionItem(DeviceListScreen,ForwardViewActionItem.FORWARD_ACTION_PUSH)]);
         }
         this.view.navigator.replaceView(HomeScreen,_loc4_);
         this.dispose();
      }
      
      private function tryDelete(param1:GatewayRendererItem) : void
      {
         var confirmBox:ConfirmBox = null;
         var onConfirm:Function = null;
         var item:GatewayRendererItem = param1;
         confirmBox = new ConfirmBox();
         confirmBox.title = Lang.getString("CONFIRM_DELETE_TITLE");
         confirmBox.contentText = Lang.getString("CONFIRM_DELETE");
         confirmBox.submitTitle = Lang.getString("GENERAL_YES");
         confirmBox.cancelTitle = Lang.getString("GENERAL_NO");
         confirmBox.data = item;
         confirmBox.addEventListener(PopUpEvent.CLOSE,onConfirm = function(param1:PopUpEvent):void
         {
            confirmBox.removeEventListener(PopUpEvent.CLOSE,onConfirm);
            onEdit_Toggle();
            if(!param1.commit)
            {
               return;
            }
            var _loc2_:* = DAOFactory.getGatewayDAO();
            var _loc3_:* = DAOFactory.getGatewaySettingsDAO();
            var _loc4_:* = DAOFactory.getAppSettingDAO();
            _loc2_.removeGateway(item.gatewayInfos.gateway);
            _loc3_.clearSettingsForGateway(item.gatewayInfos.gateway);
            _loc4_.setDefaultGateway(null);
            reloadListProvider();
            listProvider.refresh();
         });
         confirmBox.open(null);
      }
      
      public function dispose() : void
      {
         this.view.bbar.removeEventListener(BottomBarEvent.HELP,this.onHelp);
         this.explorer = null;
         this.appSettingDAO = null;
         this.gatewayDAO = null;
      }
      
      private function findGatewaysLoop() : void
      {
         GatewayRendererItem.setIsRefreshing(true);
         var credentials:PortalCredentials = DAOFactory.getAppSettingDAO().getPortalCredentials();
         this.explorer.findGateways(credentials.clientId,credentials.password,function(param1:GatewayExplorer, param2:Vector.<GatewayInfos>):void
         {
            var sender:GatewayExplorer = param1;
            var entries:Vector.<GatewayInfos> = param2;
            updateListProvider(entries.concat());
            GatewayRendererItem.setIsRefreshing(false);
            if(Bootloader.useAutoLogin)
            {
               tryAutoLogin(entries);
            }
            new AutoDisposeTimer(1000,function(param1:TimerEvent):void
            {
               if(isActive)
               {
                  findGatewaysLoop();
               }
            }).start();
         });
      }
      
      private function tryAutoLogin(param1:Vector.<GatewayInfos>) : Boolean
      {
         var gwInfo:GatewayInfos = null;
         var gatewayInfos:Vector.<GatewayInfos> = param1;
         var appSettings:AppSettingDAO = DAOFactory.getAppSettingDAO();
         var userLogins:UserLoginDAO = DAOFactory.getUserLoginDAO();
         var defaultGW:Gateway = appSettings.getDefaultGateway();
         if(defaultGW == null)
         {
            return false;
         }
         var user:User = userLogins.getUserForGateway(defaultGW);
         if(user == null)
         {
            return false;
         }
         for each(gwInfo in gatewayInfos)
         {
            if(defaultGW.equals(gwInfo.gateway))
            {
               LoginHelper#1598.defaultLogin(gwInfo,user,function(param1:Boolean):void
               {
                  if(param1)
                  {
                     onLoginSuccess(gwInfo.gateway,true);
                  }
               });
               return true;
            }
         }
         return false;
      }
      
      private function updateListProvider(param1:Vector.<GatewayInfos>) : void
      {
         var _loc4_:GatewayRendererItem = null;
         var _loc5_:GatewayRendererItem = null;
         var _loc2_:GatewayInfos = null;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.listProvider.toArray())
         {
            _loc4_.gatewayInfos.isAvailable = false;
         }
         while(param1.length > 0)
         {
            _loc2_ = param1.pop();
            _loc3_ = false;
            if(StringHelper.IsNullOrEmpty(_loc2_.gateway.name))
            {
               Log.error("[GatewayExplorer] Loading Gateway-Name failed!");
            }
            for each(_loc5_ in this.listProvider)
            {
               if(_loc5_.gatewayInfos.gateway.equals(_loc2_.gateway))
               {
                  _loc3_ = true;
                  _loc5_.gatewayInfos.isAvailable = _loc2_.isAvailable;
                  if(!StringHelper.IsNullOrEmpty(_loc2_.address))
                  {
                     _loc5_.gatewayInfos.address = _loc2_.address;
                  }
                  _loc5_.gatewayInfos.isRemote = _loc2_.isRemote;
                  if(!StringHelper.IsNullOrEmpty(_loc2_.gateway.name))
                  {
                     _loc5_.gatewayInfos.gateway = _loc2_.gateway;
                  }
                  _loc5_.notifyItemChanged();
               }
            }
            if(!_loc3_)
            {
               this.listProvider.addItem(GatewayRendererItem.create(_loc2_));
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

import com.isisic.remote.hoermann.global.helper.Lang;
import refactor.bisecur._1_APP.components.popups.ErrorBox;
import refactor.bisecur._1_APP.components.popups.LoadBox;
import refactor.bisecur._1_APP.components.popups.LoginBox;
import refactor.bisecur._2_SAL.AppCache;
import refactor.bisecur._2_SAL.dao.AppSettingDAO;
import refactor.bisecur._2_SAL.dao.DAOFactory;
import refactor.bisecur._2_SAL.dao.UserLoginDAO;
import refactor.bisecur._2_SAL.gatewayData.User;
import refactor.bisecur._2_SAL.portal.PortalCredentials;
import refactor.bisecur._5_UTIL.InfoCenter;
import refactor.logicware._1_APP.commands.CommunicationResult;
import refactor.logicware._1_APP.commands.LoginCommand;
import refactor.logicware._2_SAL.ConnectionContext;
import refactor.logicware._2_SAL.LocalConnectionContext;
import refactor.logicware._2_SAL.RemoteConnectionContext;
import refactor.logicware._2_SAL.mcp.MCPErrors;
import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
import refactor.logicware._5_UTIL.LogicwareSettings;
import refactor.logicware._5_UTIL.StringHelper;
import spark.events.PopUpEvent;

class LoginHelper#1598
{
    
   
   function LoginHelper#1598()
   {
      super();
   }
   
   public static function login(param1:GatewayInfos, param2:Function) : void
   {
      var context:ConnectionContext = null;
      var gatewayInfos:GatewayInfos = param1;
      var callback:Function = param2;
      context = createContext(gatewayInfos);
      context.connect(function():void
      {
         var userLogins:UserLoginDAO = DAOFactory.getUserLoginDAO();
         var user:User = userLogins.getUserForGateway(gatewayInfos.gateway);
         tryAutoLogin(context,user,gatewayInfos,function(param1:Boolean, param2:String):void
         {
            if(param1)
            {
               if(callback != null)
               {
                  callback(true);
               }
            }
            else
            {
               presentLoginAndError(context,gatewayInfos,callback);
            }
         });
      });
   }
   
   private static function presentLoginAndError(param1:ConnectionContext, param2:GatewayInfos, param3:Function) : void
   {
      var context:ConnectionContext = param1;
      var gatewayInfos:GatewayInfos = param2;
      var callback:Function = param3;
      var userLogins:UserLoginDAO = DAOFactory.getUserLoginDAO();
      var user:User = userLogins.getUserForGateway(gatewayInfos.gateway);
      showLoginBox(context,user,gatewayInfos,function(param1:Boolean, param2:String):void
      {
         var success:Boolean = param1;
         var errorMessage:String = param2;
         if(!success && errorMessage != null)
         {
            showError(errorMessage,function():void
            {
               presentLoginAndError(context,gatewayInfos,callback);
            });
            return;
         }
         if(callback != null)
         {
            callback(success);
         }
      });
   }
   
   public static function defaultLogin(param1:GatewayInfos, param2:User, param3:Function = null) : *
   {
      var context:ConnectionContext = null;
      var gatewayInfos:GatewayInfos = param1;
      var user:User = param2;
      var callback:Function = param3;
      context = createContext(gatewayInfos);
      context.connect(function():void
      {
         executeLogin(gatewayInfos,context,user,function(param1:*, param2:String):void
         {
            if(param1)
            {
            }
            if(callback)
            {
               callback(param1);
            }
         });
      });
   }
   
   private static function tryAutoLogin(param1:ConnectionContext, param2:User, param3:GatewayInfos, param4:Function) : void
   {
      var admin:User = null;
      var context:ConnectionContext = param1;
      var user:User = param2;
      var gatewayInfos:GatewayInfos = param3;
      var callback:Function = param4;
      if(user != null && !StringHelper.IsNullOrEmpty(user.password))
      {
         executeLogin(gatewayInfos,context,user,function(param1:Boolean, param2:String):void
         {
            if(!param1)
            {
               showError(param2);
            }
            callback(param1,param2);
         });
      }
      else
      {
         admin = User.createByCredentials("admin","0000",gatewayInfos.gateway);
         executeLogin(gatewayInfos,context,admin,callback);
      }
   }
   
   private static function showLoginBox(param1:ConnectionContext, param2:User, param3:GatewayInfos, param4:Function) : void
   {
      var loginBox:LoginBox = null;
      var context:ConnectionContext = param1;
      var user:User = param2;
      var gatewayInfos:GatewayInfos = param3;
      var callback:Function = param4;
      loginBox = LoginBox.sharedBox;
      if(user != null)
      {
         loginBox.username = StringHelper.ValueOrDefault(user.name);
         loginBox.password = StringHelper.ValueOrDefault(user.password);
         loginBox.shouldSave = !StringHelper.IsNullOrEmpty(user.password);
      }
      else
      {
         loginBox.username = "";
         loginBox.password = "";
         loginBox.shouldSave = false;
      }
      loginBox.openAsync(function(param1:PopUpEvent):void
      {
         var passwordlessUser:User = null;
         var event:PopUpEvent = param1;
         if(!event.commit)
         {
            callback(false,null);
            return;
         }
         user = User.createByCredentials(loginBox.username,loginBox.password,gatewayInfos.gateway);
         var userLogins:UserLoginDAO = DAOFactory.getUserLoginDAO();
         if(loginBox.shouldSave)
         {
            userLogins.setUser(user);
         }
         else
         {
            passwordlessUser = user.clone();
            passwordlessUser.password = null;
            userLogins.setUser(passwordlessUser);
         }
         executeLogin(gatewayInfos,context,user,function(param1:Boolean, param2:String):void
         {
            if(param1)
            {
               loginBox.close(true);
            }
            callback(param1,param2);
         });
      });
   }
   
   private static function executeLogin(param1:GatewayInfos, param2:ConnectionContext, param3:User, param4:Function) : void
   {
      var loadBox:LoadBox = null;
      var gatewayInfos:GatewayInfos = param1;
      var context:ConnectionContext = param2;
      var user:User = param3;
      var callback:Function = param4;
      loadBox = LoadBox.sharedBox;
      loadBox.title = Lang.getString("POPUP_LOGIN_PROCESS");
      loadBox.contentText = Lang.getString("POPUP_LOGIN_PROCESS_CONTENT");
      loadBox.open(null);
      new LoginCommand(user,context).execute(function(param1:LoginCommand, param2:String):void
      {
         var _loc5_:int = 0;
         var _loc3_:* = param2 == CommunicationResult.SUCCESS;
         var _loc4_:String = null;
         if(!_loc3_)
         {
            if(param1.response == null)
            {
               InfoCenter.onNetTimeout();
            }
            else
            {
               _loc5_ = MCPErrors.getErrorFromPackage(param1.response);
               switch(_loc5_)
               {
                  case MCPErrors.GATEWAY_BUSY:
                     _loc4_ = "LOGIN_FAILED_GATEWAY_BUSY";
                     break;
                  case MCPErrors.LOGIN_FAILED:
                     _loc4_ = "LOGIN_FAILED_WRONG_DATA";
                     break;
                  default:
                     _loc4_ = "LOGIN_FAILED_UNKNOWN";
               }
            }
         }
         else
         {
            AppCache.sharedCache.login(user,gatewayInfos,context);
         }
         loadBox.close(_loc3_);
         callback(_loc3_,_loc4_);
      });
   }
   
   private static function showError(param1:String, param2:Function = null) : void
   {
      var errorBox:ErrorBox = null;
      var onClose:Function = null;
      var textKey:String = param1;
      var callback:Function = param2;
      errorBox = ErrorBox.sharedBox;
      errorBox.title = Lang.getString("LOGIN_FAILED_TITLE");
      errorBox.contentText = Lang.getString(textKey);
      errorBox.closeable = true;
      errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
      if(callback != null)
      {
         errorBox.addEventListener(PopUpEvent.CLOSE,onClose = function(param1:PopUpEvent):void
         {
            errorBox.removeEventListener(PopUpEvent.CLOSE,onClose);
            callback();
         });
      }
      errorBox.open(HoermannRemote.app);
   }
   
   private static function createContext(param1:GatewayInfos) : ConnectionContext
   {
      var _loc4_:PortalCredentials = null;
      var _loc2_:AppSettingDAO = DAOFactory.getAppSettingDAO();
      var _loc3_:ConnectionContext = null;
      if(param1.isRemote)
      {
         _loc4_ = _loc2_.getPortalCredentials();
         _loc3_ = new RemoteConnectionContext(_loc4_.clientId,_loc4_.password,param1.gateway.mac);
      }
      else
      {
         _loc3_ = new LocalConnectionContext(param1.address,LogicwareSettings.LOCAL_CONNECTION_PORT,param1.gateway.mac);
      }
      return _loc3_;
   }
}
