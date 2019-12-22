package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.ActorState;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   
   public class HET_E2_StateHelper extends StateHelperBase
   {
       
      
      public function HET_E2_StateHelper()
      {
         super();
      }
      
      override public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         return null;
      }
      
      override public function forceState(param1:HmTransition, param2:Boolean) : String
      {
         param1.hcp = null;
         switch(true)
         {
            case HmTransitionHelper.isOpened(param1):
               return ActorState.OPEN;
            case HmTransitionHelper.isClosed(param1):
               return ActorState.CLOSED;
            default:
               return ActorState.HALF_2;
         }
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         if(param2.actual > 0 && param2.actual < 200)
         {
            return Lang.getString("DRIVE_MESSAGE_HALF_MOVING");
         }
         return null;
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return "";
      }
   }
}
