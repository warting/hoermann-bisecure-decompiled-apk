package
{
   import mx.resources.ResourceBundle;
   
   public class fr_FR$textLayout_properties extends ResourceBundle
   {
       
      
      public function fr_FR$textLayout_properties()
      {
         super("fr_FR","textLayout");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "badRemoveChild":"L\'enfant à supprimer n\'a pas été trouvé.",
            "badReplaceChildrenIndex":"L\'index vers FlowGroupElement.replaceChildren est en dehors de la plage.",
            "missingTextFlow":"Aucun TextFlow à analyser",
            "unexpectedNamespace":"Espace de noms inattendu {0}",
            "badMXMLChildrenArgument":"L\'élément du type {0} passé à mxmlChildren n\'est pas correct.",
            "invalidReplaceTextPositions":"Les positions passées à SpanElement.replaceText ne sont pas valides.",
            "invalidSplitAtPosition":"Le paramètre passé à splitAtPosition n\'est pas valide.",
            "badSurrogatePairCopy":"Copie de la moitié uniquement d\'une paire de substitution dans SpanElement.shallowCopy",
            "invalidChildType":"Le type de NewElement ne lui permet pas d\'en être le parent.",
            "unknownAttribute":"L\'attribut {0} n\'est pas autorisé dans l\'élément {1}.",
            "invalidSurrogatePairSplit":"Fractionnement non valide d\'une paire de substitution",
            "expectedExactlyOneTextLayoutFormat":"Un et un seul TextLayoutFormat attendu dans {0}\t",
            "invalidFlowElementConstruct":"Tentative de construction d\'une sous-classe FlowElement non valide",
            "malformedTag":"Balise {0} mal formée",
            "missingStringResource":"Aucune chaîne pour la ressource {0}",
            "invalidSplitAtIndex":"Le paramètre passé à splitAtIndex n\'est pas valide.",
            "illegalOperation":"Tentative interdite d\'exécuter l\'opération {0}",
            "malformedMarkup":"Balisage {0} mal formé",
            "unexpectedXMLElementInSpan":"Elément inattendu {0} dans un bloc",
            "badPropertyValue":"La propriété {0} valeur {1} est en dehors de la plage.",
            "badShallowCopyRange":"Plage incorrecte dans shallowCopy",
            "unknownElement":"Elément inconnu {0}"
         };
         return _loc1_;
      }
   }
}
