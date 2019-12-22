package
{
   import mx.resources.ResourceBundle;
   
   public class lv_LV$effects_properties extends ResourceBundle
   {
       
      
      public function lv_LV$effects_properties()
      {
         super("lv_LV","effects");
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
