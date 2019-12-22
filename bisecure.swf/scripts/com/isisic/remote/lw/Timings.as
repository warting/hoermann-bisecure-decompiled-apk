package com.isisic.remote.lw
{
   public final class Timings
   {
      
      public static const MCPPROCESSOR_REQUEST_TIMEOUTS:Object = {
         "GET_NAME":4000,
         "INHERIT_PORT":25000,
         "ADD_PORT":25000,
         "SCAN_WIFI":10000,
         "LOGIN":10000,
         "FALLBACK":15000
      };
      
      public static const TCP_CONNECTION_DELAY:int = 0;
      
      public static const TCP_CONNECTION_TIMEOUT:int = 500;
      
      public static const UDP_SEARCH_TIMEOUT:Number = 10000;
      
      public static const UDP_DESKTOP_SEARCH_TIMEOUT:Number = 1000;
      
      public static const NET_DEBUG_FLUSH_INTERVAL:Number = 1000;
       
      
      public function Timings()
      {
         super();
      }
   }
}
