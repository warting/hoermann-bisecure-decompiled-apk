package refactor.logicware._2_SAL.mcp
{
   import com.isisic.remote.lw.net.lw_network;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.apache.flex.collections.ArrayList;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.LocalConnectionContext;
   import refactor.logicware._2_SAL.tmcp.TMCPPackage;
   import refactor.logicware._2_SAL.tmcp.TMCPReader;
   import refactor.logicware._2_SAL.tmcp.TMCPReaderEvent;
   import refactor.logicware._2_SAL.tmcp.TMCPWriter;
   import refactor.logicware._4_HAL.network.IClient;
   import refactor.logicware._4_HAL.network.Timings;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   
   use namespace lw_network;
   
   public class MCPPackageQueue extends EventDispatcher implements IDisposable
   {
       
      
      private var context:ConnectionContext;
      
      private var reader:TMCPReader;
      
      private var writer:TMCPWriter;
      
      private var mcpQueue:Vector.<TMCPPackage>;
      
      private var token:uint = 0;
      
      private var _activePackage:TMCPPackage;
      
      private var packageReceiverList:ArrayList;
      
      private var watchdog:Timer;
      
      public function MCPPackageQueue(param1:ConnectionContext, param2:IClient)
      {
         super();
         this.context = param1;
         this.reader = new TMCPReader(param2);
         this.reader.addEventListener(TMCPReaderEvent.RECEIVE,this.packageReceive_handler);
         this.writer = new TMCPWriter(param2);
         this.mcpQueue = new Vector.<TMCPPackage>(0);
         this.watchdog = new Timer(Timings.MCPPROCESSOR_REQUEST_TIMEOUTS.FALLBACK);
         this.watchdog.addEventListener(TimerEvent.TIMER,this.watchdog_handler);
         this.packageReceiverList = new ArrayList();
      }
      
      private function set activePackage(param1:TMCPPackage) : *
      {
         this._activePackage = param1;
         dispatchEvent(new Event("processingChanged"));
      }
      
      private function get activePackage() : TMCPPackage
      {
         return this._activePackage;
      }
      
      [Bindable("processingChanged")]
      public function get isProcessing() : Boolean
      {
         return this.activePackage != null;
      }
      
      public function send(param1:TMCPPackage, param2:Function) : void
      {
         param1.mcp = MCPPackageBuffer.sharedBuffer.insert(param1.mcp,param2);
         this.mcpQueue.push(param1);
         if(!this.isProcessing)
         {
            this._processQueue();
         }
      }
      
      public function addPackageReceiver(param1:Function) : void
      {
         this.packageReceiverList.addItem(param1);
      }
      
      public function removePackageReceiver(param1:Function) : void
      {
         this.packageReceiverList.removeItem(param1);
      }
      
      private function callPackageReceiver(param1:MCPPackage, param2:MCPPackage) : void
      {
         var _loc3_:Function = null;
         if(this.packageReceiverList.length <= 0)
         {
            return;
         }
         for each(_loc3_ in this.packageReceiverList.toArray())
         {
            CallbackHelper.callCallback(_loc3_,[param1,param2]);
         }
      }
      
      public function dispose() : void
      {
         this.reader.removeEventListener(TMCPReaderEvent.RECEIVE,this.packageReceive_handler);
         this.reader.dispose();
         this.reader = null;
         this.writer.dispose();
         this.writer = null;
         this.activePackage = null;
         if(this.watchdog.running)
         {
            this.watchdog.stop();
         }
         this.watchdog.removeEventListener(TimerEvent.TIMER,this.watchdog_handler);
         this.watchdog = null;
      }
      
      private function _processQueue() : void
      {
         if(this.mcpQueue.length < 1)
         {
            this.activePackage = null;
            return;
         }
         this.activePackage = this.mcpQueue.shift();
         this.activePackage.mcp.token = this.token;
         this.initWatchdog();
         this.watchdog.start();
         try
         {
            this.writer.write(this.activePackage);
            return;
         }
         catch(error:Error)
         {
            Log.error("sending package failed! \n" + error);
            return;
         }
      }
      
      private function packageReceive_handler(param1:TMCPReaderEvent) : void
      {
         this.watchdog.reset();
         var _loc2_:TMCPPackage = param1.data;
         var _loc3_:MCPPackage = _loc2_.mcp;
         if(this.context is LocalConnectionContext)
         {
            this.context._clientId = _loc2_.destinationAddress;
         }
         _loc3_.validToken = _loc3_.token == this.token || _loc3_.token == 0;
         if(_loc3_.command == MCPCommands.LOGIN && _loc3_.response)
         {
            _loc3_.payload.position = 0;
            _loc3_.payload.readUnsignedByte();
            this.token = _loc3_.payload.readUnsignedInt();
            _loc3_.payload.position = 0;
         }
         else if(_loc3_.command == MCPCommands.LOGOUT)
         {
            this.token = 0;
            if(_loc3_.tag == 255)
            {
               AppCache.sharedCache.logout();
            }
         }
         if(!_loc3_.validToken)
         {
            Log.info("[MCPPackageQueue] received package with invalid token => no reply to callback\n\t\t\t\t" + _loc2_);
            return;
         }
         if(_loc3_.tag == 255)
         {
            Log.info("[MCPPackageQueue] received package with 0xFF tag => no reply to loader\n\t\t\t\t" + _loc2_);
            this.callPackageReceiver(_loc3_,null);
            return;
         }
         var _loc4_:Function = MCPPackageBuffer.sharedBuffer.readExtra(_loc3_.tag) as Function;
         var _loc5_:MCPPackage = MCPPackageBuffer.sharedBuffer.remove(_loc3_.tag);
         if(_loc4_ != null)
         {
            _loc4_(_loc3_,_loc5_);
         }
         this.callPackageReceiver(_loc3_,_loc5_);
         this._processQueue();
      }
      
      private function initWatchdog() : void
      {
         var _loc1_:String = MCPCommands.NAMES[this.activePackage.mcp.command];
         if(Timings.MCPPROCESSOR_REQUEST_TIMEOUTS[_loc1_] != null)
         {
            this.watchdog.delay = Timings.MCPPROCESSOR_REQUEST_TIMEOUTS[_loc1_];
         }
         else
         {
            this.watchdog.delay = Timings.MCPPROCESSOR_REQUEST_TIMEOUTS.FALLBACK;
         }
      }
      
      private function watchdog_handler(param1:TimerEvent) : void
      {
         this.watchdog.reset();
         Log.warning("[MCPPackageQueue] Request timed out: " + this.activePackage);
         var _loc2_:Function = MCPPackageBuffer.sharedBuffer.readExtra(this.activePackage.mcp.tag) as Function;
         MCPPackageBuffer.sharedBuffer.remove(this.activePackage.mcp.tag);
         _loc2_(null,this.activePackage.mcp);
         this._processQueue();
      }
   }
}
