package com.isisic.remote.hoermann.views.gateways.loading.local
{
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import me.mweber.states.StateContextBase;
   
   public class IdleLocalState extends LoadGatewaysState
   {
       
      
      public function IdleLocalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         nextState = new LoadLocalState(context,false);
         super.enterState();
         if(!scanFinished)
         {
            goNext();
         }
      }
   }
}
