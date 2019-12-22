package com.isisic.remote.hoermann.global.valueObjects
{
   public class GatewayVersions
   {
      
      public static const EE001425_06_OR_LOWER:String = "<=EE001425-06";
      
      public static const EE001425_07:String = "EE001425-07";
      
      public static const EE001425_08:String = "EE001425-08";
      
      public static const EE001425_09:String = "EE001425-09";
      
      public static const EE001425_10:String = "EE001425-10";
      
      public static const NR_EE001425_06_OR_LOWER:uint = 6;
      
      public static const NR_EE001425_07:uint = 7;
      
      public static const NR_EE001425_08:uint = 8;
      
      public static const NR_EE001425_09:uint = 9;
      
      public static const NR_EE001425_10:uint = 10;
      
      public static const NAMES:Object = {
         6:EE001425_06_OR_LOWER,
         7:EE001425_07,
         8:EE001425_08,
         9:EE001425_09,
         10:EE001425_10
      };
       
      
      public function GatewayVersions()
      {
         super();
      }
      
      public static function numberFromName(param1:String) : uint
      {
         return parseInt(param1.substr(-2),10);
      }
      
      public static function nameFromNumber(param1:uint) : String
      {
         return NAMES[param1];
      }
   }
}
