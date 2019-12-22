package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.SetStateAction;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
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
         var _loc4_:Object = null;
         var _loc5_:SetStateAction = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc5_ = new SetStateAction();
            _loc5_.port = _loc4_.portId;
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
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var portId:int = param1;
         var state:int = param2;
         if(this.tmpActions.length <= 0)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
            this.timeoutTimer = null;
            this.dispatchEvent(new Event(Event.COMPLETE));
         }
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            if(loader.data.command == Commands.SET_STATE || loader.data.command == Commands.HM_GET_TRANSITION || loader.data.command == Commands.ERROR)
            {
               if(!loader.preceding || !loader.preceding.payload || loader.preceding.payload.length < 2)
               {
                  Debug.warning("[StateSetter] received invalid setState response: \n" + loader.data);
               }
               loader.preceding.payload.position = 0;
               _loc2_ = loader.preceding.payload.readUnsignedByte();
               _loc3_ = loader.preceding.payload.readUnsignedByte();
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
                  Debug.warning("[StateSetter] unexpected setState: " + loader.preceding);
               }
               else if(tmpActions.length > 0)
               {
                  setState(tmpActions[0].port,tmpActions[0].state);
               }
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[StateSetter] setting state failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_STATE,MCPBuilder.payloadSetState(portId,state)));
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
      }
   }
}
