package com.isisic.remote.hoermann.global.stateHelper.implementation
{
   import com.isisic.remote.hoermann.global.stateHelper.IStateHelper;
   import com.isisic.remote.hoermann.net.HmTransition;
   import mx.core.IVisualElement;
   
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
