package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   
   public class PortCleaner extends EventDispatcher
   {
       
      
      private var context:ConnectionContext;
      
      private var timeoutTimer:Timer;
      
      private var portList:Array;
      
      private var groupedPorts:Array;
      
      private var _processingGroups:Array;
      
      private var _removingPorts:Array;
      
      public function PortCleaner(param1:ConnectionContext, param2:int = 5000)
      {
         super();
         this.context = param1;
         this.timeoutTimer = new Timer(param2,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
      }
      
      public function destruct() : void
      {
         this.reset();
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.reset();
         this.timeoutTimer = null;
      }
      
      public function searchDeadPorts() : void
      {
         this.portList = new Array();
         this.groupedPorts = new Array();
         this.readPortIds(function():void
         {
            if(portList.length < 1)
            {
               dispatchEvent(new Event(Event.COMPLETE));
               timeoutTimer.reset();
               reset();
               return;
            }
            readGroups(function():void
            {
               timeoutTimer.reset();
               deleteDeadPorts();
            });
         });
         this.timeoutTimer.start();
      }
      
      private function readPortIds(param1:Function) : void
      {
         var loaderComplate:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var callback:Function = param1;
         loader = Logicware.initMCPLoader(this.context,loaderComplate = function(param1:Event):void
         {
            if(loader.data.command == Commands.ERROR)
            {
               Debug.warning("[PortCleaner] loading portIds failed! mcp:\n" + loader.data);
            }
            else if(loader.data.command == Commands.GET_PORTS)
            {
               if(!loader.data.payload || loader.data.payload.length < 1)
               {
                  HoermannRemote.gatewayData.portCount = 0;
                  callback.call();
                  Logicware.finalizeMCPLoader(loader,loaderComplate,loaderFailed);
                  return;
               }
               loader.data.payload.position = 0;
               while(loader.data.payload.bytesAvailable)
               {
                  portList.push(loader.data.payload.readUnsignedByte());
               }
               HoermannRemote.gatewayData.portCount = portList.length;
               callback.call();
            }
            else
            {
               Debug.warning("[PortCleaner] received unexpected mcp package! mcp:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplate,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[PortCleaner] requesting ports failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplate,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_PORTS));
      }
      
      private function readGroups(param1:Function) : void
      {
         var groupsLoaded:Function = null;
         var callback:Function = param1;
         var dbg:* = HoermannRemote;
         if(HoermannRemote.gatewayData.groups == null)
         {
            HoermannRemote.gatewayData.addEventListener(GatewayData.GROUPS_CHANGED,groupsLoaded = function(param1:Event):void
            {
               HoermannRemote.gatewayData.removeEventListener(GatewayData.GROUPS_CHANGED,groupsLoaded);
               callback.call();
            });
         }
         else
         {
            callback.call();
         }
      }
      
      private function deleteDeadPorts() : void
      {
         var group:Object = null;
         var pId:int = 0;
         var loaders:Array = null;
         var toRemove:int = 0;
         var port:Object = null;
         var lData:Object = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var groupedList:ArrayList = new ArrayList();
         this._removingPorts = new Array();
         for each(group in HoermannRemote.gatewayData.groups)
         {
            if(group.ports)
            {
               for each(port in group.ports)
               {
                  groupedList.addItem(port.id);
               }
            }
         }
         for each(pId in this.portList)
         {
            if(groupedList.getItemIndex(pId) < 0)
            {
               this._removingPorts.push(pId);
            }
         }
         if(this._removingPorts.length <= 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         loaders = new Array();
         for each(toRemove in this._removingPorts)
         {
            lData = {
               "loader":null,
               "complete":null,
               "failed":null
            };
            lData.loader = Logicware.initMCPLoader(this.context,lData.complete = function(param1:Event):void
            {
               var _loc2_:* = undefined;
               _removingPorts.shift();
               if(!loaders[0].loader.data.payload || loaders[0].loader.data.payload.length < 1)
               {
                  Debug.warning("[PortCleaner] unexpected MCP while removing ports:\n" + loaders[0].loader.data);
               }
               else
               {
                  loaders[0].loader.data.payload.position = 0;
                  _loc2_ = loaders[0].loader.data.payload.readUnsignedByte().toString(16);
                  while(_loc2_.length < 2)
                  {
                     _loc2_ = "0" + _loc2_;
                  }
                  Debug.info("[PortCleaner] removed Port with id \'0x" + _loc2_ + "\' (not grouped)");
               }
               if(_removingPorts.length <= 0)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
               Logicware.finalizeMCPLoader(loaders[0].loader,loaders[0].complete,loaders[0].failed);
               loaders.shift();
            },lData.failed = function(param1:Event):void
            {
               var _loc2_:* = _removingPorts.shift().toString(16);
               while(_loc2_.length < 2)
               {
                  _loc2_ = "0" + _loc2_;
               }
               Debug.info("[PortCleaner] removing port \'0x" + _loc2_ + "\' failed!\n" + param1);
               if(_removingPorts.length <= 0)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
               Logicware.finalizeMCPLoader(loaders[0].loader,loaders[0].complete,loaders[0].failed);
               loaders.shift();
            });
            loaders.push(lData);
            lData.loader.request(MCPBuilder.buildMCP(Commands.REMOVE_PORT,MCPBuilder.payloadRemovePort(toRemove)));
         }
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         Debug.warning("PortCleaner timed out!");
         this.reset();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function reset() : void
      {
         this.timeoutTimer.reset();
         this.context = null;
         this._processingGroups = null;
         this.groupedPorts = null;
         this.portList = null;
      }
   }
}
