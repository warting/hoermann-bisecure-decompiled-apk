package com.isisic.remote.lw.mcp
{
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MCPLoader extends EventDispatcher implements IDisposable
   {
       
      
      var requestPackage:MCP;
      
      protected var _data:MCP;
      
      protected var _context:ConnectionContext;
      
      public function MCPLoader(param1:ConnectionContext)
      {
         super();
         this._context = param1;
      }
      
      public function get preceding() : MCP
      {
         return this.requestPackage;
      }
      
      public function get data() : MCP
      {
         return this._data;
      }
      
      public function get context() : ConnectionContext
      {
         return this._context;
      }
      
      public function request(param1:MCP) : void
      {
         if(this._context == null)
         {
            Debug.error("[MCPLoader] can not start request (invalid context: \'null\')");
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"context invalid",2));
            return;
         }
         this.requestPackage = param1;
         this._context.processor.load(this);
      }
      
      public function dispose() : void
      {
         this.requestPackage = null;
         this._context = null;
         this._data = null;
      }
      
      function onRespond(param1:MCP) : void
      {
         this._data = param1;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      function onTimeout() : void
      {
         Debug.warning("[MCPLoader] timeout");
         this._data = null;
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Request timed out",1));
      }
      
      override public function toString() : String
      {
         return "[MCPLoader request=\'" + this.requestPackage + "\' data=\'" + this.data + "\']";
      }
   }
}
