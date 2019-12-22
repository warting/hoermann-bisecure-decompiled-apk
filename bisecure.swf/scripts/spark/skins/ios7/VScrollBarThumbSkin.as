package spark.skins.ios7
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.Button;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class VScrollBarThumbSkin extends MobileSkin
   {
      
      mx_internal static const PADDING_RIGHT_640DPI:int = 10;
      
      mx_internal static const PADDING_VERTICAL_640DPI:int = 8;
      
      mx_internal static const PADDING_RIGHT_480DPI:int = 8;
      
      mx_internal static const PADDING_VERTICAL_480DPI:int = 6;
      
      mx_internal static const PADDING_RIGHT_320DPI:int = 5;
      
      mx_internal static const PADDING_VERTICAL_320DPI:int = 4;
      
      mx_internal static const PADDING_RIGHT_240DPI:int = 4;
      
      mx_internal static const PADDING_VERTICAL_240DPI:int = 3;
      
      mx_internal static const PADDING_RIGHT_120DPI:int = 2;
      
      mx_internal static const PADDING_VERTICAL_120DPI:int = 1;
      
      mx_internal static const PADDING_RIGHT_DEFAULTDPI:int = 3;
      
      mx_internal static const PADDING_VERTICAL_DEFAULTDPI:int = 2;
       
      
      public var hostComponent:Button;
      
      protected var paddingRight:int;
      
      protected var paddingVertical:int;
      
      public function VScrollBarThumbSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               minWidth = 19;
               this.paddingRight = VScrollBarThumbSkin.PADDING_RIGHT_640DPI;
               this.paddingVertical = VScrollBarThumbSkin.PADDING_VERTICAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               minWidth = 19;
               this.paddingRight = VScrollBarThumbSkin.PADDING_RIGHT_480DPI;
               this.paddingVertical = VScrollBarThumbSkin.PADDING_VERTICAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               this.paddingRight = PADDING_RIGHT_320DPI;
               this.paddingVertical = PADDING_VERTICAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               this.paddingRight = PADDING_RIGHT_240DPI;
               this.paddingVertical = PADDING_VERTICAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               this.paddingRight = PADDING_RIGHT_120DPI;
               this.paddingVertical = PADDING_VERTICAL_120DPI;
               break;
            default:
               this.paddingRight = PADDING_RIGHT_DEFAULTDPI;
               this.paddingVertical = PADDING_VERTICAL_DEFAULTDPI;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:Number = param1 - this.paddingRight;
         var _loc4_:uint = getStyle("color");
         graphics.beginFill(_loc4_,1);
         graphics.drawRect(0.5,this.paddingVertical + 0.5,_loc3_,param2 - 2 * this.paddingVertical);
         graphics.endFill();
      }
   }
}
