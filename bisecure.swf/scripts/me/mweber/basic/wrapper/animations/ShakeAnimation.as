package me.mweber.basic.wrapper.animations
{
   import flash.display.DisplayObject;
   import mx.events.EffectEvent;
   import spark.effects.Move;
   
   public class ShakeAnimation extends AnimationBase
   {
       
      
      public function ShakeAnimation(param1:DisplayObject, param2:Boolean = false)
      {
         super(param1,param2);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      override public function start() : void
      {
         var _loc3_:Move = null;
         var _loc4_:Move = null;
         super.start();
         var _loc1_:Number = 250;
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = new Move();
            _loc3_.xFrom = 0;
            _loc3_.xTo = 50;
            _loc3_.duration = _loc1_ / 2;
            _loc3_.startDelay = _loc2_ * (_loc1_ * 2);
            _loc3_.play([component],true);
            _loc4_ = new Move();
            _loc4_.xFrom = 0;
            _loc4_.xTo = -50;
            _loc4_.duration = _loc1_ / 2;
            _loc4_.startDelay = _loc2_ * (_loc1_ * 2);
            _loc4_.play([component],true);
            _loc4_.addEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
            _loc2_++;
         }
      }
      
      private function effectEndHandler(param1:EffectEvent) : void
      {
         (param1.currentTarget as Move).removeEventListener(EffectEvent.EFFECT_END,this.effectEndHandler);
         this.finalize();
      }
   }
}
