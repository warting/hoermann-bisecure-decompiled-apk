package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.Button;
   import spark.components.VScrollBar;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class VScrollBarSkin extends MobileSkin
   {
       
      
      public var hostComponent:VScrollBar;
      
      protected var minThumbHeight:Number;
      
      protected var thumbSkinClass:Class;
      
      public var track:Button;
      
      public var thumb:Button;
      
      public function VScrollBarSkin()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         minHeight = 20;
         this.thumbSkinClass = VScrollBarThumbSkin;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               minWidth = 24;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_640DPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_640DPI;
               break;
            case DPIClassification.DPI_480:
               minWidth = 18;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_480DPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_480DPI;
               break;
            case DPIClassification.DPI_320:
               minWidth = 12;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_320DPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_320DPI;
               break;
            case DPIClassification.DPI_240:
               minWidth = 9;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_240DPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_240DPI;
               break;
            case DPIClassification.DPI_120:
               minWidth = 9;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_120DPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_120DPI;
               break;
            default:
               minWidth = 6;
               _loc1_ = VScrollBarThumbSkin.PADDING_RIGHT_DEFAULTDPI;
               _loc2_ = VScrollBarThumbSkin.PADDING_VERTICAL_DEFAULTDPI;
         }
         this.minThumbHeight = minWidth - _loc1_ + _loc2_ * 2;
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
            this.thumb.minHeight = this.minThumbHeight;
            this.thumb.setStyle("skinClass",this.thumbSkinClass);
            this.thumb.width = minWidth;
            this.thumb.height = minWidth;
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
