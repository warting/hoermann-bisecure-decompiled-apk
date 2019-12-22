package refactor.bisecur._2_SAL.net.cache.userRights
{
   import flash.events.Event;
   import refactor.bisecur._2_SAL.gatewayData.User;
   
   public class GatewayUserRightsEvent extends Event
   {
      
      public static const RIGHTS_SET:String = "GATEWAY_USER_RIGHTS_SET";
      
      public static const RIGHTS_READ:String = "GATEWAY_USER_RIGHTS_READ";
       
      
      private var _user:User;
      
      private var _rights:Array;
      
      public function GatewayUserRightsEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:User = null, param5:Array = null)
      {
         super(param1,param2,param3);
         this._user = param4;
         this._rights = param5;
      }
      
      public function get user() : User
      {
         return this._user;
      }
      
      public function get rights() : Array
      {
         return this._rights;
      }
   }
}
