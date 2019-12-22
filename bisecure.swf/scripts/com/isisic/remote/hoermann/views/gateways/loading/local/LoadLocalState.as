package com.isisic.remote.hoermann.views.gateways.loading.local
{
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import me.mweber.states.StateContextBase;
   
   public class LoadLocalState extends LoadGatewaysState
   {
       
      
      public function LoadLocalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         var _loc2_:Object = null;
         super.enterState();
         if(HoermannRemote.appData != null)
         {
            nextState = new TestLocalState(context,false);
         }
         else
         {
            nextState = new IdleLocalState(context,true);
            goNext();
         }
         gatewayList = new Array();
         var _loc1_:Gateway = null;
         for each(_loc2_ in HoermannRemote.appData.gateways)
         {
            _loc1_ = new Gateway();
            _loc1_.parseObject(_loc2_);
            _loc1_.available = false;
            _loc1_.isPortal = false;
            gatewayList.push(_loc1_);
         }
         (nextState as LoadGatewaysState).gatewayList = gatewayList;
         goNext();
      }
      
      override public function exitState() : void
      {
         super.exitState();
         this.gatewayList = null;
      }
   }
}
