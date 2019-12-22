package
{
   import mx.resources.ResourceBundle;
   
   public class el_GR$layout_properties extends ResourceBundle
   {
       
      
      public function el_GR$layout_properties()
      {
         super("el_GR","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \'{0}\' δεν βρέθηκε.",
            "constraintLayoutNotVirtualized":"ConstraintLayout δεν υποστηρίζει virtualization.",
            "basicLayoutNotVirtualized":"Το BasicLayout doesn\'t δεν υποστηριζει virtualization.",
            "columnNotFound":"ConstraintColumn \'{0}\' δεν βρέθηκε.",
            "invalidIndex":"άκυρη Δείκτης",
            "invalidBaselineOnRow":"Invalid baseline value on row {0}: \'{1}\'. Must be a Number or of the form \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
