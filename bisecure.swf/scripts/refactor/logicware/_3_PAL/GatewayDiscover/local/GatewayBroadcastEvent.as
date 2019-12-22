package refactor.logicware._3_PAL.GatewayDiscover.local
{
   import flash.events.Event;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class GatewayBroadcastEvent extends Event
   {
      
      public static const GATEWAY_FOUND:String = "Broadcast_Gateway_found";
       
      
      private var _gateway:Gateway;
      
      private var _srcAddress:String;
      
      public function GatewayBroadcastEvent(param1:String, param2:Gateway = null, param3:String = null)
      {
         super(param1,false,false);
         this._gateway = param2;
         this._srcAddress = param3;
      }
      
      public function get gateway() : Gateway
      {
         return this._gateway;
      }
      
      public function get srcAddress() : String
      {
         return this._srcAddress;
      }
   }
}
