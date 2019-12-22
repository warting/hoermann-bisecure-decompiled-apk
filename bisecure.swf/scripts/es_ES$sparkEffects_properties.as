package
{
   import mx.resources.ResourceBundle;
   
   public class es_ES$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function es_ES$sparkEffects_properties()
      {
         super("es_ES","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition sólo funciona en las instancias IUIComponent y GraphicElement.",
            "accDecWithinRange":"(aceleración + deceleración) debe encontrarse en el rango [0,1].",
            "propNotPropOrStyle":"La propiedad {0} no es una propiedad ni un estilo en el objeto {1}: {2}.",
            "cannotCalculateValue":"El interpolador no puede calcular valores interpolados si los valores de startValue ({0}) o endValue ({1}) no son numéricos.",
            "illegalPropValue":"Valor de propiedad no válido: {0}.",
            "arraysNotOfEqualLength":"Las matrices de inicio y finalización deben tener la misma longitud.",
            "endValContainsNonNums":"La matriz endValue contiene valores no numéricos: se debe proporcionar un interpolador personalizado para Animation.",
            "startValContainsNonNums":"La matriz startValue contiene valores no numéricos: se debe proporcionar un interpolador para Animation."
         };
         return _loc1_;
      }
   }
}
