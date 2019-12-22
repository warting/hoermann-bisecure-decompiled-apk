package com.isisic.remote.hoermann.global
{
   public class WifiStates
   {
      
      public static const CONNECTED:int = 0;
      
      public static const NOT_CONNECTED:int = 1;
      
      public static const BUSY:int = 64;
      
      public static const AP_NOT_FOUND:int = 128;
      
      public static const SECURITY_MISMATCH:int = 129;
      
      public static const AUTHENTICATION_FAILURE:int = 130;
      
      public static const CONNECTION_FAILURE:int = 131;
      
      public static const NAMES:Object = {
         0:"CONNECTED",
         1:"NOT_CONNECTED",
         64:"BUSY",
         128:"AP_NOT_FOUND",
         129:"SECURITY_MISMATCH",
         130:"AUTHENTICATION_FAILURE",
         131:"CONNECTION_FAILURE"
      };
       
      
      public function WifiStates()
      {
         super();
      }
   }
}
