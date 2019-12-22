package refactor.bisecur._1_APP.views.settings.subSettings
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgSearch_White;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgInfo;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgNegative;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgPositive;
   import com.isisic.remote.hoermann.global.WifiStates;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestDefaults;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.controls.Spacer;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.WifiSettingsScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._1_APP.components.popups.LoadBox;
   import refactor.bisecur._1_APP.components.popups.SelectBox;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._2_SAL.mcp.MCPReceiver;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.BusyIndicator;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.TextInput;
   import spark.components.VGroup;
   import spark.components.View;
   import spark.events.PopUpEvent;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class WifiSettingsScreen extends View implements IBindingClient
   {
      
      public static const WIFI_SCAN_TIMEOUT:int = 15000;
      
      public static const STATE_REFRESH_DELAY:int = 2000;
      
      private static const SSID_SCAN_REGEX:RegExp = /(?<=Ssid.\svalue.{2}).*?(?=")/;
      
      private static const PASSPHRASE_SCAN_REGEX:RegExp = /(?<=pw.\svalue.{2}).*?(?=")/;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _WifiSettingsScreen_Label1:Label;
      
      public var _WifiSettingsScreen_Label3:Label;
      
      public var _WifiSettingsScreen_Label4:Label;
      
      public var _WifiSettingsScreen_Label5:Label;
      
      private var _3016817bbar:BottomBar;
      
      private var _117924854btnCancel:Button;
      
      private var _206187257btnScan:Button;
      
      private var _594113940btnSubmit:Button;
      
      private var _951530617content:SkinnableContainer;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _2116680264icnWifiState:SkinnableContainer;
      
      private var _398939494lblWifiState:Label;
      
      private var _574077798txtPassphrase:TextInput;
      
      private var _878574101txtSSID:TextInput;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var timeoutTimer:Timer;
      
      private var refreshTimer:Timer;
      
      private var scannedWifis:Array;
      
      private var mcpReceiver:MCPReceiver;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function WifiSettingsScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._WifiSettingsScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_settings_subSettings_WifiSettingsScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return WifiSettingsScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._WifiSettingsScreen_Array1_c);
         this.addEventListener("initialize",this.___WifiSettingsScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         WifiSettingsScreen._watcherSetupUtil = param1;
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
      
      private function onInit() : void
      {
         this.readNetworkData();
         this.loadNetworkState();
         this.refreshTimer = new Timer(STATE_REFRESH_DELAY);
         this.refreshTimer.addEventListener(TimerEvent.TIMER,this.onRefresh);
         this.refreshTimer.start();
         this.mcpReceiver = new MCPReceiver(AppCache.sharedCache.connection);
      }
      
      private function dispose() : void
      {
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onScanTimeout);
            this.timeoutTimer = null;
         }
         if(this.refreshTimer)
         {
            this.refreshTimer.reset();
            this.refreshTimer.removeEventListener(TimerEvent.TIMER,this.onRefresh);
            this.refreshTimer = null;
         }
         this.mcpReceiver.dispose();
      }
      
      private function loadNetworkState() : void
      {
         if(!AppCache.sharedCache.connection)
         {
            this.dispose();
         }
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createGetWifiState(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc3_:int = 0;
            var _loc4_:String = null;
            var _loc5_:IVisualElement = null;
            if(param1.response == null)
            {
               Log.warning("[WifiSettingsScreen] requesting wifiState failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            var _loc2_:MCPPackage = param1.response;
            if(_loc2_.command == MCPCommands.GET_WIFI_STATE)
            {
               if(!_loc2_.payload || _loc2_.payload.length < 1)
               {
                  Log.warning("[WifiSettingsScreen] received a wifi state package without payload! mcp:\n" + _loc2_);
                  return;
               }
               _loc2_.payload.position = 0;
               enableSubmission(true);
               _loc3_ = _loc2_.payload.readUnsignedByte();
               _loc4_ = WifiStates.NAMES[_loc3_];
               lblWifiState.text = Lang.getString("WIFI_STATE_" + _loc4_);
               icnWifiState.removeAllElements();
               if((_loc3_ & 128) == 128)
               {
                  icnWifiState.styleName = "failed";
                  _loc5_ = new ImgNegative();
                  _loc5_.percentHeight = 100;
                  _loc5_.percentWidth = 100;
               }
               else if((_loc3_ & 64) == 64)
               {
                  icnWifiState.styleName = "busy";
                  _loc5_ = new BusyIndicator();
                  _loc5_.percentHeight = 80;
                  _loc5_.percentWidth = 80;
               }
               else if(_loc3_ == WifiStates.CONNECTED)
               {
                  icnWifiState.styleName = "connected";
                  _loc5_ = new ImgPositive();
                  _loc5_.percentHeight = 100;
                  _loc5_.percentWidth = 100;
                  enableSubmission(false);
               }
               else
               {
                  icnWifiState.styleName = "notConnected";
                  _loc5_ = new ImgInfo();
                  _loc5_.percentHeight = 100;
                  _loc5_.percentWidth = 100;
               }
               icnWifiState.addElement(_loc5_);
            }
            else if(_loc2_.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               Log.warning("[WifiSettingsScreen] requesting wifi state failed (MCP Error)! mcp:\n" + _loc2_);
            }
            else
            {
               Log.warning("[WifiSettingsScreen] requesting wifi state failed (unexpected MCP)! mcp:\n" + _loc2_);
            }
         });
      }
      
      private function readNetworkData() : void
      {
         var loadBox:LoadBox = null;
         var loader:URLLoader = null;
         var onComplete:Function = null;
         var onError:Function = null;
         loadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("WIFI_LOADING_DATA_TITLE");
         loadBox.contentText = Lang.getString("WIFI_LOADING_DATA_CONTENT");
         loadBox.open(null);
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,onComplete = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            var _loc2_:* = loader.data;
            var _loc3_:* = _loc2_.match(SSID_SCAN_REGEX)[0];
            var _loc4_:* = _loc2_.match(PASSPHRASE_SCAN_REGEX)[0];
            txtSSID.text = _loc3_;
            txtPassphrase.text = _loc4_;
            loadBox.close();
         });
         loader.addEventListener(IOErrorEvent.IO_ERROR,onError = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            Log.error("[WifiSettingsScreen] Could not load http data\n" + param1);
            loadBox.close();
         });
         loader.load(new URLRequest(this.httpHost));
      }
      
      private function enableSubmission(param1:Boolean = true) : void
      {
         this.btnSubmit.enabled = param1;
         this.btnScan.enabled = param1;
         this.txtSSID.enabled = param1;
         this.txtPassphrase.enabled = param1;
      }
      
      private function onSelectWifi() : void
      {
         var loadBox:LoadBox = null;
         loadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("WIFI_SCANNING_TITLE");
         loadBox.contentText = Lang.getString("WIFI_SCANNING_CONTENT");
         loadBox.open(null);
         this.timeoutTimer = new Timer(WIFI_SCAN_TIMEOUT,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onScanTimeout);
         this.timeoutTimer.start();
         this.scannedWifis = [];
         this.mcpReceiver.start(this.onMCP);
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createScanWifi(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[WifiSettingsScreen] requesting mcp scan_wifi failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            timeoutTimer.reset();
            mcpReceiver.stop();
            loadBox.close();
            if(param1.response.command == MCPCommands.SCAN_WIFI && param1.response.response)
            {
               showWifis();
            }
            else if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               Log.warning("[WifiSettingsScreen] scan_wifi failed (error)! mcp:\n" + param1.response);
            }
            else
            {
               Log.warning("[WifiSettingsScreen] scan_wifi failed (unexpected MCP)! mcp:\n" + param1.response);
            }
         });
      }
      
      private function onRefresh(param1:TimerEvent) : void
      {
         this.loadNetworkState();
      }
      
      private function onScanTimeout(param1:Event) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onScanTimeout);
         this.mcpReceiver.stop();
         LoadBox.sharedBox.close();
      }
      
      private function get httpHost() : String
      {
         return "http://" + AppCache.sharedCache.connectedGateway.address + "/index.htm";
      }
      
      private function onMCP(param1:MCPPackage, param2:MCPPackage) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         Log.debug("[WifiSettingScreen] received MCP");
         if(param1.command != MCPCommands.WIFI_FOUND && param1.command != MCPCommands.ERROR)
         {
            return;
         }
         Log.debug("[WifiSettingScreen] MCP is WIFI found");
         if(param1.command == MCPCommands.WIFI_FOUND)
         {
            _loc3_ = param1.payload.readUnsignedByte();
            _loc4_ = param1.payload.readUTFBytes(param1.payload.bytesAvailable);
            this.scannedWifis.push(_loc4_);
            Log.debug("[WifiSettingScreen] ADD WIFI");
         }
         else if(param1.command == MCPCommands.ERROR)
         {
            Log.debug("[WifiSettingScreen] received MCP ERROR");
            if(!param1.payload || param1.payload.length < 1)
            {
               Log.error("[WifiSettingsScreen] Received MCP Error without payload!\n" + param1);
               return;
            }
            param1.payload.position = 0;
            _loc5_ = param1.payload.readUnsignedByte();
            if(_loc5_ == MCPErrors.GATEWAY_BUSY)
            {
               this.timeoutTimer.reset();
               this.mcpReceiver.stop();
               LoadBox.sharedBox.close();
               Log.debug("[WifiSettingsScreen] Gateway is already Scanning ...");
            }
         }
      }
      
      private function showWifis() : void
      {
         var box:SelectBox = null;
         var onClose:Function = null;
         var errorBox:ErrorBox = null;
         if(this.scannedWifis == null || this.scannedWifis.length <= 0)
         {
            errorBox = ErrorBox.sharedBox;
            errorBox.title = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID");
            errorBox.contentText = Lang.getString("WIFI_STATE_AP_NOT_FOUND");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         box = new SelectBox(this.scannedWifis,this.txtSSID.text);
         box.title = Lang.getString("GENERAL_SELECT");
         box.addEventListener(PopUpEvent.CLOSE,onClose = function(param1:PopUpEvent):void
         {
            box.removeEventListener(PopUpEvent.CLOSE,onClose);
            if(!param1.commit)
            {
               return;
            }
            txtSSID.text = param1.data;
         });
         box.open(null);
      }
      
      private function onSave() : void
      {
         var loader:URLLoader = null;
         var onComplete:Function = null;
         var onError:Function = null;
         var request:URLRequest = new URLRequest(this.httpHost);
         request.method = URLRequestMethod.POST;
         request.idleTimeout = 3800;
         URLRequestDefaults.idleTimeout = 3800;
         var vars:URLVariables = new URLVariables();
         vars.Ssid = this.txtSSID.text;
         vars.wsec = "WPAAuto";
         vars.pw = this.txtPassphrase.text;
         request.data = vars;
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,onComplete = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            Log.debug("[WifiSettingsScreen] Save complete");
         });
         loader.addEventListener(IOErrorEvent.IO_ERROR,onError = function(param1:Event):void
         {
            loader.removeEventListener(Event.COMPLETE,onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            Log.debug("[WifiSettingsScreen] Saveing failed\n" + param1);
         });
         loader.load(request);
      }
      
      private function onHelp(param1:BottomBarEvent) : void
      {
         if(param1.ctrlKey)
         {
            this.txtSSID.text = "ISIS-IC";
            this.txtPassphrase.text = "0Nk3L0770I5TD4";
            return;
         }
         new WifiSettingsScreenOverlay(this.icnWifiState,this.lblWifiState,this.txtSSID,this.btnScan,this.txtPassphrase,this.btnSubmit,this.btnCancel,this.bbar.callout).open(null);
      }
      
      private function _WifiSettingsScreen_Array1_c() : Array
      {
         var _loc1_:Array = [this._WifiSettingsScreen_GatewayDisplay1_i(),this._WifiSettingsScreen_SkinnableContainer1_i(),this._WifiSettingsScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_GatewayDisplay1_i() : GatewayDisplay
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
      
      private function _WifiSettingsScreen_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.layout = this._WifiSettingsScreen_VerticalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._WifiSettingsScreen_Array2_c);
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.paddingLeft = 20;
         _loc1_.paddingRight = 20;
         _loc1_.paddingTop = 20;
         _loc1_.paddingBottom = 20;
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._WifiSettingsScreen_Label1_i(),this._WifiSettingsScreen_HGroup1_c(),this._WifiSettingsScreen_Spacer1_c(),this._WifiSettingsScreen_VGroup1_c(),this._WifiSettingsScreen_Spacer2_c(),this._WifiSettingsScreen_Label3_i(),this._WifiSettingsScreen_Spacer3_c(),this._WifiSettingsScreen_Label4_i(),this._WifiSettingsScreen_HGroup2_c(),this._WifiSettingsScreen_Spacer4_c(),this._WifiSettingsScreen_Label5_i(),this._WifiSettingsScreen_TextInput2_i(),this._WifiSettingsScreen_Spacer5_c(),this._WifiSettingsScreen_HGroup3_c()];
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "title";
         _loc1_.id = "_WifiSettingsScreen_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._WifiSettingsScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_WifiSettingsScreen_Label1",this._WifiSettingsScreen_Label1);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._WifiSettingsScreen_SkinnableContainer2_i(),this._WifiSettingsScreen_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_SkinnableContainer2_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.width = 64;
         _loc1_.height = 64;
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "icnWifiState";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.icnWifiState = _loc1_;
         BindingManager.executeBindings(this,"icnWifiState",this.icnWifiState);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.maxDisplayedLines = -1;
         _loc1_.id = "lblWifiState";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblWifiState = _loc1_;
         BindingManager.executeBindings(this,"lblWifiState",this.lblWifiState);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalAlign = "center";
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._WifiSettingsScreen_SkinnableContainer3_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_SkinnableContainer3_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.height = 1;
         _loc1_.setStyle("backgroundColor",13421772);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Spacer2_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "title";
         _loc1_.id = "_WifiSettingsScreen_Label3";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._WifiSettingsScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_WifiSettingsScreen_Label3",this._WifiSettingsScreen_Label3);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Spacer3_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_WifiSettingsScreen_Label4";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._WifiSettingsScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_WifiSettingsScreen_Label4",this._WifiSettingsScreen_Label4);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._WifiSettingsScreen_TextInput1_i(),this._WifiSettingsScreen_Button1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.percentWidth = 100;
         _loc1_.returnKeyLabel = "next";
         _loc1_.addEventListener("enter",this.__txtSSID_enter);
         _loc1_.id = "txtSSID";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.txtSSID = _loc1_;
         BindingManager.executeBindings(this,"txtSSID",this.txtSSID);
         return _loc1_;
      }
      
      public function __txtSSID_enter(param1:FlexEvent) : void
      {
         stage.focus = this.txtPassphrase;
      }
      
      private function _WifiSettingsScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnScan_click);
         _loc1_.id = "btnScan";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnScan = _loc1_;
         BindingManager.executeBindings(this,"btnScan",this.btnScan);
         return _loc1_;
      }
      
      public function __btnScan_click(param1:MouseEvent) : void
      {
         this.onSelectWifi();
      }
      
      private function _WifiSettingsScreen_Spacer4_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_WifiSettingsScreen_Label5";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._WifiSettingsScreen_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_WifiSettingsScreen_Label5",this._WifiSettingsScreen_Label5);
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_TextInput2_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.percentWidth = 100;
         _loc1_.displayAsPassword = true;
         _loc1_.returnKeyLabel = "done";
         _loc1_.addEventListener("enter",this.__txtPassphrase_enter);
         _loc1_.id = "txtPassphrase";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.txtPassphrase = _loc1_;
         BindingManager.executeBindings(this,"txtPassphrase",this.txtPassphrase);
         return _loc1_;
      }
      
      public function __txtPassphrase_enter(param1:FlexEvent) : void
      {
         stage.focus = null;
      }
      
      private function _WifiSettingsScreen_Spacer5_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 20;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_HGroup3_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._WifiSettingsScreen_Button2_i(),this._WifiSettingsScreen_Button3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WifiSettingsScreen_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.percentWidth = 50;
         _loc1_.addEventListener("click",this.__btnCancel_click);
         _loc1_.id = "btnCancel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnCancel = _loc1_;
         BindingManager.executeBindings(this,"btnCancel",this.btnCancel);
         return _loc1_;
      }
      
      public function __btnCancel_click(param1:MouseEvent) : void
      {
         this.dispose();
         navigator.popView();
      }
      
      private function _WifiSettingsScreen_Button3_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.percentWidth = 50;
         _loc1_.addEventListener("click",this.__btnSubmit_click);
         _loc1_.id = "btnSubmit";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnSubmit = _loc1_;
         BindingManager.executeBindings(this,"btnSubmit",this.btnSubmit);
         return _loc1_;
      }
      
      public function __btnSubmit_click(param1:MouseEvent) : void
      {
         this.onSave();
      }
      
      private function _WifiSettingsScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 0;
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
         this.onHelp(param1);
      }
      
      public function ___WifiSettingsScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _WifiSettingsScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_WIFI_SETTINGS");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return gwDisplay.height + 25;
         },null,"content.top");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("WIFI_ACTIVE_STATE");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_WifiSettingsScreen_Label1.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("WIFI_STATE_NOT_CONNECTED");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblWifiState.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("WIFI_SETTINGS");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_WifiSettingsScreen_Label3.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("WIFI_SELECTED_NETWORK");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_WifiSettingsScreen_Label4.text");
         result[6] = new Binding(this,function():Number
         {
            return btnScan.height;
         },null,"btnScan.width");
         result[7] = new Binding(this,function():Object
         {
            return new ImgSearch_White();
         },function(param1:Object):void
         {
            btnScan.setStyle("icon",param1);
         },"btnScan.icon");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("WIFI_PASSPHRASE");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_WifiSettingsScreen_Label5.text");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_BACK");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnCancel.label");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("GENERAL_CONNNECT");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"btnSubmit.label");
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
      public function get btnCancel() : Button
      {
         return this._117924854btnCancel;
      }
      
      public function set btnCancel(param1:Button) : void
      {
         var _loc2_:Object = this._117924854btnCancel;
         if(_loc2_ !== param1)
         {
            this._117924854btnCancel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnCancel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnScan() : Button
      {
         return this._206187257btnScan;
      }
      
      public function set btnScan(param1:Button) : void
      {
         var _loc2_:Object = this._206187257btnScan;
         if(_loc2_ !== param1)
         {
            this._206187257btnScan = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnScan",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnSubmit() : Button
      {
         return this._594113940btnSubmit;
      }
      
      public function set btnSubmit(param1:Button) : void
      {
         var _loc2_:Object = this._594113940btnSubmit;
         if(_loc2_ !== param1)
         {
            this._594113940btnSubmit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnSubmit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : SkinnableContainer
      {
         return this._951530617content;
      }
      
      public function set content(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
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
      public function get icnWifiState() : SkinnableContainer
      {
         return this._2116680264icnWifiState;
      }
      
      public function set icnWifiState(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._2116680264icnWifiState;
         if(_loc2_ !== param1)
         {
            this._2116680264icnWifiState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icnWifiState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblWifiState() : Label
      {
         return this._398939494lblWifiState;
      }
      
      public function set lblWifiState(param1:Label) : void
      {
         var _loc2_:Object = this._398939494lblWifiState;
         if(_loc2_ !== param1)
         {
            this._398939494lblWifiState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblWifiState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get txtPassphrase() : TextInput
      {
         return this._574077798txtPassphrase;
      }
      
      public function set txtPassphrase(param1:TextInput) : void
      {
         var _loc2_:Object = this._574077798txtPassphrase;
         if(_loc2_ !== param1)
         {
            this._574077798txtPassphrase = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtPassphrase",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get txtSSID() : TextInput
      {
         return this._878574101txtSSID;
      }
      
      public function set txtSSID(param1:TextInput) : void
      {
         var _loc2_:Object = this._878574101txtSSID;
         if(_loc2_ !== param1)
         {
            this._878574101txtSSID = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"txtSSID",_loc2_,param1));
            }
         }
      }
   }
}
