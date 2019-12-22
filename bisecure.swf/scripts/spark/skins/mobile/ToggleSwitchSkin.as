package spark.skins.mobile
{
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.utils.ColorUtil;
   import spark.components.ToggleSwitch;
   import spark.core.SpriteVisualElement;
   import spark.skins.mobile.supportClasses.MobileSkin;
   import spark.skins.mobile640.assets.ToggleSwitch_contentShadow;
   
   use namespace mx_internal;
   
   public class ToggleSwitchSkin extends MobileSkin
   {
       
      
      protected var layoutThumbWidth:Number;
      
      protected var layoutThumbHeight:Number;
      
      protected var layoutCornerEllipseSize:Number;
      
      protected var layoutStrokeWeight:Number;
      
      protected var layoutBorderSize:Number;
      
      protected var layoutInnerPadding:Number;
      
      protected var layoutOuterPadding:Number;
      
      protected var layoutTextShadowOffset:Number;
      
      public var selectedLabelDisplay:LabelDisplayComponent#813;
      
      public var unselectedLabelDisplay:LabelDisplayComponent#813;
      
      private var slidingContentBackground:SpriteVisualElement;
      
      private var slidingContentForeground:UIComponent;
      
      private var slidingContentOverlayClass:Class;
      
      private var slidingContentOverlay:DisplayObject;
      
      private var contents:UIComponent;
      
      private var thumbEraseOverlay:Sprite;
      
      private var thumbContent:Sprite;
      
      public var thumb:IVisualElement;
      
      public var track:IVisualElement;
      
      private var _hostComponent:ToggleSwitch;
      
      private var _selectedLabel:String;
      
      private var _unselectedLabel:String;
      
      public function ToggleSwitchSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.layoutThumbWidth = 94;
               this.layoutThumbHeight = 56;
               this.layoutStrokeWeight = 2;
               this.layoutBorderSize = 2;
               this.layoutTextShadowOffset = -2;
               this.layoutInnerPadding = 14;
               this.layoutOuterPadding = 22;
               this.slidingContentOverlayClass = spark.skins.mobile640.assets.ToggleSwitch_contentShadow;
               break;
            case DPIClassification.DPI_480:
               this.layoutThumbWidth = 140;
               this.layoutThumbHeight = 84;
               this.layoutStrokeWeight = 2;
               this.layoutBorderSize = 2;
               this.layoutTextShadowOffset = -2;
               this.layoutInnerPadding = 20;
               this.layoutOuterPadding = 34;
               this.slidingContentOverlayClass = spark.skins.mobile480.assets.ToggleSwitch_contentShadow;
               break;
            case DPIClassification.DPI_320:
               this.layoutThumbWidth = 94;
               this.layoutThumbHeight = 56;
               this.layoutStrokeWeight = 2;
               this.layoutBorderSize = 2;
               this.layoutTextShadowOffset = -2;
               this.layoutInnerPadding = 14;
               this.layoutOuterPadding = 22;
               this.slidingContentOverlayClass = spark.skins.mobile320.assets.ToggleSwitch_contentShadow;
               break;
            case DPIClassification.DPI_240:
               this.layoutThumbWidth = 70;
               this.layoutThumbHeight = 42;
               this.layoutStrokeWeight = 2;
               this.layoutBorderSize = 1;
               this.layoutTextShadowOffset = -1;
               this.layoutInnerPadding = 10;
               this.layoutOuterPadding = 17;
               this.slidingContentOverlayClass = spark.skins.mobile240.assets.ToggleSwitch_contentShadow;
               break;
            case DPIClassification.DPI_120:
               this.layoutThumbWidth = 35;
               this.layoutThumbHeight = 21;
               this.layoutStrokeWeight = 1;
               this.layoutBorderSize = 1;
               this.layoutTextShadowOffset = -1;
               this.layoutInnerPadding = 5;
               this.layoutOuterPadding = 8;
               this.slidingContentOverlayClass = spark.skins.mobile120.assets.ToggleSwitch_contentShadow;
               break;
            default:
               this.layoutThumbWidth = 47;
               this.layoutThumbHeight = 28;
               this.layoutStrokeWeight = 1;
               this.layoutBorderSize = 1;
               this.layoutTextShadowOffset = -1;
               this.layoutInnerPadding = 7;
               this.layoutOuterPadding = 11;
               this.slidingContentOverlayClass = spark.skins.mobile160.assets.ToggleSwitch_contentShadow;
         }
         this.layoutCornerEllipseSize = this.layoutThumbHeight;
         this.selectedLabel = resourceManager.getString("components","toggleSwitchSelectedLabel");
         this.unselectedLabel = resourceManager.getString("components","toggleSwitchUnselectedLabel");
      }
      
      override public function set currentState(param1:String) : void
      {
         var _loc2_:Boolean = currentState && currentState.indexOf("down") >= 0;
         super.currentState = param1;
         if(_loc2_ != currentState.indexOf("down") >= 0)
         {
            invalidateDisplayList();
         }
      }
      
      public function get hostComponent() : ToggleSwitch
      {
         return this._hostComponent;
      }
      
      public function set hostComponent(param1:ToggleSwitch) : void
      {
         if(this._hostComponent)
         {
            this._hostComponent.removeEventListener("thumbPositionChanged",this.thumbPositionChanged_handler);
         }
         this._hostComponent = param1;
         if(this._hostComponent)
         {
            this._hostComponent.addEventListener("thumbPositionChanged",this.thumbPositionChanged_handler);
         }
      }
      
      protected function get selectedLabel() : String
      {
         return this._selectedLabel;
      }
      
      protected function set selectedLabel(param1:String) : void
      {
         this._selectedLabel = param1;
      }
      
      protected function get unselectedLabel() : String
      {
         return this._unselectedLabel;
      }
      
      protected function set unselectedLabel(param1:String) : void
      {
         this._unselectedLabel = param1;
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:Number = Math.max(param1 - 2 * this.layoutBorderSize,getElementPreferredWidth(this.thumb));
         var _loc4_:Number = Math.max(param2 - 2 * this.layoutBorderSize,getElementPreferredHeight(this.thumb));
         this.drawSlidingContent(_loc3_,_loc4_);
         this.drawTrack(_loc3_,_loc4_);
         this.drawThumb(_loc3_,_loc4_);
         this.drawMask(_loc3_,_loc4_);
         graphics.beginFill(16777215,0.3);
         graphics.drawRoundRect(0,(_loc4_ - this.layoutThumbHeight) / 2,_loc3_ + 2 * this.layoutBorderSize,this.layoutThumbHeight + 2 * this.layoutBorderSize,this.layoutCornerEllipseSize + this.layoutBorderSize);
         graphics.endFill();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         var _loc3_:Number = Math.max(param1 - 2 * this.layoutBorderSize,getElementPreferredWidth(this.thumb));
         var _loc4_:Number = Math.max(param2 - 2 * this.layoutBorderSize,getElementPreferredHeight(this.thumb));
         setElementSize(this.contents,_loc3_,this.layoutThumbHeight);
         setElementPosition(this.contents,this.layoutBorderSize,this.layoutBorderSize + (_loc4_ - this.layoutThumbHeight) / 2);
         this.layoutTrack(_loc3_,this.layoutThumbHeight);
         this.layoutThumb(_loc3_,this.layoutThumbHeight);
         this.layoutSlidingContent(_loc3_,this.layoutThumbHeight);
         this.layoutMask(_loc3_,this.layoutThumbHeight);
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = this.layoutThumbWidth + 2 * this.layoutBorderSize;
         measuredMinHeight = this.layoutThumbWidth + 2 * this.layoutBorderSize;
         var _loc1_:Number = Math.max(getElementPreferredWidth(this.selectedLabelDisplay),getElementPreferredWidth(this.unselectedLabelDisplay));
         measuredWidth = this.layoutThumbWidth + _loc1_ + this.layoutInnerPadding + this.layoutOuterPadding + 2 * this.layoutBorderSize;
         measuredHeight = this.layoutThumbHeight + 2 * this.layoutBorderSize;
      }
      
      override protected function commitCurrentState() : void
      {
         if(currentState && currentState.indexOf("disabled") >= 0)
         {
            alpha = 0.5;
            this.selectedLabelDisplay.showShadow(false);
            this.unselectedLabelDisplay.showShadow(false);
         }
         else
         {
            alpha = 1;
            this.selectedLabelDisplay.showShadow(true);
            this.unselectedLabelDisplay.showShadow(true);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.contents = new UIComponent();
         this.contents.blendMode = BlendMode.LAYER;
         addChild(this.contents);
         this.slidingContentBackground = new SpriteVisualElement();
         this.contents.addChild(this.slidingContentBackground);
         this.slidingContentOverlay = new this.slidingContentOverlayClass();
         this.contents.addChild(this.slidingContentOverlay);
         this.slidingContentForeground = new UIComponent();
         this.contents.addChild(this.slidingContentForeground);
         this.selectedLabelDisplay = new LabelDisplayComponent#813();
         this.selectedLabelDisplay.id = "selectedLabelDisplay";
         this.selectedLabelDisplay.text = this.selectedLabel;
         this.selectedLabelDisplay.shadowYOffset = this.layoutTextShadowOffset;
         this.slidingContentForeground.addChild(this.selectedLabelDisplay);
         this.unselectedLabelDisplay = new LabelDisplayComponent#813();
         this.unselectedLabelDisplay.id = "unselectedLabelDisplay";
         this.unselectedLabelDisplay.text = this.unselectedLabel;
         this.unselectedLabelDisplay.shadowYOffset = this.layoutTextShadowOffset;
         this.slidingContentForeground.addChild(this.unselectedLabelDisplay);
         this.track = new SpriteVisualElement();
         this.contents.addChild(SpriteVisualElement(this.track));
         this.thumb = new SpriteVisualElement();
         this.contents.addChild(SpriteVisualElement(this.thumb));
         this.thumbEraseOverlay = new Sprite();
         this.thumbEraseOverlay.blendMode = BlendMode.ERASE;
         SpriteVisualElement(this.thumb).addChild(this.thumbEraseOverlay);
         this.thumbContent = new Sprite();
         SpriteVisualElement(this.thumb).addChild(this.thumbContent);
         var _loc1_:Sprite = new SpriteVisualElement();
         this.contents.mask = _loc1_;
         this.contents.addChild(_loc1_);
      }
      
      private function drawSlidingContent(param1:Number, param2:Number) : void
      {
         this.slidingContentBackground.graphics.clear();
         this.slidingContentBackground.graphics.beginFill(getStyle("accentColor"));
         this.slidingContentBackground.graphics.drawRect(this.layoutThumbWidth - param1,0,param1 - this.layoutThumbWidth / 2,this.layoutThumbHeight);
         this.slidingContentBackground.graphics.endFill();
         this.slidingContentBackground.graphics.beginFill(ColorUtil.adjustBrightness2(getStyle("chromeColor"),-25));
         this.slidingContentBackground.graphics.drawRect(this.layoutThumbWidth / 2,0,param1 - this.layoutThumbWidth / 2,this.layoutThumbHeight);
         this.slidingContentBackground.graphics.endFill();
      }
      
      private function layoutSlidingContent(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param1 - this.layoutThumbWidth;
         var _loc4_:Number = _loc3_ - this.layoutInnerPadding - this.layoutOuterPadding;
         setElementSize(this.selectedLabelDisplay,_loc4_,this.layoutThumbHeight);
         setElementPosition(this.selectedLabelDisplay,-_loc3_ + this.layoutOuterPadding,0);
         setElementSize(this.unselectedLabelDisplay,_loc4_,this.layoutThumbHeight);
         setElementPosition(this.unselectedLabelDisplay,this.layoutThumbWidth + this.layoutInnerPadding,0);
         setElementSize(this.slidingContentOverlay,param1,this.layoutThumbHeight);
         setElementPosition(this.slidingContentOverlay,0,(param2 - this.layoutThumbHeight) / 2);
         this.moveSlidingContent();
      }
      
      private function drawTrack(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = SpriteVisualElement(this.track).graphics;
         _loc3_.clear();
         _loc3_.lineStyle(this.layoutStrokeWeight,0,0.3);
         _loc3_.drawRoundRect(this.layoutStrokeWeight / 2,this.layoutStrokeWeight / 2,param1 - this.layoutStrokeWeight,this.layoutThumbHeight - this.layoutStrokeWeight,this.layoutCornerEllipseSize - this.layoutStrokeWeight / 2);
         _loc3_.lineStyle();
      }
      
      private function layoutTrack(param1:Number, param2:Number) : void
      {
         setElementSize(this.track,param1,this.layoutThumbHeight);
         setElementPosition(this.track,0,(param2 - this.layoutThumbHeight) / 2);
      }
      
      private function drawThumb(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = this.thumbContent.graphics;
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Number = getStyle("chromeColor");
         if(currentState && currentState.indexOf("down") >= 0)
         {
            _loc7_ = ColorUtil.adjustBrightness(_loc7_,-60);
         }
         _loc3_.clear();
         _loc4_[0] = ColorUtil.adjustBrightness2(_loc7_,-70);
         _loc4_[1] = ColorUtil.adjustBrightness2(_loc7_,-55);
         _loc5_[0] = 1;
         _loc5_[1] = 1;
         _loc6_[0] = 0;
         _loc6_[1] = 255;
         colorMatrix.createGradientBox(this.layoutThumbWidth,this.layoutThumbHeight,Math.PI / 2);
         _loc3_.beginGradientFill(GradientType.LINEAR,_loc4_,_loc5_,_loc6_,colorMatrix);
         _loc3_.drawRoundRect(0,0,this.layoutThumbWidth,this.layoutThumbHeight,this.layoutCornerEllipseSize);
         _loc3_.endFill();
         _loc4_[0] = ColorUtil.adjustBrightness2(_loc7_,-30);
         _loc4_[1] = _loc7_;
         _loc4_[2] = ColorUtil.adjustBrightness2(_loc7_,20);
         _loc5_[2] = 1;
         _loc6_[0] = 0;
         _loc6_[1] = 0.7 * 255;
         _loc6_[2] = 255;
         colorMatrix.createGradientBox(this.layoutThumbWidth - this.layoutStrokeWeight * 2,this.layoutThumbHeight - this.layoutStrokeWeight * 2,Math.PI / 2);
         _loc3_.beginGradientFill(GradientType.LINEAR,_loc4_,_loc5_,_loc6_,colorMatrix);
         _loc3_.drawRoundRect(this.layoutStrokeWeight,this.layoutStrokeWeight,this.layoutThumbWidth - this.layoutStrokeWeight * 2,this.layoutThumbHeight - this.layoutStrokeWeight * 2,this.layoutCornerEllipseSize - this.layoutStrokeWeight * 2);
         _loc3_.endFill();
         _loc4_[0] = 16777215;
         _loc4_[1] = 16777215;
         _loc4_[2] = 0;
         _loc5_[0] = 0.9;
         _loc5_[1] = 0;
         _loc5_[2] = 0.2;
         _loc6_[0] = 0.33 * 255;
         _loc6_[1] = 0.5 * 255;
         _loc6_[2] = 255;
         colorMatrix.createGradientBox(this.layoutThumbWidth - this.layoutStrokeWeight * 3,this.layoutThumbHeight - this.layoutStrokeWeight * 3,Math.PI / 2);
         _loc3_.lineStyle(this.layoutStrokeWeight);
         _loc3_.lineGradientStyle(GradientType.LINEAR,_loc4_,_loc5_,_loc6_,colorMatrix);
         _loc3_.drawRoundRect(this.layoutStrokeWeight * 1.5,this.layoutStrokeWeight * 1.5,this.layoutThumbWidth - this.layoutStrokeWeight * 3,this.layoutThumbHeight - this.layoutStrokeWeight * 3,this.layoutCornerEllipseSize - this.layoutStrokeWeight * 3);
         _loc3_.lineStyle();
         this.thumbEraseOverlay.graphics.clear();
         this.thumbEraseOverlay.graphics.beginFill(0);
         this.thumbEraseOverlay.graphics.drawRoundRect(0,0,this.layoutThumbWidth,this.layoutThumbHeight,this.layoutCornerEllipseSize);
         this.thumbEraseOverlay.graphics.endFill();
      }
      
      private function layoutThumb(param1:Number, param2:Number) : void
      {
         setElementSize(this.thumb,this.layoutThumbWidth,this.layoutThumbHeight);
      }
      
      private function drawMask(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = SpriteVisualElement(this.contents.mask).graphics;
         _loc3_.clear();
         _loc3_.beginFill(0);
         _loc3_.drawRoundRect(0,0,param1,this.layoutThumbHeight,this.layoutCornerEllipseSize);
         _loc3_.endFill();
      }
      
      private function layoutMask(param1:Number, param2:Number) : void
      {
         setElementSize(this.contents.mask,param1,this.layoutThumbHeight);
         setElementPosition(this.contents.mask,0,(param2 - this.layoutThumbHeight) / 2);
      }
      
      private function moveSlidingContent() : void
      {
         if(!this.hostComponent)
         {
            return;
         }
         var _loc1_:Number = (this.track.getLayoutBoundsWidth() - this.thumb.getLayoutBoundsWidth()) * this.hostComponent.thumbPosition + this.track.getLayoutBoundsX();
         var _loc2_:Number = this.thumb.getLayoutBoundsY();
         setElementPosition(this.slidingContentBackground,_loc1_,_loc2_);
         setElementPosition(this.slidingContentForeground,_loc1_,_loc2_);
      }
      
      private function thumbPositionChanged_handler(param1:Event) : void
      {
         this.moveSlidingContent();
      }
   }
}

