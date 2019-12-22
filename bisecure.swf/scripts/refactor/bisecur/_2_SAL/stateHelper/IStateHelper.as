package refactor.bisecur._2_SAL.stateHelper
{
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.net.HmTransition;
   
   public interface IStateHelper
   {
       
      
      function forceTransition(param1:HmTransition) : HmTransition;
      
      function showDriveDirection(param1:HmTransition, param2:Boolean) : Boolean;
      
      function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement;
      
      function showState(param1:HmTransition, param2:Boolean) : Boolean;
      
      function forceState(param1:HmTransition, param2:Boolean) : String;
      
      function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String;
      
      function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String;
   }
}
