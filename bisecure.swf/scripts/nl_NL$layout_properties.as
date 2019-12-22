package
{
   import mx.resources.ResourceBundle;
   
   public class nl_NL$layout_properties extends ResourceBundle
   {
       
      
      public function nl_NL$layout_properties()
      {
         super("nl_NL","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \'{0}\' niet gevonden.",
            "constraintLayoutNotVirtualized":"ConstraintLayout ondersteunt virtualisatie niet.",
            "basicLayoutNotVirtualized":"BasicLayout ondersteunt geen virtualisatie.",
            "columnNotFound":"ConstraintColumn \'{0}\' niet gevonden.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Ongeldige basislijnwaarde op rij {0}: \'{1}\'. Moet een getal zijn of de notatie \'maxAscent:x\' hebben."
         };
         return _loc1_;
      }
   }
}