import flash.events.Event;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;

use namespace mx_internal;

class LabelDisplayComponent#813 extends UIComponent implements IDisplayText
{
    
   
   public var shadowYOffset:Number = 0;
   
   private var labelChanged:Boolean = false;
   
   private var labelDisplay:StyleableTextField;
   
   private var labelDisplayShadow:StyleableTextField;
   
   private var _text:String;
   
   function LabelDisplayComponent#813()
   {
      super();
      this._text = "";
   }
   
   override public function get baselinePosition() : Number
   {
      return this.labelDisplay.baselinePosition;
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      this.labelDisplay = StyleableTextField(createInFontContext(StyleableTextField));
      this.labelDisplay.styleName = this;
      this.labelDisplay.editable = false;
      this.labelDisplay.selectable = false;
      this.labelDisplay.multiline = false;
      this.labelDisplay.wordWrap = false;
      this.labelDisplay.addEventListener(FlexEvent.VALUE_COMMIT,this.labelDisplay_valueCommitHandler);
      this.labelDisplayShadow = StyleableTextField(createInFontContext(StyleableTextField));
      this.labelDisplayShadow.styleName = this;
      this.labelDisplayShadow.colorName = "textShadowColor";
      this.labelDisplayShadow.editable = false;
      this.labelDisplayShadow.selectable = false;
      this.labelDisplayShadow.multiline = false;
      this.labelDisplayShadow.wordWrap = false;
      addChild(this.labelDisplayShadow);
      addChild(this.labelDisplay);
   }
   
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if(this.labelChanged)
      {
         this.labelDisplay.text = this.text;
         invalidateSize();
         invalidateDisplayList();
         this.labelChanged = false;
      }
   }
   
   override protected function measure() : void
   {
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplay.text = this.text;
      }
      this.labelDisplay.commitStyles();
      measuredWidth = this.labelDisplay.getPreferredBoundsWidth();
      measuredHeight = this.labelDisplay.getPreferredBoundsHeight();
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplay.text = this.text;
      }
      this.labelDisplay.commitStyles();
      var _loc3_:Number = this.labelDisplay.getPreferredBoundsHeight();
      var _loc4_:Number = (param2 - _loc3_) / 2;
      var _loc5_:Number = Math.min(param1,this.labelDisplay.getPreferredBoundsWidth());
      var _loc6_:Number = (param1 - _loc5_) / 2;
      this.labelDisplay.setLayoutBoundsSize(_loc5_,_loc3_);
      this.labelDisplay.setLayoutBoundsPosition(_loc6_,_loc4_);
      this.labelDisplay.truncateToFit();
      this.labelDisplayShadow.commitStyles();
      this.labelDisplayShadow.setLayoutBoundsSize(_loc5_,_loc3_);
      this.labelDisplayShadow.setLayoutBoundsPosition(_loc6_,_loc4_ + this.shadowYOffset);
      this.labelDisplayShadow.alpha = getStyle("textShadowAlpha");
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplayShadow.text = this.labelDisplay.text;
      }
   }
   
   private function labelDisplay_valueCommitHandler(param1:Event) : void
   {
      this.labelDisplayShadow.text = this.labelDisplay.text;
   }
   
   public function get text() : String
   {
      return this._text;
   }
   
   public function set text(param1:String) : void
   {
      this._text = param1;
      this.labelChanged = true;
      invalidateProperties();
   }
   
   public function get isTruncated() : Boolean
   {
      return this.labelDisplay.isTruncated;
   }
   
   public function showShadow(param1:Boolean) : void
   {
      this.labelDisplayShadow.visible = param1;
   }
}
