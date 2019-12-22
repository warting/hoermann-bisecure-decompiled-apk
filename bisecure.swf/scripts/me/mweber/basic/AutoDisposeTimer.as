package me.mweber.basic
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AutoDisposeTimer extends Timer
   {
       
      
      private var callback:Function;
      
      public function AutoDisposeTimer(param1:Number, param2:Function)
      {
         super(param1,1);
         this.callback = param2;
         this.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this.callback != null)
         {
            this.callback.call(null,param1);
         }
         this.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimer);
         this.callback = null;
         this.reset();
      }
   }
}
