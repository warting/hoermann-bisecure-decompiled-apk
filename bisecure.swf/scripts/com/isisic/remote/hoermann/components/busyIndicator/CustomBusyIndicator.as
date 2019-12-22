package com.isisic.remote.hoermann.components.busyIndicator
{
   import com.isisic.remote.hoermann.components.busyIndicator.animations.IAnimation;
   import com.isisic.remote.hoermann.components.busyIndicator.animations.MoveUpAnimation;
   import flash.events.Event;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.effects.Effect;
   import spark.components.Group;
   import spark.primitives.Graphic;
   
   public class CustomBusyIndicator extends Group
   {
       
      
      public var showDebug:Boolean = false;
      
      public var animationDuration:Number = 1000;
      
      public var animationStartDelay:Number = 0;
      
      private var _animation:IAnimation;
      
      private var _icon:IVisualElement;
      
      protected var effect:Effect;
      
      public function CustomBusyIndicator()
      {
         super();
         minHeight = 25;
         minWidth = 25;
         this.animation = new MoveUpAnimation();
         clipAndEnableScrolling = true;
      }
      
      public function get animation() : IAnimation
      {
         return this._animation;
      }
      
      public function set animation(param1:IAnimation) : void
      {
         if(param1 == this._animation)
         {
            return;
         }
         var _loc2_:Boolean = this.isPlaying;
         if(_loc2_)
         {
            this.stopAnimation();
         }
         this._animation = param1;
         if(_loc2_)
         {
            this.startAnimation();
         }
      }
      
      [Bindable("iconChanged")]
      public function get icon() : IVisualElement
      {
         return this._icon;
      }
      
      public function set icon(param1:IVisualElement) : void
      {
         if(param1 == this._icon)
         {
            return;
         }
         this._icon = param1;
         this.updateIcon(param1);
         dispatchEvent(new Event("iconChanged"));
      }
      
      public function get isPlaying() : Boolean
      {
         return this.effect != null && this.effect.isPlaying;
      }
      
      public function startAnimation() : void
      {
         if(this.isPlaying)
         {
            this.stopAnimation();
         }
         var _loc1_:Point = this.animation.getStartPosition(this.icon,this);
         this.icon.x = _loc1_.x;
         this.icon.y = _loc1_.y;
         this.effect = this.animation.getEffect(this.icon,this);
         this.effect.repeatCount = 0;
         this.effect.duration = this.animationDuration;
         this.effect.startDelay = this.animationStartDelay;
         this.effect.play();
      }
      
      public function stopAnimation() : void
      {
         this.effect.stop();
      }
      
      protected function updateIcon(param1:IVisualElement, param2:Boolean = true) : void
      {
         var _loc4_:Graphic = null;
         removeAllElements();
         if(this.showDebug)
         {
            _loc4_ = new Graphic();
            _loc4_.graphics.lineStyle(1,3381538);
            _loc4_.graphics.beginFill(3381538,0.5);
            _loc4_.graphics.drawRect(0,0,width - 1,height - 1);
            _loc4_.graphics.endFill();
            _loc4_.graphics.lineStyle();
            addElement(_loc4_);
         }
         var _loc3_:Number = 1;
         if(this.icon.width > this.icon.height)
         {
            _loc3_ = this.icon.height / this.icon.width;
            this.icon.width = this.width;
            this.icon.height = this.icon.width * _loc3_;
         }
         else
         {
            _loc3_ = this.icon.width / this.icon.height;
            this.icon.height = this.height;
            this.icon.width = this.icon.height * _loc3_;
         }
         this.applyIconProperties();
         addElement(param1);
      }
      
      protected function applyIconProperties() : void
      {
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
         super.setActualSize(param1,param2);
         this.updateIcon(this.icon);
         this.stopAnimation();
         this.startAnimation();
      }
   }
}
