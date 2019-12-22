package refactor.bisecur._2_SAL.stateHelper
{
   public class ActorState
   {
      
      public static const CLOSED:String = "closed";
      
      public static const HALF_1:String = "half_1";
      
      public static const HALF_2:String = "half_2";
      
      public static const HALF_3:String = "half_3";
      
      public static const OPEN:String = "open";
      
      public static const ON:String = CLOSED;
      
      public static const OFF:String = OPEN;
      
      public static const EXTENDED:String = CLOSED;
      
      public static const RETRACTED:String = OPEN;
      
      public static const NOT_RETRACTED:String = HALF_2;
       
      
      public function ActorState()
      {
         super();
      }
   }
}
