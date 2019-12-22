package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TextAreaVScrollBarSkin extends VScrollBarSkin
   {
       
      
      public function TextAreaVScrollBarSkin()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         thumbSkinClass = TextAreaVScrollBarThumbSkin;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               minWidth = 30;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_640DPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               minWidth = 22;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_480DPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               minWidth = 15;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_320DPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               minWidth = 11;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_240DPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               minWidth = 6;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_120DPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_120DPI;
               break;
            default:
               minWidth = 9;
               _loc1_ = TextAreaVScrollBarThumbSkin.PADDING_RIGHT_DEFAULTDPI;
               _loc2_ = TextAreaVScrollBarThumbSkin.PADDING_VERTICAL_DEFAULTDPI;
         }
         minThumbHeight = minWidth - _loc1_ + _loc2_ * 2;
      }
   }
}
