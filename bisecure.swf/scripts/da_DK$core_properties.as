package
{
   import mx.resources.ResourceBundle;
   
   public class da_DK$core_properties extends ResourceBundle
   {
       
      
      public function da_DK$core_properties()
      {
         super("da_DK","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Der er angivet flere sæt visuelle underordnede for denne komponent (komponentdefinition og komponentforekomst).",
            "truncationIndicator":"...",
            "notExecuting":"Gentagelse udføres ikke.",
            "remoteClassMemoryLeak":"advarsel: Klassen {0} er blevet brugt i et kald til net.registerClassAlias() i {2}. Derved slipper {1} ud. Du kan løse problemet ved at definere {0} i programmet på øverste niveau.   ",
            "nullParameter":"Parameteren {0} må ikke være null.",
            "versionAlreadyRead":"Kompatibilitetsversionen er allerede læst.",
            "multipleChildSets_ClassAndSubclass":"Der er angivet flere sæt visuelle underordnede for denne komponent (definition af basiskomponent og udledt komponentforekomst).",
            "fontIncompatible":"advarsel: inkompatibel integreret skrifttype \'{0}\' angivet for {1}. Til denne komponent kræves det, at den integrerede skrifttype erklæres med embedAsCff={2}.",
            "badParameter":"Parameteren {0} skal være en af de accepterede værdier.",
            "notImplementedInFTETextField":"{0}\' er ikke implementeret i FTETextField.",
            "viewSource":"Vis kilde",
            "unsupportedTypeInFTETextField":"FTETextField understøtter ikke indstilling af typen til \"input\".",
            "badFile":"Filen findes ikke.",
            "stateUndefined":"Udefineret tilstand \'{0}\'.",
            "badIndex":"Det angivne indeks er uden for grænserne.",
            "versionAlreadySet":"Kompatibilitetsversionen er allerede indstillet."
         };
         return _loc1_;
      }
   }
}
