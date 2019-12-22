package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgAdd;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgPrefs;
   import com.isisic.remote.hoermann.components.ArrowComponent;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.GatewayScreenOverlay;
   import com.isisic.remote.hoermann.components.overlays.screens.HelpOverlay;
   import com.isisic.remote.hoermann.components.popups.AgreementBox;
   import com.isisic.remote.hoermann.components.popups.LoginBox;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.components.popups.addGateway.AGSetAddress;
   import com.isisic.remote.hoermann.components.popups.portal.SetDeviceIdBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.events.GatewayEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.LoginHelper#1838;
   import com.isisic.remote.hoermann.gwFirmwareFeatures.FirmwareFeatures;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import com.isisic.remote.hoermann.views.home.HomeScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import com.isisic.remote.lw.net.GatewayFinder;
   import com.isisic.remote.lw.net.udp.UDPUnitEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
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
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.components.View;
   import spark.effects.Move;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class GatewayScreen extends View implements IDisposable, IBindingClient
   {
      
      public static const REFRESH_GATEWAY_STATE_DELAY:int = 4000;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _GatewayScreen_Group1:Group;
      
      public var _GatewayScreen_Label2:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _1378839387btnAdd:Button;
      
      private var _205771398btnEdit:Button;
      
      private var _503168488btnPortal:Button;
      
      private var _435574526gatewayList:HmList;
      
      private var _1269202576helpAddGW:Label;
      
      private var _1269634376helpArrow:ArrowComponent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _828473878_gatewayProvider:AdvancedGatewayProvider;
      
      private var gatewayRefreshTimer:Timer;
      
      private var loginBox:LoginBox;
      
      private var loginHelper:LoginHelper#1838;
      
      private var _enableAutoUpdate:Boolean = true;
      
      private var defaultGatewayNotFound:Boolean = false;
      
      private var preventLoginError:Boolean = false;
      
      private var addLongPressTimer:Timer;
      
      private var addLongPressed:Boolean = false;
      
      private var addLongPressedHandler:Function;
      
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
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_gateways_GatewayScreenWatcherSetupUtil");
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
         this.addEventListener("initialize",this.___GatewayScreen_View1_initialize);
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
      
      public function get gatewayProvider() : AdvancedGatewayProvider
      {
         return this._gatewayProvider;
      }
      
      public function get enableAutoUpdate() : Boolean
      {
         return this._enableAutoUpdate;
      }
      
      public function set enableAutoUpdate(param1:Boolean) : void
      {
         this._enableAutoUpdate = param1;
         if(param1 == true)
         {
            GatewayFinder.finder.start();
            this._gatewayProvider.enableProviderUpdate = true;
            if(this.gatewayRefreshTimer == null)
            {
               this.gatewayRefreshTimer = new Timer(REFRESH_GATEWAY_STATE_DELAY,1);
               this.gatewayRefreshTimer.addEventListener(TimerEvent.TIMER,this.refreshGateways);
            }
            if(this.gatewayRefreshTimer.running == false)
            {
               this.refreshGateways(null);
            }
         }
         else
         {
            GatewayFinder.finder.stop();
            this._gatewayProvider.enableProviderUpdate = false;
         }
      }
      
      private function onInit() : void
      {
         var _loc1_:AgreementBox = null;
         GatewayDisplay.description = "";
         HoermannRemote.app.editMode = false;
         this.gatewayList.addEventListener(GatewayEvent.DELETE,this.onDelete);
         this.gatewayList.addEventListener(IndexChangeEvent.CHANGING,this.onSelect);
         this._gatewayProvider = new AdvancedGatewayProvider();
         this._gatewayProvider.addEventListener(Event.COMPLETE,this.onRefreshComplete);
         this.gatewayRefreshTimer = new Timer(REFRESH_GATEWAY_STATE_DELAY,1);
         this.gatewayRefreshTimer.addEventListener(TimerEvent.TIMER,this.refreshGateways);
         this.refreshGateways(null);
         addEventListener(Event.ACTIVATE,this.onActivate);
         addEventListener(Event.DEACTIVATE,this.onDeactivate);
         this.bbar.addEventListener(BottomBarEvent.HELP,this.onHelp);
         this.bbar.addEventListener(BottomBarEvent.ONLINE_HELP,this.onBottomBarViewChange);
         this.bbar.addEventListener(BottomBarEvent.NOTIFICATIONS,this.onBottomBarViewChange);
         if(HoermannRemote.app.editMode)
         {
            this.btnEdit.setStyle("chromeAlpha",1);
         }
         else
         {
            this.btnEdit.setStyle("chromeAlpha",0);
         }
         HoermannRemote.gatewayData.clear();
         if(!HoermannRemote.appData.acceptedTermsOfUse || !HoermannRemote.appData.acceptedTermsOfPrivacy)
         {
            _loc1_ = new AgreementBox(true);
            _loc1_.open(null);
         }
         GatewayFinder.finder.addEventListener(UDPUnitEvent.DISCOVERED,this.onGatewayFound);
         GatewayFinder.finder.start();
      }
      
      public function dispose() : void
      {
         GatewayFinder.finder.removeEventListener(UDPUnitEvent.DISCOVERED,this.onGatewayFound);
         this.gatewayList.removeEventListener(GatewayEvent.DELETE,this.onDelete);
         this.gatewayList.removeEventListener(IndexChangeEvent.CHANGING,this.onSelect);
         this.enableAutoUpdate = false;
         removeEventListener(Event.ACTIVATE,this.onActivate);
         removeEventListener(Event.DEACTIVATE,this.onDeactivate);
         this.bbar.removeEventListener(BottomBarEvent.HELP,this.onHelp);
         this.bbar.removeEventListener(BottomBarEvent.ONLINE_HELP,this.onBottomBarViewChange);
         this.bbar.removeEventListener(BottomBarEvent.NOTIFICATIONS,this.onBottomBarViewChange);
         this.gatewayRefreshTimer.removeEventListener(TimerEvent.TIMER,this.refreshGateways);
         this.gatewayRefreshTimer.reset();
         this.gatewayRefreshTimer = null;
         this._gatewayProvider.removeEventListener(Event.COMPLETE,this.onRefreshComplete);
         this._gatewayProvider.dispose();
         this._gatewayProvider = null;
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
         new GatewayScreenOverlay(this.btnEdit,this.btnAdd,this.btnPortal,this.bbar.email,this.bbar.callout).open(null);
      }
      
      private function onBottomBarViewChange(param1:BottomBarEvent) : void
      {
         this.dispose();
      }
      
      private function onActivate(param1:Event) : void
      {
         this.enableAutoUpdate = true;
      }
      
      private function onDeactivate(param1:Event) : void
      {
         this.enableAutoUpdate = false;
      }
      
      private function refreshGateways(param1:TimerEvent) : void
      {
         this._gatewayProvider.update();
      }
      
      private function onRefreshComplete(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         this.gatewayRefreshTimer.reset();
         if(this.enableAutoUpdate)
         {
            this.gatewayRefreshTimer.start();
         }
         if(!ArrayHelper.in_array(getQualifiedClassName(this),HoermannRemote.appData.shownOverlays))
         {
            new HelpOverlay(this.bbar.help).open(null);
            HoermannRemote.appData.shownOverlays.push(getQualifiedClassName(this));
            HoermannRemote.appData.save();
         }
         if(HoermannRemote.appData.useAutoLogin)
         {
            if(HoermannRemote.appData.autoLogin)
            {
               _loc2_ = null;
               _loc3_ = HoermannRemote.appData.autoLogin;
               for each(_loc4_ in this._gatewayProvider.dataProvider.toArray())
               {
                  if(_loc4_.mac == HoermannRemote.appData.autoLogin.mac)
                  {
                     _loc2_ = _loc4_;
                  }
               }
               if(_loc2_ == null || _loc2_.available == false)
               {
                  Debug.debug("AUTO_LOGIN:");
                  Debug.debug("\tmac:" + _loc3_.mac);
                  Debug.debug("\tuser:" + _loc3_.username);
                  Debug.debug("\tpasswd:" + _loc3_.password);
                  HoermannRemote.errorBox.title = Lang.getString("ERROR_DFAULT_GATEWAY_NOT_FOUND");
                  HoermannRemote.errorBox.contentText = Lang.getString("ERROR_DFAULT_GATEWAY_NOT_FOUND_CONTENT");
                  HoermannRemote.errorBox.closeable = true;
                  HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
                  if(this.defaultGatewayNotFound == false)
                  {
                     HoermannRemote.errorBox.open(null);
                  }
                  this.defaultGatewayNotFound = true;
                  return;
               }
               this.defaultGatewayNotFound = false;
               this.enableAutoUpdate = false;
               this.gatewayList.selectedItem = _loc2_;
               this.doLogin(_loc2_,_loc3_.username,_loc3_.password,true);
            }
         }
      }
      
      protected function onSelect(param1:IndexChangeEvent) : void
      {
         var _loc4_:Object = null;
         if(this.isInEditMode || !this.gatewayList.selectedItem || !this.gatewayList.selectedItem.available)
         {
            param1.preventDefault();
            return;
         }
         this.enableAutoUpdate = false;
         this.loginBox = new LoginBox();
         var _loc2_:Object = this.gatewayList.selectedItem;
         var _loc3_:Object = null;
         for each(_loc4_ in _loc2_.users)
         {
            if(_loc4_.id == _loc2_.lastUser)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_ && _loc3_.password)
         {
            this.doLogin(_loc2_,_loc3_.name,_loc3_.password,true);
         }
         else
         {
            this.preventLoginError = true;
            this.doLogin(_loc2_,"admin","0000",false);
         }
      }
      
      private function presentLoginPopup(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = null;
         for each(_loc3_ in param1.users)
         {
            if(_loc3_.id == param1.lastUser)
            {
               _loc2_ = _loc3_;
            }
         }
         if(_loc2_)
         {
            this.loginBox.username = _loc2_.name;
            this.loginBox.password = _loc2_.password;
            this.loginBox.shouldSave = _loc2_.password;
         }
         this.loginBox.addEventListener(PopUpEvent.CLOSE,this.onLogin);
         this.loginBox.open(null);
      }
      
      private function doLogin(param1:Object, param2:String, param3:String, param4:Boolean) : void
      {
         var _loc6_:Object = null;
         HoermannRemote.loadBox.title = Lang.getString("POPUP_LOGIN_PROCESS");
         HoermannRemote.loadBox.contentText = Lang.getString("POPUP_LOGIN_PROCESS_CONTENT");
         HoermannRemote.loadBox.open(null);
         HoermannRemote.appData.username = param2;
         var _loc5_:Object = null;
         for each(_loc6_ in HoermannRemote.appData.gateways)
         {
            if(_loc6_.mac == param1.mac)
            {
               _loc5_ = _loc6_;
            }
         }
         if(_loc5_ == null)
         {
            Debug.warning("[GatewayScanner] \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\ncan not find given gateway in storage!\n\n\n\n\n\n");
            HoermannRemote.appData.gateways.push(param1);
            _loc5_ = param1;
         }
         var _loc7_:String = !!param1.isPortal?ConnectionTypes.PORTAL:ConnectionTypes.LOCAL;
         var _loc8_:String = !!param1.isPortal?HoermannRemote.appData.portalData.deviceId:Logicware.API.clientId;
         var _loc9_:ConnectionContext = Logicware.API.createContext(param1.host,param1.port,_loc8_,param1.mac,_loc7_,param1.mac);
         this.loginHelper = new LoginHelper#1838(_loc9_,_loc5_);
         this.loginHelper.addEventListener(Event.COMPLETE,this.onLoginFinished);
         this.loginHelper.addEventListener(ErrorEvent.ERROR,this.onLoginFailed);
         this.loginHelper.login(param2,param3,param4);
         if(!param4)
         {
            return;
         }
         HoermannRemote.appData.save();
      }
      
      protected function onLogin(param1:PopUpEvent) : void
      {
         var _loc2_:Object = this.gatewayList.selectedItem;
         if(!param1.commit)
         {
            this.gatewayList.selectedItem = null;
            this.enableAutoUpdate = true;
            this._gatewayProvider.dataProvider.refresh();
            return;
         }
         var _loc3_:String = (param1.target as LoginBox).username;
         var _loc4_:String = (param1.target as LoginBox).password;
         var _loc5_:Boolean = (param1.target as LoginBox).shouldSave;
         this.doLogin(_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      private function onLoginFinished(param1:Event) : void
      {
         var _loc2_:ErrorEvent = null;
         var _loc3_:Object = null;
         if(this.loginHelper)
         {
            this.loginHelper.removeEventListener(Event.COMPLETE,this.onLoginFinished);
            this.loginHelper.removeEventListener(ErrorEvent.ERROR,this.onLoginFailed);
            this.loginHelper.dispose();
            this.loginHelper = null;
         }
         BottomBar.username = HoermannRemote.appData.username;
         if(!HoermannRemote.appData.activeConnection)
         {
            HoermannRemote.loadBox.close();
            _loc2_ = new ErrorEvent(ErrorEvent.ERROR,false,false,"LOGIN_FAILED_UNKNOWN",1);
            this.onLoginFailed(_loc2_);
            return;
         }
         FirmwareFeatures.resetFeatures();
         HoermannRemote.gatewayData.updateSoftwareVersion(HoermannRemote.appData.activeConnection);
         HoermannRemote.appData.mcpProcessor = new HmProcessor(HoermannRemote.appData.activeConnection);
         HoermannRemote.appData.mcpProcessor.requestTransition();
         HoermannRemote.loadBox.close();
         _loc3_ = {};
         if(HoermannRemote.appData.useAutoLogin)
         {
            if(HoermannRemote.appData.autoLogin)
            {
               if(HoermannRemote.appData.autoLogin.mac == HoermannRemote.appData.activeConnection.mac)
               {
                  _loc3_.forward = ActorScreen;
               }
            }
         }
         this.enableAutoUpdate = false;
         this.navigator.replaceView(HomeScreen,_loc3_);
         this.dispose();
         HoermannRemote.appData.useAutoLogin = false;
         this.gatewayList.removeEventListener(GatewayEvent.DELETE,this.onDelete);
      }
      
      private function onLoginFailed(param1:ErrorEvent) : void
      {
         var _loc2_:Object = null;
         if(this.loginHelper)
         {
            _loc2_ = this.loginHelper.gateway;
            this.loginHelper.context.dispose();
            this.loginHelper.removeEventListener(Event.COMPLETE,this.onLoginFinished);
            this.loginHelper.removeEventListener(ErrorEvent.ERROR,this.onLoginFailed);
            this.loginHelper.dispose();
            this.loginHelper = null;
         }
         HoermannRemote.loadBox.close();
         if(!this.preventLoginError)
         {
            HoermannRemote.errorBox.title = Lang.getString("LOGIN_FAILED_TITLE");
            HoermannRemote.errorBox.contentText = Lang.getString(param1.text);
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(HoermannRemote.app);
            if(param1.errorID == Errors.LOGIN_FAILED)
            {
               HoermannRemote.errorBox.addEventListener(PopUpEvent.CLOSE,this.onWrongUserData);
            }
            else
            {
               this.enableAutoUpdate = true;
               this.gatewayList.selectedItem = null;
            }
         }
         else
         {
            this.presentLoginPopup(_loc2_);
         }
         this.preventLoginError = false;
         HoermannRemote.appData.useAutoLogin = false;
      }
      
      protected function onWrongUserData(param1:PopUpEvent) : void
      {
         var _loc4_:Object = null;
         HoermannRemote.errorBox.removeEventListener(PopUpEvent.CLOSE,this.onWrongUserData);
         this.loginBox = new LoginBox();
         var _loc2_:Object = this.gatewayList.selectedItem;
         var _loc3_:Object = null;
         for each(_loc4_ in _loc2_.users)
         {
            if(_loc4_.id == _loc2_.lastUser)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_)
         {
            this.loginBox.username = _loc3_.name;
            this.loginBox.password = _loc3_.password;
            this.loginBox.shouldSave = _loc3_.password;
         }
         this.loginBox.addEventListener(PopUpEvent.CLOSE,this.onLogin);
         this.loginBox.open(null);
      }
      
      public function get isInEditMode() : Boolean
      {
         return this.btnEdit.getStyle("chromeAlpha");
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
      
      protected function onDelete(param1:GatewayEvent) : void
      {
         if(this.loginBox && this.loginBox.isOpen)
         {
            this.loginBox.close();
         }
         HoermannRemote.confirmBox.title = Lang.getString("CONFIRM_DELETE_TITLE");
         HoermannRemote.confirmBox.contentText = Lang.getString("CONFIRM_DELETE");
         HoermannRemote.confirmBox.submitTitle = Lang.getString("GENERAL_YES");
         HoermannRemote.confirmBox.cancelTitle = Lang.getString("GENERAL_NO");
         HoermannRemote.confirmBox.data = param1.target.data;
         HoermannRemote.confirmBox.addEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         HoermannRemote.confirmBox.open(null);
         if(this.loginBox && this.loginBox.isOpen)
         {
            this.loginBox.close();
         }
      }
      
      protected function onDeleteCommit(param1:PopUpEvent) : void
      {
         var _loc4_:* = null;
         HoermannRemote.confirmBox.removeEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         this.toggleEdit();
         if(!param1.commit)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         var _loc3_:Array = HoermannRemote.appData.gateways;
         if(HoermannRemote.appData.autoLogin)
         {
            if(HoermannRemote.appData.autoLogin.mac == _loc2_.mac)
            {
               HoermannRemote.appData.autoLogin = null;
            }
         }
         for(_loc4_ in _loc3_)
         {
            if(_loc2_.mac == _loc3_[int(_loc4_)].mac)
            {
               HoermannRemote.appData.gateways.splice(int(_loc4_),1);
            }
         }
         this._gatewayProvider.dataProvider.removeItem(_loc2_);
         this._gatewayProvider.update();
      }
      
      protected function onSetPortalData(param1:MouseEvent, param2:Boolean = false) : void
      {
         var _loc3_:AGSetAddress = null;
         if(param1.ctrlKey || param2)
         {
            _loc3_ = new AGSetAddress();
            _loc3_.addEventListener(PopUpEvent.CLOSE,this.onAdd);
            _loc3_.open(HoermannRemote.app);
            return;
         }
         this.onAddPortalId();
      }
      
      protected function onAddPortalId() : void
      {
         var _loc1_:SetDeviceIdBox = new SetDeviceIdBox();
         _loc1_.addEventListener(PopUpEvent.CLOSE,this.onPortalIdAdded);
         _loc1_.open(null);
      }
      
      protected function onPortalIdAdded(param1:PopUpEvent) : void
      {
         param1.currentTarget.removeEventListener(PopUpEvent.CLOSE,this.onPortalIdAdded);
         this._gatewayProvider.update();
      }
      
      protected function onAdd(param1:PopUpEvent) : void
      {
         var _loc4_:Object = null;
         if(!param1.commit)
         {
            return;
         }
         var _loc2_:Object = param1.data;
         var _loc3_:Boolean = false;
         for each(_loc4_ in HoermannRemote.appData.gateways)
         {
            if(_loc4_.mac == _loc2_.mac)
            {
               _loc4_.available = true;
               _loc4_.name = _loc2_.name;
               _loc4_.host = _loc2_.host;
               _loc4_.port = _loc2_.port;
               _loc4_.isPortal = _loc2_.isPortal;
               _loc4_.localIp = _loc2_.localIp;
               _loc4_.localPort = _loc2_.localPort;
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            HoermannRemote.appData.gateways.push(_loc2_);
            this._gatewayProvider.update();
         }
      }
      
      private function onAddDown(param1:Event) : void
      {
         var self:View = null;
         var event:Event = param1;
         this.addLongPressed = false;
         if(this.addLongPressTimer != null)
         {
            this.addLongPressTimer.reset();
            this.addLongPressTimer = null;
         }
         if(Features.enableDdnsDialog)
         {
            this.addLongPressTimer = new Timer(1000,1);
            self = this;
            this.addLongPressTimer.addEventListener(TimerEvent.TIMER,this.addLongPressedHandler = function(param1:TimerEvent):void
            {
               var _loc4_:* = undefined;
               addLongPressTimer.removeEventListener(TimerEvent.TIMER,addLongPressedHandler);
               addLongPressed = true;
               var _loc2_:* = 250;
               var _loc3_:* = 0;
               while(_loc3_ < 4)
               {
                  _loc4_ = new Move();
                  _loc4_.xFrom = 0;
                  _loc4_.xTo = 50;
                  _loc4_.duration = _loc2_ / 2;
                  _loc4_.startDelay = _loc3_ * (_loc2_ * 2);
                  _loc4_.play([self],true);
                  _loc4_ = new Move();
                  _loc4_.xFrom = 0;
                  _loc4_.xTo = -50;
                  _loc4_.duration = _loc2_ / 2;
                  _loc4_.startDelay = _loc3_ * (_loc2_ * 2);
                  _loc4_.play([self],true);
                  _loc3_++;
               }
            });
            this.addLongPressTimer.start();
         }
      }
      
      private function onAddGW(param1:MouseEvent) : void
      {
         var _loc2_:SearchGatewaysPopup = null;
         if(Features.presenterVersion)
         {
            if(this.addLongPressTimer != null)
            {
               this.addLongPressTimer.reset();
            }
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(this.addLongPressTimer != null)
         {
            this.addLongPressTimer.reset();
         }
         if(param1.altKey || this.addLongPressed)
         {
            new AGSetAddress().open(null);
         }
         else
         {
            _loc2_ = new SearchGatewaysPopup();
            _loc2_.addEventListener(Event.COMPLETE,this.onGatewaysScanned);
            _loc2_.open(null);
            this.enableAutoUpdate = false;
         }
      }
      
      private function onGatewaysScanned(param1:Event) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         this.enableAutoUpdate = true;
         var _loc2_:SearchGatewaysPopup = param1.currentTarget as SearchGatewaysPopup;
         if(_loc2_.gateways == null || _loc2_.gateways.length <= 0)
         {
            return;
         }
         for each(_loc3_ in _loc2_.gateways)
         {
            _loc4_ = ArrayHelper.findByProperty("mac",_loc3_.mac,HoermannRemote.appData.gateways);
            if(_loc4_ != null)
            {
               _loc4_.name = _loc3_.name;
               _loc4_.localIp = _loc3_.localIp;
               _loc4_.localPort = _loc3_.localPort;
            }
            else
            {
               if(HoermannRemote.appData.gateways == null)
               {
                  HoermannRemote.appData.gateways = new Array();
               }
               HoermannRemote.appData.gateways.push(_loc3_);
            }
         }
         HoermannRemote.appData.save();
         this._gatewayProvider.update();
      }
      
      private function onGatewayFound(param1:UDPUnitEvent) : void
      {
         var _loc2_:Object = ArrayHelper.findByProperty("mac",param1.mac,HoermannRemote.appData.gateways);
         if(_loc2_ != null)
         {
            _loc2_.localIp = param1.host;
            _loc2_.host = param1.host;
            _loc2_.isPortal = false;
         }
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
         this.toggleEdit();
      }
      
      private function _GatewayScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
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
         this.onAddGW(param1);
      }
      
      public function __btnAdd_buttonDown(param1:FlexEvent) : void
      {
         this.onAddDown(param1);
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
         this.onSetPortalData(param1);
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
         this.onInit();
      }
      
      private function _GatewayScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("SELECT_GATEWAY");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgEdit);
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[2] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgAdd);
         },function(param1:Object):void
         {
            btnAdd.setStyle("icon",param1);
         },"btnAdd.icon");
         result[3] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgPrefs);
         },function(param1:Object):void
         {
            btnPortal.setStyle("icon",param1);
         },"btnPortal.icon");
         result[4] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"gatewayList.bottom");
         result[5] = new Binding(this,function():IList
         {
            return this._gatewayProvider.dataProvider;
         },null,"gatewayList.dataProvider");
         result[6] = new Binding(this,function():Boolean
         {
            return _gatewayProvider.dataProvider.length <= 0;
         },null,"_GatewayScreen_Group1.visible");
         result[7] = new Binding(this,null,null,"helpArrow.sourcePointer","helpAddGW");
         result[8] = new Binding(this,null,null,"helpArrow.destinationPointer","btnAdd");
         result[9] = new Binding(this,function():Number
         {
            return helpArrow.height;
         },null,"helpArrow.width");
         result[10] = new Binding(this,function():Number
         {
            return helpAddGW.y + helpAddGW.height;
         },null,"helpArrow.height");
         result[11] = new Binding(this,null,null,"helpArrow.controlX","btnAdd");
         result[12] = new Binding(this,null,null,"helpArrow.controlY","helpAddGW");
         result[13] = new Binding(this,function():Number
         {
            return height * 0.05;
         },null,"helpAddGW.y");
         result[14] = new Binding(this,function():Object
         {
            return helpArrow.width;
         },null,"helpAddGW.right");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GATEWAY_SCREEN_ADD_HELP");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"helpAddGW.text");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GATEWAY_SCREEN_NO_GATEWAYS_CONTENT");
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
      
      [Bindable(event="propertyChange")]
      private function get _gatewayProvider() : AdvancedGatewayProvider
      {
         return this._828473878_gatewayProvider;
      }
      
      private function set _gatewayProvider(param1:AdvancedGatewayProvider) : void
      {
         var _loc2_:Object = this._828473878_gatewayProvider;
         if(_loc2_ !== param1)
         {
            this._828473878_gatewayProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_gatewayProvider",_loc2_,param1));
            }
         }
      }
   }
}
