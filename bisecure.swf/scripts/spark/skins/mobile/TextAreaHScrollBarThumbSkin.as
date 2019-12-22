package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TextAreaHScrollBarThumbSkin extends HScrollBarThumbSkin
   {
      
      mx_internal static const PADDING_BOTTOM_640DPI:int = 16;
      
      mx_internal static const PADDING_HORIZONTAL_640DPI:int = 16;
      
      mx_internal static const PADDING_BOTTOM_480DPI:int = 12;
      
      mx_internal static const PADDING_HORIZONTAL_480DPI:int = 12;
      
      mx_internal static const PADDING_BOTTOM_320DPI:int = 8;
      
      mx_internal static const PADDING_HORIZONTAL_320DPI:int = 12;
      
      mx_internal static const PADDING_BOTTOM_240DPI:int = 6;
      
      mx_internal static const PADDING_HORIZONTAL_240DPI:int = 6;
      
      mx_internal static const PADDING_BOTTOM_120DPI:int = 3;
      
      mx_internal static const PADDING_HORIZONTAL_120DPI:int = 3;
      
      mx_internal static const PADDING_BOTTOM_DEFAULTDPI:int = 4;
      
      mx_internal static const PADDING_HORIZONTAL_DEFAULTDPI:int = 6;
       
      
      public function TextAreaHScrollBarThumbSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               paddingBottom = PADDING_BOTTOM_640DPI;
               paddingHorizontal = PADDING_HORIZONTAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               paddingBottom = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_480DPI;
               paddingHorizontal = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               paddingBottom = PADDING_BOTTOM_320DPI;
               paddingHorizontal = PADDING_HORIZONTAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               paddingBottom = PADDING_BOTTOM_240DPI;
               paddingHorizontal = PADDING_HORIZONTAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               paddingBottom = PADDING_BOTTOM_120DPI;
               paddingHorizontal = PADDING_HORIZONTAL_120DPI;
               break;
            default:
               paddingBottom = PADDING_BOTTOM_DEFAULTDPI;
               paddingHorizontal = PADDING_HORIZONTAL_DEFAULTDPI;
         }
      }
   }
}
