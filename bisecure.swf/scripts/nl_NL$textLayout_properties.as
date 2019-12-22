package
{
   import mx.resources.ResourceBundle;
   
   public class nl_NL$textLayout_properties extends ResourceBundle
   {
       
      
      public function nl_NL$textLayout_properties()
      {
         super("nl_NL","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"Te verwijderen onderliggend element niet gevonden",
            "badReplaceChildrenIndex":"Index naar FlowGroupElement.replaceChildren buiten bereik",
            "missingTextFlow":"Er is geen TextFlow om te parseren",
            "unexpectedNamespace":"Onverwachte naamruimte {0}",
            "badMXMLChildrenArgument":"Ongeldig element van type {0} doorgegeven aan mxmlChildren",
            "invalidReplaceTextPositions":"Ongeldige posities doorgegeven aan SpanElement.replaceText",
            "invalidSplitAtPosition":"Ongeldige parameter naar splitAtPosition",
            "badSurrogatePairCopy":"Alleen de helft van een vervangend paar in SpanElement.shallowCopy wordt gekopieerd",
            "invalidChildType":"NewElement niet van een type dat dit als bovenliggend element kan hebben",
            "unknownAttribute":"Kenmerk {0] niet toegestaan in element {1}",
            "invalidSurrogatePairSplit":"Ongeldige splitsing van een vervangend paar",
            "expectedExactlyOneTextLayoutFormat":"Er werd slechts één, en niet meer dan één, TextLayoutFormat in {0}\t verwacht",
            "invalidFlowElementConstruct":"Poging tot samenstellen van ongeldige FlowElement-subklasse",
            "malformedTag":"Onjuist ingedeelde code {0}",
            "missingStringResource":"Geen tekenreeks voor resource {0}",
            "invalidSplitAtIndex":"Ongeldige parameter naar splitAtIndex",
            "illegalOperation":"Ongeldige poging om {0}-bewerking uit te voeren",
            "malformedMarkup":"Onjuist ingedeelde markering {0}",
            "unexpectedXMLElementInSpan":"Onverwacht element {0} binnen een span",
            "badPropertyValue":"Waarde {1} van eigenschap {0} valt buiten bereik",
            "badShallowCopyRange":"Ongeldig bereik in shallowCopy",
            "unknownElement":"Onbekend element {0}"
         };
         return _loc1_;
      }
   }
}
