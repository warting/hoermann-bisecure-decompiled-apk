package
{
   import mx.resources.ResourceBundle;
   
   public class it_IT$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function it_IT$sparkEffects_properties()
      {
         super("it_IT","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition funziona solo su istanze IUIComponent e GraphicElement.",
            "accDecWithinRange":"Il valore (accelerazione + decelerazione) deve rientrare nell\'intervallo [0,1].",
            "propNotPropOrStyle":"La proprietà {0} non è né una proprietà né uno stile di oggetto {1}: {2}.",
            "cannotCalculateValue":"Interpolator non è in grado di calcolare i valori interpolati quando startValue ({0}) o endValue ({1}) non è un numero.",
            "illegalPropValue":"Valore di proprietà non valido: {0}.",
            "arraysNotOfEqualLength":"Gli array di inizio e di fine devono avere la stessa lunghezza.",
            "endValContainsNonNums":"L\'array endValue contiene elementi non numerici: è necessario fornire un Interpolator personalizzato ad Animation.",
            "startValContainsNonNums":"L\'array startValue contiene elementi non numerici: è necessario fornire Interpolator ad Animation."
         };
         return _loc1_;
      }
   }
}
