package com.isisic.remote.lw.mcp.events
{
   import com.isisic.remote.lw.ConnectionContext;
   import flash.events.Event;
   
   public class GatewayFoundEvent extends Event
   {
      
      public static const FOUND:String = "GATEWAY_FOUND";
      
      public static const SCAN_FINISHED:String = "GATEWAY_SCAN_FINISHED";
       
      
      protected var _context:ConnectionContext;
      
      public function GatewayFoundEvent(param1:ConnectionContext, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param2,param3,param4);
         this._context = param1;
      }
      
      public function get context() : ConnectionContext
      {
         return this._context;
      }
   }
}
