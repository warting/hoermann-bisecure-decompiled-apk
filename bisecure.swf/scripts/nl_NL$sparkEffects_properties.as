package
{
   import mx.resources.ResourceBundle;
   
   public class nl_NL$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function nl_NL$sparkEffects_properties()
      {
         super("nl_NL","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition werkt alleen op exemplaren van IUIComponent en GraphicElement.",
            "accDecWithinRange":"(versnelling + vertraging) moeten binnen bereik [0,1] vallen.",
            "propNotPropOrStyle":"Eigenschap [0] is geen eigenschap en geen stijl op object {1}: {2}.",
            "cannotCalculateValue":"Interpolator kan geen geïnterpoleerde waarden berekenen wanneer startValue ({0}) of endValue ({1}) geen getal is.",
            "illegalPropValue":"Ongeldige eigenschapswaarde: {0}.",
            "arraysNotOfEqualLength":"De begin- en eindmatrices moeten even lang zijn.",
            "endValContainsNonNums":"De matrix endValue bevat waarden die geen getallen zijn; u moet een aangepaste Interpolator aan Animation leveren.",
            "startValContainsNonNums":"De matrix startValue bevat waarden die geen getallen zijn; u moet een Interpolator aan Animation leveren."
         };
         return _loc1_;
      }
   }
}
