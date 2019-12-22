package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class LoginEvent extends Event
   {
      
      public static const LOGIN:String = "LOGIN";
      
      public static const CANCELED:String = "LOGIN_CANCELED";
       
      
      public function LoginEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
