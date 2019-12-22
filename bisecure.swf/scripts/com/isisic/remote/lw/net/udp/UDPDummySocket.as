package com.isisic.remote.lw.net.udp
{
   import be.aboutme.nativeExtensions.udp.UDPSocket;
   import flash.utils.ByteArray;
   
   public class UDPDummySocket extends UDPSocket
   {
       
      
      public function UDPDummySocket()
      {
         super();
      }
      
      override public function get isSupported() : Boolean
      {
         return true;
      }
      
      override public function send(param1:ByteArray, param2:String, param3:uint) : void
      {
      }
      
      override public function bind(param1:uint, param2:String = "0.0.0.0") : void
      {
      }
      
      override public function receive() : void
      {
      }
      
      override public function close() : void
      {
      }
   }
}
