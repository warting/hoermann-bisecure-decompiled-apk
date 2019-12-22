package spark.skins.ios7.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.FocusEvent;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import spark.components.supportClasses.IStyleableEditableText;
   import spark.components.supportClasses.SkinnableTextBase;
   import spark.components.supportClasses.StyleableStageText;
   import spark.components.supportClasses.StyleableTextField;
   import spark.core.IDisplayText;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class StageTextSkinBase extends MobileSkin
   {
       
      
      protected var layoutBorderSize:uint;
      
      protected var roundheight:uint;
      
      protected var isFocused:Boolean = false;
      
      protected var border:DisplayObject;
      
      private var borderVisibleChanged:Boolean = false;
      
      protected var multiline:Boolean = false;
      
      public var textDisplay:IStyleableEditableText;
      
      private var _263438014promptDisplay:IDisplayText;
      
      public function StageTextSkinBase()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               measuredDefaultWidth = 1200;
               measuredDefaultHeight = 132;
               this.layoutBorderSize = 3;
               this.roundheight = 24;
               break;
            case DPIClassification.DPI_480:
               measuredDefaultWidth = 880;
               measuredDefaultHeight = 100;
               this.layoutBorderSize = 2;
               this.roundheight = 18;
               break;
            case DPIClassification.DPI_320:
               measuredDefaultWidth = 600;
               measuredDefaultHeight = 66;
               this.layoutBorderSize = 1.5;
               this.roundheight = 14;
               break;
            case DPIClassification.DPI_240:
               measuredDefaultWidth = 440;
               measuredDefaultHeight = 50;
               this.layoutBorderSize = 1;
               this.roundheight = 10;
               break;
            case DPIClassification.DPI_120:
               measuredDefaultWidth = 220;
               measuredDefaultHeight = 25;
               this.layoutBorderSize = 0.5;
               this.roundheight = 5;
               break;
            default:
               measuredDefaultWidth = 300;
               measuredDefaultHeight = 33;
               this.layoutBorderSize = 0.5;
               this.roundheight = 7;
         }
         addEventListener(FocusEvent.FOCUS_IN,this.focusChangeHandler);
         addEventListener(FocusEvent.FOCUS_OUT,this.focusChangeHandler);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.textDisplay)
         {
            this.textDisplay = this.createTextDisplay();
            this.textDisplay.editable = true;
            this.textDisplay.styleName = this;
            this.addChild(DisplayObject(this.textDisplay));
         }
      }
      
      protected function createTextDisplay() : IStyleableEditableText
      {
         return new StyleableStageText(this.multiline);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:uint = getStyle("contentBackgroundColor");
         var _loc4_:Number = getStyle("contentBackgroundAlpha");
         var _loc5_:uint = !!this.isFocused?uint(getStyle("focusColor")):uint(getStyle("borderColor"));
         var _loc6_:uint = this.layoutBorderSize * 2;
         if(isNaN(_loc4_))
         {
            _loc4_ = 1;
         }
         if(getStyle("contentBackgroundBorder") == "roundedrect")
         {
            graphics.lineStyle(this.layoutBorderSize,_loc5_,1,true);
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRoundRectComplex(this.layoutBorderSize,this.layoutBorderSize,param1 - _loc6_,param2 - _loc6_,this.roundheight,this.roundheight,this.roundheight,this.roundheight);
            graphics.endFill();
         }
         if(getStyle("contentBackgroundBorder") == "rectangle")
         {
            graphics.lineStyle(this.layoutBorderSize,_loc5_,1);
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(this.layoutBorderSize,this.layoutBorderSize,param1 - _loc6_,param2 - _loc6_);
            graphics.endFill();
         }
         else if(getStyle("contentBackgroundBorder") == "none")
         {
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,0,param1 - _loc6_,param2 - _loc6_);
            graphics.endFill();
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "borderVisible")
         {
            this.borderVisibleChanged = true;
            invalidateProperties();
         }
         if(_loc2_ || param1.indexOf("padding") == 0)
         {
            invalidateDisplayList();
         }
         super.styleChanged(param1);
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         alpha = currentState.indexOf("disabled") == -1?Number(1):Number(0.5);
         var _loc1_:* = currentState.indexOf("WithPrompt") != -1;
         if(_loc1_ && !this.promptDisplay)
         {
            this.promptDisplay = this.createPromptDisplay();
            this.promptDisplay.addEventListener(FocusEvent.FOCUS_IN,this.promptDisplay_focusInHandler);
         }
         else if(!_loc1_ && this.promptDisplay)
         {
            this.promptDisplay.removeEventListener(FocusEvent.FOCUS_IN,this.promptDisplay_focusInHandler);
            removeChild(this.promptDisplay as DisplayObject);
            this.promptDisplay = null;
         }
         super.commitCurrentState();
         invalidateDisplayList();
      }
      
      protected function createPromptDisplay() : IDisplayText
      {
         var _loc1_:StyleableTextField = StyleableTextField(createInFontContext(StyleableTextField));
         _loc1_.styleName = this;
         _loc1_.editable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.useTightTextBounds = false;
         addChild(_loc1_);
         return _loc1_;
      }
      
      protected function measureTextComponent(param1:SkinnableTextBase) : void
      {
         var _loc7_:int = 0;
         var _loc2_:Number = getStyle("paddingLeft");
         var _loc3_:Number = getStyle("paddingRight");
         var _loc4_:Number = getStyle("paddingTop");
         var _loc5_:Number = getStyle("paddingBottom");
         var _loc6_:Number = getStyle("fontSize");
         if(this.textDisplay)
         {
            _loc6_ = getElementPreferredHeight(this.textDisplay);
         }
         if(param1 && param1.maxChars)
         {
            _loc7_ = Math.max(1,_loc6_ - 2);
            measuredWidth = _loc7_ * param1.maxChars + _loc2_ + _loc3_;
         }
         measuredHeight = _loc4_ + _loc6_ + _loc5_;
      }
      
      private function focusChangeHandler(param1:FocusEvent) : void
      {
         this.isFocused = param1.type == FocusEvent.FOCUS_IN;
         invalidateDisplayList();
      }
      
      private function focusTextDisplay() : void
      {
         this.textDisplay.setFocus();
      }
      
      private function promptDisplay_focusInHandler(param1:FocusEvent) : void
      {
         callLater(this.focusTextDisplay);
      }
      
      [Bindable(event="propertyChange")]
      public function get promptDisplay() : IDisplayText
      {
         return this._263438014promptDisplay;
      }
      
      public function set promptDisplay(param1:IDisplayText) : void
      {
         var _loc2_:Object = this._263438014promptDisplay;
         if(_loc2_ !== param1)
         {
            this._263438014promptDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"promptDisplay",_loc2_,param1));
            }
         }
      }
   }
}
