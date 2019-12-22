package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.managers.SystemManager;
   import mx.utils.MatrixUtil;
   import mx.utils.PopUpUtil;
   
   use namespace mx_internal;
   
   public class Callout extends SkinnablePopUpContainer
   {
      
      private static var decomposition:Vector.<Number> = new <Number>[0,0,0,0,0];
       
      
      private var _93090825arrow:UIComponent;
      
      private var invalidatePositionFlag:Boolean = false;
      
      private var _horizontalPosition:String = "auto";
      
      private var _actualHorizontalPosition:String;
      
      private var _verticalPosition:String = "auto";
      
      private var _actualVerticalPosition:String;
      
      private var _arrowDirection:String = "none";
      
      private var arrowDirectionAdjusted:Boolean = false;
      
      private var _margin:Number = NaN;
      
      private var _explicitMoveForSoftKeyboard:Boolean = false;
      
      private var _calloutMaxWidth:Number = NaN;
      
      private var _calloutMaxHeight:Number = NaN;
      
      public function Callout()
      {
         super();
      }
      
      public function get horizontalPosition() : String
      {
         return this._horizontalPosition;
      }
      
      public function set horizontalPosition(param1:String) : void
      {
         if(param1 == this._horizontalPosition)
         {
            return;
         }
         this._horizontalPosition = param1;
         this.invalidatePosition();
      }
      
      mx_internal function get actualHorizontalPosition() : String
      {
         if(this._actualHorizontalPosition)
         {
            return this._actualHorizontalPosition;
         }
         return this.horizontalPosition;
      }
      
      mx_internal function set actualHorizontalPosition(param1:String) : void
      {
         this._actualHorizontalPosition = param1;
      }
      
      public function get verticalPosition() : String
      {
         return this._verticalPosition;
      }
      
      public function set verticalPosition(param1:String) : void
      {
         if(param1 == this._verticalPosition)
         {
            return;
         }
         this._verticalPosition = param1;
         this.invalidatePosition();
      }
      
      mx_internal function get actualVerticalPosition() : String
      {
         if(this._actualVerticalPosition)
         {
            return this._actualVerticalPosition;
         }
         return this.verticalPosition;
      }
      
      mx_internal function set actualVerticalPosition(param1:String) : void
      {
         this._actualVerticalPosition = param1;
      }
      
      public function get arrowDirection() : String
      {
         return this._arrowDirection;
      }
      
      mx_internal function setArrowDirection(param1:String) : void
      {
         if(this._arrowDirection == param1)
         {
            return;
         }
         this._arrowDirection = param1;
         skin.invalidateProperties();
         switch(this.arrowDirection)
         {
            case ArrowDirection.DOWN:
               softKeyboardEffectMarginBottom = 0;
               softKeyboardEffectMarginTop = this.margin;
               break;
            case ArrowDirection.UP:
               softKeyboardEffectMarginTop = 0;
               softKeyboardEffectMarginBottom = this.margin;
               break;
            default:
               softKeyboardEffectMarginBottom = this.margin;
               softKeyboardEffectMarginTop = this.margin;
         }
         if(hasEventListener("arrowDirectionChanged"))
         {
            dispatchEvent(new Event("arrowDirectionChanged"));
         }
      }
      
      mx_internal function get margin() : Number
      {
         var _loc1_:Number = NaN;
         if(isNaN(this._margin))
         {
            if(FlexGlobals.topLevelApplication.hasOwnProperty("applicationDPI"))
            {
               _loc1_ = FlexGlobals.topLevelApplication["applicationDPI"];
            }
            if(_loc1_)
            {
               switch(_loc1_)
               {
                  case DPIClassification.DPI_640:
                     this._margin = 32;
                     break;
                  case DPIClassification.DPI_480:
                     this._margin = 24;
                     break;
                  case DPIClassification.DPI_320:
                     this._margin = 16;
                     break;
                  case DPIClassification.DPI_240:
                     this._margin = 12;
                     break;
                  case DPIClassification.DPI_120:
                     this._margin = 6;
                     break;
                  default:
                     this._margin = 8;
               }
            }
            else
            {
               this._margin = 8;
            }
         }
         return this._margin;
      }
      
      override public function get moveForSoftKeyboard() : Boolean
      {
         if(!this._explicitMoveForSoftKeyboard && this.arrowDirection == ArrowDirection.UP)
         {
            return false;
         }
         return super.moveForSoftKeyboard;
      }
      
      override public function set moveForSoftKeyboard(param1:Boolean) : void
      {
         super.moveForSoftKeyboard = param1;
         this._explicitMoveForSoftKeyboard = true;
      }
      
      mx_internal function get calloutMaxWidth() : Number
      {
         return this._calloutMaxWidth;
      }
      
      mx_internal function set calloutMaxWidth(param1:Number) : void
      {
         if(this._calloutMaxWidth == param1)
         {
            return;
         }
         this._calloutMaxWidth = param1;
         this.invalidateMaxSize();
      }
      
      mx_internal function get calloutMaxHeight() : Number
      {
         return this._calloutMaxHeight;
      }
      
      mx_internal function set calloutMaxHeight(param1:Number) : void
      {
         if(this._calloutMaxHeight == param1)
         {
            return;
         }
         this._calloutMaxHeight = param1;
         this.invalidateMaxSize();
      }
      
      override public function get explicitMaxWidth() : Number
      {
         if(!isNaN(super.explicitMaxWidth))
         {
            return super.explicitMaxWidth;
         }
         return this.calloutMaxWidth;
      }
      
      override public function get explicitMaxHeight() : Number
      {
         if(!isNaN(super.explicitMaxHeight))
         {
            return super.explicitMaxHeight;
         }
         return this.calloutMaxHeight;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:String = null;
         super.commitProperties();
         if(!owner || !owner.parent)
         {
            return;
         }
         this.commitAutoPosition();
         this.commitMaxSize();
         if(this.arrow)
         {
            if(!this.arrowDirectionAdjusted)
            {
               _loc1_ = this.determineArrowPosition(this.actualHorizontalPosition,this.actualVerticalPosition);
               if(this.arrowDirection != _loc1_)
               {
                  this.setArrowDirection(_loc1_);
                  if(this.arrow)
                  {
                     this.arrow.visible = this.arrowDirection != ArrowDirection.NONE;
                  }
               }
            }
            invalidateDisplayList();
         }
      }
      
      override public function updatePopUpPosition() : void
      {
         if(!owner || !systemManager)
         {
            return;
         }
         var _loc1_:Point = this.calculatePopUpPosition();
         var _loc2_:UIComponent = owner as UIComponent;
         var _loc3_:ColorTransform = !!_loc2_?_loc2_.$transform.concatenatedColorTransform:null;
         PopUpUtil.applyPopUpTransform(owner,_loc3_,systemManager,this,_loc1_);
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         super.partAdded(param1,param2);
         if(param2 == this.arrow)
         {
            this.arrow.addEventListener(ResizeEvent.RESIZE,this.arrow_resizeHandler);
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         super.partRemoved(param1,param2);
         if(param2 == this.arrow)
         {
            this.arrow.removeEventListener(ResizeEvent.RESIZE,this.arrow_resizeHandler);
         }
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(isOpen)
         {
            return;
         }
         this.invalidatePositionFlag = false;
         this.arrowDirectionAdjusted = false;
         super.open(param1,param2);
         var _loc3_:SystemManager = this.parent as SystemManager;
         if(_loc3_)
         {
            _loc3_.addEventListener(Event.RESIZE,this.systemManager_resizeHandler);
         }
      }
      
      override public function close(param1:Boolean = false, param2:* = null) : void
      {
         if(!isOpen)
         {
            return;
         }
         var _loc3_:SystemManager = this.parent as SystemManager;
         if(_loc3_)
         {
            _loc3_.removeEventListener(Event.RESIZE,this.systemManager_resizeHandler);
         }
         super.close(param1,param2);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(isOpen && this.invalidatePositionFlag)
         {
            this.updatePopUpPosition();
            this.invalidatePositionFlag = false;
         }
         this.updateSkinDisplayList();
      }
      
      private function invalidatePosition() : void
      {
         this.arrowDirectionAdjusted = false;
         invalidateProperties();
         if(isOpen)
         {
            this.invalidatePositionFlag = true;
         }
      }
      
      private function invalidateMaxSize() : void
      {
         if(!canSkipMeasurement() && !this.isMaxSizeSet)
         {
            skin.invalidateSize();
         }
      }
      
      protected function updateSkinDisplayList() : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc1_:IVisualElement = owner as IVisualElement;
         if(!this.arrow || !_loc1_ || this.arrowDirection == ArrowDirection.NONE || !_loc1_.parent)
         {
            return;
         }
         var _loc2_:* = false;
         var _loc3_:* = false;
         var _loc4_:* = false;
         var _loc5_:String = !!this.isArrowVertical?this.actualHorizontalPosition:this.actualVerticalPosition;
         _loc2_ = _loc5_ == CalloutPosition.START;
         _loc3_ = _loc5_ == CalloutPosition.MIDDLE;
         _loc4_ = _loc5_ == CalloutPosition.END;
         var _loc6_:Boolean = this.arrowDirection == ArrowDirection.DOWN || this.arrowDirection == ArrowDirection.RIGHT;
         var _loc7_:Number = getLayoutBoundsWidth();
         var _loc8_:Number = getLayoutBoundsHeight();
         var _loc9_:Number = this.arrow.getLayoutBoundsWidth();
         var _loc10_:Number = this.arrow.getLayoutBoundsHeight();
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = _loc7_ - _loc9_;
         var _loc14_:Number = _loc8_ - _loc10_;
         var _loc15_:DisplayObject = systemManager.getSandboxRoot();
         var _loc16_:Point = owner.localToGlobal(new Point());
         _loc16_ = _loc15_.globalToLocal(_loc16_);
         if(this.isArrowVertical)
         {
            _loc17_ = _loc16_.x;
            _loc18_ = !!_loc1_?Number(_loc1_.getLayoutBoundsWidth()):Number(owner.width);
            if(_loc17_ < 0 && _loc18_ < screen.width)
            {
               _loc18_ = Math.max(_loc18_ + _loc17_,0);
            }
            else if(_loc17_ >= 0 && _loc17_ + _loc18_ >= screen.width)
            {
               _loc18_ = Math.max(screen.width - _loc17_,0);
            }
            _loc18_ = Math.min(_loc18_,screen.width);
            if(_loc7_ <= _loc18_)
            {
               _loc11_ = (_loc7_ - _loc9_) / 2;
            }
            else
            {
               _loc11_ = (_loc18_ - _loc9_) / 2;
               if(_loc17_ > 0)
               {
                  _loc11_ = _loc11_ + Math.abs(_loc17_ - getLayoutBoundsX());
               }
               if(_loc17_ < this.margin)
               {
                  _loc11_ = _loc11_ - (this.margin - _loc17_);
               }
            }
            _loc11_ = Math.max(Math.min(_loc13_,_loc11_),0);
            if(_loc6_)
            {
               _loc12_ = _loc8_ - _loc10_;
            }
         }
         else
         {
            _loc19_ = _loc16_.y;
            _loc20_ = !!_loc1_?Number(_loc1_.getLayoutBoundsHeight()):Number(owner.height);
            if(_loc19_ < 0 && _loc20_ < screen.height)
            {
               _loc20_ = Math.max(_loc20_ + _loc19_,0);
            }
            else if(_loc19_ >= 0 && _loc19_ + _loc20_ >= screen.height)
            {
               _loc20_ = Math.max(screen.height - _loc19_,0);
            }
            _loc20_ = Math.min(_loc20_,screen.height);
            if(_loc8_ <= _loc20_)
            {
               _loc12_ = (_loc8_ - _loc10_) / 2;
            }
            else
            {
               _loc12_ = (_loc20_ - _loc10_) / 2;
               if(_loc19_ > 0)
               {
                  _loc12_ = _loc12_ + Math.abs(_loc19_ - getLayoutBoundsY());
               }
               if(_loc19_ < this.margin)
               {
                  _loc19_ = _loc19_ - (this.margin - _loc19_);
               }
            }
            _loc12_ = Math.max(Math.min(_loc14_,_loc12_),0);
            if(_loc6_)
            {
               _loc11_ = _loc7_ - _loc9_;
            }
         }
         this.arrow.setLayoutBoundsPosition(Math.floor(_loc11_),Math.floor(_loc12_));
         this.arrow.invalidateDisplayList();
      }
      
      mx_internal function adjustCalloutPosition(param1:String, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Boolean = false) : String
      {
         if(!param1)
         {
            return null;
         }
         var _loc10_:String = null;
         var _loc11_:Number = param4 - param3;
         var _loc12_:Number = Math.max(0,param7 - param5);
         var _loc13_:Number = Math.max(0,param8 - param6);
         var _loc14_:Boolean = param2 == CalloutPosition.AUTO && _loc12_ < _loc11_ && _loc13_ < _loc11_;
         var _loc15_:Boolean = false;
         switch(param1)
         {
            case CalloutPosition.BEFORE:
               _loc15_ = true;
               if(param3 < param5)
               {
                  _loc10_ = CalloutPosition.AFTER;
               }
               break;
            case CalloutPosition.AFTER:
               _loc15_ = true;
               if(param4 > param6)
               {
                  _loc10_ = CalloutPosition.BEFORE;
               }
               break;
            case CalloutPosition.END:
               if(param3 < param5)
               {
                  _loc10_ = CalloutPosition.START;
               }
               break;
            case CalloutPosition.START:
               if(param4 > param6)
               {
                  _loc10_ = CalloutPosition.END;
               }
         }
         if(_loc14_ && _loc10_ && _loc15_)
         {
            _loc10_ = _loc13_ >= _loc12_?CalloutPosition.START:CalloutPosition.END;
         }
         if(param9)
         {
            return !!_loc10_?null:param1;
         }
         return _loc10_;
      }
      
      mx_internal function nudgeToFit(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = 0;
         if(param1 < param3)
         {
            _loc6_ = _loc6_ + (param3 - param1) / param5;
         }
         else if(param2 > param4)
         {
            _loc6_ = _loc6_ - (param2 - param4) / param5;
         }
         return _loc6_;
      }
      
      mx_internal function calculatePopUpPosition() : Point
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc16_:Point = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:Rectangle = null;
         var _loc1_:DisplayObject = systemManager.getSandboxRoot();
         var _loc2_:Matrix = MatrixUtil.getConcatenatedMatrix(owner,_loc1_);
         var _loc3_:Point = new Point();
         if(!_loc2_)
         {
            return _loc3_;
         }
         var _loc6_:Rectangle = this.determinePosition(this.actualHorizontalPosition,this.actualVerticalPosition,_loc2_,_loc3_);
         var _loc7_:Rectangle = owner.getBounds(systemManager.getSandboxRoot());
         if(screen)
         {
            _loc4_ = this.adjustCalloutPosition(this.actualHorizontalPosition,this.horizontalPosition,_loc6_.left,_loc6_.right,screen.left,screen.right,_loc7_.left,_loc7_.right);
            _loc5_ = this.adjustCalloutPosition(this.actualVerticalPosition,this.verticalPosition,_loc6_.top,_loc6_.bottom,screen.top,screen.bottom,_loc7_.top,_loc7_.bottom);
         }
         var _loc8_:String = this.arrowDirection;
         var _loc9_:String = null;
         this.arrowDirectionAdjusted = false;
         if(_loc4_ != null || _loc5_ != null)
         {
            _loc16_ = new Point();
            _loc17_ = !!_loc4_?_loc4_:this.actualHorizontalPosition;
            _loc18_ = !!_loc5_?_loc5_:this.actualVerticalPosition;
            _loc9_ = this.determineArrowPosition(_loc17_,_loc18_);
            this.setArrowDirection(_loc9_);
            this.arrowDirectionAdjusted = true;
            if(this.arrow)
            {
               this.arrow.visible = this.arrowDirection != ArrowDirection.NONE;
            }
            this.updateSkinDisplayList();
            _loc19_ = this.determinePosition(_loc17_,_loc18_,_loc2_,_loc16_);
            if(screen)
            {
               _loc4_ = this.adjustCalloutPosition(_loc4_,this.horizontalPosition,_loc19_.left,_loc19_.right,screen.left,screen.right,_loc7_.left,_loc7_.right,true);
               _loc5_ = this.adjustCalloutPosition(_loc5_,this.verticalPosition,_loc19_.top,_loc19_.bottom,screen.top,screen.bottom,_loc7_.top,_loc7_.bottom,true);
            }
            if(_loc4_ != null || _loc5_ != null)
            {
               _loc3_ = _loc16_;
               _loc6_ = _loc19_;
               if(_loc4_)
               {
                  this.actualHorizontalPosition = _loc4_;
               }
               if(_loc5_)
               {
                  this.actualVerticalPosition = _loc5_;
               }
               this.updateSkinDisplayList();
            }
            else
            {
               this.setArrowDirection(_loc8_);
               this.arrowDirectionAdjusted = false;
               this.updateSkinDisplayList();
            }
         }
         MatrixUtil.decomposeMatrix(decomposition,_loc2_,0,0);
         var _loc10_:Number = decomposition[3];
         var _loc11_:Number = decomposition[4];
         var _loc12_:Number = screen.top;
         var _loc13_:Number = screen.bottom;
         var _loc14_:Number = screen.left;
         var _loc15_:Number = screen.right;
         switch(this.arrowDirection)
         {
            case ArrowDirection.UP:
               _loc13_ = _loc13_ - this.margin;
               _loc14_ = _loc14_ + this.margin;
               _loc15_ = _loc15_ - this.margin;
               break;
            case ArrowDirection.DOWN:
               _loc12_ = _loc12_ + this.margin;
               _loc14_ = _loc14_ + this.margin;
               _loc15_ = _loc15_ - this.margin;
               break;
            case ArrowDirection.LEFT:
               _loc12_ = _loc12_ + this.margin;
               _loc13_ = _loc13_ - this.margin;
               _loc15_ = _loc15_ - this.margin;
               break;
            case ArrowDirection.RIGHT:
               _loc12_ = _loc12_ + this.margin;
               _loc13_ = _loc13_ - this.margin;
               _loc14_ = _loc14_ + this.margin;
               break;
            default:
               _loc12_ = _loc12_ + this.margin;
               _loc13_ = _loc13_ - this.margin;
               _loc14_ = _loc14_ + this.margin;
               _loc15_ = _loc15_ - this.margin;
         }
         _loc3_.y = _loc3_.y + this.nudgeToFit(_loc6_.top,_loc6_.bottom,_loc12_,_loc13_,_loc11_);
         _loc3_.x = _loc3_.x + this.nudgeToFit(_loc6_.left,_loc6_.right,_loc14_,_loc15_,_loc10_);
         if(layoutDirection == LayoutDirection.RTL)
         {
            _loc3_.x = _loc3_.x + _loc6_.width;
         }
         return MatrixUtil.getConcatenatedComputedMatrix(owner,_loc1_).transformPoint(_loc3_);
      }
      
      mx_internal function commitAutoPosition() : void
      {
         if(!screen || this.horizontalPosition != CalloutPosition.AUTO && this.verticalPosition != CalloutPosition.AUTO)
         {
            this.actualHorizontalPosition = null;
            this.actualVerticalPosition = null;
            return;
         }
         var _loc1_:Rectangle = owner.getBounds(systemManager.getSandboxRoot());
         var _loc2_:* = screen.width > screen.height;
         var _loc3_:Number = Math.max(0,_loc1_.left);
         var _loc4_:Number = Math.max(0,screen.width - _loc1_.right);
         var _loc5_:Number = Math.max(0,_loc1_.top);
         var _loc6_:Number = Math.max(0,screen.height - _loc1_.bottom);
         if(this.verticalPosition != CalloutPosition.AUTO)
         {
            switch(this.verticalPosition)
            {
               case CalloutPosition.START:
               case CalloutPosition.MIDDLE:
               case CalloutPosition.END:
                  this.actualHorizontalPosition = _loc4_ > _loc3_?CalloutPosition.AFTER:CalloutPosition.BEFORE;
                  break;
               default:
                  this.actualHorizontalPosition = CalloutPosition.MIDDLE;
            }
            this.actualVerticalPosition = null;
         }
         else if(this.horizontalPosition != CalloutPosition.AUTO)
         {
            switch(this.horizontalPosition)
            {
               case CalloutPosition.START:
               case CalloutPosition.MIDDLE:
               case CalloutPosition.END:
                  this.actualVerticalPosition = _loc6_ > _loc5_?CalloutPosition.AFTER:CalloutPosition.BEFORE;
                  break;
               default:
                  this.actualVerticalPosition = CalloutPosition.MIDDLE;
            }
            this.actualHorizontalPosition = null;
         }
         else if(!_loc2_)
         {
            this.actualHorizontalPosition = CalloutPosition.MIDDLE;
            this.actualVerticalPosition = _loc6_ > _loc5_?CalloutPosition.AFTER:CalloutPosition.BEFORE;
         }
         else
         {
            this.actualHorizontalPosition = _loc4_ > _loc3_?CalloutPosition.AFTER:CalloutPosition.BEFORE;
            this.actualVerticalPosition = CalloutPosition.MIDDLE;
         }
      }
      
      mx_internal function get isMaxSizeSet() : Boolean
      {
         var _loc1_:Number = super.explicitMaxWidth;
         var _loc2_:Number = super.explicitMaxHeight;
         return !isNaN(_loc1_) && !isNaN(_loc2_);
      }
      
      mx_internal function get calloutHeight() : Number
      {
         return !!isSoftKeyboardEffectActive?Number(softKeyboardEffectCachedHeight):Number(getLayoutBoundsHeight());
      }
      
      mx_internal function commitMaxSize() : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:Rectangle = owner.getBounds(systemManager.getSandboxRoot());
         var _loc2_:Number = _loc1_.left;
         var _loc3_:Number = _loc1_.right;
         var _loc4_:Number = _loc1_.top;
         var _loc5_:Number = _loc1_.bottom;
         switch(this.actualHorizontalPosition)
         {
            case CalloutPosition.MIDDLE:
               _loc6_ = screen.width - this.margin * 2;
               break;
            case CalloutPosition.START:
            case CalloutPosition.END:
               _loc2_ = _loc1_.right;
               _loc3_ = _loc1_.left;
            default:
               _loc6_ = Math.max(_loc2_,screen.right - _loc3_) - this.margin;
         }
         if(this.horizontalPosition == CalloutPosition.AUTO && _loc1_.width > _loc6_)
         {
            _loc6_ = _loc6_ + _loc1_.width;
         }
         switch(this.actualVerticalPosition)
         {
            case CalloutPosition.MIDDLE:
               _loc7_ = screen.height - this.margin * 2;
               break;
            case CalloutPosition.START:
            case CalloutPosition.END:
               _loc4_ = _loc1_.bottom;
               _loc5_ = _loc1_.top;
            default:
               _loc7_ = Math.max(_loc4_,screen.bottom - _loc5_) - this.margin;
         }
         if(this.verticalPosition == CalloutPosition.AUTO && _loc1_.height > _loc7_)
         {
            _loc7_ = _loc7_ + _loc1_.height;
         }
         this.calloutMaxWidth = _loc6_;
         this.calloutMaxHeight = _loc7_;
      }
      
      mx_internal function determineArrowPosition(param1:String, param2:String) : String
      {
         var _loc3_:String = ArrowDirection.NONE;
         if(param1 == CalloutPosition.BEFORE)
         {
            if(param2 != CalloutPosition.BEFORE && param2 != CalloutPosition.AFTER)
            {
               _loc3_ = ArrowDirection.RIGHT;
            }
         }
         else if(param1 == CalloutPosition.AFTER)
         {
            if(param2 != CalloutPosition.BEFORE && param2 != CalloutPosition.AFTER)
            {
               _loc3_ = ArrowDirection.LEFT;
            }
         }
         else if(param2 == CalloutPosition.BEFORE)
         {
            _loc3_ = ArrowDirection.DOWN;
         }
         else if(param2 == CalloutPosition.AFTER)
         {
            _loc3_ = ArrowDirection.UP;
         }
         else if(param1 == CalloutPosition.START)
         {
            _loc3_ = ArrowDirection.LEFT;
         }
         else if(param1 == CalloutPosition.END)
         {
            _loc3_ = ArrowDirection.RIGHT;
         }
         else if(param2 == CalloutPosition.START)
         {
            _loc3_ = ArrowDirection.UP;
         }
         else if(param2 == CalloutPosition.END)
         {
            _loc3_ = ArrowDirection.DOWN;
         }
         return _loc3_;
      }
      
      mx_internal function determinePosition(param1:String, param2:String, param3:Matrix, param4:Point) : Rectangle
      {
         var _loc5_:ILayoutElement = owner as ILayoutElement;
         var _loc6_:Number = !!_loc5_?Number(_loc5_.getLayoutBoundsWidth()):Number(owner.width);
         var _loc7_:Number = !!_loc5_?Number(_loc5_.getLayoutBoundsHeight()):Number(owner.height);
         var _loc8_:Number = getLayoutBoundsWidth();
         var _loc9_:Number = this.calloutHeight;
         switch(param1)
         {
            case CalloutPosition.BEFORE:
               param4.x = -_loc8_;
               break;
            case CalloutPosition.START:
               param4.x = 0;
               break;
            case CalloutPosition.END:
               param4.x = _loc6_ - _loc8_;
               break;
            case CalloutPosition.AFTER:
               param4.x = _loc6_;
               break;
            default:
               param4.x = Math.floor((_loc6_ - _loc8_) / 2);
         }
         switch(param2)
         {
            case CalloutPosition.BEFORE:
               param4.y = -_loc9_;
               break;
            case CalloutPosition.START:
               param4.y = 0;
               break;
            case CalloutPosition.MIDDLE:
               param4.y = Math.floor((_loc7_ - _loc9_) / 2);
               break;
            case CalloutPosition.END:
               param4.y = _loc7_ - _loc9_;
               break;
            default:
               param4.y = _loc7_;
         }
         var _loc10_:Point = param4.clone();
         var _loc11_:Point = MatrixUtil.transformBounds(_loc8_,_loc9_,param3,_loc10_);
         var _loc12_:Rectangle = new Rectangle();
         _loc12_.left = _loc10_.x;
         _loc12_.top = _loc10_.y;
         _loc12_.width = _loc11_.x;
         _loc12_.height = _loc11_.y;
         return _loc12_;
      }
      
      mx_internal function get isArrowVertical() : Boolean
      {
         return this.arrowDirection == ArrowDirection.UP || this.arrowDirection == ArrowDirection.DOWN;
      }
      
      private function arrow_resizeHandler(param1:Event) : void
      {
         this.updateSkinDisplayList();
      }
      
      private function systemManager_resizeHandler(param1:Event) : void
      {
         callLater(this.queued_systemManager_resizeHandler,[param1]);
      }
      
      private function queued_systemManager_resizeHandler(param1:Event) : void
      {
         softKeyboardEffectResetExplicitSize();
         this.invalidatePosition();
         if(!isSoftKeyboardEffectActive)
         {
            validateNow();
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get arrow() : UIComponent
      {
         return this._93090825arrow;
      }
      
      [SkinPart(required="false")]
      public function set arrow(param1:UIComponent) : void
      {
         var _loc2_:Object = this._93090825arrow;
         if(_loc2_ !== param1)
         {
            this._93090825arrow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrow",_loc2_,param1));
            }
         }
      }
   }
}
