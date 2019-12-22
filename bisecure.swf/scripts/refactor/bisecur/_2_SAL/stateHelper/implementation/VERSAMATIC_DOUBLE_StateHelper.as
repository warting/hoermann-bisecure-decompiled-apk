package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   
   public class VERSAMATIC_DOUBLE_StateHelper extends StateHelperBase
   {
       
      
      public function VERSAMATIC_DOUBLE_StateHelper()
      {
         super();
      }
      
      override public function forceTransition(param1:HmTransition) : HmTransition
      {
         return super.forceTransition(param1);
      }
      
      override public function forceState(param1:HmTransition, param2:Boolean) : String
      {
         if(!param2 || param1 == null)
         {
            return super.forceState(param1,param2);
         }
         if(param1.exst == null || param1.exst.length < 5)
         {
            return super.forceState(param1,param2);
         }
         var _loc3_:Number = (param1.exst[5] as Number) / 2;
         var _loc4_:Number = (param1.exst[4] as Number) / 2;
         return this.getStateByPosition(_loc3_) + ":" + this.getStateByPosition(_loc4_);
      }
      
      private function getStateByPosition(param1:Number) : String
      {
         return HmTransitionHelper.getActorStateFromPercent(param1);
      }
   }
}
