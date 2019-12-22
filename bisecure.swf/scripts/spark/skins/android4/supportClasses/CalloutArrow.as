package spark.skins.android4.supportClasses
{
   import flash.display.BlendMode;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.GraphicsPathCommand;
   import flash.display.Sprite;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.utils.ColorUtil;
   import spark.components.Application;
   import spark.components.ArrowDirection;
   import spark.components.Callout;
   import spark.skins.android4.CalloutSkin;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class CalloutArrow extends UIComponent
   {
       
      
      protected var gap:Number;
      
      protected var backgroundGradientHeight:Number;
      
      private var highlightWeight:Number;
      
      protected var useBackgroundGradient:Boolean;
      
      protected var borderColor:Number = -1;
      
      protected var borderThickness:Number = -1;
      
      private var eraseFill:Sprite;
      
      public function CalloutArrow()
      {
         super();
         this.useBackgroundGradient = true;
         var _loc1_:Number = DPIClassification.DPI_160;
         if(FlexGlobals.topLevelApplication is Application)
         {
            _loc1_ = Application(FlexGlobals.topLevelApplication).applicationDPI;
         }
         switch(_loc1_)
         {
            case DPIClassification.DPI_640:
               this.gap = 32;
               this.backgroundGradientHeight = 440;
               this.highlightWeight = 4;
               break;
            case DPIClassification.DPI_480:
               this.gap = 24;
               this.backgroundGradientHeight = 330;
               this.highlightWeight = 3;
               break;
            case DPIClassification.DPI_320:
               this.gap = 16;
               this.backgroundGradientHeight = 220;
               this.highlightWeight = 2;
               break;
            case DPIClassification.DPI_240:
               this.gap = 12;
               this.backgroundGradientHeight = 165;
               this.highlightWeight = 1;
               break;
            case DPIClassification.DPI_120:
               this.gap = 6;
               this.backgroundGradientHeight = 83;
               this.highlightWeight = 1;
               break;
            default:
               this.gap = 8;
               this.backgroundGradientHeight = 110;
               this.highlightWeight = 1;
         }
      }
      
      private function get actualBorderThickness() : Number
      {
         return this.calloutSkin.actualBorderThickness;
      }
      
      private function get actualBorderColor() : uint
      {
         return this.calloutSkin.actualBorderColor;
      }
      
      protected function get calloutSkin() : CalloutSkin
      {
         return parent as CalloutSkin;
      }
      
      protected function get calloutHostComponent() : Callout
      {
         return this.calloutSkin.hostComponent;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.eraseFill = new Sprite();
         this.eraseFill.blendMode = BlendMode.ERASE;
         parent.addChildAt(this.eraseFill,parent.getChildIndex(this));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         super.updateDisplayList(param1,param2);
         graphics.clear();
         this.eraseFill.graphics.clear();
         var _loc3_:Callout = this.calloutHostComponent;
         var _loc4_:String = _loc3_.arrowDirection;
         if(_loc4_ == ArrowDirection.NONE)
         {
            return;
         }
         var _loc5_:Graphics = this.graphics;
         var _loc6_:Graphics = this.eraseFill.graphics;
         var _loc7_:Number = param1;
         var _loc8_:Number = param2;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = this.actualBorderThickness;
         var _loc16_:* = _loc15_ > 0;
         var _loc17_:Number = _loc15_ / 2;
         var _loc18_:Boolean = false;
         if(_loc4_ == ArrowDirection.LEFT || _loc4_ == ArrowDirection.RIGHT)
         {
            _loc18_ = true;
            _loc9_ = -_loc17_;
            _loc10_ = this.gap;
            _loc8_ = _loc8_ - this.gap * 2;
            _loc11_ = _loc7_ - _loc17_;
            _loc12_ = _loc10_ + _loc8_ / 2;
            _loc13_ = _loc9_;
            _loc14_ = _loc10_ + _loc8_;
            if(_loc4_ == ArrowDirection.LEFT)
            {
               _loc9_ = _loc7_ - _loc9_;
               _loc11_ = _loc7_ - _loc11_;
               _loc13_ = _loc7_ - _loc13_;
            }
         }
         else
         {
            _loc9_ = this.gap;
            _loc10_ = -_loc17_;
            _loc7_ = _loc7_ - this.gap * 2;
            _loc11_ = _loc9_ + _loc7_ / 2;
            _loc12_ = _loc8_ - _loc17_;
            _loc13_ = _loc9_ + _loc7_;
            _loc14_ = _loc10_;
            if(_loc3_.arrowDirection == ArrowDirection.UP)
            {
               _loc10_ = _loc8_ - _loc10_;
               _loc12_ = _loc8_ - _loc12_;
               _loc14_ = _loc8_ - _loc14_;
            }
         }
         var _loc19_:Vector.<int> = new Vector.<int>(3,true);
         _loc19_[0] = GraphicsPathCommand.MOVE_TO;
         _loc19_[1] = GraphicsPathCommand.LINE_TO;
         _loc19_[2] = GraphicsPathCommand.LINE_TO;
         var _loc20_:Vector.<Number> = new Vector.<Number>(6,true);
         _loc20_[0] = _loc9_;
         _loc20_[1] = _loc10_;
         _loc20_[2] = _loc11_;
         _loc20_[3] = _loc12_;
         _loc20_[4] = _loc13_;
         _loc20_[5] = _loc14_;
         var _loc21_:Number = getStyle("backgroundColor");
         var _loc22_:Number = getStyle("backgroundAlpha");
         if(this.useBackgroundGradient)
         {
            _loc29_ = ColorUtil.adjustBrightness2(_loc21_,CalloutSkin.BACKGROUND_GRADIENT_BRIGHTNESS_TOP);
            _loc30_ = ColorUtil.adjustBrightness2(_loc21_,CalloutSkin.BACKGROUND_GRADIENT_BRIGHTNESS_BOTTOM);
            MobileSkin.colorMatrix.createGradientBox(param1,this.backgroundGradientHeight,Math.PI / 2,0,-getLayoutBoundsY());
            _loc5_.beginGradientFill(GradientType.LINEAR,[_loc29_,_loc30_],[_loc22_,_loc22_],[0,255],MobileSkin.colorMatrix);
         }
         else
         {
            _loc5_.beginFill(_loc21_,_loc22_);
         }
         if(_loc16_)
         {
            _loc31_ = 0;
            _loc32_ = 0;
            _loc33_ = 0;
            _loc34_ = 0;
            switch(_loc4_)
            {
               case ArrowDirection.UP:
                  _loc31_ = _loc9_;
                  _loc32_ = _loc10_;
                  _loc33_ = _loc7_;
                  _loc34_ = _loc15_;
                  break;
               case ArrowDirection.DOWN:
                  _loc31_ = _loc9_;
                  _loc32_ = -_loc15_;
                  _loc33_ = _loc7_;
                  _loc34_ = _loc15_;
                  break;
               case ArrowDirection.LEFT:
                  _loc31_ = _loc9_;
                  _loc32_ = _loc10_;
                  _loc33_ = _loc15_;
                  _loc34_ = _loc8_;
                  break;
               case ArrowDirection.RIGHT:
                  _loc31_ = -_loc15_;
                  _loc32_ = _loc10_;
                  _loc33_ = _loc15_;
                  _loc34_ = _loc8_;
            }
            _loc5_.drawRect(_loc31_,_loc32_,_loc33_,_loc34_);
         }
         if(_loc22_ < 1)
         {
            this.eraseFill.x = getLayoutBoundsX();
            this.eraseFill.y = getLayoutBoundsY();
            _loc6_.beginFill(0,1);
            _loc6_.drawPath(_loc19_,_loc20_);
            _loc6_.endFill();
         }
         if(_loc16_)
         {
            _loc5_.lineStyle(_loc15_,this.actualBorderColor,1,true);
         }
         _loc5_.drawPath(_loc19_,_loc20_);
         _loc5_.endFill();
         var _loc23_:* = _loc4_ == ArrowDirection.UP;
         var _loc24_:Number = !!_loc23_?Number(param2):Number(-getLayoutBoundsY());
         var _loc25_:Number = this.gap - getLayoutBoundsX();
         var _loc26_:Number = this.highlightWeight * 1.5;
         var _loc27_:Number = _loc26_ + _loc24_;
         var _loc28_:Number = IVisualElement(this.calloutSkin).getLayoutBoundsWidth() - this.gap * 2;
         if(_loc18_)
         {
            _loc28_ = _loc28_ - _loc7_;
            if(_loc4_ == ArrowDirection.LEFT)
            {
               _loc25_ = _loc25_ + _loc7_;
            }
         }
         if(this.useBackgroundGradient)
         {
            if(_loc23_)
            {
               _loc35_ = _loc28_ - _loc7_;
               _loc5_.lineStyle(this.highlightWeight,16777215,0.2 * _loc22_);
               if(_loc25_ < 0)
               {
                  _loc5_.moveTo(_loc25_,_loc27_);
                  _loc5_.lineTo(_loc9_,_loc27_);
                  _loc35_ = _loc35_ - (_loc9_ - _loc25_);
               }
               _loc20_[1] = _loc10_ + _loc26_;
               _loc20_[3] = _loc12_ + _loc26_;
               _loc20_[5] = _loc14_ + _loc26_;
               _loc5_.drawPath(_loc19_,_loc20_);
               if(_loc35_ > 0)
               {
                  _loc5_.moveTo(_loc13_,_loc27_);
                  _loc5_.lineTo(_loc13_ + _loc35_,_loc27_);
               }
            }
            else
            {
               _loc5_.lineStyle(this.highlightWeight,16777215,0.2 * _loc22_);
               _loc5_.moveTo(_loc25_,_loc27_);
               _loc5_.lineTo(_loc25_ + _loc28_,_loc27_);
            }
         }
      }
   }
}
