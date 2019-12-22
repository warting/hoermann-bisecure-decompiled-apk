package refactor.logicware._2_SAL.tmcp
{
   import avmplus.getQualifiedClassName;
   import flash.events.EventDispatcher;
   import refactor.logicware._4_HAL.network.ClientEvent;
   import refactor.logicware._4_HAL.network.IClient;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   
   public class TMCPReader extends EventDispatcher implements IDisposable
   {
       
      
      private var client:IClient;
      
      public function TMCPReader(param1:IClient)
      {
         super();
         this.client = param1;
         this.client.addEventListener(ClientEvent.RECEIVE,this.onReceive);
      }
      
      private function onReceive(param1:ClientEvent) : void
      {
         if(param1.data == null)
         {
            return;
         }
         var _loc2_:String = param1.data.readUTFBytes(param1.data.bytesAvailable);
         var _loc3_:TMCPPackage = new TMCPPackage().deserialize(_loc2_);
         if(Log.TRACE_INPUT)
         {
            Log.inPackage(_loc3_.mcp,_loc3_.sourceAddress,_loc3_.destinationAddress,getQualifiedClassName(this.client));
         }
         dispatchEvent(new TMCPReaderEvent(TMCPReaderEvent.RECEIVE,_loc3_));
      }
      
      public function dispose() : void
      {
         this.client.removeEventListener(ClientEvent.RECEIVE,this.onReceive);
         this.client = null;
      }
   }
}
