package com.isisic.remote.hoermann.global.valueObjects.localStorage
{
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   import mx.events.PropertyChangeEvent;
   
   public class Scenario implements IExternalizable, IEventDispatcher
   {
       
      
      private var _3373707name:String;
      
      public var actions:Array;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function Scenario()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:ScenarioAction = null;
         Debug.debug("[Scenario] Write");
         param1.writeUTF(this.name);
         param1.writeUnsignedInt(this.actions.length);
         for each(_loc3_ in this.actions)
         {
            _loc2_ = new ByteArray();
            _loc3_.writeExternal(_loc2_);
            param1.writeUnsignedInt(_loc2_.length);
            param1.writeBytes(_loc2_);
         }
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:ScenarioAction = null;
         var _loc5_:ByteArray = null;
         Debug.debug("[Scenario] read");
         this.name = param1.readUTF();
         this.actions = new Array();
         var _loc2_:uint = param1.readUnsignedInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc5_ = new ByteArray();
            _loc3_ = param1.readUnsignedInt();
            param1.readBytes(_loc5_,0,_loc3_);
            _loc4_ = new ScenarioAction(0,0,0);
            _loc4_.readExternal(_loc5_);
            this.actions.push(_loc4_);
            _loc6_++;
         }
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
