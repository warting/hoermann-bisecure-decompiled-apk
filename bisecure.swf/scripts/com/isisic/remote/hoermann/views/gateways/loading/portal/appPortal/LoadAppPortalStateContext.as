package com.isisic.remote.hoermann.views.gateways.loading.portal.appPortal
{
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysStateContext;
   
   public class LoadAppPortalStateContext extends LoadGatewaysStateContext
   {
       
      
      public function LoadAppPortalStateContext()
      {
         super();
         this.reset();
      }
      
      override public function reset() : void
      {
         super.reset();
         setState(new IdleAppPortalState(this,false));
      }
   }
}
