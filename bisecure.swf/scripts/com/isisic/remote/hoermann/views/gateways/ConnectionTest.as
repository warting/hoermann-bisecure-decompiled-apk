package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class ConnectionTest implements IDisposable
   {
       
      
      public var context:ConnectionContext;
      
      private var callback:Function;
      
      public function ConnectionTest(param1:ConnectionContext, param2:Function)
      {
         super();
         this.context = param1;
         this.callback = param2;
      }
      
      public function testConnection() : ConnectionTest
      {
         if(this.context.connected)
         {
            this.ping();
         }
         else
         {
            this.connect();
         }
         return this;
      }
      
      public function dispose() : void
      {
         this.context.processor.removeEventListener(Event.CONNECT,this.onConnect);
         this.context.processor.removeEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
         this.context = null;
         this.callback = null;
      }
      
      private function connect() : void
      {
         this.context.processor.addEventListener(Event.CONNECT,this.onConnect);
         this.context.processor.addEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
         Logicware.API.connect(this.context);
      }
      
      private function ping() : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var self:ConnectionTest = null;
         var loader:MCPLoader = null;
         self = this;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(callback == null)
            {
               return;
            }
            var _loc2_:* = null;
            if(loader.data.payload != null && loader.data.payload.length > 0)
            {
               loader.data.payload.position = 0;
               _loc2_ = loader.data.payload.readUTFBytes(loader.data.payload.bytesAvailable);
            }
            callback.call(null,true,self,_loc2_);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            if(callback == null)
            {
               return;
            }
            callback.call(null,false,self,null);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_NAME));
      }
      
      private function onConnect(param1:Event) : void
      {
         this.context.processor.removeEventListener(Event.CONNECT,this.onConnect);
         this.context.processor.removeEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
         this.ping();
      }
      
      private function onConnectionError(param1:Event) : void
      {
         this.context.processor.removeEventListener(Event.CONNECT,this.onConnect);
         this.context.processor.removeEventListener(IOErrorEvent.IO_ERROR,this.onConnectionError);
         this.callback.call(null,false,this,null);
      }
   }
}
