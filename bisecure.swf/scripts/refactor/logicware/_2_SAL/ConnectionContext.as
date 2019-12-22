package refactor.logicware._2_SAL
{
   import com.isisic.remote.lw.net.lw_network;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import refactor.logicware._2_SAL.mcp.MCPPackageQueue;
   import refactor.logicware._5_UTIL.IDisposable;
   
   use namespace lw_network;
   
   public class ConnectionContext extends EventDispatcher implements IDisposable
   {
       
      
      protected var _packageQueue:MCPPackageQueue;
      
      lw_network var _clientId:String;
      
      protected var _mac:String;
      
      public function ConnectionContext()
      {
         super();
      }
      
      lw_network function set packageQueue(param1:MCPPackageQueue) : void
      {
         if(this._packageQueue != null)
         {
            this._packageQueue.removeEventListener("processingChanged",this.onPackageQueue_ProcessingChanged);
         }
         this._packageQueue = param1;
         if(this._packageQueue != null)
         {
            this._packageQueue.addEventListener("processingChanged",this.onPackageQueue_ProcessingChanged);
         }
      }
      
      lw_network function get packageQueue() : MCPPackageQueue
      {
         return this._packageQueue;
      }
      
      [Bindable("isCommunicatingChanged")]
      public function get isCommunicating() : Boolean
      {
         return this.packageQueue.isProcessing;
      }
      
      public function get clientId() : String
      {
         return this._clientId;
      }
      
      public function get mac() : String
      {
         return this._mac;
      }
      
      public function get connected() : Boolean
      {
         return false;
      }
      
      public function connect(param1:Function = null) : void
      {
      }
      
      public function disconnect() : void
      {
      }
      
      public function dispose() : void
      {
         this.packageQueue = null;
      }
      
      protected function canDisconnect() : Boolean
      {
         var onProcessingChanged:Function = null;
         if(this.packageQueue.isProcessing)
         {
            this.packageQueue.addEventListener("processingChanged",onProcessingChanged = function(param1:Event):void
            {
               packageQueue.removeEventListener("processingChanged",onProcessingChanged);
               disconnect();
            });
            return false;
         }
         return true;
      }
      
      protected function onPackageQueue_ProcessingChanged(param1:Event) : void
      {
         dispatchEvent(new Event("isCommunicatingChanged"));
      }
   }
}
