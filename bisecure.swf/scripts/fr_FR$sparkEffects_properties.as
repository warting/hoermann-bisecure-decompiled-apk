package
{
   import mx.resources.ResourceBundle;
   
   public class fr_FR$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function fr_FR$sparkEffects_properties()
      {
         super("fr_FR","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition fonctionne uniquement dans des instances IUIComponent et GraphicElement.",
            "accDecWithinRange":"(accélération + ralentissement) doit se situer dans la plage [0,1].",
            "propNotPropOrStyle":"La propriété {0} n’est pas une propriété ou un style pour l’objet {1} : {2}.",
            "cannotCalculateValue":"L’interpolateur ne peut pas calculer de valeurs interpolées si les valeurs de startValue ({0}) ou endValue ({1}) ne sont pas des nombres.",
            "illegalPropValue":"Valeur de propriété illégale : {0}.",
            "arraysNotOfEqualLength":"Les tableaux de début et de fin doivent être de longueur équivalente.",
            "endValContainsNonNums":"Le tableau endValue contient des valeurs autres que des nombres : vous devez fournir un interpolateur personnalisé à Animation.",
            "startValContainsNonNums":"Le tableau startValue contient des valeurs autres que des nombres : vous devez fournir un interpolateur à Animation."
         };
         return _loc1_;
      }
   }
}
