package mx.core
{
   import flash.text.TextField;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   public class FlexTextField extends TextField
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function FlexTextField()
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
