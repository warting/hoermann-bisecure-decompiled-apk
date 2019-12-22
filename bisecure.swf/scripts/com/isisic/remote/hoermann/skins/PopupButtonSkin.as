package com.isisic.remote.hoermann.skins
{
   import flash.display.Sprite;
   import spark.skins.mobile.ButtonSkin;
   
   public class PopupButtonSkin extends ButtonSkin
   {
       
      
      public function PopupButtonSkin()
      {
         super();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getStyle("backgroundColor");
         if(this.currentState == "down")
         {
            _loc3_ = getStyle("downColor");
         }
         else if(this.currentState == "disabled")
         {
            _loc3_ = getStyle("backgroundColor");
         }
         this.graphics.beginFill(_loc3_,getStyle("backgroundAlpha"));
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         return Sprite;
      }
   }
}
