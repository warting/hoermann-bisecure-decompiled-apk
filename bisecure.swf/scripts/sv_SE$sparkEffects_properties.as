package
{
   import mx.resources.ResourceBundle;
   
   public class sv_SE$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function sv_SE$sparkEffects_properties()
      {
         super("sv_SE","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition fungerar endast tillsammans med IUIComponent- och GraphicElement-instanser.",
            "accDecWithinRange":"(acceleration + deceleration) måste vara inom intervallet [0,1].",
            "propNotPropOrStyle":"Egenskap {0} är varken en egenskap eller en stil som hör till objekt {1}: {2}.",
            "cannotCalculateValue":"startValue ({0}) eller endValue ({1}) måste vara tal annars kan inte Interpolator beräkna interpolerade värden.",
            "illegalPropValue":"Felaktigt egenskapsvärde: {0}.",
            "arraysNotOfEqualLength":"Start- och slutarrayer måste vara lika långa.",
            "endValContainsNonNums":"Array endValue innehåller inte bara siffror: du måste ange en anpassad Interpolator till Animation.",
            "startValContainsNonNums":"Array startValue innehåller inte bara siffror: du måste ange en anpassad Interpolator till Animation."
         };
         return _loc1_;
      }
   }
}
