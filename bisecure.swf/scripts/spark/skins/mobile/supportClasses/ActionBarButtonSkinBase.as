package spark.skins.mobile.supportClasses
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.skins.mobile.ButtonSkin;
   
   use namespace mx_internal;
   
   public class ActionBarButtonSkinBase extends ButtonSkin
   {
      
      private static var matrix:Matrix = new Matrix();
       
      
      public function ActionBarButtonSkinBase()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutBorderSize = 2;
               layoutPaddingTop = 24;
               layoutPaddingBottom = 20;
               layoutPaddingLeft = 40;
               layoutPaddingRight = 40;
               measuredDefaultWidth = 212;
               measuredDefaultHeight = 172;
               break;
            case DPIClassification.DPI_480:
               layoutBorderSize = 1;
               layoutPaddingTop = 18;
               layoutPaddingBottom = 16;
               layoutPaddingLeft = 32;
               layoutPaddingRight = 32;
               measuredDefaultWidth = 162;
               measuredDefaultHeight = 130;
               break;
            case DPIClassification.DPI_320:
               layoutBorderSize = 1;
               layoutPaddingTop = 12;
               layoutPaddingBottom = 10;
               layoutPaddingLeft = 20;
               layoutPaddingRight = 20;
               measuredDefaultWidth = 106;
               measuredDefaultHeight = 86;
               break;
            case DPIClassification.DPI_240:
               layoutBorderSize = 1;
               layoutPaddingTop = 9;
               layoutPaddingBottom = 8;
               layoutPaddingLeft = 16;
               layoutPaddingRight = 16;
               measuredDefaultWidth = 81;
               measuredDefaultHeight = 65;
               break;
            case DPIClassification.DPI_120:
               layoutBorderSize = 1;
               layoutPaddingTop = 4;
               layoutPaddingBottom = 4;
               layoutPaddingLeft = 8;
               layoutPaddingRight = 8;
               measuredDefaultWidth = 40;
               measuredDefaultHeight = 33;
               break;
            default:
               layoutBorderSize = 1;
               layoutPaddingTop = 6;
               layoutPaddingBottom = 5;
               layoutPaddingLeft = 10;
               layoutPaddingRight = 10;
               measuredDefaultWidth = 53;
               measuredDefaultHeight = 43;
         }
      }
      
      override protected function commitDisabled() : void
      {
         var _loc1_:Number = !!hostComponent.enabled?Number(1):Number(0.5);
         labelDisplay.alpha = _loc1_;
         labelDisplayShadow.alpha = _loc1_;
         var _loc2_:DisplayObject = getIconDisplay();
         if(_loc2_ != null)
         {
            _loc2_.alpha = _loc1_;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:* = currentState == "down";
         var _loc4_:uint = !!_loc3_?uint(getStyle(fillColorStyleName)):uint(0);
         var _loc5_:Number = !!_loc3_?Number(1):Number(0);
         graphics.beginFill(_loc4_,_loc5_);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
