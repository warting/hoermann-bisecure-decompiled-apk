package
{
   import mx.resources.ResourceBundle;
   
   public class fi_FI$effects_properties extends ResourceBundle
   {
       
      
      public function fi_FI$effects_properties()
      {
         super("fi_FI","effects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "incorrectTrigger":"Zoomaustehostetta ei voi laukaista moveEffect-liipasimella.",
            "incorrectSource":"Source-ominaisuuden on oltava luokka tai merkkijono."
         };
         return _loc1_;
      }
   }
}
