package
{
   import mx.resources.ResourceBundle;
   
   public class sv_SE$layout_properties extends ResourceBundle
   {
       
      
      public function sv_SE$layout_properties()
      {
         super("sv_SE","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"Det går inte att hitta ConstraintRow \"{0\\}\"",
            "constraintLayoutNotVirtualized":"ConstraintLayout stöder inte virtualisering.",
            "basicLayoutNotVirtualized":"BasicLayout stöder inte virtualisering.",
            "columnNotFound":"Det går inte att hitta ConstraintColumn \"{0}\".",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Ogiltigt baslinjevärde på rad {0}: \"{1}\". Måste vara en siffra eller i formen \"maxAscent:x\"."
         };
         return _loc1_;
      }
   }
}
