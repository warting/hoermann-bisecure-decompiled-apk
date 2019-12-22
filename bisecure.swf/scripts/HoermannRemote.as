package
{
   import com.isisic.remote.hoermann.assets.images.gates.OTHER;
   import com.isisic.remote.hoermann.assets.images.gates.closed.DOOR;
   import com.isisic.remote.hoermann.assets.images.gates.closed.HORIZONTAL_SECTIONAL_DOOR;
   import com.isisic.remote.hoermann.assets.images.gates.closed.JACK;
   import com.isisic.remote.hoermann.assets.images.gates.closed.LIGHT;
   import com.isisic.remote.hoermann.assets.images.gates.closed.SECTIONAL_DOOR;
   import com.isisic.remote.hoermann.assets.images.gates.closed.SLIDING_GATE;
   import com.isisic.remote.hoermann.assets.images.gates.closed.SWING_GATE_DOUBLE;
   import com.isisic.remote.hoermann.assets.images.gates.closed.SWING_GATE_SINGLE;
   import com.isisic.remote.hoermann.assets.images.ports.AUTO_CLOSE;
   import com.isisic.remote.hoermann.assets.images.ports.DOWN;
   import com.isisic.remote.hoermann.assets.images.ports.HALF;
   import com.isisic.remote.hoermann.assets.images.ports.IMPULS;
   import com.isisic.remote.hoermann.assets.images.ports.IMPULS_SHORT;
   import com.isisic.remote.hoermann.assets.images.ports.LIFT;
   import com.isisic.remote.hoermann.assets.images.ports.LOCK;
   import com.isisic.remote.hoermann.assets.images.ports.OFF;
   import com.isisic.remote.hoermann.assets.images.ports.ON;
   import com.isisic.remote.hoermann.assets.images.ports.ON_OFF;
   import com.isisic.remote.hoermann.assets.images.ports.OPEN_DOOR;
   import com.isisic.remote.hoermann.assets.images.ports.SINK;
   import com.isisic.remote.hoermann.assets.images.ports.UNLOCK;
   import com.isisic.remote.hoermann.assets.images.ports.UP;
   import com.isisic.remote.hoermann.assets.images.ports.WALK;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.ConfirmBox;
   import com.isisic.remote.hoermann.components.popups.ErrorBox;
   import com.isisic.remote.hoermann.components.popups.LoadBox;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.CustomFeatures;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.UserDataStorage;
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.JSONConfig;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_1;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_2;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_3;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_4;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_5;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_6;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_7;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_8;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.views.Bootloader;
   import com.isisic.remote.hoermann.views.channels.ChannelContentSkin;
   import com.isisic.remote.hoermann.views.gateways.SelectGateway;
   import com.isisic.remote.hoermann.views.notifications.NotificationLoader;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.mcp.MCPManager;
   import com.isisic.remote.lw.mcp.events.LoginEvent;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.system.Capabilities;
   import me.mweber.basic.helper.ApplicationHelper;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSCondition;
   import mx.styles.CSSSelector;
   import mx.styles.CSSStyleDeclaration;
   import spark.components.ViewNavigatorApplication;
   import spark.transitions.ViewTransitionBase;
   
   public class HoermannRemote extends ViewNavigatorApplication
   {
      
      public static const GROUP_LOADING_TIMEOUT:int = 60000;
      
      public static var isActive:Boolean = true;
      
      private static var _96801app:HoermannRemote;
      
      public static var WINDOW_WIDTH:Number;
      
      public static var WINDOW_HEIGHT:Number;
      
      public static var loadBox:LoadBox;
      
      public static var errorBox:ErrorBox;
      
      public static var confirmBox:ConfirmBox;
      
      private static var _794434197appData:AppData;
      
      private static var _435820530gatewayData:GatewayData;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _configUpdate_1:Update_1;
      
      private var _configUpdate_2:Update_2;
      
      private var _configUpdate_3:Update_3;
      
      private var _configUpdate_4:Update_4;
      
      private var _configUpdate_5:Update_5;
      
      private var _configUpdate_6:Update_6;
      
      private var _configUpdate_7:Update_7;
      
      private var _configUpdate_8:Update_8;
      
      private var _closed_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.closed.SECTIONAL_DOOR;
      
      private var _closed_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.closed.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _closed_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.closed.SWING_GATE_SINGLE;
      
      private var _closed_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.closed.SWING_GATE_DOUBLE;
      
      private var _closed_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.closed.SLIDING_GATE;
      
      private var _closed_DOOR:com.isisic.remote.hoermann.assets.images.gates.closed.DOOR;
      
      private var _closed_LIGHT:com.isisic.remote.hoermann.assets.images.gates.closed.LIGHT;
      
      private var _closed_JACK:com.isisic.remote.hoermann.assets.images.gates.closed.JACK;
      
      private var _closed_OTHER:com.isisic.remote.hoermann.assets.images.gates.OTHER;
      
      private var _half_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.half.SECTIONAL_DOOR;
      
      private var _half_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.half.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _half_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.half.SWING_GATE_SINGLE;
      
      private var _half_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.half.SWING_GATE_DOUBLE;
      
      private var _half_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.half.SLIDING_GATE;
      
      private var _half_DOOR:com.isisic.remote.hoermann.assets.images.gates.half.DOOR;
      
      private var _half_LIGHT:com.isisic.remote.hoermann.assets.images.gates.half.LIGHT;
      
      private var _half_JACK:com.isisic.remote.hoermann.assets.images.gates.half.JACK;
      
      private var _opened_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.opened.SECTIONAL_DOOR;
      
      private var _opened_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.opened.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _opened_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.opened.SWING_GATE_SINGLE;
      
      private var _opened_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.opened.SWING_GATE_DOUBLE;
      
      private var _opened_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.opened.SLIDING_GATE;
      
      private var _opened_DOOR:com.isisic.remote.hoermann.assets.images.gates.opened.DOOR;
      
      private var _opened_LIGHT:com.isisic.remote.hoermann.assets.images.gates.opened.LIGHT;
      
      private var _opened_JACK:com.isisic.remote.hoermann.assets.images.gates.opened.JACK;
      
      private var _undefined_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.undefined.SECTIONAL_DOOR;
      
      private var _undefined_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.undefined.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _undefined_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.undefined.SWING_GATE_SINGLE;
      
      private var _undefined_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.undefined.SWING_GATE_DOUBLE;
      
      private var _undefined_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.undefined.SLIDING_GATE;
      
      private var _undefined_DOOR:com.isisic.remote.hoermann.assets.images.gates.undefined.DOOR;
      
      private var _undefined_LIGHT:com.isisic.remote.hoermann.assets.images.gates.undefined.LIGHT;
      
      private var _undefined_JACK:com.isisic.remote.hoermann.assets.images.gates.undefined.JACK;
      
      private var _error_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.error.SECTIONAL_DOOR;
      
      private var _error_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.error.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _error_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.error.SWING_GATE_SINGLE;
      
      private var _error_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.error.SWING_GATE_DOUBLE;
      
      private var _error_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.error.SLIDING_GATE;
      
      private var _error_DOOR:com.isisic.remote.hoermann.assets.images.gates.error.DOOR;
      
      private var _error_LIGHT:com.isisic.remote.hoermann.assets.images.gates.error.LIGHT;
      
      private var _error_JACK:com.isisic.remote.hoermann.assets.images.gates.error.JACK;
      
      private var _autoClose_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.autoClose.SECTIONAL_DOOR;
      
      private var _autoClose_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gates.autoClose.HORIZONTAL_SECTIONAL_DOOR;
      
      private var _autoClose_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gates.autoClose.SWING_GATE_SINGLE;
      
      private var _autoClose_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gates.autoClose.SWING_GATE_DOUBLE;
      
      private var _autoClose_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gates.autoClose.SLIDING_GATE;
      
      private var _autoClose_DOOR:com.isisic.remote.hoermann.assets.images.gates.autoClose.DOOR;
      
      private var _autoClose_LIGHT:com.isisic.remote.hoermann.assets.images.gates.autoClose.LIGHT;
      
      private var _autoClose_JACK:com.isisic.remote.hoermann.assets.images.gates.autoClose.JACK;
      
      private var thumb_closed_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.SECTIONAL_DOOR;
      
      private var thumb_closed_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_closed_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.SWING_GATE_SINGLE;
      
      private var thumb_closed_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.SWING_GATE_DOUBLE;
      
      private var thumb_closed_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.SLIDING_GATE;
      
      private var thumb_closed_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.DOOR;
      
      private var thumb_closed_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.LIGHT;
      
      private var thumb_closed_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.closed.JACK;
      
      private var thumb_closed_OTHER:com.isisic.remote.hoermann.assets.images.gateThumbs.OTHER;
      
      private var thumb_half_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.half.SECTIONAL_DOOR;
      
      private var thumb_half_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.half.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_half_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.half.SWING_GATE_DOUBLE;
      
      private var thumb_half_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.half.SWING_GATE_SINGLE;
      
      private var thumb_half_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.half.SLIDING_GATE;
      
      private var thumb_half_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.half.DOOR;
      
      private var thumb_half_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.half.LIGHT;
      
      private var thumb_half_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.half.JACK;
      
      private var thumb_opened_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.SECTIONAL_DOOR;
      
      private var thumb_opened_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_opened_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.SWING_GATE_SINGLE;
      
      private var thumb_opened_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.SWING_GATE_DOUBLE;
      
      private var thumb_opened_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.SLIDING_GATE;
      
      private var thumb_opened_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.DOOR;
      
      private var thumb_opened_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.LIGHT;
      
      private var thumb_opened_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.opened.JACK;
      
      private var thumb_undefined_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.SECTIONAL_DOOR;
      
      private var thumb_undefined_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_undefined_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.SWING_GATE_SINGLE;
      
      private var thumb_undefined_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.SWING_GATE_DOUBLE;
      
      private var thumb_undefined_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.SLIDING_GATE;
      
      private var thumb_undefined_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.DOOR;
      
      private var thumb_undefined_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.LIGHT;
      
      private var thumb_undefined_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.undefined.JACK;
      
      private var thumb_error_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.error.SECTIONAL_DOOR;
      
      private var thumb_error_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.error.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_error_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.error.SWING_GATE_SINGLE;
      
      private var thumb_error_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.error.SWING_GATE_DOUBLE;
      
      private var thumb_error_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.error.SLIDING_GATE;
      
      private var thumb_error_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.error.DOOR;
      
      private var thumb_error_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.error.LIGHT;
      
      private var thumb_error_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.error.JACK;
      
      private var thumb_autoClose_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.SECTIONAL_DOOR;
      
      private var thumb_autoClose_HORIZONTAL_SECTIONAL_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.HORIZONTAL_SECTIONAL_DOOR;
      
      private var thumb_autoClose_SWING_GATE_SINGLE:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.SWING_GATE_SINGLE;
      
      private var thumb_autoClose_SWING_GATE_DOUBLE:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.SWING_GATE_DOUBLE;
      
      private var thumb_autoClose_SLIDING_GATE:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.SLIDING_GATE;
      
      private var thumb_autoClose_DOOR:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.DOOR;
      
      private var thumb_autoClose_LIGHT:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.LIGHT;
      
      private var thumb_autoClose_JACK:com.isisic.remote.hoermann.assets.images.gateThumbs.autoClose.JACK;
      
      private var port_IMPULS:IMPULS;
      
      private var port_IMPULS_SHORT:IMPULS_SHORT;
      
      private var port_IMPULS_LONG:AUTO_CLOSE;
      
      private var port_ON_OFF:ON_OFF;
      
      private var port_UP:UP;
      
      private var port_DOWN:DOWN;
      
      private var port_HALF:HALF;
      
      private var port_WALK:WALK;
      
      private var port_LIGHT:com.isisic.remote.hoermann.assets.images.ports.LIGHT;
      
      private var port_ON:ON;
      
      private var port_OFF:OFF;
      
      private var port_LOCK:LOCK;
      
      private var port_UNLOCK:UNLOCK;
      
      private var port_OPEN_DOOR:OPEN_DOOR;
      
      private var port_LIFT:LIFT;
      
      private var port_SINK:SINK;
      
      private var _1601832653editMode:Boolean = false;
      
      mx_internal var _HoermannRemote_StylesInit_done:Boolean = false;
      
      private var _embed__font_RobotoRegular_bold_normal_210891490:Class;
      
      private var _embed__font_RobotoBold_bold_normal_1737038659:Class;
      
      private var _embed__font_RobotoRegular_medium_normal_31627508:Class;
      
      private var _embed__font_MarkerFelt_medium_normal_26904710:Class;
      
      public function HoermannRemote()
      {
         this._embed__font_RobotoRegular_bold_normal_210891490 = HoermannRemote__embed__font_RobotoRegular_bold_normal_210891490;
         this._embed__font_RobotoBold_bold_normal_1737038659 = HoermannRemote__embed__font_RobotoBold_bold_normal_1737038659;
         this._embed__font_RobotoRegular_medium_normal_31627508 = HoermannRemote__embed__font_RobotoRegular_medium_normal_31627508;
         this._embed__font_MarkerFelt_medium_normal_26904710 = HoermannRemote__embed__font_MarkerFelt_medium_normal_26904710;
         super();
         mx_internal::_document = this;
         this.applicationDPI = 320;
         this.firstView = Bootloader;
         this.splashScreenScaleMode = "zoom";
         this.styleName = "mixed";
         this.addEventListener("applicationComplete",this.___HoermannRemote_ViewNavigatorApplication1_applicationComplete);
         this.addEventListener("preinitialize",this.___HoermannRemote_ViewNavigatorApplication1_preinitialize);
         this.addEventListener("initialize",this.___HoermannRemote_ViewNavigatorApplication1_initialize);
      }
      
      [Bindable(event="propertyChange")]
      public static function get app() : HoermannRemote
      {
         return HoermannRemote._96801app;
      }
      
      public static function set app(param1:HoermannRemote) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = HoermannRemote._96801app;
         if(_loc2_ !== param1)
         {
            HoermannRemote._96801app = param1;
            _loc3_ = HoermannRemote.staticEventDispatcher;
            if(_loc3_ != null && _loc3_.hasEventListener("propertyChange"))
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(HoermannRemote,"app",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get appData() : AppData
      {
         return HoermannRemote._794434197appData;
      }
      
      public static function set appData(param1:AppData) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = HoermannRemote._794434197appData;
         if(_loc2_ !== param1)
         {
            HoermannRemote._794434197appData = param1;
            _loc3_ = HoermannRemote.staticEventDispatcher;
            if(_loc3_ != null && _loc3_.hasEventListener("propertyChange"))
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(HoermannRemote,"appData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public static function get gatewayData() : GatewayData
      {
         return HoermannRemote._435820530gatewayData;
      }
      
      public static function set gatewayData(param1:GatewayData) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = HoermannRemote._435820530gatewayData;
         if(_loc2_ !== param1)
         {
            HoermannRemote._435820530gatewayData = param1;
            _loc3_ = HoermannRemote.staticEventDispatcher;
            if(_loc3_ != null && _loc3_.hasEventListener("propertyChange"))
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(HoermannRemote,"gatewayData",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         mx_internal::_HoermannRemote_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function preInitApp() : void
      {
         var _loc1_:int = 0;
         if(ApplicationHelper.applicationVersion() == "" || ApplicationHelper.applicationVersion() == null)
         {
            _loc1_ = 0;
            while(_loc1_ < 100)
            {
               _loc1_++;
            }
         }
         Lang.init();
         new CustomFeatures().load().apply().dispose();
         Features.apply();
         MultiDevice.exec();
      }
      
      public function initApp() : void
      {
         navigator.styleName = "mixed";
         NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,function(param1:Event):void
         {
            Debug.debug("[HoermannRemote] DEACTIVATE");
            UserDataStorage.currentStorage.appDeactivated();
            UserDataStorage.currentStorage.save();
            HoermannRemote.isActive = false;
            if(HoermannRemote.appData)
            {
               HoermannRemote.appData.save();
            }
            if(Capabilities.os.substr(0,3) == "Win")
            {
               return;
            }
            if(Features.autoLogout || Capabilities.os.indexOf("iPhone") > -1)
            {
               HoermannRemote.app.logout();
            }
         });
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,function(param1:Event):void
         {
            var e:Event = param1;
            Debug.debug("[HoermannRemote] ACTIVATE");
            UserDataStorage.currentStorage.appActivated();
            if(HoermannRemote.appData != null)
            {
               HoermannRemote.appData.useAutoLogin = true;
            }
            Debug.debug("[HoermannRemote] updating Notifications");
            NotificationLoader.instance.update(function():void
            {
               var _loc1_:int = 0;
               while(_loc1_ < navigator.activeView.numElements)
               {
                  if(navigator.activeView.getElementAt(_loc1_) is BottomBar)
                  {
                     (navigator.activeView.getElementAt(_loc1_) as BottomBar).invalidateDisplayList();
                  }
                  _loc1_++;
               }
            });
            HoermannRemote.isActive = true;
            if(HoermannRemote.app.navigator.activeView is SelectGateway)
            {
               if(Features.autoLogout || Capabilities.os.indexOf("iPhone") > -1)
               {
                  HoermannRemote.app.navigator.replaceView(Bootloader,null,null,new ViewTransitionBase());
               }
            }
         });
         var cfg:AsConfig = new JSONConfig();
         HoermannRemote.app = this;
         HoermannRemote.appData = new AppData(cfg);
         HoermannRemote.gatewayData = new GatewayData();
         HoermannRemote.loadBox = new LoadBox();
         HoermannRemote.errorBox = new ErrorBox();
         HoermannRemote.confirmBox = new ConfirmBox();
         if(appData.portalData != null)
         {
            Logicware.API.clientId = appData.portalData.deviceId;
         }
         UserDataStorage.currentStorage.appActivated();
         MultiDevice.exec();
      }
      
      public function onComplete() : void
      {
         WINDOW_WIDTH = this.width;
         WINDOW_HEIGHT = this.height;
         this.updateNotifications();
      }
      
      private function updateNotifications() : void
      {
         if(navigator == null || navigator.activeView == null)
         {
            callLater(this.updateNotifications);
            return;
         }
         Debug.debug("[HoermannRemote] updating Notifications");
         NotificationLoader.instance.update(function():void
         {
            var _loc1_:int = 0;
            while(_loc1_ < navigator.activeView.numElements)
            {
               if(navigator.activeView.getElementAt(_loc1_) is BottomBar)
               {
                  (navigator.activeView.getElementAt(_loc1_) as BottomBar).invalidateDisplayList();
               }
               _loc1_++;
            }
         });
      }
      
      public function login(param1:ConnectionContext) : void
      {
         HoermannRemote.appData.useAutoLogin = true;
         param1.processor.addEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
         param1.processor.addEventListener(Event.CLOSE,this.onDisconnect);
         param1.processor.addEventListener(LoginEvent.LOGOUT,this.onLogout);
      }
      
      private function onLogout(param1:LoginEvent) : void
      {
         this.logout();
      }
      
      private function onConnectionError(param1:IOErrorEvent) : void
      {
         this.logout();
         this.closePopups();
         HoermannRemote.errorBox.title = Lang.getString("ERROR_CONNECTION_CLOSED");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_CONNECTION_CLOSED_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
      }
      
      private function onDisconnect(param1:Event) : void
      {
         this.logout();
         this.closePopups();
         HoermannRemote.errorBox.title = Lang.getString("ERROR_CONNECTION_CLOSED");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_CONNECTION_CLOSED_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
      }
      
      public function closePopups() : void
      {
         HoermannRemote.loadBox.close();
         HoermannRemote.errorBox.close();
         HoermannRemote.confirmBox.close();
      }
      
      public function logout() : void
      {
         var context:ConnectionContext = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         Debug.info("[HoermannRemote] Logout begin!");
         if(HoermannRemote.appData.activeConnection)
         {
            context = HoermannRemote.appData.activeConnection;
            context.processor.removeEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
            context.processor.removeEventListener(Event.CLOSE,this.onDisconnect);
            context.processor.removeEventListener(LoginEvent.LOGOUT,this.onLogout);
            if(context.connected)
            {
               loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
               {
                  Debug.info("[HoermannRemote] Logout request finished!");
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  Logicware.API.disconnect(context);
                  context.dispose();
               },loaderFailed = function(param1:Event):void
               {
                  Debug.warning("[HoermannRemote] Logout request failed! mcp:\n" + param1);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  Logicware.API.disconnect(context);
                  context.dispose();
               });
               loader.request(MCPBuilder.buildMCP(Commands.LOGOUT));
            }
            else
            {
               Logicware.API.disconnect(context);
               context.dispose();
            }
            HoermannRemote.appData.activeConnection = null;
            HoermannRemote.gatewayData.clear();
         }
         if(HmProcessor.defaultProcessor)
         {
            HmProcessor.defaultProcessor.destruct();
         }
         appData.dispose();
         appData = null;
         gatewayData.dispose();
         MCPManager.defaultManager.token = 0;
         HoermannRemote.app.navigator.popAll(new ViewTransitionBase());
         Bootloader.useAutoLogin = false;
         HoermannRemote.app.navigator.replaceView(Bootloader,null,null,new ViewTransitionBase());
         Popup.closeAll();
         BottomBar.username = "";
      }
      
      private function onMinimize(param1:Event) : void
      {
      }
      
      public function ___HoermannRemote_ViewNavigatorApplication1_applicationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      public function ___HoermannRemote_ViewNavigatorApplication1_preinitialize(param1:FlexEvent) : void
      {
         this.preInitApp();
      }
      
      public function ___HoermannRemote_ViewNavigatorApplication1_initialize(param1:FlexEvent) : void
      {
         this.initApp();
      }
      
      mx_internal function _HoermannRemote_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         if(mx_internal::_HoermannRemote_StylesInit_done)
         {
            return;
         }
         mx_internal::_HoermannRemote_StylesInit_done = true;
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","channelContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".channelContent");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = ChannelContentSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","channelContentTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".channelContentTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","channelContentState");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".channelContentState");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","toastMessage");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".toastMessage");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 2368548;
               this.color = 15592941;
               this.textAlign = "center";
               this.backgroundAlpha = 0.85;
               this.borderAlpha = 0;
               this.cornerRadius = 20;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","titleDisplay");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.ActionBar #titleDisplay");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","whiteWheel");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .whiteWheel");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.symbolColor = 16777215;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","listNoteTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".listNoteTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 50;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","listNoteContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".listNoteContent");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 40;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","toggleActionButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .toggleActionButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.chromeColor = 13421772;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","title");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".title");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.views.gateways.GatewayRenderer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","title");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed com.isisic.remote.hoermann.views.gateways.GatewayRenderer .title");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.disabledOverlayAlpha = 0.5;
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","subTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .subTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 14606046;
               this.fontSize = 25;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","error");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .error");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10035763;
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","loginContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .loginContent");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","popupTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .popupTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.symbolColor = 0;
               this.fontSize = 40;
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","mixed");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","popupContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("*.mixed .popupContent");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 0;
               this.fontSize = 30;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","actorTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".actorTitle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","actorState");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".actorState");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontSize = 25;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","actorTime");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".actorTime");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 13421772;
               this.fontSize = 25;
            };
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get editMode() : Boolean
      {
         return this._1601832653editMode;
      }
      
      public function set editMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._1601832653editMode;
         if(_loc2_ !== param1)
         {
            this._1601832653editMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"editMode",_loc2_,param1));
            }
         }
      }
   }
}
