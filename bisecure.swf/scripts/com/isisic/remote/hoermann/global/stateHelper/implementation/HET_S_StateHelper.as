package com.isisic.remote.hoermann.global.stateHelper.implementation
{
   import com.isisic.remote.hoermann.net.HmTransition;
   import mx.core.IVisualElement;
   
   public class HET_S_StateHelper extends StateHelperBase
   {
       
      
      public function HET_S_StateHelper()
      {
         super();
      }
      
      override public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         return null;
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return null;
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return "";
      }
   }
}
