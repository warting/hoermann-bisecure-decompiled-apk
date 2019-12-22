package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class GatewayEvent extends Event
   {
      
      public static const DELETE:String = "gateway_delete";
       
      
      public function GatewayEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
