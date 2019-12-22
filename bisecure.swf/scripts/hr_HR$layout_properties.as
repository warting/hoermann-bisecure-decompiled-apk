package
{
   import mx.resources.ResourceBundle;
   
   public class hr_HR$layout_properties extends ResourceBundle
   {
       
      
      public function hr_HR$layout_properties()
      {
         super("hr_HR","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \'{0}\' not found.",
            "constraintLayoutNotVirtualized":"ConstraintLayout doesn\'t support virtualization.",
            "basicLayoutNotVirtualized":"BasicLayout doesn\'t support virtualization.",
            "columnNotFound":"ConstraintColumn \'{0}\' not found.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Invalid baseline value on row {0}: \'{1}\'. Must be a Number or of the form \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
