package com.isisic.remote.hoermann.net.portal
{
   import flash.events.Event;
   
   public class PortalGatewayEvent extends Event
   {
      
      public static const LOADED:String = "PortalGatewaysLoaded";
      
      public static const LOADING_FAILED:String = "PortalGatewaysLoadingFailed";
       
      
      private var _gateways:Array;
      
      public function PortalGatewayEvent(param1:Array, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param2,param3,param4);
         this._gateways = param1;
      }
      
      public function get gateways() : Array
      {
         return this._gateways;
      }
   }
}
