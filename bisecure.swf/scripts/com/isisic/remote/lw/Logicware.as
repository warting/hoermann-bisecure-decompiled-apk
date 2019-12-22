package com.isisic.remote.lw
{
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.mcp.MCPProcessor;
   import com.isisic.remote.lw.mcp.events.GatewayFoundEvent;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import com.isisic.remote.lw.net.udp.UDPUnit;
   import com.isisic.remote.lw.net.udp.UDPUnitEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   
   public class Logicware extends EventDispatcher
   {
      
      public static const TCP_PORT:int = 4000;
      
      private static var singleton:Logicware;
       
      
      public var clientId:String = "000000000000";
      
      public function Logicware()
      {
         super();
      }
      
      public static function get API() : Logicware
      {
         if(!singleton)
         {
            singleton = new Logicware();
         }
         return singleton;
      }
      
      public static function initMCPLoader(param1:ConnectionContext, param2:Function, param3:Function) : MCPLoader
      {
         var _loc4_:MCPLoader = new MCPLoader(param1);
         _loc4_.addEventListener(Event.COMPLETE,param2);
         _loc4_.addEventListener(ErrorEvent.ERROR,param3);
         return _loc4_;
      }
      
      public static function finalizeMCPLoader(param1:MCPLoader, param2:Function, param3:Function) : void
      {
         param1.removeEventListener(Event.COMPLETE,param2);
         param1.removeEventListener(ErrorEvent.ERROR,param3);
         param1.dispose();
      }
      
      public function findGateways() : void
      {
         var _loc1_:Timer = null;
         UDPUnit.defaultUnit.addEventListener(UDPUnitEvent.DISCOVERED,this.onBoxFound);
         UDPUnit.defaultUnit.discover();
         if(Capabilities.os.substr(0,3) == "Win")
         {
            _loc1_ = new Timer(Timings.UDP_DESKTOP_SEARCH_TIMEOUT,1);
         }
         else
         {
            _loc1_ = new Timer(Timings.UDP_SEARCH_TIMEOUT,1);
         }
         _loc1_.addEventListener(TimerEvent.TIMER,this.onScanFinished);
         _loc1_.start();
      }
      
      public function createContext(param1:String, param2:int, param3:String, param4:String, param5:String, param6:String) : ConnectionContext
      {
         var _loc7_:ConnectionContext = new MCPProcessor(param1,param2,param3,param4,param5,param6).context;
         return _loc7_;
      }
      
      public function connect(param1:ConnectionContext) : void
      {
         param1.processor.connect();
      }
      
      public function disconnect(param1:ConnectionContext) : void
      {
         param1.processor.disconnect();
      }
      
      private function onBoxFound(param1:UDPUnitEvent) : void
      {
         var _loc2_:ConnectionContext = this.createContext(param1.host,TCP_PORT,this.clientId,param1.mac,ConnectionTypes.LOCAL,param1.mac);
         this.dispatchEvent(new GatewayFoundEvent(_loc2_,GatewayFoundEvent.FOUND));
      }
      
      private function onScanFinished(param1:TimerEvent) : void
      {
         (param1.target as Timer).removeEventListener(TimerEvent.TIMER,this.onScanFinished);
         UDPUnit.defaultUnit.removeEventListener(UDPUnitEvent.DISCOVERED,this.onBoxFound);
         UDPUnit.defaultUnit.dispose();
         dispatchEvent(new GatewayFoundEvent(null,GatewayFoundEvent.SCAN_FINISHED));
      }
   }
}
