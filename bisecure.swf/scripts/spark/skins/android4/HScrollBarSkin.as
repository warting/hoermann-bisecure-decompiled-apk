package spark.skins.android4
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.Button;
   import spark.components.HScrollBar;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class HScrollBarSkin extends MobileSkin
   {
       
      
      public var hostComponent:HScrollBar;
      
      protected var minThumbWidth:Number;
      
      protected var thumbSkinClass:Class;
      
      public var track:Button;
      
      public var thumb:Button;
      
      public function HScrollBarSkin()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         minWidth = 20;
         this.thumbSkinClass = HScrollBarThumbSkin;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               minHeight = 24;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_640DPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               minHeight = 18;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_480DPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               minHeight = 12;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_320DPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               minHeight = 9;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_240DPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               minHeight = 5;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_120DPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_120DPI;
               break;
            default:
               minHeight = 6;
               _loc1_ = HScrollBarThumbSkin.PADDING_BOTTOM_DEFAULTDPI;
               _loc2_ = HScrollBarThumbSkin.PADDING_HORIZONTAL_DEFAULTDPI;
         }
         this.minThumbWidth = minHeight - _loc1_ + _loc2_ * 2;
      }
      
      override protected function createChildren() : void
      {
         if(!this.track)
         {
            this.track = new Button();
            this.track.setStyle("skinClass",MobileSkin);
            this.track.width = minWidth;
            this.track.height = minHeight;
            addChild(this.track);
         }
         if(!this.thumb)
         {
            this.thumb = new Button();
            this.thumb.minWidth = this.minThumbWidth;
            this.thumb.setStyle("skinClass",this.thumbSkinClass);
            this.thumb.width = minHeight;
            this.thumb.height = minHeight;
            addChild(this.thumb);
         }
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         setElementSize(this.track,param1,param2);
      }
   }
}
