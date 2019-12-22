package
{
   import mx.resources.ResourceBundle;
   
   public class es_ES$layout_properties extends ResourceBundle
   {
       
      
      public function es_ES$layout_properties()
      {
         super("es_ES","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"No se ha encontrado ConstraintRow \'{0}\'.",
            "constraintLayoutNotVirtualized":"ConstraintLayout no admite virtualización.",
            "basicLayoutNotVirtualized":"BasicLayout no admite virtualización.",
            "columnNotFound":"No se ha encontrado ConstraintColumn \'{0}\'.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Valor de línea de base no válido en fila {0}: \'{1}\'. Debe ser un número o del formulario \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
