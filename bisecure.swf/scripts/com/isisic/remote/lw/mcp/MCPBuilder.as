package com.isisic.remote.lw.mcp
{
   import flash.utils.ByteArray;
   import me.mweber.basic.helper.StringHelper;
   
   public class MCPBuilder
   {
       
      
      public function MCPBuilder()
      {
         super();
      }
      
      public static function buildMCP(param1:int, param2:ByteArray = null, param3:MCP = null) : MCP
      {
         if(param3 == null)
         {
            param3 = new MCP();
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
      
      public static function payloadLogin(param1:String, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(StringHelper.getByteLength(param1));
         _loc3_.writeUTFBytes(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadSetValue(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadGetValue(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadGetUserRights(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadGetTransition(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadJMCP(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
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
      
      public static function payloadSetGroupName(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadRemovePort(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadRemoveGroup(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadGetType(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadSetType(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadSetState(param1:int, param2:int) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeByte(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadSetName(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadChangePassword(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadChangePasswordOfUser(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadChangeUserName(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public static function payloadChangeUserNameOfUser(param1:int, param2:String) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeByte(param1);
         _loc3_.writeUTFBytes(param2);
         _loc3_.position = 0;
         return _loc3_;
      }
      
      public static function payloadRemoveUser(param1:int) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeByte(param1);
         _loc2_.position = 0;
         return _loc2_;
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
   }
}
