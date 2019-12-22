package
{
   import mx.resources.ResourceBundle;
   
   public class bg_BG$effects_properties extends ResourceBundle
   {
       
      
      public function bg_BG$effects_properties()
      {
         super("bg_BG","effects");
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
