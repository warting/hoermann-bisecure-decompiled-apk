package refactor.bisecur._2_SAL.net.cache.groups
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import mx.collections.ArrayList;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._5_UTIL.Log;
   
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
            Log.error("can not remove ports (Remover is busy)");
            return;
         }
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.tmpPorts = param1;
         this.deleteRequest();
      }
      
      private function deleteRequest() : void
      {
         this.timeoutTimer.reset();
         if(!this.tmpPorts || this.tmpPorts.length < 1)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         this.timeoutTimer.start();
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createRemovePort(this.tmpPorts[0]),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            var _loc3_:uint = 0;
            var _loc4_:ByteArray = null;
            var _loc5_:uint = 0;
            if(param1.response == null)
            {
               Log.error("[PortRemover] removing port \'" + tmpPorts[0] + "\' failed! (NetTimeout)\n");
               InfoCenter.onNetTimeout();
            }
            else if(param1.response.command == MCPCommands.ERROR)
            {
               _loc2_ = MCPErrors.getErrorFromPackage(param1.response);
               InfoCenter.onMCPError(param1.response,_loc2_);
               if(_loc2_ != MCPErrors.PORT_NOT_FOUND)
               {
                  Log.warning("[PortRemover] received unexpected MCP-Error! package:\n" + param1.response);
                  return;
               }
               if(!param1.request || !param1.request.payload || param1.request.payload.length < 1)
               {
                  Log.error("[PortRemover] Received PORT_NOT_FOUND error but can not find valid request!\n" + "\tresponse: " + param1.response + "\n" + "\trequest: " + param1.request);
                  return;
               }
               param1.request.payload.position = 0;
               _loc3_ = param1.request.payload.readUnsignedByte();
               new ArrayList(tmpPorts).removeItem(_loc3_);
               deleteRequest();
            }
            else if(!(param1.response.payload == null || param1.response.payload.length < 1))
            {
               _loc4_ = param1.response.payload;
               _loc4_.position = 0;
               _loc5_ = _loc4_.readUnsignedByte();
               new ArrayList(tmpPorts).removeItem(_loc5_);
               deleteRequest();
            }
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         Log.warning("[PortRemover] timeout while removing port: " + this.tmpPorts[0]);
         this.tmpPorts.shift();
         this.deleteRequest();
      }
   }
}
