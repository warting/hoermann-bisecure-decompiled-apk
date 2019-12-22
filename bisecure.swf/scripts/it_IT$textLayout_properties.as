package
{
   import mx.resources.ResourceBundle;
   
   public class it_IT$textLayout_properties extends ResourceBundle
   {
       
      
      public function it_IT$textLayout_properties()
      {
         super("it_IT","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"Elemento secondario da rimuovere non trovato",
            "badReplaceChildrenIndex":"L\'indice a FlowGroupElement.replaceChildren non rientra nell\'intervallo",
            "missingTextFlow":"Nessun TextFlow da analizzare",
            "unexpectedNamespace":"Spazio dei nomi {0} non previsto",
            "badMXMLChildrenArgument":"Elemento di tipo {0} non valido passato a mxmlChildren",
            "invalidReplaceTextPositions":"Posizioni non valide passate a SpanElement.replaceText",
            "invalidSplitAtPosition":"Parametro a splitAtPosition non valido",
            "badSurrogatePairCopy":"Copia di una sola metà di una coppia sostitutiva in SpanElement.shallowCopy",
            "invalidChildType":"NewElement non è di un tipo di cui questo può essere l\'elemento principale",
            "unknownAttribute":"L\'attributo {0} non è consentito nell\'elemento {1}",
            "invalidSurrogatePairSplit":"Divisione di una coppia sostitutiva non valida",
            "expectedExactlyOneTextLayoutFormat":"Previsto un unico TextLayoutFormat in {0}\t",
            "invalidFlowElementConstruct":"Tentativo di costruire una sottoclasse FlowElement non valida",
            "malformedTag":"Tag {0} non valido",
            "missingStringResource":"Nessuna stringa per la risorsa {0}",
            "invalidSplitAtIndex":"Parametro a splitAtIndex non valido",
            "illegalOperation":"Tentativo di eseguire l\'operazione {0} non valido",
            "malformedMarkup":"Codifica {0} non valida",
            "unexpectedXMLElementInSpan":"Elemento {0} non previsto in una estensione",
            "badPropertyValue":"Il valore {1} della proprietà {0} non rientra nell\'intervallo",
            "badShallowCopyRange":"Intervallo non valido in shallowCopy",
            "unknownElement":"Elemento {0} sconosciuto"
         };
         return _loc1_;
      }
   }
}
