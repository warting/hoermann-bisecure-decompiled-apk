package refactor.bisecur._1_APP
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
   import com.isisic.remote.hoermann.global.cfg.updates.Update_1;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_2;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_3;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_4;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_5;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_6;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_7;
   import com.isisic.remote.hoermann.global.cfg.updates.Update_8;
   import com.isisic.remote.hoermann.skins.ActionBarSkin;
   import com.isisic.remote.hoermann.skins.BiSecurViewNavigatorApplicationSkin;
   import com.isisic.remote.hoermann.skins.CheckboxSkin;
   import com.isisic.remote.hoermann.skins.GateButtonSkin;
   import com.isisic.remote.hoermann.skins.HiddenScrollBarSkin;
   import com.isisic.remote.hoermann.skins.PopupButtonSkin;
   import com.isisic.remote.hoermann.skins.TextInputSkin;
   import com.isisic.remote.hoermann.views.channels.ChannelContentSkin;
   import com.isisic.remote.hoermann.views.home.HomeButtonSkin;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.styles.CSSCondition;
   import mx.styles.CSSSelector;
   import mx.styles.CSSStyleDeclaration;
   import refactor.bisecur._1_APP.views.bootloader.Bootloader;
   import spark.components.ViewNavigatorApplication;
   import spark.skins.android4.TransparentActionButtonSkin;
   import spark.skins.ios7.CalloutSkin;
   import spark.skins.mobile.BusyIndicatorSkin;
   
   use namespace mx_internal;
   
   public class BiSecurApp extends ViewNavigatorApplication implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
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
      
      mx_internal var _BiSecurApp_StylesInit_done:Boolean = false;
      
      private var _embed__font_RobotoRegular_bold_normal_1938544467:Class;
      
      private var _embed__font_MarkerFelt_medium_normal_374878036:Class;
      
      private var _embed__font_RobotoRegular_medium_normal_2117808449:Class;
      
      private var _embed__font_RobotoBold_bold_normal_408492680:Class;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BiSecurApp()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._embed__font_RobotoRegular_bold_normal_1938544467 = BiSecurApp__embed__font_RobotoRegular_bold_normal_1938544467;
         this._embed__font_MarkerFelt_medium_normal_374878036 = BiSecurApp__embed__font_MarkerFelt_medium_normal_374878036;
         this._embed__font_RobotoRegular_medium_normal_2117808449 = BiSecurApp__embed__font_RobotoRegular_medium_normal_2117808449;
         this._embed__font_RobotoBold_bold_normal_408492680 = BiSecurApp__embed__font_RobotoBold_bold_normal_408492680;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._BiSecurApp_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_BiSecurAppWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return BiSecurApp[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.applicationDPI = 320;
         this.firstView = Bootloader;
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BiSecurApp._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         mx_internal::_BiSecurApp_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function _BiSecurApp_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return UIConfig.STYLE_NAME;
         },null,"this.styleName");
         return result;
      }
      
      mx_internal function _BiSecurApp_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         if(mx_internal::_BiSecurApp_StylesInit_done)
         {
            return;
         }
         mx_internal::_BiSecurApp_StylesInit_done = true;
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         conditions = [];
         condition = new CSSCondition("id","actionGroup");
         conditions.push(condition);
         selector = new CSSSelector("spark.components.Group",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.ActionBar spark.components.Group#actionGroup spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               if(styleManager.acceptMediaList("(os-platform:\"IOS\") and (min-os-version:7)"))
               {
                  this.skinClass = TransparentActionButtonSkin;
               }
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 3355443;
               this.color = 16777215;
               this.textShadowColor = 16777215;
               this.skinClass = GateButtonSkin;
               this.backgroundAlpha = 1;
               this.downColor = 5592405;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.List spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = PopupButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.views.home.HomeScreen",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.views.home.HomeScreen spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 408958;
               this.skinClass = HomeButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","popupContent");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("*.popupContent spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 3355443;
               this.color = 16777215;
               this.textShadowColor = 16777215;
               this.skinClass = GateButtonSkin;
               this.backgroundAlpha = 1;
               this.downColor = 5592405;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","bottomCallout");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("*.bottomCallout spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 16777215;
               this.skinClass = PopupButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","popupTitle");
         conditions.push(condition);
         selector = new CSSSelector("*",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("*.popupTitle spark.components.Button");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = PopupButtonSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("me.mweber.itemRenderer.RoundetTableItemRenderer",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Button",conditions,selector);
         style = styleManager.getStyleDeclaration("me.mweber.itemRenderer.RoundetTableItemRenderer spark.components.Button");
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
         conditions = null;
         selector = new CSSSelector("spark.components.ViewNavigatorApplication",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.ViewNavigatorApplication");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 14973;
               this.skinClass = BiSecurViewNavigatorApplicationSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.ActionBar",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.ActionBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textShadowAlpha = 1;
               this.showLogo = false;
               this.textShadowColor = 0;
               this.skinClass = ActionBarSkin;
               this.chromeColor = 3355443;
               this.titleAlign = "center";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("me.mweber.itemRenderer.RoundetTableItemRenderer",conditions,selector);
         style = styleManager.getStyleDeclaration("me.mweber.itemRenderer.RoundetTableItemRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 4221853;
               this.alternatingItemColors = [14973,14973];
               this.color = 16777215;
               this.selectionColor = 16750848;
               this.downColor = 16750848;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.List");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.contentBackgroundAlpha = 0;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.HScrollBar",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.List spark.components.HScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fixedThumbSize = true;
               this.skinClass = HiddenScrollBarSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.List",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.VScrollBar",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.List spark.components.VScrollBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fixedThumbSize = true;
               this.skinClass = HiddenScrollBarSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.TextInput",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.TextInput");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderVisible = false;
               this.backgroundColor = 3355443;
               this.skinClass = TextInputSkin;
               this.backgroundAlpha = 0.5;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.CheckBox",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.CheckBox");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.skinClass = CheckboxSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.components.BottomBar",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.components.BottomBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textShadowAlpha = 1;
               this.showLogo = false;
               this.textShadowColor = 0;
               this.skinClass = ActionBarSkin;
               this.chromeColor = 14973;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.popups.Popup",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.popups.Popup");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.backgroundAlpha = 0.5;
            };
         }
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
         condition = new CSSCondition("class","whiteWheel");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".whiteWheel");
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
         condition = new CSSCondition("class","logoutButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".logoutButton");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 3355443;
               this.color = 16777215;
               this.textShadowColor = 16777215;
               this.backgroundAlpha = 1;
               this.downColor = 5592405;
            };
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","toggleActionButton");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".toggleActionButton");
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
         condition = new CSSCondition("class","GatewayDisplay");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".GatewayDisplay");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 4473924;
               this.color = 10132122;
               this.backgroundAlpha = 0.9;
               this.fontWeight = "bold";
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
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.views.gateways.renderer.GatewayRenderer",conditions,selector);
         conditions = [];
         condition = new CSSCondition("class","title");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.views.gateways.renderer.GatewayRenderer .title");
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
         condition = new CSSCondition("class","subTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".subTitle");
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
         condition = new CSSCondition("class","error");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".error");
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
         condition = new CSSCondition("class","loginContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".loginContent");
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
         condition = new CSSCondition("class","popupTitle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".popupTitle");
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
         condition = new CSSCondition("class","popupContent");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".popupContent");
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
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.Callout",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.Callout");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderThickness = 0;
               this.contentBackgroundAppearance = "flat";
               this.backgroundColor = 3355443;
               this.frameThickness = 0;
               this.gap = 12;
               this.skinClass = CalloutSkin;
               this.contentBackgroundColor = 16185078;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.BusyIndicator",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.BusyIndicator");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.rotationInterval = 50;
               this.skinClass = BusyIndicatorSkin;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.bottom_bar.BottomBar",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.bottom_bar.BottomBar");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.textShadowAlpha = 1;
               this.textShadowColor = 0;
               this.chromeColor = 14973;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.GatewayDisplay",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.GatewayDisplay");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 4473924;
               this.color = 10132122;
               this.backgroundAlpha = 0.9;
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.skins.GateButtonSkin",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.skins.GateButtonSkin");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 10532303;
               this.backgroundColors = [8100284,14973];
               this.downColors = [16370559,16750848];
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.overlays.OverlayBase",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.overlays.OverlayBase");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 1118481;
               this.backgroundAlpha = 0.7;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.overlays.OverlayBase",conditions,selector);
         conditions = null;
         selector = new CSSSelector("spark.components.Label",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.overlays.OverlayBase spark.components.Label");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.fontFamily = "MarkerFelt";
               this.fontSize = 30;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.arrowColor = 16777215;
               this.arrowThickness = 5;
               this.color = 16777215;
               this.arrowAlpha = 1;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("spark.components.View",conditions,selector);
         style = styleManager.getStyleDeclaration("spark.components.View");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 14973;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.renderer.SelectBoxItemRenderer",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.renderer.SelectBoxItemRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 16777215;
               this.color = 0;
               this.selectionColor = 14973;
               this.fontWeight = "bold";
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.views.home.HomeListRenderer",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.views.home.HomeListRenderer");
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
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.views.deviceActions.ChannelContentSkin",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.views.deviceActions.ChannelContentSkin");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 4221853;
               this.bgColor = 14973;
               this.borderAlpha = 1;
               this.cornerRadius = 30;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("refactor.bisecur._1_APP.views.deviceActions.DeviceActionsScreen",conditions,selector);
         style = styleManager.getStyleDeclaration("refactor.bisecur._1_APP.views.deviceActions.DeviceActionsScreen");
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
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.components.VLine",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.components.VLine");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 0;
               this.foregroundColor = 11184810;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.renderer.LearnPortRenderer",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.renderer.LearnPortRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.backgroundColor = 16777215;
               this.color = 0;
               this.selectionColor = 10532303;
               this.backgroundAlpha = 1;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.views.notifications.NotificationIcon",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.views.notifications.NotificationIcon");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.circleFontSize = 30;
            };
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("com.isisic.remote.hoermann.views.notifications.NotificationRenderer",conditions,selector);
         style = styleManager.getStyleDeclaration("com.isisic.remote.hoermann.views.notifications.NotificationRenderer");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.alternatingItemColors = 14973;
               this.color = 16777215;
               this.downColor = 5658198;
            };
         }
         styleManager.initProtoChainRoots();
      }
   }
}
