package refactor.logicware._2_SAL.tmcp
{
   import avmplus.getQualifiedClassName;
   import flash.utils.ByteArray;
   import refactor.logicware._4_HAL.network.IClient;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   
   public class TMCPWriter implements IDisposable
   {
       
      
      private var client:IClient;
      
      public function TMCPWriter(param1:IClient)
      {
         super();
         this.client = param1;
      }
      
      public function write(param1:TMCPPackage) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1.serialize());
         if(Log.TRACE_OUTPUT)
         {
            Log.outPackage(param1.mcp,param1.sourceAddress,param1.destinationAddress,getQualifiedClassName(this.client));
         }
         if(Log.TRACE_OUTPUT)
         {
            Log.info("[TMCPWriter] Writing: " + param1.serialize());
         }
         this.client.send(_loc2_);
      }
      
      public function dispose() : void
      {
         this.client = null;
      }
   }
}
