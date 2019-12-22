package com.isisic.remote.hoermann.views.gateways.loading.portal.appPortal
{
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.hoermann.net.portal.PortalCommunicator;
   import com.isisic.remote.hoermann.net.portal.PortalGatewayEvent;
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import com.isisic.remote.lw.Debug;
   import me.mweber.states.StateContextBase;
   
   public class LoadAppPortalState extends LoadGatewaysState
   {
       
      
      public function LoadAppPortalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         nextState = new IdleAppPortalState(context,true);
         super.enterState();
         if(!this.isPortalAvailable())
         {
            nextState = new IdleAppPortalState(context,true);
            goNext();
            return;
         }
         gatewayList = new Array();
         PortalCommunicator.defaultCommunicator.addEventListener(PortalGatewayEvent.LOADED,this.onGatewaysLoaded);
         PortalCommunicator.defaultCommunicator.addEventListener(PortalGatewayEvent.LOADING_FAILED,this.onGatewayLoadingFailed);
         PortalCommunicator.defaultCommunicator.requestStatus();
      }
      
      override public function exitState() : void
      {
         super.exitState();
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADED,this.onGatewaysLoaded);
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADING_FAILED,this.onGatewayLoadingFailed);
         gatewayList = null;
      }
      
      private function isPortalAvailable() : Boolean
      {
         return HoermannRemote.appData != null && HoermannRemote.appData.portalData != null && HoermannRemote.appData.portalData.deviceId != null && HoermannRemote.appData.portalData.deviceId != "";
      }
      
      private function onGatewaysLoaded(param1:PortalGatewayEvent) : void
      {
         var _loc3_:Gateway = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADED,this.onGatewaysLoaded);
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADING_FAILED,this.onGatewayLoadingFailed);
         var _loc2_:Boolean = false;
         for each(_loc4_ in param1.gateways)
         {
            _loc3_ = new Gateway();
            _loc3_.parseObject(_loc4_);
            _loc3_.isPortal = true;
            _loc5_ = ArrayHelper.findByProperty("mac",_loc3_.mac,HoermannRemote.appData.gateways);
            if(_loc5_ != null && _loc5_.name != null && _loc5_.name != "Gateway " + _loc5_.mac)
            {
               _loc3_.name = _loc5_.name;
            }
            else
            {
               _loc2_ = true;
            }
            gatewayList.push(_loc3_);
         }
         if(_loc2_)
         {
            nextState = new LoadNameAppPortalState(context,false);
         }
         (nextState as LoadGatewaysState).gatewayList = gatewayList;
         goNext();
      }
      
      private function onGatewayLoadingFailed(param1:PortalGatewayEvent) : void
      {
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADED,this.onGatewaysLoaded);
         PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADING_FAILED,this.onGatewayLoadingFailed);
         Debug.warning("[LoadPortalState] Loading portal gateways failed!");
         goNext();
      }
   }
}
