package
{
   import mx.resources.ResourceBundle;
   
   public class pt_PT$layout_properties extends ResourceBundle
   {
       
      
      public function pt_PT$layout_properties()
      {
         super("pt_PT","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"A ConstraintRow \'[[0]]\' não foi encontrada.",
            "constraintLayoutNotVirtualized":"O ConstraintLayout não suporta virtualização.",
            "basicLayoutNotVirtualized":"BasicLayout não suporta virtualização.",
            "columnNotFound":"A ConstraintColumn \'[[0]]\' não foi encontrada.",
            "invalidIndex":"indexInválido",
            "invalidBaselineOnRow":"Valor de base inválido na linha [[0]]: \'[[1]]\'. Deve ser um Number ou estar na forma \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
