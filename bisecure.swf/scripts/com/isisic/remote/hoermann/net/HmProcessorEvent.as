package com.isisic.remote.hoermann.net
{
   import flash.events.Event;
   
   public class HmProcessorEvent extends Event
   {
      
      public static const TRANSITIONS_UPDATED:String = "transitionsUpdated";
      
      public static const TRANSITION_LOADED:String = "transitionLoaded";
       
      
      public function HmProcessorEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
