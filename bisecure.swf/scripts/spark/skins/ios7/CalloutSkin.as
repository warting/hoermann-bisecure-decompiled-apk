package spark.skins.ios7
{
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import spark.components.ArrowDirection;
   import spark.components.Callout;
   import spark.components.ContentBackgroundAppearance;
   import spark.components.Group;
   import spark.core.SpriteVisualElement;
   import spark.effects.Fade;
   import spark.primitives.RectangularDropShadow;
   import spark.skins.ios7.supportClasses.CalloutArrow;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class CalloutSkin extends MobileSkin
   {
      
      mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_TOP:int = 15;
      
      mx_internal static const BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM:int = -15;
       
      
      public var hostComponent:Callout;
      
      protected var dropShadowVisible:Boolean = false;
      
      protected var useBackgroundGradient:Boolean = true;
      
      protected var contentCornerRadius:uint;
      
      protected var contentBackgroundInsetClass:Class;
      
      protected var backgroundCornerRadius:Number;
      
      protected var frameThickness:Number;
      
      protected var borderColor:Number = -1;
      
      protected var borderThickness:Number = -1;
      
      protected var arrowWidth:Number;
      
      protected var arrowHeight:Number;
      
      mx_internal var contentBackgroundGraphic:SpriteVisualElement;
      
      mx_internal var isOpen:Boolean;
      
      private var backgroundGradientHeight:Number;
      
      private var contentMask:Sprite;
      
      private var backgroundFill:SpriteVisualElement;
      
      private var dropShadow:RectangularDropShadow;
      
      private var dropShadowBlurX:Number;
      
      private var dropShadowBlurY:Number;
      
      private var dropShadowDistance:Number;
      
      private var dropShadowAlpha:Number;
      
      private var fade:Fade;
      
      private var highlightWeight:Number;
      
      public var contentGroup:Group;
      
      public var arrow:UIComponent;
      
      public function CalloutSkin()
      {
         super();
         this.dropShadowAlpha = 0;
         this.contentBackgroundInsetClass = null;
         this.frameThickness = 0;
         this.backgroundCornerRadius = 0;
         this.backgroundGradientHeight = 0;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.arrowWidth = 160;
               this.arrowHeight = 80;
               this.contentCornerRadius = 40;
               this.dropShadowBlurX = 64;
               this.dropShadowBlurY = 64;
               this.dropShadowDistance = 12;
               this.highlightWeight = 4;
               break;
            case DPIClassification.DPI_480:
               this.arrowWidth = 120;
               this.arrowHeight = 60;
               this.contentCornerRadius = 30;
               this.dropShadowBlurX = 48;
               this.dropShadowBlurY = 48;
               this.dropShadowDistance = 8;
               this.highlightWeight = 2;
               break;
            case DPIClassification.DPI_320:
               this.arrowWidth = 80;
               this.arrowHeight = 40;
               this.contentCornerRadius = 20;
               this.dropShadowBlurX = 32;
               this.dropShadowBlurY = 32;
               this.dropShadowDistance = 6;
               this.highlightWeight = 2;
               break;
            case DPIClassification.DPI_240:
               this.arrowWidth = 60;
               this.arrowHeight = 30;
               this.contentCornerRadius = 15;
               this.dropShadowBlurX = 24;
               this.dropShadowBlurY = 24;
               this.dropShadowDistance = 4;
               this.highlightWeight = 1;
               break;
            case DPIClassification.DPI_120:
               this.arrowWidth = 30;
               this.arrowHeight = 15;
               this.contentCornerRadius = 7.5;
               this.dropShadowBlurX = 12;
               this.dropShadowBlurY = 12;
               this.dropShadowDistance = 2;
               this.highlightWeight = 0.5;
               break;
            default:
               this.arrowWidth = 40;
               this.arrowHeight = 20;
               this.contentCornerRadius = 10;
               this.dropShadowBlurX = 16;
               this.dropShadowBlurY = 16;
               this.dropShadowDistance = 3;
               this.highlightWeight = 1;
         }
      }
      
      mx_internal function get actualBorderThickness() : Number
      {
         var _loc1_:Number = this.borderThickness != -1?Number(this.borderThickness):Number(getStyle("borderThickness"));
         return !!isNaN(_loc1_)?Number(0):Number(_loc1_);
      }
      
      mx_internal function get actualBorderColor() : uint
      {
         return this.borderColor != -1?uint(this.borderColor):uint(getStyle("borderColor"));
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(this.dropShadowVisible)
         {
            this.dropShadow = new RectangularDropShadow();
            this.dropShadow.angle = 90;
            this.dropShadow.distance = this.dropShadowDistance;
            this.dropShadow.blurX = this.dropShadowBlurX;
            this.dropShadow.blurY = this.dropShadowBlurY;
            this.dropShadow.tlRadius = this.dropShadow.trRadius = this.dropShadow.blRadius = this.dropShadow.brRadius = this.backgroundCornerRadius;
            this.dropShadow.mouseEnabled = false;
            this.dropShadow.alpha = this.dropShadowAlpha;
            addChild(this.dropShadow);
         }
         this.backgroundFill = new SpriteVisualElement();
         addChild(this.backgroundFill);
         if(!this.arrow)
         {
            this.arrow = new CalloutArrow();
            this.arrow.id = "arrow";
            this.arrow.styleName = this;
            addChild(this.arrow);
         }
         if(!this.contentGroup)
         {
            this.contentGroup = new Group();
            this.contentGroup.id = "contentGroup";
            addChild(this.contentGroup);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:String = getStyle("contentBackgroundAppearance");
         if(_loc1_ == ContentBackgroundAppearance.INSET)
         {
            if(!this.contentBackgroundGraphic && this.contentBackgroundInsetClass)
            {
               this.contentBackgroundGraphic = new this.contentBackgroundInsetClass() as SpriteVisualElement;
               addChild(this.contentBackgroundGraphic);
            }
         }
         else if(this.contentBackgroundGraphic)
         {
            removeChild(this.contentBackgroundGraphic);
            this.contentBackgroundGraphic = null;
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.measure();
         var _loc1_:Number = this.actualBorderThickness;
         var _loc2_:Number = (this.frameThickness + _loc1_) * 2;
         if(this.isArrowHorizontal)
         {
            _loc3_ = this.arrowHeight;
            _loc4_ = this.arrowWidth + this.backgroundCornerRadius * 2;
         }
         else if(this.isArrowVertical)
         {
            _loc3_ = this.arrowWidth + this.backgroundCornerRadius * 2;
            _loc4_ = this.arrowHeight;
         }
         measuredMinWidth = this.contentGroup.measuredMinWidth + _loc2_;
         measuredMinHeight = this.contentGroup.measuredMinHeight + _loc2_;
         measuredWidth = this.contentGroup.getPreferredBoundsWidth() + _loc2_;
         measuredHeight = this.contentGroup.getPreferredBoundsHeight() + _loc2_;
         if(this.isArrowHorizontal)
         {
            measuredMinWidth = measuredMinWidth + _loc3_;
            measuredMinHeight = Math.max(measuredMinHeight,_loc4_);
            measuredWidth = measuredWidth + _loc3_;
            measuredHeight = Math.max(measuredHeight,_loc4_);
         }
         else if(this.isArrowVertical)
         {
            measuredMinWidth = measuredMinWidth + Math.max(measuredMinWidth,_loc3_);
            measuredMinHeight = measuredMinHeight + _loc4_;
            measuredWidth = Math.max(measuredWidth,_loc3_);
            measuredHeight = measuredHeight + _loc4_;
         }
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         var _loc1_:* = currentState == "normal";
         var _loc2_:* = currentState == "disabled";
         if(!(_loc1_ || _loc2_) && this.isOpen)
         {
            if(!this.fade)
            {
               this.fade = new Fade();
               this.fade.target = this;
               this.fade.duration = 200;
               this.fade.alphaTo = 0;
            }
            blendMode = BlendMode.LAYER;
            this.fade.addEventListener(EffectEvent.EFFECT_END,this.stateChangeComplete);
            this.fade.play();
            this.isOpen = false;
         }
         else
         {
            this.isOpen = _loc1_ || _loc2_;
            if(this.fade && this.fade.isPlaying)
            {
               this.fade.removeEventListener(EffectEvent.EFFECT_END,this.stateChangeComplete);
               this.fade.stop();
            }
            if(_loc2_)
            {
               blendMode = BlendMode.LAYER;
               alpha = 0.5;
            }
            else
            {
               blendMode = BlendMode.NORMAL;
               if(_loc1_)
               {
                  alpha = 1;
               }
               else
               {
                  alpha = 0;
               }
            }
            this.stateChangeComplete();
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Graphics = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         super.drawBackground(param1,param2);
         var _loc3_:Number = this.backgroundCornerRadius * 2;
         var _loc4_:Number = this.actualBorderThickness;
         var _loc5_:* = _loc4_ > 0;
         var _loc6_:Number = Math.floor(this.contentGroup.getLayoutBoundsX() - this.frameThickness) - _loc4_ / 2;
         var _loc7_:Number = Math.floor(this.contentGroup.getLayoutBoundsY() - this.frameThickness) - _loc4_ / 2;
         var _loc8_:Number = this.contentGroup.getLayoutBoundsWidth() + this.frameThickness * 2 + _loc4_;
         var _loc9_:Number = this.contentGroup.getLayoutBoundsHeight() + this.frameThickness * 2 + _loc4_;
         var _loc10_:Number = getStyle("contentBackgroundColor");
         var _loc11_:Number = getStyle("backgroundAlpha");
         var _loc12_:Graphics = this.backgroundFill.graphics;
         _loc12_.clear();
         var _loc13_:String = getStyle("contentBackgroundAppearance");
         if(_loc13_ != ContentBackgroundAppearance.NONE)
         {
            _loc14_ = this.contentCornerRadius * 2;
            _loc15_ = getStyle("contentBackgroundAlpha");
            _loc16_ = this.contentGroup.getLayoutBoundsWidth();
            _loc17_ = this.contentGroup.getLayoutBoundsHeight();
            if(!this.contentMask)
            {
               this.contentMask = new SpriteVisualElement();
            }
            this.contentGroup.mask = this.contentMask;
            _loc18_ = this.contentMask.graphics;
            _loc18_.clear();
            _loc18_.beginFill(0,1);
            _loc18_.drawRoundRect(0,0,_loc16_,_loc17_,_loc14_,_loc14_);
            _loc18_.endFill();
            if(_loc5_)
            {
               _loc12_.lineStyle(NaN);
            }
            _loc12_.beginFill(getStyle("contentBackgroundColor"),_loc15_);
            _loc12_.drawRoundRect(this.contentGroup.getLayoutBoundsX(),this.contentGroup.getLayoutBoundsY(),_loc16_,_loc17_,_loc14_,_loc14_);
            _loc12_.endFill();
            if(this.contentBackgroundGraphic)
            {
               this.contentBackgroundGraphic.alpha = _loc15_;
            }
         }
         else if(this.contentMask)
         {
            this.contentGroup.mask = null;
            this.contentMask = null;
         }
         if(this.useBackgroundGradient && !this.isArrowHorizontal && !this.isArrowVertical)
         {
            _loc19_ = _loc8_ - _loc3_;
            _loc20_ = _loc6_ + this.backgroundCornerRadius;
            _loc21_ = this.highlightWeight * 1.5;
            _loc12_.lineStyle(this.highlightWeight,16777215,0.2 * _loc11_);
            _loc12_.moveTo(_loc20_,_loc21_);
            _loc12_.lineTo(_loc20_ + _loc19_,_loc21_);
         }
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         if(this.isArrowHorizontal)
         {
            this.arrow.width = this.arrowHeight;
            this.arrow.height = this.arrowWidth + this.backgroundCornerRadius * 2;
         }
         else if(this.isArrowVertical)
         {
            this.arrow.width = this.arrowWidth + this.backgroundCornerRadius * 2;
            this.arrow.height = this.arrowHeight;
         }
         setElementSize(this.backgroundFill,param1,param2);
         setElementPosition(this.backgroundFill,0,0);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = param1;
         var _loc6_:Number = param2;
         switch(this.hostComponent.arrowDirection)
         {
            case ArrowDirection.UP:
               _loc4_ = this.arrow.height;
               _loc6_ = _loc6_ - this.arrow.height;
               break;
            case ArrowDirection.DOWN:
               _loc6_ = _loc6_ - this.arrow.height;
               break;
            case ArrowDirection.LEFT:
               _loc3_ = this.arrow.width;
               _loc5_ = _loc5_ - this.arrow.width;
               break;
            case ArrowDirection.RIGHT:
               _loc5_ = _loc5_ - this.arrow.width;
         }
         if(this.dropShadow)
         {
            setElementSize(this.dropShadow,_loc5_,_loc6_);
            setElementPosition(this.dropShadow,_loc3_,_loc4_);
         }
         var _loc7_:Number = this.actualBorderThickness;
         var _loc8_:Number = this.frameThickness + _loc7_;
         var _loc9_:Number = _loc3_ + _loc8_;
         var _loc10_:Number = _loc4_ + _loc8_;
         _loc8_ = _loc8_ * 2;
         var _loc11_:Number = _loc5_ - _loc8_;
         var _loc12_:Number = _loc6_ - _loc8_;
         if(this.contentBackgroundGraphic)
         {
            setElementSize(this.contentBackgroundGraphic,_loc11_,_loc12_);
            setElementPosition(this.contentBackgroundGraphic,_loc9_,_loc10_);
         }
         setElementSize(this.contentGroup,_loc11_,_loc12_);
         setElementPosition(this.contentGroup,_loc9_,_loc10_);
         if(this.contentMask)
         {
            setElementSize(this.contentMask,_loc11_,_loc12_);
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc3_:Number = NaN;
         super.styleChanged(param1);
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "contentBackgroundAppearance")
         {
            invalidateProperties();
         }
         if(_loc2_ || param1 == "backgroundAlpha")
         {
            _loc3_ = getStyle("backgroundAlpha");
            blendMode = _loc3_ < 1?BlendMode.LAYER:BlendMode.NORMAL;
         }
      }
      
      mx_internal function get isArrowHorizontal() : Boolean
      {
         return this.hostComponent.arrowDirection == ArrowDirection.LEFT || this.hostComponent.arrowDirection == ArrowDirection.RIGHT;
      }
      
      mx_internal function get isArrowVertical() : Boolean
      {
         return this.hostComponent.arrowDirection == ArrowDirection.UP || this.hostComponent.arrowDirection == ArrowDirection.DOWN;
      }
      
      private function stateChangeComplete(param1:Event = null) : void
      {
         if(this.fade && param1)
         {
            this.fade.removeEventListener(EffectEvent.EFFECT_END,this.stateChangeComplete);
         }
         dispatchEvent(new FlexEvent(FlexEvent.STATE_CHANGE_COMPLETE));
      }
   }
}
