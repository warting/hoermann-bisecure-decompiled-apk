package refactor.logicware._3_PAL.GatewayDiscover
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class GatewayInfos implements IEventDispatcher
   {
       
      
      private var _189118908gateway:Gateway;
      
      private var _444517567isAvailable:Boolean;
      
      private var _260576752isRemote:Boolean;
      
      private var _1147692044address:String;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function GatewayInfos()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get gateway() : Gateway
      {
         return this._189118908gateway;
      }
      
      public function set gateway(param1:Gateway) : void
      {
         var _loc2_:Object = this._189118908gateway;
         if(_loc2_ !== param1)
         {
            this._189118908gateway = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gateway",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isAvailable() : Boolean
      {
         return this._444517567isAvailable;
      }
      
      public function set isAvailable(param1:Boolean) : void
      {
         var _loc2_:Object = this._444517567isAvailable;
         if(_loc2_ !== param1)
         {
            this._444517567isAvailable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isAvailable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isRemote() : Boolean
      {
         return this._260576752isRemote;
      }
      
      public function set isRemote(param1:Boolean) : void
      {
         var _loc2_:Object = this._260576752isRemote;
         if(_loc2_ !== param1)
         {
            this._260576752isRemote = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isRemote",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get address() : String
      {
         return this._1147692044address;
      }
      
      public function set address(param1:String) : void
      {
         var _loc2_:Object = this._1147692044address;
         if(_loc2_ !== param1)
         {
            this._1147692044address = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"address",_loc2_,param1));
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
