package com.isisic.remote.hoermann.global.stateHelper.implementation
{
   import com.isisic.remote.hoermann.net.HmTransition;
   
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
