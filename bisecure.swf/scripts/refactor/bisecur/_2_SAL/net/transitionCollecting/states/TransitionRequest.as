package refactor.bisecur._2_SAL.net.transitionCollecting.states
{
   import com.isisic.remote.hoermann.net.NetErrors;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.transitionCollecting.StateContext;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class TransitionRequest extends StateBase
   {
       
      
      public function TransitionRequest()
      {
         super();
      }
      
      override public function Enter(param1:StateContext) : void
      {
         var self:StateBase = null;
         var error:Error = null;
         var context:StateContext = param1;
         self = this;
         new MCPLoader(AppCache.sharedCache.connection).load(MCPBuilder.createGetTransition(context.portId,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            if(param1.response == null)
            {
               error = new Error("Loading new actor State for port \'0x" + StringHelper.int2hex(context.portId) + "\' failed! (Net Timeout)",NetErrors.NETWORK_TIMEOUT);
               context.onError(self,error);
            }
            else if(param1.response.command == MCPCommands.ERROR)
            {
               _loc2_ = MCPErrors.getErrorFromPackage(param1.response);
               InfoCenter.onMCPError(param1.response,_loc2_);
               error = new Error(MCPErrors.NAMES[_loc2_],_loc2_);
               context.onError(self,error);
            }
            else if(param1.response.command != MCPCommands.HM_GET_TRANSITION)
            {
               Log.warning("[TransitionCollector] Loading new actor State for port \'0x" + StringHelper.int2hex(context.portId) + "\' failed! (Unexpected response) mcp:\n" + param1.response);
               error = new Error("Unexpected response",param1.response.command);
               context.onError(self,error);
            }
            else
            {
               context.onTransitionReceived(param1.response.payload);
            }
         });
      }
      
      override public function Exit(param1:StateContext) : void
      {
      }
   }
}
