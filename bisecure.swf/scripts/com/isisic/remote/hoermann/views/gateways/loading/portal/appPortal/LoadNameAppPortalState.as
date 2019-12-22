package com.isisic.remote.hoermann.views.gateways.loading.portal.appPortal
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.valueObjects.Gateway;
   import com.isisic.remote.hoermann.views.gateways.loading.LoadGatewaysState;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import com.isisic.remote.lw.net.HTTPClient;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import me.mweber.states.StateContextBase;
   
   public class LoadNameAppPortalState extends LoadGatewaysState
   {
       
      
      private var loader:Vector.<MCPLoader>;
      
      public function LoadNameAppPortalState(param1:StateContextBase, param2:Boolean)
      {
         super(param1,param2);
      }
      
      override public function enterState() : void
      {
         var _loc2_:Gateway = null;
         var _loc3_:ConnectionContext = null;
         nextState = new IdleAppPortalState(context,true);
         super.enterState();
         this.loader = new Vector.<MCPLoader>();
         var _loc1_:MCPLoader = null;
         for each(_loc2_ in gatewayList)
         {
            if(_loc2_.name == null)
            {
               _loc3_ = this.createConnection(_loc2_);
               _loc3_.httpAutentication = HTTPClient.createBasicAuth(HoermannRemote.appData.portalData.deviceId,HoermannRemote.appData.portalData.password);
               _loc1_ = Logicware.initMCPLoader(_loc3_,this.onNameLoaded,this.onNameLoadFailed);
               this.loader.push(_loc1_);
               Logicware.API.connect(_loc3_);
            }
         }
         for each(_loc1_ in this.loader)
         {
            _loc1_.request(MCPBuilder.buildMCP(Commands.GET_NAME));
         }
      }
      
      override public function exitState() : void
      {
         var _loc1_:MCPLoader = null;
         super.exitState();
         if(this.loader != null)
         {
            for each(_loc1_ in this.loader)
            {
               this.disposeMcpLoader(_loc1_);
            }
            this.loader = null;
         }
      }
      
      private function onNameLoaded(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc2_:MCPLoader = param1.currentTarget as MCPLoader;
         var _loc3_:Gateway = ArrayHelper.findByProperty("mac",_loc2_.context.mac,gatewayList);
         if(_loc3_ != null)
         {
            _loc4_ = "Gateway " + _loc2_.context.mac;
            _loc5_ = _loc2_.data.payload;
            if(_loc5_ != null && _loc5_.length > 0)
            {
               _loc5_.position = 0;
               _loc4_ = _loc5_.readUTFBytes(_loc5_.bytesAvailable);
            }
            else
            {
               Debug.error("[LoadNameAppPortalState] name could not be unwrapped! (Payload is empty)");
            }
            _loc3_.name = _loc4_;
         }
         else
         {
            Debug.error("[LoadNameAppPortalState] no gateway found for response!");
         }
         this.disposeMcpLoader(_loc2_);
         if(this.loader == null || this.loader.length <= 0)
         {
            (nextState as LoadGatewaysState).gatewayList = gatewayList;
            goNext();
         }
      }
      
      private function onNameLoadFailed(param1:Event) : void
      {
         var _loc2_:MCPLoader = param1.currentTarget as MCPLoader;
         var _loc3_:Gateway = ArrayHelper.findByProperty("mac",_loc2_.context.mac,gatewayList);
         if(_loc3_ != null)
         {
            _loc3_.name = "Gateway " + _loc2_.context.mac;
         }
         else
         {
            Debug.error("[LoadNameAppPortalState] no gateway found for response!");
         }
         this.disposeMcpLoader(_loc2_);
         if(this.loader == null || this.loader.length <= 0)
         {
            (nextState as LoadGatewaysState).gatewayList = gatewayList;
            goNext();
         }
      }
      
      private function disposeMcpLoader(param1:MCPLoader) : void
      {
         param1.context.dispose();
         Logicware.finalizeMCPLoader(param1,this.onNameLoaded,this.onNameLoadFailed);
         if(this.loader != null && this.loader.indexOf(param1) >= 0)
         {
            this.loader.splice(this.loader.indexOf(param1),1);
         }
      }
      
      private function createConnection(param1:Gateway) : ConnectionContext
      {
         return Logicware.API.createContext(Features.portalHostCommunication,443,HoermannRemote.appData.portalData.deviceId,param1.mac,ConnectionTypes.PORTAL,param1.mac);
      }
   }
}
