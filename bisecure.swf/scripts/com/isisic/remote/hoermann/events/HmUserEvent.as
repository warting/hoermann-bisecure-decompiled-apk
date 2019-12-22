package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class HmUserEvent extends Event
   {
      
      public static const DELETE:String = "HMUSER_DELETE";
       
      
      public function HmUserEvent(param1:String)
      {
         super(param1,true,false);
      }
   }
}
