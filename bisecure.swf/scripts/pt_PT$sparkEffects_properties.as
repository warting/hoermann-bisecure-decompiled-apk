package
{
   import mx.resources.ResourceBundle;
   
   public class pt_PT$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function pt_PT$sparkEffects_properties()
      {
         super("pt_PT","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition só funciona em instâncias do IUIComponent e GraphicElement.",
            "accDecWithinRange":"(aceleração + desaceleração) deve estar dentro do intervalo [0,1].",
            "propNotPropOrStyle":"Propriedade [[0]] não é uma propriedade ou um estilo no objecto [[1]]: [[2]].",
            "cannotCalculateValue":"Interpolator não consegue calcular valores interpolados quando o startValue ([[0]]) ou endValue ([[1]]) não é um número.",
            "illegalPropValue":"Valor da propriedade inválido: [[0]].",
            "arraysNotOfEqualLength":"Os arrays, primeiro e final, devem ser do mesmo tamanho.",
            "endValContainsNonNums":"O endValue array contém caractéres não numéricos: você tem de fornecer Interpolator à Animation.",
            "startValContainsNonNums":"O startValue array contém caractéres não numéricos: você tem de fornecer Interpolator à Animation."
         };
         return _loc1_;
      }
   }
}
