package com.isisic.remote.hoermann.skins
{
   import com.isisic.remote.hoermann.components.ValueButton;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import org.osmf.layout.ScaleMode;
   import spark.components.Image;
   import spark.skins.mobile.ButtonSkin;
   
   public class GateButtonSkin extends ButtonSkin
   {
       
      
      public function GateButtonSkin()
      {
         super();
         layoutPaddingTop = 2;
         layoutPaddingBottom = 2;
         layoutPaddingLeft = 2;
         layoutPaddingRight = 2;
         switch(MultiDevice.screenSize)
         {
            case ScreenSizes.XXLARGE:
               layoutGap = 20;
               layoutCornerEllipseSize = 28;
               layoutBorderSize = 2;
               measuredDefaultWidth = 128;
               measuredDefaultHeight = 172;
               break;
            case ScreenSizes.XLARGE:
               layoutGap = 14;
               layoutCornerEllipseSize = 20;
               layoutBorderSize = 2;
               measuredDefaultWidth = 96;
               measuredDefaultHeight = 130;
               break;
            case ScreenSizes.LARGE:
               layoutGap = 14;
               layoutCornerEllipseSize = 20;
               layoutBorderSize = 2;
               measuredDefaultWidth = 96;
               measuredDefaultHeight = 115;
               break;
            case ScreenSizes.NORMAL:
               layoutGap = 14;
               layoutCornerEllipseSize = 20;
               layoutBorderSize = 2;
               measuredDefaultWidth = 96;
               measuredDefaultHeight = 100;
               break;
            case ScreenSizes.SMALL:
            default:
               layoutGap = 10;
               layoutCornerEllipseSize = 10;
               layoutBorderSize = 2;
               measuredDefaultWidth = 64;
               measuredDefaultHeight = 86;
         }
      }
      
      override protected function setIcon(param1:Object) : void
      {
         var _loc2_:Image = new Image();
         _loc2_.source = param1;
         _loc2_.scaleMode = ScaleMode.LETTERBOX;
         _loc2_.percentHeight = 100;
         super.setIcon(_loc2_);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc8_:uint = 0;
         var _loc3_:* = this.getStyle("borderColor");
         var _loc4_:Array = this.getStyle("backgroundColors");
         var _loc5_:Array = this.getStyle("backgroundAlphas");
         var _loc6_:Array = this.getStyle("backgroundRatios");
         if(this.isDown())
         {
            _loc4_ = this.getStyle("downColors");
            _loc5_ = this.getStyle("downAlphas");
            _loc6_ = this.getStyle("downRatios");
         }
         if(!_loc4_)
         {
            _loc4_ = [16711935,16777215];
         }
         if(!_loc5_)
         {
            _loc5_ = [1,1];
         }
         if(!_loc6_)
         {
            _loc6_ = [0,255];
         }
         if(_loc3_ !== undefined)
         {
            _loc8_ = getStyle("borderSize") !== undefined?uint(getStyle("borderSize")):uint(2);
            graphics.lineStyle(_loc8_,_loc3_);
         }
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(param1,param2,Math.PI / 2,0,0);
         graphics.beginGradientFill(GradientType.LINEAR,_loc4_,_loc5_,_loc6_,_loc7_);
         graphics.drawRoundRect(0,0,param1,param2,30);
         graphics.endFill();
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         return Sprite;
      }
      
      private function isDown() : Boolean
      {
         return this.currentState == "down" || this.hostComponent is ValueButton && (this.hostComponent as ValueButton).showDown;
      }
   }
}
