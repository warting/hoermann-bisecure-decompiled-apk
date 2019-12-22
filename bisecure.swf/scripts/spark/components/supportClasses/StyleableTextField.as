package spark.components.supportClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.events.TextEvent;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.text.Font;
   import flash.text.FontType;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextInteractionMode;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import mx.core.DesignLayer;
   import mx.core.FlexGlobals;
   import mx.core.FlexTextField;
   import mx.core.IInvalidating;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.TouchInteractionEvent;
   import mx.events.TouchInteractionReason;
   import mx.geom.TransformOffsets;
   import mx.managers.SystemManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.IStyleClient;
   import mx.utils.MatrixUtil;
   import spark.components.Application;
   import spark.components.Scroller;
   import spark.core.IEditableText;
   import spark.events.TextOperationEvent;
   
   use namespace mx_internal;
   
   public class StyleableTextField extends FlexTextField implements IEditableText, ISimpleStyleClient, IVisualElement
   {
      
      private static var truncationIndicatorResource:String;
      
      private static var supportedStyles:String = "textAlign fontFamily fontWeight fontStyle color fontSize textDecoration textIndent leading letterSpacing";
      
      private static var textFormat:TextFormat = new TextFormat();
      
      private static var embeddedFonts:Array;
      
      private static var textTopOffsetTable:Dictionary = new Dictionary();
      
      private static var decomposition:Vector.<Number> = new <Number>[0,0,0,0,0];
      
      mx_internal static const TEXT_WIDTH_PADDING:int = 5;
      
      mx_internal static const TEXT_GUTTER:int = 2;
      
      mx_internal static const TEXT_HEIGHT_PADDING:int = 4;
       
      
      private var _colorName:String = "color";
      
      private var _styleDeclaration:CSSStyleDeclaration;
      
      private var _styleName:Object;
      
      public var minHeight:Number;
      
      public var minWidth:Number;
      
      private var _focusEnabled:Boolean = true;
      
      private var _enabled:Boolean = true;
      
      private var _bottom:Object;
      
      private var _left:Object;
      
      private var _right:Object;
      
      private var _top:Object;
      
      private var _inlineStyleObject:Object;
      
      mx_internal var useTightTextBounds:Boolean = true;
      
      mx_internal var scrollToRangeDelegate:Function;
      
      mx_internal var leftMargin:Object;
      
      mx_internal var rightMargin:Object;
      
      private var invalidateStyleFlag:Boolean = true;
      
      private var _isTruncated:Boolean = false;
      
      private var invalidateTextSizeFlag:Boolean = false;
      
      private var _measuredTextSize:Point;
      
      private var invalidateBaselinePosition:Boolean = true;
      
      private var _baselinePosition:Number;
      
      private var invalidateTightTextHeight:Boolean = true;
      
      private var _tightTextHeight:Number;
      
      private var _tightTextTopOffset:Number;
      
      private var scrollerInTextSelectionMode:Scroller;
      
      public function StyleableTextField()
      {
         super();
         doubleClickEnabled = true;
         this.width = 400;
         addEventListener(Event.CHANGE,this.changeHandler,false,100);
         addEventListener(TextEvent.TEXT_INPUT,this.textInputHandler);
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_STARTING,this.touchInteractionStartingHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_START,this.touchInteractionStartHandler);
         addEventListener(TouchInteractionEvent.TOUCH_INTERACTION_END,this.touchInteractionEndHandler);
         if(!truncationIndicatorResource)
         {
            truncationIndicatorResource = ResourceManager.getInstance().getString("core","truncationIndicator");
         }
      }
      
      private static function getTextTopOffset(param1:TextFormat, param2:StyleSheet = null) : Number
      {
         var _loc5_:TextField = null;
         var _loc6_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:String = param1.font + "_" + param1.size + "_" + param1.bold + "_" + param1.italic;
         var _loc4_:Number = textTopOffsetTable[_loc3_];
         if(isNaN(_loc4_))
         {
            _loc4_ = StyleableTextField.TEXT_HEIGHT_PADDING / 2;
            _loc5_ = new TextField();
            if(param2)
            {
               _loc5_.styleSheet = param2;
            }
            else
            {
               _loc5_.defaultTextFormat = param1;
            }
            _loc5_.embedFonts = isFontEmbedded(param1);
            _loc5_.textColor = 0;
            _loc5_.text = "T";
            if(_loc5_.textWidth > 0 && _loc5_.textHeight > 0)
            {
               _loc5_.width = _loc5_.textWidth;
               _loc5_.height = _loc5_.textHeight;
               _loc6_ = new BitmapData(_loc5_.width,_loc5_.height);
               _loc6_.draw(_loc5_);
               _loc7_ = Math.round(_loc6_.width / 2);
               _loc8_ = 0;
               while(_loc8_ < _loc6_.height)
               {
                  if(_loc6_.getPixel(_loc7_,_loc8_) != 16777215)
                  {
                     break;
                  }
                  _loc8_++;
               }
               if(_loc8_ < _loc6_.height)
               {
                  _loc4_ = _loc8_;
               }
            }
            textTopOffsetTable[_loc3_] = _loc4_;
         }
         return _loc4_;
      }
      
      private static function isFontEmbedded(param1:TextFormat) : Boolean
      {
         var _loc3_:Font = null;
         var _loc4_:String = null;
         if(!embeddedFonts)
         {
            embeddedFonts = Font.enumerateFonts();
         }
         var _loc2_:int = 0;
         while(_loc2_ < embeddedFonts.length)
         {
            _loc3_ = Font(embeddedFonts[_loc2_]);
            if(_loc3_.fontName == param1.font && _loc3_.fontType != FontType.EMBEDDED_CFF)
            {
               _loc4_ = "regular";
               if(param1.bold && param1.italic)
               {
                  _loc4_ = "boldItalic";
               }
               else if(param1.bold)
               {
                  _loc4_ = "bold";
               }
               else if(param1.italic)
               {
                  _loc4_ = "italic";
               }
               if(_loc3_.fontStyle == _loc4_)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(multiline)
         {
            this.invalidateTightTextHeight = true;
            this.invalidateTextSizeFlag = true;
         }
      }
      
      mx_internal function set colorName(param1:String) : void
      {
         if(this._colorName == param1)
         {
            return;
         }
         this._colorName = param1;
         this.invalidateStyleFlag = true;
      }
      
      mx_internal function get colorName() : String
      {
         return this._colorName;
      }
      
      mx_internal function get measuredTextSize() : Point
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Application = null;
         var _loc4_:SystemManager = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.commitStyles();
         if(!this._measuredTextSize)
         {
            this._measuredTextSize = new Point();
            this.invalidateTextSizeFlag = true;
            this.invalidateTightTextHeight = true;
         }
         if(this.invalidateTextSizeFlag)
         {
            _loc1_ = 1;
            _loc2_ = 1;
            if(!stage)
            {
               _loc3_ = FlexGlobals.topLevelApplication as Application;
               _loc4_ = !!_loc3_?_loc3_.systemManager as SystemManager:null;
               if(_loc4_)
               {
                  _loc1_ = _loc4_.densityScale;
                  _loc2_ = _loc4_.densityScale;
               }
            }
            else
            {
               MatrixUtil.decomposeMatrix(decomposition,transform.concatenatedMatrix,0,0);
               _loc1_ = decomposition[3];
               _loc2_ = decomposition[4];
            }
            if(embedFonts || _loc1_ == 1 && _loc2_ == 1)
            {
               this._measuredTextSize.x = textWidth + TEXT_WIDTH_PADDING;
               this._measuredTextSize.y = textHeight + TEXT_HEIGHT_PADDING;
               if(!multiline)
               {
                  this._measuredTextSize.x = this._measuredTextSize.x + this.getStyle("textIndent");
               }
            }
            else
            {
               _loc5_ = width;
               _loc6_ = height;
               _loc7_ = autoSize;
               autoSize = TextFieldAutoSize.LEFT;
               if(!stage)
               {
                  _loc8_ = this.scaleX;
                  _loc9_ = this.scaleY;
                  this.scaleX = this.scaleX * _loc1_;
                  this.scaleY = this.scaleY * _loc2_;
                  this._measuredTextSize.x = width / _loc1_;
                  this._measuredTextSize.y = height / _loc2_;
                  this.scaleX = _loc8_;
                  this.scaleY = _loc9_;
               }
               else
               {
                  this._measuredTextSize.x = width;
                  this._measuredTextSize.y = height;
               }
               autoSize = _loc7_;
               if(autoSize == TextFieldAutoSize.NONE)
               {
                  super.width = _loc5_;
                  super.height = _loc6_;
               }
            }
            if(numLines > 1)
            {
               this._measuredTextSize.y = this._measuredTextSize.y + this.getStyle("leading");
            }
            this._measuredTextSize.x = Math.ceil(this._measuredTextSize.x);
            this._measuredTextSize.y = Math.ceil(this._measuredTextSize.y);
            this.invalidateTextSizeFlag = false;
         }
         return this._measuredTextSize;
      }
      
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return this._styleDeclaration;
      }
      
      public function set styleDeclaration(param1:CSSStyleDeclaration) : void
      {
         this._styleDeclaration = param1;
      }
      
      public function get styleName() : Object
      {
         if(this._styleName)
         {
            return this._styleName;
         }
         if(parent is IStyleClient)
         {
            return parent;
         }
         return null;
      }
      
      public function set styleName(param1:Object) : void
      {
         if(this._styleName === param1)
         {
            return;
         }
         this._styleName = param1;
         this.styleChanged("styleName");
      }
      
      private function get tightTextTopOffset() : Number
      {
         this.updateTightTextSizes();
         return this._tightTextTopOffset;
      }
      
      private function get tightTextHeight() : Number
      {
         this.updateTightTextSizes();
         return this._tightTextHeight;
      }
      
      private function updateTightTextSizes() : void
      {
         var _loc1_:* = false;
         var _loc2_:TextLineMetrics = null;
         var _loc3_:Number = NaN;
         this.commitStyles();
         if(this.invalidateTightTextHeight)
         {
            _loc1_ = this.text == "";
            if(_loc1_)
            {
               this.text = "Wj";
            }
            _loc2_ = getLineMetrics(0);
            _loc3_ = StyleableTextField.TEXT_HEIGHT_PADDING / 2 + _loc2_.descent;
            if(numLines == 1)
            {
               _loc3_ = _loc3_ + _loc2_.leading;
            }
            this._tightTextTopOffset = getTextTopOffset(defaultTextFormat,styleSheet);
            this._tightTextHeight = this.measuredTextSize.y - this._tightTextTopOffset - _loc3_;
            if(_loc1_)
            {
               this.text = "";
            }
            this.invalidateTightTextHeight = false;
         }
      }
      
      override public function get text() : String
      {
         return super.text;
      }
      
      override public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         super.text = param1;
         this._isTruncated = false;
         this.invalidateTextSizeFlag = true;
         this.invalidateTightTextHeight = true;
         if(hasEventListener(FlexEvent.VALUE_COMMIT))
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      mx_internal final function get $text() : String
      {
         return super.text;
      }
      
      mx_internal final function set $text(param1:String) : void
      {
         super.text = param1;
      }
      
      public function get isTruncated() : Boolean
      {
         return this._isTruncated;
      }
      
      public function get editable() : Boolean
      {
         return type == TextFieldType.INPUT;
      }
      
      public function set editable(param1:Boolean) : void
      {
         if(param1 == this.editable)
         {
            return;
         }
         type = !!param1?TextFieldType.INPUT:TextFieldType.DYNAMIC;
         this.invalidateTightTextHeight = true;
         this.invalidateTextSizeFlag = true;
         dispatchEvent(new Event("editableChanged"));
      }
      
      public function get focusEnabled() : Boolean
      {
         return this._focusEnabled;
      }
      
      public function set focusEnabled(param1:Boolean) : void
      {
         this._focusEnabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = mouseEnabled = param1;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return scrollH;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         scrollH = Math.min(Math.max(0,int(param1)),maxScrollH);
      }
      
      public function get lineBreak() : String
      {
         return !!wordWrap?"toFit":"explicit";
      }
      
      public function set lineBreak(param1:String) : void
      {
         wordWrap = param1 != "explicit";
      }
      
      public function get selectionActivePosition() : int
      {
         return selectionEndIndex;
      }
      
      public function get selectionAnchorPosition() : int
      {
         return selectionBeginIndex;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return scrollV;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         scrollV = Math.min(Math.max(0,int(param1)),maxScrollV);
      }
      
      public function scrollToRange(param1:int, param2:int) : void
      {
         if(this.scrollToRangeDelegate != null)
         {
            this.scrollToRangeDelegate(param1,param2);
            return;
         }
         if(getCharBoundaries(param1) || getCharBoundaries(param2))
         {
            return;
         }
         this.verticalScrollPosition = getLineIndexOfChar(param1);
      }
      
      public function insertText(param1:String) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:String = null;
         if(styleSheet)
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = _loc2_.getString("components","styleSheetError");
            throw new Error(_loc3_);
         }
         replaceText(this.selectionAnchorPosition,this.selectionActivePosition,param1);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         this.invalidateTextSizeFlag = true;
         this.invalidateTightTextHeight = true;
      }
      
      override public function appendText(param1:String) : void
      {
         super.appendText(param1);
         var _loc2_:int = this.text.length;
         setSelection(_loc2_,_loc2_);
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         this.invalidateTextSizeFlag = true;
         this.invalidateTightTextHeight = true;
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         setSelection(Math.min(param1,param2),Math.max(param1,param2));
      }
      
      public function selectAll() : void
      {
         setSelection(0,length);
      }
      
      public function setFocus() : void
      {
         if(stage && stage.focus != this)
         {
            stage.focus = this;
         }
         if(selectable == false)
         {
            setSelection(0,0);
         }
         if(this.editable)
         {
            requestSoftKeyboard();
         }
      }
      
      public function commitStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         if(this.invalidateStyleFlag)
         {
            _loc1_ = this.getStyle("textAlign");
            if(_loc1_ == "start")
            {
               _loc1_ = TextFormatAlign.LEFT;
            }
            if(_loc1_ == "end")
            {
               _loc1_ = TextFormatAlign.RIGHT;
            }
            textFormat.align = _loc1_;
            textFormat.font = this.getStyle("fontFamily");
            textFormat.bold = this.getStyle("fontWeight") == "bold";
            textFormat.color = this.getStyle(this.colorName);
            textFormat.size = this.getStyle("fontSize");
            textFormat.italic = this.getStyle("fontStyle") == "italic";
            textFormat.underline = this.getStyle("textDecoration") == "underline";
            textFormat.indent = this.getStyle("textIndent");
            textFormat.leading = this.getStyle("leading");
            textFormat.letterSpacing = this.getStyle("letterSpacing");
            _loc2_ = this.getStyle("kerning");
            if(_loc2_ == "auto" || _loc2_ == "on")
            {
               _loc2_ = true;
            }
            else if(_loc2_ == "default" || _loc2_ == "off")
            {
               _loc2_ = false;
            }
            textFormat.kerning = _loc2_;
            antiAliasType = this.getStyle("fontAntiAliasType");
            gridFitType = this.getStyle("fontGridFitType");
            sharpness = this.getStyle("fontSharpness");
            thickness = this.getStyle("fontThickness");
            textFormat.leftMargin = this.leftMargin;
            textFormat.rightMargin = this.rightMargin;
            embedFonts = isFontEmbedded(textFormat);
            if(!styleSheet)
            {
               defaultTextFormat = textFormat;
               setTextFormat(textFormat);
            }
            if(this.text == "")
            {
               this.width = textFormat.size + TEXT_WIDTH_PADDING;
            }
            this.invalidateStyleFlag = false;
            this.invalidateTextSizeFlag = true;
            this.invalidateBaselinePosition = true;
            this.invalidateTightTextHeight = true;
         }
      }
      
      public function getStyle(param1:String) : *
      {
         if(this._inlineStyleObject && this._inlineStyleObject[param1] !== undefined)
         {
            return this._inlineStyleObject[param1];
         }
         if(this.styleDeclaration && this.styleDeclaration.getStyle(param1) !== undefined)
         {
            return this.styleDeclaration.getStyle(param1);
         }
         if(this.styleName is IStyleClient)
         {
            return IStyleClient(this.styleName).getStyle(param1);
         }
         return undefined;
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         if(!this._inlineStyleObject)
         {
            this._inlineStyleObject = {};
         }
         if(param2 == null)
         {
            delete this._inlineStyleObject[param1];
         }
         else
         {
            this._inlineStyleObject[param1] = param2;
         }
         this.styleChanged(param1);
      }
      
      public function styleChanged(param1:String) : void
      {
         if(param1 == null || param1 == "styleName" || supportedStyles.indexOf(param1) >= 0 || param1 == this.colorName)
         {
            this.invalidateStyleFlag = true;
         }
      }
      
      public function truncateToFit(param1:String = "...") : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         if(!param1)
         {
            param1 = truncationIndicatorResource;
         }
         var _loc2_:String = super.text;
         var _loc3_:Boolean = this._isTruncated;
         var _loc4_:Number = width;
         if(this.leftMargin is Number)
         {
            _loc4_ = _loc4_ - Number(this.leftMargin);
         }
         if(this.rightMargin is Number)
         {
            _loc4_ = _loc4_ - Number(this.rightMargin);
         }
         this._isTruncated = false;
         if(_loc2_ != "" && this.measuredTextSize.x > _loc4_ + 1.0e-14)
         {
            _loc5_ = _loc2_;
            _loc5_ = _loc2_.slice(0,Math.floor(_loc4_ / (textWidth + TEXT_WIDTH_PADDING) * _loc2_.length));
            while(_loc5_.length > 1 && this.measuredTextSize.x > _loc4_)
            {
               _loc5_ = _loc5_.slice(0,-1);
               super.text = _loc5_ + param1;
               this.invalidateTextSizeFlag = true;
            }
            _loc6_ = _loc2_.length;
            _loc7_ = _loc5_;
            while(_loc7_.length < _loc6_)
            {
               _loc7_ = _loc2_.slice(0,_loc7_.length + 1);
               super.text = _loc7_ + param1;
               this.invalidateTextSizeFlag = true;
               if(this.measuredTextSize.x + TEXT_WIDTH_PADDING <= _loc4_)
               {
                  _loc5_ = _loc7_;
                  continue;
               }
               break;
            }
            if(_loc5_.length > 0)
            {
               super.text = _loc5_ + param1;
            }
            this._isTruncated = true;
            this.invalidateBaselinePosition = true;
            this.invalidateTightTextHeight = true;
            scrollH = 0;
         }
         if(this._isTruncated != _loc3_)
         {
            if(hasEventListener("isTruncatedChanged"))
            {
               dispatchEvent(new Event("isTruncatedChanged"));
            }
         }
         return this._isTruncated;
      }
      
      private function changeHandler(param1:Event) : void
      {
         var _loc2_:TextOperationEvent = null;
         if(!(param1 is TextOperationEvent))
         {
            this.invalidateTextSizeFlag = true;
            this.invalidateTightTextHeight = true;
            _loc2_ = new TextOperationEvent(param1.type);
            param1.stopImmediatePropagation();
            dispatchEvent(_loc2_);
         }
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FlexEvent(FlexEvent.ENTER));
         }
      }
      
      private function textInputHandler(param1:TextEvent) : void
      {
         var _loc2_:TextOperationEvent = new TextOperationEvent(TextOperationEvent.CHANGING);
         var _loc3_:TextInputOperation = new TextInputOperation();
         _loc3_.text = param1.text;
         _loc2_.operation = _loc3_;
         if(!dispatchEvent(_loc2_))
         {
            param1.preventDefault();
         }
      }
      
      private function touchInteractionStartingHandler(param1:TouchInteractionEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Scroller = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         if(textInteractionMode == TextInteractionMode.SELECTION)
         {
            _loc2_ = this.getStyle("focusThickness");
            _loc3_ = param1.relatedObject as Scroller;
            if(param1.reason != TouchInteractionReason.SCROLL || !_loc3_)
            {
               return;
            }
            if(this.scrollerInTextSelectionMode)
            {
               param1.preventDefault();
               return;
            }
            _loc8_ = new Point(0,0);
            _loc8_.offset(-x,-y);
            _loc8_.offset(-_loc2_,-_loc2_);
            _loc8_ = localToGlobal(_loc8_);
            _loc8_ = DisplayObject(_loc3_.viewport).globalToLocal(_loc8_);
            _loc6_ = Math.max(0,_loc8_.x);
            _loc4_ = Math.max(0,_loc8_.y);
            _loc8_.x = width;
            _loc8_.y = height;
            _loc8_.offset(x,y);
            _loc8_.offset(_loc2_,_loc2_);
            _loc8_ = parent.localToGlobal(_loc8_);
            _loc8_ = DisplayObject(_loc3_.viewport).globalToLocal(_loc8_);
            _loc7_ = _loc8_.x - _loc3_.width;
            _loc5_ = _loc8_.y - _loc3_.height;
            this.scrollerInTextSelectionMode = _loc3_;
            _loc3_.enableTextSelectionAutoScroll(true,_loc6_,_loc7_,_loc4_,_loc5_);
         }
      }
      
      private function touchInteractionStartHandler(param1:TouchInteractionEvent) : void
      {
         addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.softKeyboardActivatingHandler);
      }
      
      private function touchInteractionEndHandler(param1:TouchInteractionEvent) : void
      {
         var _loc2_:Scroller = null;
         removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.softKeyboardActivatingHandler);
         if(textInteractionMode == TextInteractionMode.SELECTION)
         {
            _loc2_ = param1.relatedObject as Scroller;
            this.scrollerInTextSelectionMode = null;
            if(_loc2_)
            {
               _loc2_.enableTextSelectionAutoScroll(false);
            }
         }
      }
      
      private function softKeyboardActivatingHandler(param1:SoftKeyboardEvent) : void
      {
         var _loc2_:Application = FlexGlobals.topLevelApplication as Application;
         if(!(_loc2_ && _loc2_.isSoftKeyboardActive))
         {
            param1.preventDefault();
         }
      }
      
      public function getBoundsXAtSize(param1:Number, param2:Number, param3:Boolean = true) : Number
      {
         return x;
      }
      
      public function getBoundsYAtSize(param1:Number, param2:Number, param3:Boolean = true) : Number
      {
         return y;
      }
      
      public function getLayoutBoundsHeight(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return height - (this.measuredTextSize.y - this.tightTextHeight);
         }
         return height;
      }
      
      public function getLayoutBoundsWidth(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return width - StyleableTextField.TEXT_GUTTER * 2;
         }
         return width;
      }
      
      public function getLayoutBoundsX(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return x + StyleableTextField.TEXT_GUTTER;
         }
         return x;
      }
      
      public function getLayoutBoundsY(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return y + this.tightTextTopOffset;
         }
         return y;
      }
      
      public function getLayoutMatrix() : Matrix
      {
         return transform.matrix;
      }
      
      public function getLayoutMatrix3D() : Matrix3D
      {
         return transform.matrix3D;
      }
      
      public function getMaxBoundsHeight(param1:Boolean = true) : Number
      {
         return UIComponent.DEFAULT_MAX_WIDTH;
      }
      
      public function getMaxBoundsWidth(param1:Boolean = true) : Number
      {
         return UIComponent.DEFAULT_MAX_WIDTH;
      }
      
      public function getMinBoundsHeight(param1:Boolean = true) : Number
      {
         return !!isNaN(this.minHeight)?Number(0):Number(this.minHeight);
      }
      
      public function getMinBoundsWidth(param1:Boolean = true) : Number
      {
         return !!isNaN(this.minWidth)?Number(0):Number(this.minWidth);
      }
      
      public function getPreferredBoundsHeight(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return this.tightTextHeight;
         }
         return this.measuredTextSize.y;
      }
      
      public function getPreferredBoundsWidth(param1:Boolean = true) : Number
      {
         if(this.useTightTextBounds)
         {
            return this.measuredTextSize.x - StyleableTextField.TEXT_GUTTER * 2;
         }
         return this.measuredTextSize.x;
      }
      
      public function invalidateLayoutDirection() : void
      {
      }
      
      public function setLayoutBoundsPosition(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         if(this.useTightTextBounds)
         {
            this.x = param1 - StyleableTextField.TEXT_GUTTER;
            this.y = param2 - this.tightTextTopOffset;
         }
         else
         {
            this.x = param1;
            this.y = param2;
         }
      }
      
      public function setLayoutBoundsSize(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         var _loc6_:Number = NaN;
         var _loc4_:Number = param1;
         if(isNaN(_loc4_))
         {
            _loc4_ = this.getPreferredBoundsWidth();
         }
         if(this.useTightTextBounds)
         {
            _loc4_ = _loc4_ + StyleableTextField.TEXT_WIDTH_PADDING;
         }
         this.width = _loc4_;
         var _loc5_:Number = param2;
         if(isNaN(_loc5_))
         {
            _loc5_ = this.getPreferredBoundsHeight();
         }
         if(this.useTightTextBounds)
         {
            if(_loc5_ > 0)
            {
               _loc6_ = this.measuredTextSize.y - this.tightTextTopOffset - this.tightTextHeight;
               if(_loc5_ < this.tightTextHeight)
               {
                  _loc6_ = StyleableTextField.TEXT_HEIGHT_PADDING;
               }
               _loc5_ = _loc5_ + (this.tightTextTopOffset + _loc6_);
            }
         }
         this.height = _loc5_;
      }
      
      public function setLayoutMatrix(param1:Matrix, param2:Boolean) : void
      {
      }
      
      public function setLayoutMatrix3D(param1:Matrix3D, param2:Boolean) : void
      {
      }
      
      public function transformAround(param1:Vector3D, param2:Vector3D = null, param3:Vector3D = null, param4:Vector3D = null, param5:Vector3D = null, param6:Vector3D = null, param7:Vector3D = null, param8:Boolean = true) : void
      {
      }
      
      public function get layoutDirection() : String
      {
         return null;
      }
      
      public function set layoutDirection(param1:String) : void
      {
      }
      
      public function get baseline() : Object
      {
         return null;
      }
      
      public function set baseline(param1:Object) : void
      {
      }
      
      public function get baselinePosition() : Number
      {
         var _loc1_:* = false;
         this.commitStyles();
         if(this.invalidateBaselinePosition)
         {
            if(this.useTightTextBounds)
            {
               this._baselinePosition = this.tightTextHeight;
            }
            else
            {
               _loc1_ = this.text == "";
               if(_loc1_)
               {
                  super.text = "Wj";
               }
               this._baselinePosition = getLineMetrics(0).ascent + StyleableTextField.TEXT_HEIGHT_PADDING / 2;
               if(_loc1_)
               {
                  super.text = "";
               }
            }
            this.invalidateBaselinePosition = false;
         }
         return this._baselinePosition;
      }
      
      public function get bottom() : Object
      {
         return this._bottom;
      }
      
      public function set bottom(param1:Object) : void
      {
         if(this._bottom == param1)
         {
            return;
         }
         this._bottom = param1;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get hasLayoutMatrix3D() : Boolean
      {
         return false;
      }
      
      public function get horizontalCenter() : Object
      {
         return null;
      }
      
      public function set horizontalCenter(param1:Object) : void
      {
      }
      
      public function get includeInLayout() : Boolean
      {
         return true;
      }
      
      public function set includeInLayout(param1:Boolean) : void
      {
      }
      
      public function get left() : Object
      {
         return this._left;
      }
      
      public function set left(param1:Object) : void
      {
         if(this._left == param1)
         {
            return;
         }
         this._left = param1;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get percentHeight() : Number
      {
         return NaN;
      }
      
      public function set percentHeight(param1:Number) : void
      {
      }
      
      public function get percentWidth() : Number
      {
         return NaN;
      }
      
      public function set percentWidth(param1:Number) : void
      {
      }
      
      public function get right() : Object
      {
         return this._right;
      }
      
      public function set right(param1:Object) : void
      {
         if(this._right == param1)
         {
            return;
         }
         this._right = param1;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get top() : Object
      {
         return this._top;
      }
      
      public function set top(param1:Object) : void
      {
         if(this._top == param1)
         {
            return;
         }
         this._top = param1;
         this.invalidateParentSizeAndDisplayList();
      }
      
      public function get verticalCenter() : Object
      {
         return null;
      }
      
      public function set verticalCenter(param1:Object) : void
      {
      }
      
      public function get depth() : Number
      {
         return 0;
      }
      
      public function set depth(param1:Number) : void
      {
      }
      
      public function get designLayer() : DesignLayer
      {
         return null;
      }
      
      public function set designLayer(param1:DesignLayer) : void
      {
      }
      
      public function get is3D() : Boolean
      {
         return false;
      }
      
      public function get owner() : DisplayObjectContainer
      {
         return null;
      }
      
      public function set owner(param1:DisplayObjectContainer) : void
      {
      }
      
      public function get postLayoutTransformOffsets() : TransformOffsets
      {
         return null;
      }
      
      public function set postLayoutTransformOffsets(param1:TransformOffsets) : void
      {
      }
      
      private function invalidateParentSizeAndDisplayList() : void
      {
         if(parent && parent is IInvalidating)
         {
            IInvalidating(parent).invalidateSize();
            IInvalidating(parent).invalidateDisplayList();
         }
      }
   }
}
