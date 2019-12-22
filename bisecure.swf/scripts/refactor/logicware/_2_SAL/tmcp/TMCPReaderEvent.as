package refactor.logicware._2_SAL.tmcp
{
   import flash.events.Event;
   
   public class TMCPReaderEvent extends Event
   {
      
      public static const RECEIVE:String = "tmcpreader_receive";
       
      
      private var _data:TMCPPackage;
      
      public function TMCPReaderEvent(param1:String, param2:TMCPPackage)
      {
         super(param1,bubbles,cancelable);
         this._data = param2;
      }
      
      public function get data() : TMCPPackage
      {
         return this._data;
      }
   }
}
