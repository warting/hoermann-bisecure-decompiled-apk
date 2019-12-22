package
{
   import mx.resources.ResourceBundle;
   
   public class nb_NO$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function nb_NO$sparkEffects_properties()
      {
         super("nb_NO","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition kan bare operere på forekomster av IUIComponent og GraphicElement.",
            "accDecWithinRange":"(akselerasjon + deselerasjon) må være innenfor området [0,1].",
            "propNotPropOrStyle":"Egenskapen {0} er ikke en egenskap eller en stil på objektet {1}: {2}.",
            "cannotCalculateValue":"Interpolator kan ikke beregne interpolerte verdier når startValue ({0}) eller endValue ({1}) ikke er et tall.",
            "illegalPropValue":"Ugyldig egenskapsverdi: {0}.",
            "arraysNotOfEqualLength":"Start- og sluttmatriser må være like lange.",
            "endValContainsNonNums":"endValue-matrisen inneholder ikke-tall: du må sende en tilpasset interpolator til animering.",
            "startValContainsNonNums":"startValue-matrisen inneholder ikke-tall: du må sende en interpolator til animering."
         };
         return _loc1_;
      }
   }
}
