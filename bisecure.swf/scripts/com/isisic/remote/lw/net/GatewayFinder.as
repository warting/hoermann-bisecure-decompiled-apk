package com.isisic.remote.lw.net
{
   import com.isisic.remote.lw.Timings;
   import com.isisic.remote.lw.net.udp.UDPUnit;
   import com.isisic.remote.lw.net.udp.UDPUnitEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GatewayFinder extends EventDispatcher
   {
      
      private static var singleton:GatewayFinder;
       
      
      private var resendTimer:Timer;
      
      public function GatewayFinder(param1:SingletonEnforcer#162)
      {
         super();
      }
      
      public static function get finder() : GatewayFinder
      {
         if(singleton == null)
         {
            singleton = new GatewayFinder(null);
         }
         return singleton;
      }
      
      public function start() : void
      {
         UDPUnit.defaultUnit.addEventListener(UDPUnitEvent.DISCOVERED,this.onGatewayFound);
         this.setupResendTimer();
         this.resendTimer.start();
         this.sendDiscover();
      }
      
      public function stop() : void
      {
         UDPUnit.defaultUnit.removeEventListener(UDPUnitEvent.DISCOVERED,this.onGatewayFound);
         this.disposeResendTimer();
      }
      
      protected function setupResendTimer() : void
      {
         if(this.resendTimer != null)
         {
            this.disposeResendTimer();
         }
         this.resendTimer = new Timer(Timings.UDP_SEARCH_TIMEOUT);
         this.resendTimer.addEventListener(TimerEvent.TIMER,this.onResendTimer);
      }
      
      protected function disposeResendTimer() : void
      {
         if(this.resendTimer != null)
         {
            this.resendTimer.reset();
            this.resendTimer.removeEventListener(TimerEvent.TIMER,this.onResendTimer);
            this.resendTimer = null;
         }
      }
      
      private function sendDiscover() : void
      {
         UDPUnit.defaultUnit.discover();
      }
      
      private function onResendTimer(param1:TimerEvent) : void
      {
         this.sendDiscover();
      }
      
      private function onGatewayFound(param1:UDPUnitEvent) : void
      {
         dispatchEvent(new UDPUnitEvent(param1.host,param1.mac,param1.softwareVersion,param1.hardwareVersion,param1.type));
      }
   }
}

class SingletonEnforcer#162
{
    
   
   function SingletonEnforcer#162()
   {
      super();
   }
}
