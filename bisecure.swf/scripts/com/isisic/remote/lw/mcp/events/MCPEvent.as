package com.isisic.remote.lw.mcp.events
{
   import com.isisic.remote.lw.mcp.MCP;
   import flash.events.Event;
   
   public class MCPEvent extends Event
   {
      
      public static const SEND:String = "SEND";
      
      public static const RECEIVED:String = "RECEIVED";
      
      public static const SEND_FAIL:String = "SEND_FAIL";
       
      
      protected var _mcp:MCP;
      
      protected var _preceding:MCP;
      
      public function MCPEvent(param1:MCP, param2:MCP, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         super(param3,param4,param5);
         this._mcp = param1;
         this._preceding = param2;
      }
      
      public function get mcp() : MCP
      {
         return this._mcp;
      }
      
      public function get preceding() : MCP
      {
         return this._preceding;
      }
   }
}
