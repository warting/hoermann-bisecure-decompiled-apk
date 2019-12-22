package
{
   import mx.resources.ResourceBundle;
   
   public class it_IT$layout_properties extends ResourceBundle
   {
       
      
      public function it_IT$layout_properties()
      {
         super("it_IT","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"Impossibile trovare ConstraintRow \'{0}\'.",
            "constraintLayoutNotVirtualized":"ConstraintLayout non supporta la virtualizzazione.",
            "basicLayoutNotVirtualized":"Layout di base non supporta la virtualizzazione.",
            "columnNotFound":"Impossibile trovare ConstraintColumn \'{0}\'.",
            "invalidIndex":"invalidIndex",
            "invalidBaselineOnRow":"Valore linea di base non valido nella riga {0}: \'{1}\'. Deve essere un numero o in formato \'maxAscent:x\'."
         };
         return _loc1_;
      }
   }
}
