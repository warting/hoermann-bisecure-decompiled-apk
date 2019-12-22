package me.mweber.states
{
   import flash.events.EventDispatcher;
   
   public class StateContextBase extends EventDispatcher
   {
       
      
      private var _stateClass:Class = null;
      
      protected var _currentState:StateBase;
      
      public function StateContextBase()
      {
         super();
         this.stateClass = StateBase;
      }
      
      protected function get stateClass() : Class
      {
         return this._stateClass;
      }
      
      protected function set stateClass(param1:Class) : void
      {
         if(!(param1.prototype instanceof StateBase) && param1 != StateBase)
         {
            throw new Error("stateClass must be StateBase or a subclass");
         }
         this._stateClass = param1;
      }
      
      public function get currentState() : StateBase
      {
         return this._currentState;
      }
      
      public function setState(param1:StateBase) : void
      {
         if(!(param1 is this.stateClass))
         {
            throw new ArgumentError("state must extend " + this.stateClass);
         }
         if(this.currentState != null)
         {
            this.currentState.exitState();
            if(hasEventListener(StateChangeEvent.EXIT_STATE))
            {
               dispatchEvent(new StateChangeEvent(this.currentState,this,StateChangeEvent.EXIT_STATE));
            }
         }
         this._currentState = param1;
         this.currentState.enterState();
         if(hasEventListener(StateChangeEvent.ENTER_STATE))
         {
            dispatchEvent(new StateChangeEvent(this.currentState,this,StateChangeEvent.ENTER_STATE));
         }
      }
      
      public function dispose() : void
      {
         if(this.currentState != null)
         {
            this.currentState.exitState();
            this._currentState = null;
         }
      }
   }
}
