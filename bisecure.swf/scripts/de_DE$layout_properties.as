package
{
   import mx.resources.ResourceBundle;
   
   public class de_DE$layout_properties extends ResourceBundle
   {
       
      
      public function de_DE$layout_properties()
      {
         super("de_DE","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow „{0}“ nicht gefunden.",
            "constraintLayoutNotVirtualized":"ConstraintLayout unterstützt keine Virtualisierung.",
            "basicLayoutNotVirtualized":"BasicLayout unterstützt keine Virtualisierung.",
            "columnNotFound":"ConstraintColumn „{0}“ nicht gefunden.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Ungültiger Grundlinienwert in Zeile {0}: „{1}“. Muss eine Zahl sein oder in der Form „maxAscent:x“ angegeben werden."
         };
         return _loc1_;
      }
   }
}
