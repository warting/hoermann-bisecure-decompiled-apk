package
{
   import mx.resources.ResourceBundle;
   
   public class nb_NO$core_properties extends ResourceBundle
   {
       
      
      public function nb_NO$core_properties()
      {
         super("nb_NO","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Flere sett med visuelle underordnede er angitt for denne komponenten (komponentdefinisjon og komponentforekomst).",
            "truncationIndicator":"...",
            "notExecuting":"Repeater kjører ikke.",
            "remoteClassMemoryLeak":"advarsel: Klassen {0} er brukt i et kall til net.registerClassAlias() i {2}. Dette vil føre til at {1} lekker ut. Du løser lekkasjen ved å definere {0} i applikasjonen på toppnivå.   ",
            "nullParameter":"Parameteren {0} kan ikke være null.",
            "versionAlreadyRead":"Kompatibilitetsversjon er allerede lest.",
            "multipleChildSets_ClassAndSubclass":"Flere sett med visuelle underordnede er angitt for denne komponenten (basiskomponentdefinisjon og avledet komponentdefinisjon).",
            "fontIncompatible":"advarsel: Den ikke-kompatible, innebygde fonten {0} er angitt for {1}. Denne komponenten krever at den innebygde fonten deklareres med embedAsCff={2}.",
            "badParameter":"Parameteren {0} må være en av de godkjente verdiene.",
            "notImplementedInFTETextField":"{0} er ikke implementert i FTETextField.",
            "viewSource":"Vis kilde",
            "unsupportedTypeInFTETextField":"FTETextField støtter ikke at type angis som \"input\".",
            "badFile":"Filen finnes ikke.",
            "stateUndefined":"Udefinert tilstand {0}.",
            "badIndex":"Tilsendt indeks er utenfor område.",
            "versionAlreadySet":"Kompatibilitetsversjon er allerede angitt."
         };
         return _loc1_;
      }
   }
}
