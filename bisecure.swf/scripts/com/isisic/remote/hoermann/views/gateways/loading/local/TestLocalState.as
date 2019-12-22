package com.isisic.remote.hoermann.views.gateways.loading.local
{
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.hoermann.views.gateways.ConnectionTest;
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import me.mweber.basic.ObjectInfos;
   import me.mweber.states.StateContextBase;
   
   public class TestLocalState extends LoadGatewaysState
   {
       
      
      private var tests:Vector.<ConnectionTest>;
      
      public function TestLocalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         var _loc1_:ConnectionContext = null;
         var _loc2_:Gateway = null;
         var _loc3_:ConnectionTest = null;
         nextState = new IdleLocalState(context,true);
         super.enterState();
         this.tests = new Vector.<ConnectionTest>();
         for each(_loc2_ in gatewayList)
         {
            this.tests.push(new ConnectionTest(this.createConnection(_loc2_),this.onConnectionTested));
         }
         for each(_loc3_ in this.tests)
         {
            _loc3_.testConnection();
         }
         if(this.tests.length <= 0)
         {
            (nextState as LoadGatewaysState).gatewayList = gatewayList;
            goNext();
         }
      }
      
      override public function exitState() : void
      {
         var _loc1_:ConnectionTest = null;
         super.exitState();
         if(this.tests != null && this.tests.length > 0)
         {
            for each(_loc1_ in this.tests)
            {
               _loc1_.context.dispose();
               _loc1_.dispose();
            }
            this.tests = null;
         }
         this.gatewayList = null;
      }
      
      private function onConnectionTested(param1:Boolean, param2:ConnectionTest, param3:String) : void
      {
         var _loc4_:ConnectionContext = param2.context;
         if(_loc4_.processor.client != null)
         {
            Debug.debug("[TestLocalState] disconnecting: " + ObjectInfos.getMemoryHash(_loc4_.processor.client) + " isConnected: " + _loc4_.connected + " clientConnected: " + _loc4_.processor.client.connected);
         }
         Logicware.API.disconnect(_loc4_);
         var _loc5_:Gateway = ArrayHelper.findByProperty("mac",_loc4_.mac,gatewayList);
         if(_loc5_ == null)
         {
            Debug.error("[TestLocalState] Tested gateway not found! Mac:" + _loc4_.mac);
         }
         _loc5_.available = param1;
         _loc5_.host = _loc5_.localIp;
         _loc5_.port = _loc5_.localPort;
         if(param3 != null)
         {
            _loc5_.name = param3;
         }
         else if(param1)
         {
            Debug.error("[TestLocalState] Gateway has been tested but no name was loaded! Mac:" + _loc4_.mac);
         }
         param2.dispose();
         this.tests.splice(this.tests.indexOf(param2),1);
         if(this.tests.length <= 0)
         {
            (nextState as LoadGatewaysState).gatewayList = gatewayList;
            goNext();
         }
      }
      
      private function createConnection(param1:Gateway) : ConnectionContext
      {
         return Logicware.API.createContext(param1.localIp,param1.localPort,Logicware.API.clientId,param1.mac,ConnectionTypes.LOCAL,param1.mac);
      }
   }
}
