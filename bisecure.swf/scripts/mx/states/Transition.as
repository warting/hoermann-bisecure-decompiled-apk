package mx.states
{
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   
   use namespace mx_internal;
   
   public class Transition
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public var effect:IEffect;
      
      public var fromState:String = "*";
      
      public var toState:String = "*";
      
      public var autoReverse:Boolean = false;
      
      public var interruptionBehavior:String;
      
      public function Transition()
      {
         this.interruptionBehavior = InterruptionBehavior.END;
         super();
      }
   }
}
