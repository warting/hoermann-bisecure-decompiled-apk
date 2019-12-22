package spark.components.supportClasses
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AutoCapitalize;
   import flash.text.ReturnKeyLabel;
   import flash.text.SoftKeyboardType;
   import flash.text.StageText;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flashx.textLayout.formats.LineBreak;
   import mx.core.FlexGlobals;
   import mx.core.IRawChildrenContainer;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.MoveEvent;
   import mx.events.ResizeEvent;
   import mx.managers.FocusManager;
   import mx.managers.SystemManager;
   import mx.managers.systemClasses.ActiveWindowManager;
   import mx.utils.MatrixUtil;
   import mx.utils.Platform;
   import spark.components.Application;
   import spark.components.ViewNavigator;
   import spark.core.ISoftKeyboardHintClient;
   import spark.effects.Fade;
   import spark.events.PopUpEvent;
   import spark.events.TextOperationEvent;
   
   use namespace mx_internal;
   
   public class StyleableStageText extends UIComponent implements IStyleableEditableText, ISoftKeyboardHintClient
   {
      
      mx_internal static var alwaysShowProxyImage:Boolean = false;
      
      private static var awm:ActiveWindowManager;
      
      private static var supportedStyles:String = "textAlign fontFamily fontWeight fontStyle fontSize color locale";
      
      private static var defaultStyles:Object;
      
      private static var focusedStageText:StageText = null;
      
      private static var pendingFocusedStageText:StageText = null;
      
      mx_internal static var androidHeightMultiplier:Number = 1.15;
      
      private static const isAndroid:Boolean = Platform.isAndroid;
      
      private static const isDesktop:Boolean = Platform.isDesktop;
       
      
      private var stageText:StageText;
      
      private var invalidateStyleFlag:Boolean = true;
      
      private var localViewPort:Rectangle;
      
      private var invalidateViewPortFlag:Boolean = false;
      
      private var deferredViewPortUpdate:Boolean = false;
      
      private var savedSelectionAnchorIndex:int = 0;
      
      private var savedSelectionActiveIndex:int = 0;
      
      private var proxyImage:Bitmap = null;
      
      private var showProxyImage:Boolean = false;
      
      private var numEffectsRunning:int = 0;
      
      private var ignoreProxyUpdatesDuringTransition:Boolean = false;
      
      private var removedDuringTransition:Boolean = false;
      
      private var ancestorsVisible:Boolean;
      
      private var invalidateAncestorsVisibleFlag:Boolean = true;
      
      private var showOnComplete:Boolean = false;
      
      private var watchedAncestors:Vector.<UIComponent>;
      
      private var stageTextVisibleChangePending:Boolean = false;
      
      private var stageTextVisible:Boolean;
      
      private var viewTransitionRunning:Boolean = false;
      
      private var suspendedViewTransitions:Boolean = false;
      
      private var _enabled:Boolean = true;
      
      private var _effectiveEnabled:Boolean;
      
      private var invalidateEffectiveEnabledFlag:Boolean = true;
      
      private var _visible:Boolean = true;
      
      private var _densityScale:Number;
      
      private var _displayAsPassword:Boolean;
      
      private var _editable:Boolean = true;
      
      private var _maxChars:int;
      
      private var _multiline:Boolean;
      
      private var _restrict:String;
      
      private var _text:String = "";
      
      private var _autoCapitalize:String = "none";
      
      private var _autoCorrect:Boolean = true;
      
      private var _returnKeyLabel:String = "default";
      
      private var _softKeyboardType:String = "default";
      
      private var _completeEventPending:Boolean = false;
      
      private var completeEventBackstop:Timer = null;
      
      public function StyleableStageText(param1:Boolean = false)
      {
         this.watchedAncestors = new Vector.<UIComponent>();
         super();
         this._multiline = param1;
         this.getStageText(true);
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
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this._enabled = param1;
         this.invalidateEffectiveEnabledFlag = true;
         invalidateProperties();
      }
      
      private function get effectiveEnabled() : Boolean
      {
         var _loc1_:DisplayObject = null;
         if(this.invalidateEffectiveEnabledFlag)
         {
            this._effectiveEnabled = this._enabled;
            if(this._effectiveEnabled)
            {
               _loc1_ = parent;
               while(_loc1_ != null)
               {
                  if(_loc1_ is IUIComponent && !IUIComponent(_loc1_).enabled)
                  {
                     this._effectiveEnabled = false;
                     break;
                  }
                  _loc1_ = _loc1_.parent;
               }
            }
            this.invalidateEffectiveEnabledFlag = false;
         }
         return this._effectiveEnabled;
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
      
      private function get densityScale() : Number
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
            this.updateProxyImage();
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
      
      private function get completeEventPending() : Boolean
      {
         return this._completeEventPending;
      }
      
      private function set completeEventPending(param1:Boolean) : void
      {
         if(this._completeEventPending != param1)
         {
            this._completeEventPending = param1;
            if(param1)
            {
               this.completeEventBackstop = new Timer(1000,1);
               this.completeEventBackstop.addEventListener(TimerEvent.TIMER,this.completeEventBackstop_timerHandler);
               this.completeEventBackstop.start();
            }
            else
            {
               this.completeEventBackstop.removeEventListener(TimerEvent.TIMER,this.completeEventBackstop_timerHandler);
               this.completeEventBackstop = null;
               if(!isDesktop && this.viewTransitionRunning && isAndroid)
               {
                  ViewNavigator.resumeTransitions();
                  this.suspendedViewTransitions = false;
               }
            }
         }
         else if(this._completeEventPending)
         {
            this.completeEventBackstop.reset();
            this.completeEventBackstop.start();
         }
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
      
      override public function setFocus() : void
      {
         if(!this.showProxyImage && !alwaysShowProxyImage)
         {
            this.commitVisible(true);
         }
         if(this.effectiveEnabled && this.stageText != null)
         {
            if(this.stageText.visible)
            {
               this.stageText.assignFocus();
            }
            else
            {
               pendingFocusedStageText = this.stageText;
            }
         }
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
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         var _loc1_:Boolean = false;
         if(alwaysShowProxyImage && !this.showProxyImage)
         {
            this.createProxyImage();
            _loc1_ = true;
         }
         if(this.stageText != null)
         {
            this.stageText.editable = this._editable && this.effectiveEnabled;
         }
         if(!_loc1_)
         {
            this.commitVisible();
         }
         if(this.invalidateViewPortFlag)
         {
            this.updateViewPort();
            this.invalidateViewPortFlag = false;
            this.updateProxyImageForTopmostForm();
         }
         if(!_loc1_ && this.showProxyImage)
         {
            this.updateProxyImage();
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
            this.updateProxyImage();
         }
      }
      
      private function commitVisible(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = false;
         if(this.showProxyImage)
         {
            if(this.proxyImage != null)
            {
               this.proxyImage.x = 0;
               this.proxyImage.y = 0;
               if(this.stageText != null)
               {
                  this.stageText.visible = false;
                  this.stageTextVisibleChangePending = false;
                  removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               }
            }
         }
         else if(this.stageText != null)
         {
            _loc2_ = this._visible && this.calcAncestorsVisible();
            if(this.completeEventPending && _loc2_)
            {
               this.showOnComplete = true;
            }
            else if(param1)
            {
               this.stageText.visible = _loc2_;
               if(this.stageText.visible)
               {
                  if(this.stageText == focusedStageText && stage.softKeyboardRect.height > 0 || this.stageText == pendingFocusedStageText)
                  {
                     this.stageText.assignFocus();
                  }
               }
               this.disposeProxyImage();
               this.stageTextVisibleChangePending = false;
               removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            }
            else
            {
               this.stageTextVisible = _loc2_;
               this.stageTextVisibleChangePending = true;
               addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            }
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
         this.updateProxyImage();
      }
      
      public function scrollToRange(param1:int, param2:int) : void
      {
      }
      
      public function selectAll() : void
      {
         if(this.stageText != null && this.stageText.text != null)
         {
            this.stageText.selectRange(0,this.stageText.text.length);
            this.updateProxyImage();
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         if(this.stageText != null)
         {
            this.stageText.selectRange(param1,param2);
            this.updateProxyImage();
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
            this.updateProxyImage();
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
         this.commitStyles();
         var _loc1_:BitmapData = new BitmapData(this.stageText.viewPort.width,this.stageText.viewPort.height,true,16777215);
         this.stageText.drawViewPortToBitmapData(_loc1_);
         return _loc1_;
      }
      
      private function beginAnimation() : void
      {
         if(this.numEffectsRunning++ == 0)
         {
            if(this.invalidateViewPortFlag)
            {
               this.updateViewPort();
               this.invalidateViewPortFlag = false;
            }
            this.createProxyImage();
         }
      }
      
      private function createProxyImage() : void
      {
         var _loc1_:BitmapData = null;
         if(!this.showProxyImage && this.proxyImage != null)
         {
            this.showProxyImage = true;
            this.updateProxyImage();
            this.commitVisible(true);
         }
         else if(this.proxyImage == null)
         {
            _loc1_ = this.captureBitmapData();
            if(_loc1_)
            {
               if(this.densityScale == 1)
               {
                  this.proxyImage = new Bitmap(_loc1_);
               }
               else
               {
                  this.proxyImage = new Bitmap(_loc1_,PixelSnapping.NEVER,true);
                  this.proxyImage.scaleX = 1 / this.densityScale;
                  this.proxyImage.scaleY = 1 / this.densityScale;
               }
               this.showProxyImage = true;
               this.commitVisible();
               addChild(this.proxyImage);
            }
         }
      }
      
      private function endAnimation() : void
      {
         if(--this.numEffectsRunning == 0 && !alwaysShowProxyImage)
         {
            if(this.removedDuringTransition)
            {
               this.removedFromStageHandler(null);
            }
            else
            {
               this.updateViewPort();
               if(awm)
               {
                  this.updateProxyImageForTopmostForm();
               }
               else
               {
                  this.disposeProxyImageLater();
               }
            }
         }
      }
      
      private function findTopmostForm(param1:Object) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(!awm)
         {
            return null;
         }
         var _loc2_:Object = awm.form;
         var _loc3_:int = this.getFormIndex(_loc2_);
         for each(_loc4_ in awm.forms)
         {
            _loc5_ = this.getFormIndex(_loc4_);
            if(_loc5_ > _loc3_ && _loc4_ != param1)
            {
               _loc2_ = _loc4_;
               _loc3_ = _loc5_;
            }
         }
         return _loc2_;
      }
      
      private function getFormIndex(param1:Object) : int
      {
         return param1 is DisplayObject?int(systemManager.rawChildren.getChildIndex(param1 as DisplayObject)):-1;
      }
      
      private function getGlobalViewPort() : Rectangle
      {
         var _loc1_:Matrix = MatrixUtil.getConcatenatedMatrix(parent,stage);
         var _loc2_:Point = _loc1_.transformPoint(this.localViewPort.topLeft);
         var _loc3_:Point = _loc1_.transformPoint(this.localViewPort.bottomRight);
         var _loc4_:Rectangle = new Rectangle();
         _loc4_.x = Math.floor(Math.min(_loc2_.x,_loc3_.x));
         _loc4_.y = Math.floor(Math.min(_loc2_.y,_loc3_.y));
         _loc4_.width = Math.ceil(Math.abs(_loc3_.x - _loc2_.x));
         _loc4_.height = Math.ceil(Math.abs(_loc3_.y - _loc2_.y));
         return _loc4_;
      }
      
      private function hasOverlappingForm() : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         if(!this.localViewPort || !parent || !this.stageText || !awm)
         {
            return false;
         }
         if(awm.numModalWindows > 0)
         {
            return true;
         }
         var _loc1_:Rectangle = this.getGlobalViewPort();
         var _loc2_:Boolean = false;
         for each(_loc3_ in awm.forms)
         {
            _loc4_ = _loc3_ as DisplayObject;
            if(_loc4_ && (!_loc3_.hasOwnProperty("focusManager") || _loc3_.focusManager != focusManager))
            {
               _loc5_ = _loc4_ is UIComponent?UIComponent(_loc4_).getVisibleRect():_loc4_.getBounds(stage);
               if(_loc5_.intersects(_loc1_))
               {
                  _loc2_ = true;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      private function isFormApplication(param1:DisplayObject) : Boolean
      {
         return systemManager.document is IRawChildrenContainer?Boolean(IRawChildrenContainer(systemManager.document).rawChildren.contains(param1)):Boolean(systemManager.document.contains(param1));
      }
      
      private function isFormOwnedByAncestor(param1:Object) : Boolean
      {
         var _loc3_:UIComponent = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc2_:Boolean = false;
         if(param1 is UIComponent)
         {
            _loc3_ = param1 as UIComponent;
            _loc4_ = _loc3_.owner;
            _loc2_ = _loc4_ != null && _loc4_.contains(this);
         }
         return _loc2_;
      }
      
      private function updateProxyImage() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         if(this.stageText == null || this.completeEventPending)
         {
            return;
         }
         if(this.ignoreProxyUpdatesDuringTransition)
         {
            return;
         }
         if(this.proxyImage != null)
         {
            _loc1_ = this.captureBitmapData();
            if(_loc1_)
            {
               _loc2_ = this.proxyImage.bitmapData;
               this.proxyImage.bitmapData = _loc1_;
               _loc2_.dispose();
            }
         }
      }
      
      private function disposeProxyImage() : void
      {
         var fade:Fade = null;
         if(this.proxyImage != null)
         {
            fade = new Fade(this.proxyImage);
            fade.alphaTo = 0;
            fade.duration = 125;
            fade.addEventListener(EffectEvent.EFFECT_END,function(param1:EffectEvent):void
            {
               if(proxyImage)
               {
                  removeChild(proxyImage);
                  proxyImage.bitmapData.dispose();
                  proxyImage = null;
               }
            },false,0,true);
            fade.play();
         }
      }
      
      private function disposeProxyImageLater() : void
      {
         if(this.showProxyImage)
         {
            this.showProxyImage = false;
            invalidateProperties();
         }
      }
      
      private function updateProxyImageForForm(param1:Object) : void
      {
         if(alwaysShowProxyImage)
         {
            return;
         }
         if(param1 && param1.hasOwnProperty("focusManager"))
         {
            if(param1.focusManager != focusManager && (!this.isFormOwnedByAncestor(param1) || this.hasOverlappingForm()))
            {
               this.createProxyImage();
            }
            else
            {
               this.disposeProxyImageLater();
            }
         }
      }
      
      private function updateProxyImageForTopmostForm(param1:Object = null) : void
      {
         if(!awm || alwaysShowProxyImage)
         {
            return;
         }
         var _loc2_:Object = awm.form;
         if(!(_loc2_ is DisplayObject) || this.isFormApplication(_loc2_ as DisplayObject))
         {
            _loc2_ = this.findTopmostForm(param1);
         }
         this.updateProxyImageForForm(_loc2_);
      }
      
      private function updateViewPort() : void
      {
         var _loc1_:Rectangle = null;
         if(parent && this.localViewPort && this.stageText != null)
         {
            if(this.stageText.stage)
            {
               _loc1_ = this.getGlobalViewPort();
               if(!_loc1_.equals(this.stageText.viewPort))
               {
                  if(this.stageText.viewPort.width != _loc1_.width || this.stageText.viewPort.height != _loc1_.height)
                  {
                     this.completeEventPending = true;
                  }
                  this.stageText.viewPort = _loc1_;
               }
               this.deferredViewPortUpdate = false;
            }
            else
            {
               this.deferredViewPortUpdate = true;
            }
         }
      }
      
      private function measureTextLineHeight() : Number
      {
         var _loc1_:TextLineMetrics = measureText("Wj");
         if(isAndroid)
         {
            return _loc1_.height * androidHeightMultiplier;
         }
         return _loc1_.height;
      }
      
      private function calcAncestorsVisible() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:DisplayObject = null;
         if(this.invalidateAncestorsVisibleFlag)
         {
            _loc1_ = this.visible;
            _loc2_ = parent;
            while(_loc1_ && _loc2_)
            {
               _loc1_ = _loc2_.visible;
               _loc2_ = _loc2_.parent;
            }
            this.ancestorsVisible = _loc1_;
            this.invalidateAncestorsVisibleFlag = false;
         }
         return this.ancestorsVisible;
      }
      
      private function gatherAncestorComponents() : Vector.<UIComponent>
      {
         var _loc1_:Vector.<UIComponent> = new Vector.<UIComponent>();
         var _loc2_:DisplayObject = parent;
         while(_loc2_)
         {
            if(_loc2_ is UIComponent)
            {
               _loc1_.push(_loc2_ as UIComponent);
            }
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }
      
      private function updateWatchedAncestors() : void
      {
         var _loc2_:int = 0;
         var _loc4_:UIComponent = null;
         var _loc5_:UIComponent = null;
         var _loc1_:Vector.<UIComponent> = this.gatherAncestorComponents();
         _loc2_ = 0;
         while(_loc2_ < this.watchedAncestors.length)
         {
            _loc4_ = this.watchedAncestors[_loc2_];
            if(_loc1_.indexOf(_loc4_) == -1)
            {
               _loc4_.removeEventListener(FlexEvent.CREATION_COMPLETE,this.ancestor_creationCompleteHandler);
               _loc4_.removeEventListener(MoveEvent.MOVE,this.ancestor_moveHandler);
               _loc4_.removeEventListener(ResizeEvent.RESIZE,this.ancestor_resizeHandler);
               _loc4_.removeEventListener(FlexEvent.SHOW,this.ancestor_showHandler);
               _loc4_.removeEventListener(FlexEvent.HIDE,this.ancestor_hideHandler);
               _loc4_.removeEventListener(PopUpEvent.CLOSE,this.ancestor_closeHandler);
               _loc4_.removeEventListener(PopUpEvent.OPEN,this.ancestor_openHandler);
            }
            _loc2_++;
         }
         var _loc3_:Boolean = false;
         _loc2_ = _loc1_.length - 1;
         while(_loc2_ >= 0)
         {
            _loc5_ = _loc1_[_loc2_];
            if(this.watchedAncestors.indexOf(_loc5_) == -1)
            {
               _loc5_.addEventListener(MoveEvent.MOVE,this.ancestor_moveHandler,false,0,true);
               _loc5_.addEventListener(ResizeEvent.RESIZE,this.ancestor_resizeHandler,false,0,true);
               _loc5_.addEventListener(FlexEvent.SHOW,this.ancestor_showHandler,false,0,true);
               _loc5_.addEventListener(FlexEvent.HIDE,this.ancestor_hideHandler,false,0,true);
               if(_loc5_.isPopUp)
               {
                  _loc5_.addEventListener(PopUpEvent.CLOSE,this.ancestor_closeHandler,false,0,true);
                  _loc5_.addEventListener(PopUpEvent.OPEN,this.ancestor_openHandler,false,0,true);
               }
               if(!_loc5_.initialized && !_loc3_)
               {
                  _loc3_ = true;
                  _loc5_.addEventListener(FlexEvent.CREATION_COMPLETE,this.ancestor_creationCompleteHandler,false,0,true);
               }
            }
            _loc2_--;
         }
         this.watchedAncestors = _loc1_;
      }
      
      private function updateWatchedForms(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:EventDispatcher = null;
         if(awm)
         {
            for each(_loc2_ in awm.forms)
            {
               if(_loc2_ is EventDispatcher)
               {
                  _loc3_ = _loc2_ as EventDispatcher;
                  _loc3_.removeEventListener(MoveEvent.MOVE,this.form_moveHandler);
                  _loc3_.removeEventListener(ResizeEvent.RESIZE,this.form_resizeHandler);
                  if(_loc2_ != param1)
                  {
                     _loc3_.addEventListener(MoveEvent.MOVE,this.form_moveHandler,false,0,true);
                     _loc3_.addEventListener(ResizeEvent.RESIZE,this.form_resizeHandler,false,0,true);
                  }
               }
            }
         }
      }
      
      private function clearWatchedAncestors() : void
      {
         var _loc1_:UIComponent = null;
         while(this.watchedAncestors.length > 0)
         {
            _loc1_ = this.watchedAncestors.pop();
            _loc1_.removeEventListener(FlexEvent.CREATION_COMPLETE,this.ancestor_creationCompleteHandler);
            _loc1_.removeEventListener(MoveEvent.MOVE,this.ancestor_moveHandler);
            _loc1_.removeEventListener(ResizeEvent.RESIZE,this.ancestor_resizeHandler);
            _loc1_.removeEventListener(FlexEvent.SHOW,this.ancestor_showHandler);
            _loc1_.removeEventListener(FlexEvent.HIDE,this.ancestor_hideHandler);
            _loc1_.removeEventListener(PopUpEvent.CLOSE,this.ancestor_closeHandler);
            _loc1_.removeEventListener(PopUpEvent.OPEN,this.ancestor_openHandler);
         }
      }
      
      private function restoreStageText() : void
      {
         if(this.stageText != null)
         {
            this.stageText.editable = this._editable && this.effectiveEnabled;
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
            this.invalidateAncestorsVisibleFlag = true;
            invalidateProperties();
         }
      }
      
      mx_internal function getStageText(param1:Boolean = false) : StageText
      {
         if(this.stageText == null && param1)
         {
            this.stageText = StageTextPool#1108.acquireStageText(this);
         }
         return this.stageText;
      }
      
      private function registerStageTextListeners() : void
      {
         if(this.stageText != null)
         {
            this.stageText.addEventListener(Event.CHANGE,this.stageText_changeHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
            this.stageText.addEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardHandler);
            this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
            this.stageText.addEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         }
      }
      
      override protected function focusInHandler(param1:FocusEvent) : void
      {
         if(this.stageText != null && focusedStageText != this.stageText && this.effectiveEnabled)
         {
            this.stageText.assignFocus();
         }
      }
      
      private function ancestor_closeHandler(param1:Event) : void
      {
         this.ancestorsVisible = false;
         this.invalidateAncestorsVisibleFlag = false;
         invalidateProperties();
      }
      
      private function ancestor_creationCompleteHandler(param1:FlexEvent) : void
      {
         if(!this.invalidateAncestorsVisibleFlag)
         {
            this.invalidateAncestorsVisibleFlag = true;
            invalidateProperties();
         }
      }
      
      private function ancestor_hideHandler(param1:FlexEvent) : void
      {
         this.ancestorsVisible = false;
         this.invalidateAncestorsVisibleFlag = false;
         invalidateProperties();
      }
      
      private function ancestor_moveHandler(param1:MoveEvent) : void
      {
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      private function ancestor_openHandler(param1:Event) : void
      {
         this.invalidateAncestorsVisibleFlag = true;
         invalidateProperties();
      }
      
      private function ancestor_resizeHandler(param1:ResizeEvent) : void
      {
         this.invalidateViewPortFlag = true;
         invalidateProperties();
      }
      
      private function ancestor_showHandler(param1:FlexEvent) : void
      {
         this.invalidateAncestorsVisibleFlag = true;
         invalidateProperties();
      }
      
      private function ancestor_viewChangeStartHandler(param1:Event) : void
      {
         this.viewTransitionRunning = true;
      }
      
      private function ancestor_viewChangeCompleteHandler(param1:Event) : void
      {
         this.viewTransitionRunning = false;
         if(this.stageTextVisibleChangePending)
         {
            this.enterFrameHandler(null);
         }
      }
      
      private function awm_activatedFormHandler(param1:DynamicEvent) : void
      {
         this.updateWatchedForms();
         this.updateProxyImageForTopmostForm();
      }
      
      private function awm_deactivatedFormHandler(param1:DynamicEvent) : void
      {
         this.updateWatchedForms();
         var _loc2_:Object = !!param1.hasOwnProperty("form")?param1.form:null;
         this.updateProxyImageForForm(_loc2_);
      }
      
      private function awm_removeFocusManagerHandler(param1:FocusEvent) : void
      {
         var _loc2_:Object = param1.relatedObject;
         this.updateWatchedForms(_loc2_);
         this.updateProxyImageForTopmostForm(_loc2_);
      }
      
      private function completeEventBackstop_timerHandler(param1:TimerEvent) : void
      {
         this.completeEventPending = false;
         if(this.showOnComplete)
         {
            this.commitVisible(true);
            this.showOnComplete = false;
         }
      }
      
      private function form_moveHandler(param1:MoveEvent) : void
      {
         this.updateProxyImageForTopmostForm();
      }
      
      private function form_resizeHandler(param1:ResizeEvent) : void
      {
         this.updateProxyImageForTopmostForm();
      }
      
      private function stageText_changeHandler(param1:Event) : void
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
      
      private function stageText_completeHandler(param1:Event) : void
      {
         if(!this.completeEventPending && !isDesktop && isAndroid && this.viewTransitionRunning)
         {
            this.ignoreProxyUpdatesDuringTransition = false;
         }
         this.completeEventPending = false;
         this.updateProxyImage();
         if(!isDesktop && this.viewTransitionRunning && isAndroid)
         {
            this.ignoreProxyUpdatesDuringTransition = true;
         }
         if(this.showOnComplete)
         {
            this.commitVisible(true);
            this.showOnComplete = false;
         }
      }
      
      private function stageText_focusInHandler(param1:FocusEvent) : void
      {
         focusedStageText = this.stageText;
         pendingFocusedStageText = null;
         dispatchEvent(new FocusEvent(param1.type,true,param1.cancelable,param1.relatedObject,param1.shiftKey,param1.keyCode,param1.direction));
      }
      
      private function stageText_focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:FocusManager = null;
         var _loc3_:Object = null;
         if(focusedStageText == this.stageText)
         {
            focusedStageText = null;
            if(focusManager is FocusManager)
            {
               _loc2_ = focusManager as FocusManager;
               _loc3_ = _loc2_.lastFocus as Object;
               if(_loc3_ && _loc3_.hasOwnProperty("textDisplay") && _loc3_.textDisplay == this)
               {
                  _loc2_.lastFocus = null;
               }
            }
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
      
      private function stageText_softKeyboardHandler(param1:SoftKeyboardEvent) : void
      {
         dispatchEvent(new SoftKeyboardEvent(param1.type,true,param1.cancelable,this,param1.triggerType));
      }
      
      private function eventTargetsAncestor(param1:Event) : Boolean
      {
         var _loc2_:DisplayObject = parent;
         var _loc3_:Object = param1.target;
         while(_loc2_ != null && _loc2_ != _loc3_)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ != null;
      }
      
      private function stage_effectStartHandler(param1:EffectEvent) : void
      {
         if(this.eventTargetsAncestor(param1))
         {
            this.beginAnimation();
         }
      }
      
      private function stage_effectEndHandler(param1:EffectEvent) : void
      {
         if(this.eventTargetsAncestor(param1))
         {
            this.endAnimation();
         }
      }
      
      private function stage_enabledChangedHandler(param1:Event) : void
      {
         if(this.eventTargetsAncestor(param1))
         {
            this.invalidateEffectiveEnabledFlag = true;
            invalidateProperties();
         }
      }
      
      private function stage_hierarchyChangedHandler(param1:Event) : void
      {
         if(this.eventTargetsAncestor(param1))
         {
            this.updateWatchedAncestors();
         }
      }
      
      private function viewTransition_prepareHandler(param1:Event) : void
      {
         if(!isDesktop && isAndroid)
         {
            if(this.completeEventPending && !this.suspendedViewTransitions)
            {
               ViewNavigator.suspendTransitions();
               this.suspendedViewTransitions = true;
            }
            else
            {
               this.ignoreProxyUpdatesDuringTransition = true;
            }
         }
         this.viewTransitionRunning = true;
         this.beginAnimation();
      }
      
      private function stage_transitionEndHandler(param1:FlexEvent) : void
      {
         if(this.viewTransitionRunning)
         {
            this.viewTransitionRunning = false;
            this.endAnimation();
         }
         this.ignoreProxyUpdatesDuringTransition = false;
         if(this.stageTextVisibleChangePending)
         {
            this.enterFrameHandler(null);
         }
      }
      
      private function addHierarchyListeners() : void
      {
         if(this.stageText == null)
         {
            return;
         }
         this.updateWatchedAncestors();
         this.stageText.stage.addEventListener(Event.ADDED,this.stage_hierarchyChangedHandler,false,0,true);
         this.stageText.stage.addEventListener(Event.REMOVED,this.stage_hierarchyChangedHandler,false,0,true);
      }
      
      private function removeHierarchyListeners() : void
      {
         if(this.stageText == null)
         {
            return;
         }
         this.stageText.stage.removeEventListener(Event.ADDED,this.stage_hierarchyChangedHandler);
         this.stageText.stage.removeEventListener(Event.REMOVED,this.stage_hierarchyChangedHandler);
         this.clearWatchedAncestors();
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         if(this.viewTransitionRunning)
         {
            this.removedDuringTransition = false;
            return;
         }
         var _loc2_:* = false;
         if(!awm)
         {
            awm = ActiveWindowManager(systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         }
         if(awm)
         {
            awm.addEventListener("activatedForm",this.awm_activatedFormHandler,false,0,true);
            awm.addEventListener("deactivatedForm",this.awm_deactivatedFormHandler,false,0,true);
            awm.addEventListener("removeFocusManager",this.awm_removeFocusManagerHandler,false,0,true);
         }
         if(this.stageText == null)
         {
            _loc2_ = !StageTextPool#1108.hasCachedStageText(this);
            this.getStageText(true);
         }
         this.stageText.visible = false;
         this.stageText.addEventListener(Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.stage = stage;
         this.completeEventPending = true;
         this.stageText.stage.addEventListener(EffectEvent.EFFECT_START,this.stage_effectStartHandler,true,0,true);
         this.stageText.stage.addEventListener(EffectEvent.EFFECT_END,this.stage_effectEndHandler,true,0,true);
         this.stageText.stage.addEventListener(FlexEvent.TRANSITION_END,this.stage_transitionEndHandler,false,0,true);
         this.stageText.stage.addEventListener("viewTransitionPrepare",this.viewTransition_prepareHandler,false,0,true);
         this.stageText.stage.addEventListener("enabledChanged",this.stage_enabledChangedHandler,true,0,true);
         this.addHierarchyListeners();
         if(_loc2_)
         {
            this.restoreStageText();
         }
         else if(this.savedSelectionAnchorIndex > 0 || this.savedSelectionActiveIndex > 0)
         {
            if(this.savedSelectionAnchorIndex <= this._text.length && this.savedSelectionActiveIndex <= this._text.length)
            {
               this.stageText.selectRange(this.savedSelectionAnchorIndex,this.savedSelectionActiveIndex);
            }
            this.savedSelectionAnchorIndex = 0;
            this.savedSelectionActiveIndex = 0;
         }
         if(this.deferredViewPortUpdate)
         {
            this.updateViewPort();
         }
         this.registerStageTextListeners();
         if(alwaysShowProxyImage)
         {
            this.createProxyImage();
         }
         this.invalidateAncestorsVisibleFlag = true;
         this.invalidateEffectiveEnabledFlag = true;
         invalidateProperties();
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         if(!this.viewTransitionRunning && this.stageTextVisibleChangePending)
         {
            this.stageText.visible = this.stageTextVisible;
            if(this.stageTextVisible)
            {
               if(this.stageText == focusedStageText && stage.softKeyboardRect.height > 0 || this.stageText == pendingFocusedStageText)
               {
                  this.stageText.assignFocus();
               }
            }
            this.disposeProxyImage();
            this.stageTextVisibleChangePending = false;
         }
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         if(this.viewTransitionRunning)
         {
            this.removedDuringTransition = true;
            return;
         }
         if(awm)
         {
            awm.removeEventListener("activatedForm",this.awm_activatedFormHandler);
            awm.removeEventListener("deactivatedForm",this.awm_deactivatedFormHandler);
            awm.removeEventListener("removeFocusManager",this.awm_removeFocusManagerHandler);
         }
         if(this.stageText == null)
         {
            return;
         }
         this.savedSelectionAnchorIndex = this.stageText.selectionAnchorIndex;
         this.savedSelectionActiveIndex = this.stageText.selectionActiveIndex;
         this.stageText.stage.removeEventListener(EffectEvent.EFFECT_START,this.stage_effectStartHandler,true);
         this.stageText.stage.removeEventListener(EffectEvent.EFFECT_END,this.stage_effectEndHandler,true);
         this.stageText.stage.removeEventListener(FlexEvent.TRANSITION_END,this.stage_transitionEndHandler);
         this.stageText.stage.removeEventListener("viewTransitionPrepare",this.viewTransition_prepareHandler);
         this.stageText.stage.removeEventListener("enabledChanged",this.stage_enabledChangedHandler,true);
         this.removeHierarchyListeners();
         this.stageText.stage = null;
         this.stageText.removeEventListener(Event.CHANGE,this.stageText_changeHandler);
         this.stageText.removeEventListener(Event.COMPLETE,this.stageText_completeHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_IN,this.stageText_focusInHandler);
         this.stageText.removeEventListener(FocusEvent.FOCUS_OUT,this.stageText_focusOutHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING,this.stageText_softKeyboardHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stageText_softKeyboardHandler);
         this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stageText_softKeyboardHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN,this.stageText_keyDownHandler);
         this.stageText.removeEventListener(KeyboardEvent.KEY_UP,this.stageText_keyUpHandler);
         StageTextPool#1108.releaseStageText(this,this.stageText);
         this.stageText = null;
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.stageTextVisibleChangePending = false;
         this.showProxyImage = false;
         if(this.proxyImage != null)
         {
            removeChild(this.proxyImage);
            this.proxyImage.bitmapData.dispose();
            this.proxyImage = null;
         }
         this.numEffectsRunning = 0;
         this.removedDuringTransition = false;
      }
   }
}

import flash.events.TimerEvent;
import flash.text.StageText;
import flash.text.StageTextInitOptions;
import flash.utils.Dictionary;
import flash.utils.Timer;
import spark.components.supportClasses.StyleableStageText;

class StageTextPool#1108
{
   
   private static const poolReserve:Number = 5;
   
   private static const poolTimerInterval:Number = 10000;
   
   private static var map_StyleableStageText_to_StageText:Dictionary = new Dictionary(true);
   
   private static var map_StageText_to_StyleableStageText:Dictionary = new Dictionary(true);
   
   private static var multilinePool:Vector.<StageText> = new Vector.<StageText>();
   
   private static var multilinePoolTimer:Timer;
   
   private static var singleLinePool:Vector.<StageText> = new Vector.<StageText>();
   
   private static var singleLinePoolTimer:Timer;
   
   private static var cleanProperties:Object = null;
    
   
   function StageTextPool#1108()
   {
      super();
   }
   
   public static function acquireStageText(param1:StyleableStageText) : StageText
   {
      var _loc3_:* = null;
      var _loc4_:int = 0;
      var _loc2_:StageText = map_StyleableStageText_to_StageText[param1];
      if(!_loc2_)
      {
         if(param1.multiline)
         {
            if(multilinePool.length == 0)
            {
               while(multilinePool.length < poolReserve)
               {
                  multilinePool.push(new StageText(new StageTextInitOptions(true)));
               }
            }
            _loc2_ = multilinePool.pop();
         }
         else
         {
            if(singleLinePool.length == 0)
            {
               while(singleLinePool.length < poolReserve)
               {
                  singleLinePool.push(new StageText(new StageTextInitOptions(false)));
               }
            }
            _loc2_ = singleLinePool.pop();
         }
         if(!cleanProperties)
         {
            cleanProperties = {};
            cleanProperties["autoCapitalize"] = _loc2_.autoCapitalize;
            cleanProperties["autoCorrect"] = _loc2_.autoCorrect;
            cleanProperties["displayAsPassword"] = _loc2_.displayAsPassword;
            cleanProperties["editable"] = _loc2_.editable;
            cleanProperties["maxChars"] = _loc2_.maxChars;
            cleanProperties["restrict"] = _loc2_.restrict;
            cleanProperties["returnKeyLabel"] = _loc2_.returnKeyLabel;
            cleanProperties["softKeyboardType"] = _loc2_.softKeyboardType;
            cleanProperties["text"] = _loc2_.text;
         }
         else
         {
            for(_loc3_ in cleanProperties)
            {
               _loc2_[_loc3_] = cleanProperties[_loc3_];
            }
         }
      }
      else if(param1.multiline)
      {
         _loc4_ = multilinePool.indexOf(_loc2_);
         multilinePool.splice(_loc4_,1);
      }
      else
      {
         _loc4_ = singleLinePool.indexOf(_loc2_);
         singleLinePool.splice(_loc4_,1);
      }
      uncacheStageText(_loc2_);
      return _loc2_;
   }
   
   public static function hasCachedStageText(param1:StyleableStageText) : Boolean
   {
      return map_StyleableStageText_to_StageText[param1] !== undefined;
   }
   
   public static function releaseStageText(param1:StyleableStageText, param2:StageText) : void
   {
      var host:StyleableStageText = param1;
      var stageText:StageText = param2;
      map_StyleableStageText_to_StageText[host] = stageText;
      map_StageText_to_StyleableStageText[stageText] = host;
      if(host.multiline)
      {
         multilinePool.push(stageText);
         if(multilinePool.length > poolReserve)
         {
            if(!multilinePoolTimer)
            {
               multilinePoolTimer = new Timer(poolTimerInterval,1);
               multilinePoolTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
               {
                  shrinkPool(true);
                  multilinePoolTimer = null;
               },false,0,true);
            }
            multilinePoolTimer.reset();
            multilinePoolTimer.start();
         }
      }
      else
      {
         singleLinePool.push(stageText);
         if(singleLinePool.length > poolReserve)
         {
            if(!singleLinePoolTimer)
            {
               singleLinePoolTimer = new Timer(poolTimerInterval,1);
               singleLinePoolTimer.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
               {
                  shrinkPool(false);
                  singleLinePoolTimer = null;
               },false,0,true);
            }
            singleLinePoolTimer.reset();
            singleLinePoolTimer.start();
         }
      }
   }
   
   private static function shrinkPool(param1:Boolean) : void
   {
      var _loc2_:StageText = null;
      if(param1)
      {
         while(multilinePool.length > poolReserve)
         {
            _loc2_ = multilinePool.shift();
            uncacheStageText(_loc2_);
            _loc2_.dispose();
         }
      }
      else
      {
         while(singleLinePool.length > poolReserve)
         {
            _loc2_ = singleLinePool.shift();
            uncacheStageText(_loc2_);
            _loc2_.dispose();
         }
      }
   }
   
   private static function uncacheStageText(param1:StageText) : void
   {
      var _loc2_:StyleableStageText = map_StageText_to_StyleableStageText[param1];
      delete map_StyleableStageText_to_StageText[_loc2_];
      delete map_StageText_to_StyleableStageText[param1];
   }
}
