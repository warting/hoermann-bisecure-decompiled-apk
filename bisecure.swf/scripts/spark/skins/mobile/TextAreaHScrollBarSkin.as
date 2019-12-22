package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TextAreaHScrollBarSkin extends HScrollBarSkin
   {
       
      
      public function TextAreaHScrollBarSkin()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         thumbSkinClass = TextAreaHScrollBarThumbSkin;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               minHeight = 30;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_320DPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_320DPI;
               break;
            case DPIClassification.DPI_480:
               minHeight = 22;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_480DPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               minHeight = 15;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_320DPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               minHeight = 11;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_240DPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               minHeight = 11;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_120DPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_120DPI;
               break;
            default:
               minHeight = 9;
               _loc1_ = TextAreaHScrollBarThumbSkin.PADDING_BOTTOM_DEFAULTDPI;
               _loc2_ = TextAreaHScrollBarThumbSkin.PADDING_HORIZONTAL_DEFAULTDPI;
         }
         minThumbWidth = minHeight - _loc1_ + _loc2_ * 2;
      }
   }
}
