package refactor.bisecur._2_SAL.net.cache.ports
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmPort;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._2_SAL.net.cache.CacheBase;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class GatewayPorts extends CacheBase
   {
      
      public static const MAX_PORT_COUNT:int = AppData.MAX_PORTS;
      
      private static var singleton:GatewayPorts;
       
      
      private var portCount:int = -1;
      
      public function GatewayPorts(param1:SingletonEnforcer#149)
      {
         super();
         this.validateCache();
      }
      
      public static function get instance() : GatewayPorts
      {
         if(singleton == null)
         {
            singleton = new GatewayPorts(null);
         }
         return singleton;
      }
      
      public function addPort(param1:int, param2:Function) : void
      {
         var type:int = param1;
         var callback:Function = param2;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createAddPort(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var sender:MCPLoader = param1;
            var error:Error = checkForErrors(sender.response,"adding port");
            if(error != null)
            {
               CallbackHelper.callCallback(callback,[sender,null,error]);
               return;
            }
            var payload:ByteArray = sender.response.payload;
            payload.position = 0;
            var portId:int = payload.readUnsignedByte();
            setType(portId,type,function(param1:GatewayPorts, param2:HmPort, param3:Error):void
            {
               if(param3 != null)
               {
                  CallbackHelper.callCallback(callback,[param1,null,param3]);
                  GatewayGroups.instance.invalidateCache();
                  GatewayPorts.instance.invalidateCache();
                  return;
               }
               CallbackHelper.callCallback(callback,[param1,param2,null]);
               GatewayGroups.instance.invalidateCache();
               GatewayPorts.instance.invalidateCache();
            });
         });
      }
      
      public function inheritPort(param1:int, param2:Function) : void
      {
         var type:int = param1;
         var callback:Function = param2;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createInheritPort(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var sender:MCPLoader = param1;
            var error:Error = checkForErrors(sender.response,"inheriting port");
            if(error != null)
            {
               CallbackHelper.callCallback(callback,[sender,null,error]);
               return;
            }
            var payload:ByteArray = sender.response.payload;
            payload.position = 0;
            var portId:int = payload.readUnsignedByte();
            setType(portId,type,function(param1:GatewayPorts, param2:HmPort, param3:Error):void
            {
               if(param3 != null)
               {
                  CallbackHelper.callCallback(callback,[param1,null,param3]);
                  GatewayGroups.instance.invalidateCache();
                  GatewayPorts.instance.invalidateCache();
                  return;
               }
               CallbackHelper.callCallback(callback,[param1,param2,null]);
               GatewayGroups.instance.invalidateCache();
               GatewayPorts.instance.invalidateCache();
            });
         });
      }
      
      public function getPortCount(param1:Function = null) : int
      {
         var callback:Function = param1;
         if(isCacheValid)
         {
            CallbackHelper.callCallback(callback,[this,this.portCount,null]);
            return this.portCount;
         }
         this.validateCache(function(param1:GatewayPorts, param2:Array, param3:Error):void
         {
            if(param3 != null)
            {
               CallbackHelper.callCallback(callback,[param1,null,param3]);
               return;
            }
            CallbackHelper.callCallback(callback,[param1,portCount,null]);
         });
         return -1;
      }
      
      private function setType(param1:int, param2:int, param3:Function) : void
      {
         var self:GatewayPorts = null;
         var portId:int = param1;
         var type:int = param2;
         var callback:Function = param3;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetType(portId,type,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = checkForErrors(param1.response,"setting port type");
            if(_loc2_ != null)
            {
               CallbackHelper.callCallback(callback,[self,null,_loc2_]);
               return;
            }
            var _loc3_:HmPort = makePort(portId,type);
            CallbackHelper.callCallback(callback,[self,_loc3_,null]);
         });
      }
      
      private function checkForErrors(param1:MCPPackage, param2:String) : Error
      {
         var _loc3_:int = 0;
         if(param1 == null)
         {
            return new Error(param2 + " failed! (NetTimeout)",NetErrors.NETWORK_TIMEOUT);
         }
         if(param1.command == MCPCommands.ERROR)
         {
            _loc3_ = MCPErrors.getErrorFromPackage(param1);
            InfoCenter.onMCPError(param1,_loc3_);
            return new Error(param2 + " failed! 0x" + StringHelper.int2hex(_loc3_) + " (" + MCPErrors.NAMES[_loc3_] + ")",_loc3_);
         }
         return null;
      }
      
      private function makePort(param1:int, param2:int = -1) : HmPort
      {
         if(param1 < -1 || param1 > MAX_PORT_COUNT)
         {
            return null;
         }
         var _loc3_:HmPort = new HmPort();
         _loc3_.id = param1;
         _loc3_.type = param2;
         return _loc3_;
      }
      
      public function makePortFromJMCP(param1:Object, param2:Function) : void
      {
         var _loc4_:Error = null;
         if(param1.id < -1 || param1.id > MAX_PORT_COUNT)
         {
            _loc4_ = new Error("creating port failed! (invalid id)",MCPErrors.PORT_ERROR);
            CallbackHelper.callCallback(param2,[null,_loc4_]);
            return;
         }
         var _loc3_:HmPort = new HmPort();
         _loc3_.id = param1.id;
         _loc3_.type = param1.type;
         CallbackHelper.callCallback(param2,[_loc3_,null]);
      }
      
      override protected function validateCache(param1:Function = null) : void
      {
         var self:GatewayPorts = null;
         var callback:Function = param1;
         if(isValidatingCache)
         {
            super.validateCache(callback);
            return;
         }
         super.validateCache(callback);
         self = this;
         this.portCount = -1;
         this.loadPortCount().then(function(param1:int):void
         {
            finishCacheValidation([self,null,null]);
         },function(param1:Error):void
         {
            finishCacheValidation([self,null,param1]);
         });
      }
      
      private function loadPortCount() : Promise
      {
         var deferred:Deferred = null;
         var self:GatewayPorts = null;
         deferred = new Deferred();
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createGetPorts(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = checkForErrors(param1.response,"reading ports");
            if(_loc2_ != null)
            {
               deferred.reject(_loc2_);
               return;
            }
            self.portCount = 0;
            var _loc3_:ByteArray = param1.response.payload;
            _loc3_.position = 0;
            while(_loc3_.bytesAvailable)
            {
               self.portCount++;
               _loc3_.readUnsignedByte();
            }
            deferred.resolve(self.portCount);
         });
         return deferred.promise;
      }
   }
}

class SingletonEnforcer#149
{
    
   
   function SingletonEnforcer#149()
   {
      super();
   }
}
