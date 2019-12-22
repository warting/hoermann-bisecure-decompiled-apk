package spark.skins.mobile
{
   import flash.display.DisplayObject;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.skins.mobile.supportClasses.MobileSkin;
   import spark.skins.mobile640.assets.BeveledBackButton_down;
   import spark.skins.mobile640.assets.BeveledBackButton_fill;
   import spark.skins.mobile640.assets.BeveledBackButton_up;
   
   use namespace mx_internal;
   
   public class BeveledBackButtonSkin extends ButtonSkin
   {
       
      
      private var _fill:DisplayObject;
      
      private var fillClass:Class;
      
      private var colorized:Boolean;
      
      public function BeveledBackButtonSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 64;
               layoutPaddingRight = 40;
               measuredDefaultWidth = 232;
               measuredDefaultHeight = 108;
               upBorderSkin = spark.skins.mobile640.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile640.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile640.assets.BeveledBackButton_fill;
               break;
            case DPIClassification.DPI_480:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 46;
               layoutPaddingRight = 30;
               measuredDefaultWidth = 174;
               measuredDefaultHeight = 84;
               upBorderSkin = spark.skins.mobile480.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile480.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile480.assets.BeveledBackButton_fill;
               break;
            case DPIClassification.DPI_320:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 32;
               layoutPaddingRight = 20;
               measuredDefaultWidth = 116;
               measuredDefaultHeight = 54;
               upBorderSkin = spark.skins.mobile320.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile320.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile320.assets.BeveledBackButton_fill;
               break;
            case DPIClassification.DPI_240:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 23;
               layoutPaddingRight = 15;
               measuredDefaultWidth = 87;
               measuredDefaultHeight = 42;
               upBorderSkin = spark.skins.mobile240.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile240.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile240.assets.BeveledBackButton_fill;
               break;
            case DPIClassification.DPI_120:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 14;
               layoutPaddingRight = 8;
               measuredDefaultWidth = 44;
               measuredDefaultHeight = 21;
               upBorderSkin = spark.skins.mobile120.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile120.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile120.assets.BeveledBackButton_fill;
               break;
            default:
               layoutBorderSize = 0;
               layoutPaddingTop = 0;
               layoutPaddingBottom = 0;
               layoutPaddingLeft = 16;
               layoutPaddingRight = 10;
               measuredDefaultWidth = 58;
               measuredDefaultHeight = 28;
               upBorderSkin = spark.skins.mobile160.assets.BeveledBackButton_up;
               downBorderSkin = spark.skins.mobile160.assets.BeveledBackButton_down;
               this.fillClass = spark.skins.mobile160.assets.BeveledBackButton_fill;
         }
         minHeight = measuredDefaultHeight;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         if(!this._fill && this.fillClass)
         {
            this._fill = new this.fillClass();
            addChildAt(this._fill,0);
         }
         if(this._fill)
         {
            if(getChildIndex(this._fill) > 0)
            {
               removeChild(this._fill);
               addChildAt(this._fill,0);
            }
            setElementSize(this._fill,param1,param2);
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getStyle(fillColorStyleName);
         if(this.colorized || _loc3_ != MobileSkin.MOBILE_THEME_DARK_COLOR)
         {
            applyColorTransform(this._fill,MobileSkin.MOBILE_THEME_DARK_COLOR,_loc3_);
            this.colorized = _loc3_ != MobileSkin.MOBILE_THEME_DARK_COLOR;
         }
      }
   }
}
