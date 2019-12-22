package com.isisic.remote.lw.net.udp
{
   import flash.events.Event;
   
   public class UDPUnitEvent extends Event
   {
      
      public static const DISCOVERED:String = "DISCOVERED";
       
      
      private var _host:String;
      
      private var _mac:String;
      
      private var _softwareVersion:String;
      
      private var _hardwareVersion:String;
      
      public function UDPUnitEvent(param1:String, param2:String, param3:String, param4:String, param5:String, param6:Boolean = false, param7:Boolean = false)
      {
         super(param5,param6,param7);
         this._host = param1;
         this._mac = param2;
         this._softwareVersion = param3;
         this._hardwareVersion = param4;
      }
      
      public function get host() : String
      {
         return this._host;
      }
      
      public function get mac() : String
      {
         return this._mac;
      }
      
      public function get softwareVersion() : String
      {
         return this._softwareVersion;
      }
      
      public function get hardwareVersion() : String
      {
         return this._hardwareVersion;
      }
   }
}
