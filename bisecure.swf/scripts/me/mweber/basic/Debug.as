package me.mweber.basic
{
   import flash.globalization.DateTimeFormatter;
   import flash.globalization.LocaleID;
   
   public class Debug
   {
      
      public static var WRITE_DEBUG:Boolean = true;
      
      public static var WRITE_INFO:Boolean = true;
      
      public static var WRITE_WARNING:Boolean = true;
      
      public static var WRITE_ERROR:Boolean = true;
       
      
      public function Debug()
      {
         super();
      }
      
      public static function debug(param1:String) : Boolean
      {
         return Debug.write("DEBUG",param1);
      }
      
      public static function info(param1:String) : Boolean
      {
         return Debug.write("INFO",param1);
      }
      
      public static function warning(param1:String) : Boolean
      {
         return Debug.write("WARNING",param1);
      }
      
      public static function error(param1:String) : Boolean
      {
         return Debug.write("ERROR",param1);
      }
      
      private static function write(param1:String, param2:String) : Boolean
      {
         switch(param1.toUpperCase())
         {
            case "DEBUG":
               if(!WRITE_DEBUG)
               {
                  return false;
               }
               break;
            case "INFO":
               if(!WRITE_INFO)
               {
                  return false;
               }
               break;
            case "WARNING":
               if(!WRITE_WARNING)
               {
                  return false;
               }
               break;
            case "ERROR":
               if(!WRITE_ERROR)
               {
                  return false;
               }
               break;
         }
         var _loc3_:DateTimeFormatter = new DateTimeFormatter(LocaleID.DEFAULT);
         _loc3_.setDateTimePattern("HH:mm:ss");
         var _loc4_:Date = new Date();
         return true;
      }
   }
}
