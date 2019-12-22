package
{
   import mx.resources.ResourceBundle;
   
   public class nb_NO$layout_properties extends ResourceBundle
   {
       
      
      public function nb_NO$layout_properties()
      {
         super("nb_NO","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"Finner ikke ConstraintRow \'{0}\'.",
            "constraintLayoutNotVirtualized":"ConstraintLayout støtter ikke virtualisering.",
            "basicLayoutNotVirtualized":"BasicLayout støtter ikke virtualisering.",
            "columnNotFound":"Finner ikke ConstraintColumn \'{0}\'.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Ugyldig grunnlinjeverdi på rad {0}: \'{1}\'. Må være et tall eller i formatet \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
