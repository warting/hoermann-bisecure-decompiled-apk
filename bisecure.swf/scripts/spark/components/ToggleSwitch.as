package spark.components
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ResizeEvent;
   import spark.components.supportClasses.ToggleButtonBase;
   import spark.effects.animation.Animation;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.Linear;
   import spark.effects.easing.Sine;
   
   use namespace mx_internal;
   
   public class ToggleSwitch extends ToggleButtonBase
   {
      
      private static const MOUSE_MOVE_TOLERANCE:Number = 0.15;
       
      
      private var lastMouseX:Number = 0;
      
      private var mouseDragUtil:MouseDragUtil;
      
      private var mouseMoved:Boolean = false;
      
      private var slideToPosition:Number = 0;
      
      private var stageOffset:Point;
      
      private var positionOffset:Number = 0;
      
      [SkinPart(required="false")]
      public var thumb:IVisualElement;
      
      [SkinPart(required="false")]
      public var track:IVisualElement;
      
      private var _animator:Animation = null;
      
      private var _thumbPosition:Number = 0.0;
      
      public function ToggleSwitch()
      {
         super();
         stickyHighlighting = true;
         this.animator = new Animation();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         var _loc2_:Number = this.selectedToPosition(param1);
         this.slideToPosition = _loc2_;
         this.setThumbPosition(_loc2_);
      }
      
      mx_internal function get animator() : Animation
      {
         return this._animator;
      }
      
      mx_internal function set animator(param1:Animation) : void
      {
         this._animator = param1;
      }
      
      [Bindable(event="thumbPositionChanged")]
      public function get thumbPosition() : Number
      {
         return this._thumbPosition;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.updateSkinDisplayList();
      }
      
      override protected function attachSkin() : void
      {
         super.attachSkin();
         skin.addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
         skin.addEventListener(ResizeEvent.RESIZE,this.resizeHandler);
      }
      
      override protected function addHandlers() : void
      {
         super.addHandlers();
         this.mouseDragUtil = new MouseDragUtil(this,this.mouseDownHandler,this.mouseDragHandler,this.thinnedMouseDragHandler,this.mouseUpHandler);
         this.mouseDragUtil.setupHandlers();
      }
      
      private function positionToSelected(param1:Number) : Boolean
      {
         return param1 > 0.5;
      }
      
      private function selectedToPosition(param1:Boolean) : Number
      {
         return !!param1?Number(1):Number(0);
      }
      
      private function moveToPositionAndSelect(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = getStyle("slideDuration");
         if(param1 != this.thumbPosition && _loc2_ > 0)
         {
            if(this.animator.isPlaying)
            {
               this.stopAnimation();
            }
            this.slideToPosition = param1;
            _loc3_ = _loc2_ * Math.abs(this.thumbPosition - this.slideToPosition);
            this.animateToPosition(this.animator,this.thumbPosition,param1,_loc3_);
         }
         else
         {
            this.setSelected(this.positionToSelected(param1));
         }
      }
      
      private function moveToPosition(param1:Number) : void
      {
         if(param1 != this.thumbPosition)
         {
            if(this.animator.isPlaying)
            {
               this.stopAnimation();
            }
            this.animateToPosition(this.animator,this.thumbPosition,param1,ToggleSwitch.MAX_UPDATE_RATE);
         }
      }
      
      private function setSelected(param1:Boolean) : void
      {
         var _loc2_:* = param1 != selected;
         this.selected = param1;
         if(_loc2_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function setupAnimator(param1:Animation, param2:Boolean) : void
      {
         this.stopAnimation();
         var _loc3_:AnimationTargetHelper = param1.animationTarget as ToggleSwitch;
         if(!_loc3_)
         {
            param1.animationTarget = _loc3_ = new AnimationTargetHelper();
         }
         _loc3_.updateFunction = this.animationUpdateHandler;
         param1.motionPaths = new <MotionPath>[null];
         if(param2)
         {
            _loc3_.endFunction = this.animationEndHandler;
            param1.easer = new Sine(0);
         }
         else
         {
            _loc3_.endFunction = null;
            param1.easer = new Linear();
         }
      }
      
      private function animateToPosition(param1:Animation, param2:Number, param3:Number, param4:Number) : void
      {
         if(param1.isPlaying)
         {
            this.stopAnimation();
         }
         param1.duration = param4;
         param1.motionPaths[0] = new SimpleMotionPath("position",param2,param3);
         param1.play();
      }
      
      private function setThumbPosition(param1:Number) : void
      {
         if(param1 == this._thumbPosition)
         {
            return;
         }
         param1 = Math.min(param1,1);
         param1 = Math.max(param1,0);
         if(param1 == this._thumbPosition)
         {
            return;
         }
         this._thumbPosition = param1;
         invalidateDisplayList();
         if(hasEventListener("thumbPositionChanged"))
         {
            dispatchEvent(new Event("thumbPositionChanged"));
         }
      }
      
      private function stopAnimation() : void
      {
         this.animator.stop();
      }
      
      private function updateSkinDisplayList() : void
      {
         if(!this.thumb || !this.track || !this.thumb.parent || !this.track.parent)
         {
            return;
         }
         var _loc1_:Number = this.getGlobalTrackRange() * this.thumbPosition;
         var _loc2_:Point = this.track.parent.localToGlobal(new Point(this.track.getLayoutBoundsX()));
         _loc2_.x = _loc2_.x + _loc1_;
         var _loc3_:Point = this.thumb.parent.globalToLocal(_loc2_);
         this.thumb.setLayoutBoundsPosition(Math.round(_loc3_.x),this.thumb.getLayoutBoundsY());
      }
      
      private function getGlobalTrackRange() : Number
      {
         var _loc1_:Point = this.track.parent.localToGlobal(new Point(this.track.getLayoutBoundsWidth()));
         var _loc2_:Point = this.thumb.parent.localToGlobal(new Point(this.thumb.getLayoutBoundsWidth()));
         return _loc1_.x - _loc2_.x;
      }
      
      private function isSelectionAnimationRunning() : Boolean
      {
         return this.animator && this.animator.isPlaying && AnimationTargetHelper(this.animator.animationTarget).endFunction != null;
      }
      
      private function updateCompleteHandler(param1:FlexEvent) : void
      {
         this.updateSkinDisplayList();
         skin.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
      }
      
      private function resizeHandler(param1:ResizeEvent) : void
      {
         skin.addEventListener(FlexEvent.UPDATE_COMPLETE,this.updateCompleteHandler);
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         this.updateSkinDisplayList();
      }
      
      override protected function mouseEventHandler(param1:Event) : void
      {
         if(this.isSelectionAnimationRunning())
         {
            return;
         }
         super.mouseEventHandler(param1);
      }
      
      override protected function buttonReleased() : void
      {
         var _loc1_:Number = NaN;
         if(this.isSelectionAnimationRunning())
         {
            return;
         }
         this.setupAnimator(this.animator,true);
         if(this.mouseMoved)
         {
            _loc1_ = this.selectedToPosition(this.thumbPosition >= 0.5);
         }
         else
         {
            _loc1_ = this.selectedToPosition(this.slideToPosition < 0.5);
         }
         this.moveToPositionAndSelect(_loc1_);
         this.mouseMoved = false;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         if(this.isSelectionAnimationRunning())
         {
            return;
         }
         this.setupAnimator(this.animator,false);
         this.mouseMoved = false;
         this.stageOffset = new Point(param1.stageX,param1.stageY);
         this.positionOffset = this.thumbPosition;
      }
      
      private function mouseDragHandler(param1:MouseEvent) : void
      {
         this.lastMouseX = param1.stageX;
      }
      
      private function thinnedMouseDragHandler(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         if(mouseCaptured && this.track && this.thumb)
         {
            _loc2_ = (this.lastMouseX - this.stageOffset.x) / this.getGlobalTrackRange();
            if(!this.mouseMoved && Math.abs(_loc2_) > MOUSE_MOVE_TOLERANCE && param1.type != MouseEvent.MOUSE_UP)
            {
               this.mouseMoved = true;
            }
            if(this.mouseMoved)
            {
               this.moveToPosition(this.positionOffset + _loc2_ + (!!selected?MOUSE_MOVE_TOLERANCE:-MOUSE_MOVE_TOLERANCE));
            }
         }
      }
      
      private function mouseUpHandler(param1:Event) : void
      {
         if(param1.target != this && !mouseCaptured)
         {
            this.buttonReleased();
         }
      }
      
      private function animationUpdateHandler(param1:Animation) : void
      {
         this.setThumbPosition(param1.currentValue["position"]);
      }
      
      private function animationEndHandler(param1:Animation) : void
      {
         this.setSelected(this.positionToSelected(this.slideToPosition));
      }
   }
}

import spark.effects.animation.Animation;
import spark.effects.animation.IAnimationTarget;

class AnimationTargetHelper implements IAnimationTarget
{
    
   
   public var updateFunction:Function;
   
   public var endFunction:Function;
   
   function AnimationTargetHelper(param1:Function = null, param2:Function = null)
   {
      super();
      this.updateFunction = param1;
      this.endFunction = param2;
   }
   
   public function animationStart(param1:Animation) : void
   {
   }
   
   public function animationEnd(param1:Animation) : void
   {
      if(this.endFunction != null)
      {
         this.endFunction(param1);
      }
   }
   
   public function animationStop(param1:Animation) : void
   {
   }
   
   public function animationRepeat(param1:Animation) : void
   {
   }
   
   public function animationUpdate(param1:Animation) : void
   {
      if(this.updateFunction != null)
      {
         this.updateFunction(param1);
      }
   }
}

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import mx.core.UIComponent;
import spark.utils.MouseEventUtil;

class MouseDragUtil
{
   
   public static const MAX_UPDATE_RATE:Number = 30;
    
   
   private var mouseDownHandler:Function;
   
   private var mouseMoveEveryHandler:Function;
   
   private var mouseMoveThinnedHandler:Function;
   
   private var mouseUpHandler:Function;
   
   private var target:UIComponent;
   
   private var dragPending:Boolean;
   
   private var dragTimer:Timer;
   
   function MouseDragUtil(param1:UIComponent, param2:Function, param3:Function, param4:Function, param5:Function)
   {
      super();
      this.target = param1;
      this.mouseDownHandler = param2;
      this.mouseMoveEveryHandler = param3;
      this.mouseMoveThinnedHandler = param4;
      this.mouseUpHandler = param5;
   }
   
   public function setupHandlers() : void
   {
      MouseEventUtil.addDownDragUpListeners(this.target,this.mouseDownHandlerWrapper,this.mouseDragHandlerWrapper,this.mouseUpHandlerWrapper);
   }
   
   public function removeHandlers() : void
   {
      MouseEventUtil.removeDownDragUpListeners(this.target,this.mouseDownHandlerWrapper,this.mouseDragHandlerWrapper,this.mouseUpHandlerWrapper);
      if(this.dragTimer)
      {
         this.dragTimer.stop();
         this.dragTimer.removeEventListener(TimerEvent.TIMER,this.dragTimerHandler);
         this.dragTimer = null;
      }
   }
   
   private function mouseDownHandlerWrapper(param1:MouseEvent) : void
   {
      this.mouseDownHandler(param1);
   }
   
   private function mouseDragHandlerWrapper(param1:MouseEvent) : void
   {
      this.mouseMoveEveryHandler(param1);
      if(!this.dragTimer)
      {
         this.dragTimer = new Timer(1000 / MAX_UPDATE_RATE,0);
         this.dragTimer.addEventListener(TimerEvent.TIMER,this.dragTimerHandler);
      }
      if(!this.dragTimer.running)
      {
         this.mouseMoveThinnedHandler(param1);
         this.dragPending = false;
         this.dragTimer.start();
      }
      else
      {
         this.dragPending = true;
      }
   }
   
   private function dragTimerHandler(param1:TimerEvent) : void
   {
      if(this.dragPending)
      {
         this.mouseMoveThinnedHandler(param1);
         this.dragPending = false;
      }
      else
      {
         this.dragTimer.stop();
      }
   }
   
   private function mouseUpHandlerWrapper(param1:Event) : void
   {
      if(this.dragTimer)
      {
         if(this.dragPending)
         {
            this.mouseMoveThinnedHandler(param1);
            this.dragPending = false;
         }
         this.dragTimer.stop();
         this.dragTimer.removeEventListener(TimerEvent.TIMER,this.dragTimerHandler);
         this.dragTimer = null;
      }
      this.mouseUpHandler(param1);
   }
}
