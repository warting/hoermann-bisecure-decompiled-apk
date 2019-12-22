package com.isisic.remote.hoermann.views.gateways.loading.portal.appPortal
{
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import me.mweber.states.StateContextBase;
   
   public class IdleAppPortalState extends LoadGatewaysState
   {
       
      
      public function IdleAppPortalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         nextState = new LoadAppPortalState(context,false);
         super.enterState();
         if(!scanFinished)
         {
            goNext();
         }
      }
   }
}
