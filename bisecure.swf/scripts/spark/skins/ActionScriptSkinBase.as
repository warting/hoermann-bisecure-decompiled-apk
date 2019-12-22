package spark.skins
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import mx.core.FlexGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.ILayoutElement;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.core.DisplayObjectSharingMode;
   import spark.core.IGraphicElement;
   
   use namespace mx_internal;
   
   public class ActionScriptSkinBase extends UIComponent implements IHighlightBitmapCaptureClient
   {
      
      mx_internal static const DEFAULT_SYMBOL_COLOR_VALUE:uint = 0;
      
      private static var _colorMatrix:Matrix = new Matrix();
      
      private static var _colorTransform:ColorTransform;
      
      private static var exclusionAlphaValues:Array;
      
      private static var oldContentBackgroundAlpha:Number;
      
      private static var contentBackgroundAlphaSetLocally:Boolean;
       
      
      protected var useSymbolColor:Boolean = false;
      
      mx_internal var useMinimumHitArea:Boolean = false;
      
      protected var measuredDefaultWidth:Number = 0;
      
      protected var measuredDefaultHeight:Number = 0;
      
      private var _currentState:String;
      
      public function ActionScriptSkinBase()
      {
         super();
      }
      
      mx_internal static function get colorMatrix() : Matrix
      {
         if(!_colorMatrix)
         {
            _colorMatrix = new Matrix();
         }
         return _colorMatrix;
      }
      
      mx_internal static function get colorTransform() : ColorTransform
      {
         if(!_colorTransform)
         {
            _colorTransform = new ColorTransform();
         }
         return _colorTransform;
      }
      
      protected function get applicationDPI() : Number
      {
         return FlexGlobals.topLevelApplication.applicationDPI;
      }
      
      protected function get symbolItems() : Array
      {
         return null;
      }
      
      override public function get currentState() : String
      {
         return this._currentState;
      }
      
      override public function set currentState(param1:String) : void
      {
         if(param1 != this._currentState)
         {
            this._currentState = param1;
            this.commitCurrentState();
         }
      }
      
      protected function commitCurrentState() : void
      {
      }
      
      override public function hasState(param1:String) : Boolean
      {
         return true;
      }
      
      override public function setCurrentState(param1:String, param2:Boolean = true) : void
      {
         this.currentState = param1;
      }
      
      override public function get measuredWidth() : Number
      {
         return Math.max(super.measuredWidth,this.measuredDefaultWidth);
      }
      
      override public function get measuredHeight() : Number
      {
         return Math.max(super.measuredHeight,this.measuredDefaultHeight);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         graphics.clear();
         super.updateDisplayList(param1,param2);
         this.layoutContents(param1,param2);
         if(this.useSymbolColor)
         {
            this.applySymbolColor();
         }
         if(this.useMinimumHitArea)
         {
            this.drawMinimumHitArea(param1,param2);
         }
         this.drawBackground(param1,param2);
      }
      
      override public function get explicitMinWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(parent is SkinnableComponent)
         {
            _loc1_ = SkinnableComponent(parent).explicitMinWidth;
            if(!isNaN(_loc1_))
            {
               return _loc1_;
            }
         }
         return super.explicitMinWidth;
      }
      
      override public function get explicitMinHeight() : Number
      {
         var _loc1_:Number = NaN;
         if(parent is SkinnableComponent)
         {
            _loc1_ = SkinnableComponent(parent).explicitMinHeight;
            if(!isNaN(_loc1_))
            {
               return _loc1_;
            }
         }
         return super.explicitMinHeight;
      }
      
      override public function get explicitMaxWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(parent is SkinnableComponent)
         {
            _loc1_ = SkinnableComponent(parent).explicitMaxWidth;
            if(!isNaN(_loc1_))
            {
               return _loc1_;
            }
         }
         return super.explicitMaxWidth;
      }
      
      override public function get explicitMaxHeight() : Number
      {
         var _loc1_:Number = NaN;
         if(parent is SkinnableComponent)
         {
            _loc1_ = SkinnableComponent(parent).explicitMaxHeight;
            if(!isNaN(_loc1_))
            {
               return _loc1_;
            }
         }
         return super.explicitMaxHeight;
      }
      
      mx_internal function drawMinimumHitArea(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.applicationDPI / 4;
         if(param1 > _loc3_ && param2 > _loc3_)
         {
            return;
         }
         var _loc4_:Number = Math.max(_loc3_,param1);
         var _loc5_:Number = Math.max(_loc3_,param2);
         var _loc6_:Number = (param1 - _loc4_) / 2;
         var _loc7_:Number = (param2 - _loc5_) / 2;
         graphics.beginFill(0,0);
         graphics.drawRect(_loc6_,_loc7_,_loc4_,_loc5_);
         graphics.endFill();
      }
      
      protected function layoutContents(param1:Number, param2:Number) : void
      {
      }
      
      protected function applyColorTransform(param1:DisplayObject, param2:uint, param3:uint) : void
      {
         colorTransform.redOffset = ((param3 & 255 << 16) >> 16) - ((param2 & 255 << 16) >> 16);
         colorTransform.greenOffset = ((param3 & 255 << 8) >> 8) - ((param2 & 255 << 8) >> 8);
         colorTransform.blueOffset = (param3 & 255) - (param2 & 255);
         colorTransform.alphaMultiplier = alpha;
         param1.transform.colorTransform = colorTransform;
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
      }
      
      mx_internal function applySymbolColor() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc1_:Array = this.symbolItems;
         var _loc2_:uint = !!_loc1_?uint(_loc1_.length):uint(0);
         if(_loc2_ > 0)
         {
            _loc3_ = getStyle("symbolColor");
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               _loc4_ = this[_loc1_[_loc6_]];
               if(_loc4_ is DisplayObject)
               {
                  if(!_loc5_)
                  {
                     colorTransform.redOffset = ((_loc3_ & 255 << 16) >> 16) - DEFAULT_SYMBOL_COLOR_VALUE;
                     colorTransform.greenOffset = ((_loc3_ & 255 << 8) >> 8) - DEFAULT_SYMBOL_COLOR_VALUE;
                     colorTransform.blueOffset = (_loc3_ & 255) - DEFAULT_SYMBOL_COLOR_VALUE;
                     colorTransform.alphaMultiplier = alpha;
                     _loc5_ = true;
                  }
                  DisplayObject(_loc4_).transform.colorTransform = colorTransform;
               }
               _loc6_++;
            }
         }
      }
      
      protected function setElementPosition(param1:Object, param2:Number, param3:Number) : void
      {
         if(param1 is ILayoutElement)
         {
            ILayoutElement(param1).setLayoutBoundsPosition(param2,param3,false);
         }
         else if(param1 is IFlexDisplayObject)
         {
            IFlexDisplayObject(param1).move(param2,param3);
         }
         else
         {
            param1.x = param2;
            param1.y = param3;
         }
      }
      
      protected function setElementSize(param1:Object, param2:Number, param3:Number) : void
      {
         if(param1 is ILayoutElement)
         {
            ILayoutElement(param1).setLayoutBoundsSize(param2,param3,false);
         }
         else if(param1 is IFlexDisplayObject)
         {
            IFlexDisplayObject(param1).setActualSize(param2,param3);
         }
         else
         {
            param1.width = param2;
            param1.height = param3;
         }
      }
      
      protected function getElementPreferredWidth(param1:Object) : Number
      {
         if(param1 is ILayoutElement)
         {
            return ILayoutElement(param1).getPreferredBoundsWidth();
         }
         if(param1 is IFlexDisplayObject)
         {
            return IFlexDisplayObject(param1).measuredWidth;
         }
         return param1.width;
      }
      
      protected function getElementPreferredHeight(param1:Object) : Number
      {
         if(param1 is ILayoutElement)
         {
            return ILayoutElement(param1).getPreferredBoundsHeight();
         }
         if(param1 is IFlexDisplayObject)
         {
            return IFlexDisplayObject(param1).measuredHeight;
         }
         return param1.height;
      }
      
      protected function get focusSkinExclusions() : Array
      {
         return null;
      }
      
      public function beginHighlightBitmapCapture() : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:IGraphicElement = null;
         var _loc1_:Array = this.focusSkinExclusions;
         if(!_loc1_)
         {
            if("hostComponent" in this && this["hostComponent"] is SkinnableComponent)
            {
               _loc1_ = SkinnableComponent(this["hostComponent"]).suggestedFocusSkinExclusions;
            }
         }
         var _loc2_:Number = _loc1_ == null?Number(0):Number(_loc1_.length);
         exclusionAlphaValues = [];
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc1_[_loc4_] in this)
            {
               _loc5_ = this[_loc1_[_loc4_]];
               if(_loc5_ is UIComponent)
               {
                  exclusionAlphaValues[_loc4_] = (_loc5_ as UIComponent).$alpha;
                  (_loc5_ as UIComponent).$alpha = 0;
               }
               else if(_loc5_ is DisplayObject)
               {
                  exclusionAlphaValues[_loc4_] = (_loc5_ as DisplayObject).alpha;
                  (_loc5_ as DisplayObject).alpha = 0;
               }
               else if(_loc5_ is IGraphicElement)
               {
                  _loc6_ = _loc5_ as IGraphicElement;
                  if(_loc6_.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
                  {
                     exclusionAlphaValues[_loc4_] = _loc6_.displayObject.alpha;
                     _loc6_.displayObject.alpha = 0;
                  }
                  else
                  {
                     exclusionAlphaValues[_loc4_] = _loc6_.alpha;
                     _loc6_.alpha = 0;
                     _loc3_ = true;
                  }
               }
            }
            _loc4_++;
         }
         if(getStyle("contentBackgroundAlpha") < 0.5)
         {
            if(styleDeclaration && styleDeclaration.getStyle("contentBackgroundAlpha") !== null)
            {
               contentBackgroundAlphaSetLocally = true;
            }
            else
            {
               contentBackgroundAlphaSetLocally = false;
            }
            oldContentBackgroundAlpha = getStyle("contentBackgroundAlpha");
            setStyle("contentBackgroundAlpha",0.5);
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function endHighlightBitmapCapture() : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:IGraphicElement = null;
         var _loc1_:Array = this.focusSkinExclusions;
         if(!_loc1_)
         {
            if("hostComponent" in this && this["hostComponent"] is SkinnableComponent)
            {
               _loc1_ = SkinnableComponent(this["hostComponent"]).suggestedFocusSkinExclusions;
            }
         }
         var _loc2_:Number = _loc1_ == null?Number(0):Number(_loc1_.length);
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc1_[_loc4_] in this)
            {
               _loc5_ = this[_loc1_[_loc4_]];
               if(_loc5_ is UIComponent)
               {
                  (_loc5_ as UIComponent).$alpha = exclusionAlphaValues[_loc4_];
               }
               else if(_loc5_ is DisplayObject)
               {
                  (_loc5_ as DisplayObject).alpha = exclusionAlphaValues[_loc4_];
               }
               else if(_loc5_ is IGraphicElement)
               {
                  _loc6_ = _loc5_ as IGraphicElement;
                  if(_loc6_.displayObjectSharingMode == DisplayObjectSharingMode.OWNS_UNSHARED_OBJECT)
                  {
                     _loc6_.displayObject.alpha = exclusionAlphaValues[_loc4_];
                  }
                  else
                  {
                     _loc6_.alpha = exclusionAlphaValues[_loc4_];
                     _loc3_ = true;
                  }
               }
            }
            _loc4_++;
         }
         exclusionAlphaValues = null;
         if(!isNaN(oldContentBackgroundAlpha))
         {
            if(contentBackgroundAlphaSetLocally)
            {
               setStyle("contentBackgroundAlpha",oldContentBackgroundAlpha);
            }
            else
            {
               clearStyle("contentBackgroundAlpha");
            }
            _loc3_ = true;
            oldContentBackgroundAlpha = NaN;
         }
         return _loc3_;
      }
   }
}
