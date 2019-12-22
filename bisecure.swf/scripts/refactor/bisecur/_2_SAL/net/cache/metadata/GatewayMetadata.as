package refactor.bisecur._2_SAL.net.cache.metadata
{
   import com.isisic.remote.hoermann.global.valueObjects.GatewayVersions;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class GatewayMetadata
   {
      
      private static var singleton:GatewayMetadata;
       
      
      private var _gatewayVersionNumber:int = -1;
      
      public function GatewayMetadata(param1:ConstructorLock#144)
      {
         super();
      }
      
      public static function get instance() : GatewayMetadata
      {
         if(singleton == null)
         {
            singleton = new GatewayMetadata(null);
         }
         return singleton;
      }
      
      public function getGatewayVersion(param1:Function = null) : void
      {
         var self:GatewayMetadata = null;
         var callback:Function = param1;
         if(this._gatewayVersionNumber >= GatewayVersions.NR_EE001425_06_OR_LOWER)
         {
            CallbackHelper.callCallback(callback,[this,this._gatewayVersionNumber,null]);
            return;
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createGetGwVersion(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            var _loc3_:ByteArray = null;
            var _loc4_:String = null;
            var _loc5_:Error = null;
            if(param1.response == null)
            {
               Log.error("[GatewayData] couldn\'t load Gateway-Firmware Version! (Net Timeout)");
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               _loc2_ = MCPErrors.getErrorFromPackage(param1.response);
               InfoCenter.onMCPError(param1.response,_loc2_);
               if(_loc2_ == MCPErrors.COMMAND_NOT_FOUND)
               {
                  Log.debug("[GatewayData] Firmware Version is <= EE001425-06");
               }
               else
               {
                  Log.warning("[GatewayData] couldn\'t load Gateway-Firmware Version! (Error: 0x" + StringHelper.int2hex(_loc2_) + " = " + MCPErrors.NAMES[_loc2_] + ")");
               }
               self._gatewayVersionNumber = GatewayVersions.NR_EE001425_06_OR_LOWER;
               CallbackHelper.callCallback(callback,[self,_gatewayVersionNumber,null]);
            }
            else if(param1.response.command == MCPCommands.GET_GW_VERSION)
            {
               _loc3_ = param1.response.payload;
               _loc3_.position = 0;
               _loc4_ = _loc3_.readUTFBytes(_loc3_.bytesAvailable);
               if(StringHelper.IsNullOrEmpty(_loc4_))
               {
                  Log.warning("[GatewayData] couldn\'t load Gateway-Firmware Version! (Invalid Payload)");
                  self._gatewayVersionNumber = GatewayVersions.NR_EE001425_06_OR_LOWER;
               }
               else
               {
                  self._gatewayVersionNumber = GatewayVersions.numberFromName(_loc4_);
               }
               CallbackHelper.callCallback(callback,[self,_gatewayVersionNumber,null]);
            }
            else
            {
               _loc5_ = new Error("Detecting Firmware Version failed!" + "(unexpected response from Gateway) MCP:\n" + param1.response.toString(),-1);
               Log.warning("[GatewayData] " + _loc5_.message);
               self._gatewayVersionNumber = GatewayVersions.NR_EE001425_06_OR_LOWER;
               CallbackHelper.callCallback(callback,[self,_gatewayVersionNumber,_loc5_]);
            }
         });
      }
      
      public function invalidateCache() : void
      {
         this._gatewayVersionNumber = -1;
      }
   }
}

class ConstructorLock#144
{
    
   
   function ConstructorLock#144()
   {
      super();
   }
}
