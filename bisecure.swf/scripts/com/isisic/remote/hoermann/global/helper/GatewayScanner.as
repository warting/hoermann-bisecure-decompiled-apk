package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.net.portal.PortalCommunicator;
   import com.isisic.remote.hoermann.net.portal.PortalGatewayEvent;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.mcp.events.GatewayFoundEvent;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import com.isisic.remote.lw.net.HTTPClient;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GatewayScanner extends EventDispatcher
   {
      
      public static const TIMEOUT_DELAY:int = 11000;
      
      static const STATE_SCAN_LOCAL:String = "SCAN_LOCAL";
      
      static const STATE_SCAN_PORTAL:String = "SCAN_PORTAL";
      
      static const STATE_END_TEST:String = "END_TEST";
       
      
      public var gateways:Array;
      
      var stateStack:Array;
      
      var timeoutTimer:Timer;
      
      var processing:int;
      
      var bcActive:Boolean;
      
      private var load:Function = null;
      
      private var fail:Function = null;
      
      public function GatewayScanner()
      {
         super();
      }
      
      public function scan(param1:Array, param2:Boolean = true, param3:Boolean = true) : void
      {
         var bcFound:Function = null;
         var bcFinished:Function = null;
         var self:GatewayScanner = null;
         var gw:Object = null;
         var gateways:Array = param1;
         var scanLocal:Boolean = param2;
         var scanPortal:Boolean = param3;
         this.gateways = gateways;
         self = this;
         Logicware.API.addEventListener(GatewayFoundEvent.FOUND,bcFound = function(param1:GatewayFoundEvent):void
         {
            var _loc2_:* = new Object();
            _loc2_.host = param1.context.host;
            _loc2_.port = 4000;
            _loc2_.mac = param1.context.mac.toUpperCase();
            _loc2_.name = "";
            _loc2_.available = true;
            _loc2_.isDDns = false;
            _loc2_.isPortal = false;
            self.addContext(param1.context,_loc2_,true);
         });
         Logicware.API.addEventListener(GatewayFoundEvent.SCAN_FINISHED,bcFinished = function(param1:Event):void
         {
            Logicware.API.removeEventListener(GatewayFoundEvent.SCAN_FINISHED,bcFinished);
            Logicware.API.removeEventListener(GatewayFoundEvent.FOUND,bcFound);
            self.bcActive = false;
            if(self.stateStack.length > 0)
            {
               if(self.stateStack[0] == STATE_END_TEST)
               {
                  self.runActualState();
               }
            }
         });
         this.bcActive = true;
         Logicware.API.findGateways();
         for each(gw in gateways)
         {
            gw.available = false;
         }
         this.stateStack = new Array();
         if(scanPortal)
         {
            this.stateStack.push(STATE_SCAN_PORTAL);
         }
         if(scanLocal)
         {
            this.stateStack.push(STATE_SCAN_LOCAL);
         }
         this.stateStack.push(STATE_END_TEST);
         this.runActualState();
      }
      
      protected function runActualState() : void
      {
         if(this.stateStack.length <= 0)
         {
            Debug.info("[GatewayScanner] StateStack complete!");
            this.finishScan();
            return;
         }
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
         var _loc1_:String = this.stateStack[0];
         Debug.info("[GatewayScanner] \t\tRunning State: " + _loc1_);
         switch(_loc1_)
         {
            case STATE_SCAN_LOCAL:
               this.scanLocal();
               break;
            case STATE_SCAN_PORTAL:
               this.scanPortal();
               break;
            case STATE_END_TEST:
               this.endTest();
         }
      }
      
      protected function scanLocal() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ConnectionContext = null;
         this.processing = 0;
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         for each(_loc1_ in this.gateways)
         {
            if(!_loc1_.isPortal)
            {
               if(_loc1_.isDDns)
               {
                  _loc2_ = Logicware.API.createContext(_loc1_.host,_loc1_.port,Logicware.API.clientId,_loc1_.mac,ConnectionTypes.LOCAL,_loc1_.mac);
                  this.addContext(_loc2_,_loc1_,false);
                  this.processing++;
               }
            }
         }
         if(this.processing <= 0)
         {
            this.timeoutTimer.reset();
            this.processing = 0;
            this.stateStack.shift();
            this.runActualState();
         }
      }
      
      protected function scanPortal() : void
      {
         var self:GatewayScanner = null;
         if(HoermannRemote.appData.portalData == null)
         {
            this.stateStack.shift();
            this.runActualState();
            return;
         }
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         self = this;
         PortalCommunicator.defaultCommunicator.addEventListener(PortalGatewayEvent.LOADED,this.load = function(param1:PortalGatewayEvent):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            param1.currentTarget.removeEventListener(PortalGatewayEvent.LOADED,load);
            param1.currentTarget.removeEventListener(PortalGatewayEvent.LOADING_FAILED,fail);
            self.processing = param1.gateways.length;
            for each(_loc2_ in param1.gateways)
            {
               Logicware.API.clientId = HoermannRemote.appData.portalData.deviceId;
               _loc3_ = Logicware.API.createContext(Features.portalHostCommunication,443,Logicware.API.clientId,_loc2_.mac,ConnectionTypes.PORTAL,_loc2_.mac);
               _loc3_.httpAutentication = HTTPClient.createBasicAuth(HoermannRemote.appData.portalData.deviceId,HoermannRemote.appData.portalData.password);
               addContext(_loc3_,_loc2_);
            }
         });
         PortalCommunicator.defaultCommunicator.addEventListener(PortalGatewayEvent.LOADING_FAILED,this.fail = function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(PortalGatewayEvent.LOADED,load);
            param1.currentTarget.removeEventListener(PortalGatewayEvent.LOADING_FAILED,fail);
            self.processing--;
            if(this.processing <= 0)
            {
               self.stateStack.shift();
               self.runActualState();
            }
         });
         PortalCommunicator.defaultCommunicator.requestGateways();
      }
      
      protected function endTest() : void
      {
         if(this.bcActive)
         {
            return;
         }
         this.stateStack.shift();
         this.runActualState();
      }
      
      protected function addContext(param1:ConnectionContext, param2:Object, param3:Boolean = false) : void
      {
         var self:GatewayScanner = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var context:ConnectionContext = param1;
         var gateway:Object = param2;
         var bcAdd:Boolean = param3;
         Logicware.API.connect(context);
         self = this;
         loader = Logicware.initMCPLoader(context,loaderComplete = function(param1:Event):void
         {
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            loader.data.payload.position = 0;
            var _loc2_:* = loader.data.payload.readUTFBytes(loader.data.payload.bytesAvailable);
            var _loc3_:* = false;
            for each(_loc4_ in self.gateways)
            {
               if(_loc4_.mac == context.mac)
               {
                  _loc3_ = true;
                  self.updateGatewayContext(_loc4_,context,_loc2_);
               }
            }
            if(!_loc3_)
            {
               _loc5_ = new Object();
               _loc5_.available = true;
               _loc5_.mac = context.mac;
               _loc5_.name = _loc2_;
               _loc5_.host = context.host;
               _loc5_.port = context.port;
               if(context.connectionType == ConnectionTypes.LOCAL)
               {
                  _loc5_.localIp = context.host;
                  _loc5_.localPort = context.port;
               }
               _loc5_.isPortal = context.connectionType == ConnectionTypes.PORTAL;
               self.gateways.push(_loc5_);
            }
            if(!bcAdd)
            {
               self.processing--;
            }
            if(self.processing <= 0 && !bcAdd)
            {
               self.stateStack.shift();
               self.runActualState();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
            Logicware.API.disconnect(context);
            context.dispose();
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[GatewayScanner] Name Request failed!\n" + param1);
            self.processing--;
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
            Logicware.API.disconnect(context);
            context.dispose();
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_NAME));
      }
      
      protected function updateGatewayContext(param1:Object, param2:ConnectionContext, param3:String) : void
      {
         if(param1.available == true && param1.isPortal == false)
         {
            return;
         }
         param1.name = param3;
         param1.available = true;
         param1.isPortal = param2.connectionType == ConnectionTypes.PORTAL;
         if(!param1.isDDns)
         {
            param1.host = param2.host;
            param1.port = param2.port;
         }
      }
      
      protected function finishScan() : void
      {
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         }
         this.timeoutTimer = null;
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      protected function onTimeout(param1:TimerEvent) : void
      {
         if(this.load != null)
         {
            PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADED,this.load);
         }
         if(this.fail != null)
         {
            PortalCommunicator.defaultCommunicator.removeEventListener(PortalGatewayEvent.LOADING_FAILED,this.fail);
         }
         this.stateStack.shift();
         this.runActualState();
      }
   }
}
