package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class ScenarioEvent extends Event
   {
      
      public static const EDIT:String = "HMSCENARIO_EDIT";
       
      
      public function ScenarioEvent(param1:String)
      {
         super(param1,true,false);
      }
   }
}
