package
{
   import mx.resources.ResourceBundle;
   
   public class ru_RU$core_properties extends ResourceBundle
   {
       
      
      public function ru_RU$core_properties()
      {
         super("ru_RU","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Несколько наборов видимых нижестоящих элементов определены для этого компонента (определение компонента и экземпляр компонента).",
            "truncationIndicator":"...",
            "notExecuting":"Повторитель не работает.",
            "remoteClassMemoryLeak":"Предупреждение. Класс {0} использовался для вызова net.registerClassAlias() в {2}, что может стать причиной утечки в {1}. Для устранения утечки определите {0} в приложении верхнего уровня. ",
            "nullParameter":"Параметр {0} не может принимать значение null.",
            "versionAlreadyRead":"Версия совместимости уже считана.",
            "multipleChildSets_ClassAndSubclass":"Несколько наборов видимых нижестоящих элементов определены для этого компонента (определение основного и полученного компонента).",
            "fontIncompatible":"Предупреждение: несовместимый встроенный шрифт \"{0}\" указан для {1}. Для этого компонента требуется объявление встроенного шрифта посредством embedAsCff={2}.",
            "badParameter":"Параметр {0} должен принимать одно из принятых значений.",
            "notImplementedInFTETextField":"\"{0}\" не реализовано в FTETextField.",
            "viewSource":"Отобразить код",
            "unsupportedTypeInFTETextField":"FTETextField не поддерживает настройку типа как \"input\".",
            "badFile":"Файл не существует.",
            "stateUndefined":"Неопределенное состояние \"{0}\".",
            "badIndex":"Переданный индекс превышает заданные пределы.",
            "versionAlreadySet":"Версия совместимости уже установлена."
         };
         return _loc1_;
      }
   }
}
