package com.isisic.remote.hoermann.views.gateways.loading
{
   import flash.events.Event;
   import me.mweber.states.StateBase;
   import me.mweber.states.StateContextBase;
   
   public class LoadGatewaysStateContext extends StateContextBase
   {
       
      
      public function LoadGatewaysStateContext()
      {
         super();
         stateClass = LoadGatewaysState;
      }
      
      public function get scanFinished() : Boolean
      {
         return this.getCurrentState().scanFinished;
      }
      
      public function get gatewayList() : Array
      {
         if(this.scanFinished)
         {
            return this.getCurrentState().gatewayList;
         }
         return null;
      }
      
      public function reset() : void
      {
         if(this.getCurrentState() != null)
         {
            this.getCurrentState().gatewayList = null;
         }
      }
      
      override public function setState(param1:StateBase) : void
      {
         super.setState(param1);
         if(this.scanFinished)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function getCurrentState() : LoadGatewaysState
      {
         return currentState as LoadGatewaysState;
      }
   }
}
