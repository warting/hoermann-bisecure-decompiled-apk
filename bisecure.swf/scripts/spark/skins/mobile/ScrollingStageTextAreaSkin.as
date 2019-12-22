package spark.skins.mobile
{
   import spark.components.supportClasses.IStyleableEditableText;
   import spark.components.supportClasses.ScrollableStageText;
   
   public class ScrollingStageTextAreaSkin extends StageTextAreaSkin
   {
       
      
      public function ScrollingStageTextAreaSkin()
      {
         super();
      }
      
      override protected function createTextDisplay() : IStyleableEditableText
      {
         return new ScrollableStageText(multiline);
      }
   }
}
