package com.isisic.remote.hoermann.net.dao.users
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import flash.events.Event;
   
   public class GatewayUsersEvent extends Event
   {
      
      public static const USER_CREATED:String = "GATEWAY_USER_CREATED";
      
      public static const USERS_READ:String = "GATEWAY_USERS_READ";
      
      public static const USER_UPDATED:String = "GATEWAY_USER_UPDATED";
      
      public static const USER_DELETED:String = "GATEWAY_USER_DELETED";
       
      
      private var _user:User;
      
      public function GatewayUsersEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:User = null)
      {
         super(param1,param2,param3);
         this._user = param4;
      }
      
      public function get user() : User
      {
         return this._user;
      }
   }
}
