package
{
   import mx.resources.ResourceBundle;
   
   public class hu_HU$effects_properties extends ResourceBundle
   {
       
      
      public function hu_HU$effects_properties()
      {
         super("hu_HU","effects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "incorrectTrigger":"The Zoom effect can not be triggered by a moveEffect trigger.",
            "incorrectSource":"Source property must be a Class or String."
         };
         return _loc1_;
      }
   }
}
