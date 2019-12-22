package refactor.bisecur._2_SAL.gatewayData
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class Scenario implements IEventDispatcher
   {
       
      
      public var id:int = -1;
      
      private var _3373707name:String;
      
      public var actions:Array;
      
      public var userId:int = -1;
      
      public var gatewayMac:String;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function Scenario(param1:int, param2:String)
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
         this.userId = param1;
         this.gatewayMac = param2;
      }
      
      public function toString() : String
      {
         var _loc2_:ScenarioAction = null;
         var _loc1_:* = "[Scenario: name=\'" + this.name + "\' userId=\'" + this.userId + "\' mac=\'" + this.gatewayMac + "\']";
         if(this.actions != null)
         {
            for each(_loc2_ in this.actions)
            {
               _loc1_ = _loc1_ + ("\n\t" + _loc2_);
            }
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
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
