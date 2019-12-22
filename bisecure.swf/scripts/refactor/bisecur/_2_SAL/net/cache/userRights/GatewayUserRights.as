package refactor.bisecur._2_SAL.net.cache.userRights
{
   import com.isisic.remote.hoermann.net.NetErrors;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class GatewayUserRights extends EventDispatcher
   {
      
      private static var singleton:GatewayUserRights;
       
      
      private var rightsCache:Object;
      
      public function GatewayUserRights(param1:ConstructorLock#142)
      {
         super();
         this.rightsCache = {};
      }
      
      public static function get instance() : GatewayUserRights
      {
         if(singleton == null)
         {
            singleton = new GatewayUserRights(null);
         }
         return singleton;
      }
      
      public function setRightsForUser(param1:User, param2:Array, param3:Function = null) : void
      {
         var self:GatewayUserRights = null;
         var user:User = param1;
         var rights:Array = param2;
         var callback:Function = param3;
         if(user.id < 0)
         {
            Log.error("[GatewayUserRights] Writing Rights failed! (User.id is invalid)");
            return;
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createSetUserRights(user.id,rights,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(checkForErrors(callback,GatewayUserRightsErrorEvent.RIGHTS_SET_FAILD,"writing user-rights",param1.response))
            {
               return;
            }
            rightsCache[user.id] = rights;
            CallbackHelper.callCallback(callback,[self,rights,user,null]);
            dispatchEvent(new GatewayUserRightsEvent(GatewayUserRightsEvent.RIGHTS_SET,false,false,user,rights));
         });
      }
      
      public function invalidateCache() : void
      {
         this.rightsCache = {};
      }
      
      public function getRightsForUser(param1:User, param2:Function) : void
      {
         var self:GatewayUserRights = null;
         var user:User = param1;
         var callback:Function = param2;
         if(user.id < 0)
         {
            Log.error("[GatewayUserRights] Requesting Rights failed! (User.id is invalid)");
            return;
         }
         if(this.rightsCache[user.id])
         {
            CallbackHelper.callCallback(callback,[this,this.rightsCache[user.id],user,null]);
            return;
         }
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createGetUserRights(user.id,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(checkForErrors(callback,GatewayUserRightsErrorEvent.RIGHTS_READ_FAILED,"requesting user-rights",param1.response))
            {
               return;
            }
            var _loc2_:ByteArray = param1.response.payload;
            _loc2_.position = 0;
            var _loc3_:uint = _loc2_.readUnsignedByte();
            var _loc4_:Array = [];
            while(_loc2_.bytesAvailable)
            {
               _loc4_.push(_loc2_.readUnsignedByte());
            }
            rightsCache[_loc3_] = _loc4_;
            CallbackHelper.callCallback(callback,[self,_loc4_,user,null]);
            dispatchEvent(new GatewayUserRightsEvent(GatewayUserRightsEvent.RIGHTS_READ,false,false,user,_loc4_));
         });
      }
      
      private function checkForErrors(param1:Function, param2:String, param3:String, param4:MCPPackage) : Boolean
      {
         var _loc6_:int = 0;
         var _loc5_:Error = null;
         if(param4 == null)
         {
            _loc5_ = new Error(param3 + " failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
            CallbackHelper.callCallback(param1,[this,null,null,_loc5_]);
            dispatchEvent(new GatewayUserRightsErrorEvent(param2,false,false,_loc5_.errorID));
            return true;
         }
         if(param4.command == MCPCommands.ERROR)
         {
            _loc6_ = MCPErrors.getErrorFromPackage(param4);
            _loc5_ = new Error(param3 + " failed! (Error: 0x" + StringHelper.int2hex(_loc6_) + " = " + MCPErrors.NAMES[_loc6_] + ")",_loc6_);
            InfoCenter.onMCPError(param4,_loc6_);
            CallbackHelper.callCallback(param1,[this,null,null,_loc5_]);
            dispatchEvent(new GatewayUserRightsErrorEvent(param2,false,false,_loc6_));
            return true;
         }
         return false;
      }
   }
}

class ConstructorLock#142
{
    
   
   function ConstructorLock#142()
   {
      super();
   }
}
