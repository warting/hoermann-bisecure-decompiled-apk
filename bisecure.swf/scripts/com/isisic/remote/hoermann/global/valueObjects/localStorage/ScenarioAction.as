package com.isisic.remote.hoermann.global.valueObjects.localStorage
{
   import com.isisic.remote.lw.Debug;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   
   public class ScenarioAction implements IExternalizable
   {
       
      
      public var portId:int;
      
      public var portType:int;
      
      public var groupId:int;
      
      public function ScenarioAction(param1:int, param2:int, param3:int)
      {
         super();
         this.portId = param1;
         this.groupId = param3;
         this.portType = param2;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         Debug.debug("[ScenarioAction] write");
         param1.writeInt(this.portId);
         param1.writeInt(this.groupId);
         param1.writeInt(this.portType);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         Debug.debug("[ScenarioAction] read");
         this.portId = param1.readInt();
         this.groupId = param1.readInt();
         this.portType = param1.readInt();
      }
   }
}
