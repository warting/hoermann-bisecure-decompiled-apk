package refactor.bisecur._2_SAL.net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._2_SAL.net.transitionCollecting.TransitionCollector;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class HmProcessor extends EventDispatcher implements IDisposable
   {
       
      
      private var _1909310018transitions:Object;
      
      public var _requestablePorts:Object;
      
      private var context:ConnectionContext;
      
      private var transCollector:TransitionCollector;
      
      public function HmProcessor(param1:ConnectionContext)
      {
         var context:ConnectionContext = param1;
         super();
         this.context = context;
         this.transCollector = new TransitionCollector();
         this.transCollector.addEventListener(Event.COMPLETE,this.onTransitionCollected);
         this.transitions = {};
         this.transCollector.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onTransitionUpdated);
         this.transCollector.addEventListener("processingChanged",function(param1:Event):void
         {
            dispatchEvent(new Event(param1.type));
         });
      }
      
      public function get requestablePorts() : Object
      {
         return this._requestablePorts;
      }
      
      public function set requestablePorts(param1:Object) : void
      {
         this._requestablePorts = param1;
      }
      
      public function get collector() : TransitionCollector
      {
         return this.transCollector;
      }
      
      public function dispose() : void
      {
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
            this.context = null;
         }
      }
      
      public function cancelCollecting(param1:Array = null) : void
      {
         this.transCollector.cancelCollection();
      }
      
      [Bindable("processingChanged")]
      public function get transitionCollectingActive() : Boolean
      {
         return this.transCollector.processing;
      }
      
      private function onTransitionUpdated(param1:PropertyChangeEvent) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in this.transCollector.transitions)
         {
            this.transitions[int(_loc2_)] = this.transCollector.transitions[int(_loc2_)];
         }
         dispatchEvent(new HmProcessorEvent(HmProcessorEvent.TRANSITION_LOADED));
      }
      
      public function requestTransition(param1:int = -1, param2:Boolean = true) : void
      {
         if(param1 < 0)
         {
            this.transitions = {};
            param2 = true;
         }
         else
         {
            this.transitions[param1] = null;
         }
         this.transCollector.collect(param1,param2);
      }
      
      private function onTransitionCollected(param1:Event) : void
      {
         var _loc2_:* = null;
         if(this.transCollector == null)
         {
            return;
         }
         for(_loc2_ in this.transCollector.transitions)
         {
            this.transitions[int(_loc2_)] = this.transCollector.transitions[int(_loc2_)];
         }
         dispatchEvent(new HmProcessorEvent(HmProcessorEvent.TRANSITIONS_UPDATED));
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
