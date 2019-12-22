package
{
   import mx.resources.ResourceBundle;
   
   public class nl_NL$core_properties extends ResourceBundle
   {
       
      
      public function nl_NL$core_properties()
      {
         super("nl_NL","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Meerdere sets visuele onderliggende elementen zijn opgegeven voor deze component (componentdefinitie en componentinstantie).",
            "truncationIndicator":"...",
            "notExecuting":"Repeater wordt niet uitgevoerd.",
            "remoteClassMemoryLeak":"waarschuwing: De klasse {0} is gebruikt bij een aanroep van net.registerClassAlias() in {2}. Hierdoor zal {1} uitlekken. Definieer {0} in de toepassing op het hoogste niveau om het lek te repareren.   ",
            "nullParameter":"Parameter {0} moet niet-null zijn.",
            "versionAlreadyRead":"Compatibiliteitsversie is al gelezen.",
            "multipleChildSets_ClassAndSubclass":"Meerdere sets visuele onderliggende elementen zijn opgegeven voor deze component (basiscomponentdefinitie en afgeleide componentdefinitie).",
            "fontIncompatible":"waarschuwing: incompatibel ingesloten font \'{0}\' opgegeven voor {1}. Deze component vereist dat het ingesloten font gedeclareerd wordt met embedAsCff={2}.",
            "badParameter":"Parameter {0} moet een van de geaccepteerde waarden zijn.",
            "notImplementedInFTETextField":"{0}\' is niet geïmplementeerd in FTETextField.",
            "viewSource":"Bron weergeven",
            "unsupportedTypeInFTETextField":"FTETextField biedt geen ondersteuning om het type op \"input\" in te stellen.",
            "badFile":"Bestand bestaat niet.",
            "stateUndefined":"Ongedefinieerde status \'{0}\'.",
            "badIndex":"De opgegeven index valt buiten bereik.",
            "versionAlreadySet":"Compatibiliteitsversie is al ingesteld."
         };
         return _loc1_;
      }
   }
}
