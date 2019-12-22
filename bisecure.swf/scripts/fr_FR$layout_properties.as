package
{
   import mx.resources.ResourceBundle;
   
   public class fr_FR$layout_properties extends ResourceBundle
   {
       
      
      public function fr_FR$layout_properties()
      {
         super("fr_FR","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \'{0}\' introuvable.",
            "constraintLayoutNotVirtualized":"ConstraintLayout ne prend pas en charge la virtualisation.",
            "basicLayoutNotVirtualized":"BasicLayout ne prend pas en charge la virtualisation.",
            "columnNotFound":"ConstraintColumn \'{0}\' introuvable.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Valeur initiale non valide sur la ligne {0}: \'{1}\'. Doit être un Nombre ou se présenter sous la forme \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
