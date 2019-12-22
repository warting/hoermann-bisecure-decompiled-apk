package refactor.logicware._3_PAL.GatewayDiscover
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class Gateway implements IEventDispatcher
   {
       
      
      private var _3373707name:String;
      
      private var _107855mac:String;
      
      public var protocolVersion:String;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function Gateway()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function equals(param1:Gateway) : Boolean
      {
         return param1 != null && this.mac == param1.mac;
      }
      
      public function toString() : String
      {
         return "[Gateway: name=\"" + this.name + "\" mac=\"" + this.mac + "\" protocolVersion=\"" + this.protocolVersion + "\"]";
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
      public function get mac() : String
      {
         return this._107855mac;
      }
      
      public function set mac(param1:String) : void
      {
         var _loc2_:Object = this._107855mac;
         if(_loc2_ !== param1)
         {
            this._107855mac = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mac",_loc2_,param1));
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
