package
{
   import mx.resources.ResourceBundle;
   
   public class fi_FI$core_properties extends ResourceBundle
   {
       
      
      public function fi_FI$core_properties()
      {
         super("fi_FI","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Tälle komponentille (komponentin määritys ja komponentin esiintymä) on määritetty useita visuaalisten alikomponenttien joukkoja.",
            "truncationIndicator":"...",
            "notExecuting":"Toistuvan toiminnon suorittaminen epäonnistui.",
            "remoteClassMemoryLeak":"varoitus: Luokkaa {0} on käytetty soitossa  kohteeseen net.registerClassAlias() kohdassa {2}. Tämä aiheuttaa, että {1} tulee vuotamaan. Ratkaise vuoto määrittämällä {0} ylätason sovellutuksessa.        ",
            "nullParameter":"Parametrin {0} pitää olla muu kuin null-arvo.",
            "versionAlreadyRead":"Yhteensopivuusversio on jo luettu.",
            "multipleChildSets_ClassAndSubclass":"Tälle komponentille (peruskomponentin määritys ja johdettu komponentin määritys) on määritetty useita visuaalisten alikomponenttien joukkoja.",
            "fontIncompatible":"varoitus: väärä upotettu kirjasin \'{0}\' määritetty kohteelle {1}. Komponentin vaatimusten mukaisesti upotetun kirjasimen määrittämiseen vaaditaan embedAsCff={2}.",
            "badParameter":"Parametrin {0} pitää olla jokin hyväksytyistä arvoista.",
            "notImplementedInFTETextField":"Kohdetta \'{0}\' ei ole toteutettu kentässä FTETextField.",
            "viewSource":"Näytä lähde",
            "unsupportedTypeInFTETextField":"FTETextField ei tue tyypin asettamista muotoon \"input\".",
            "badFile":"Tiedostoa ei ole.",
            "stateUndefined":"Määrittämätön tila {0}.",
            "badIndex":"Toimitettu indeksi on rajojen ulkopuolella.",
            "versionAlreadySet":"Yhteensopivuusversio on jo määritetty."
         };
         return _loc1_;
      }
   }
}
