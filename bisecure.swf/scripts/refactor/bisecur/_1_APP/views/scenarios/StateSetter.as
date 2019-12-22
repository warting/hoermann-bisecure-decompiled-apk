package refactor.bisecur._1_APP.views.scenarios
{
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.SetStateAction;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import refactor.bisecur._2_SAL.gatewayData.ScenarioAction;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPCommands;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._5_UTIL.Log;
   
   public class StateSetter extends EventDispatcher
   {
      
      public static const TIMEOUT_DELAY:int = 600000;
       
      
      private var context:ConnectionContext;
      
      private var tmpActions:Array;
      
      private var timeoutTimer:Timer;
      
      public function StateSetter(param1:ConnectionContext)
      {
         super();
         this.context = param1;
      }
      
      public function setScenarios(param1:Array, param2:int = 255) : void
      {
         var _loc4_:ScenarioAction = null;
         var _loc5_:SetStateAction = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc5_ = new SetStateAction();
            _loc5_.port = _loc4_.deviceAction;
            _loc5_.state = param2;
            _loc3_.push(_loc5_);
         }
         this.setStates(_loc3_);
      }
      
      public function setStates(param1:Array) : void
      {
         if(param1.length < 1)
         {
            return;
         }
         this.tmpActions = param1;
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer.start();
         this.setState(this.tmpActions[0].port,this.tmpActions[0].state);
      }
      
      private function setState(param1:int, param2:int) : void
      {
         var portId:int = param1;
         var state:int = param2;
         if(this.tmpActions.length <= 0)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
            this.timeoutTimer = null;
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
         new MCPLoader(this.context).load(MCPBuilder.createSetState(portId,state,MCPPackage.getFromPool()),function(param1:MCPLoader):void
         {
            var _loc2_:int = 0;
            var _loc3_:int = 0;
            var _loc4_:Boolean = false;
            var _loc5_:int = 0;
            var _loc6_:SetStateAction = null;
            if(param1.response == null)
            {
               Log.warning("[StateSetter] setting state failed! (NetTimeout)");
               InfoCenter.onNetTimeout();
               return;
            }
            if(param1.response.command == MCPCommands.ERROR)
            {
               InfoCenter.onMCPError(param1.response,MCPErrors.getErrorFromPackage(param1.response));
            }
            if(param1.response.command == MCPCommands.SET_STATE || param1.response.command == MCPCommands.HM_GET_TRANSITION || param1.response.command == MCPCommands.ERROR)
            {
               if(!param1.request || !param1.request.payload || param1.request.payload.length < 2)
               {
                  Log.warning("[StateSetter] received invalid setState response: \n" + param1.response);
               }
               param1.request.payload.position = 0;
               _loc2_ = param1.request.payload.readUnsignedByte();
               _loc3_ = param1.request.payload.readUnsignedByte();
               _loc4_ = false;
               _loc5_ = 0;
               while(_loc5_ < tmpActions.length)
               {
                  _loc6_ = tmpActions[_loc5_];
                  if(_loc6_.port == _loc2_ && _loc6_.state == _loc3_)
                  {
                     _loc4_ = true;
                     tmpActions.splice(_loc5_,1);
                     break;
                  }
                  _loc5_++;
               }
               if(!_loc4_)
               {
                  Log.warning("[StateSetter] unexpected setState: " + param1.request);
               }
               else if(tmpActions.length > 0)
               {
                  setState(tmpActions[0].port,tmpActions[0].state);
               }
            }
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }
}
