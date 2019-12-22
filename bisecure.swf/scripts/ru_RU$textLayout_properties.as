package
{
   import mx.resources.ResourceBundle;
   
   public class ru_RU$textLayout_properties extends ResourceBundle
   {
       
      
      public function ru_RU$textLayout_properties()
      {
         super("ru_RU","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"Не найден нижестоящий элемент для удаления",
            "badReplaceChildrenIndex":"Индекс для FlowGroupElement.replaceChildren находится за пределами допустимого диапазона",
            "missingTextFlow":"Отсутствует TextFlow для анализа",
            "unexpectedNamespace":"Непредвиденное пространство имен {0}",
            "badMXMLChildrenArgument":"Недопустимый элемент типа {0} передан в mxmlChildren",
            "invalidReplaceTextPositions":"Недействительные позиции переданы в SpanElement.replaceText",
            "invalidSplitAtPosition":"Недействительный параметр для splitAtPosition",
            "badSurrogatePairCopy":"Выполняется копирование только половины суррогатной пары в SpanElement.shallowCopy",
            "invalidChildType":"NewElement не является возможным нижестоящим типом для данного элемента",
            "unknownAttribute":"Атрибут {0} не разрешен для элемента {1}",
            "invalidSurrogatePairSplit":"Недействительное разделение суррогатной пары",
            "expectedExactlyOneTextLayoutFormat":"Ожидался только один TextLayoutFormat в {0}\t",
            "invalidFlowElementConstruct":"Выполнена попытка создания недопустимого подкласса FlowElement",
            "malformedTag":"Недопустимый тег {0}",
            "missingStringResource":"Отсутствует строка для ресурса {0}",
            "invalidSplitAtIndex":"Недействительный параметр для splitAtIndex",
            "illegalOperation":"Недопустимая попытка выполнения операции {0}",
            "malformedMarkup":"Недопустимая разметка {0}",
            "unexpectedXMLElementInSpan":"Непредвиденный элемент {0} в диапазоне",
            "badPropertyValue":"Указанное для свойства {0} значение {1} находится за пределами допустимого диапазона",
            "badShallowCopyRange":"Недопустимый диапазон в shallowCopy",
            "unknownElement":"Неизвестный элемент {0}"
         };
         return _loc1_;
      }
   }
}
