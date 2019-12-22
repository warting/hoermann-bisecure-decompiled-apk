package mx.effects.effectClasses
{
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.Tween;
   import mx.events.TweenEvent;
   
   use namespace mx_internal;
   
   public class TweenEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      mx_internal var needToLayout:Boolean = false;
      
      private var _seekTime:Number = 0;
      
      public var easingFunction:Function;
      
      public var tween:Tween;
      
      public function TweenEffectInstance(param1:Object)
      {
         super(param1);
      }
      
      override mx_internal function set playReversed(param1:Boolean) : void
      {
         super.playReversed = param1;
         if(this.tween)
         {
            this.tween.playReversed = param1;
         }
      }
      
      override public function get playheadTime() : Number
      {
         if(this.tween)
         {
            return this.tween.playheadTime + super.playheadTime;
         }
         return 0;
      }
      
      override public function set playheadTime(param1:Number) : void
      {
         if(this.tween)
         {
            this.tween.seek(param1);
         }
         else
         {
            this._seekTime = param1;
         }
      }
      
      override public function pause() : void
      {
         super.pause();
         if(this.tween)
         {
            this.tween.pause();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(this.tween)
         {
            this.tween.stop();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(this.tween)
         {
            this.tween.resume();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         if(this.tween)
         {
            this.tween.reverse();
         }
         super.playReversed = !playReversed;
      }
      
      override public function end() : void
      {
         stopRepeat = true;
         if(delayTimer)
         {
            delayTimer.reset();
         }
         if(this.tween)
         {
            this.tween.endTween();
            this.tween = null;
         }
      }
      
      protected function createTween(param1:Object, param2:Object, param3:Object, param4:Number = -1, param5:Number = -1) : Tween
      {
         var _loc6_:Tween = new Tween(param1,param2,param3,param4,param5);
         _loc6_.addEventListener(TweenEvent.TWEEN_START,this.tweenEventHandler);
         _loc6_.addEventListener(TweenEvent.TWEEN_UPDATE,this.tweenEventHandler);
         _loc6_.addEventListener(TweenEvent.TWEEN_END,this.tweenEventHandler);
         if(this.easingFunction != null)
         {
            _loc6_.easingFunction = this.easingFunction;
         }
         if(this._seekTime > 0)
         {
            _loc6_.seek(this._seekTime);
         }
         _loc6_.playReversed = playReversed;
         return _loc6_;
      }
      
      mx_internal function applyTweenStartValues() : void
      {
         if(duration > 0)
         {
            this.onTweenUpdate(this.tween.getCurrentValue(0));
         }
      }
      
      private function tweenEventHandler(param1:TweenEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function onTweenUpdate(param1:Object) : void
      {
      }
      
      public function onTweenEnd(param1:Object) : void
      {
         this.onTweenUpdate(param1);
         this.tween = null;
         if(this.needToLayout)
         {
            UIComponentGlobals.layoutManager.validateNow();
         }
         finishRepeat();
      }
   }
}
