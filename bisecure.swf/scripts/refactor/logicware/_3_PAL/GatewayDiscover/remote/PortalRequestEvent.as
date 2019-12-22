package refactor.logicware._3_PAL.GatewayDiscover.remote
{
   import flash.events.Event;
   
   public class PortalRequestEvent extends Event
   {
      
      public static const COMPLETE:String = "portalRequestComplete";
      
      public static const FAILED:String = "portalRequestFailed";
       
      
      private var _json:Object;
      
      public function PortalRequestEvent(param1:Object, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param2,param3,param4);
         this._json = param1;
      }
      
      public function get json() : Object
      {
         return this._json;
      }
   }
}
