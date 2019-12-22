package me.mweber.basic.wrapper.gestures.longPress
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import me.mweber.basic.wrapper.gestures.GestureRecognizer;
   
   public class LongPressRecognizer extends GestureRecognizer
   {
       
      
      private var longPressed:Boolean;
      
      private var longPressTimer:Timer;
      
      private var pressTime:Number;
      
      public function LongPressRecognizer(param1:DisplayObject, param2:Number = 1000)
      {
         super(param1);
         this.pressTime = param2;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         component.addEventListener(MouseEvent.MOUSE_UP,this.mouse_upHandler);
         component.addEventListener(MouseEvent.MOUSE_OUT,this.mouse_outHandler);
         component.addEventListener(MouseEvent.MOUSE_DOWN,this.mouse_downHandler);
      }
      
      override public function dispose() : void
      {
         component.removeEventListener(MouseEvent.CLICK,this.mouse_upHandler);
         component.removeEventListener(MouseEvent.MOUSE_OUT,this.mouse_outHandler);
         component.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouse_downHandler);
         if(this.longPressTimer != null)
         {
            this.longPressTimer.reset();
            this.longPressTimer = null;
         }
         super.dispose();
      }
      
      private function mouse_upHandler(param1:MouseEvent) : void
      {
         if(this.longPressTimer != null)
         {
            this.longPressTimer.reset();
         }
         if(this.longPressed)
         {
            dispatchEvent(new LongPressEvent(param1,LongPressEvent.LONG_PRESS_FINISHED));
         }
         else
         {
            dispatchEvent(new LongPressEvent(param1,LongPressEvent.LONG_PRESS_CANCELED));
         }
      }
      
      private function mouse_outHandler(param1:MouseEvent) : void
      {
         if(this.longPressTimer != null)
         {
            this.longPressTimer.reset();
         }
         if(param1.buttonDown)
         {
            dispatchEvent(new LongPressEvent(param1,LongPressEvent.LONG_PRESS_CANCELED));
         }
      }
      
      private function mouse_downHandler(param1:MouseEvent) : void
      {
         this.longPressed = false;
         if(this.longPressTimer != null)
         {
            this.longPressTimer.reset();
            this.longPressTimer.delay = this.pressTime;
         }
         else
         {
            this.longPressTimer = new Timer(this.pressTime,1);
            this.longPressTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.longPressHandler);
         }
         this.longPressTimer.start();
      }
      
      private function longPressHandler(param1:TimerEvent) : void
      {
         dispatchEvent(new LongPressEvent(null,LongPressEvent.LONG_PRESS_RECOGNIZED));
         this.longPressed = true;
      }
   }
}
