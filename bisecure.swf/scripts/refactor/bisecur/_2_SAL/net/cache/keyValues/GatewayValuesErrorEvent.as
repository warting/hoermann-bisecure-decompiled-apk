package refactor.bisecur._2_SAL.net.cache.keyValues
{
   import flash.events.Event;
   
   public class GatewayValuesErrorEvent extends Event
   {
      
      public static const SET_VALUE_FAILED:String = "SET_VALUE_FAILED";
      
      public static const GET_VALUES_FAILED:String = "GET_VALUES_FAILED";
       
      
      private var _error:int;
      
      public function GatewayValuesErrorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = -1)
      {
         super(param1,param2,param3);
      }
      
      public function get error() : int
      {
         return this._error;
      }
   }
}
