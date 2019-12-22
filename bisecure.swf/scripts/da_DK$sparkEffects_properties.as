package
{
   import mx.resources.ResourceBundle;
   
   public class da_DK$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function da_DK$sparkEffects_properties()
      {
         super("da_DK","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition kan kun bruges på forekomster af IUIComponent og GraphicElement.",
            "accDecWithinRange":"(acceleration + deceleration) skal være indenfor intervallet [0,1].",
            "propNotPropOrStyle":"Egenskaben {0} er hverken en egenskab eller en stil for objektet {1}: {2}.",
            "cannotCalculateValue":"Interpolatoren kan ikke beregne interpolerede værdier når startValue ({0}) eller endValue ({1}) ikke er et tal.",
            "illegalPropValue":"Ugyldig værdi for egenskab: {0}.",
            "arraysNotOfEqualLength":"Start- og slut-sættene skal have samme længde.",
            "endValContainsNonNums":"Sættet endValue indeholder værdier som ikke er tal: Du skal angive en brugerdefineret Interpolator til Animation.",
            "startValContainsNonNums":"Sættet startValue indeholder værdier som ikke er tal: Du skal angive Interpolator til Animation."
         };
         return _loc1_;
      }
   }
}
