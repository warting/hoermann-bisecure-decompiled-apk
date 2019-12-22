package com.isisic.remote.lw.net.tcp.extensions
{
   import com.isisic.remote.lw.net.tcp.Client;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import me.mweber.basic.Debug;
   
   public class ConnectionTimeoutExtension implements IClientExtension
   {
       
      
      protected var client:Client;
      
      protected var connectionTimeout:int;
      
      protected var connectionTimer:Timer;
      
      public function ConnectionTimeoutExtension(param1:int = 1500)
      {
         super();
         this.connectionTimeout = param1;
      }
      
      public function initialize(param1:Client) : void
      {
         this.client = param1;
         this.setupConnectionTimer();
      }
      
      public function onAction(param1:String, param2:Boolean, param3:Array = null) : Boolean
      {
         switch(param1)
         {
            case ExtensionActionNames.AFTER_CONNECTING:
               this.connectionTimer.start();
               break;
            case ExtensionActionNames.AFTER_CONNECT:
            case ExtensionActionNames.AFTER_CONNECT_FAIL:
               this.connectionTimer.reset();
         }
         return true;
      }
      
      public function dispose() : void
      {
         this.client = null;
         this.connectionTimer.removeEventListener(TimerEvent.TIMER,this.onConnectionTimeout);
         this.connectionTimer.reset();
         this.connectionTimer = null;
      }
      
      protected function setupConnectionTimer() : void
      {
         this.connectionTimer = new Timer(this.connectionTimeout,1);
         this.connectionTimer.addEventListener(TimerEvent.TIMER,this.onConnectionTimeout);
      }
      
      protected function onConnectionTimeout(param1:TimerEvent) : void
      {
         Debug.debug("[ConnectionTimeoutExtension] Connection timeout occurred!");
         this.connectionTimer.reset();
         this.client.close();
      }
   }
}
