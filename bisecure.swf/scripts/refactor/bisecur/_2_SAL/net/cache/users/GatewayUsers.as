package refactor.bisecur._2_SAL.net.cache.users
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.UserLoginDAO;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   
   public class GatewayUsers extends EventDispatcher
   {
      
      public static const MAX_USER_COUNT:int = 10;
      
      private static var singleton:GatewayUsers;
       
      
      private var userCache:Array;
      
      public function GatewayUsers(param1:SingletonEnforcer#152)
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
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createAddUser(name,password,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            var _loc3_:int = 0;
            var _loc4_:User = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Creating User \'" + name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_CREATE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.ADD_USER,param1.response,callback,"Creating User \'" + name + "\'",GatewayUsersErrorEvent.USER_CREATE_FAILED))
            {
               if(!param1.response.payload || param1.response.payload.length < 1)
               {
                  _loc2_ = new Error("Creating User \'" + name + "\' failed! (no payload)",MCPErrors.INVALID_PAYLOAD);
                  self.callCallback(callback,null,_loc2_);
                  self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_CREATE_FAILED,false,false,_loc2_.errorID));
                  Log.error("[GatewayUsers] " + _loc2_.message + " mcp:\n" + param1.response);
                  return;
               }
               param1.response.payload.position = 0;
               _loc3_ = param1.response.payload.readUnsignedByte();
               _loc4_ = self.makeUser(_loc3_,name);
               self.addToCache(_loc4_);
               self.callCallback(callback,_loc4_,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_CREATED,false,false,_loc4_));
            }
         });
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
         var loggedInId:int = -1;
         if(AppCache.sharedCache.loggedInUser != null)
         {
            loggedInId = AppCache.sharedCache.loggedInUser.id;
         }
         if(user.id == loggedInId)
         {
            this.updateOwnName(user,callback);
         }
         else if(loggedInId == User.ID_ADMIN)
         {
            this.updateNameOfUser(user,callback);
         }
         else
         {
            error = new Error("Updating name failed! " + "(Active user is not admin and name to update is not his own)",MCPErrors.PERMISSION_DENIED);
            this.callCallback(callback,null,error);
            dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,error.errorID));
            Log.error("[GatewayUsers] " + error.message);
         }
      }
      
      private function updateOwnName(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createChangeUserName(user.name,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Updating name failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.CHANGE_USER_NAME,param1.response,callback,"Updating name",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
         });
      }
      
      private function updateNameOfUser(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createChangeUserNameOfUser(user.id,user.name,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Updating name failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.CHANGE_USER_NAME_OF_USER,param1.response,callback,"Updating name",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
         });
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
         var loggedInId:int = -1;
         if(AppCache.sharedCache.loggedInUser != null)
         {
            loggedInId = AppCache.sharedCache.loggedInUser.id;
         }
         if(user.id == loggedInId)
         {
            this.updateOwnPassword(user,callback);
         }
         else if(loggedInId == User.ID_ADMIN)
         {
            this.updateUserPassword(user,callback);
         }
         else
         {
            error = new Error("Updating password failed! " + "(Active user is not admin and password to update is not his own)",MCPErrors.PERMISSION_DENIED);
            this.callCallback(callback,null,error);
            dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,error.errorID));
            Log.error("[GatewayUsers] " + error.message);
         }
      }
      
      private function updateOwnPassword(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var user:User = param1;
         var callback:Function = param2;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createChangePassword(user.password,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            var _loc3_:UserLoginDAO = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Updating password for \'" + user.name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.CHANGE_PASSWD,param1.response,callback,"Updating password for \'" + user.name + "\'",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               _loc3_ = DAOFactory.getUserLoginDAO();
               _loc3_.setUser(user);
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
         });
      }
      
      private function updateUserPassword(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var user:User = param1;
         var callback:Function = param2;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createChangePasswordOfUser(user.id,user.password,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Updating password for \'" + user.name + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_UPDATE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.CHANGE_PASSWORD_OF_USER,param1.response,callback,"Updating password for \'" + user.name + "\'",GatewayUsersErrorEvent.USER_UPDATE_FAILED))
            {
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_UPDATED,false,false,user));
            }
         });
      }
      
      public function deleteUser(param1:User, param2:Function = null) : void
      {
         var self:GatewayUsers = null;
         var user:User = param1;
         var callback:Function = param2;
         if(callback == null)
         {
            callback = function(param1:User, param2:Error):void
            {
            };
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createRemoveUser(user.id,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:Error = null;
            if(param1.response == null)
            {
               _loc2_ = new Error("Deleting user \'" + user.name + "\' failed! (Net Timeout)");
               self.callCallback(callback,null,_loc2_);
               self.dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USER_DELETE_FAILED,false,false,_loc2_.errorID));
               Log.error("[GatewayUsers] " + _loc2_.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.REMOVE_USER,param1.response,callback,"Deleting user \'" + user.name + "\'",GatewayUsersErrorEvent.USER_DELETE_FAILED))
            {
               self.removeFromCache(user);
               user.id = User.ID_UNKNOWN;
               self.callCallback(callback,user,null);
               self.dispatchEvent(new GatewayUsersEvent(GatewayUsersEvent.USER_DELETED,false,false,user));
            }
         });
      }
      
      public function invalidateCache() : void
      {
         this.userCache = [];
         this.readUsers();
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
         return _loc2_;
      }
      
      private function readUsers(param1:Function = null) : void
      {
         var self:GatewayUsers = null;
         var callback:Function = param1;
         if(callback == null)
         {
            callback = function(param1:Error):void
            {
            };
         }
         this.userCache = [];
         if(!AppCache.sharedCache.loggedInUser || !AppCache.sharedCache.loggedInUser.isAdmin)
         {
            this.callCallback(callback,null,null);
            return;
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createJMCP(MCPCommands.JMCP_GET_USERS,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var error:Error = null;
            var raw:ByteArray = null;
            var jStr:String = null;
            var jData:Object = null;
            var user:User = null;
            var usrO:Object = null;
            var sender:MCPLoader = param1;
            if(sender.response == null)
            {
               error = new Error("reading users failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               self.callCallback(callback,null,error);
               dispatchEvent(new GatewayUsersErrorEvent(GatewayUsersErrorEvent.USERS_READ_FAILED,false,false,error.errorID));
               Log.error("[GatewayUsers] " + error.message);
               InfoCenter.onNetTimeout();
               return;
            }
            if(!self.mcpErrorHandler(MCPCommands.JMCP,sender.response,callback,"reading users",GatewayUsersErrorEvent.USERS_READ_FAILED))
            {
               raw = sender.response.payload;
               raw.position = 0;
               jStr = raw.readUTFBytes(raw.bytesAvailable);
               try
               {
                  jData = JSON.parse(jStr);
               }
               catch(e:Error)
               {
                  Log.warning("[GatewayUsers] reading users failed! (JMCP not parsable)\n" + e);
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
                     Log.warning("[GatewayUsers] making user failed! \n" + JSON.stringify(usrO));
                  }
               }
               self.callCallback(callback,null,null);
            }
         });
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
      
      private function mcpErrorHandler(param1:int, param2:MCPPackage, param3:Function, param4:String, param5:String) : Boolean
      {
         var _loc6_:Error = null;
         var _loc7_:int = 0;
         if(param2.command == param1)
         {
            return false;
         }
         if(param2.command == MCPCommands.ERROR)
         {
            param2.payload.position = 0;
            _loc7_ = MCPErrors.getErrorFromPackage(param2);
            _loc6_ = new Error(param4 + " failed! (Error: 0x" + _loc7_ + " = " + MCPErrors.NAMES[_loc7_] + ")",_loc7_);
            InfoCenter.onMCPError(param2,_loc7_);
            this.callCallback(param3,null,_loc6_);
            dispatchEvent(new GatewayUsersErrorEvent(param5,false,false,_loc7_));
            Log.error("[GatewayUsers] " + _loc6_.message);
            return true;
         }
         _loc6_ = new Error(param4 + " failed! (unexpected response)",NetErrors.UNEXPECTED_MESSAGE);
         this.callCallback(param3,null,_loc6_);
         dispatchEvent(new GatewayUsersErrorEvent(param5,false,false,NetErrors.UNEXPECTED_MESSAGE));
         Log.error("[GatewayUsers] " + _loc6_.message + " mcp:\n" + param2);
         return true;
      }
   }
}

class SingletonEnforcer#152
{
    
   
   function SingletonEnforcer#152()
   {
      super();
   }
}
