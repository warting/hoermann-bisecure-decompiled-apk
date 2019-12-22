package
{
   import mx.resources.ResourceBundle;
   
   public class de_DE$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function de_DE$sparkEffects_properties()
      {
         super("de_DE","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition funktioniert nur auf IUIComponent- und GraphicElement-Instanzen.",
            "accDecWithinRange":"(Beschleunigung + Abbremsen) muss im Bereich [0,1] sein.",
            "propNotPropOrStyle":"Die Eigenschaft {0} ist weder eine Eigenschaft noch ein Stil auf Objekt {1}: {2}.",
            "cannotCalculateValue":"Der Interpolator kann keine interpolierten Werte berechnen, wenn startValue ({0}) oder endValue ({1}) keine Zahl ist.",
            "illegalPropValue":"Unzulässiger Eigenschaftswert: {0}.",
            "arraysNotOfEqualLength":"Das Anfangs- und Endarray müssen die gleiche Länge haben.",
            "endValContainsNonNums":"Das endValue-Array enthält andere Werte als Zahlen: Sie müssen für die Animation einen benutzerdefinierten Interpolator bereitstellen.",
            "startValContainsNonNums":"Das startValue-Array enthält andere Werte als Zahlen: Sie müssen für die Animation einen Interpolator bereitstellen."
         };
         return _loc1_;
      }
   }
}
