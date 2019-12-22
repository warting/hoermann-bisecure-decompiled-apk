package com.isisic.remote.lw.net
{
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   
   public interface IClient extends IEventDispatcher
   {
       
      
      function get connected() : Boolean;
      
      function connect(param1:String, param2:int) : void;
      
      function close() : void;
      
      function destruct() : void;
      
      function send(param1:ByteArray) : void;
   }
}
