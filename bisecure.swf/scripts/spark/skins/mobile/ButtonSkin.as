package spark.skins.mobile
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.utils.ColorUtil;
   import spark.components.supportClasses.StyleableTextField;
   import spark.skins.mobile.supportClasses.ButtonSkinBase;
   import spark.skins.mobile640.assets.Button_down;
   import spark.skins.mobile640.assets.Button_up;
   
   use namespace mx_internal;
   
   public class ButtonSkin extends ButtonSkinBase
   {
      
      mx_internal static const CHROME_COLOR_RATIOS:Array = [0,127.5];
      
      mx_internal static const CHROME_COLOR_ALPHAS:Array = [1,1];
       
      
      protected var layoutCornerEllipseSize:uint;
      
      private var _border:DisplayObject;
      
      private var changeFXGSkin:Boolean = false;
      
      private var borderClass:Class;
      
      mx_internal var fillColorStyleName:String = "chromeColor";
      
      public var labelDisplayShadow:StyleableTextField;
      
      protected var upBorderSkin:Class;
      
      protected var downBorderSkin:Class;
      
      public function ButtonSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.upBorderSkin = spark.skins.mobile640.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile640.assets.Button_down;
               layoutGap = 20;
               this.layoutCornerEllipseSize = 28;
               layoutPaddingLeft = 40;
               layoutPaddingRight = 40;
               layoutPaddingTop = 40;
               layoutPaddingBottom = 40;
               layoutBorderSize = 2;
               measuredDefaultWidth = 128;
               measuredDefaultHeight = 172;
               break;
            case DPIClassification.DPI_480:
               this.upBorderSkin = spark.skins.mobile480.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile480.assets.Button_down;
               layoutGap = 14;
               this.layoutCornerEllipseSize = 20;
               layoutPaddingLeft = 30;
               layoutPaddingRight = 30;
               layoutPaddingTop = 30;
               layoutPaddingBottom = 30;
               layoutBorderSize = 2;
               measuredDefaultWidth = 96;
               measuredDefaultHeight = 130;
               break;
            case DPIClassification.DPI_320:
               this.upBorderSkin = spark.skins.mobile320.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile320.assets.Button_down;
               layoutGap = 10;
               this.layoutCornerEllipseSize = 10;
               layoutPaddingLeft = 20;
               layoutPaddingRight = 20;
               layoutPaddingTop = 20;
               layoutPaddingBottom = 20;
               layoutBorderSize = 2;
               measuredDefaultWidth = 64;
               measuredDefaultHeight = 86;
               break;
            case DPIClassification.DPI_240:
               this.upBorderSkin = spark.skins.mobile240.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile240.assets.Button_down;
               layoutGap = 7;
               this.layoutCornerEllipseSize = 8;
               layoutPaddingLeft = 15;
               layoutPaddingRight = 15;
               layoutPaddingTop = 15;
               layoutPaddingBottom = 15;
               layoutBorderSize = 1;
               measuredDefaultWidth = 48;
               measuredDefaultHeight = 65;
               break;
            case DPIClassification.DPI_120:
               this.upBorderSkin = spark.skins.mobile120.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile120.assets.Button_down;
               layoutGap = 4;
               this.layoutCornerEllipseSize = 8;
               layoutPaddingLeft = 8;
               layoutPaddingRight = 8;
               layoutPaddingTop = 8;
               layoutPaddingBottom = 8;
               layoutBorderSize = 1;
               measuredDefaultWidth = 24;
               measuredDefaultHeight = 33;
               break;
            default:
               this.upBorderSkin = spark.skins.mobile160.assets.Button_up;
               this.downBorderSkin = spark.skins.mobile160.assets.Button_down;
               layoutGap = 5;
               this.layoutCornerEllipseSize = 10;
               layoutPaddingLeft = 10;
               layoutPaddingRight = 10;
               layoutPaddingTop = 10;
               layoutPaddingBottom = 10;
               layoutBorderSize = 1;
               measuredDefaultWidth = 32;
               measuredDefaultHeight = 43;
         }
      }
      
      protected function get border() : DisplayObject
      {
         return this._border;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.labelDisplayShadow && labelDisplay)
         {
            this.labelDisplayShadow = StyleableTextField(createInFontContext(StyleableTextField));
            this.labelDisplayShadow.styleName = this;
            this.labelDisplayShadow.colorName = "textShadowColor";
            this.labelDisplayShadow.useTightTextBounds = false;
            addChildAt(this.labelDisplayShadow,getChildIndex(labelDisplay));
         }
         setStyle("textAlign","center");
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         this.borderClass = this.getBorderClassForCurrentState();
         if(!(this._border is this.borderClass))
         {
            this.changeFXGSkin = true;
         }
         invalidateDisplayList();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         if(this.changeFXGSkin)
         {
            this.changeFXGSkin = false;
            if(this._border)
            {
               removeChild(this._border);
               this._border = null;
            }
            if(this.borderClass)
            {
               this._border = new this.borderClass();
               addChildAt(this._border,0);
            }
         }
         this.layoutBorder(param1,param2);
         this.labelDisplayShadow.alpha = getStyle("textShadowAlpha");
         this.labelDisplayShadow.commitStyles();
         setElementPosition(this.labelDisplayShadow,labelDisplay.x,labelDisplay.y + 1);
         setElementSize(this.labelDisplayShadow,labelDisplay.width,labelDisplay.height);
         if(labelDisplay.isTruncated)
         {
            this.labelDisplayShadow.text = labelDisplay.text;
         }
      }
      
      mx_internal function layoutBorder(param1:Number, param2:Number) : void
      {
         setElementSize(this.border,param1,param2);
         setElementPosition(this.border,0,0);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc4_:Array = null;
         super.drawBackground(param1,param2);
         var _loc3_:uint = getStyle(this.fillColorStyleName);
         if(currentState == "down")
         {
            graphics.beginFill(_loc3_);
         }
         else
         {
            _loc4_ = [];
            colorMatrix.createGradientBox(param1,param2,Math.PI / 2,0,0);
            _loc4_[0] = ColorUtil.adjustBrightness2(_loc3_,70);
            _loc4_[1] = _loc3_;
            graphics.beginGradientFill(GradientType.LINEAR,_loc4_,CHROME_COLOR_ALPHAS,CHROME_COLOR_RATIOS,colorMatrix);
         }
         graphics.drawRoundRect(layoutBorderSize,layoutBorderSize,param1 - layoutBorderSize * 2,param2 - layoutBorderSize * 2,this.layoutCornerEllipseSize,this.layoutCornerEllipseSize);
         graphics.endFill();
      }
      
      protected function getBorderClassForCurrentState() : Class
      {
         if(currentState == "down")
         {
            return this.downBorderSkin;
         }
         return this.upBorderSkin;
      }
      
      override protected function labelDisplay_valueCommitHandler(param1:FlexEvent) : void
      {
         super.labelDisplay_valueCommitHandler(param1);
         this.labelDisplayShadow.text = labelDisplay.text;
      }
   }
}
