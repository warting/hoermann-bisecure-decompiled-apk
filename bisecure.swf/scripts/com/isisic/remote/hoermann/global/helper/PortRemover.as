package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   
   public class PortRemover extends EventDispatcher
   {
       
      
      private var context:ConnectionContext;
      
      private var tmpPorts:Array;
      
      private var timeoutTimer:Timer;
      
      public function PortRemover(param1:ConnectionContext, param2:int = 5000)
      {
         super();
         this.context = param1;
         this.timeoutTimer = new Timer(param2,1);
      }
      
      public function remove(param1:Array) : void
      {
         if(this.tmpPorts && this.tmpPorts.length > 0)
         {
            Debug.error("can not remove ports (Remover is busy)");
            return;
         }
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.tmpPorts = param1;
         this.deleteRequest();
      }
      
      private function deleteRequest() : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         this.timeoutTimer.reset();
         if(!this.tmpPorts || this.tmpPorts.length < 1)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         this.timeoutTimer.start();
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            if(loader.data.command == Commands.ERROR)
            {
               if(loader.data.response)
               {
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               if(!loader.data.payload || loader.data.payload.length < 1)
               {
                  Debug.warning("[PortRemover] received MCP-Error without payload! mcp:\n" + loader.data);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               loader.data.payload.position = 0;
               _loc2_ = loader.data.payload.readUnsignedByte();
               if(_loc2_ != Errors.PORT_NOT_FOUND)
               {
                  Debug.warning("[PortRemover] received unexpected MCP-Error! mcp:\n" + loader.data);
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               if(!loader.preceding || !loader.preceding.payload || loader.preceding.payload.length < 1)
               {
                  Debug.warning("[PortRemover] Received PORT_NOT_FOUND error but can not find valid preceding protocol! (in PortRempver)\n" + "\tmcp: " + loader.data + "\n" + "\tpreceding: " + loader.preceding);
                  return;
               }
               loader.preceding.payload.position = 0;
               _loc3_ = loader.preceding.payload.readUnsignedByte();
               new ArrayList(tmpPorts).removeItem(_loc3_);
               deleteRequest();
            }
            else if(loader.data.command == Commands.REMOVE_PORT)
            {
               if(!loader.data.response)
               {
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               if(!loader.data.payload || loader.data.payload.length < 1)
               {
                  Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
                  return;
               }
               loader.data.payload.position = 0;
               _loc4_ = loader.data.payload.readUnsignedByte();
               new ArrayList(tmpPorts).removeItem(_loc4_);
               deleteRequest();
            }
            else
            {
               Debug.warning("[PortRemover] removing port \'" + tmpPorts[0] + "\' failed! unexpected MCP:\n" + loader.data);
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[PortRemover] removing port \'" + tmpPorts[0] + "\' failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.REMOVE_PORT,MCPBuilder.payloadRemovePort(this.tmpPorts[0])));
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         Debug.warning("timeout while removing port: " + this.tmpPorts[0]);
         this.tmpPorts.shift();
         this.deleteRequest();
      }
   }
}
