package com.isisic.remote.hoermann.skins
{
   import spark.skins.mobile.TransparentActionButtonSkin;
   
   public class ColorableActionButtonSkin extends TransparentActionButtonSkin
   {
       
      
      public function ColorableActionButtonSkin()
      {
         super();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getStyle("chromeColor");
         var _loc4_:Number = getStyle("chromeAlpha");
         graphics.beginFill(_loc3_,_loc4_);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
