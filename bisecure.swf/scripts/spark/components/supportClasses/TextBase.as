package spark.components.supportClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flashx.textLayout.compose.TextLineRecycler;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.core.IDisplayText;
   
   use namespace mx_internal;
   
   public class TextBase extends UIComponent implements IDisplayText
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      mx_internal static var truncationIndicatorResource:String;
      
      mx_internal static var createAccessibilityImplementation:Function;
       
      
      mx_internal var bounds:Rectangle;
      
      mx_internal var textLines:Vector.<DisplayObject>;
      
      mx_internal var isOverset:Boolean = false;
      
      mx_internal var hasScrollRect:Boolean = false;
      
      mx_internal var invalidateCompose:Boolean = true;
      
      mx_internal var _composeWidth:Number;
      
      mx_internal var _composeHeight:Number;
      
      private var _widthConstraint:Number = NaN;
      
      private var _measuredOneTextLine:Boolean = false;
      
      private var _backgroundShape:Shape;
      
      private var visibleChanged:Boolean = false;
      
      private var _isTruncated:Boolean = false;
      
      private var _maxDisplayedLines:int = 0;
      
      private var _showTruncationTip:Boolean = false;
      
      mx_internal var _text:String = "";
      
      public function TextBase()
      {
         this.bounds = new Rectangle(0,0,NaN,NaN);
         this.textLines = new Vector.<DisplayObject>();
         super();
         mouseChildren = false;
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         if(!truncationIndicatorResource)
         {
            truncationIndicatorResource = _loc1_.getString("core","truncationIndicator");
         }
         addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
         _loc1_.addEventListener(Event.CHANGE,this.resourceManager_changeHandler,false,0,true);
         this._backgroundShape = new Shape();
         addChild(this._backgroundShape);
      }
      
      override protected function initializeAccessibility() : void
      {
         if(TextBase.createAccessibilityImplementation != null)
         {
            TextBase.createAccessibilityImplementation(this);
         }
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(this.textLines.length == 0 || this.textLines.length == 1 && this.textLines[0] is Shape)
         {
            this.createEmptyTextLine(this._composeHeight);
         }
         return this.textLines.length > 0?Number(this.getBaselineFromFirstTextLine()):Number(0);
      }
      
      private function getBaselineFromFirstTextLine() : Number
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.textLines)
         {
            if(_loc1_ is TextLine)
            {
               return _loc1_.y;
            }
         }
         return 0;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.visibleChanged = true;
         invalidateDisplayList();
      }
      
      public function get isTruncated() : Boolean
      {
         return Boolean(this._isTruncated);
      }
      
      mx_internal function setIsTruncated(param1:Boolean) : void
      {
         if(this._isTruncated != param1)
         {
            this._isTruncated = param1;
            if(this.showTruncationTip)
            {
               toolTip = !!this._isTruncated?this.text:null;
            }
            dispatchEvent(new Event("isTruncatedChanged"));
         }
      }
      
      public function get maxDisplayedLines() : int
      {
         return this._maxDisplayedLines;
      }
      
      public function set maxDisplayedLines(param1:int) : void
      {
         if(param1 != this._maxDisplayedLines)
         {
            this._maxDisplayedLines = param1;
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get showTruncationTip() : Boolean
      {
         return this._showTruncationTip;
      }
      
      public function set showTruncationTip(param1:Boolean) : void
      {
         this._showTruncationTip = param1;
         toolTip = this._isTruncated && this._showTruncationTip?this.text:null;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(param1 != this._text)
         {
            this._text = param1;
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = !isNaN(this._widthConstraint)?Number(this._widthConstraint):Number(explicitWidth);
         var _loc2_:Number = getStyle("fontSize");
         var _loc3_:Boolean = this.composeTextLines(Math.max(_loc1_,_loc2_),Math.max(explicitHeight,_loc2_));
         invalidateDisplayList();
         var _loc4_:Number = Math.ceil(this.bounds.bottom);
         if(!isNaN(this._widthConstraint) && measuredHeight == _loc4_)
         {
            return;
         }
         super.measure();
         measuredWidth = Math.ceil(this.bounds.right);
         measuredHeight = _loc4_;
         this._measuredOneTextLine = _loc3_ && this.textLines.length == 1;
      }
      
      override public function setLayoutBoundsSize(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         super.setLayoutBoundsSize(param1,param2,param3);
         if(this._widthConstraint == param1)
         {
            return;
         }
         if(getStyle("lineBreak") == "explicit")
         {
            return;
         }
         if(canSkipMeasurement())
         {
            return;
         }
         if(!isNaN(explicitHeight))
         {
            return;
         }
         var _loc4_:Boolean = !isNaN(param1) && param1 != measuredWidth && param1 != 0;
         if(!_loc4_)
         {
            return;
         }
         if(this._measuredOneTextLine && param1 > measuredWidth)
         {
            return;
         }
         if(param3 && hasComplexLayoutMatrix)
         {
            return;
         }
         this._widthConstraint = param1;
         invalidateSize();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Number = Math.ceil(this.bounds.bottom);
         var _loc6_:Number = Math.ceil(this.bounds.right);
         if(this.invalidateCompose || this.composeForAlignStyles(param1,param2,_loc6_,_loc5_))
         {
            _loc3_ = true;
         }
         else if(param2 != _loc5_)
         {
            if(this.composeOnHeightChange(param2,_loc5_))
            {
               _loc3_ = true;
            }
            else if(param2 < _loc5_)
            {
               _loc4_ = true;
            }
         }
         if(!_loc3_ && param1 != _loc6_)
         {
            if(this.composeOnWidthChange(param1,_loc6_))
            {
               _loc3_ = true;
            }
            else if(getStyle("lineBreak") == "explicit" && param1 < _loc6_)
            {
               _loc4_ = true;
            }
         }
         if(_loc3_)
         {
            this.composeTextLines(param1,param2);
         }
         if(this.isOverset)
         {
            _loc4_ = true;
         }
         this.clip(_loc4_,param1,param2);
         var _loc7_:* = getStyle("backgroundColor");
         var _loc8_:Number = getStyle("backgroundAlpha");
         if(_loc7_ === undefined)
         {
            _loc7_ = 0;
            _loc8_ = 0;
         }
         var _loc9_:Graphics = this._backgroundShape.graphics;
         _loc9_.clear();
         _loc9_.beginFill(uint(_loc7_),_loc8_);
         _loc9_.drawRect(0,0,param1,param2);
         _loc9_.endFill();
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.invalidateTextLines();
      }
      
      mx_internal function createEmptyTextLine(param1:Number = NaN) : void
      {
      }
      
      mx_internal function invalidateTextLines() : void
      {
         this.invalidateCompose = true;
      }
      
      private function composeForAlignStyles(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc11_:* = false;
         var _loc5_:Number = !!isNaN(this._composeWidth)?Number(param3):Number(this._composeWidth);
         if(param1 != _loc5_)
         {
            _loc7_ = getStyle("direction");
            _loc8_ = getStyle("textAlign");
            _loc9_ = _loc8_ == "left" || _loc8_ == "start" && _loc7_ == "ltr" || _loc8_ == "end" && _loc7_ == "rtl";
            if(!_loc9_)
            {
               return true;
            }
         }
         var _loc6_:Number = !!isNaN(this._composeHeight)?Number(param4):Number(this._composeHeight);
         if(param2 != _loc6_)
         {
            _loc10_ = getStyle("verticalAlign");
            _loc11_ = _loc10_ == "top";
            if(!_loc11_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function composeOnHeightChange(param1:Number, param2:Number) : Boolean
      {
         if(param1 > param2 && (this.isOverset || !isNaN(this._composeHeight)))
         {
            return true;
         }
         if(this.maxDisplayedLines != 0 && getStyle("lineBreak") == "toFit")
         {
            if(this.maxDisplayedLines == -1)
            {
               return true;
            }
            if(this.maxDisplayedLines > 0 && (param1 < param2 || this.textLines.length != this.maxDisplayedLines))
            {
               return true;
            }
         }
         if(getStyle("blockProgression") != "tb")
         {
            return true;
         }
         return false;
      }
      
      private function composeOnWidthChange(param1:Number, param2:Number) : Boolean
      {
         if(getStyle("lineBreak") == "toFit")
         {
            if(isNaN(this._composeWidth) || this._composeWidth != param1)
            {
               return true;
            }
         }
         if(getStyle("blockProgression") != "tb")
         {
            return true;
         }
         return false;
      }
      
      mx_internal function composeTextLines(param1:Number = NaN, param2:Number = NaN) : Boolean
      {
         this._composeWidth = param1;
         this._composeHeight = param2;
         this.setIsTruncated(false);
         return false;
      }
      
      mx_internal function addTextLines() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:int = this.textLines.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc2_:int = _loc1_ - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this.textLines[_loc2_];
            $addChildAt(_loc3_,1);
            _loc2_--;
         }
      }
      
      mx_internal function removeTextLines() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:UIComponent = null;
         var _loc1_:int = this.textLines.length;
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.textLines[_loc2_];
            _loc4_ = _loc3_.parent as UIComponent;
            if(_loc4_)
            {
               UIComponent(_loc3_.parent).$removeChild(_loc3_);
            }
            _loc2_++;
         }
      }
      
      mx_internal function releaseTextLines(param1:Vector.<DisplayObject> = null) : void
      {
         var _loc4_:TextLine = null;
         if(!param1)
         {
            param1 = this.textLines;
         }
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_] as TextLine;
            if(_loc4_)
            {
               if(_loc4_.validity != TextLineValidity.INVALID && _loc4_.validity != TextLineValidity.STATIC)
               {
                  _loc4_.validity = TextLineValidity.INVALID;
               }
               _loc4_.userData = null;
               TextLineRecycler.addLineForReuse(_loc4_);
            }
            _loc3_++;
         }
         param1.length = 0;
      }
      
      mx_internal function isTextOverset(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Rectangle = new Rectangle(0,0,param1,param2);
         _loc3_.inflate(0.25,0.25);
         var _loc4_:Rectangle = this.bounds;
         var _loc5_:Boolean = _loc4_.top < _loc3_.top || _loc4_.left < _loc3_.left || !isNaN(_loc3_.bottom) && _loc4_.bottom > _loc3_.bottom || !isNaN(_loc3_.right) && _loc4_.right > _loc3_.right;
         return _loc5_;
      }
      
      mx_internal function clip(param1:Boolean, param2:Number, param3:Number) : void
      {
         var _loc4_:Rectangle = null;
         if(param1)
         {
            _loc4_ = scrollRect;
            if(_loc4_)
            {
               _loc4_.x = 0;
               _loc4_.y = 0;
               _loc4_.width = param2;
               _loc4_.height = param3;
            }
            else
            {
               _loc4_ = new Rectangle(0,0,param2,param3);
            }
            scrollRect = _loc4_;
            this.hasScrollRect = true;
         }
         else if(this.hasScrollRect)
         {
            scrollRect = null;
            this.hasScrollRect = false;
         }
      }
      
      mx_internal function getEmbeddedFontContext() : IFlexModuleFactory
      {
         var _loc1_:IFlexModuleFactory = null;
         var _loc3_:String = null;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc2_:String = getStyle("fontLookup");
         if(_loc2_ != FontLookup.DEVICE)
         {
            _loc3_ = getStyle("fontFamily");
            _loc4_ = getStyle("fontWeight") == "bold";
            _loc5_ = getStyle("fontStyle") == "italic";
            _loc1_ = getFontContext(_loc3_,_loc4_,_loc5_,true);
         }
         return _loc1_;
      }
      
      private function resourceManager_changeHandler(param1:Event) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         truncationIndicatorResource = _loc2_.getString("core","truncationIndicator");
         if(this.maxDisplayedLines != 0)
         {
            this.invalidateTextLines();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function updateCompleteHandler(param1:FlexEvent) : void
      {
         this._widthConstraint = NaN;
      }
   }
}
