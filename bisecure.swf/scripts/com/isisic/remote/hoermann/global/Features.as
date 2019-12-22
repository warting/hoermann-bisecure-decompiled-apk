package com.isisic.remote.hoermann.global
{
   import com.isisic.remote.hoermann.components.popups.SetDebugInfoBox;
   import com.isisic.remote.lw.Debug;
   
   public class Features
   {
      
      public static var writeError:Boolean = false;
      
      public static var writeWarning:Boolean = false;
      
      public static var writeInfo:Boolean = false;
      
      public static var writeDebug:Boolean = false;
      
      public static var traceIn:Boolean = false;
      
      public static var traceOut:Boolean = false;
      
      public static var netDebugging:Boolean = false;
      
      public static var autoLogout:Boolean = false;
      
      public static var showWifi:Boolean = true;
      
      public static var validateInheritPort:Boolean = false;
      
      public static var showInvalidToken:Boolean = false;
      
      public static var showDebugLabel:Boolean = false;
      
      public static var useDevPortal:Boolean = false;
      
      public static var enableDdnsDialog:Boolean = false;
      
      public static var addDevicePortal:Boolean = false;
      
      public static var scenarioHotfix:Boolean = false;
      
      public static var presenterVersion:Boolean = false;
      
      public static var showChannelOnButton:Boolean = false;
      
      public static const forceDPI:uint = 0;
       
      
      public function Features()
      {
         super();
      }
      
      public static function get portalHostMeta() : String
      {
         if(useDevPortal)
         {
            return Portal.DEV_HOST_META;
         }
         return Portal.HOST_META;
      }
      
      public static function get portalHostCommunication() : String
      {
         if(useDevPortal)
         {
            return Portal.DEV_HOST_COMMUNICATION;
         }
         return Portal.HOST_COMMUNICATION;
      }
      
      public static function get portalHostStatus() : String
      {
         if(useDevPortal)
         {
            return Portal.DEV_HOST_STATUS;
         }
         return Portal.HOST_STATUS;
      }
      
      public static function get shouldForceDPI() : Boolean
      {
         return forceDPI > 0;
      }
      
      public static function apply() : void
      {
         Debug.WRITE_ERROR = writeError;
         Debug.WRITE_WARNING = writeWarning;
         Debug.WRITE_INFO = writeInfo;
         Debug.WRITE_DEBUG = writeDebug;
         Debug.TRACE_INPUT = traceIn;
         Debug.TRACE_OUTPUT = traceOut;
         if(!netDebugging)
         {
            SetDebugInfoBox.writeConfigData(null,0);
         }
      }
   }
}
