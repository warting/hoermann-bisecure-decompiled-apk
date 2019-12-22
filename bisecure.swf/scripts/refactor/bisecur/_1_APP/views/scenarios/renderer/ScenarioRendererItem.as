package refactor.bisecur._1_APP.views.scenarios.renderer
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   
   public class ScenarioRendererItem implements IEventDispatcher
   {
       
      
      private var _231708046rendererState:ScenarioRendererSate;
      
      public var scenario:Scenario;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function ScenarioRendererItem(param1:ConstructorLock#185)
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public static function createArray(param1:Array) : Array
      {
         var scenarios:Array = param1;
         return scenarios.map(function(param1:Scenario, param2:int, param3:Array):ScenarioRendererItem
         {
            return create(param1);
         });
      }
      
      public static function create(param1:Scenario) : ScenarioRendererItem
      {
         var _loc2_:ScenarioRendererItem = new ScenarioRendererItem(null);
         _loc2_.rendererState = ScenarioRendererSate.sharedState;
         _loc2_.scenario = param1;
         return _loc2_;
      }
      
      public static function toggleEditMode() : Boolean
      {
         setEditMode(!getEditMode());
         return getEditMode();
      }
      
      public static function setEditMode(param1:Boolean) : void
      {
         ScenarioRendererSate.sharedState.editMode = param1;
      }
      
      public static function getEditMode() : Boolean
      {
         return ScenarioRendererSate.sharedState.editMode;
      }
      
      public function dispose() : void
      {
         this.rendererState = null;
         this.scenario = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererState() : ScenarioRendererSate
      {
         return this._231708046rendererState;
      }
      
      public function set rendererState(param1:ScenarioRendererSate) : void
      {
         var _loc2_:Object = this._231708046rendererState;
         if(_loc2_ !== param1)
         {
            this._231708046rendererState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rendererState",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

class ConstructorLock#185
{
    
   
   function ConstructorLock#185()
   {
      super();
   }
}

import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;

class ScenarioRendererSate extends EventDispatcher
{
   
   public static const sharedState:ScenarioRendererSate = new ScenarioRendererSate();
    
   
   private var _1601832653editMode:Boolean;
   
   function ScenarioRendererSate()
   {
      super();
   }
   
   [Bindable(event="propertyChange")]
   public function get editMode() : Boolean
   {
      return this._1601832653editMode;
   }
   
   public function set editMode(param1:Boolean) : void
   {
      var _loc2_:Object = this._1601832653editMode;
      if(_loc2_ !== param1)
      {
         this._1601832653editMode = param1;
         if(this.hasEventListener("propertyChange"))
         {
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"editMode",_loc2_,param1));
         }
      }
   }
}
