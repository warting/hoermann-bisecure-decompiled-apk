package
{
   import mx.resources.ResourceBundle;
   
   public class fi_FI$sparkEffects_properties extends ResourceBundle
   {
       
      
      public function fi_FI$sparkEffects_properties()
      {
         super("fi_FI","sparkEffects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "cannotOperateOn":"AnimateShaderTransition toimii vain IUIComponent- ja GraphicElement-esiintymissä.",
            "accDecWithinRange":"(kiihdytyksen + hidastuksen) täytyy olla alueella [0,1].",
            "propNotPropOrStyle":"Ominaisuus {0} ei ole ominaisuus eikä tyyli objektissa {1}: {2}.",
            "cannotCalculateValue":"Interpolaattori ei voi laskea interpoloituja arvoja, jos startValue ({0}) tai endValue ({1}) ei ole numero.",
            "illegalPropValue":"Virheellinen ominaisuusarvo: {0}.",
            "arraysNotOfEqualLength":"Aloitus- ja lopetussarjojen täytyy olla yhtä pitkiä.",
            "endValContainsNonNums":"Kohde endValue sisältää muita kuin numeroita: mukautettu interpolaattori täytyy lähettää animaatioon.",
            "startValContainsNonNums":"Kohde startValue sisältää muita kuin numeroita: interpolaattori täytyy lähettää animaatioon."
         };
         return _loc1_;
      }
   }
}
