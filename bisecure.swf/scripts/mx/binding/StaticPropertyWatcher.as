package mx.binding
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   public class StaticPropertyWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var parentObj:Class;
      
      protected var events:Object;
      
      private var propertyGetter:Function;
      
      private var _propertyName:String;
      
      public function StaticPropertyWatcher(param1:String, param2:Object, param3:Array, param4:Function = null)
      {
         super(param3);
         this._propertyName = param1;
         this.events = param2;
         this.propertyGetter = param4;
      }
      
      public function get propertyName() : String
      {
         return this._propertyName;
      }
      
      override public function updateParent(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:IEventDispatcher = null;
         this.parentObj = Class(param1);
         if(this.parentObj["staticEventDispatcher"] != null)
         {
            for(_loc2_ in this.events)
            {
               if(_loc2_ != "__NoChangeEvent__")
               {
                  _loc3_ = this.parentObj["staticEventDispatcher"];
                  _loc3_.addEventListener(_loc2_,this.eventHandler,false,EventPriority.BINDING,true);
               }
            }
         }
         wrapUpdate(this.updateProperty);
      }
      
      override protected function shallowClone() : Watcher
      {
         var _loc1_:StaticPropertyWatcher = new StaticPropertyWatcher(this._propertyName,this.events,listeners,this.propertyGetter);
         return _loc1_;
      }
      
      private function traceInfo() : String
      {
         return "StaticPropertyWatcher(" + this.parentObj + "." + this._propertyName + "): events = [" + this.eventNamesToString() + "]";
      }
      
      private function eventNamesToString() : String
      {
         var _loc2_:* = null;
         var _loc1_:String = " ";
         for(_loc2_ in this.events)
         {
            _loc1_ = _loc1_ + (_loc2_ + " ");
         }
         return _loc1_;
      }
      
      private function updateProperty() : void
      {
         if(this.parentObj)
         {
            if(this.propertyGetter != null)
            {
               value = this.propertyGetter.apply(this.parentObj,[this._propertyName]);
            }
            else
            {
               value = this.parentObj[this._propertyName];
            }
         }
         else
         {
            value = null;
         }
         updateChildren();
      }
      
      public function eventHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(param1 is PropertyChangeEvent)
         {
            _loc2_ = PropertyChangeEvent(param1).property;
            if(_loc2_ != this._propertyName)
            {
               return;
            }
         }
         wrapUpdate(this.updateProperty);
         notifyListeners(this.events[param1.type]);
      }
   }
}
