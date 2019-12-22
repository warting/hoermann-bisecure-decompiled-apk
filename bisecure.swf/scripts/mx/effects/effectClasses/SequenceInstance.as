package mx.effects.effectClasses
{
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Sequence;
   import mx.effects.Tween;
   
   use namespace mx_internal;
   
   public class SequenceInstance extends CompositeEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var activeChildCount:Number;
      
      private var currentInstanceDuration:Number = 0;
      
      private var currentSet:Array;
      
      private var currentSetIndex:int = -1;
      
      private var startTime:Number = 0;
      
      private var isPaused:Boolean = false;
      
      public function SequenceInstance(param1:Object)
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
            _loc1_ = _loc1_ + _loc4_[0].actualDuration;
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function set playheadTime(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Array = null;
         var _loc2_:Number = playheadTime;
         super.playheadTime = param1;
         var _loc7_:Number = Sequence(effect).compositeDuration;
         var _loc8_:Number = _loc7_ + startDelay + repeatDelay;
         var _loc9_:Number = _loc7_ + repeatDelay;
         var _loc10_:Number = _loc8_ + _loc9_ * (repeatCount - 1);
         if(param1 <= _loc8_)
         {
            _loc11_ = Math.min(param1 - startDelay,_loc7_);
            playCount = 1;
         }
         else if(param1 >= _loc10_ && repeatCount != 0)
         {
            _loc11_ = _loc7_;
            playCount = repeatCount;
         }
         else
         {
            _loc12_ = param1 - _loc8_;
            _loc11_ = _loc12_ % _loc9_;
            _loc11_ = Math.min(_loc11_,_loc7_);
            playCount = 1 + _loc12_ / _loc9_;
         }
         if(activeEffectQueue && activeEffectQueue.length > 0)
         {
            _loc13_ = 0;
            _loc14_ = activeEffectQueue.length;
            _loc3_ = 0;
            while(_loc3_ < _loc14_)
            {
               _loc15_ = !!playReversed?int(_loc14_ - 1 - _loc3_):int(_loc3_);
               _loc17_ = _loc13_;
               _loc18_ = _loc13_ + childSets[_loc15_][0].actualDuration;
               _loc13_ = _loc18_;
               if(_loc17_ <= _loc11_ && _loc11_ <= _loc18_)
               {
                  endEffectCalled = true;
                  if(this.currentSetIndex == _loc15_)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < this.currentSet.length)
                     {
                        this.currentSet[_loc4_].playheadTime = _loc11_ - _loc17_;
                        _loc4_++;
                     }
                  }
                  else if(_loc15_ < this.currentSetIndex)
                  {
                     if(playReversed)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < this.currentSet.length)
                        {
                           this.currentSet[_loc4_].end();
                           _loc4_++;
                        }
                        _loc4_ = this.currentSetIndex - 1;
                        while(_loc4_ > _loc15_)
                        {
                           _loc16_ = activeEffectQueue[_loc4_];
                           _loc5_ = 0;
                           while(_loc5_ < _loc16_.length)
                           {
                              if(playReversed)
                              {
                                 _loc16_[_loc5_].playReversed = true;
                              }
                              _loc16_[_loc5_].play();
                              _loc16_[_loc5_].end();
                              _loc5_++;
                           }
                           _loc4_--;
                        }
                     }
                     else
                     {
                        _loc4_ = 0;
                        while(_loc4_ < this.currentSet.length)
                        {
                           this.currentSet[_loc4_].playheadTime = 0;
                           this.currentSet[_loc4_].stop();
                           _loc4_++;
                        }
                        _loc4_ = this.currentSetIndex - 1;
                        while(_loc4_ > _loc15_)
                        {
                           _loc16_ = activeEffectQueue[_loc4_];
                           _loc5_ = 0;
                           while(_loc5_ < _loc16_.length)
                           {
                              _loc16_[_loc5_].play();
                              _loc16_[_loc5_].stop();
                              _loc5_++;
                           }
                           _loc4_--;
                        }
                     }
                     this.currentSetIndex = _loc15_;
                     this.playCurrentChildSet();
                     _loc5_ = 0;
                     while(_loc5_ < this.currentSet.length)
                     {
                        this.currentSet[_loc5_].playheadTime = _loc11_ - _loc17_;
                        if(this.isPaused)
                        {
                           this.currentSet[_loc5_].pause();
                        }
                        _loc5_++;
                     }
                  }
                  else
                  {
                     if(playReversed)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < this.currentSet.length)
                        {
                           this.currentSet[_loc4_].playheadTime = 0;
                           this.currentSet[_loc4_].stop();
                           _loc4_++;
                        }
                        _loc5_ = this.currentSetIndex + 1;
                        while(_loc5_ < _loc15_)
                        {
                           _loc16_ = activeEffectQueue[_loc5_];
                           _loc6_ = 0;
                           while(_loc6_ < _loc16_.length)
                           {
                              _loc16_[_loc6_].playheadTime = 0;
                              _loc16_[_loc6_].stop();
                              _loc6_++;
                           }
                           _loc5_++;
                        }
                     }
                     else
                     {
                        _loc19_ = this.currentSet.concat();
                        _loc4_ = 0;
                        while(_loc4_ < _loc19_.length)
                        {
                           _loc19_[_loc4_].end();
                           _loc4_++;
                        }
                        _loc5_ = this.currentSetIndex + 1;
                        while(_loc5_ < _loc15_)
                        {
                           _loc16_ = activeEffectQueue[_loc5_];
                           _loc6_ = 0;
                           while(_loc6_ < _loc16_.length)
                           {
                              _loc16_[_loc6_].play();
                              _loc16_[_loc6_].end();
                              _loc6_++;
                           }
                           _loc5_++;
                        }
                     }
                     this.currentSetIndex = _loc15_;
                     this.playCurrentChildSet();
                     _loc5_ = 0;
                     while(_loc5_ < this.currentSet.length)
                     {
                        this.currentSet[_loc5_].playheadTime = _loc11_ - _loc17_;
                        if(this.isPaused)
                        {
                           this.currentSet[_loc5_].pause();
                        }
                        _loc5_++;
                     }
                  }
                  endEffectCalled = false;
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      override public function play() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         this.isPaused = false;
         activeEffectQueue = [];
         this.currentSetIndex = !!playReversed?int(childSets.length):-1;
         _loc1_ = childSets.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc5_ = childSets[_loc2_];
            activeEffectQueue.push(_loc5_);
            _loc2_++;
         }
         super.play();
         this.startTime = Tween.intervalTime;
         if(activeEffectQueue.length == 0)
         {
            finishRepeat();
            return;
         }
         this.playNextChildSet();
      }
      
      override public function pause() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.pause();
         this.isPaused = true;
         if(this.currentSet && this.currentSet.length > 0)
         {
            _loc1_ = this.currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.currentSet[_loc2_].pause();
               _loc2_++;
            }
         }
      }
      
      override public function stop() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:IEffectInstance = null;
         this.isPaused = false;
         if(activeEffectQueue && activeEffectQueue.length > 0)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_[this.currentSetIndex];
            if(_loc2_)
            {
               _loc5_ = _loc2_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc2_[_loc6_].stop();
                  _loc6_++;
               }
            }
            _loc3_ = _loc1_.length;
            _loc4_ = this.currentSetIndex + 1;
            while(_loc4_ < _loc3_)
            {
               _loc7_ = _loc1_[_loc4_];
               _loc8_ = _loc7_.length;
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc10_ = _loc7_[_loc9_];
                  _loc10_.effect.deleteInstance(_loc10_);
                  _loc9_++;
               }
               _loc4_++;
            }
         }
         super.stop();
      }
      
      override public function resume() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.resume();
         this.isPaused = false;
         if(this.currentSet && this.currentSet.length > 0)
         {
            _loc1_ = this.currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.currentSet[_loc2_].resume();
               _loc2_++;
            }
         }
      }
      
      override public function reverse() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.reverse();
         if(this.currentSet && this.currentSet.length > 0)
         {
            _loc1_ = this.currentSet.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this.currentSet[_loc2_].reverse();
               _loc2_++;
            }
         }
      }
      
      override public function end() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         endEffectCalled = true;
         if(activeEffectQueue && activeEffectQueue.length > 0)
         {
            _loc1_ = activeEffectQueue.concat();
            activeEffectQueue = null;
            _loc2_ = _loc1_[this.currentSetIndex];
            if(_loc2_)
            {
               _loc5_ = _loc2_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc2_[_loc6_].end();
                  _loc6_++;
               }
            }
            _loc3_ = _loc1_.length;
            _loc4_ = this.currentSetIndex + 1;
            while(_loc4_ < _loc3_)
            {
               _loc7_ = _loc1_[_loc4_];
               _loc8_ = _loc7_.length;
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  EffectInstance(_loc7_[_loc9_]).playWithNoDuration();
                  _loc9_++;
               }
               _loc4_++;
            }
         }
         this.isPaused = false;
         super.end();
      }
      
      override protected function onEffectEnd(param1:IEffectInstance) : void
      {
         if(Object(param1).suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.currentSet.length)
         {
            if(param1 == this.currentSet[_loc2_])
            {
               this.currentSet.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(endEffectCalled)
         {
            return;
         }
         if(this.currentSet.length == 0)
         {
            if(false == this.playNextChildSet())
            {
               finishRepeat();
            }
         }
      }
      
      private function playCurrentChildSet() : void
      {
         var _loc1_:EffectInstance = null;
         var _loc2_:Array = activeEffectQueue[this.currentSetIndex];
         this.currentSet = [];
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = _loc2_[_loc3_];
            this.currentSet.push(_loc1_);
            _loc1_.playReversed = playReversed;
            if(_loc1_.suspendBackgroundProcessing)
            {
               UIComponent.suspendBackgroundProcessing();
            }
            _loc1_.startEffect();
            _loc3_++;
         }
         this.currentInstanceDuration = this.currentInstanceDuration + _loc1_.actualDuration;
      }
      
      private function playNextChildSet(param1:Number = 0) : Boolean
      {
         if(!playReversed)
         {
            if(!activeEffectQueue || this.currentSetIndex++ >= activeEffectQueue.length - 1)
            {
               return false;
            }
         }
         else if(this.currentSetIndex-- <= 0)
         {
            return false;
         }
         this.playCurrentChildSet();
         return true;
      }
   }
}
