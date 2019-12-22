package
{
   import mx.resources.ResourceBundle;
   
   public class ru_RU$effects_properties extends ResourceBundle
   {
       
      
      public function ru_RU$effects_properties()
      {
         super("ru_RU","effects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "incorrectTrigger":"Эффект масштабирования невозможно запустить при помощи триггера moveEffect.",
            "incorrectSource":"Исходное свойство должно быть \"Класс\" или \"Строка\"."
         };
         return _loc1_;
      }
   }
}
