package mx.core
{
   import flash.display.Loader;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   public class FlexLoader extends Loader
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function FlexLoader()
      {
         super();
         try
         {
            name = NameUtil.createUniqueName(this);
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      override public function toString() : String
      {
         return NameUtil.displayObjectToString(this);
      }
   }
}
