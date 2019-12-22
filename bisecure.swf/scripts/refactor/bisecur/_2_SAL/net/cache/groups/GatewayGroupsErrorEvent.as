package refactor.bisecur._2_SAL.net.cache.groups
{
   import flash.events.Event;
   
   public class GatewayGroupsErrorEvent extends Event
   {
      
      public static const GROUP_CREATE_FAILED:String = "GATEWAY_GROUP_CREATE_FAILED";
      
      public static const GROUPS_READ_FAILED:String = "GATEWAY_GROUPS_READ_FAILED";
      
      public static const GROUP_UPDATE_FAILED:String = "GATEWAY_GROUP_UPDATE_FAILED";
      
      public static const GROUP_DELETE_FAILED:String = "GATEWAY_GROUP_DELETE_FAILED";
       
      
      private var _error:int;
      
      public function GatewayGroupsErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1)
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
