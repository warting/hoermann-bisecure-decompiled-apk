package spark.components.supportClasses
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import spark.components.View;
   
   public class ViewDescriptor implements IExternalizable
   {
       
      
      public var context:Object;
      
      public var data:Object;
      
      public var instance:View;
      
      public var persistenceData:Object;
      
      public var viewClass:Class;
      
      public function ViewDescriptor(param1:Class = null, param2:Object = null, param3:Object = null, param4:View = null)
      {
         super();
         this.viewClass = param1;
         this.data = param2;
         this.context = param3;
         this.instance = param4;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeObject(this.context);
         param1.writeObject(this.persistenceData);
         param1.writeObject(getQualifiedClassName(this.viewClass));
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this.context = param1.readObject();
         this.persistenceData = param1.readObject();
         var _loc2_:String = param1.readObject();
         this.viewClass = _loc2_ == "null"?null:getDefinitionByName(_loc2_) as Class;
      }
   }
}
