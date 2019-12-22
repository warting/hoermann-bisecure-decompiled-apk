package
{
   import mx.resources.ResourceBundle;
   
   public class fi_FI$layout_properties extends ResourceBundle
   {
       
      
      public function fi_FI$layout_properties()
      {
         super("fi_FI","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"Kohdetta ConstraintRow \'{0}\' ei löytynyt.",
            "constraintLayoutNotVirtualized":"ConstraintLayout ei tue virtualisointia.",
            "basicLayoutNotVirtualized":"BasicLayout ei tue virtualisointia.",
            "columnNotFound":"Kohdetta ConstraintColumn \'{0}\' ei löytynyt.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Virheellinen perusarvo rivillä {0}: \'{1}\'. Arvon pitää olla Number tai muodossa \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
