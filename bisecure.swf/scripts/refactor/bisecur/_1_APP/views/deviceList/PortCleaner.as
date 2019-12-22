package refactor.bisecur._1_APP.views.deviceList
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmPort;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   
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
         this.portList = [];
         this.groupedPorts = [];
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
         var callback:Function = param1;
         new MCPLoader(this.context).load(MCPBuilder.createGetPorts(MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            if(param1.response == null)
            {
               Log.warning("[PortCleaner] requesting ports failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
               Log.warning("[PortCleaner] loading portIds failed! mcp:\n" + param1.response);
            }
            else if(param1.response.command == MCPCommands.GET_PORTS)
            {
               if(!param1.response.payload || param1.response.payload.length < 1)
               {
                  GatewayPorts.instance.invalidateCache();
                  CallbackHelper.callCallback(callback,[]);
                  return;
               }
               param1.response.payload.position = 0;
               while(param1.response.payload.bytesAvailable)
               {
                  portList.push(param1.response.payload.readUnsignedByte());
               }
               GatewayPorts.instance.getPortCount();
               CallbackHelper.callCallback(callback,[]);
            }
            else
            {
               Log.warning("[PortCleaner] received unexpected mcp package! mcp:\n" + param1.response);
            }
         });
      }
      
      private function readGroups(param1:Function) : void
      {
         var callback:Function = param1;
         GatewayGroups.instance.getAll(function():void
         {
            CallbackHelper.callCallback(callback,[]);
         });
      }
      
      private function deleteDeadPorts() : void
      {
         var groupedList:ArrayList = null;
         groupedList = new ArrayList();
         this._removingPorts = [];
         GatewayGroups.instance.getAll(function(param1:GatewayGroups, param2:Array, param3:Error):void
         {
            var group:HmGroup = null;
            var pId:int = 0;
            var loaders:Array = null;
            var toRemove:int = 0;
            var port:HmPort = null;
            var lData:Object = null;
            var sender:GatewayGroups = param1;
            var groups:Array = param2;
            var error:Error = param3;
            for each(group in groups)
            {
               if(group.ports)
               {
                  for each(port in group.ports)
                  {
                     groupedList.addItem(port.id);
                  }
               }
            }
            for each(pId in portList)
            {
               if(groupedList.getItemIndex(pId) < 0)
               {
                  _removingPorts.push(pId);
               }
            }
            if(_removingPorts.length <= 0)
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
            loaders = [];
            for each(toRemove in _removingPorts)
            {
               lData = {
                  "loader":null,
                  "complete":null,
                  "failed":null
               };
               lData.loader = new MCPLoader(context).load(MCPBuilder.createRemovePort(toRemove,MCPPackage.getFromPool()),function(param1:MCPLoader):void
               {
                  var _loc2_:* = undefined;
                  if(param1.response == null)
                  {
                     _loc2_ = _removingPorts.shift().toString(16);
                     while(_loc2_.length < 2)
                     {
                        _loc2_ = "0" + _loc2_;
                     }
                     Log.info("[PortCleaner] removing port \'0x" + _loc2_ + "\' failed! (NetTimeout)");
                     if(_removingPorts.length <= 0)
                     {
                        dispatchEvent(new Event(Event.COMPLETE));
                     }
                     loaders.shift();
                     return;
                  }
                  if(param1.response.command == MCPCommands.ERROR)
                  {
                     InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
                  }
                  _removingPorts.shift();
                  if(!param1.response.payload || param1.response.payload.length < 1)
                  {
                     Log.warning("[PortCleaner] unexpected MCP while removing ports:\n" + loaders[0].loader.response);
                  }
                  else
                  {
                     param1.response.payload.position = 0;
                     _loc2_ = param1.response.payload.readUnsignedByte().toString(16);
                     while(_loc2_.length < 2)
                     {
                        _loc2_ = "0" + _loc2_;
                     }
                     Log.info("[PortCleaner] removed Port with id \'0x" + _loc2_ + "\' (not grouped)");
                  }
                  if(_removingPorts.length <= 0)
                  {
                     dispatchEvent(new Event(Event.COMPLETE));
                  }
                  loaders.shift();
               });
            }
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         Log.warning("PortCleaner timed out!");
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
