package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import refactor.bisecur._2_SAL.net.HmTransition;
   
   public class FES_StateHelper extends StateHelperBase
   {
       
      
      public function FES_StateHelper()
      {
         super();
      }
      
      override public function forceTransition(param1:HmTransition) : HmTransition
      {
         return param1;
      }
   }
}
