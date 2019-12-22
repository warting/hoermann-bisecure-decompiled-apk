package spark.skins.android4
{
   import flash.display.DisplayObject;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import spark.components.supportClasses.StyleableTextField;
   import spark.skins.android4.assets.Button_down;
   import spark.skins.android4.assets.Button_up;
   import spark.skins.mobile.supportClasses.ButtonSkinBase;
   
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
         this.upBorderSkin = Button_up;
         this.downBorderSkin = Button_down;
         this.layoutCornerEllipseSize = 0;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutGap = 20;
               layoutPaddingLeft = 40;
               layoutPaddingRight = 40;
               layoutPaddingTop = 40;
               layoutPaddingBottom = 40;
               layoutBorderSize = 2;
               measuredDefaultWidth = 128;
               measuredDefaultHeight = 172;
               break;
            case DPIClassification.DPI_480:
               layoutGap = 14;
               layoutPaddingLeft = 30;
               layoutPaddingRight = 30;
               layoutPaddingTop = 30;
               layoutPaddingBottom = 30;
               layoutBorderSize = 2;
               measuredDefaultWidth = 96;
               measuredDefaultHeight = 130;
               break;
            case DPIClassification.DPI_320:
               layoutGap = 10;
               layoutPaddingLeft = 20;
               layoutPaddingRight = 20;
               layoutPaddingTop = 20;
               layoutPaddingBottom = 20;
               layoutBorderSize = 2;
               measuredDefaultWidth = 64;
               measuredDefaultHeight = 86;
               break;
            case DPIClassification.DPI_240:
               layoutGap = 7;
               layoutPaddingLeft = 15;
               layoutPaddingRight = 15;
               layoutPaddingTop = 15;
               layoutPaddingBottom = 15;
               layoutBorderSize = 1;
               measuredDefaultWidth = 48;
               measuredDefaultHeight = 65;
               break;
            case DPIClassification.DPI_120:
               layoutGap = 4;
               layoutPaddingLeft = 8;
               layoutPaddingRight = 8;
               layoutPaddingTop = 8;
               layoutPaddingBottom = 8;
               layoutBorderSize = 1;
               measuredDefaultWidth = 24;
               measuredDefaultHeight = 33;
               break;
            default:
               layoutGap = 5;
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
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:uint = getStyle(this.fillColorStyleName);
         applyColorTransform(this.border,16777215,_loc3_);
      }
      
      mx_internal function layoutBorder(param1:Number, param2:Number) : void
      {
         setElementSize(this.border,param1,param2);
         setElementPosition(this.border,0,0);
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
