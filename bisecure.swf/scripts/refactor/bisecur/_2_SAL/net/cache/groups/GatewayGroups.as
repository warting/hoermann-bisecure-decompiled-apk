package refactor.bisecur._2_SAL.net.cache.groups
{
   import com.codecatalyst.promise.Deferred;
   import com.codecatalyst.promise.Promise;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmPort;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import mx.utils.StringUtil;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._2_SAL.net.cache.CacheBase;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
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
   
   public class GatewayGroups extends CacheBase
   {
      
      private static var singleton:GatewayGroups;
       
      
      private var groupCache:Array;
      
      public function GatewayGroups(param1:ConstructorLock#145)
      {
         super();
         this.groupCache = [];
      }
      
      public static function get instance() : GatewayGroups
      {
         if(singleton == null)
         {
            singleton = new GatewayGroups(null);
         }
         return singleton;
      }
      
      public function createGroup(param1:String, param2:Function = null) : void
      {
         var self:GatewayGroups = null;
         var name:String = param1;
         var callback:Function = param2;
         self = this;
         this._createGroup(function(param1:GatewayGroups, param2:HmGroup, param3:Error):void
         {
            if(param3 != null)
            {
               Log.error("[GatewayGroups] creating group failed! " + param3);
               CallbackHelper.callCallback(callback,[param1,null,param3]);
               return;
            }
            param2.name = name;
            self.updateName(param2,callback);
         });
      }
      
      private function _createGroup(param1:Function = null) : void
      {
         var self:GatewayGroups = null;
         var callback:Function = param1;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createAddGroup(),function(param1:MCPLoader):void
         {
            if(checkForErrors(callback,GatewayGroupsErrorEvent.GROUP_CREATE_FAILED,"creating group",param1.response))
            {
               return;
            }
            var _loc2_:ByteArray = param1.response.payload;
            _loc2_.position = 0;
            var _loc3_:uint = _loc2_.readUnsignedByte();
            var _loc4_:HmGroup = makeGroup(_loc3_);
            addToCache(_loc4_);
            CallbackHelper.callCallback(callback,[self,_loc4_,null]);
         });
      }
      
      public function getAll(param1:Function = null) : void
      {
         var callback:Function = param1;
         if(isCacheValid)
         {
            CallbackHelper.callCallback(callback,[this,this.groupCache,null]);
            return;
         }
         this.validateCache(function(param1:GatewayGroups, param2:Array, param3:Error):void
         {
            CallbackHelper.callCallback(callback,[param1,param2,param3]);
         });
      }
      
      public function getById(param1:int, param2:Function = null) : void
      {
         this.getByProperty("id",param1,param2);
      }
      
      public function getByName(param1:String, param2:Function) : void
      {
         this.getByProperty("name",param1,param2);
      }
      
      private function getByProperty(param1:String, param2:*, param3:Function) : void
      {
         var group:HmGroup = null;
         var error:Error = null;
         var propertyName:String = param1;
         var value:* = param2;
         var callback:Function = param3;
         if(isCacheValid)
         {
            group = this.findInCache(propertyName,value);
            if(group != null)
            {
               CallbackHelper.callCallback(callback,[this,group,null]);
            }
            else
            {
               error = new Error("Group with " + propertyName + " \'" + value + "\' not found!",MCPErrors.GROUP_NOT_FOUND);
               CallbackHelper.callCallback(callback,[this,null,error]);
            }
         }
         else
         {
            this.validateCache(function(param1:GatewayGroups, param2:Array, param3:Error):void
            {
               if(param3 != null)
               {
                  CallbackHelper.callCallback(callback,[param1,null,param3]);
                  return;
               }
               getByProperty(propertyName,value,callback);
            });
         }
      }
      
      public function updateName(param1:HmGroup, param2:Function = null) : void
      {
         var self:GatewayGroups = null;
         var group:HmGroup = param1;
         var callback:Function = param2;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetGroupName(group.id,group.name,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(checkForErrors(callback,GatewayGroupsErrorEvent.GROUP_UPDATE_FAILED,"updating group name",param1.response))
            {
               return;
            }
            updateCachedProperty(group,"name",group.name);
            CallbackHelper.callCallback(callback,[self,group,null]);
         });
      }
      
      public function updateType(param1:HmGroup, param2:Function = null) : void
      {
         var self:GatewayGroups = null;
         var group:HmGroup = param1;
         var callback:Function = param2;
         self = this;
         GatewayValues.instance.setValue(group.id,group.type,function(param1:GatewayValues, param2:uint, param3:uint, param4:Error):void
         {
            if(param4)
            {
               CallbackHelper.callCallback(callback,[self,null,param4]);
            }
            else
            {
               updateCachedProperty(group,"type",group.type);
               CallbackHelper.callCallback(callback,[self,group,null]);
            }
         });
      }
      
      public function updatePorts(param1:HmGroup, param2:Function = null) : void
      {
         var self:GatewayGroups = null;
         var port:HmPort = null;
         var group:HmGroup = param1;
         var callback:Function = param2;
         var portIds:Array = [];
         if(group.ports != null)
         {
            for each(port in group.ports)
            {
               portIds.push(port.id);
            }
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetGroupedPorts(group.id,portIds,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(checkForErrors(callback,GatewayGroupsErrorEvent.GROUP_UPDATE_FAILED,"updating grouped ports",param1.response))
            {
               return;
            }
            updateCachedProperty(group,"ports",group.ports);
            CallbackHelper.callCallback(callback,[self,group,null]);
         });
      }
      
      public function setRequestablePort(param1:HmGroup, param2:uint, param3:Function = null) : void
      {
         var self:GatewayGroups = null;
         var group:HmGroup = param1;
         var portId:uint = param2;
         var callback:Function = param3;
         self = this;
         GatewayValues.instance.setValue(group.id + LogicwareSettings.MAX_PORTS,portId,function(param1:GatewayValues, param2:uint, param3:uint, param4:Error):void
         {
            var _loc5_:Object = null;
            if(param4)
            {
               CallbackHelper.callCallback(callback,[self,null,param4]);
            }
            else
            {
               _loc5_ = AppCache.sharedCache.hmProcessor.requestablePorts;
               if(_loc5_)
               {
                  _loc5_[group.id] = portId;
               }
               CallbackHelper.callCallback(callback,[self,group,null]);
            }
         });
      }
      
      public function deleteGroup(param1:HmGroup, param2:Function = null) : void
      {
         var self:GatewayGroups = null;
         var remover:PortRemover = null;
         var onComplete:Function = null;
         var port:HmPort = null;
         var group:HmGroup = param1;
         var callback:Function = param2;
         self = this;
         remover = new PortRemover(AppCache.sharedCache.connection);
         remover.addEventListener(Event.COMPLETE,onComplete = function(param1:Event):void
         {
            var event:Event = param1;
            remover.removeEventListener(Event.COMPLETE,onComplete);
            new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createRemoveGroup(group.id,MCPPackage.getFromPool()),function(param1:MCPLoader):void
            {
               if(checkForErrors(callback,GatewayGroupsErrorEvent.GROUP_DELETE_FAILED,"removing group",param1.response))
               {
                  return;
               }
               removeFromCache(group);
               CallbackHelper.callCallback(callback,[self,group,null]);
            });
         });
         var ids:Array = [];
         if(group.ports != null)
         {
            for each(port in group.ports)
            {
               ids.push(port.id);
            }
         }
         else
         {
            onComplete(null);
         }
         remover.remove(ids);
      }
      
      private function addToCache(param1:HmGroup) : void
      {
         if(param1.id < 0 || this.isInCache(param1))
         {
            return;
         }
         this.groupCache.push(param1);
      }
      
      private function removeFromCache(param1:HmGroup) : void
      {
         var _loc2_:HmGroup = null;
         if(param1.id < 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.groupCache.length)
         {
            _loc2_ = this.groupCache[_loc3_];
            if(_loc2_.id == param1.id)
            {
               this.groupCache.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      private function updateCachedProperty(param1:HmGroup, param2:String, param3:*) : void
      {
         var _loc4_:int = this.cacheIndexOf(param1);
         if(_loc4_ < 0)
         {
            Log.error("[GatewayGroups] updated group not found in cache! -> validating cache...");
            this.validateCache();
         }
         else
         {
            this.groupCache[_loc4_][param2] = param3;
         }
      }
      
      private function cacheIndexOf(param1:HmGroup) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.groupCache.length)
         {
            if(this.groupCache[_loc2_].id == param1.id)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function findInCache(param1:String, param2:*) : HmGroup
      {
         var _loc3_:HmGroup = null;
         for each(_loc3_ in this.groupCache)
         {
            if(_loc3_[param1] == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function isInCache(param1:HmGroup) : Boolean
      {
         var _loc2_:HmGroup = null;
         if(param1.id < 0 || param1.id > LogicwareSettings.MAX_PORTS)
         {
            return false;
         }
         for each(_loc2_ in this.groupCache)
         {
            if(_loc2_.id == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function makeGroup(param1:int, param2:String = null, param3:int = -1, param4:Array = null) : HmGroup
      {
         if(param1 < -1 || param1 > LogicwareSettings.MAX_PORTS)
         {
            return null;
         }
         var _loc5_:HmGroup = new HmGroup();
         _loc5_.id = param1;
         _loc5_.name = param2;
         _loc5_.type = param3;
         _loc5_.ports = param4;
         return _loc5_;
      }
      
      private function makeGroupFromJMCP(param1:Object) : Promise
      {
         var deferred:Deferred = null;
         var group:HmGroup = null;
         var error:Error = null;
         var jGroup:Object = param1;
         deferred = new Deferred();
         if(jGroup.id < -1 || jGroup.id > LogicwareSettings.MAX_PORTS)
         {
            error = new Error("parsing jmcp group failed! (invalid groupId " + jGroup.id + ")",MCPErrors.INVALID_PAYLOAD);
            Log.error("[GatewayGroups] " + error.message);
            deferred.reject(error);
         }
         group = new HmGroup();
         group.id = jGroup.id;
         group.name = jGroup.name;
         group.ports = [];
         GatewayValues.instance.getGrouptype(group.id).then(function(param1:Object):void
         {
            var portObject:Object = null;
            var response:Object = param1;
            group.type = response.type;
            if(jGroup.ports != null)
            {
               for each(portObject in jGroup.ports)
               {
                  GatewayPorts.instance.makePortFromJMCP(portObject,function(param1:HmPort, param2:Error):void
                  {
                     if(param2 != null)
                     {
                        deferred.reject(param2);
                        return;
                     }
                     group.ports.push(param1);
                  });
               }
            }
            if(group.type == 0)
            {
               Log.error("[GatewayGroups] Group type loading failed!");
            }
            deferred.resolve(group);
         },function(param1:Error):void
         {
            Log.error(param1.message);
            deferred.reject(param1);
         });
         return deferred.promise;
      }
      
      override public function invalidateCache() : void
      {
         super.invalidateCache();
      }
      
      override protected function validateCache(param1:Function = null) : void
      {
         var self:GatewayGroups = null;
         var callback:Function = param1;
         if(isValidatingCache)
         {
            super.validateCache(callback);
            return;
         }
         super.validateCache(callback);
         var jmcpCommand:String = MCPCommands.JMCP_GET_GROUPS;
         if(AppCache.sharedCache.loggedInUser && !AppCache.sharedCache.loggedInUser.isAdmin)
         {
            jmcpCommand = StringUtil.substitute(MCPCommands.JMCP_GET_GROUPS_FOR_USER,AppCache.sharedCache.loggedInUser.id);
         }
         this.groupCache = [];
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createJMCP(jmcpCommand),function(param1:MCPLoader):void
         {
            var error:Error = null;
            var payload:ByteArray = null;
            var jStr:String = null;
            var json:Object = null;
            var jArray:Array = null;
            var group:HmGroup = null;
            var pendingGroups:int = 0;
            var convertingGroups:Array = null;
            var jGroup:Object = null;
            var sender:MCPLoader = param1;
            if(checkForErrors(callback,GatewayGroupsErrorEvent.GROUPS_READ_FAILED,"reading groups",sender.response))
            {
               error = getValidationError("reading groups",sender.response);
               finishCacheValidation([self,null,error]);
               return;
            }
            try
            {
               payload = sender.response.payload;
               payload.position = 0;
               jStr = payload.readUTFBytes(payload.bytesAvailable);
               json = JSON.parse(jStr);
               jArray = json as Array;
               pendingGroups = jArray.length;
               convertingGroups = [];
               for each(jGroup in jArray)
               {
                  convertingGroups.push(makeGroupFromJMCP(jGroup));
               }
               Promise.all(convertingGroups).then(function(param1:Array):void
               {
                  var _loc2_:HmGroup = null;
                  for each(_loc2_ in param1)
                  {
                     addToCache(_loc2_);
                  }
                  finishCacheValidation([self,groupCache,null]);
               },function(param1:Error):void
               {
                  AppCache.sharedCache.logout();
                  Log.error("Loading groups failed!\n\r" + param1.message);
                  finishCacheValidation([self,null,param1]);
               });
               return;
            }
            catch(error:Error)
            {
               Log.warning("[GatewayGroups] reading users failed! (JMCP not parsable)\n" + error);
               Log.error("[GatewayGroups] " + error.getStackTrace());
               finishCacheValidation([self,null,error]);
               return;
            }
         });
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
         CallbackHelper.callCallback(param1,[this,null,_loc5_]);
         return true;
      }
   }
}

class ConstructorLock#145
{
    
   
   function ConstructorLock#145()
   {
      super();
   }
}

import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
import refactor.bisecur._5_UTIL.CallbackHelper;

class JMCPGroupParser
{
    
   
   private var _jmcpGroups:Array;
   
   private var _hmGroups:Array;
   
   private var _parser:Function;
   
   private var _callback:Function;
   
   function JMCPGroupParser()
   {
      super();
   }
   
   public function parseGroups(param1:Array, param2:Function, param3:Function) : void
   {
      this._jmcpGroups = param1;
      this._hmGroups = [];
      this._parser = param2;
      this._callback = param3;
      this._parseInternal();
   }
   
   private function _parseInternal() : void
   {
      if(this._jmcpGroups == null || this._jmcpGroups.length <= 0)
      {
         this.finalize(null);
         return;
      }
      var jmcpGroup:Object = this._jmcpGroups.shift();
      this._parser(jmcpGroup,function(param1:HmGroup, param2:Error):void
      {
         if(param2 != null)
         {
            return;
         }
         _hmGroups.push(param1);
         _parseInternal();
      });
   }
   
   private function finalize(param1:Error) : void
   {
      CallbackHelper.callCallback(this._callback,[this._hmGroups,param1]);
   }
}
