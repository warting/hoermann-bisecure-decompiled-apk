package refactor.logicware._3_PAL.GatewayDiscover.local
{
   import flash.events.DatagramSocketDataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._4_HAL.network.Timings;
   import refactor.logicware._4_HAL.network.udp.Broadcast;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.LogicwareSettings;
   
   public class GatewayBroadcast extends EventDispatcher
   {
      
      private static var singleton:GatewayBroadcast;
       
      
      public function GatewayBroadcast(param1:ConstructorLock#172)
      {
         super();
      }
      
      public static function get UDPBroadcast() : GatewayBroadcast
      {
         if(singleton == null)
         {
            singleton = new GatewayBroadcast(null);
         }
         return singleton;
      }
      
      public function discover() : Boolean
      {
         var _loc1_:Broadcast = Broadcast.UDPBroadcast;
         if(_loc1_.active)
         {
            return false;
         }
         _loc1_.addEventListener(DatagramSocketDataEvent.DATA,this.onReceive);
         _loc1_.addEventListener(Event.COMPLETE,this.onComplete);
         _loc1_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes("<Discover target=\"LogicBox\" />");
         return _loc1_.send(_loc2_,LogicwareSettings.DISCOVER_REQUEST_PORT,LogicwareSettings.DISCOVER_LISTEN_PORT,Timings.UDP_SEARCH_TIMEOUT);
      }
      
      public function cancel() : void
      {
         Broadcast.UDPBroadcast.cancel();
      }
      
      private function onReceive(param1:DatagramSocketDataEvent) : void
      {
         var request:String = null;
         var xml:XML = null;
         var attribube:XML = null;
         var mac:String = null;
         var event:DatagramSocketDataEvent = param1;
         request = event.data.readUTFBytes(event.data.bytesAvailable);
         try
         {
            xml = new XML(request);
         }
         catch(e:Error)
         {
            Log.warning("[GatewayBroadcast] receaved invalid UDP message: " + request);
            return;
         }
         var target:String = xml.name();
         var args:Dictionary = new Dictionary();
         if(!target)
         {
            Log.warning("[GatewayBroadcast] receaved invalid UDP message: " + request);
            return;
         }
         for each(attribube in xml.attributes())
         {
            args["_" + attribube.name()] = attribube.toString();
         }
         mac = xml.@mac;
         while(mac.indexOf(":") >= 0)
         {
            mac = mac.replace(":","");
         }
         var protocol:String = xml.@protocol;
         var gateway:Gateway = new Gateway();
         gateway.name = null;
         gateway.mac = mac;
         gateway.protocolVersion = protocol;
         dispatchEvent(new GatewayBroadcastEvent(GatewayBroadcastEvent.GATEWAY_FOUND,gateway,event.srcAddress));
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:Broadcast = Broadcast.UDPBroadcast;
         _loc2_.removeEventListener(DatagramSocketDataEvent.DATA,this.onReceive);
         _loc2_.removeEventListener(Event.COMPLETE,this.onComplete);
         _loc2_.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         dispatchEvent(param1);
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         var _loc2_:Broadcast = Broadcast.UDPBroadcast;
         _loc2_.removeEventListener(DatagramSocketDataEvent.DATA,this.onReceive);
         _loc2_.removeEventListener(Event.COMPLETE,this.onComplete);
         _loc2_.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         dispatchEvent(param1);
      }
   }
}

class ConstructorLock#172
{
    
   
   function ConstructorLock#172()
   {
      super();
   }
}
