package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.SoftKeyboardEvent;
   import flash.events.SoftKeyboardTrigger;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.core.EventPriority;
   import mx.core.FlexGlobals;
   import mx.core.FlexVersion;
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   import mx.effects.Parallel;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.PopUpManager;
   import mx.managers.SystemManager;
   import mx.styles.StyleProtoChain;
   import spark.effects.Move;
   import spark.effects.Resize;
   import spark.effects.animation.Animation;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Power;
   import spark.events.PopUpEvent;
   
   use namespace mx_internal;
   
   public class SkinnablePopUpContainer extends SkinnableContainer
   {
       
      
      private var closeEvent:PopUpEvent;
      
      private var addedToPopUpManager:Boolean = false;
      
      private var softKeyboardEffect:IEffect;
      
      private var softKeyboardEffectCachedYPosition:Number;
      
      private var softKeyboardEffectPendingEventType:String = null;
      
      mx_internal var softKeyboardEffectPendingEffectDelay:Number = 100;
      
      private var softKeyboardEffectPendingEventTimer:Timer;
      
      private var softKeyboardEffectOrientationChanging:Boolean = false;
      
      private var softKeyboardEffectOrientationHandlerAdded:Boolean = false;
      
      private var softKeyboardStateChangeListenersInstalled:Boolean;
      
      private var resizeListenerInstalled:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      private var _resizeForSoftKeyboard:Boolean = true;
      
      private var _moveForSoftKeyboard:Boolean = true;
      
      private var _softKeyboardEffectExplicitHeightFlag:Boolean = false;
      
      private var _softKeyboardEffectExplicitWidthFlag:Boolean = false;
      
      private var _softKeyboardEffectCachedHeight:Number;
      
      private var _isSoftKeyboardEffectActive:Boolean;
      
      private var _marginTop:Number = 0;
      
      private var _marginBottom:Number = 0;
      
      private var _isMouseDown:Boolean = false;
      
      public function SkinnablePopUpContainer()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      mx_internal function setIsOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
         invalidateSkinState();
      }
      
      public function get resizeForSoftKeyboard() : Boolean
      {
         return this._resizeForSoftKeyboard;
      }
      
      public function set resizeForSoftKeyboard(param1:Boolean) : void
      {
         if(this._resizeForSoftKeyboard == param1)
         {
            return;
         }
         this._resizeForSoftKeyboard = param1;
      }
      
      public function get moveForSoftKeyboard() : Boolean
      {
         return this._moveForSoftKeyboard;
      }
      
      public function set moveForSoftKeyboard(param1:Boolean) : void
      {
         if(this._moveForSoftKeyboard == param1)
         {
            return;
         }
         this._moveForSoftKeyboard = param1;
      }
      
      public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.closeEvent = null;
         this.owner = param1;
         if(!this.addedToPopUpManager)
         {
            this.addedToPopUpManager = true;
            PopUpManager.addPopUp(this,param1,param2);
            this.updatePopUpPosition();
         }
         this._isOpen = true;
         invalidateSkinState();
         if(skin)
         {
            skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         else
         {
            this.stateChangeComplete_handler(null);
         }
      }
      
      public function updatePopUpPosition() : void
      {
      }
      
      public function close(param1:Boolean = false, param2:* = undefined) : void
      {
         if(!this.isOpen)
         {
            return;
         }
         this.closeEvent = new PopUpEvent(PopUpEvent.CLOSE,false,false,param1,param2);
         this._isOpen = false;
         invalidateSkinState();
         if(skin)
         {
            skin.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         else
         {
            this.stateChangeComplete_handler(null);
         }
      }
      
      protected function createSoftKeyboardEffect(param1:Number, param2:Number) : IEffect
      {
         var _loc3_:Move = null;
         var _loc4_:Resize = null;
         var _loc6_:Parallel = null;
         var _loc5_:IEaser = new Power(0,5);
         if(param1 != this.y)
         {
            _loc3_ = new Move();
            _loc3_.target = this;
            _loc3_.yTo = param1;
            _loc3_.disableLayout = true;
            _loc3_.easer = _loc5_;
         }
         if(param2 != this.height)
         {
            _loc4_ = new Resize();
            _loc4_.target = this;
            _loc4_.heightTo = param2;
            _loc4_.disableLayout = true;
            _loc4_.easer = _loc5_;
         }
         if(_loc3_ && _loc4_)
         {
            _loc6_ = new Parallel();
            _loc6_.addChild(_loc3_);
            _loc6_.addChild(_loc4_);
            return _loc6_;
         }
         if(_loc3_ || _loc4_)
         {
            return !!_loc3_?_loc3_:_loc4_;
         }
         return null;
      }
      
      mx_internal function get softKeyboardEffectExplicitHeightFlag() : Boolean
      {
         return this._softKeyboardEffectExplicitHeightFlag;
      }
      
      private function setSoftKeyboardEffectExplicitHeightFlag(param1:Boolean) : void
      {
         this._softKeyboardEffectExplicitHeightFlag = param1;
      }
      
      mx_internal function get softKeyboardEffectExplicitWidthFlag() : Boolean
      {
         return this._softKeyboardEffectExplicitWidthFlag;
      }
      
      private function setSoftKeyboardEffectExplicitWidthFlag(param1:Boolean) : void
      {
         this._softKeyboardEffectExplicitWidthFlag = param1;
      }
      
      mx_internal function get softKeyboardEffectCachedHeight() : Number
      {
         var _loc1_:Number = this._softKeyboardEffectCachedHeight;
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            if(!isNaN(explicitMaxHeight) && measuredHeight > explicitMaxHeight)
            {
               _loc1_ = explicitMaxHeight;
            }
            else
            {
               _loc1_ = measuredHeight;
            }
         }
         return _loc1_;
      }
      
      private function setSoftKeyboardEffectCachedHeight(param1:Number) : void
      {
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            this._softKeyboardEffectCachedHeight = param1;
         }
      }
      
      mx_internal function get isSoftKeyboardEffectActive() : Boolean
      {
         return this._isSoftKeyboardEffectActive;
      }
      
      mx_internal function get softKeyboardEffectMarginTop() : Number
      {
         return this._marginTop;
      }
      
      mx_internal function set softKeyboardEffectMarginTop(param1:Number) : void
      {
         this._marginTop = param1;
      }
      
      mx_internal function get softKeyboardEffectMarginBottom() : Number
      {
         return this._marginBottom;
      }
      
      mx_internal function set softKeyboardEffectMarginBottom(param1:Number) : void
      {
         this._marginBottom = param1;
      }
      
      private function get isMouseDown() : Boolean
      {
         return this._isMouseDown;
      }
      
      private function set isMouseDown(param1:Boolean) : void
      {
         this._isMouseDown = param1;
         this.playPendingEffect(true);
      }
      
      override mx_internal function initProtoChain() : void
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_6)
         {
            super.initProtoChain();
         }
         else
         {
            StyleProtoChain.initProtoChain(this,false);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var _loc1_:String = super.getCurrentSkinState();
         if(!this.isOpen)
         {
            return _loc1_ == "normal"?"closed":_loc1_;
         }
         return _loc1_;
      }
      
      private function startEffect(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.startEffect);
         if(!this.isOpen || !this.softKeyboardEffect)
         {
            return;
         }
         this.softKeyboardEffect.addEventListener(EffectEvent.EFFECT_END,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect.addEventListener(EffectEvent.EFFECT_STOP,this.softKeyboardEffectCleanup);
         if(this.isSoftKeyboardEffectActive)
         {
            this.installSoftKeyboardStateChangeListeners();
         }
         Animation.pulse();
         this.softKeyboardEffect.play();
      }
      
      private function stateChangeComplete_handler(param1:Event) : void
      {
         if(param1)
         {
            param1.target.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE,this.stateChangeComplete_handler);
         }
         var _loc2_:Application = FlexGlobals.topLevelApplication as Application;
         var _loc3_:Boolean = _loc2_ && Application.softKeyboardBehavior == "none";
         var _loc4_:Stage = systemManager.stage;
         if(this.isOpen)
         {
            dispatchEvent(new PopUpEvent(PopUpEvent.OPEN,false,false));
            if(_loc3_)
            {
               if(_loc4_)
               {
                  _loc4_.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stage_softKeyboardActivateHandler,true,EventPriority.DEFAULT,true);
                  _loc4_.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stage_softKeyboardDeactivateHandler,true,EventPriority.DEFAULT,true);
                  systemManager.addEventListener(Event.RESIZE,this.systemManager_resizeHandler,false,EventPriority.EFFECT);
                  this.updateSoftKeyboardEffect(true);
               }
            }
         }
         else
         {
            dispatchEvent(this.closeEvent);
            this.closeEvent = null;
            if(_loc3_ && _loc4_)
            {
               _loc4_.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,this.stage_softKeyboardActivateHandler,true);
               _loc4_.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,this.stage_softKeyboardDeactivateHandler,true);
               systemManager.removeEventListener(Event.RESIZE,this.systemManager_resizeHandler);
            }
            PopUpManager.removePopUp(this);
            this.addedToPopUpManager = false;
            owner = null;
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function stage_softKeyboardActivateHandler(param1:SoftKeyboardEvent = null) : void
      {
         var _loc2_:Boolean = false;
         this.softKeyboardEffectPendingEventType = null;
         if(!this.isSoftKeyboardEffectActive && !this.softKeyboardEffect)
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.updateSoftKeyboardEffect(false);
         }
         else if(this.isMouseDown)
         {
            this.setPendingSoftKeyboardEvent(param1);
         }
         else
         {
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function stage_softKeyboardDeactivateHandler(param1:SoftKeyboardEvent = null) : void
      {
         if(!this.isSoftKeyboardEffectActive || this.softKeyboardEffectOrientationChanging)
         {
            return;
         }
         this.softKeyboardEffectPendingEventType = null;
         if(param1.triggerType == SoftKeyboardTrigger.USER_TRIGGERED)
         {
            this.updateSoftKeyboardEffect(false);
         }
         else
         {
            this.setPendingSoftKeyboardEvent(param1);
         }
      }
      
      private function stage_orientationChangingHandler(param1:Event) : void
      {
         this.softKeyboardEffectOrientationChanging = true;
      }
      
      private function stage_orientationChangeHandler(param1:Event) : void
      {
         this.softKeyboardEffectOrientationChanging = false;
      }
      
      private function mouseHandler(param1:MouseEvent) : void
      {
         this.isMouseDown = param1.type == MouseEvent.MOUSE_DOWN;
      }
      
      private function systemManager_mouseUpHandler(param1:Event) : void
      {
         this.isMouseDown = false;
      }
      
      private function pendingEffectTimer_timerCompleteHandler(param1:Event) : void
      {
         this.playPendingEffect(false);
      }
      
      private function playPendingEffect(param1:Boolean) : void
      {
         var _loc5_:* = false;
         var _loc2_:Boolean = this.softKeyboardEffectPendingEventTimer && this.softKeyboardEffectPendingEventTimer.running;
         var _loc3_:Boolean = _loc2_ && (param1 && this.isMouseDown);
         if(this.softKeyboardEffectPendingEventTimer && (_loc3_ || !param1))
         {
            this.softKeyboardEffectPendingEventTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.pendingEffectTimer_timerCompleteHandler);
            this.softKeyboardEffectPendingEventTimer.stop();
            this.softKeyboardEffectPendingEventTimer = null;
            if(_loc3_)
            {
               return;
            }
         }
         var _loc4_:Boolean = this.softKeyboardEffectPendingEventType && this.isOpen && (!param1 || param1 && !this.isMouseDown);
         if(_loc4_)
         {
            _loc5_ = this.softKeyboardEffectPendingEventType == SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE;
            this.updateSoftKeyboardEffect(_loc5_);
         }
      }
      
      private function softKeyboardEffectCleanup(param1:EffectEvent) : void
      {
         this.softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_END,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect.removeEventListener(EffectEvent.EFFECT_STOP,this.softKeyboardEffectCleanup);
         this.softKeyboardEffect = null;
         if(this.isSoftKeyboardEffectActive)
         {
            this.installActiveResizeListener();
         }
         else
         {
            this.uninstallActiveResizeListener();
            this.uninstallSoftKeyboardStateChangeListeners();
         }
      }
      
      private function resizeHandler(param1:Event = null) : void
      {
         this.setSoftKeyboardEffectExplicitWidthFlag(!isNaN(explicitWidth));
         this.setSoftKeyboardEffectExplicitHeightFlag(!isNaN(explicitHeight));
      }
      
      private function systemManager_resizeHandler(param1:Event) : void
      {
         if(!this.softKeyboardEffectOrientationChanging)
         {
            this.updateSoftKeyboardEffect(true);
         }
      }
      
      private function updateSoftKeyboardEffect(param1:Boolean) : void
      {
         var softKeyboardRect:Rectangle = null;
         var scaleFactor:Number = NaN;
         var popUpY:Number = NaN;
         var popUpHeight:Number = NaN;
         var overlapGlobal:Number = NaN;
         var yToGlobal:Number = NaN;
         var heightToGlobal:Number = NaN;
         var snapPosition:Boolean = param1;
         if(this.softKeyboardEffect && this.softKeyboardEffect.isPlaying)
         {
            this.softKeyboardEffect.stop();
         }
         this.uninstallActiveResizeListener();
         try
         {
            softKeyboardRect = FlexGlobals.topLevelApplication.softKeyboardRect;
         }
         catch(error:Error)
         {
            softKeyboardRect = null;
         }
         var isKeyboardOpen:Boolean = this.isOpen && softKeyboardRect && softKeyboardRect.height > 0;
         if(isNaN(this.softKeyboardEffectCachedYPosition))
         {
            if(isKeyboardOpen)
            {
               this.softKeyboardEffectCachedYPosition = this.y;
               this.setSoftKeyboardEffectCachedHeight(this.height);
               this.resizeHandler();
            }
            else
            {
               return;
            }
         }
         var sandboxRoot:DisplayObject = systemManager.getSandboxRoot();
         var yToLocal:Number = this.softKeyboardEffectCachedYPosition;
         var heightToLocal:Number = this.softKeyboardEffectCachedHeight;
         if(isKeyboardOpen)
         {
            scaleFactor = 1;
            if(systemManager as SystemManager)
            {
               scaleFactor = SystemManager(systemManager).densityScale;
            }
            popUpY = yToLocal * scaleFactor;
            popUpHeight = heightToLocal * scaleFactor;
            overlapGlobal = popUpY + popUpHeight - softKeyboardRect.y;
            yToGlobal = popUpY;
            heightToGlobal = popUpHeight;
            if(overlapGlobal > 0)
            {
               if(this.moveForSoftKeyboard)
               {
                  yToGlobal = Math.max(this.softKeyboardEffectMarginTop * scaleFactor,popUpY - overlapGlobal);
               }
               if(this.resizeForSoftKeyboard)
               {
                  overlapGlobal = yToGlobal + popUpHeight - softKeyboardRect.y;
                  if(overlapGlobal > 0)
                  {
                     heightToGlobal = popUpHeight - overlapGlobal - this.softKeyboardEffectMarginBottom * scaleFactor;
                  }
               }
            }
            if(yToGlobal != popUpY || heightToGlobal != popUpHeight)
            {
               yToLocal = Math.floor(yToGlobal / scaleFactor);
               heightToLocal = Math.floor(heightToGlobal / scaleFactor);
               heightToLocal = Math.max(heightToLocal,getMinBoundsHeight());
            }
         }
         this._isSoftKeyboardEffectActive = isKeyboardOpen;
         var duration:Number = getStyle("softKeyboardEffectDuration");
         if(!snapPosition && duration > 0)
         {
            this.softKeyboardEffect = this.createSoftKeyboardEffect(yToLocal,heightToLocal);
         }
         if(this.softKeyboardEffect)
         {
            this.softKeyboardEffect.duration = duration;
            addEventListener(Event.ENTER_FRAME,this.startEffect);
         }
         else
         {
            this.y = yToLocal;
            if(this.isOpen)
            {
               this.height = heightToLocal;
               validateNow();
               if(this.isSoftKeyboardEffectActive)
               {
                  this.installActiveResizeListener();
                  this.installSoftKeyboardStateChangeListeners();
               }
            }
            else
            {
               this.uninstallSoftKeyboardStateChangeListeners();
               this.softKeyboardEffectResetExplicitSize();
               this.softKeyboardEffectCachedYPosition = NaN;
               this.setSoftKeyboardEffectExplicitWidthFlag(false);
               this.setSoftKeyboardEffectExplicitHeightFlag(false);
               this.setSoftKeyboardEffectCachedHeight(NaN);
            }
         }
      }
      
      private function setPendingSoftKeyboardEvent(param1:SoftKeyboardEvent) : void
      {
         this.softKeyboardEffectPendingEventType = param1.type;
         if(!this.isMouseDown)
         {
            this.softKeyboardEffectPendingEventTimer = new Timer(this.softKeyboardEffectPendingEffectDelay,1);
            this.softKeyboardEffectPendingEventTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.pendingEffectTimer_timerCompleteHandler);
            this.softKeyboardEffectPendingEventTimer.start();
         }
      }
      
      private function installSoftKeyboardStateChangeListeners() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Stage = null;
         if(!this.softKeyboardStateChangeListenersInstalled)
         {
            _loc1_ = systemManager.getSandboxRoot();
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.mouseHandler,true);
            _loc1_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            this.softKeyboardEffectOrientationChanging = false;
            _loc2_ = systemManager.stage;
            _loc2_.addEventListener("orientationChanging",this.stage_orientationChangingHandler);
            _loc2_.addEventListener("orientationChange",this.stage_orientationChangeHandler);
            this.softKeyboardStateChangeListenersInstalled = true;
         }
      }
      
      private function uninstallSoftKeyboardStateChangeListeners() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Stage = null;
         if(this.softKeyboardStateChangeListenersInstalled)
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
            _loc1_ = systemManager.getSandboxRoot();
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.mouseHandler,true);
            _loc1_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
            _loc2_ = systemManager.stage;
            _loc2_.removeEventListener("orientationChange",this.stage_orientationChangeHandler);
            _loc2_.removeEventListener("orientationChanging",this.stage_orientationChangeHandler);
            this.softKeyboardStateChangeListenersInstalled = false;
         }
      }
      
      private function installActiveResizeListener() : void
      {
         if(!this.resizeListenerInstalled)
         {
            addEventListener("explicitWidthChanged",this.resizeHandler);
            addEventListener("explicitHeightChanged",this.resizeHandler);
            this.resizeListenerInstalled = true;
         }
      }
      
      private function uninstallActiveResizeListener() : void
      {
         if(this.resizeListenerInstalled)
         {
            removeEventListener("explicitWidthChanged",this.resizeHandler);
            removeEventListener("explicitHeightChanged",this.resizeHandler);
            this.resizeListenerInstalled = false;
         }
      }
      
      mx_internal function softKeyboardEffectResetExplicitSize() : void
      {
         var _loc1_:Boolean = this.resizeListenerInstalled;
         if(_loc1_)
         {
            this.uninstallActiveResizeListener();
         }
         if(!this.softKeyboardEffectExplicitWidthFlag)
         {
            explicitWidth = NaN;
         }
         if(!this.softKeyboardEffectExplicitHeightFlag)
         {
            explicitHeight = NaN;
         }
         if(_loc1_)
         {
            this.installActiveResizeListener();
         }
      }
   }
}
