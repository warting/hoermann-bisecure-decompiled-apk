package com.isisic.remote.hoermann.global.helper
{
   public final class StringValidator
   {
       
      
      public function StringValidator()
      {
         super();
      }
      
      public static function checkUsername(param1:String) : Boolean
      {
         return param1.length <= 20 && param1.length >= 2;
      }
      
      public static function checkPasswd(param1:String) : Boolean
      {
         return param1.length <= 20 && param1.length >= 4;
      }
      
      public static function checkGroupname(param1:String) : Boolean
      {
         return param1.length <= 20 && param1.length >= 1;
      }
      
      public static function checkGatewayName(param1:String) : Boolean
      {
         return param1.length <= 20 && param1.length >= 2;
      }
      
      public static function checkDeviceID(param1:String) : Boolean
      {
         if(param1.length != 12)
         {
            return false;
         }
         return true;
      }
   }
}
