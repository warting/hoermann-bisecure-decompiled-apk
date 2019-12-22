package me.mweber.states
{
   import flash.events.Event;
   
   public class StateChangeEvent extends Event
   {
      
      public static const ENTER_STATE:String = "enterState";
      
      public static const EXIT_STATE:String = "exitState";
       
      
      protected var _state:StateBase;
      
      protected var _stateContext:StateContextBase;
      
      public function StateChangeEvent(param1:StateBase, param2:StateContextBase, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         super(param3,param4,param5);
         this._state = param1;
         this._stateContext = param2;
      }
      
      public function get stateContext() : StateContextBase
      {
         return this._stateContext;
      }
   }
}
