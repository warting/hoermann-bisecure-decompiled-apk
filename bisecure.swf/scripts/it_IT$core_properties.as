package
{
   import mx.resources.ResourceBundle;
   
   public class it_IT$core_properties extends ResourceBundle
   {
       
      
      public function it_IT$core_properties()
      {
         super("it_IT","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Per questo componente sono già stati specificati più insiemi di elementi visivi secondari, cioè la definizione e l’istanza del componente.",
            "truncationIndicator":"...",
            "notExecuting":"Repeater non è in esecuzione.",
            "remoteClassMemoryLeak":"avvertimento: la classe {0} è stata utilizzata in una chiamata a net.registerClassAlias() in {2}. Ciò causerà la perdita di {1}. Per risolvere il problema, definire {0} nell\'applicazione di livello superiore.   ",
            "nullParameter":"Il parametro {0} deve essere non null.",
            "versionAlreadyRead":"La versione di compatibilità è già stata letta.",
            "multipleChildSets_ClassAndSubclass":"Per questo componente sono già stati specificati più insiemi di elementi visivi secondari, cioè la definizione del componente di base e quella del componente derivato.",
            "fontIncompatible":"Avviso: carattere incorporato \'\'{0}\'\' non compatibile specificato per {1}. Questo componente richiede che il carattere incorporato venga dichiarato con embedAsCff={2}.",
            "badParameter":"Per il parametro {0} è necessario utilizzare uno dei valori accettati.",
            "notImplementedInFTETextField":"{0}\' non è implementato in FTETextField.",
            "viewSource":"Visualizza origine",
            "unsupportedTypeInFTETextField":"L\'impostazione sul tipo \"input\" non è supportata per FTETextField.",
            "badFile":"File inesistente.",
            "stateUndefined":"Stato \'{0}\' non definito.",
            "badIndex":"L’indice specificato non rientra nell’intervallo.",
            "versionAlreadySet":"La versione di compatibilità è già stata impostata."
         };
         return _loc1_;
      }
   }
}
