package com.isisic.remote.hoermann.global.valueObjects.remoteObjects
{
   import com.isisic.remote.hoermann.global.GroupTypes;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class HmGroup implements IEventDispatcher
   {
      
      public static const FEATURE_ADD_PORT:uint = 1;
      
      public static const FEATURE_INHERIT_PORT:uint = 2;
       
      
      public var id:int = -1;
      
      private var _3373707name:String = null;
      
      public var ports:Array = null;
      
      public var type:int = -1;
      
      private var _109757585state:String;
      
      private var _236449952stateValue:String;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function HmGroup()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public static function fromObject(param1:Object) : HmGroup
      {
         var _loc2_:HmGroup = new HmGroup();
         _loc2_.id = param1.id;
         _loc2_.name = param1.name;
         _loc2_.type = !!param1.type?int(param1.type):-1;
         _loc2_.state = param1.state;
         _loc2_.ports = param1.ports;
         return _loc2_;
      }
      
      public function toString() : String
      {
         return "[HmGroup: id=\'" + this.id + "\' name=\'" + this.name + "\' ports=\'" + this.ports + "\' type=\'" + this.type + "\' state=\'" + this.state + "\' stateValue=\'" + this.stateValue + "\']";
      }
      
      public function hasFeature(param1:uint) : Boolean
      {
         return (this.features & param1) == param1;
      }
      
      public function get features() : uint
      {
         if(this.type == GroupTypes.SMARTKEY)
         {
            return FEATURE_ADD_PORT;
         }
         return FEATURE_ADD_PORT | FEATURE_INHERIT_PORT;
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
      
      [Bindable(event="propertyChange")]
      public function get state() : String
      {
         return this._109757585state;
      }
      
      public function set state(param1:String) : void
      {
         var _loc2_:Object = this._109757585state;
         if(_loc2_ !== param1)
         {
            this._109757585state = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"state",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stateValue() : String
      {
         return this._236449952stateValue;
      }
      
      public function set stateValue(param1:String) : void
      {
         var _loc2_:Object = this._236449952stateValue;
         if(_loc2_ !== param1)
         {
            this._236449952stateValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateValue",_loc2_,param1));
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
