package spark.components.supportClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AutoCapitalize;
   import flash.text.ReturnKeyLabel;
   import flash.text.SoftKeyboardType;
   import flash.text.StageText;
   import flash.text.StageTextInitOptions;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flashx.textLayout.formats.LineBreak;
   import mx.core.FlexGlobals;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.managers.SystemManager;
   import mx.utils.Platform;
   import spark.components.Application;
   import spark.core.IProxiedStageTextWrapper;
   import spark.core.ISoftKeyboardHintClient;
   import spark.events.TextOperationEvent;
   
   use namespace mx_internal;
   
   public class ScrollableStageText extends UIComponent implements IStyleableEditableText, ISoftKeyboardHintClient, IProxiedStageTextWrapper
   {
      
      protected static const isAndroid:Boolean = Platform.isAndroid;
      
      protected static const isDesktop:Boolean = Platform.isDesktop;
      
      mx_internal static var androidHeightMultiplier:Number = 1.15;
      
      protected static var supportedStyles:String = "textAlign fontFamily fontWeight fontStyle fontSize color locale";
      
      protected static var defaultStyles:Object;
      
      protected static var lastFocusedStageText:StageText;
      
      protected static var hiddenFocusStageText:StageText = null;
      
      mx_internal static var debugProxyImage:Boolean = false;
       
      
      protected var proxy:DisplayObject = null;
      
      private var localViewPort:Rectangle;
      
      private var invalidateViewPortFlag:Boolean = false;
      
      private var savedSelectionAnchorIndex:int = 0;
      
      private var savedSelectionActiveIndex:int = 0;
      
      private var isEditing:Boolean = false;
      
      private var invalidateProxyFlag:Boolean = false;
      
      protected var stageText:StageText;
      
      protected var savedStageText:StageText = null;
      
      protected var invalidateStyleFlag:Boolean = true;
      
      private var _softKeyboardType:String = "default";
      
      private var _visible:Boolean = true;
      
      private var _densityScale:Number;
      
      protected var _displayAsPassword:Boolean;
      
      protected var _editable:Boolean = true;
      
      protected var _maxChars:int;
      
      protected var _multiline:Boolean;
      
      protected var _restrict:String;
      
      private var _text:String = "";
      
      private var _autoCapitalize:String = "none";
      
      private var _autoCorrect:Boolean = true;
      
      private var _returnKeyLabel:String = "default";
      
      public function ScrollableStageText(param1:Boolean = false)
      {
         super();
         this._multiline = param1;
         this.stageText = StageTextPool#61.current.acquireStageText(param1);
         this.stageText.visible = false;
         if(!defaultStyles)
         {
            defaultStyles = {};
            defaultStyles["textAlign"] = this.stageText.textAlign;
            defaultStyles["fontFamily"] = this.stageText.fontFamily;
            defaultStyles["fontWeight"] = this.stageText.fontWeight;
            defaultStyles["fontStyle"] = this.stageText.fontPosture;
            defaultStyles["fontSize"] = this.stageText.fontSize;
            defaultStyles["color"] = this.stageText.color;
            defaultStyles["locale"] = this.stageText.locale;
         }
         this._displayAsPassword = this.stageText.displayAsPassword;
         this._maxChars = this.stageText.maxChars;
         this._restrict = this.stageText.restrict;
         this.stageText.autoCorrect = this._autoCorrect;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
      }
      
      override public function get height() : Number
      {
         if(!this.localViewPort)
         {
            return 0;
         }
         return this.localViewPort.height;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(param1 == this.height)
         {
            return;
         }
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.height = Math.max(0,param1);
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1 == this._visible)
         {
            return;
         }
         this._visible = param1;
         invalidateProperties();
      }
      
      override public function get width() : Number
      {
         if(!this.localViewPort)
         {
            return 0;
         }
         return this.localViewPort.width;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(param1 == this.width)
         {
            return;
         }
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.width = Math.max(0,param1);
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override public function get x() : Number
      {
         if(!this.localViewPort)
         {
            return 0;
         }
         return this.localViewPort.x;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         if(param1 == this.x)
         {
            return;
         }
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.x = param1;
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override public function get y() : Number
      {
         if(!this.localViewPort)
         {
            return 0;
         }
         return this.localViewPort.y;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         if(param1 == this.y)
         {
            return;
         }
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.y = param1;
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override public function get baselinePosition() : Number
      {
         return this.measureTextLineHeight();
      }
      
      protected function get densityScale() : Number
      {
         var _loc1_:Application = null;
         var _loc2_:SystemManager = null;
         if(isNaN(this._densityScale))
         {
            _loc1_ = FlexGlobals.topLevelApplication as Application;
            _loc2_ = !!_loc1_?_loc1_.systemManager as SystemManager:null;
            this._densityScale = !!_loc2_?Number(_loc2_.densityScale):Number(1);
         }
         return this._densityScale;
      }
      
      protected function get showsProxy() : Boolean
      {
         return !this.isEditing;
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this.stageText != null)
         {
            this.stageText.displayAsPassword = param1;
         }
         this._displayAsPassword = param1;
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(param1:Boolean) : void
      {
         this._editable = param1;
         invalidateProperties();
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return 0;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
      }
      
      public function get isTruncated() : Boolean
      {
         return false;
      }
      
      public function get lineBreak() : String
      {
         return LineBreak.TO_FIT;
      }
      
      public function set lineBreak(param1:String) : void
      {
      }
      
      public function get maxChars() : int
      {
         return this._maxChars;
      }
      
      public function set maxChars(param1:int) : void
      {
         if(this.stageText != null)
         {
            this.stageText.maxChars = param1;
         }
         this._maxChars = param1;
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set multiline(param1:Boolean) : void
      {
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function set restrict(param1:String) : void
      {
         if(this.stageText != null)
         {
            this.stageText.restrict = param1;
         }
         this._restrict = param1;
      }
      
      public function get selectable() : Boolean
      {
         return true;
      }
      
      public function set selectable(param1:Boolean) : void
      {
      }
      
      public function get selectionActivePosition() : int
      {
         return !!this.stageText?int(this.stageText.selectionActiveIndex):0;
      }
      
      public function get selectionAnchorPosition() : int
      {
         return !!this.stageText?int(this.stageText.selectionAnchorIndex):0;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            param1 = "";
         }
         if(param1 != this._text)
         {
            if(this.stageText != null)
            {
               _loc2_ = this.stageText.selectionAnchorIndex;
               _loc3_ = this.stageText.selectionActiveIndex;
               this.stageText.text = param1;
               this.stageText.selectRange(_loc2_,_loc3_);
            }
            this._text = param1;
            dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            this.invalidateProxy();
         }
      }
      
      public function get verticalScrollPosition() : Number
      {
         return 0;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
      }
      
      public function get autoCapitalize() : String
      {
         return !!this.stageText?this.stageText.autoCapitalize:this._autoCapitalize;
      }
      
      public function set autoCapitalize(param1:String) : void
      {
         if(param1 == "")
         {
            param1 = AutoCapitalize.NONE;
         }
         if(this.stageText != null)
         {
            this.stageText.autoCapitalize = param1;
         }
         this._autoCapitalize = param1;
      }
      
      public function get autoCorrect() : Boolean
      {
         return !!this.stageText?Boolean(this.stageText.autoCorrect):Boolean(this._autoCorrect);
      }
      
      public function set autoCorrect(param1:Boolean) : void
      {
         if(this.stageText != null)
         {
            this.stageText.autoCorrect = param1;
         }
         this._autoCorrect = param1;
      }
      
      public function get returnKeyLabel() : String
      {
         return !!this.stageText?this.stageText.returnKeyLabel:this._returnKeyLabel;
      }
      
      public function set returnKeyLabel(param1:String) : void
      {
         if(param1 == "")
         {
            param1 = ReturnKeyLabel.DEFAULT;
         }
         if(this.stageText != null)
         {
            this.stageText.returnKeyLabel = param1;
         }
         this._returnKeyLabel = param1;
      }
      
      public function get softKeyboardType() : String
      {
         return !!this.stageText?this.stageText.softKeyboardType:this._softKeyboardType;
      }
      
      public function set softKeyboardType(param1:String) : void
      {
         if(param1 == "")
         {
            param1 = SoftKeyboardType.DEFAULT;
         }
         if(this.stageText != null)
         {
            this.stageText.softKeyboardType = param1;
         }
         this._softKeyboardType = param1;
      }
      
      override public function move(param1:Number, param2:Number) : void
      {
         super.move(param1,param2);
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.x = param1;
         this.localViewPort.y = param2;
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         if(param1 == null || param1 == "styleName" || supportedStyles.indexOf(param1) >= 0)
         {
            this.invalidateStyleFlag = true;
         }
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
         super.setActualSize(param1,param2);
         if(!this.localViewPort)
         {
            this.localViewPort = new Rectangle();
         }
         this.localViewPort.width = Math.max(0,param1);
         this.localViewPort.height = Math.max(0,param2);
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      override protected function measure() : void
      {
         this.commitStyles();
         var _loc1_:TextLineMetrics = measureText("Wj");
         var _loc2_:TextLineMetrics = measureText(this.text);
         measuredMinWidth = _loc1_.width;
         measuredWidth = Math.max(measuredMinWidth,_loc2_.width);
         if(isAndroid)
         {
            measuredMinHeight = _loc1_.height * androidHeightMultiplier;
            measuredHeight = Math.max(measuredMinHeight,_loc2_.height * androidHeightMultiplier);
         }
         else
         {
            measuredMinHeight = _loc1_.height;
            measuredHeight = Math.max(measuredMinHeight,_loc2_.height);
         }
      }
      
      public function commitStyles() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = false;
         if(this.invalidateStyleFlag && this.stageText != null)
         {
            _loc1_ = getStyle("textAlign");
            if(_loc1_)
            {
               _loc8_ = getStyle("layoutDirection") == LayoutDirection.RTL;
               if(_loc1_ == "start")
               {
                  _loc1_ = !!_loc8_?TextFormatAlign.RIGHT:TextFormatAlign.LEFT;
               }
               else if(_loc1_ == "end")
               {
                  _loc1_ = !!_loc8_?TextFormatAlign.LEFT:TextFormatAlign.RIGHT;
               }
               this.stageText.textAlign = _loc1_;
            }
            else
            {
               this.stageText.textAlign = defaultStyles["textAlign"];
            }
            _loc2_ = getStyle("fontFamily");
            if(_loc2_)
            {
               this.stageText.fontFamily = _loc2_;
            }
            else
            {
               this.stageText.fontFamily = defaultStyles["fontFamily"];
            }
            _loc3_ = getStyle("fontStyle");
            if(_loc3_)
            {
               this.stageText.fontPosture = _loc3_;
            }
            else
            {
               this.stageText.fontPosture = defaultStyles["fontStyle"];
            }
            _loc4_ = getStyle("fontWeight");
            if(_loc4_)
            {
               this.stageText.fontWeight = _loc4_;
            }
            else
            {
               this.stageText.fontWeight = defaultStyles["fontWeight"];
            }
            _loc5_ = getStyle("fontSize");
            if(_loc5_ != undefined)
            {
               this.stageText.fontSize = _loc5_ * this.densityScale;
            }
            else
            {
               this.stageText.fontSize = defaultStyles["fontSize"] * this.densityScale;
            }
            _loc6_ = getStyle("color");
            if(_loc6_ != undefined)
            {
               this.stageText.color = _loc6_;
            }
            else
            {
               this.stageText.color = defaultStyles["color"];
            }
            _loc7_ = getStyle("locale");
            if(_loc7_ != undefined)
            {
               this.stageText.locale = _loc7_;
            }
            else
            {
               this.stageText.locale = defaultStyles["locale"];
            }
            this.invalidateStyleFlag = false;
            this.invalidateProxy();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.stageText != null)
         {
            this.stageText.editable = this._editable;
         }
         if(this.invalidateViewPortFlag)
         {
            this.invalidateViewPortFlag = false;
            this.updateViewPort();
         }
         if(this.invalidateProxyFlag && this.showsProxy)
         {
            this.invalidateProxyFlag = false;
            this.updateProxy();
         }
      }
      
      override public function setFocus() : void
      {
         if(this.stageText != null)
         {
            this.stageText.assignFocus();
            lastFocusedStageText = this.stageText;
         }
      }
      
      public function appendText(param1:String) : void
      {
         if(this.stageText != null && param1.length > 0)
         {
            if(this.stageText.text != null)
            {
               this.stageText.text = this.stageText.text + param1;
            }
            else
            {
               this.stageText.text = param1;
            }
            this._text = this.stageText.text;
            this.stageText.selectRange(this._text.length,this._text.length);
            dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
            this.invalidateProxy();
         }
      }
      
      public function insertText(param1:String) : void
      {
         if(this.stageText == null || param1.length == 0)
         {
            return;
         }
         var _loc2_:String = this.stageText.text;
         var _loc3_:int = this.stageText.selectionActiveIndex;
         var _loc4_:int = this.stageText.selectionAnchorIndex;
         var _loc5_:int = _loc2_.length;
         var _loc6_:int = _loc5_;
         if(_loc3_ >= 0 && _loc4_ >= 0)
         {
            _loc5_ = Math.min(_loc3_,_loc4_);
            _loc6_ = Math.max(_loc3_,_loc4_);
         }
         else if(_loc3_ >= 0)
         {
            _loc5_ = _loc3_;
            _loc6_ = _loc3_;
         }
         else if(_loc4_ >= 0)
         {
            _loc5_ = _loc4_;
            _loc6_ = _loc4_;
         }
         var _loc7_:String = "";
         if(_loc5_ > 0)
         {
            _loc7_ = _loc7_ + _loc2_.substring(0,_loc5_);
         }
         _loc7_ = _loc7_ + param1;
         if(_loc6_ < _loc2_.length)
         {
            _loc7_ = _loc7_ + _loc2_.substring(_loc6_);
         }
         this.stageText.text = _loc7_;
         this.stageText.selectRange(_loc5_ + param1.length,_loc5_ + param1.length);
         this._text = this.stageText.text;
         dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
         this.invalidateProxy();
      }
      
      public function scrollToRange(param1:int, param2:int) : void
      {
      }
      
      public function selectAll() : void
      {
         if(this.stageText != null && this.stageText.text != null)
         {
            this.stageText.selectRange(0,this.stageText.text.length);
            this.invalidateProxy();
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this.stageText != null)
         {
            this.stageText.selectRange(param1,param2);
            this.invalidateProxy();
         }
      }
      
      protected function createProxy() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(this.densityScale == 1)
         {
            _loc1_ = new Bitmap(null);
         }
         else
         {
            _loc1_ = new Bitmap(null,PixelSnapping.NEVER,true);
            _loc1_.scaleX = 1 / this.densityScale;
            _loc1_.scaleY = 1 / this.densityScale;
         }
         return _loc1_;
      }
      
      private function invalidateProxy() : void
      {
         this.invalidateProxyFlag = true;
         invalidateProperties();
      }
      
      protected function updateProxy() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Matrix = null;
         if(this.stageText == null)
         {
            return;
         }
         if(this.proxy != null)
         {
            _loc1_ = this.captureBitmapData();
            if(_loc1_)
            {
               _loc2_ = Bitmap(this.proxy).bitmapData;
               Bitmap(this.proxy).bitmapData = _loc1_;
               if(_loc2_)
               {
                  _loc2_.dispose();
               }
            }
            if(layoutDirection == LayoutDirection.RTL)
            {
               _loc3_ = this.proxy.transform.matrix;
               if(_loc3_.a > 0)
               {
                  _loc3_.a = -_loc3_.a;
               }
               _loc3_.tx = this.width;
               this.proxy.transform.matrix = _loc3_;
            }
         }
      }
      
      protected function disposeProxy() : void
      {
         var _loc1_:BitmapData = Bitmap(this.proxy).bitmapData;
         if(_loc1_)
         {
            _loc1_.dispose();
         }
      }
      
      mx_internal function captureBitmapData() : BitmapData
      {
         if(!this.stageText || !this.stageText.stage || !this.localViewPort || this.localViewPort.width == 0 || this.localViewPort.height == 0)
         {
            return null;
         }
         if(this.stageText.viewPort.width == 0 || this.stageText.viewPort.height == 0)
         {
            this.updateViewPort();
         }
         this.invalidateStyleFlag = true;
         this.commitStyles();
         var _loc1_:BitmapData = new BitmapData(this.stageText.viewPort.width,this.stageText.viewPort.height,!debugProxyImage,!!debugProxyImage?uint(16748799):uint(16777215));
         this.stageText.drawViewPortToBitmapData(_loc1_);
         return _loc1_;
      }
      
      protected function getGlobalViewPort() : Rectangle
      {
         var _loc1_:Point = parent.localToGlobal(this.localViewPort.topLeft);
         var _loc2_:Point = parent.localToGlobal(this.localViewPort.bottomRight);
         var _loc3_:Rectangle = new Rectangle();
         _loc3_.x = Math.floor(Math.min(_loc1_.x,_loc2_.x));
         _loc3_.y = Math.floor(Math.min(_loc1_.y,_loc2_.y));
         _loc3_.width = Math.ceil(Math.abs(_loc2_.x - _loc1_.x));
         _loc3_.height = Math.ceil(Math.abs(_loc2_.y - _loc1_.y));
         if(_loc3_.x > 0)
         {
            _loc3_.x = Math.min(_loc3_.x,stage.stageWidth);
         }
         else
         {
            _loc3_.x = Math.max(_loc3_.x,0);
         }
         if(_loc3_.y > 0)
         {
            _loc3_.y = Math.min(_loc3_.y,stage.stageHeight);
         }
         else
         {
            _loc3_.y = Math.max(_loc3_.y,0);
         }
         _loc3_.width = Math.min(_loc3_.width,stage.stageWidth);
         _loc3_.height = Math.min(_loc3_.height,stage.stageHeight);
         return _loc3_;
      }
      
      protected function updateViewPort() : void
      {
         var _loc1_:Rectangle = null;
         if(parent && this.localViewPort && this.stageText != null)
         {
            if(this.stageText.stage)
            {
               _loc1_ = this.getGlobalViewPort();
               if(!_loc1_.equals(this.stageText.viewPort))
               {
                  this.stageText.viewPort = _loc1_;
               }
            }
         }
      }
      
      protected function measureTextLineHeight() : Number
      {
         var _loc1_:TextLineMetrics = measureText("Wj");
         if(isAndroid)
         {
            return _loc1_.height * androidHeightMultiplier;
         }
         return _loc1_.height;
      }
      
      protected function restoreStageText() : void
      {
         if(this.stageText != null)
         {
            this.stageText.editable = this._editable;
            this.stageText.text = this._text;
            this.stageText.selectRange(this.savedSelectionAnchorIndex,this.savedSelectionActiveIndex);
            this.savedSelectionAnchorIndex = 0;
            this.savedSelectionActiveIndex = 0;
            this.stageText.displayAsPassword = this._displayAsPassword;
            this.stageText.maxChars = this._maxChars;
            this.stageText.restrict = this._restrict;
            this.stageText.autoCapitalize = this._autoCapitalize;
            this.stageText.autoCorrect = this._autoCorrect;
            this.stageText.returnKeyLabel = this._returnKeyLabel;
            this.stageText.softKeyboardType = this._softKeyboardType;
            this.invalidateStyleFlag = true;
            this.invalidateViewPortFlag = true;
            invalidateProperties();
         }
      }
      
      protected function addedToStageHandler(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(this.stageText == null)
         {
            this.stageText = StageTextPool#61.current.acquireStageText(this.multiline,this.savedStageText);
            if(this.stageText !== this.savedStageText)
            {
               _loc2_ = true;
            }
            this.savedStageText = null;
            this.stageText.visible = false;
         }
         this.proxy = this.createProxy();
         addChild(this.proxy);
         this.invalidateProxy();
         this.stageText.addEventListener(Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.stage = stage;
         if(_loc2_)
         {
            this.restoreStageText();
         }
         else
         {
            this.stageText.text = this._text;
            if(this.savedSelectionAnchorIndex > 0 || this.savedSelectionActiveIndex > 0)
            {
               if(this.savedSelectionAnchorIndex <= this._text.length && this.savedSelectionActiveIndex <= this._text.length)
               {
                  this.stageText.selectRange(this.savedSelectionAnchorIndex,this.savedSelectionActiveIndex);
               }
               this.savedSelectionAnchorIndex = 0;
               this.savedSelectionActiveIndex = 0;
            }
         }
         if(this.stageText != null)
         {
            this.stageText.addEventListener(Event.CHANGE,this.stageText_changeHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         }
         invalidateProperties();
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         if(this.stageText == null)
         {
            return;
         }
         this.savedSelectionAnchorIndex = this.stageText.selectionAnchorIndex;
         this.savedSelectionActiveIndex = this.stageText.selectionActiveIndex;
         this.stageText.stage = null;
         this.stageText.removeEventListener(Event.CHANGE,this.stageText_changeHandler);
         this.stageText.removeEventListener(Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardActivateHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         StageTextPool#61.current.releaseStageText(this.stageText,this.multiline);
         this.savedStageText = this.stageText;
         this.stageText = null;
         if(this.proxy != null)
         {
            removeChild(this.proxy);
            this.disposeProxy();
            this.proxy = null;
         }
      }
      
      protected function stageText_changeHandler(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:* = false;
         if(this.stageText != null)
         {
            _loc3_ = this._text;
            _loc4_ = this.stageText.text;
            _loc2_ = _loc4_ != _loc3_;
            this._text = this.stageText.text;
         }
         if(_loc2_)
         {
            dispatchEvent(new TextOperationEvent(param1.type));
         }
      }
      
      protected function stageText_completeHandler(param1:Event) : void
      {
         this.invalidateProxy();
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      private function stageText_focusInHandler(param1:FocusEvent) : void
      {
         if(!this.isEditing)
         {
            this.startTextEdit();
         }
         dispatchEvent(new FocusEvent(param1.type,true,param1.cancelable,param1.relatedObject,param1.shiftKey,param1.keyCode,param1.direction));
      }
      
      private function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         if(this.isEditing)
         {
            callLater(this.endTextEdit);
         }
         dispatchEvent(new FocusEvent(param1.type,true,param1.cancelable,param1.relatedObject,param1.shiftKey,param1.keyCode,param1.direction));
      }
      
      private function stageText_keyDownHandler(param1:KeyboardEvent) : void
      {
         if((param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT) && !this._multiline)
         {
            dispatchEvent(new FlexEvent(FlexEvent.ENTER));
         }
         dispatchEvent(new KeyboardEvent(param1.type,true,param1.cancelable,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey,param1.controlKey,param1.commandKey));
         if((param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT) && !this._multiline && !isDesktop)
         {
            param1.preventDefault();
         }
      }
      
      private function stageText_keyUpHandler(param1:KeyboardEvent) : void
      {
         dispatchEvent(new KeyboardEvent(param1.type,true,param1.cancelable,param1.charCode,param1.keyCode,param1.keyLocation,param1.ctrlKey,param1.altKey,param1.shiftKey,param1.controlKey,param1.commandKey));
         if((param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.NEXT) && !this._multiline && !isDesktop)
         {
            param1.preventDefault();
         }
      }
      
      private function stageText_softKeyboardActivateHandler(param1:SoftKeyboardEvent) : void
      {
         this.startTextEdit();
         dispatchEvent(new SoftKeyboardEvent(param1.type,true,param1.cancelable,this,param1.triggerType));
      }
      
      private function stageText_softKeyboardHandler(param1:SoftKeyboardEvent) : void
      {
         dispatchEvent(new SoftKeyboardEvent(param1.type,true,param1.cancelable,this,param1.triggerType));
      }
      
      protected function startTextEdit() : Boolean
      {
         if(!this.isEditing)
         {
            this.isEditing = true;
            this.proxy.visible = false;
            this.updateViewPort();
            this.stageText.visible = true;
            return true;
         }
         return false;
      }
      
      protected function endTextEdit() : Boolean
      {
         if(this.isEditing)
         {
            this.isEditing = false;
            this.invalidateProxy();
            this.proxy.visible = true;
            this.stageText.visible = false;
            return true;
         }
         return false;
      }
      
      protected function get debugId() : String
      {
         var _loc1_:UIComponent = this.parent.parent as UIComponent;
         return !!_loc1_?_loc1_.id:"-";
      }
      
      public function prepareForTouchScroll() : void
      {
         this.endTextEdit();
         if(hiddenFocusStageText)
         {
            hiddenFocusStageText.visible = false;
         }
      }
      
      public function keepSoftKeyboardActive() : void
      {
         if(!hiddenFocusStageText)
         {
            hiddenFocusStageText = new StageText(new StageTextInitOptions(false));
            hiddenFocusStageText.viewPort = new Rectangle(0,0,0,0);
            hiddenFocusStageText.stage = stage;
         }
         if(lastFocusedStageText)
         {
            hiddenFocusStageText.softKeyboardType = lastFocusedStageText.softKeyboardType;
         }
         hiddenFocusStageText.visible = true;
         hiddenFocusStageText.assignFocus();
      }
   }
}

import flash.events.TimerEvent;
import flash.text.StageText;
import flash.text.StageTextInitOptions;
import flash.utils.Timer;

class StageTextPool#61
{
   
   private static const poolReserve:Number = 5;
   
   private static const poolTimerInterval:Number = 10000;
   
   private static var _current:StageTextPool#61;
    
   
   private var multilinePool:Vector.<StageText>;
   
   private var multilinePoolTimer:Timer;
   
   private var singleLinePool:Vector.<StageText>;
   
   private var singleLinePoolTimer:Timer;
   
   private var cleanProperties:Object = null;
   
   function StageTextPool#61()
   {
      this.multilinePool = new Vector.<StageText>();
      this.singleLinePool = new Vector.<StageText>();
      super();
   }
   
   private static function get current() : StageTextPool#61
   {
      if(!_current)
      {
         _current = new StageTextPool#61();
      }
      return _current;
   }
   
   public function acquireStageText(param1:Boolean, param2:StageText = null) : StageText
   {
      var _loc5_:int = 0;
      var _loc6_:* = null;
      var _loc3_:StageText = null;
      var _loc4_:Vector.<StageText> = !!param1?this.multilinePool:this.singleLinePool;
      if(param2 != null)
      {
         _loc5_ = _loc4_.indexOf(param2);
         if(_loc5_ >= 0)
         {
            _loc3_ = param2;
            _loc4_.splice(_loc5_,1);
         }
      }
      if(_loc3_ == null)
      {
         if(_loc4_.length == 0)
         {
            while(_loc4_.length < poolReserve)
            {
               _loc4_.push(new StageText(new StageTextInitOptions(param1)));
            }
         }
         _loc3_ = _loc4_.pop();
         if(!this.cleanProperties)
         {
            this.cleanProperties = {};
            this.cleanProperties["autoCapitalize"] = _loc3_.autoCapitalize;
            this.cleanProperties["autoCorrect"] = _loc3_.autoCorrect;
            this.cleanProperties["displayAsPassword"] = _loc3_.displayAsPassword;
            this.cleanProperties["editable"] = _loc3_.editable;
            this.cleanProperties["maxChars"] = _loc3_.maxChars;
            this.cleanProperties["restrict"] = _loc3_.restrict;
            this.cleanProperties["returnKeyLabel"] = _loc3_.returnKeyLabel;
            this.cleanProperties["softKeyboardType"] = _loc3_.softKeyboardType;
            this.cleanProperties["text"] = _loc3_.text;
         }
         else
         {
            for(_loc6_ in this.cleanProperties)
            {
               _loc3_[_loc6_] = this.cleanProperties[_loc6_];
            }
         }
      }
      return _loc3_;
   }
   
   public function releaseStageText(param1:StageText, param2:Boolean) : void
   {
      var stageText:StageText = param1;
      var multiline:Boolean = param2;
      if(multiline)
      {
         this.multilinePool.push(stageText);
         if(this.multilinePool.length > poolReserve)
         {
            if(!this.multilinePoolTimer)
            {
               this.multilinePoolTimer = new Timer(poolTimerInterval,1);
               this.multilinePoolTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
               {
                  shrinkPool(true);
                  multilinePoolTimer = null;
               },false,0,true);
            }
            this.multilinePoolTimer.reset();
            this.multilinePoolTimer.start();
         }
      }
      else
      {
         this.singleLinePool.push(stageText);
         if(this.singleLinePool.length > poolReserve)
         {
            if(!this.singleLinePoolTimer)
            {
               this.singleLinePoolTimer = new Timer(poolTimerInterval,1);
               this.singleLinePoolTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
               {
                  shrinkPool(false);
                  singleLinePoolTimer = null;
               },false,0,true);
            }
            this.singleLinePoolTimer.reset();
            this.singleLinePoolTimer.start();
         }
      }
   }
   
   private function shrinkPool(param1:Boolean) : void
   {
      var _loc2_:StageText = null;
      var _loc3_:Vector.<StageText> = !!param1?this.multilinePool:this.singleLinePool;
      while(_loc3_.length > poolReserve)
      {
         _loc2_ = _loc3_.shift();
         _loc2_.dispose();
      }
   }
}
