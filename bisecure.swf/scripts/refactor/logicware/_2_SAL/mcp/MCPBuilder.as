package refactor.logicware._2_SAL.mcp
{
   import flash.utils.ByteArray;
   import me.mweber.basic.helper.StringHelper;
   
   public class MCPBuilder
   {
       
      
      public function MCPBuilder()
      {
         super();
      }
      
      public static function createMCP(param1:int, param2:ByteArray = null, param3:MCPPackage = null) : MCPPackage
      {
         if(param3 == null)
         {
            param3 = new MCPPackage();
         }
         else
         {
            param3.clear();
         }
         param3.command = param1;
         param3.payload = param2;
         param3.tag = 0;
         if(param3.payload != null)
         {
            param3.payload.position = 0;
         }
         return param3;
      }
      
      public static function createPing(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.PING,null,param1);
      }
      
      public static function createGetMac(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_MAC,null,param1);
      }
      
      public static function createGetName(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_NAME,null,param1);
      }
      
      public static function createLogin(param1:String, param2:String, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.LOGIN,payloadLogin(param1,param2),param3);
      }
      
      public static function payloadLogin(param1:String, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(StringHelper.getByteLength(param1));
         _loc3_.writeUTFBytes(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createLogout(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.LOGOUT,null,param1);
      }
      
      public static function createSetValue(param1:int, param2:int, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_VALUE,payloadSetValue(param1,param2),param3);
      }
      
      public static function payloadSetValue(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createGetValue(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_VALUE,payloadGetValue(param1),param2);
      }
      
      public static function payloadGetValue(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createGetUserRights(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_USER_RIGHTS,payloadGetUserRights(param1),param2);
      }
      
      public static function payloadGetUserRights(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createAddPort(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.ADD_PORT,null,param1);
      }
      
      public static function createAddGroup(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.ADD_GROUP,null,param1);
      }
      
      public static function createGetTransition(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.HM_GET_TRANSITION,payloadGetTransition(param1),param2);
      }
      
      public static function payloadGetTransition(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createJMCP(param1:String, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.JMCP,payloadJMCP(param1),param2);
      }
      
      public static function payloadJMCP(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createGetGwVersion(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_GW_VERSION,null,param1);
      }
      
      public static function createSetGroupedPorts(param1:int, param2:Array, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_GROUPED_PORTS,payloadSetGroupedPorts(param1,param2),param3);
      }
      
      public static function payloadSetGroupedPorts(param1:int, param2:Array) : ByteArray
      {
         var _loc4_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         for each(_loc4_ in param2)
         {
            _loc3_.writeByte(_loc4_);
         }
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createSetGroupName(param1:int, param2:String, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_GROUP_NAME,payloadSetGroupName(param1,param2),param3);
      }
      
      public static function payloadSetGroupName(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createInheritPort(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.INHERIT_PORT,null,param1);
      }
      
      public static function createRemovePort(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.REMOVE_PORT,payloadRemovePort(param1),param2);
      }
      
      public static function payloadRemovePort(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createRemoveGroup(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.REMOVE_GROUP,payloadRemoveGroup(param1),param2);
      }
      
      public static function payloadRemoveGroup(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createGetPorts(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_PORTS,null,param1);
      }
      
      public static function createGetType(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_TYPE,payloadGetType(param1),param2);
      }
      
      public static function payloadGetType(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createSetType(param1:int, param2:int, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_TYPE,payloadSetType(param1,param2),param3);
      }
      
      public static function payloadSetType(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createSetState(param1:int, param2:int, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_STATE,payloadSetState(param1,param2),param3);
      }
      
      public static function payloadSetState(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createSetName(param1:String, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_NAME,payloadSetName(param1),param2);
      }
      
      public static function payloadSetName(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createChangePassword(param1:String, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.CHANGE_PASSWD,payloadChangePassword(param1),param2);
      }
      
      public static function payloadChangePassword(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createChangePasswordOfUser(param1:int, param2:String, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.CHANGE_PASSWORD_OF_USER,payloadChangePasswordOfUser(param1,param2),param3);
      }
      
      public static function payloadChangePasswordOfUser(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createChangeUserName(param1:String, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.CHANGE_USER_NAME,payloadChangeUserName(param1),param2);
      }
      
      public static function payloadChangeUserName(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createChangeUserNameOfUser(param1:int, param2:String, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.CHANGE_USER_NAME_OF_USER,payloadChangeUserNameOfUser(param1,param2),param3);
      }
      
      public static function payloadChangeUserNameOfUser(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createRemoveUser(param1:int, param2:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.REMOVE_USER,payloadRemoveUser(param1),param2);
      }
      
      public static function payloadRemoveUser(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function createAddUser(param1:String, param2:String, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.ADD_USER,payloadAddUser(param1,param2),param3);
      }
      
      public static function payloadAddUser(param1:String, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(StringHelper.getByteLength(param1));
         _loc3_.writeUTFBytes(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createSetUserRights(param1:int, param2:Array, param3:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SET_USER_RIGHTS,payloadSetUserRights(param1,param2),param3);
      }
      
      public static function payloadSetUserRights(param1:int, param2:Array) : ByteArray
      {
         var _loc4_:int = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         for each(_loc4_ in param2)
         {
            _loc3_.writeByte(_loc4_);
         }
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function createScanWifi(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.SCAN_WIFI,null,param1);
      }
      
      public static function createGetWifiState(param1:MCPPackage = null) : MCPPackage
      {
         return createMCP(MCPCommands.GET_WIFI_STATE,null,param1);
      }
   }
}
