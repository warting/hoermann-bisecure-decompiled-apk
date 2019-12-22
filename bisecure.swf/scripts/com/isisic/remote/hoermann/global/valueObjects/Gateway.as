package com.isisic.remote.hoermann.global.valueObjects
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class Gateway implements IExternalizable
   {
       
      
      public var available:Boolean = false;
      
      public var name:String = "";
      
      public var mac:String = "000000000000";
      
      public var isPortal:Boolean = false;
      
      public var host:String = "";
      
      public var port:int = 4000;
      
      public var localIp:String = null;
      
      public var localPort:int = -1;
      
      public var users:Array;
      
      public var lastUser:int = -1;
      
      public var adminPwdChanged:Boolean = false;
      
      public function Gateway()
      {
         this.users = new Array();
         super();
      }
      
      public function parseObject(param1:Object) : void
      {
         this.available = param1.available;
         this.name = param1.name;
         this.mac = param1.mac;
         this.isPortal = param1.isPortal;
         this.host = param1.host;
         this.port = param1.port;
         this.localIp = param1.localIp;
         this.localPort = param1.localPort;
         this.users = param1.users;
         this.lastUser = param1.lastUser;
         this.adminPwdChanged = param1.adminPwdChanged;
      }
      
      public function copy(param1:Gateway = null, param2:Vector.<String> = null) : Gateway
      {
         param2 = param2 != null?param2:new Vector.<String>();
         var _loc3_:Gateway = param1 != null?param1:new Gateway();
         if(param2.indexOf("available") < 0)
         {
            _loc3_.available = this.available;
         }
         if(param2.indexOf("name") < 0)
         {
            _loc3_.name = this.name;
         }
         if(param2.indexOf("mac") < 0)
         {
            _loc3_.mac = this.mac;
         }
         if(param2.indexOf("isPortal") < 0)
         {
            _loc3_.isPortal = this.isPortal;
         }
         if(param2.indexOf("host") < 0)
         {
            _loc3_.host = this.host;
         }
         if(param2.indexOf("port") < 0)
         {
            _loc3_.port = this.port;
         }
         if(param2.indexOf("localIp") < 0)
         {
            _loc3_.localIp = this.localIp;
         }
         if(param2.indexOf("localPort") < 0)
         {
            _loc3_.localPort = this.localPort;
         }
         if(param2.indexOf("users") < 0)
         {
            _loc3_.users = this.users;
         }
         if(param2.indexOf("lastUser") < 0)
         {
            _loc3_.lastUser = this.lastUser;
         }
         if(param2.indexOf("adminPwdChanged") < 0)
         {
            _loc3_.adminPwdChanged = this.adminPwdChanged;
         }
         return _loc3_;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:User = null;
         param1.writeBoolean(false);
         param1.writeUTF(this.name);
         param1.writeUTF(this.mac);
         param1.writeBoolean(this.isPortal);
         param1.writeUTF(this.host);
         param1.writeInt(this.port);
         param1.writeUnsignedInt(this.users.length);
         for each(_loc3_ in this.users)
         {
            _loc2_ = new ByteArray();
            _loc3_.writeExternal(_loc2_);
            param1.writeUnsignedInt(_loc2_.length);
            param1.writeBytes(_loc2_);
         }
         param1.writeInt(this.lastUser);
         param1.writeBoolean(this.adminPwdChanged);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:User = null;
         this.available = false;
         this.name = param1.readUTF();
         this.mac = param1.readUTF();
         this.isPortal = param1.readBoolean();
         this.host = param1.readUTF();
         this.port = param1.readInt();
         this.users = new Array();
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = param1.readUnsignedInt();
            _loc4_ = new ByteArray();
            param1.readBytes(_loc4_,0,_loc3_);
            _loc5_ = new User();
            _loc5_.readExternal(_loc4_);
            this.users.push(_loc5_);
            _loc6_++;
         }
         this.lastUser = param1.readInt();
         this.adminPwdChanged = param1.readBoolean();
      }
   }
}
