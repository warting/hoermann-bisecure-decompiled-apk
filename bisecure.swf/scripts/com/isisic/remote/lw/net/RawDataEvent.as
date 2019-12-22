package com.isisic.remote.lw.net
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class RawDataEvent extends Event
   {
      
      public static const DATA:String = "RAW_DATA";
      
      public static const NO_DATA:String = "NO_DATA";
       
      
      private var _data:ByteArray;
      
      public function RawDataEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:ByteArray = null)
      {
         super(param1,param2,param3);
         this._data = param4;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
   }
}
