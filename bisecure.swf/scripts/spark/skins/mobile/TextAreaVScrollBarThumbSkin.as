package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TextAreaVScrollBarThumbSkin extends VScrollBarThumbSkin
   {
      
      mx_internal static const PADDING_RIGHT_640DPI:int = 16;
      
      mx_internal static const PADDING_VERTICAL_640DPI:int = 24;
      
      mx_internal static const PADDING_RIGHT_480DPI:int = 12;
      
      mx_internal static const PADDING_VERTICAL_480DPI:int = 18;
      
      mx_internal static const PADDING_RIGHT_320DPI:int = 8;
      
      mx_internal static const PADDING_VERTICAL_320DPI:int = 12;
      
      mx_internal static const PADDING_RIGHT_240DPI:int = 4;
      
      mx_internal static const PADDING_VERTICAL_240DPI:int = 6;
      
      mx_internal static const PADDING_RIGHT_120DPI:int = 2;
      
      mx_internal static const PADDING_VERTICAL_120DPI:int = 3;
      
      mx_internal static const PADDING_RIGHT_DEFAULTDPI:int = 4;
      
      mx_internal static const PADDING_VERTICAL_DEFAULTDPI:int = 6;
       
      
      public function TextAreaVScrollBarThumbSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               paddingRight = PADDING_RIGHT_640DPI;
               paddingVertical = PADDING_VERTICAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               paddingRight = PADDING_RIGHT_480DPI;
               paddingVertical = PADDING_VERTICAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               paddingRight = PADDING_RIGHT_320DPI;
               paddingVertical = PADDING_VERTICAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               paddingRight = PADDING_RIGHT_240DPI;
               paddingVertical = PADDING_VERTICAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               paddingRight = PADDING_RIGHT_120DPI;
               paddingVertical = PADDING_VERTICAL_120DPI;
               break;
            default:
               paddingRight = PADDING_RIGHT_DEFAULTDPI;
               paddingVertical = PADDING_VERTICAL_DEFAULTDPI;
         }
      }
   }
}
