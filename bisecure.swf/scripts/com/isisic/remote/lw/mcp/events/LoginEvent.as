package com.isisic.remote.lw.mcp.events
{
   import com.isisic.remote.lw.mcp.MCP;
   import flash.events.Event;
   
   public class LoginEvent extends Event
   {
      
      public static const LOGIN:String = "login";
      
      public static const LOGOUT:String = "logout";
       
      
      private var _mcp:MCP;
      
      public function LoginEvent(param1:String, param2:MCP, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._mcp = param2;
      }
      
      public function get mcp() : MCP
      {
         return this._mcp;
      }
   }
}
