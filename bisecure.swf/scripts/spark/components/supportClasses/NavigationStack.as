package spark.components.supportClasses
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class NavigationStack implements IExternalizable
   {
       
      
      private var _source:Vector.<ViewDescriptor>;
      
      public function NavigationStack()
      {
         super();
         this._source = new Vector.<ViewDescriptor>();
      }
      
      mx_internal function get source() : Vector.<ViewDescriptor>
      {
         return this._source;
      }
      
      public function get length() : int
      {
         return this._source.length;
      }
      
      mx_internal function get topView() : ViewDescriptor
      {
         return this._source.length == 0?null:this._source[this._source.length - 1];
      }
      
      public function clear() : void
      {
         this._source.length = 0;
      }
      
      public function pushView(param1:Class, param2:Object, param3:Object = null) : ViewDescriptor
      {
         var _loc4_:ViewDescriptor = new ViewDescriptor(param1,param2,param3);
         this._source.push(_loc4_);
         return _loc4_;
      }
      
      public function popView() : ViewDescriptor
      {
         return this._source.pop();
      }
      
      public function popToFirstView() : ViewDescriptor
      {
         var _loc1_:ViewDescriptor = null;
         if(this._source.length > 1)
         {
            _loc1_ = this.topView;
            this._source.length = 1;
            return _loc1_;
         }
         return null;
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         param1.writeObject(this._source);
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         this._source = param1.readObject() as Vector.<ViewDescriptor>;
      }
   }
}
