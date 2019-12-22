package me.mweber.basic.helper
{
   import flash.desktop.NativeApplication;
   import flash.system.Capabilities;
   
   public class ApplicationHelper
   {
       
      
      public function ApplicationHelper()
      {
         super();
      }
      
      public static function applicationVersion() : String
      {
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         var _loc3_:String = _loc1_._loc2_::["versionNumber"].toString();
         return _loc3_;
      }
      
      public static function currentOS() : String
      {
         if(Capabilities.version.indexOf("WIN") >= 0)
         {
            return "WINDOWS";
         }
         if(Capabilities.version.indexOf("AND") >= 0)
         {
            return "ANDROID";
         }
         if(Capabilities.version.indexOf("IOS") >= 0)
         {
            return "IOS";
         }
         return null;
      }
   }
}
