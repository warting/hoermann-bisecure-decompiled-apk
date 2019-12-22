package com.isisic.remote.hoermann.views.gateways.loading
{
   import me.mweber.states.StateBase;
   import me.mweber.states.StateContextBase;
   
   public class LoadGatewaysState extends StateBase
   {
       
      
      public var gatewayList:Array;
      
      public var scanFinished:Boolean;
      
      public function LoadGatewaysState(param1:StateContextBase, param2:Boolean)
      {
         super(param1);
         this.scanFinished = param2;
      }
      
      override protected function goNext() : void
      {
         super.goNext();
      }
   }
}
