package
{
   import mx.resources.ResourceBundle;
   
   public class ru_RU$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function ru_RU$sparkEffects_properties()
      {
         super("ru_RU","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition может работать только с экземплярами IUIComponent и GraphicElement.",
            "accDecWithinRange":"(ускорение + замедление) должен находиться в диапазоне [0,1].",
            "propNotPropOrStyle":"Свойство {0} не является свойством или стилем объекта {1}: {2}.",
            "cannotCalculateValue":"Интерполятор не может вычислить интерполированные значения, если startValue ({0}) или endValue ({1}) не являются числами.",
            "illegalPropValue":"Недопустимое значение свойства: {0}.",
            "arraysNotOfEqualLength":"Массивы начала и конца должны иметь одинаковую длину.",
            "endValContainsNonNums":"Массив endValue содержит символы, отличные от чисел: для анимации требуется интерполятор.",
            "startValContainsNonNums":"Массив startValue содержит символы, отличные от чисел: для анимации требуется интерполятор."
         };
         return _loc1_;
      }
   }
}
