package spark.skins.mobile.supportClasses
{
   import mx.core.ClassFactory;
   import spark.components.supportClasses.SkinnableComponent;
   
   public class ButtonBarButtonClassFactory extends ClassFactory
   {
       
      
      private var _skinClass:Class;
      
      public function ButtonBarButtonClassFactory(param1:Class)
      {
         super(param1);
      }
      
      public function get skinClass() : Class
      {
         return this._skinClass;
      }
      
      public function set skinClass(param1:Class) : void
      {
         this._skinClass = param1;
      }
      
      override public function newInstance() : *
      {
         var _loc2_:* = null;
         var _loc1_:Object = new generator();
         if(properties != null)
         {
            for(_loc2_ in properties)
            {
               _loc1_[_loc2_] = properties[_loc2_];
            }
         }
         if(_loc1_ is SkinnableComponent && this._skinClass)
         {
            SkinnableComponent(_loc1_).setStyle("skinClass",this._skinClass);
            SkinnableComponent(_loc1_).setStyle("focusSkin",null);
         }
         return _loc1_;
      }
   }
}
