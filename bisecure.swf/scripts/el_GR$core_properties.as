package
{
   import mx.resources.ResourceBundle;
   
   public class el_GR$core_properties extends ResourceBundle
   {
       
      
      public function el_GR$core_properties()
      {
         super("el_GR","core");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "multipleChildSets_ClassAndInstance":"Multiple sets of visual children have been specified for this component (component definition and component instance).",
            "truncationIndicator":"...",
            "notExecuting":"Repeater is not executing.",
            "remoteClassMemoryLeak":"warning: Η κλάση {0}έχει χρησιμοποιηθεί στην κλήση του  net.registerClassAlias() στο {2}. Αυτό ενδέχεται να δημιουργήσει στο {1} διαρροές μνήμης. Για να διορθώσετε την διαρροή ορίστε την κλάση {0} στο αρχικό επίπεδο της εφαρμογής(top-level application).   ",
            "nullParameter":"Παράμετρος{0} πρέπει να μην είναι κενή (null).",
            "versionAlreadyRead":"Συμβατή έκδοση έχει ήδη διαβάσει.",
            "multipleChildSets_ClassAndSubclass":"Multiple sets of visual children have been specified for this component (base component definition and derived component definition).",
            "fontIncompatible":"Προσοχή: Ασύμβατη ενσωμάτωση γραμματοσειράς \'{0}\' που καθορίστηκε για  {1}. Αυτό το component απαιτεί ότι η ενσωματωμένη γραμματοσειρά θα δηλωθεί ως embedAsCFF={2}.",
            "badParameter":"Παράμετρος {0} πρέπει να είναι στις επιτρεπτές τιμές.",
            "notImplementedInFTETextField":"\'{0}\' δεν έχει υλοποιηθεί στο FTETextField.",
            "viewSource":"προβολή πηγαίου κώδικα",
            "unsupportedTypeInFTETextField":"FTETextField δεν υποστηρίζει ρυθμίσεις του τύπου  \"input\".",
            "badFile":"Το αρχείο δεν υπάρχει.",
            "stateUndefined":"Απροσδιόριστος κατάσταση\'{0}\'.",
            "badIndex":"Ο δείκτης που δόθηκε είναι  είναι εκτός ορίων. ",
            "versionAlreadySet":"Συμβατή έκδοση έχει ήδη καθοριστεί."
         };
         return _loc1_;
      }
   }
}
