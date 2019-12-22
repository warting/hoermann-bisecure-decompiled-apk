package com.isisic.remote.hoermann.views.gateways.loading.local
{
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysStateContext;
   
   public class LoadLocalStateContext extends LoadGatewaysStateContext
   {
       
      
      public function LoadLocalStateContext()
      {
         super();
         this.reset();
      }
      
      override public function reset() : void
      {
         super.reset();
         setState(new IdleLocalState(this,false));
      }
   }
}
