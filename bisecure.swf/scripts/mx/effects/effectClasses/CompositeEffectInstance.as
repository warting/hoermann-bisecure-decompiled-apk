package mx.effects.effectClasses
{
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import mx.core.mx_internal;
   import mx.effects.EffectInstance;
   import mx.effects.IEffectInstance;
   import mx.effects.Tween;
   import mx.events.EffectEvent;
   
   use namespace mx_internal;
   
   public class CompositeEffectInstance extends EffectInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var resizeEffectType:Class;
      
      private static var resizeEffectLoaded:Boolean = false;
       
      
      mx_internal var activeEffectQueue:Array;
      
      private var _playheadTime:Number = 0;
      
      mx_internal var childSets:Array;
      
      mx_internal var endEffectCalled:Boolean;
      
      mx_internal var timerTween:Tween;
      
      public function CompositeEffectInstance(param1:Object)
      {
         this.activeEffectQueue = [];
         this.childSets = [];
         super(param1);
      }
      
      override mx_internal function get actualDuration() : Number
      {
         var _loc1_:Number = NaN;
         if(repeatCount > 0)
         {
            _loc1_ = this.durationWithoutRepeat * repeatCount + repeatDelay * (repeatCount - 1) + startDelay;
         }
         return _loc1_;
      }
      
      override public function get playheadTime() : Number
      {
         return this._playheadTime;
      }
      
      override public function set playheadTime(param1:Number) : void
      {
         if(this.timerTween)
         {
            this.timerTween.seek(param1);
         }
         else
         {
            this._playheadTime = param1;
         }
         super.playheadTime = param1;
      }
      
      mx_internal function get durationWithoutRepeat() : Number
      {
         return 0;
      }
      
      override public function play() : void
      {
         this.timerTween = new Tween(this,0,0,this.durationWithoutRepeat);
         super.play();
      }
      
      override public function pause() : void
      {
         super.pause();
         if(this.timerTween)
         {
            this.timerTween.pause();
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         if(this.timerTween)
         {
            this.timerTween.stop();
         }
      }
      
      override public function end() : void
      {
         super.end();
         if(this.timerTween)
         {
            this.timerTween.endTween();
         }
      }
      
      override public function resume() : void
      {
         super.resume();
         if(this.timerTween)
         {
            this.timerTween.resume();
         }
      }
      
      override public function reverse() : void
      {
         super.reverse();
         super.playReversed = !playReversed;
         if(this.timerTween)
         {
            this.timerTween.reverse();
         }
      }
      
      override public function finishEffect() : void
      {
         this.activeEffectQueue = null;
         super.finishEffect();
      }
      
      public function addChildSet(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1.length;
            if(_loc2_ > 0)
            {
               if(!this.childSets)
               {
                  this.childSets = [param1];
               }
               else
               {
                  this.childSets.push(param1);
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  param1[_loc3_].addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
                  param1[_loc3_].parentCompositeEffectInstance = this;
                  _loc3_++;
               }
            }
         }
      }
      
      mx_internal function hasRotateInstance() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:CompositeEffectInstance = null;
         if(this.childSets)
         {
            _loc1_ = 0;
            while(_loc1_ < this.childSets.length)
            {
               if(this.childSets[_loc1_].length > 0)
               {
                  _loc2_ = this.childSets[_loc1_][0] as CompositeEffectInstance;
                  if(this.childSets[_loc1_][0] is RotateInstance || _loc2_ && _loc2_.hasRotateInstance())
                  {
                     return true;
                  }
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      mx_internal function hasResizeInstance() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:CompositeEffectInstance = null;
         if(this.childSets)
         {
            if(!resizeEffectLoaded)
            {
               resizeEffectLoaded = true;
               if(ApplicationDomain.currentDomain.hasDefinition("spark.effects.supportClasses.ResizeInstance"))
               {
                  resizeEffectType = Class(ApplicationDomain.currentDomain.getDefinition("spark.effects.supportClasses.ResizeInstance"));
               }
            }
            if(resizeEffectType)
            {
               _loc1_ = 0;
               while(_loc1_ < this.childSets.length)
               {
                  if(this.childSets[_loc1_].length > 0)
                  {
                     _loc2_ = this.childSets[_loc1_][0] as CompositeEffectInstance;
                     if(this.childSets[_loc1_][0] is resizeEffectType || _loc2_ && _loc2_.hasResizeInstance())
                     {
                        return true;
                     }
                  }
                  _loc1_++;
               }
            }
         }
         return false;
      }
      
      override mx_internal function playWithNoDuration() : void
      {
         super.playWithNoDuration();
         this.end();
      }
      
      protected function onEffectEnd(param1:IEffectInstance) : void
      {
      }
      
      public function onTweenUpdate(param1:Object) : void
      {
         this._playheadTime = !!this.timerTween?Number(this.timerTween.playheadTime):Number(this._playheadTime);
      }
      
      public function onTweenEnd(param1:Object) : void
      {
         this._playheadTime = !!this.timerTween?Number(this.timerTween.playheadTime):Number(this._playheadTime);
      }
      
      override public function initEffect(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super.initEffect(param1);
         var _loc2_:int = this.childSets.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.childSets[_loc3_];
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_[_loc6_].initEffect(param1);
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      mx_internal function effectEndHandler(param1:EffectEvent) : void
      {
         this.onEffectEnd(param1.effectInstance);
      }
   }
}
