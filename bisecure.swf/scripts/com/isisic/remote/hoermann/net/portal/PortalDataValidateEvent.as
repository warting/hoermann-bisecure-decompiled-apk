package com.isisic.remote.hoermann.net.portal
{
   import flash.events.Event;
   
   public class PortalDataValidateEvent extends Event
   {
      
      public static const VALIDATED:String = "PortalDataValidated";
      
      public static const VALIDATION_FAILED:String = "PortalDataValidationFailed";
      
      public static const AUTH_FAILED:String = "PortalDataValidationAuthFailed";
       
      
      public function PortalDataValidateEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
