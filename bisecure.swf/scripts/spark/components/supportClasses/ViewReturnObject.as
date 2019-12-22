package spark.components.supportClasses
{
   public class ViewReturnObject
   {
       
      
      public var context:Object = null;
      
      public var object:Object = null;
      
      public function ViewReturnObject(param1:Object = null, param2:Object = null)
      {
         super();
         this.object = param1;
         this.context = param2;
      }
   }
}
