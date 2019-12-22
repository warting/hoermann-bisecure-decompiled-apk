package
{
   import mx.resources.ResourceBundle;
   
   public class sv_SE$core_properties extends ResourceBundle
   {
       
      
      public function sv_SE$core_properties()
      {
         super("sv_SE","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Flera uppsättningar visuella underordnade har specificerats för denna komponent (komponentdefinition och komponentinstans).",
            "truncationIndicator":"...",
            "notExecuting":"Repeterare körs inte.",
            "remoteClassMemoryLeak":"varning: Klassen {0} har använts vid ett samtal till net.registerClassAlias() i {2}. Det innebär att {1} kommer att läcka. Du kan korrigera det här genom att definiera {0} i programmet på översta nivån.   ",
            "nullParameter":"Parametern {0} får inte vara null.",
            "versionAlreadyRead":"Kompatibilitetsversionen har redan lästs.",
            "multipleChildSets_ClassAndSubclass":"Flera uppsättningar visuella underordnade har specificerats för denna komponent (baskomponentdefinition och härledd komponentdefinition).",
            "fontIncompatible":"varning: inkompatibelt inbäddat teckensnitt ({0}) har angetts för {1}. Komponenten kräver att det inbäddade teckensnittet deklareras med embedAsCff={2}.",
            "badParameter":"Parametern {0} måste vara inom de godkända intervallet.",
            "notImplementedInFTETextField":"\"{0}\" är inte implementerat i FTETextField.",
            "viewSource":"Visa källa",
            "unsupportedTypeInFTETextField":"FTETextField saknar stöd för inställningstyp till \"input\".",
            "badFile":"Filen finns inte.",
            "stateUndefined":"Odefinierat tillstånd \'{0}\'.",
            "badIndex":"Det angivna indexet är utanför intervallet.",
            "versionAlreadySet":"Kompatibilitetsversionen har redan angetts."
         };
         return _loc1_;
      }
   }
}
