package
{
   import mx.resources.ResourceBundle;
   
   public class fr_FR$core_properties extends ResourceBundle
   {
       
      
      public function fr_FR$core_properties()
      {
         super("fr_FR","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Plusieurs jeux d\'enfants visuels ont été spécifiés pour ce composant (définition et instance du composant).",
            "truncationIndicator":"...",
            "notExecuting":"Le répéteur ne s\'exécute pas.",
            "remoteClassMemoryLeak":"Avertissement : La classe {0} a été utilisée dans un appel de net.registerClassAlias() dans {2}. Ceci va entraîner la fuite de {1}. Pour éviter la fuite, définissez {0} dans l’application de niveau supérieur.   ",
            "nullParameter":"Le paramètre {0} ne peut pas être nul.",
            "versionAlreadyRead":"La version de compatibilité a déjà été identifiée.",
            "multipleChildSets_ClassAndSubclass":"Plusieurs jeux d\'enfants visuels ont été spécifiés pour ce composant (définition des composants de base et dérivé).",
            "fontIncompatible":"avertissement : la police incorporée \'{0}\' spécifiée pour {1} n\'est pas compatible. Ce composant requiert que la police incorporée soit déclarée avec embedAsCff={2}.",
            "badParameter":"Le paramètre {0} doit contenir une valeur acceptée.",
            "notImplementedInFTETextField":"{0}\' n\'est pas implémenté dans FTETextField.",
            "viewSource":"Afficher la source",
            "unsupportedTypeInFTETextField":"FTETextField ne prend pas en charge la définition du type sur \"input\".",
            "badFile":"Le fichier n\'existe pas.",
            "stateUndefined":"Etat {0} non défini.",
            "badIndex":"L\'index fourni est hors limites.",
            "versionAlreadySet":"La version de compatibilité a déjà été définie."
         };
         return _loc1_;
      }
   }
}
