package
{
   import mx.resources.ResourceBundle;
   
   public class fi_FI$textLayout_properties extends ResourceBundle
   {
       
      
      public function fi_FI$textLayout_properties()
      {
         super("fi_FI","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"Poistettavaa aliosaa ei löydy",
            "badReplaceChildrenIndex":"Alueen ulkopuolinen indeksi kohteelle FlowGroupElement.replaceChildren",
            "missingTextFlow":"Ei jäsennettävää TextFlow-kohdetta",
            "unexpectedNamespace":"Odottamaton nimitila {0}",
            "badMXMLChildrenArgument":"Virheellinen {0}-tyyppinen elementti välitetty kohteeseen mxmlChildren",
            "invalidReplaceTextPositions":"Virheellisiä sijainteja välitetty kohteeseen SpanElement.replaceText",
            "invalidSplitAtPosition":"Virheellinen parametri kohteelle splitAtPosition",
            "badSurrogatePairCopy":"Kopioidaan vain puolet korvaavasta parista kohteessa SpanElement.shallowCopy",
            "invalidChildType":"NewElement on tyypiltään väärä yläosaan nähden",
            "unknownAttribute":"Määritteen {0} käyttö ei ole sallittua elementissä {1}",
            "invalidSurrogatePairSplit":"Korvaavan parin virheellinen jako",
            "expectedExactlyOneTextLayoutFormat":"Vain yksi odotettu TextLayoutFormat kohteessa {0}\t",
            "invalidFlowElementConstruct":"Yritetään luoda virheellinen FlowElement-aliluokka",
            "malformedTag":"Väärin muodostettu tunniste {0}",
            "missingStringResource":"Ei merkkijonoa resurssille {0}",
            "invalidSplitAtIndex":"Virheellinen parametri kohteelle splitAtIndex",
            "illegalOperation":"Virheellinen yritys suorittaa operaatio {0}",
            "malformedMarkup":"Väärin muodostettu merkintä {0}",
            "unexpectedXMLElementInSpan":"Odottamaton elemetti {0} span-kohteessa",
            "badPropertyValue":"Ominaisuuden {0} arvo {1} ei ole alueella",
            "badShallowCopyRange":"Virheellinen alue kohteessa shallowCopy",
            "unknownElement":"Tuntematon elementti {0}"
         };
         return _loc1_;
      }
   }
}
