package spark.skins.mobile.supportClasses
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
   import spark.skins.mobile640.assets.TextInput_border;
   
   use namespace mx_internal;
   
   public class StageTextSkinBase extends MobileSkin
   {
       
      
      protected var borderClass:Class;
      
      protected var layoutCornerEllipseSize:uint;
      
      protected var layoutBorderSize:uint;
      
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
               this.borderClass = spark.skins.mobile640.assets.TextInput_border;
               this.layoutCornerEllipseSize = 48;
               measuredDefaultWidth = 1200;
               measuredDefaultHeight = 132;
               this.layoutBorderSize = 3;
               break;
            case DPIClassification.DPI_480:
               this.borderClass = spark.skins.mobile480.assets.TextInput_border;
               this.layoutCornerEllipseSize = 32;
               measuredDefaultWidth = 880;
               measuredDefaultHeight = 100;
               this.layoutBorderSize = 2;
               break;
            case DPIClassification.DPI_320:
               this.borderClass = spark.skins.mobile320.assets.TextInput_border;
               this.layoutCornerEllipseSize = 24;
               measuredDefaultWidth = 600;
               measuredDefaultHeight = 66;
               this.layoutBorderSize = 2;
               break;
            case DPIClassification.DPI_240:
               this.borderClass = spark.skins.mobile240.assets.TextInput_border;
               this.layoutCornerEllipseSize = 12;
               measuredDefaultWidth = 440;
               measuredDefaultHeight = 50;
               this.layoutBorderSize = 1;
               break;
            case DPIClassification.DPI_120:
               this.borderClass = spark.skins.mobile120.assets.TextInput_border;
               this.layoutCornerEllipseSize = 6;
               measuredDefaultWidth = 220;
               measuredDefaultHeight = 25;
               this.layoutBorderSize = 1;
               break;
            default:
               this.borderClass = spark.skins.mobile160.assets.TextInput_border;
               this.layoutCornerEllipseSize = 12;
               measuredDefaultWidth = 300;
               measuredDefaultHeight = 33;
               this.layoutBorderSize = 1;
         }
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
         if(!this.border)
         {
            this.border = new this.borderClass();
            addChild(this.border);
         }
      }
      
      protected function createTextDisplay() : IStyleableEditableText
      {
         return new StyleableStageText(this.multiline);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         super.commitProperties();
         if(this.borderVisibleChanged)
         {
            this.borderVisibleChanged = false;
            _loc1_ = getStyle("borderVisible");
            if(_loc1_ && !this.border)
            {
               this.border = new this.borderClass();
               addChild(this.border);
            }
            else if(!_loc1_ && this.border)
            {
               removeChild(this.border);
               this.border = null;
            }
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:uint = !!this.border?uint(this.layoutBorderSize):uint(0);
         var _loc4_:uint = _loc3_ * 2;
         var _loc5_:uint = getStyle("contentBackgroundColor");
         var _loc6_:Number = getStyle("contentBackgroundAlpha");
         if(isNaN(_loc6_))
         {
            _loc6_ = 1;
         }
         graphics.beginFill(_loc5_,_loc6_);
         graphics.drawRoundRect(_loc3_,_loc3_,param1 - _loc4_,param2 - _loc4_,this.layoutCornerEllipseSize,this.layoutCornerEllipseSize);
         graphics.endFill();
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
         invalidateDisplayList();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         if(this.border)
         {
            setElementSize(this.border,param1,param2);
            setElementPosition(this.border,0,0);
         }
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
