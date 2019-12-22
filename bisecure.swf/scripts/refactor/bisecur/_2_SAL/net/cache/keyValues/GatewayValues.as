package refactor.bisecur._2_SAL.net.cache.keyValues
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._2_SAL.net.cache.CacheBase;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.LogicwareSettings;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class GatewayValues extends CacheBase
   {
      
      private static var singleton:GatewayValues;
       
      
      private var keyValueCache:Object;
      
      public function GatewayValues(param1:ConstructorLock#150)
      {
         super();
         this.keyValueCache = {};
      }
      
      public static function get instance() : GatewayValues
      {
         if(singleton == null)
         {
            singleton = new GatewayValues(null);
         }
         return singleton;
      }
      
      public function setValue(param1:uint, param2:uint, param3:Function = null) : void
      {
         var self:GatewayValues = null;
         var key:uint = param1;
         var value:uint = param2;
         var callback:Function = param3;
         if(!isCacheValid)
         {
            this.validateCache(function(param1:GatewayValues, param2:Object, param3:Object, param4:Error):void
            {
               setValue(key,value,callback);
            });
         }
         else
         {
            self = this;
            new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetValue(key,value,MCPPackage.getFromPool()),function(param1:MCPLoader):void
            {
               var _loc2_:Error = null;
               if(checkForErrors(callback,GatewayValuesErrorEvent.SET_VALUE_FAILED,"writing key-value pair",param1.response))
               {
                  _loc2_ = getValidationError("writing key-value pair",param1.response);
                  CallbackHelper.callCallback(callback,[self,-1,-1,_loc2_]);
                  return;
               }
               keyValueCache[key] = value;
               CallbackHelper.callCallback(callback,[self,key,value,null]);
            });
         }
      }
      
      public function getGrouptype(param1:uint) : Promise
      {
         var promiseDeferred:Deferred = null;
         var key:uint = 0;
         var groupId:uint = param1;
         promiseDeferred = new Deferred();
         key = groupId;
         if(isCacheValid && this.keyValueCache.hasOwnProperty(key.toString()))
         {
            promiseDeferred.resolve({
               "response":"GroupType",
               "id":groupId,
               "type":this.keyValueCache[key]
            });
         }
         else
         {
            this.validateCache(function(param1:GatewayValues, param2:Object, param3:Object, param4:Error):void
            {
               if(param4 != null)
               {
                  promiseDeferred.reject(param4);
               }
               else
               {
                  promiseDeferred.resolve({
                     "response":"GroupType",
                     "id":groupId,
                     "type":keyValueCache[key]
                  });
               }
            });
         }
         return promiseDeferred.promise;
      }
      
      public function getRequestablePort(param1:uint) : Promise
      {
         var promiseDeferred:Deferred = null;
         var key:uint = 0;
         var groupId:uint = param1;
         promiseDeferred = new Deferred();
         key = groupId + LogicwareSettings.MAX_PORTS;
         if(isCacheValid && this.keyValueCache.hasOwnProperty(key.toString()))
         {
            promiseDeferred.resolve({
               "response":"RequestablePort",
               "id":groupId,
               "portId":this.keyValueCache[key]
            });
         }
         else
         {
            this.validateCache(function(param1:GatewayValues, param2:Object, param3:Object, param4:Error):void
            {
               if(param4 != null)
               {
                  promiseDeferred.reject(param4);
               }
               else
               {
                  promiseDeferred.resolve({
                     "response":"RequestablePort",
                     "id":groupId,
                     "portId":keyValueCache[key]
                  });
               }
            });
         }
         return promiseDeferred.promise;
      }
      
      public function getValue(param1:uint, param2:Function) : void
      {
         var self:* = undefined;
         var key:uint = param1;
         var callback:Function = param2;
         if(isCacheValid && this.keyValueCache.hasOwnProperty(key.toString()))
         {
            CallbackHelper.callCallback(callback,[this,key,this.keyValueCache[key],null]);
         }
         else
         {
            self = this;
            this.validateCache(function(param1:GatewayValues, param2:Object, param3:Object, param4:Error):void
            {
               if(param4 != null)
               {
                  CallbackHelper.callCallback(callback,[self,null,null,param4]);
                  return;
               }
               CallbackHelper.callCallback(callback,[self,param2,null,null]);
            });
         }
      }
      
      public function getValues(param1:Function = null) : void
      {
         var self:GatewayValues = null;
         var callback:Function = param1;
         if(isCacheValid)
         {
            CallbackHelper.callCallback(callback,[this,this.keyValueCache,null,null]);
            return;
         }
         self = this;
         this.validateCache(function(param1:GatewayValues, param2:Object, param3:Object, param4:Error):void
         {
            if(param4 != null)
            {
               CallbackHelper.callCallback(callback,[self,null,null,param4]);
               return;
            }
            CallbackHelper.callCallback(callback,[self,param2,null,null]);
         });
      }
      
      override public function invalidateCache() : void
      {
         super.invalidateCache();
         this.keyValueCache = {};
      }
      
      override protected function validateCache(param1:Function = null) : void
      {
         var self:GatewayValues = null;
         var callback:Function = param1;
         if(isValidatingCache)
         {
            super.validateCache(callback);
            return;
         }
         super.validateCache(callback);
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createJMCP(MCPCommands.JMCP_GET_VALUES,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var error:Error = null;
            var payload:ByteArray = null;
            var jstr:String = null;
            var json:Object = null;
            var jsonKey:String = null;
            var sender:MCPLoader = param1;
            if(checkForErrors(callback,GatewayValuesErrorEvent.GET_VALUES_FAILED,"reading key-value pairs",sender.response))
            {
               error = getValidationError("reading key-value pairs",sender.response);
               finishCacheValidation([self,null,null,error]);
               return;
            }
            try
            {
               payload = sender.response.payload;
               payload.position = 0;
               jstr = payload.readUTFBytes(payload.bytesAvailable);
               json = JSON.parse(jstr);
               for(jsonKey in json)
               {
                  keyValueCache[uint(jsonKey)] = json[jsonKey];
               }
               finishCacheValidation([self,keyValueCache,null,null]);
               return;
            }
            catch(error:Error)
            {
               finishCacheValidation([self,null,null,error]);
               return;
            }
         });
      }
      
      private function get cacheComplete() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < LogicwareSettings.MAX_VALUES)
         {
            if(!this.keyValueCache.hasOwnProperty(_loc1_.toString()))
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function getValidationError(param1:String, param2:MCPPackage) : Error
      {
         var _loc4_:int = 0;
         var _loc3_:Error = null;
         if(param2 == null)
         {
            _loc3_ = new Error(param1 + " failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
         }
         else if(param2.command == MCPCommands.ERROR)
         {
            _loc4_ = MCPErrors.getErrorFromPackage(param2);
            _loc3_ = new Error(param1 + " failed! (Error: 0x" + StringHelper.int2hex(_loc4_) + " = " + MCPErrors.NAMES[_loc4_] + ")",_loc4_);
            InfoCenter.onMCPError(param2,_loc4_);
         }
         return _loc3_;
      }
      
      private function checkForErrors(param1:Function, param2:String, param3:String, param4:MCPPackage) : Boolean
      {
         var _loc5_:Error = this.getValidationError(param3,param4);
         if(_loc5_ == null)
         {
            return false;
         }
         Log.warning("[GatewayValues] " + param3 + " failed! " + _loc5_);
         CallbackHelper.callCallback(param1,[this,null,null,_loc5_]);
         return true;
      }
   }
}

class ConstructorLock#150
{
    
   
   function ConstructorLock#150()
   {
      super();
   }
}
