package
{
   import mx.resources.ResourceBundle;
   
   public class da_DK$layout_properties extends ResourceBundle
   {
       
      
      public function da_DK$layout_properties()
      {
         super("da_DK","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \'{0}\' blev ikke fundet.",
            "constraintLayoutNotVirtualized":"ConstraintLayout understøtter ikke virtualisering.",
            "basicLayoutNotVirtualized":"BasicLayout understøtter ikke virtualisering.",
            "columnNotFound":"ConstraintColumn \'{0}\' blev ikke fundet.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Ugyldig grundlinjeværdi i række {0}: \'{1}\'. Det skal være et tal eller have formen \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
