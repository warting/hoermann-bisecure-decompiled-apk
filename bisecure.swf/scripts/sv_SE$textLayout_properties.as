package
{
   import mx.resources.ResourceBundle;
   
   public class sv_SE$textLayout_properties extends ResourceBundle
   {
       
      
      public function sv_SE$textLayout_properties()
      {
         super("sv_SE","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"Underordnad som ska tas bort hittades inte",
            "badReplaceChildrenIndex":"Index utanför intervallet: FlowGroupElement.replaceChildren",
            "missingTextFlow":"Det finns inget TextFlow som kan tolkas",
            "unexpectedNamespace":"Oväntat namnutrymme {0}",
            "badMXMLChildrenArgument":"Felaktigt element av typen {0} skickades till mxmlChildren",
            "invalidReplaceTextPositions":"Ogiltiga positioner skickades till SpanElement.replaceText",
            "invalidSplitAtPosition":"Ogiltig parameter till splitAtPosition",
            "badSurrogatePairCopy":"Endast hälften av surrogatparet i SpanElement.shallowCopy kopieras",
            "invalidChildType":"Typen som NewElement tillhör innebär att detta inte kan vara överordnat",
            "unknownAttribute":"Attributet {0} är inte tillåtet i element {1}",
            "invalidSurrogatePairSplit":"Ogiltig delning av surrogatpar",
            "expectedExactlyOneTextLayoutFormat":"Endast en TextLayoutFormat förväntades i {0}\t",
            "invalidFlowElementConstruct":"Försök att konstruera ogiltig FlowElement-underklass",
            "malformedTag":"Felaktig tagg {0}",
            "missingStringResource":"Sträng saknas för resurs {0}",
            "invalidSplitAtIndex":"Ogiltig parameter till splitAtIndex",
            "illegalOperation":"Ogiltigt försök att köra åtgärden {0}",
            "malformedMarkup":"Felaktig markering {0}",
            "unexpectedXMLElementInSpan":"Oväntat element {0} inom intervall",
            "badPropertyValue":"Egenskapen {0} och värde {1} är utanför intervallet",
            "badShallowCopyRange":"Felaktigt intervall i shallowCopy",
            "unknownElement":"Okänt element: {0}"
         };
         return _loc1_;
      }
   }
}
