package spark.skins.mobile
{
   import spark.components.TextInput;
   import spark.components.supportClasses.StyleableTextField;
   import spark.skins.mobile.supportClasses.StageTextSkinBase;
   
   public class StageTextInputSkin extends StageTextSkinBase
   {
       
      
      public var hostComponent:TextInput;
      
      public function StageTextInputSkin()
      {
         super();
         multiline = false;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingRight");
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = getStyle("paddingBottom");
         var _loc7_:Number = Math.max(0,param1 - _loc3_ - _loc4_);
         var _loc8_:Number = Math.max(0,param2 - _loc5_ - _loc6_);
         var _loc9_:Number = getElementPreferredHeight(textDisplay);
         var _loc10_:Number = Math.round(0.5 * (_loc8_ - _loc9_)) + _loc5_;
         if(textDisplay)
         {
            textDisplay.commitStyles();
            setElementSize(textDisplay,_loc7_,_loc8_);
            setElementPosition(textDisplay,_loc3_,_loc10_);
         }
         if(promptDisplay)
         {
            if(promptDisplay is StyleableTextField)
            {
               StyleableTextField(promptDisplay).commitStyles();
            }
            _loc11_ = getElementPreferredHeight(promptDisplay);
            _loc12_ = Math.round(0.5 * (_loc8_ - _loc11_)) + _loc5_;
            setElementSize(promptDisplay,_loc7_,_loc11_);
            setElementPosition(promptDisplay,_loc3_,_loc12_);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measureTextComponent(this.hostComponent);
      }
   }
}
