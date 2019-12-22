package spark.skins.mobile
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.Button;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class HScrollBarThumbSkin extends MobileSkin
   {
      
      mx_internal static const PADDING_BOTTOM_640DPI:int = 10;
      
      mx_internal static const PADDING_HORIZONTAL_640DPI:int = 8;
      
      mx_internal static const PADDING_BOTTOM_480DPI:int = 8;
      
      mx_internal static const PADDING_HORIZONTAL_480DPI:int = 6;
      
      mx_internal static const PADDING_BOTTOM_320DPI:int = 5;
      
      mx_internal static const PADDING_HORIZONTAL_320DPI:int = 4;
      
      mx_internal static const PADDING_BOTTOM_240DPI:int = 4;
      
      mx_internal static const PADDING_HORIZONTAL_240DPI:int = 3;
      
      mx_internal static const PADDING_BOTTOM_120DPI:int = 2;
      
      mx_internal static const PADDING_HORIZONTAL_120DPI:int = 2;
      
      mx_internal static const PADDING_BOTTOM_DEFAULTDPI:int = 3;
      
      mx_internal static const PADDING_HORIZONTAL_DEFAULTDPI:int = 2;
       
      
      public var hostComponent:Button;
      
      protected var paddingBottom:int;
      
      protected var paddingHorizontal:int;
      
      public function HScrollBarThumbSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_480:
               this.paddingBottom = PADDING_BOTTOM_480DPI;
               this.paddingHorizontal = PADDING_HORIZONTAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               this.paddingBottom = PADDING_BOTTOM_320DPI;
               this.paddingHorizontal = PADDING_HORIZONTAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               this.paddingBottom = PADDING_BOTTOM_240DPI;
               this.paddingHorizontal = PADDING_HORIZONTAL_240DPI;
               break;
            default:
               this.paddingBottom = PADDING_BOTTOM_DEFAULTDPI;
               this.paddingHorizontal = PADDING_HORIZONTAL_DEFAULTDPI;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:Number = param2 - this.paddingBottom;
         graphics.beginFill(getStyle("chromeColor"),1);
         graphics.lineStyle(1,0,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND);
         graphics.drawRoundRect(this.paddingHorizontal + 0.5,0.5,param1 - 2 * this.paddingHorizontal,_loc3_,_loc3_,_loc3_);
         graphics.endFill();
      }
   }
}
