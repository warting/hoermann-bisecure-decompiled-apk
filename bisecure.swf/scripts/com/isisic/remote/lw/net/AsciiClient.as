package com.isisic.remote.lw.net
{
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.net.tcp.Client;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   use namespace lw_network;
   
   public class AsciiClient extends Client
   {
      
      public static var INSTANCE_COUNT:int = 0;
      
      public static const DEFAULT_COMPLETATION_TIMEOUT:int = 1500;
      
      public static const DEFAULT_SEND_INTERVAL:int = 100;
       
      
      public function AsciiClient(param1:Socket = null)
      {
         super(param1);
         INSTANCE_COUNT++;
      }
      
      override public function send(param1:ByteArray) : void
      {
         if(!param1 || !(param1 is ByteArray))
         {
            Debug.error("Class AsciiClient expects a String as Parameter to Send Method!");
            return;
         }
         param1.position = 0;
         super.send(param1);
      }
      
      override public function get connected() : Boolean
      {
         if(!socket)
         {
            return false;
         }
         return socket.connected;
      }
      
      override public function destruct() : void
      {
         super.destruct();
         if(this.socket == null && this.buffer == null)
         {
            INSTANCE_COUNT--;
         }
      }
   }
}
