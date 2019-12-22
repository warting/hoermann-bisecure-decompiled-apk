package com.isisic.remote.hoermann.global.stateHelper.implementation
{
   import com.isisic.remote.hoermann.global.helper.HmTransitionHelper;
   import com.isisic.remote.hoermann.net.HmTransition;
   import mx.core.IVisualElement;
   
   public class ESE_StateHelper extends StateHelperBase
   {
       
      
      public function ESE_StateHelper()
      {
         super();
      }
      
      override public function forceTransition(param1:HmTransition) : HmTransition
      {
         return super.forceTransition(param1);
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
         if(HmTransitionHelper.isDefinedHalfOpened(param2))
         {
            return "(H)";
         }
         return "";
      }
   }
}
