package mx.managers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.controls.ToolTip;
   import mx.core.FlexGlobals;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModule;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IToolTip;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.LayoutDirection;
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   import mx.effects.IAbstractEffect;
   import mx.events.DynamicEvent;
   import mx.events.EffectEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.IStyleClient;
   import mx.validators.IValidatorListener;
   
   use namespace mx_internal;
   
   public class ToolTipManagerImpl extends EventDispatcher implements IToolTipManager2
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var instance:IToolTipManager2;
      
      public static var mixins:Array;
       
      
      mx_internal var initialized:Boolean = false;
      
      mx_internal var showTimer:Timer;
      
      mx_internal var hideTimer:Timer;
      
      mx_internal var scrubTimer:Timer;
      
      mx_internal var currentText:String;
      
      mx_internal var isError:Boolean;
      
      mx_internal var previousTarget:DisplayObject;
      
      private var _currentTarget:DisplayObject;
      
      mx_internal var _currentToolTip:DisplayObject;
      
      private var _enabled:Boolean = true;
      
      private var _hideDelay:Number = 10000;
      
      private var _hideEffect:IAbstractEffect;
      
      private var _scrubDelay:Number = 100;
      
      private var _showDelay:Number = 500;
      
      private var _showEffect:IAbstractEffect;
      
      private var _toolTipClass:Class;
      
      public function ToolTipManagerImpl()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._toolTipClass = ToolTip;
         super();
         if(instance)
         {
            throw new Error("Instance already exists.");
         }
         if(mixins)
         {
            _loc1_ = mixins.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               new mixins[_loc2_](this);
               _loc2_++;
            }
         }
         if(hasEventListener("initialize"))
         {
            dispatchEvent(new Event("initialize"));
         }
      }
      
      public static function getInstance() : IToolTipManager2
      {
         if(!instance)
         {
            instance = new ToolTipManagerImpl();
         }
         return instance;
      }
      
      private static function mouseIsOver(param1:DisplayObject) : Boolean
      {
         if(!param1 || !param1.stage)
         {
            return false;
         }
         if(param1.stage.mouseX == 0 && param1.stage.mouseY == 0)
         {
            return false;
         }
         if(param1 is ILayoutManagerClient && !ILayoutManagerClient(param1).initialized)
         {
            return false;
         }
         if(param1 is IVisualElement && !IVisualElement(param1).visible)
         {
            return false;
         }
         if(param1 is IFlexDisplayObject && !IFlexDisplayObject(param1).visible)
         {
            return false;
         }
         if(!isVisibleParentsIncluded(param1))
         {
            return false;
         }
         return param1.hitTestPoint(param1.stage.mouseX,param1.stage.mouseY,true);
      }
      
      private static function isVisibleParentsIncluded(param1:DisplayObject) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return !!isTopLevelApplication(param1)?Boolean(param1.visible):param1.visible && isVisibleParentsIncluded(param1.parent);
      }
      
      private static function isTopLevelApplication(param1:DisplayObject) : Boolean
      {
         return param1 == FlexGlobals.topLevelApplication;
      }
      
      private static function getGlobalBounds(param1:DisplayObject, param2:DisplayObject, param3:Boolean) : Rectangle
      {
         var _loc4_:Point = new Point(0,0);
         _loc4_ = param1.localToGlobal(_loc4_);
         if(param3)
         {
            _loc4_.x = _loc4_.x - param1.width;
         }
         _loc4_ = param2.globalToLocal(_loc4_);
         return new Rectangle(_loc4_.x,_loc4_.y,param1.width,param1.height);
      }
      
      public function get currentTarget() : DisplayObject
      {
         return this._currentTarget;
      }
      
      public function set currentTarget(param1:DisplayObject) : void
      {
         this._currentTarget = param1;
      }
      
      public function get currentToolTip() : IToolTip
      {
         return this._currentToolTip as IToolTip;
      }
      
      public function set currentToolTip(param1:IToolTip) : void
      {
         this._currentToolTip = param1 as DisplayObject;
         if(hasEventListener("currentToolTip"))
         {
            dispatchEvent(new Event("currentToolTip"));
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function get hideDelay() : Number
      {
         return this._hideDelay;
      }
      
      public function set hideDelay(param1:Number) : void
      {
         this._hideDelay = param1;
      }
      
      public function get hideEffect() : IAbstractEffect
      {
         return this._hideEffect;
      }
      
      public function set hideEffect(param1:IAbstractEffect) : void
      {
         this._hideEffect = param1 as IAbstractEffect;
      }
      
      public function get scrubDelay() : Number
      {
         return this._scrubDelay;
      }
      
      public function set scrubDelay(param1:Number) : void
      {
         this._scrubDelay = param1;
      }
      
      public function get showDelay() : Number
      {
         return this._showDelay;
      }
      
      public function set showDelay(param1:Number) : void
      {
         this._showDelay = param1;
      }
      
      public function get showEffect() : IAbstractEffect
      {
         return this._showEffect;
      }
      
      public function set showEffect(param1:IAbstractEffect) : void
      {
         this._showEffect = param1 as IAbstractEffect;
      }
      
      public function get toolTipClass() : Class
      {
         return this._toolTipClass;
      }
      
      public function set toolTipClass(param1:Class) : void
      {
         this._toolTipClass = param1;
      }
      
      mx_internal function initialize() : void
      {
         if(!this.showTimer)
         {
            this.showTimer = new Timer(0,1);
            this.showTimer.addEventListener(TimerEvent.TIMER,this.showTimer_timerHandler);
         }
         if(!this.hideTimer)
         {
            this.hideTimer = new Timer(0,1);
            this.hideTimer.addEventListener(TimerEvent.TIMER,this.hideTimer_timerHandler);
         }
         if(!this.scrubTimer)
         {
            this.scrubTimer = new Timer(0,1);
         }
         this.initialized = true;
      }
      
      public function registerToolTip(param1:DisplayObject, param2:String, param3:String) : void
      {
         if(!param2 && param3)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.toolTipMouseOverHandler);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.toolTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               this.showImmediately(param1);
            }
         }
         else if(param2 && !param3)
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.toolTipMouseOverHandler);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.toolTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               this.hideImmediately();
            }
         }
      }
      
      public function registerErrorString(param1:DisplayObject, param2:String, param3:String) : void
      {
         if(!param2 && param3)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.errorTipMouseOverHandler);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.errorTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               this.showImmediately(param1);
            }
         }
         else if(param2 && !param3)
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.errorTipMouseOverHandler);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.errorTipMouseOutHandler);
            if(mouseIsOver(param1))
            {
               this.hideImmediately();
            }
         }
      }
      
      private function showImmediately(param1:DisplayObject) : void
      {
         var _loc2_:Number = ToolTipManager.showDelay;
         ToolTipManager.showDelay = 0;
         this.checkIfTargetChanged(param1);
         ToolTipManager.showDelay = _loc2_;
      }
      
      private function hideImmediately() : void
      {
         this.checkIfTargetChanged(null);
      }
      
      mx_internal function checkIfTargetChanged(param1:DisplayObject) : void
      {
         if(!this.enabled)
         {
            return;
         }
         this.findTarget(param1);
         if(this.currentTarget != this.previousTarget)
         {
            this.targetChanged();
            this.previousTarget = this.currentTarget;
         }
      }
      
      mx_internal function findTarget(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = false;
         while(param1)
         {
            if(param1 is IValidatorListener)
            {
               this.currentText = IValidatorListener(param1).errorString;
               if(param1 is IStyleClient)
               {
                  _loc2_ = FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0 || IStyleClient(param1).getStyle("showErrorTip");
               }
               if(this.currentText != null && this.currentText != "" && _loc2_)
               {
                  this.currentTarget = param1;
                  this.isError = true;
                  return;
               }
            }
            if(param1 is IToolTipManagerClient)
            {
               this.currentText = IToolTipManagerClient(param1).toolTip;
               if(this.currentText != null)
               {
                  this.currentTarget = param1;
                  this.isError = false;
                  return;
               }
            }
            param1 = param1.parent;
         }
         this.currentText = null;
         this.currentTarget = null;
      }
      
      mx_internal function targetChanged() : void
      {
         var _loc1_:ToolTipEvent = null;
         if(!this.initialized)
         {
            this.initialize();
         }
         if(this.previousTarget && this.currentToolTip)
         {
            if(this.currentToolTip is IToolTip)
            {
               _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
               _loc1_.toolTip = this.currentToolTip;
               this.previousTarget.dispatchEvent(_loc1_);
            }
            else if(hasEventListener(ToolTipEvent.TOOL_TIP_HIDE))
            {
               dispatchEvent(new Event(ToolTipEvent.TOOL_TIP_HIDE));
            }
         }
         this.reset();
         if(this.currentTarget)
         {
            if(this.currentText == "")
            {
               return;
            }
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_START);
            this.currentTarget.dispatchEvent(_loc1_);
            if(this.showDelay == 0 || this.scrubTimer.running)
            {
               this.createTip();
               this.initializeTip();
               this.positionTip();
               this.showTip();
            }
            else
            {
               this.showTimer.delay = this.showDelay;
               this.showTimer.start();
            }
         }
      }
      
      mx_internal function createTip() : void
      {
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_CREATE);
         this.currentTarget.dispatchEvent(_loc1_);
         if(_loc1_.toolTip)
         {
            this.currentToolTip = _loc1_.toolTip;
         }
         else
         {
            this.currentToolTip = new this.toolTipClass();
         }
         this.currentToolTip.visible = false;
         if(this.currentToolTip is IFlexModule && IFlexModule(this.currentToolTip).moduleFactory == null && this.currentTarget is IFlexModule)
         {
            IFlexModule(this.currentToolTip).moduleFactory = IFlexModule(this.currentTarget).moduleFactory;
         }
         if(hasEventListener("createTip"))
         {
            if(!dispatchEvent(new Event("createTip",false,true)))
            {
               return;
            }
         }
         var _loc2_:ISystemManager = this.getSystemManager(this.currentTarget) as ISystemManager;
         _loc2_.topLevelSystemManager.toolTipChildren.addChild(this.currentToolTip as DisplayObject);
      }
      
      mx_internal function initializeTip() : void
      {
         if(this.currentToolTip is IToolTip)
         {
            IToolTip(this.currentToolTip).text = this.currentText;
         }
         if(this.isError && this.currentToolTip is IStyleClient)
         {
            IStyleClient(this.currentToolTip).setStyle("styleName","errorTip");
         }
         this.sizeTip(this.currentToolTip);
         if(this.currentToolTip is IStyleClient)
         {
            if(this.showEffect)
            {
               IStyleClient(this.currentToolTip).setStyle("showEffect",this.showEffect);
            }
            if(this.hideEffect)
            {
               IStyleClient(this.currentToolTip).setStyle("hideEffect",this.hideEffect);
            }
         }
         if(this.showEffect || this.hideEffect)
         {
            this.currentToolTip.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
         }
      }
      
      public function sizeTip(param1:IToolTip) : void
      {
         if(param1 is IInvalidating)
         {
            IInvalidating(param1).validateNow();
         }
         param1.setActualSize(param1.getExplicitOrMeasuredWidth(),param1.getExplicitOrMeasuredHeight());
      }
      
      mx_internal function positionTip() : void
      {
         var _loc1_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:ILayoutDirectionElement = null;
         var _loc8_:Rectangle = null;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:ISystemManager = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Point = null;
         if(this.currentTarget is ILayoutDirectionElement)
         {
            _loc1_ = ILayoutDirectionElement(this.currentTarget).layoutDirection;
         }
         else
         {
            _loc1_ = LayoutDirection.LTR;
         }
         var _loc2_:* = _loc1_ == LayoutDirection.RTL;
         var _loc5_:Number = this.currentToolTip.screen.width;
         var _loc6_:Number = this.currentToolTip.screen.height;
         if(this.isError)
         {
            _loc7_ = this.currentToolTip as ILayoutDirectionElement;
            if(_loc7_ && _loc7_.layoutDirection != _loc1_)
            {
               _loc7_.layoutDirection = _loc1_;
               _loc7_.invalidateLayoutDirection();
            }
            _loc8_ = getGlobalBounds(this.currentTarget,this.currentToolTip.root,_loc2_);
            _loc3_ = !!_loc2_?Number(_loc8_.left - 4):Number(_loc8_.right + 4);
            _loc4_ = _loc8_.top - 1;
            _loc9_ = !!_loc2_?_loc3_ < this.currentToolTip.width:_loc3_ + this.currentToolTip.width > _loc5_;
            if(_loc9_)
            {
               _loc10_ = NaN;
               _loc11_ = NaN;
               _loc3_ = !!_loc2_?Number(_loc8_.right + 2 - this.currentToolTip.width):Number(_loc8_.left - 2);
               if(_loc2_)
               {
                  if(_loc3_ < this.currentToolTip.width + 4)
                  {
                     _loc3_ = 4;
                     _loc10_ = _loc8_.right - 2;
                  }
               }
               else if(_loc3_ + this.currentToolTip.width + 4 > _loc5_)
               {
                  _loc10_ = _loc5_ - _loc3_ - 4;
               }
               if(!isNaN(_loc10_))
               {
                  _loc11_ = Object(this.toolTipClass).maxWidth;
                  Object(this.toolTipClass).maxWidth = _loc10_;
                  if(this.currentToolTip is IStyleClient)
                  {
                     IStyleClient(this.currentToolTip).setStyle("borderStyle","errorTipAbove");
                  }
                  this.currentToolTip["text"] = this.currentToolTip["text"];
               }
               else
               {
                  if(this.currentToolTip is IStyleClient)
                  {
                     IStyleClient(this.currentToolTip).setStyle("borderStyle","errorTipAbove");
                  }
                  this.currentToolTip["text"] = this.currentToolTip["text"];
               }
               if(this.currentToolTip.height + 2 < _loc8_.top)
               {
                  _loc4_ = _loc8_.top - (this.currentToolTip.height + 2);
               }
               else
               {
                  _loc4_ = _loc8_.bottom + 2;
                  if(!isNaN(_loc10_))
                  {
                     Object(this.toolTipClass).maxWidth = _loc10_;
                  }
                  if(this.currentToolTip is IStyleClient)
                  {
                     IStyleClient(this.currentToolTip).setStyle("borderStyle","errorTipBelow");
                  }
                  this.currentToolTip["text"] = this.currentToolTip["text"];
               }
            }
            this.sizeTip(this.currentToolTip);
            if(!isNaN(_loc11_))
            {
               Object(this.toolTipClass).maxWidth = _loc11_;
            }
            else if(_loc2_)
            {
               _loc3_ = _loc8_.right + 2 - this.currentToolTip.width;
            }
         }
         else
         {
            _loc12_ = this.getSystemManager(this.currentTarget);
            _loc3_ = DisplayObject(_loc12_).mouseX + 11;
            if(_loc2_)
            {
               _loc3_ = _loc3_ - this.currentToolTip.width;
            }
            _loc4_ = DisplayObject(_loc12_).mouseY + 22;
            _loc13_ = this.currentToolTip.width;
            if(_loc2_)
            {
               if(_loc3_ < 2)
               {
                  _loc3_ = 2;
               }
            }
            else if(_loc3_ + _loc13_ > _loc5_)
            {
               _loc3_ = _loc5_ - _loc13_;
            }
            _loc14_ = this.currentToolTip.height;
            if(_loc4_ + _loc14_ > _loc6_)
            {
               _loc4_ = _loc6_ - _loc14_;
            }
            _loc15_ = new Point(_loc3_,_loc4_);
            _loc15_ = DisplayObject(_loc12_).localToGlobal(_loc15_);
            _loc15_ = DisplayObject(_loc12_.getSandboxRoot()).globalToLocal(_loc15_);
            _loc3_ = _loc15_.x;
            _loc4_ = _loc15_.y;
         }
         this.currentToolTip.move(_loc3_,_loc4_);
      }
      
      mx_internal function showTip() : void
      {
         var _loc2_:ISystemManager = null;
         var _loc1_:ToolTipEvent = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOW);
         _loc1_.toolTip = this.currentToolTip;
         this.currentTarget.dispatchEvent(_loc1_);
         if(this.isError)
         {
            this.currentTarget.addEventListener(Event.CHANGE,this.changeHandler);
         }
         else
         {
            _loc2_ = this.getSystemManager(this.currentTarget);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.systemManager_mouseDownHandler);
         }
         this.currentToolTip.visible = true;
         if(!this.showEffect)
         {
            this.showEffectEnded();
         }
      }
      
      mx_internal function hideTip() : void
      {
         var _loc1_:ToolTipEvent = null;
         var _loc2_:ISystemManager = null;
         if(this.previousTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_HIDE);
            _loc1_.toolTip = this.currentToolTip;
            this.previousTarget.dispatchEvent(_loc1_);
         }
         if(this.currentToolTip)
         {
            this.currentToolTip.visible = false;
         }
         if(this.isError)
         {
            if(this.currentTarget)
            {
               this.currentTarget.removeEventListener(Event.CHANGE,this.changeHandler);
            }
         }
         else if(this.previousTarget)
         {
            _loc2_ = this.getSystemManager(this.previousTarget);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.systemManager_mouseDownHandler);
         }
         if(!this.hideEffect)
         {
            this.hideEffectEnded();
         }
      }
      
      mx_internal function reset() : void
      {
         var _loc1_:DynamicEvent = null;
         var _loc2_:ISystemManager = null;
         this.showTimer.reset();
         this.hideTimer.reset();
         if(this.currentToolTip)
         {
            if(this.showEffect || this.hideEffect)
            {
               this.currentToolTip.removeEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
            }
            EffectManager.endEffectsForTarget(this.currentToolTip);
            if(hasEventListener("removeChild"))
            {
               _loc1_ = new DynamicEvent("removeChild",false,true);
               _loc1_.sm = this.currentToolTip.systemManager;
               _loc1_.toolTip = this.currentToolTip;
            }
            if(!_loc1_ || dispatchEvent(_loc1_))
            {
               _loc2_ = this.currentToolTip.systemManager as ISystemManager;
               _loc2_.topLevelSystemManager.toolTipChildren.removeChild(this.currentToolTip as DisplayObject);
            }
            this.currentToolTip = null;
            this.scrubTimer.delay = this.scrubDelay;
            this.scrubTimer.reset();
            if(this.scrubDelay > 0)
            {
               this.scrubTimer.delay = this.scrubDelay;
               this.scrubTimer.start();
            }
         }
      }
      
      public function createToolTip(param1:String, param2:Number, param3:Number, param4:String = null, param5:IUIComponent = null) : IToolTip
      {
         var _loc8_:DynamicEvent = null;
         var _loc6_:ToolTip = new ToolTip();
         var _loc7_:ISystemManager = !!param5?param5.systemManager as ISystemManager:FlexGlobals.topLevelApplication.systemManager as ISystemManager;
         if(param5 is IFlexModule)
         {
            _loc6_.moduleFactory = IFlexModule(param5).moduleFactory;
         }
         else
         {
            _loc6_.moduleFactory = _loc7_;
         }
         if(hasEventListener("addChild"))
         {
            _loc8_ = new DynamicEvent("addChild",false,true);
            _loc8_.sm = _loc7_;
            _loc8_.toolTip = _loc6_;
         }
         if(!_loc8_ || dispatchEvent(_loc8_))
         {
            _loc7_.topLevelSystemManager.toolTipChildren.addChild(_loc6_ as DisplayObject);
         }
         if(param4)
         {
            _loc6_.setStyle("styleName","errorTip");
            _loc6_.setStyle("borderStyle",param4);
         }
         _loc6_.text = param1;
         this.sizeTip(_loc6_);
         _loc6_.move(param2,param3);
         return _loc6_ as IToolTip;
      }
      
      public function destroyToolTip(param1:IToolTip) : void
      {
         var _loc2_:DynamicEvent = null;
         var _loc3_:ISystemManager = null;
         if(hasEventListener("removeChild"))
         {
            _loc2_ = new DynamicEvent("removeChild",false,true);
            _loc2_.sm = param1.systemManager;
            _loc2_.toolTip = param1;
         }
         if(!_loc2_ || dispatchEvent(_loc2_))
         {
            _loc3_ = param1.systemManager as ISystemManager;
            _loc3_.topLevelSystemManager.toolTipChildren.removeChild(param1 as DisplayObject);
         }
      }
      
      mx_internal function showEffectEnded() : void
      {
         var _loc1_:ToolTipEvent = null;
         if(this.hideDelay == 0)
         {
            this.hideTip();
         }
         else if(this.hideDelay < Infinity)
         {
            this.hideTimer.delay = this.hideDelay;
            this.hideTimer.start();
         }
         if(this.currentTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_SHOWN);
            _loc1_.toolTip = this.currentToolTip;
            this.currentTarget.dispatchEvent(_loc1_);
         }
      }
      
      mx_internal function hideEffectEnded() : void
      {
         var _loc1_:ToolTipEvent = null;
         this.reset();
         if(this.previousTarget)
         {
            _loc1_ = new ToolTipEvent(ToolTipEvent.TOOL_TIP_END);
            _loc1_.toolTip = this.currentToolTip;
            this.previousTarget.dispatchEvent(_loc1_);
         }
      }
      
      mx_internal function getSystemManager(param1:DisplayObject) : ISystemManager
      {
         return param1 is IUIComponent?IUIComponent(param1).systemManager:null;
      }
      
      mx_internal function toolTipMouseOverHandler(param1:MouseEvent) : void
      {
         this.checkIfTargetChanged(DisplayObject(param1.target));
      }
      
      mx_internal function toolTipMouseOutHandler(param1:MouseEvent) : void
      {
         this.checkIfTargetChanged(param1.relatedObject);
      }
      
      mx_internal function errorTipMouseOverHandler(param1:MouseEvent) : void
      {
         this.checkIfTargetChanged(DisplayObject(param1.target));
      }
      
      mx_internal function errorTipMouseOutHandler(param1:MouseEvent) : void
      {
         this.checkIfTargetChanged(param1.relatedObject);
      }
      
      mx_internal function showTimer_timerHandler(param1:TimerEvent) : void
      {
         if(this.currentTarget)
         {
            this.createTip();
            this.initializeTip();
            this.positionTip();
            this.showTip();
         }
      }
      
      mx_internal function hideTimer_timerHandler(param1:TimerEvent) : void
      {
         this.hideTip();
      }
      
      mx_internal function effectEndHandler(param1:EffectEvent) : void
      {
         if(param1.effectInstance.effect == this.showEffect)
         {
            this.showEffectEnded();
         }
         else if(param1.effectInstance.effect == this.hideEffect)
         {
            this.hideEffectEnded();
         }
      }
      
      mx_internal function systemManager_mouseDownHandler(param1:MouseEvent) : void
      {
         this.reset();
      }
      
      mx_internal function changeHandler(param1:Event) : void
      {
         this.reset();
      }
   }
}
