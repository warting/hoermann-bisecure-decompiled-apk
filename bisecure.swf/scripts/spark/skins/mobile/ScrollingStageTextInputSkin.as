package spark.skins.mobile
{
   import spark.components.supportClasses.IStyleableEditableText;
   import spark.components.supportClasses.ScrollableStageText;
   
   public class ScrollingStageTextInputSkin extends StageTextInputSkin
   {
       
      
      public function ScrollingStageTextInputSkin()
      {
         super();
      }
      
      override protected function createTextDisplay() : IStyleableEditableText
      {
         return new ScrollableStageText(multiline);
      }
   }
}
