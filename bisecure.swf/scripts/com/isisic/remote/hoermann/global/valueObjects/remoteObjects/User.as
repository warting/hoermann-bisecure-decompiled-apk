package com.isisic.remote.hoermann.global.valueObjects.remoteObjects
{
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.Scenario;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public dynamic class User implements IExternalizable
   {
      
      public static const ID_UNKNOWN:int = -1;
      
      public static const ID_ADMIN:int = 0;
       
      
      public var id:int;
      
      public var name:String;
      
      public var password:String;
      
      public var scenarios:Array;
      
      public function User(param1:int = -1, param2:String = null, param3:String = null, param4:Array = null)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.password = param3;
         this.scenarios = param4;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Scenario = null;
         param1.writeInt(this.id);
         param1.writeUTF(this.name);
         param1.writeUTF(this.password);
         param1.writeUnsignedInt(this.scenarios.length);
         for each(_loc3_ in this.scenarios)
         {
            _loc2_ = new ByteArray();
            _loc3_.writeExternal(_loc2_);
            param1.writeUnsignedInt(_loc2_.length);
            param1.writeBytes(_loc2_);
         }
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:Scenario = null;
         this.id = param1.readInt();
         this.name = param1.readUTF();
         this.password = param1.readUTF();
         this.scenarios = new Array();
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = param1.readUnsignedInt();
            _loc4_ = new ByteArray();
            param1.readBytes(_loc4_,0,_loc3_);
            _loc5_ = new Scenario();
            _loc5_.readExternal(_loc4_);
            this.scenarios.push(_loc5_);
            _loc6_++;
         }
      }
   }
}
