package refactor.logicware._4_HAL.network.udp
{
   import be.aboutme.nativeExtensions.udp.UDPSocket;
   import flash.events.DatagramSocketDataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   import me.mweber.basic.AutoDisposeTimer;
   import refactor.logicware._5_UTIL.Log;
   
   public class Broadcast extends EventDispatcher
   {
      
      private static var singleton:Broadcast = null;
       
      
      private var _active:Boolean;
      
      private var _socket:UDPSocket;
      
      public function Broadcast(param1:ConstructorLock#189)
      {
         super();
      }
      
      public static function get UDPBroadcast() : Broadcast
      {
         if(singleton == null)
         {
            singleton = new Broadcast(null);
         }
         return singleton;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function send(param1:ByteArray, param2:int, param3:int = -1, param4:Number = 10000) : Boolean
      {
         var data:ByteArray = param1;
         var sendPort:int = param2;
         var listenPort:int = param3;
         var timeout:Number = param4;
         if(this.active)
         {
            Log.warning("[Broadcast] Sending broadcast failed! (Broadcast already active)");
            return false;
         }
         if(listenPort < 0)
         {
            listenPort = sendPort;
         }
         this._active = true;
         this._socket = new UDPSocket();
         if(timeout != 0)
         {
            this.startReceive(listenPort);
         }
         try
         {
            this._socket.send(data,"255.255.255.255",sendPort);
         }
         catch(e:Error)
         {
            Log.error("[Broadcast] Sending UDP Broadcast failed:\n" + "[" + e.errorID + "] " + e.message + "\n" + e.getStackTrace());
            dispatchEvent(new IOErrorEvent(IOErrorEvent.NETWORK_ERROR,false,false,e.message,e.errorID));
            return false;
         }
         if(timeout == 0)
         {
            new AutoDisposeTimer(250,function(param1:Event):void
            {
               finalizeReceive();
            }).start();
         }
         else if(timeout >= 0)
         {
            new AutoDisposeTimer(timeout,function(param1:Event):void
            {
               finalizeReceive();
            }).start();
         }
         return true;
      }
      
      public function cancel() : void
      {
         if(this.active)
         {
            this.finalizeReceive();
         }
      }
      
      private function startReceive(param1:int) : Boolean
      {
         var listenPort:int = param1;
         this._socket.addEventListener(DatagramSocketDataEvent.DATA,this.onReceive);
         try
         {
            this._socket.bind(listenPort);
            Log.info("[Broadcast] bind on " + listenPort);
            this._socket.receive();
         }
         catch(e:Error)
         {
            Log.error("[Broadcast] UDP bind/receive failed:\n" + "[" + e.errorID + "] " + e.message + "\n" + e.getStackTrace());
            dispatchEvent(new IOErrorEvent(IOErrorEvent.NETWORK_ERROR,false,false,e.message,e.errorID));
            return false;
         }
         return true;
      }
      
      private function finalizeReceive() : void
      {
         this._socket.close();
         this._socket.removeEventListener(DatagramSocketDataEvent.DATA,this.onReceive);
         this._socket = null;
         this._active = false;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onReceive(param1:DatagramSocketDataEvent) : void
      {
         dispatchEvent(param1);
      }
   }
}

class ConstructorLock#189
{
    
   
   function ConstructorLock#189()
   {
      super();
   }
}
