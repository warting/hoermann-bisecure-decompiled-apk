package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgPrefs;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.popups.AgreementBox;
   import com.isisic.remote.hoermann.components.popups.LoginBox;
   import com.isisic.remote.hoermann.components.popups.addGateway.AGSetAddress;
   import com.isisic.remote.hoermann.components.popups.portal.SetDeviceIdBox;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.events.GatewayEvent;
   import com.isisic.remote.hoermann.events.LoginEvent;
   import com.isisic.remote.hoermann.global.helper.GatewayScanner;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.LoginHelper#1838;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.skins.ColorableActionButtonSkin;
   import com.isisic.remote.hoermann.views.actors.ActorScreen;
   import com.isisic.remote.hoermann.views.home.HomeScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import flash.events.ErrorEvent;
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
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class SelectGateway extends View implements IBindingClient
   {
      
      public static const MAX_GATEWAYS:int = 12;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _205771398btnEdit:Button;
      
      private var _503168488btnPortal:Button;
      
      private var _435574526gatewayList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1567718737gateways:ArrayCollection;
      
      private var loginBox:LoginBox;
      
      private var loginHelper:LoginHelper#1838;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SelectGateway()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._SelectGateway_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_gateways_SelectGatewayWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SelectGateway[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.actionContent = [this._SelectGateway_Button1_i(),this._SelectGateway_Button2_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SelectGateway_Array2_c);
         this.addEventListener("initialize",this.___SelectGateway_View1_initialize);
         this.addEventListener("creationComplete",this.___SelectGateway_View1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SelectGateway._watcherSetupUtil = param1;
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
         GatewayDisplay.description = "";
         HoermannRemote.app.editMode = false;
         this.gateways = new ArrayCollection();
         this.gatewayList.addEventListener(GatewayEvent.DELETE,this.onDelete);
         this.gatewayList.addEventListener(IndexChangeEvent.CHANGING,this.onSelect);
         this.bbar.showRefresh = true;
         this.bbar.addEventListener(BottomBarEvent.REFRESH,this.onRefresh);
         this.bbar.addEventListener(BottomBarEvent.HELP,this.onHelp);
         if(HoermannRemote.app.editMode)
         {
            this.btnEdit.setStyle("chromeAlpha",1);
         }
         else
         {
            this.btnEdit.setStyle("chromeAlpha",0);
         }
         HoermannRemote.gatewayData.clear();
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
      }
      
      private function onRefresh(param1:BottomBarEvent) : void
      {
         this.loadGateways();
      }
      
      protected function onComplete() : void
      {
         var _loc2_:AgreementBox = null;
         var _loc1_:Timer = new Timer(5000,1);
         _loc1_.addEventListener(TimerEvent.TIMER_COMPLETE,this.initHandler);
         _loc1_.start();
         HoermannRemote.WINDOW_HEIGHT = navigator.height;
         HoermannRemote.WINDOW_WIDTH = navigator.width;
         if(!HoermannRemote.appData)
         {
            return;
         }
         if(!HoermannRemote.appData.acceptedTermsOfUse || !HoermannRemote.appData.acceptedTermsOfPrivacy)
         {
            _loc2_ = new AgreementBox();
            _loc2_.addEventListener(PopUpEvent.CLOSE,this.onAgreementClosed);
            _loc2_.open(null);
         }
         else
         {
            this.loadGateways();
         }
      }
      
      private function onAgreementClosed(param1:Event) : void
      {
         (param1.currentTarget as AgreementBox).removeEventListener(PopUpEvent.CLOSE,this.onAgreementClosed);
         (param1.currentTarget as AgreementBox).dispose();
         this.loadGateways();
      }
      
      private function initHandler(param1:TimerEvent) : void
      {
         (param1.currentTarget as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.initHandler);
      }
      
      public function loadGateways() : void
      {
         if(!HoermannRemote.isActive)
         {
            return;
         }
         HoermannRemote.loadBox.title = Lang.getString("POPUP_SEARCH_TITLE");
         HoermannRemote.loadBox.contentText = Lang.getString("POPUP_SEARCH_CONTENT");
         HoermannRemote.loadBox.open(null);
         var _loc1_:GatewayScanner = new GatewayScanner();
         _loc1_.addEventListener(Event.COMPLETE,this.onGatewaysScaned);
         _loc1_.scan(HoermannRemote.appData.gateways);
      }
      
      protected function onGatewaysScaned(param1:Event) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         HoermannRemote.loadBox.close();
         param1.currentTarget.removeEventListener(Event.COMPLETE,this.onGatewaysScaned);
         this.refreshGateways(param1.currentTarget.gateways as Array);
         var _loc2_:IFactory = this.gatewayList.itemRenderer;
         this.gatewayList.itemRenderer = null;
         this.gatewayList.itemRenderer = _loc2_;
         if(HoermannRemote.appData.useAutoLogin)
         {
            if(HoermannRemote.appData.autoLogin)
            {
               _loc3_ = null;
               _loc4_ = HoermannRemote.appData.autoLogin;
               for each(_loc5_ in this.gateways.toArray())
               {
                  if(_loc5_.mac == HoermannRemote.appData.autoLogin.mac)
                  {
                     _loc3_ = _loc5_;
                  }
               }
               if(_loc3_ == null || _loc3_.available == false)
               {
                  Debug.debug("AUTO_LOGIN:");
                  Debug.debug("\tmac:" + _loc4_.mac);
                  Debug.debug("\tuser:" + _loc4_.username);
                  Debug.debug("\tpasswd:" + _loc4_.password);
                  HoermannRemote.errorBox.title = Lang.getString("ERROR_DFAULT_GATEWAY_NOT_FOUND");
                  HoermannRemote.errorBox.contentText = Lang.getString("ERROR_DFAULT_GATEWAY_NOT_FOUND_CONTENT");
                  HoermannRemote.errorBox.closeable = true;
                  HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
                  HoermannRemote.errorBox.open(null);
                  return;
               }
               this.gatewayList.selectedItem = _loc3_;
               this.doLogin(_loc3_,_loc4_.username,_loc4_.password,true);
            }
         }
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
      
      public function get isInEditMode() : Boolean
      {
         return this.btnEdit.getStyle("chromeAlpha");
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
         this.gateways.removeItem(_loc2_);
         this.gateways.refresh();
      }
      
      protected function onSelect(param1:IndexChangeEvent) : void
      {
         var _loc4_:Object = null;
         if(this.isInEditMode || !this.gatewayList.selectedItem || !this.gatewayList.selectedItem.available)
         {
            param1.preventDefault();
            return;
         }
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
            if(_loc3_.password)
            {
               this.doLogin(_loc2_,_loc3_.name,_loc3_.password,true);
               return;
            }
            this.loginBox.username = _loc3_.name;
            this.loginBox.password = _loc3_.password;
            this.loginBox.shouldSave = _loc3_.password;
         }
         this.loginBox.addEventListener(PopUpEvent.CLOSE,this.onLogin);
         this.loginBox.open(null);
      }
      
      protected function onLogin(param1:PopUpEvent) : void
      {
         var _loc2_:Object = this.gatewayList.selectedItem;
         if(!param1.commit)
         {
            this.gatewayList.selectedItem = null;
            return;
         }
         var _loc3_:String = (param1.target as LoginBox).username;
         var _loc4_:String = (param1.target as LoginBox).password;
         var _loc5_:Boolean = (param1.target as LoginBox).shouldSave;
         this.doLogin(_loc2_,_loc3_,_loc4_,_loc5_);
      }
      
      private function doLogin(param1:Object, param2:String, param3:String, param4:Boolean) : void
      {
         HoermannRemote.loadBox.title = Lang.getString("POPUP_LOGIN_PROCESS");
         HoermannRemote.loadBox.contentText = Lang.getString("POPUP_LOGIN_PROCESS_CONTENT");
         HoermannRemote.loadBox.open(null);
         HoermannRemote.appData.username = param2;
         var _loc5_:String = !!param1.isPortal?ConnectionTypes.PORTAL:ConnectionTypes.LOCAL;
         var _loc6_:ConnectionContext = Logicware.API.createContext(param1.host,param1.port,Logicware.API.clientId,param1.mac,_loc5_,param1.mac);
         this.loginHelper = new LoginHelper#1838(_loc6_,param1);
         this.loginHelper.addEventListener(Event.COMPLETE,this.onLoginFinished);
         this.loginHelper.addEventListener(ErrorEvent.ERROR,this.onLoginFailed);
         this.loginHelper.login(param2,param3,param4);
         if(!param4)
         {
            return;
         }
         HoermannRemote.appData.save();
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
         this.navigator.replaceView(HomeScreen,_loc3_);
         HoermannRemote.appData.useAutoLogin = false;
         this.gatewayList.removeEventListener(LoginEvent.LOGIN,this.onLogin);
         this.gatewayList.removeEventListener(LoginEvent.CANCELED,this.onCancel);
         this.gatewayList.removeEventListener(GatewayEvent.DELETE,this.onDelete);
      }
      
      private function onLoginFailed(param1:ErrorEvent) : void
      {
         if(this.loginHelper)
         {
            this.loginHelper.removeEventListener(Event.COMPLETE,this.onLoginFinished);
            this.loginHelper.removeEventListener(ErrorEvent.ERROR,this.onLoginFailed);
            this.loginHelper.dispose();
            this.loginHelper = null;
         }
         HoermannRemote.loadBox.close();
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
            this.gatewayList.selectedItem = null;
         }
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
      
      protected function onCancel(param1:Event) : void
      {
         this.gatewayList.selectedItem = null;
      }
      
      protected function onAddDDNS(param1:MouseEvent) : void
      {
         var _loc2_:AGSetAddress = new AGSetAddress();
         _loc2_.addEventListener(PopUpEvent.CLOSE,this.onAdd);
         _loc2_.open(HoermannRemote.app);
      }
      
      protected function onAddGateway(param1:MouseEvent) : void
      {
         var _loc2_:AGSetAddress = null;
         if(param1.ctrlKey)
         {
            _loc2_ = new AGSetAddress();
            _loc2_.addEventListener(PopUpEvent.CLOSE,this.onAdd);
            _loc2_.open(HoermannRemote.app);
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
         if(!param1.commit)
         {
            return;
         }
         this.loadGateways();
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
         for each(_loc4_ in this.gateways.toArray())
         {
            if(_loc4_.mac == _loc2_.mac)
            {
               _loc4_.available = true;
               _loc4_.name = _loc2_.name;
               _loc4_.host = _loc2_.host;
               _loc4_.port = _loc2_.port;
               _loc4_.isDDns = _loc2_.isDDns;
               _loc4_.isPortal = _loc2_.isPortal;
               _loc3_ = true;
               this.gatewayList.itemRenderer = new ClassFactory(GatewayRenderer);
               break;
            }
         }
         if(!_loc3_)
         {
            this.gateways.addItem(_loc2_);
         }
      }
      
      private function refreshGateways(param1:Array) : void
      {
         if(param1.length > MAX_GATEWAYS)
         {
            param1 = param1.slice(0,MAX_GATEWAYS);
         }
         this.gateways = new ArrayCollection(param1);
      }
      
      private function _SelectGateway_Button1_i() : Button
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
      
      private function _SelectGateway_Button2_i() : Button
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
         this.onAddGateway(param1);
      }
      
      private function _SelectGateway_Array2_c() : Array
      {
         var _loc1_:Array = [this._SelectGateway_HmList1_i(),this._SelectGateway_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _SelectGateway_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.top = 0;
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.itemRenderer = this._SelectGateway_ClassFactory1_c();
         _loc1_.id = "gatewayList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gatewayList = _loc1_;
         BindingManager.executeBindings(this,"gatewayList",this.gatewayList);
         return _loc1_;
      }
      
      private function _SelectGateway_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = GatewayRenderer;
         return _loc1_;
      }
      
      private function _SelectGateway_BottomBar1_i() : BottomBar
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
      
      public function ___SelectGateway_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___SelectGateway_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _SelectGateway_bindingsSetup() : Array
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
            return MultiDevice.getFxg(ImgPrefs);
         },function(param1:Object):void
         {
            btnPortal.setStyle("icon",param1);
         },"btnPortal.icon");
         result[3] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"gatewayList.bottom");
         result[4] = new Binding(this,function():IList
         {
            return this.gateways;
         },null,"gatewayList.dataProvider");
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
      public function get gateways() : ArrayCollection
      {
         return this._1567718737gateways;
      }
      
      public function set gateways(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1567718737gateways;
         if(_loc2_ !== param1)
         {
            this._1567718737gateways = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gateways",_loc2_,param1));
            }
         }
      }
   }
}
