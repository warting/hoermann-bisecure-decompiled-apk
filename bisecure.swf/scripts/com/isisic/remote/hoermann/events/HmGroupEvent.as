package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class HmGroupEvent extends Event
   {
      
      public static const EDIT:String = "HMGROUP_EDIT";
       
      
      public function HmGroupEvent(param1:String)
      {
         super(param1,true,false);
      }
   }
}
