package com.isisic.remote.hoermann.global.valueObjects.localStorage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class PortalData implements IExternalizable
   {
       
      
      public var deviceId:String;
      
      public var username:String;
      
      public var password:String;
      
      public function PortalData()
      {
         super();
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeUTF(this.deviceId);
         param1.writeUTF(this.username);
         param1.writeUTF(this.password);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.deviceId = param1.readUTF();
         this.username = param1.readUTF();
         this.password = param1.readUTF();
      }
   }
}
