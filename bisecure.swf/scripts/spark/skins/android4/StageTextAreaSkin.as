package spark.skins.android4
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.TextArea;
   import spark.components.supportClasses.IStyleableEditableText;
   import spark.components.supportClasses.ScrollableStageText;
   import spark.components.supportClasses.StyleableTextField;
   import spark.skins.android4.supportClasses.StageTextSkinBase;
   
   use namespace mx_internal;
   
   public class StageTextAreaSkin extends StageTextSkinBase
   {
      
      mx_internal static var iOSVerticalPaddingAdjustment:Number = 5;
       
      
      public var hostComponent:TextArea;
      
      public function StageTextAreaSkin()
      {
         super();
         multiline = true;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               measuredDefaultHeight = 212;
               break;
            case DPIClassification.DPI_480:
               measuredDefaultHeight = 140;
               break;
            case DPIClassification.DPI_320:
               measuredDefaultHeight = 106;
               break;
            case DPIClassification.DPI_240:
               measuredDefaultHeight = 70;
               break;
            case DPIClassification.DPI_120:
               measuredDefaultHeight = 35;
               break;
            default:
               measuredDefaultHeight = 48;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measureTextComponent(this.hostComponent);
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingRight");
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = getStyle("paddingBottom");
         var _loc7_:Number = Math.max(0,param1 - _loc3_ - _loc4_);
         var _loc8_:Number = Math.max(0,param2 - _loc5_ - _loc6_);
         if(textDisplay)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            textDisplay.commitStyles();
            setElementSize(textDisplay,_loc7_,_loc8_ + _loc10_);
            setElementPosition(textDisplay,_loc3_,_loc5_ - _loc9_);
         }
         if(promptDisplay)
         {
            if(promptDisplay is StyleableTextField)
            {
               StyleableTextField(promptDisplay).commitStyles();
            }
            setElementSize(promptDisplay,_loc7_,_loc8_);
            setElementPosition(promptDisplay,_loc3_,_loc5_);
         }
      }
      
      override protected function createTextDisplay() : IStyleableEditableText
      {
         return new ScrollableStageText(multiline);
      }
   }
}
