package com.isisic.remote.hoermann.net
{
   import com.isisic.remote.hoermann.components.popups.ErrorBox;
   import com.isisic.remote.hoermann.global.ActorClasses;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.helper.HmTransitionHelper;
   import com.isisic.remote.hoermann.global.stateHelper.IStateHelper;
   import com.isisic.remote.hoermann.global.stateHelper.StateHelperFactory;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.Timings;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import me.mweber.basic.helper.StringHelper;
   import me.mweber.components.SyntaxTextArea;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import spark.components.TextArea;
   
   public class TransitionCollector extends EventDispatcher implements IDisposable
   {
      
      private static const REQUEST_TIMEOUT_DELAY:int = Timings.MCPPROCESSOR_REQUEST_TIMEOUTS["FALLBACK"];
      
      private static const MAX_REQUEST_RETRYS:int = 3;
      
      private static const BUSY_RETRY_DELAY:int = 1500;
      
      private static const ERROR_RETRY_DELAY:int = 1500;
       
      
      private var _1909310018transitions:Object;
      
      public var processablePorts:Object;
      
      private var context:ConnectionContext;
      
      private var timeoutTimer:Timer;
      
      private var _processingTransitions:Array;
      
      private var retryCounter:int;
      
      public function TransitionCollector(param1:ConnectionContext)
      {
         super();
         this.context = param1;
         this.timeoutTimer = new Timer(REQUEST_TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
      }
      
      public static function parseHmTransition(param1:ByteArray) : HmTransition
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         param1.position = 0;
         var _loc2_:HmTransition = new HmTransition();
         _loc2_.actual = param1.readUnsignedByte();
         _loc2_.desired = param1.readUnsignedByte();
         var _loc3_:* = int(param1.readUnsignedByte());
         var _loc4_:int = param1.readUnsignedByte();
         _loc2_.error = false;
         _loc2_.autoClose = false;
         if(_loc3_ >> 6 > 0)
         {
            if((_loc3_ & 128) > 0)
            {
               _loc2_.error = true;
            }
            if((_loc3_ & 64) > 0)
            {
               _loc2_.autoClose = true;
               if((_loc3_ & 16) > 0)
               {
               }
            }
            _loc3_ = _loc3_ & ~240;
         }
         if(_loc2_.error == false)
         {
            _loc2_.driveTime = (_loc3_ << 8) + _loc4_;
         }
         var _loc5_:int = param1.readUnsignedByte();
         var _loc6_:int = param1.readUnsignedByte();
         _loc2_.gk = (_loc5_ << 8) + _loc6_;
         _loc2_.hcp = null;
         if(_loc5_ < 252)
         {
            _loc11_ = param1.readUnsignedByte();
            _loc12_ = param1.readUnsignedByte();
            _loc2_.hcp = HCP.fromRaw(_loc11_,_loc12_);
         }
         _loc2_.exst = new Array();
         var _loc7_:int = 0;
         while(_loc7_ < 8)
         {
            _loc2_.exst.push(param1.readUnsignedByte());
            _loc7_++;
         }
         _loc2_.exst.reverse();
         _loc2_.time = new Date();
         if(_loc2_.hcp != null && _loc2_.hcp.driving == false)
         {
            if(_loc2_.driveTime > 0 || _loc2_.hcp.forecastLeadTime)
            {
               _loc2_.driveTime = 2;
               _loc2_.ignoreRetries = true;
               _loc2_.hcp = null;
            }
         }
         else if(_loc2_.hcp != null && _loc2_.hcp.driving == true)
         {
            if(_loc2_.driveTime <= 0)
            {
               _loc2_.driveTime = 2;
               _loc2_.ignoreRetries = true;
            }
         }
         if(_loc2_.gk == ActorClasses.ESE && HmTransitionHelper.isDriving(_loc2_))
         {
            _loc2_.driveTime = 5;
            _loc2_.ignoreRetries = true;
         }
         var _loc8_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc9_:IStateHelper = StateHelperFactory.getStateHelper(_loc2_);
         var _loc10_:HmTransition = _loc9_.forceTransition(_loc2_);
         if(_loc10_ == null)
         {
            _loc2_ = _loc8_.forceTransition(_loc2_);
         }
         else
         {
            _loc2_ = _loc10_;
         }
         return _loc2_;
      }
      
      private function get processingTransitions() : Array
      {
         return this._processingTransitions;
      }
      
      private function set processingTransitions(param1:Array) : void
      {
         this._processingTransitions = param1;
      }
      
      public function dispose() : void
      {
         this.context = null;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            if(this.timeoutTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
            {
               this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
            }
            this.timeoutTimer = null;
         }
         this.transitions = null;
         this.processablePorts = null;
         this.processingTransitions = null;
      }
      
      [Bindable("processingChanged")]
      public function get processing() : Boolean
      {
         return this.processingTransitions && this.processingTransitions.length > 0;
      }
      
      public function collect(param1:int = -1, param2:Object = null, param3:Boolean = true) : Boolean
      {
         var group:String = null;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var gid:int = param1;
         var processablePorts:Object = param2;
         var clearOldTransitions:Boolean = param3;
         if(this.processing)
         {
            Debug.warning("[TransitionCollector] Can not collect transitions: Already processing!");
            return false;
         }
         this.processablePorts = !!processablePorts?processablePorts:new Object();
         this.transitions = new Object();
         this.processingTransitions = new Array();
         this.retryCounter = 0;
         if(processablePorts)
         {
            if(gid < 0)
            {
               for(group in this.processablePorts)
               {
                  this.processingTransitions.push(int(group));
                  if(clearOldTransitions)
                  {
                     this.transitions[int(group)] = null;
                  }
               }
            }
            else
            {
               this.processingTransitions.push(gid);
               if(clearOldTransitions)
               {
                  this.transitions[gid] = null;
               }
            }
            if(clearOldTransitions)
            {
               dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,this.transitions));
            }
            dispatchEvent(new Event("processingChanged"));
            this.requestTransition();
            return true;
         }
         if(HoermannRemote.gatewayData.userRights != null)
         {
            this.readProcessables(HoermannRemote.gatewayData.userRights);
            Debug.info("[TransitionCollector] Using buffered userRights in collect()");
            return true;
         }
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(loader.data.command != Commands.GET_USER_RIGHTS)
            {
               Debug.warning("[TransitionCollector] read userrights failed! MCP:\n" + loader.data);
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            loader.data.payload.position = 1;
            var _loc2_:* = new Array();
            while(loader.data.payload.bytesAvailable)
            {
               _loc2_.push(loader.data.payload.readUnsignedByte());
            }
            HoermannRemote.gatewayData.userRights = _loc2_;
            readProcessables(_loc2_);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[TransitionCollector] reading userrights failed!\n" + param1);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.GET_USER_RIGHTS,MCPBuilder.payloadGetUserRights(HoermannRemote.appData.userId)));
         return true;
      }
      
      public function cancelCollecting(param1:Array = null) : void
      {
         var _loc2_:int = 0;
         Debug.debug("[TransitionCollector] canceling Requests");
         if(!this.processingTransitions)
         {
            this.processingTransitions = new Array();
         }
         if(this.processingTransitions.length > 1)
         {
            this.processingTransitions.splice(1,this.processingTransitions.length - 1);
            Debug.debug("[TransitionCollector] processingTransitions > 1 shifting to " + this.processingTransitions.length);
         }
         if(param1 != null)
         {
            Debug.debug("[TransitionCollector] " + param1.length + " lastCaLLs given");
            for each(_loc2_ in param1)
            {
               if(this.processablePorts[_loc2_] != null)
               {
                  Debug.debug("[TransitionCollector] adding call");
                  this.processingTransitions.push(_loc2_);
               }
               else
               {
                  Debug.warning("[TransitionCollector] can not add lastCall \'" + StringHelper.fillWith(_loc2_.toString(16),"0") + "\' (processable port not found)");
               }
            }
            Debug.debug("[TransitionCollector] processingTransitions = " + this.processingTransitions.length);
            if(this.processingTransitions.length == param1.length)
            {
               Debug.debug("[TransitionCollector] collecting not active => starting");
               this.requestTransition();
            }
         }
      }
      
      private function readProcessables(param1:Array) : void
      {
         var onValuesChanged:Function = null;
         var key:String = null;
         var gId:int = 0;
         var userRights:Array = param1;
         if(HoermannRemote.gatewayData.values != null)
         {
            Debug.info("[TransitionCollector] Using buffered Key / Values in readProcessables()");
            for each(gId in userRights)
            {
               key = (gId + AppData.MAX_PORTS).toString();
               while(key.length < 2)
               {
                  key = "0" + key;
               }
               this.processingTransitions.push(gId);
               this.processablePorts[gId] = HoermannRemote.gatewayData.values[key];
            }
            dispatchEvent(new Event("processingChanged"));
            this.requestTransition();
            return;
         }
         HoermannRemote.gatewayData.addEventListener(GatewayData.VALUES_CHANGED,onValuesChanged = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            HoermannRemote.gatewayData.removeEventListener(GatewayData.VALUES_CHANGED,onValuesChanged);
            Debug.debug("[TransitionCollector] updated values");
            for each(_loc3_ in userRights)
            {
               _loc2_ = (_loc3_ + AppData.MAX_PORTS).toString();
               while(_loc2_.length < 2)
               {
                  _loc2_ = "0" + _loc2_;
               }
               processingTransitions.push(_loc3_);
               processablePorts[_loc3_] = HoermannRemote.gatewayData.values[_loc2_];
            }
            HmProcessor.defaultProcessor.requestablePorts = processablePorts;
            dispatchEvent(new Event("processingChanged"));
            requestTransition();
         });
         HoermannRemote.gatewayData.updateValues(this.context);
      }
      
      private function complete() : void
      {
         var _loc3_:* = null;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
         this.processingTransitions = null;
         this.retryCounter = 0;
         var _loc1_:ErrorBox = ErrorBox.create("TRANSITIONS FINISHED");
         var _loc2_:TextArea = new SyntaxTextArea();
         _loc2_.editable = false;
         _loc2_.percentWidth = 100;
         _loc2_.height = 800;
         _loc2_.text = "";
         for(_loc3_ in this.transitions)
         {
            _loc2_.text = _loc2_.text + (_loc3_ + ": " + this.transitions[_loc3_] + "\n");
         }
         _loc1_.contentText = _loc2_.text;
         this.dispatchEvent(new Event(Event.COMPLETE));
         dispatchEvent(new Event("processingChanged"));
      }
      
      private function requestTransition() : void
      {
         var toRequest:int = 0;
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var oldTrans:HmTransition = null;
         if(!this.processing)
         {
            this.complete();
            return;
         }
         toRequest = this.processablePorts[this.processingTransitions[0]];
         if(toRequest == 255)
         {
            this.retryCounter = 0;
            this.processingTransitions.shift();
            Debug.debug("[TransitionCollector] (port: 0x" + StringHelper.fillWith(toRequest.toString(16),"0") + ") Actor not requestable shifting to " + this.processingTransitions.length);
            this.requestTransition();
            return;
         }
         if(this.retryCounter >= MAX_REQUEST_RETRYS)
         {
            Debug.info("[TransitionCollector] MAX_RETRIES reached for port: " + StringHelper.fillWith(toRequest.toString(16),"0"));
            this.retryCounter = 0;
            oldTrans = this.transitions[this.processingTransitions[0]];
            this.transitions[this.processingTransitions[0]] = null;
            this.processingTransitions.shift();
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"transitions",oldTrans,null,this.transitions));
            this.requestTransition();
            return;
         }
         if(this.timeoutTimer.running)
         {
         }
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var _loc5_:* = undefined;
            if(!loader.data.validToken)
            {
               Debug.error("[TransitionCollector] received HM_TRANSITION response with invalid token!");
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               errorRetry();
               return;
            }
            retryCounter++;
            if(timeoutTimer)
            {
               timeoutTimer.reset();
            }
            if(loader.data.command != Commands.HM_GET_TRANSITION)
            {
               Debug.warning("[TransitionCollector] requesting transition (0x" + StringHelper.fillWith(toRequest.toString(16),"0") + ") failed! mcp:\n" + loader.data);
               errorRetry();
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            if(!loader.data.payload || loader.data.payload.length < 4)
            {
               Debug.warning("[TransitionCollector] Received HM_TRANSITION with no valid payload!\n\t" + loader.data);
               errorRetry();
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var _loc2_:* = TransitionCollector.parseHmTransition(loader.data.payload);
            if(_loc2_.ignoreRetries == true)
            {
               retryCounter = 0;
            }
            if(!processingTransitions || processingTransitions.length < 1)
            {
               Debug.error("[TransitionCollector] received transition that can\'t be assigned  to a actor");
               requestTransition();
               Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
               return;
            }
            var _loc3_:* = processingTransitions[0];
            var _loc4_:* = transitions[_loc3_];
            transitions[_loc3_] = _loc2_;
            Debug.debug("[TransitionCollector] transition assigned to group: " + _loc3_);
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"transitions",_loc4_,_loc2_,transitions));
            if(_loc2_.driveTime == 0 || _loc2_.error || _loc2_.autoClose)
            {
               Debug.debug("[TransitionCollector] collection for group " + _loc3_ + " finished!");
               retryCounter = 0;
               processingTransitions.shift();
               requestTransition();
            }
            else
            {
               Debug.debug("[TransitionCollector] collecting new transition for group: " + _loc3_);
               _loc5_ = new Timer(_loc2_.driveTime * 1000,1);
               _loc5_.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayedRequest);
               _loc5_.start();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[TransitionCollector] requesting transition (0x" + toRequest.toString(16) + ") failed!\n" + param1);
            requestTransition();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.HM_GET_TRANSITION,MCPBuilder.payloadGetTransition(toRequest)));
      }
      
      private function errorRetry() : void
      {
         var tmr:Timer = null;
         var tmrComplete:Function = null;
         tmr = new Timer(ERROR_RETRY_DELAY,1);
         tmrComplete = function(param1:Event):void
         {
            tmr.removeEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete);
            requestTransition();
         };
         tmr.addEventListener(TimerEvent.TIMER_COMPLETE,tmrComplete);
         tmr.start();
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         Debug.debug("[TransitionCollector] request timeout");
         this.timeoutTimer.reset();
         this.retryCounter++;
         this.requestTransition();
      }
      
      private function onDelayedRequest(param1:TimerEvent) : void
      {
         Debug.debug("[TransitionCollector] delayed request");
         (param1.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayedRequest);
         this.requestTransition();
      }
      
      [Bindable(event="propertyChange")]
      public function get transitions() : Object
      {
         return this._1909310018transitions;
      }
      
      public function set transitions(param1:Object) : void
      {
         var _loc2_:Object = this._1909310018transitions;
         if(_loc2_ !== param1)
         {
            this._1909310018transitions = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transitions",_loc2_,param1));
            }
         }
      }
   }
}
