package mx.utils
{
   import flash.system.Capabilities;
   import flash.utils.getDefinitionByName;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Platform
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var _instance:Platform;
      
      protected static var _initialized:Boolean;
      
      protected static var _isAndroid:Boolean;
      
      protected static var _isIOS:Boolean;
      
      protected static var _isIPad:Boolean;
      
      protected static var _isBlackBerry:Boolean;
      
      protected static var _isMobile:Boolean;
      
      protected static var _isMac:Boolean;
      
      protected static var _isWindows:Boolean;
      
      protected static var _isLinux:Boolean;
      
      protected static var _isDesktop:Boolean;
      
      protected static var _isBrowser:Boolean;
      
      protected static var _isAir:Boolean;
      
      private static var _osVersion:String = null;
      
      mx_internal static var androidVersionOverride:String;
      
      mx_internal static var iosVersionOverride:String;
       
      
      public function Platform()
      {
         super();
      }
      
      public static function get isIOS() : Boolean
      {
         getPlatforms();
         return _isIOS;
      }
      
      public static function get isIPad() : Boolean
      {
         getPlatforms();
         return _isIPad;
      }
      
      public static function get isBlackBerry() : Boolean
      {
         getPlatforms();
         return _isBlackBerry;
      }
      
      public static function get isAndroid() : Boolean
      {
         getPlatforms();
         return _isAndroid;
      }
      
      public static function get isWindows() : Boolean
      {
         getPlatforms();
         return _isWindows;
      }
      
      public static function get isMac() : Boolean
      {
         getPlatforms();
         return _isMac;
      }
      
      public static function get isLinux() : Boolean
      {
         getPlatforms();
         return _isLinux;
      }
      
      public static function get isDesktop() : Boolean
      {
         getPlatforms();
         return _isDesktop;
      }
      
      public static function get isMobile() : Boolean
      {
         getPlatforms();
         return _isMobile;
      }
      
      public static function get isAir() : Boolean
      {
         getPlatforms();
         return _isAir;
      }
      
      public static function get isBrowser() : Boolean
      {
         getPlatforms();
         return _isBrowser;
      }
      
      public static function get osVersion() : String
      {
         if(_osVersion == null)
         {
            if(mx_internal::androidVersionOverride == null && mx_internal::iosVersionOverride == null)
            {
               _osVersion = computeOSVersionString();
            }
            else if(mx_internal::androidVersionOverride != null)
            {
               _osVersion = mx_internal::androidVersionOverride;
            }
            else if(mx_internal::iosVersionOverride != null)
            {
               _osVersion = mx_internal::iosVersionOverride;
            }
         }
         return _osVersion;
      }
      
      protected static function getPlatforms() : void
      {
         var _loc1_:Class = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(!_initialized)
         {
            _loc1_ = Capabilities;
            _loc2_ = Capabilities.version;
            _loc3_ = Capabilities.os;
            _loc4_ = Capabilities.playerType;
            _isAndroid = _loc2_.indexOf("AND") > -1;
            _isIOS = _loc2_.indexOf("IOS") > -1;
            _isBlackBerry = _loc2_.indexOf("QNX") > -1;
            _isMobile = _isAndroid || _isIOS || _isBlackBerry;
            _isMac = _loc3_.indexOf("Mac OS") != -1;
            _isWindows = _loc3_.indexOf("Windows") != -1;
            _isLinux = _loc3_.indexOf("Linux") != -1;
            _isIPad = _loc3_.indexOf("iPad") > -1;
            _isDesktop = !_isMobile;
            _isAir = _loc4_ == "Desktop";
            _isBrowser = _loc4_ == "PlugIn" || _loc4_ == "ActiveX";
            _initialized = true;
         }
      }
      
      private static function computeOSVersionString() : String
      {
         var osVersionMatch:Array = null;
         var mobileHelperClass:Class = null;
         var os:String = Capabilities.os;
         var version:String = "";
         if(isIOS)
         {
            osVersionMatch = os.match(/iPhone OS\s([\d\.]+)/);
            if(osVersionMatch && osVersionMatch.length == 2)
            {
               version = osVersionMatch[1];
            }
         }
         else if(isAndroid)
         {
            try
            {
               mobileHelperClass = Class(getDefinitionByName("spark.utils::PlatformMobileHelper"));
               if(mobileHelperClass != null)
               {
                  version = mobileHelperClass["computeOSVersionForAndroid"]();
               }
            }
            catch(e:Error)
            {
               trace("Error: " + e.message);
            }
         }
         else
         {
            osVersionMatch = os.match(/[A-Za-z\s]+([\d\.]+)/);
            if(osVersionMatch && osVersionMatch.length == 2)
            {
               version = osVersionMatch[1];
            }
         }
         return version;
      }
   }
}
