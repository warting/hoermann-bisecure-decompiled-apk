package com.isisic.remote.hoermann.net.dao.users
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.hoermann.net.NetErrors;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCP;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import me.mweber.basic.Debug;
   
   public class GatewayUsers extends EventDispatcher
   {
      
      public static const MAX_USER_COUNT:int = 10;
      
      private static var singleton:GatewayUsers;
       
      
      private var userCache:Array;
      
      public function GatewayUsers(param1:SingletonEnforcer#176)
      {
         super();
         this.userCache = [];
         this.readUsers();
      }
      
      public static function get instance() : GatewayUsers
      {
         if(singleton == null)
         {
            singleton = new GatewayUsers(null);
         }
         return singleton;
      }
      
      public function createUser(param1:String, param2:String, param3:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var name:String = param1;
         var password:String = param2;
         var callback:Function = param3;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            if(!self.mcpErrorHandler(Commands.ADD_USER,loader.data,callback,"Creating User \'" + name + "\'",GatewayUsersErrorEvent.USER_CREATE_FAILED))
            {
               if(!loader.data.payload || loader.data.payload.length < 1)
               {
                  _loc4_ = new Error("Creating User \'" + name + "\' failed! (no payload)",Errors.INVALID_PAYLOAD);
                  self.callCallback(callback,null,_loc4_);
                  self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_CREATE_FAILED,false,false,_loc4_.errorID));
                  Debug.error("[GatewayUsers] " + _loc4_.message + " mcp:\n" + loader.data);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               loader.data.payload.position = 0;
               _loc2_ = loader.data.payload.readUnsignedByte();
               _loc3_ = self.makeUser(_loc2_,name);
               self.addToCache(_loc3_);
               self.callCallback(callback,_loc3_,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_CREATED,false,false,_loc3_));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Creating User \'" + name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_CREATE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.ADD_USER,MCPBuilder.payloadAddUser(name,password)));
      }
      
      public function getUsers() : Array
      {
         return this.userCache.concat();
      }
      
      public function getUserCount() : int
      {
         return this.userCache.length;
      }
      
      public function getUserByName(param1:String) : User
      {
         var _loc2_:User = null;
         if(param1 == null)
         {
            return null;
         }
         for each(_loc2_ in this.userCache)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getUserById(param1:int) : User
      {
         var _loc2_:User = null;
         if(param1 < 0 || param1 > MAX_USER_COUNT)
         {
            return null;
         }
         for each(_loc2_ in this.userCache)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function refreshCache(param1:Function = null) : void
      {
         this.readUsers(param1);
      }
      
      public function updateName(param1:User, param2:Function = null) : void
      {
         var error:Error = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         if(user.id == HoermannRemote.appData.userId)
         {
            this.updateOwnName(user,callback);
         }
         else if(HoermannRemote.appData.userId == User.ID_ADMIN)
         {
            this.updateNameOfUser(user,callback);
         }
         else
         {
            error = new Error("Updating name failed! " + "(Active user is not admin and name to update is not his own)",Errors.PERMISSION_DENIED);
            this.callCallback(callback,null,error);
            dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,error.errorID));
            Debug.error("[GatewayUsers] " + error.message);
         }
      }
      
      private function updateOwnName(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            if(!self.mcpErrorHandler(Commands.CHANGE_USER_NAME,loader.data,callback,"Updating name",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Updating name failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.CHANGE_USER_NAME,MCPBuilder.payloadChangeUserName(user.name)));
      }
      
      private function updateNameOfUser(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            if(!self.mcpErrorHandler(Commands.CHANGE_USER_NAME_OF_USER,loader.data,callback,"Updating name",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Updating name failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.CHANGE_USER_NAME_OF_USER,MCPBuilder.payloadChangeUserNameOfUser(user.id,user.name)));
      }
      
      public function updatePassword(param1:User, param2:Function = null) : void
      {
         var error:Error = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         if(user.id == HoermannRemote.appData.userId)
         {
            this.updateOwnPassword(user,callback);
         }
         else if(HoermannRemote.appData.userId == User.ID_ADMIN)
         {
            this.updateUserPassword(user,callback);
         }
         else
         {
            error = new Error("Updating password failed! " + "(Active user is not admin and password to update is not his own)",Errors.PERMISSION_DENIED);
            this.callCallback(callback,null,error);
            dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,error.errorID));
            Debug.error("[GatewayUsers] " + error.message);
         }
      }
      
      private function updateOwnPassword(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var user:User = param1;
         var callback:Function = param2;
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            if(!self.mcpErrorHandler(Commands.CHANGE_PASSWD,loader.data,callback,"Updating password for \'" + user.name + "\'",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               for each(_loc2_ in HoermannRemote.appData.activeGateway.users)
               {
                  if(_loc2_.id == HoermannRemote.appData.userId)
                  {
                     if(_loc2_.password)
                     {
                        _loc2_.password = user.password;
                     }
                  }
               }
               if(HoermannRemote.appData.autoLogin && HoermannRemote.appData.autoLogin.password != null)
               {
                  HoermannRemote.appData.autoLogin.password = user.password;
               }
               HoermannRemote.appData.save();
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Updating password for \'" + user.name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.CHANGE_PASSWD,MCPBuilder.payloadChangePassword(user.password)));
      }
      
      private function updateUserPassword(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var user:User = param1;
         var callback:Function = param2;
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            if(!self.mcpErrorHandler(Commands.CHANGE_PASSWORD_OF_USER,loader.data,callback,"Updating password for \'" + user.name + "\'",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Updating password for \'" + user.name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.CHANGE_PASSWORD_OF_USER,MCPBuilder.payloadChangePasswordOfUser(user.id,user.password)));
      }
      
      public function deleteUser(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            if(!self.mcpErrorHandler(Commands.REMOVE_USER,loader.data,callback,"Deleting user \'" + user.name + "\'",GatewayUsersErrorEvent.USER_DELETE_FAILED))
            {
               self.removeFromCache(user);
               user.id = User.ID_UNKNOWN;
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_DELETED,false,false,user));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("Deleting user \'" + user.name + "\' failed! (Net Timeout)");
            self.callCallback(callback,null,_loc2_);
            self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_DELETE_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.REMOVE_USER,MCPBuilder.payloadRemoveUser(user.id)));
      }
      
      private function addToCache(param1:User) : void
      {
         if(param1.id < 0 || this.isInCache(param1))
         {
            return;
         }
         this.userCache.push(param1);
      }
      
      private function removeFromCache(param1:User) : void
      {
         var _loc2_:User = null;
         if(param1.id < 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.userCache.length)
         {
            _loc2_ = this.userCache[_loc3_];
            if(_loc2_.id == param1.id)
            {
               this.userCache.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      private function isInCache(param1:User) : Boolean
      {
         var _loc2_:User = null;
         if(param1.id < 0 || param1.id > MAX_USER_COUNT)
         {
            return false;
         }
         for each(_loc2_ in this.userCache)
         {
            if(_loc2_.id == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function makeUser(param1:int, param2:String) : User
      {
         if(param1 < -1 || param1 > MAX_USER_COUNT)
         {
            return null;
         }
         var _loc3_:User = new User();
         _loc3_.id = param1;
         _loc3_.name = param2;
         _loc3_.isAdmin = param1 == User.ID_ADMIN;
         _loc3_.groups = [];
         return _loc3_;
      }
      
      private function makeUserFromJMCP(param1:Object) : User
      {
         if(param1.id < -1 || param1.id > MAX_USER_COUNT)
         {
            return null;
         }
         var _loc2_:User = new User();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.isAdmin = param1.id == User.ID_ADMIN?true:param1.isAdmin;
         _loc2_.groups = param1.groups;
         return _loc2_;
      }
      
      private function readUsers(param1:Function = null) : void
      {
         var self:GatewayUsers = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var callback:Function = param1;
         if(callback == null)
         {
            callback = function(param1:Error):void
            {
            };
         }
         this.userCache = [];
         self = this;
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            var raw:* = undefined;
            var jStr:* = undefined;
            var jData:* = undefined;
            var user:* = undefined;
            var usrO:* = undefined;
            var event:Event = param1;
            if(!self.mcpErrorHandler(Commands.JMCP,loader.data,callback,"reading users",GatewayUsersErrorEvent.USERS_READ_FAILED))
            {
               raw = loader.data.payload;
               raw.position = 0;
               jStr = raw.readUTFBytes(raw.bytesAvailable);
               try
               {
                  jData = JSON.parse(jStr);
               }
               catch(e:Error)
               {
                  Debug.warning("[GatewayUsers] reading users failed! (JMCP not parsable)\n" + e);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               for each(usrO in jData as Array)
               {
                  user = self.makeUserFromJMCP(usrO);
                  if(user != null)
                  {
                     self.addToCache(user);
                  }
                  else
                  {
                     Debug.warning("[GatewayUsers] making user failed! \n" + JSON.stringify(usrO));
                  }
               }
               self.callCallback(callback,null,null);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            var _loc2_:* = new Error("reading users failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            self.callCallback(callback,null,_loc2_);
            dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USERS_READ_FAILED,false,false,_loc2_.errorID));
            Debug.error("[GatewayUsers] " + _loc2_.message);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.JMCP,MCPBuilder.payloadJMCP(Commands.JMCP_GET_USERS)));
      }
      
      private function callCallback(param1:Function, param2:User, param3:Error) : void
      {
         switch(param1.length)
         {
            case 0:
               param1();
               break;
            case 1:
               param1(param3);
               break;
            case 2:
               param1(param2,param3);
         }
      }
      
      private function mcpErrorHandler(param1:int, param2:MCP, param3:Function, param4:String, param5:String) : Boolean
      {
         var _loc6_:Error = null;
         var _loc7_:int = 0;
         if(param2.command == param1)
         {
            return false;
         }
         if(param2.command == Commands.ERROR)
         {
            param2.payload.position = 0;
            _loc7_ = param2.payload.readUnsignedByte();
            _loc6_ = new Error(param4 + " failed! (Error: 0x" + _loc7_ + " = " + Errors.NAMES[_loc7_] + ")",_loc7_);
            this.callCallback(param3,null,_loc6_);
            dispatchEvent(new GatewayUsersErrorEvent(param5,false,false,_loc7_));
            Debug.error("[GatewayUsers] " + _loc6_.message);
            return true;
         }
         _loc6_ = new Error(param4 + " failed! (unexpected response)",NetErrors.UNEXPECTED_MESSAGE);
         this.callCallback(param3,null,_loc6_);
         dispatchEvent(new GatewayUsersErrorEvent(param5,false,false,NetErrors.UNEXPECTED_MESSAGE));
         Debug.error("[GatewayUsers] " + _loc6_.message + " mcp:\n" + param2);
         return true;
      }
   }
}

class SingletonEnforcer#176
{
    
   
   function SingletonEnforcer#176()
   {
      super();
   }
}
