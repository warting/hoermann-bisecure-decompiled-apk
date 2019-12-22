package refactor.logicware._2_SAL.mcp
{
   import com.isisic.remote.lw.net.lw_network;
   import flash.events.ErrorEvent;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.tmcp.TMCPPackage;
   import refactor.logicware._5_UTIL.Log;
   
   use namespace lw_network;
   
   public class MCPLoader extends EventDispatcher
   {
       
      
      private var _request:MCPPackage;
      
      private var _response:MCPPackage;
      
      private var _context:ConnectionContext;
      
      private var autoCloseContext:Boolean = false;
      
      private var _callback:Function = null;
      
      public function MCPLoader(param1:ConnectionContext)
      {
         super();
         this._context = param1;
      }
      
      public function get request() : MCPPackage
      {
         return this._request;
      }
      
      public function get response() : MCPPackage
      {
         return this._response;
      }
      
      public function get context() : ConnectionContext
      {
         return this._context;
      }
      
      public function load(param1:MCPPackage, param2:Function = null) : void
      {
         var self:MCPLoader = null;
         var request:MCPPackage = param1;
         var callback:Function = param2;
         self = this;
         this._callback = callback;
         if(this._context == null)
         {
            Log.error("[MCPLoader] can not start request (invalid context: \'null\')");
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"context invalid",2));
            CallbackHelper.callCallback(this._callback,[self]);
            this.dispose();
            return;
         }
         this._context.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         if(!this.context.connected)
         {
            this.autoCloseContext = true;
            this.context.connect(function(param1:Object, param2:Boolean):void
            {
               load(request,callback);
            });
            return;
         }
         this._request = request;
         var tmcp:TMCPPackage = new TMCPPackage();
         tmcp.sourceAddress = this.context.clientId;
         tmcp.destinationAddress = this.context.mac;
         tmcp.mcp = request;
         this._context.packageQueue.send(tmcp,function(param1:MCPPackage, param2:MCPPackage):void
         {
            _response = param1;
            CallbackHelper.callCallback(_callback,[self]);
            if(autoCloseContext)
            {
               autoCloseContext = false;
               context.disconnect();
            }
            dispose();
         });
      }
      
      private function dispose() : void
      {
         if(this._context)
         {
            this._context.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         }
         if(this._request)
         {
            this._request.putToPool();
         }
         if(this._response)
         {
            this._response.putToPool();
         }
         this._request = null;
         this._response = null;
         this._context = null;
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         this._response = null;
         CallbackHelper.callCallback(this._callback,[this]);
         this.dispose();
      }
   }
}
