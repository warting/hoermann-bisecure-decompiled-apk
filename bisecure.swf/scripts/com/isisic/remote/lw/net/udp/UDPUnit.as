package com.isisic.remote.lw.net.udp
{
   import be.aboutme.nativeExtensions.udp.UDPSocket;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import flash.desktop.NativeApplication;
   import flash.events.DatagramSocketDataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import me.mweber.basic.helper.ArrayHelper;
   
   public class UDPUnit extends EventDispatcher implements IDisposable
   {
      
      public static const REQUEST_PORT:uint = 4001;
      
      public static const LISTEN_PORT:uint = 4002;
      
      public static const VALID_PROTOCOLS:Array = ["MCP V3.0","MCPPackage V3.2"];
      
      private static var _singleton:UDPUnit;
       
      
      private var _socket:UDPSocket;
      
      public function UDPUnit(param1:SingletonEnforcer#125)
      {
         super();
         if(!param1)
         {
            throw new Error("Singleton Enforcer must be specified!");
         }
         this.initSocket();
         NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,this.deactivateHandler);
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,this.activateHandler);
      }
      
      public static function get defaultUnit() : UDPUnit
      {
         if(!_singleton)
         {
            _singleton = new UDPUnit(new SingletonEnforcer#125());
         }
         return _singleton;
      }
      
      public function dispose() : void
      {
         Debug.info("[UDPUnit] dispose ");
      }
      
      private function disposeSockets() : void
      {
         if(this._socket != null)
         {
            this._socket.close();
         }
         this._socket = null;
      }
      
      private function deactivateHandler(param1:Event) : void
      {
         this.disposeSockets();
         this._socket = new UDPDummySocket();
      }
      
      private function activateHandler(param1:Event) : void
      {
         this.initSocket();
      }
      
      private function initSocket() : void
      {
         this._socket = new UDPSocket();
         this._socket.addEventListener(DatagramSocketDataEvent.DATA,this.onData);
         try
         {
            this._socket.bind(LISTEN_PORT);
            Debug.info("[UDPUnit] bind on " + LISTEN_PORT);
            this._socket.receive();
            return;
         }
         catch(e:Error)
         {
            Debug.error("[UDPUnit] UDP bind/receive failed:\n" + e);
            return;
         }
      }
      
      public function discover(param1:String = "LogicBox") : void
      {
         var discoverTarget:String = param1;
         var xml:XML = new XML(<Discover/>);
         xml.@target = discoverTarget;
         var ba:ByteArray = new ByteArray();
         ba.writeUTFBytes(xml.toXMLString());
         if(Capabilities.os.indexOf("Win") > -1 || Capabilities.os.indexOf("Mac") > -1)
         {
            return;
         }
         try
         {
            this._socket.send(ba,"255.255.255.255",REQUEST_PORT);
            return;
         }
         catch(e:Error)
         {
            Debug.error("[UDPUnit] Sending UDP broadcast failed:\n" + e);
            disposeSockets();
            initSocket();
            return;
         }
      }
      
      private function onData(param1:DatagramSocketDataEvent) : void
      {
         var request:String = null;
         var xml:XML = null;
         var attribube:XML = null;
         var event:DatagramSocketDataEvent = param1;
         request = event.data.readUTFBytes(event.data.bytesAvailable);
         try
         {
            xml = new XML(request);
         }
         catch(e:Error)
         {
            Debug.warning("[UDPUnit] receaved invalid UDP message: " + request);
            return;
         }
         var target:String = xml.name();
         var args:Dictionary = new Dictionary();
         if(!target)
         {
            Debug.warning("[UDPUnit] receaved invalid UDP message: " + request);
            return;
         }
         for each(attribube in xml.attributes())
         {
            args["_" + attribube.name()] = attribube.toString();
         }
         this.runMessage(target,args,event.srcAddress);
      }
      
      private function runMessage(param1:String, param2:Dictionary, param3:String) : void
      {
         switch(param1.toUpperCase())
         {
            case DiscoverTargets.LOGIC_BOX.toLocaleUpperCase():
            case DiscoverTargets.Simulator.toLocaleUpperCase():
               this.onLogicBox(param2,param3);
         }
      }
      
      private function onLogicBox(param1:Dictionary, param2:String) : void
      {
         var _loc4_:* = null;
         var _loc3_:String = "";
         for(_loc4_ in param1)
         {
            _loc3_ = _loc3_ + (_loc4_.substr(1) + "=\'" + param1[_loc4_] + "\', ");
         }
         _loc3_ = _loc3_.substring(0,_loc3_.length - 2);
         if(!ArrayHelper.in_array(param1._protocol,VALID_PROTOCOLS))
         {
            Debug.warning("[UDPUnit] found LogicBox with invalid protocol: \'" + param2 + " (" + _loc3_ + ")");
            return;
         }
         Debug.info("[UDPUnit] LogicBox discovered: [" + param2 + ": " + _loc3_ + "]");
         var _loc5_:String = param1._mac;
         while(_loc5_.indexOf(":") >= 0)
         {
            _loc5_ = _loc5_.replace(":","");
         }
         dispatchEvent(new UDPUnitEvent(param2,_loc5_,param1._swVersion,param1._hwVersion,UDPUnitEvent.DISCOVERED));
      }
   }
}

class SingletonEnforcer#125
{
    
   
   function SingletonEnforcer#125()
   {
      super();
   }
}
