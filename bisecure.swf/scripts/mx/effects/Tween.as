package mx.effects
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.TweenEvent;
   
   use namespace mx_internal;
   
   public class Tween extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      mx_internal static var activeTweens:Array = [];
      
      private static var interval:Number = 10;
      
      private static var timer:Timer = null;
      
      mx_internal static var intervalTime:Number = NaN;
       
      
      mx_internal var needToLayout:Boolean = false;
      
      private var id:int = -1;
      
      private var maxDelay:Number = 87.5;
      
      private var arrayMode:Boolean;
      
      private var _doSeek:Boolean = false;
      
      private var _isPlaying:Boolean = true;
      
      private var _doReverse:Boolean = false;
      
      mx_internal var startTime:Number;
      
      private var previousUpdateTime:Number;
      
      private var userEquation:Function;
      
      private var updateFunction:Function;
      
      private var endFunction:Function;
      
      private var endValue:Object;
      
      private var startValue:Object;
      
      private var started:Boolean = false;
      
      public var duration:Number = 3000;
      
      public var listener:Object;
      
      private var _playheadTime:Number = 0;
      
      private var _invertValues:Boolean = false;
      
      public function Tween(param1:Object, param2:Object, param3:Object, param4:Number = -1, param5:Number = -1, param6:Function = null, param7:Function = null)
      {
         this.userEquation = this.defaultEasingFunction;
         super();
         if(!param1)
         {
            return;
         }
         if(param2 is Array)
         {
            this.arrayMode = true;
         }
         this.listener = param1;
         this.startValue = param2;
         this.endValue = param3;
         if(!isNaN(param4) && param4 != -1)
         {
            this.duration = param4;
         }
         if(!isNaN(param5) && param5 != -1)
         {
            this.maxDelay = 1000 / param5;
         }
         this.updateFunction = param6;
         this.endFunction = param7;
         if(param4 == 0)
         {
            this.id = -1;
            this.endTween();
         }
         else
         {
            Tween.addTween(this);
         }
      }
      
      private static function addTween(param1:Tween) : void
      {
         param1.id = activeTweens.length;
         activeTweens.push(param1);
         if(!timer)
         {
            timer = new Timer(interval);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
            timer.start();
         }
         else
         {
            timer.start();
         }
         if(isNaN(intervalTime))
         {
            intervalTime = getTimer();
         }
         param1.startTime = param1.previousUpdateTime = intervalTime;
      }
      
      private static function removeTweenAt(param1:int) : void
      {
         var _loc4_:Tween = null;
         var _loc2_:int = activeTweens.length;
         if(param1 >= _loc2_ || param1 < 0)
         {
            return;
         }
         activeTweens.splice(param1,1);
         _loc2_--;
         var _loc3_:int = param1;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = Tween(activeTweens[_loc3_]);
            _loc4_.id--;
            _loc3_++;
         }
         if(_loc2_ == 0)
         {
            intervalTime = NaN;
            timer.reset();
         }
      }
      
      mx_internal static function removeTween(param1:Tween) : void
      {
         removeTweenAt(param1.id);
         param1.id = -1;
      }
      
      private static function timerHandler(param1:TimerEvent) : void
      {
         var _loc6_:Tween = null;
         var _loc2_:Boolean = false;
         var _loc3_:Number = intervalTime;
         var _loc4_:int = activeTweens.length;
         intervalTime = getTimer();
         var _loc5_:int = _loc4_ - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = Tween(activeTweens[_loc5_]);
            if(_loc6_)
            {
               _loc6_.needToLayout = false;
               _loc6_.doInterval();
               if(_loc6_.needToLayout)
               {
                  _loc2_ = true;
               }
            }
            _loc5_--;
         }
         if(_loc2_)
         {
            UIComponentGlobals.layoutManager.validateNow();
         }
         param1.updateAfterEvent();
      }
      
      mx_internal function get playheadTime() : Number
      {
         return this._playheadTime;
      }
      
      mx_internal function get playReversed() : Boolean
      {
         return this._invertValues;
      }
      
      mx_internal function set playReversed(param1:Boolean) : void
      {
         this._invertValues = param1;
      }
      
      public function setTweenHandlers(param1:Function, param2:Function) : void
      {
         this.updateFunction = param1;
         this.endFunction = param2;
      }
      
      public function set easingFunction(param1:Function) : void
      {
         this.userEquation = param1;
      }
      
      public function endTween() : void
      {
         var _loc1_:TweenEvent = new TweenEvent(TweenEvent.TWEEN_END);
         var _loc2_:Object = this.getCurrentValue(this.duration);
         _loc1_.value = _loc2_;
         dispatchEvent(_loc1_);
         if(this.endFunction != null)
         {
            this.endFunction(_loc2_);
         }
         else
         {
            this.listener.onTweenEnd(_loc2_);
         }
         if(this.id >= 0)
         {
            Tween.removeTweenAt(this.id);
            this.id = -1;
         }
      }
      
      mx_internal function doInterval() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:TweenEvent = null;
         var _loc5_:TweenEvent = null;
         var _loc1_:Boolean = false;
         this.previousUpdateTime = intervalTime;
         if(this._isPlaying || this._doSeek)
         {
            _loc2_ = intervalTime - this.startTime;
            this._playheadTime = _loc2_;
            _loc3_ = this.getCurrentValue(_loc2_);
            if(_loc2_ >= this.duration && !this._doSeek)
            {
               this.endTween();
               _loc1_ = true;
            }
            else
            {
               if(!this.started)
               {
                  _loc5_ = new TweenEvent(TweenEvent.TWEEN_START);
                  dispatchEvent(_loc5_);
                  this.started = true;
               }
               _loc4_ = new TweenEvent(TweenEvent.TWEEN_UPDATE);
               _loc4_.value = _loc3_;
               dispatchEvent(_loc4_);
               if(this.updateFunction != null)
               {
                  this.updateFunction(_loc3_);
               }
               else
               {
                  this.listener.onTweenUpdate(_loc3_);
               }
            }
            this._doSeek = false;
         }
         return _loc1_;
      }
      
      mx_internal function getCurrentValue(param1:Number) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.duration == 0)
         {
            return this.endValue;
         }
         if(this._invertValues)
         {
            param1 = this.duration - param1;
         }
         if(this.arrayMode)
         {
            _loc2_ = [];
            _loc3_ = this.startValue.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_[_loc4_] = this.userEquation(param1,this.startValue[_loc4_],this.endValue[_loc4_] - this.startValue[_loc4_],this.duration);
               _loc4_++;
            }
            return _loc2_;
         }
         return this.userEquation(param1,this.startValue,Number(this.endValue) - Number(this.startValue),this.duration);
      }
      
      private function defaultEasingFunction(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 / 2 * (Math.sin(Math.PI * (param1 / param4 - 0.5)) + 1) + param2;
      }
      
      public function seek(param1:Number) : void
      {
         var _loc2_:Number = intervalTime;
         this.previousUpdateTime = _loc2_;
         this.startTime = _loc2_ - param1;
         this._doSeek = true;
         this.doInterval();
      }
      
      public function reverse() : void
      {
         if(this._isPlaying)
         {
            this._doReverse = false;
            this.seek(this.duration - this._playheadTime);
            this._invertValues = !this._invertValues;
         }
         else
         {
            this._doReverse = !this._doReverse;
         }
      }
      
      public function pause() : void
      {
         this._isPlaying = false;
      }
      
      public function stop() : void
      {
         if(this.id >= 0)
         {
            Tween.removeTweenAt(this.id);
            this.id = -1;
         }
      }
      
      public function resume() : void
      {
         this._isPlaying = true;
         this.startTime = intervalTime - this._playheadTime;
         if(this._doReverse)
         {
            this.reverse();
            this._doReverse = false;
         }
      }
   }
}
