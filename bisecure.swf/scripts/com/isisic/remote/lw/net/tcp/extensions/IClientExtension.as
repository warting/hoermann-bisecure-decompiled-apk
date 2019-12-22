package com.isisic.remote.lw.net.tcp.extensions
{
   import com.isisic.remote.lw.net.tcp.Client;
   
   public interface IClientExtension
   {
       
      
      function initialize(param1:Client) : void;
      
      function onAction(param1:String, param2:Boolean, param3:Array = null) : Boolean;
      
      function dispose() : void;
   }
}
