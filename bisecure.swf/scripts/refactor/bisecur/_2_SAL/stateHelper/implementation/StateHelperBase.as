package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.IStateHelper;
   
   public class StateHelperBase implements IStateHelper
   {
       
      
      public function StateHelperBase()
      {
         super();
      }
      
      public function forceTransition(param1:HmTransition) : HmTransition
      {
         return null;
      }
      
      public function showDriveDirection(param1:HmTransition, param2:Boolean) : Boolean
      {
         return true;
      }
      
      public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         return null;
      }
      
      public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return null;
      }
      
      public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return null;
      }
      
      public function showState(param1:HmTransition, param2:Boolean) : Boolean
      {
         return true;
      }
      
      public function forceState(param1:HmTransition, param2:Boolean) : String
      {
         return null;
      }
      
      protected function getStatePercent(param1:HmTransition) : String
      {
         return " " + param1.actual / 2 + " % ";
      }
   }
}
