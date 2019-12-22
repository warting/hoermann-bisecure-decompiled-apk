package
{
   import mx.resources.ResourceBundle;
   
   public class it_IT$effects_properties extends ResourceBundle
   {
       
      
      public function it_IT$effects_properties()
      {
         super("it_IT","effects");
      }
      
      override protected function getContent() : Object
      {
         var _loc1_:Object = {
            "incorrectTrigger":"Non è possibile attivare l’effetto zoom con un attivatore moveEffect.",
            "incorrectSource":"È necessario che la proprietà Source sia una classe o una stringa."
         };
         return _loc1_;
      }
   }
}
