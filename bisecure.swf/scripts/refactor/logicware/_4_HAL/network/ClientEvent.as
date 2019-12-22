package refactor.logicware._4_HAL.network
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class ClientEvent extends Event
   {
      
      public static const RECEIVE:String = "IClient_Receive";
       
      
      private var _data:ByteArray;
      
      public function ClientEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:ByteArray = null)
      {
         super(param1,param2,param3);
         this._data = param4;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
   }
}
