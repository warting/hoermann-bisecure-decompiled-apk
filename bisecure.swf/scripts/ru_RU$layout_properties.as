package
{
   import mx.resources.ResourceBundle;
   
   public class ru_RU$layout_properties extends ResourceBundle
   {
       
      
      public function ru_RU$layout_properties()
      {
         super("ru_RU","layout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "rowNotFound":"ConstraintRow \"{0}\" не найден.",
            "constraintLayoutNotVirtualized":"ConstraintLayout не поддерживает виртуализацию.",
            "basicLayoutNotVirtualized":"BasicLayout не поддерживает виртуализацию.",
            "columnNotFound":"ConstraintColumn \"{0}\" не найден.",
            "invalidIndex":"Недопустимый индекс",
            "invalidBaselineOnRow":"Недействительное базовое значение в строке {0}: \"{1}\". Необходимо использовать Number или шаблон \"maxAscent:x\"."
         };
         return _loc1_;
      }
   }
}
