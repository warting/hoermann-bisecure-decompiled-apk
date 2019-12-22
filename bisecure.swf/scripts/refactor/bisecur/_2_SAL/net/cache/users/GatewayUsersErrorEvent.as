package refactor.bisecur._2_SAL.net.cache.users
{
   import flash.events.Event;
   
   public class GatewayUsersErrorEvent extends Event
   {
      
      public static const USER_CREATE_FAILED:String = "GATEWAY_USER_CREATE_FAILED";
      
      public static const USERS_READ_FAILED:String = "GATEWAY_USERS_READ_FAILED";
      
      public static const USER_UPDATE_FAILED:String = "GATEWAY_USER_UPDATE_FAILED";
      
      public static const USER_DELETE_FAILED:String = "GATEWAY_USER_DELETE_FAILED";
       
      
      private var _error:int;
      
      public function GatewayUsersErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1)
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
