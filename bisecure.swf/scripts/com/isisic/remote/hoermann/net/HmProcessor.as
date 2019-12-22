package com.isisic.remote.hoermann.net
{
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.popups.ErrorBox;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.DebugGlobals;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCP;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.mcp.events.MCPEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class HmProcessor extends EventDispatcher implements IDisposable
   {
      
      private static var _716443473defaultProcessor:HmProcessor;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
       
      
      private var _1909310018transitions:Object;
      
      public var _requestablePorts:Object;
      
      private var context:ConnectionContext;
      
      private var transCollector:TransitionCollector;
      
      private var unreachableBox:ErrorBox;
      
      private var calls:int = 1;
      
      public function HmProcessor(param1:ConnectionContext)
      {
         var context:ConnectionContext = param1;
         super();
         if(defaultProcessor)
         {
            throw new Error("MCPProcessor already initialized (use MCPProcessor.defaultProcessor)");
         }
         defaultProcessor = this;
         this.context = context;
         this.context.processor.addEventListener(MCPEvent.RECEIVED,this.onMCP);
         this.transCollector = new TransitionCollector(context);
         this.transCollector.addEventListener(Event.COMPLETE,this.onTransitionCollected);
         this.transitions = new Object();
         this.transCollector.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionUpdated);
         this.transCollector.addEventListener("processingChanged",function(param1:Event):void
         {
            dispatchEvent(param1);
         });
      }
      
      [Bindable(event="propertyChange")]
      public static function get defaultProcessor() : HmProcessor
      {
         return HmProcessor._716443473defaultProcessor;
      }
      
      public static function set defaultProcessor(param1:HmProcessor) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = HmProcessor._716443473defaultProcessor;
         if(_loc2_ !== param1)
         {
            HmProcessor._716443473defaultProcessor = param1;
            _loc3_ = HmProcessor.staticEventDispatcher;
            if(_loc3_ != null && _loc3_.hasEventListener("propertyChange"))
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(HmProcessor,"defaultProcessor",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public function get requestablePorts() : Object
      {
         return this._requestablePorts;
      }
      
      public function set requestablePorts(param1:Object) : void
      {
         this._requestablePorts = param1;
      }
      
      public function dispose() : void
      {
         defaultProcessor = null;
         this.transitions = null;
         this.requestablePorts = null;
         if(this.transCollector)
         {
            this.transCollector.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionUpdated);
            this.transCollector.dispose();
            this.transCollector = null;
         }
         if(this.context)
         {
            this.context.processor.removeEventListener(MCPEvent.RECEIVED,this.onMCP);
            this.context = null;
         }
      }
      
      public function cancelCollecting(param1:Array = null) : void
      {
         this.transCollector.cancelCollecting(param1);
      }
      
      [Bindable("processingChanged")]
      public function get transitionCollectingActive() : Boolean
      {
         return this.transCollector.processing;
      }
      
      private function onTransitionUpdated(param1:PropertyChangeEvent) : void
      {
         var _loc2_:* = null;
         this.requestablePorts = this.transCollector.processablePorts;
         for(_loc2_ in this.transCollector.transitions)
         {
            this.transitions[int(_loc2_)] = this.transCollector.transitions[int(_loc2_)];
         }
         dispatchEvent(new HmProcessorEvent(HmProcessorEvent.TRANSITION_LOADED));
      }
      
      public function destruct() : void
      {
         this.dispose();
      }
      
      public function setRequestable(param1:int, param2:int = 255) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var gId:int = param1;
         var pId:int = param2;
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            if(!loader.data.command == Commands.SET_VALUE)
            {
               return;
            }
            if(!testPayload(loader.data,2))
            {
               return;
            }
            loader.data.payload.position = 0;
            var _loc2_:* = loader.data.payload.readUnsignedByte();
            var _loc3_:* = loader.data.payload.readUnsignedByte();
            HoermannRemote.gatewayData.values[_loc2_] = _loc3_;
            HoermannRemote.gatewayData.dispatchEvent(new Event(GatewayData.VALUES_CHANGED));
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[MCPProcessor] requesting SetValue failed!\n" + param1);
            InfoCenter.onNetTimeout();
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.SET_VALUE,MCPBuilder.payloadSetValue(gId + AppData.MAX_PORTS,pId)));
         if(!this.requestablePorts)
         {
            this.requestablePorts = new Object();
         }
         this.requestablePorts[gId] = pId;
      }
      
      public function requestTransition(param1:int = -1, param2:Boolean = false, param3:Boolean = true) : Boolean
      {
         if(param1 < 0)
         {
            this.transitions = new Object();
            param3 = true;
         }
         else
         {
            this.transitions[param1] = null;
         }
         return this.transCollector.collect(param1,!!param2?null:this.requestablePorts,param3);
      }
      
      private function testPayload(param1:MCP, param2:int) : Boolean
      {
         if(!param1.payload || param1.payload.length < param2)
         {
            Debug.error("[MCPProcessor] can not read payload (payload empty or not enaugh data)");
            return false;
         }
         return true;
      }
      
      private function onTransitionCollected(param1:Event) : void
      {
         var _loc2_:* = null;
         if(this.transCollector == null)
         {
            return;
         }
         this.requestablePorts = this.transCollector.processablePorts;
         for(_loc2_ in this.transCollector.transitions)
         {
            this.transitions[int(_loc2_)] = this.transCollector.transitions[int(_loc2_)];
         }
         dispatchEvent(new HmProcessorEvent(HmProcessorEvent.TRANSITIONS_UPDATED));
      }
      
      private function onMCP(param1:MCPEvent) : void
      {
         var _loc4_:int = 0;
         var _loc2_:MCP = param1.mcp;
         var _loc3_:MCP = param1.preceding;
         switch(_loc2_.command)
         {
            case Commands.ERROR:
               if(!this.testPayload(_loc2_,1))
               {
                  return;
               }
               _loc2_.payload.position = 0;
               _loc4_ = _loc2_.payload.readUnsignedByte();
               if(_loc4_ == Errors.PORT_ERROR)
               {
                  if(Features.showDebugLabel)
                  {
                     DebugGlobals.STATE_CRUD_COUNTER = 0;
                     BottomBar.debugLabel.text = "Requests: " + DebugGlobals.STATE_CRUD_COUNTER;
                  }
                  if(!this.unreachableBox)
                  {
                     this.unreachableBox = ErrorBox.create(Lang.getString("ERROR_PORT_UNREACHABLE"),Lang.getString("ERROR_PORT_UNREACHABLE_CONTENT"),true,Lang.getString("GENERAL_SUBMIT"));
                  }
                  if(!this.unreachableBox.isOpen)
                  {
                     this.calls = 1;
                     this.unreachableBox.title = Lang.getString("ERROR_PORT_UNREACHABLE");
                  }
                  else
                  {
                     this.calls++;
                     this.unreachableBox.title = Lang.getString("ERROR_PORT_UNREACHABLE");
                  }
               }
               else if(_loc4_ == Errors.PERMISSION_DENIED)
               {
                  Debug.error("[MCPProcessor] User has not the permission for the last request! Logging off");
                  HoermannRemote.app.logout();
               }
               break;
         }
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
