package me.mweber.basic.wrapper.gestures.longPress
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LongPressEvent extends Event
   {
      
      public static const LONG_PRESS_CANCELED:String = "longPressCanceled";
      
      public static const LONG_PRESS_RECOGNIZED:String = "longPressRecognized";
      
      public static const LONG_PRESS_FINISHED:String = "longPressFinished";
       
      
      private var _mouseEvent:MouseEvent;
      
      public function LongPressEvent(param1:MouseEvent, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param2,param3,param4);
         this._mouseEvent = param1;
      }
      
      public function get mouseEvent() : MouseEvent
      {
         return this._mouseEvent;
      }
   }
}
