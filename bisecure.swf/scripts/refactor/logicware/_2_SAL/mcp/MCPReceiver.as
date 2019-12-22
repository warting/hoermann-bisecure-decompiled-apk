package refactor.logicware._2_SAL.mcp
{
   import com.isisic.remote.lw.net.lw_network;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._5_UTIL.IDisposable;
   
   use namespace lw_network;
   
   public class MCPReceiver implements IDisposable
   {
       
      
      private var _packageQueue:MCPPackageQueue;
      
      private var _callback:Function;
      
      public function MCPReceiver(param1:ConnectionContext)
      {
         super();
         this._packageQueue = param1.packageQueue;
      }
      
      public function start(param1:Function) : void
      {
         this._callback = param1;
         this._packageQueue.addPackageReceiver(this.onPackageReceived);
      }
      
      public function stop() : void
      {
         this._packageQueue.removePackageReceiver(this.onPackageReceived);
         this._callback = null;
      }
      
      public function dispose() : void
      {
         this.stop();
         this._packageQueue = null;
      }
      
      private function onPackageReceived(param1:MCPPackage, param2:MCPPackage) : void
      {
         CallbackHelper.callCallback(this._callback,[param1,param2]);
      }
   }
}
