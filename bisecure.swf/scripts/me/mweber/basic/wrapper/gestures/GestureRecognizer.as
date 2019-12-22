package me.mweber.basic.wrapper.gestures
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import me.mweber.basic.IDisposable;
   
   public class GestureRecognizer extends EventDispatcher implements IDisposable
   {
       
      
      protected var component:DisplayObject;
      
      public function GestureRecognizer(param1:DisplayObject)
      {
         super();
         this.component = param1;
         this.initialize();
      }
      
      public function dispose() : void
      {
         this.component = null;
      }
      
      protected function initialize() : void
      {
      }
   }
}
