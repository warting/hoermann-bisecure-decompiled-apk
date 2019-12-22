package refactor.bisecur._2_SAL.net.cache.userRights
{
   import flash.events.Event;
   
   public class GatewayUserRightsErrorEvent extends Event
   {
      
      public static const RIGHTS_SET_FAILD:String = "GATEWAY_USER_RIGHTS_SET_FAILED";
      
      public static const RIGHTS_READ_FAILED:String = "GATEWAY_USER_RIGHTS_READ_FAILED";
       
      
      private var _error:int;
      
      public function GatewayUserRightsErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1)
      {
         super(param1,param2,param3);
         this._error = param4;
      }
      
      public function get error() : int
      {
         return this._error;
      }
   }
}
