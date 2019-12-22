package com.isisic.remote.hoermann.skins
{
   import spark.skins.mobile.ScrollingStageTextInputSkin;
   
   public class TextInputSkin extends ScrollingStageTextInputSkin
   {
      
      private static const TRIANGLE_SIZE:Number = 0.5;
       
      
      public function TextInputSkin()
      {
         super();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         this.graphics.lineStyle(1,getStyle("backgroundColor"),getStyle("backgroundAlpha"));
         this.graphics.moveTo(0,param2);
         this.graphics.lineTo(param1,param2);
         this.graphics.lineStyle();
         this.graphics.beginFill(this.getStyle("backgroundColor"),getStyle("backgroundAlpha"));
         this.graphics.moveTo(param1 - param2 * TRIANGLE_SIZE,param2);
         this.graphics.lineTo(param1,param2 * TRIANGLE_SIZE);
         this.graphics.lineTo(param1,param2);
         this.graphics.lineTo(param1 - param2 * TRIANGLE_SIZE,param2);
         this.graphics.endFill();
      }
   }
}
