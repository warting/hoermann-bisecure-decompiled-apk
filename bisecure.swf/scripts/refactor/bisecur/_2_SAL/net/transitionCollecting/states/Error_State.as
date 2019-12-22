package refactor.bisecur._2_SAL.net.transitionCollecting.states
{
   import refactor.bisecur._2_SAL.net.NetErrors;
   import refactor.bisecur._2_SAL.net.transitionCollecting.StateContext;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class Error_State extends StateBase
   {
       
      
      public function Error_State()
      {
         super();
      }
      
      override public function Enter(param1:StateContext) : void
      {
         var _loc2_:Error = null;
         if(param1.requestCount <= StateContext.MAX_REQUEST_RETRYS && param1.errorCount <= StateContext.MAX_ERROR_RETRYS)
         {
            param1.onRetry();
         }
         else
         {
            _loc2_ = new Error("Loading new actor State for port \'0x" + StringHelper.int2hex(param1.portId) + "\' failed! (Net Timeout)",NetErrors.MAX_RETRIES);
            param1.onRequestFailed(_loc2_);
         }
      }
      
      override public function Exit(param1:StateContext) : void
      {
      }
   }
}
