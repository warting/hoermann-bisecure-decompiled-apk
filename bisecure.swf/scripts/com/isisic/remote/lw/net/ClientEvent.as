package com.isisic.remote.lw.net
{
   import flash.events.Event;
   
   public class ClientEvent extends Event
   {
      
      public static const BUFFER_PROCESSED:String = "CLIENT_BUFFER_PROCESSED";
       
      
      public function ClientEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
