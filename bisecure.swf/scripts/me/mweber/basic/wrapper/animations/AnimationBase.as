package me.mweber.basic.wrapper.animations
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import me.mweber.basic.IDisposable;
   
   public class AnimationBase extends EventDispatcher implements IDisposable
   {
       
      
      protected var component:DisplayObject;
      
      protected var autoDispose:Boolean;
      
      public function AnimationBase(param1:DisplayObject, param2:Boolean = false)
      {
         super();
         this.component = param1;
         this.autoDispose = param2;
      }
      
      public function dispose() : void
      {
         this.component = null;
      }
      
      public function start() : void
      {
      }
      
      protected function finalize() : void
      {
         dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_END));
         if(this.autoDispose)
         {
            this.dispose();
         }
      }
   }
}
