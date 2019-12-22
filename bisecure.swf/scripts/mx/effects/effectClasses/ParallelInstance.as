package mx.effects.effectClasses
{
   import flash.events.TimerEvent;
   import flash.system.ApplicationDomain;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Parallel;
   
   use namespace mx_internal;
   
   public class ParallelInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var resizeEffectType:Class;
      
      private static var resizeEffectLoaded:Boolean = false;
       
      
      private var doneEffectQueue:Array;
      
      private var replayEffectQueue:Array;
      
      private var isReversed:Boolean = false;
      
      private var timer:Timer;
      
      public function ParallelInstance(param1:Object)
      {
         super(param1);
      }
      
      override mx_internal function get durationWithoutRepeat() : Number
      {
         var _loc4_:Array = null;
         var _loc1_:Number = 0;
         var _loc2_:int = childSets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = childSets[_loc3_];
            _loc1_ = Math.max(_loc4_[0].actualDuration,_loc1_);
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function set playheadTime(param1:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:EffectInstance = null;
         super.playheadTime = param1;
         var _loc2_:Number = Parallel(effect).compositeDuration;
         var _loc3_:Number = _loc2_ + startDelay + repeatDelay;
         var _loc4_:Number = _loc2_ + repeatDelay;
         var _loc5_:Number = _loc3_ + _loc4_ * (repeatCount - 1);
         if(param1 <= _loc3_)
         {
            _loc6_ = Math.min(param1 - startDelay,_loc2_);
            playCount = 1;
         }
         else if(param1 >= _loc5_ && repeatCount != 0)
         {
            _loc6_ = _loc2_;
            playCount = repeatCount;
         }
         else
         {
            _loc8_ = param1 - _loc3_;
            _loc6_ = Math.min(_loc6_,_loc2_);
            _loc6_ = _loc8_ % _loc4_;
            playCount = 1 + _loc8_ / _loc4_;
         }
         var _loc7_:int = 0;
         while(_loc7_ < childSets.length)
         {
            _loc9_ = childSets[_loc7_];
            _loc10_ = _loc9_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc9_[_loc11_].playheadTime = !!playReversed?Math.max(0,_loc6_ - (this.durationWithoutRepeat - _loc9_[_loc11_].actualDuration)):_loc6_;
               _loc11_++;
            }
            _loc7_++;
         }
         if(playReversed && this.replayEffectQueue != null && this.replayEffectQueue.length > 0)
         {
            _loc12_ = this.durationWithoutRepeat - playheadTime;
            _loc13_ = this.replayEffectQueue.length;
            _loc7_ = _loc13_ - 1;
            while(_loc7_ >= 0)
            {
               _loc14_ = this.replayEffectQueue[_loc7_];
               if(_loc12_ <= _loc14_.actualDuration)
               {
                  if(activeEffectQueue == null)
                  {
                     activeEffectQueue = [];
                  }
                  activeEffectQueue.push(_loc14_);
                  this.replayEffectQueue.splice(_loc7_,1);
                  _loc14_.playReversed = playReversed;
                  _loc14_.startEffect();
               }
               _loc7_--;
            }
         }
      }
      
      override public function addChildSet(param1:Array) : void
      {
         var _loc2_:CompositeEffectInstance = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:CompositeEffectInstance = null;
         super.addChildSet(param1);
         if(childSets.length > 1 && param1.length > 0)
         {
            _loc2_ = param1[0] as CompositeEffectInstance;
            if(!resizeEffectLoaded)
            {
               resizeEffectLoaded = true;
               if(ApplicationDomain.currentDomain.hasDefinition("spark.effects.supportClasses.ResizeInstance"))
               {
                  resizeEffectType = Class(ApplicationDomain.currentDomain.getDefinition("spark.effects.supportClasses.ResizeInstance"));
               }
            }
            if(resizeEffectType && (param1[0] is resizeEffectType || _loc2_ != null && _loc2_.hasResizeInstance()))
            {
               _loc3_ = childSets.pop();
               _loc4_ = 0;
               _loc5_ = 0;
               while(_loc5_ < childSets.length)
               {
                  _loc6_ = childSets[_loc5_];
                  _loc7_ = _loc6_[0] as CompositeEffectInstance;
                  if(!(_loc6_[0] is resizeEffectType) && (!_loc7_ || !_loc7_.hasResizeInstance()))
                  {
                     break;
                  }
                  _loc4_++;
                  _loc5_++;
               }
               childSets.splice(_loc4_,0,_loc3_);
            }
            else if(param1[0] is RotateInstance || _loc2_ != null && _loc2_.hasRotateInstance())
            {
               childSets.unshift(childSets.pop());
            }
         }
      }
      
      override public function play() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EffectInstance = null;
         var _loc8_:Array = null;
         this.doneEffectQueue = [];
         activeEffectQueue = [];
         this.replayEffectQueue = [];
         var _loc1_:Boolean = false;
         super.play();
         _loc2_ = childSets.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = childSets[_loc3_];
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_ && activeEffectQueue != null)
            {
               _loc7_ = _loc4_[_loc6_];
               if(playReversed && _loc7_.actualDuration < this.durationWithoutRepeat)
               {
                  this.replayEffectQueue.push(_loc7_);
                  this.startTimer();
               }
               else
               {
                  _loc7_.playReversed = playReversed;
                  activeEffectQueue.push(_loc7_);
               }
               if(_loc7_.suspendBackgroundProcessing)
               {
                  UIComponent.suspendBackgroundProcessing();
               }
               _loc6_++;
            }
            _loc3_++;
         }
         if(activeEffectQueue.length > 0)
         {
            _loc8_ = activeEffectQueue.slice(0);
            _loc3_ = 0;
            while(_loc3_ < _loc8_.length)
            {
               _loc8_[_loc3_].startEffect();
               _loc3_++;
            }
         }
      }
      
      override public function pause() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.pause();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].pause();
               _loc2_++;
            }
         }
      }
      
      override public function stop() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.stopTimer();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_])
               {
                  _loc1_[_loc3_].stop();
               }
               _loc3_++;
            }
         }
         super.stop();
      }
      
      override public function resume() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.resume();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].resume();
               _loc2_++;
            }
         }
      }
      
      override public function reverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.reverse();
         if(this.isReversed)
         {
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].reverse();
               _loc2_++;
            }
            this.stopTimer();
         }
         else
         {
            this.replayEffectQueue = this.doneEffectQueue.splice(0);
            _loc1_ = activeEffectQueue.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               activeEffectQueue[_loc2_].reverse();
               _loc2_++;
            }
            this.startTimer();
         }
         this.isReversed = !this.isReversed;
      }
      
      override public function end() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         endEffectCalled = true;
         this.stopTimer();
         if(activeEffectQueue)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if(_loc1_[_loc3_])
               {
                  _loc1_[_loc3_].end();
               }
               _loc3_++;
            }
         }
         super.end();
      }
      
      override protected function onEffectEnd(param1:IEffectInstance) : void
      {
         if(Object(param1).suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
         if(endEffectCalled || activeEffectQueue == null)
         {
            return;
         }
         var _loc2_:int = activeEffectQueue.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == activeEffectQueue[_loc3_])
            {
               this.doneEffectQueue.push(param1);
               activeEffectQueue.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == 1)
         {
            finishRepeat();
         }
      }
      
      private function startTimer() : void
      {
         if(!this.timer)
         {
            this.timer = new Timer(10);
            this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this.timer.start();
      }
      
      private function stopTimer() : void
      {
         if(this.timer)
         {
            this.timer.reset();
         }
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         var _loc5_:EffectInstance = null;
         var _loc2_:Number = this.durationWithoutRepeat - playheadTime;
         var _loc3_:int = this.replayEffectQueue.length;
         if(_loc3_ == 0)
         {
            this.stopTimer();
            return;
         }
         var _loc4_:int = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = this.replayEffectQueue[_loc4_];
            if(_loc2_ <= _loc5_.actualDuration)
            {
               if(activeEffectQueue == null)
               {
                  activeEffectQueue = [];
               }
               activeEffectQueue.push(_loc5_);
               this.replayEffectQueue.splice(_loc4_,1);
               _loc5_.playReversed = playReversed;
               _loc5_.startEffect();
            }
            _loc4_--;
         }
      }
   }
}
