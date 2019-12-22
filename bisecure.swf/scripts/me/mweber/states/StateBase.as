package me.mweber.states
{
   import flash.errors.IllegalOperationError;
   
   public class StateBase
   {
       
      
      protected var context:StateContextBase;
      
      protected var nextState:StateBase;
      
      public function StateBase(param1:StateContextBase)
      {
         super();
         this.context = param1;
      }
      
      public function enterState() : void
      {
      }
      
      public function exitState() : void
      {
      }
      
      protected function goNext() : void
      {
         if(this.nextState == null)
         {
            throw new IllegalOperationError("nextState must not be null",1);
         }
         this.context.setState(this.nextState);
      }
   }
}
