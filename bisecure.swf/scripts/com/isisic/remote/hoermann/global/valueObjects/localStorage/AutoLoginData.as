package com.isisic.remote.hoermann.global.valueObjects.localStorage
{
   import com.isisic.remote.lw.IDisposable;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class AutoLoginData implements IExternalizable, IDisposable
   {
       
      
      public var mac:String;
      
      public var username:String;
      
      public var password:String;
      
      public function AutoLoginData()
      {
         super();
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeUTF(this.mac);
         param1.writeUTF(this.username);
         param1.writeUTF(this.password);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.mac = param1.readUTF();
         this.username = param1.readUTF();
         this.password = param1.readUTF();
      }
      
      public function dispose() : void
      {
         this.mac = null;
         this.username = null;
         this.password = null;
      }
   }
}
