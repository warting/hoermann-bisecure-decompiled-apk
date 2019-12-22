package refactor.bisecur._2_SAL.gatewayData
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class User implements IEventDispatcher
   {
      
      public static const ID_UNKNOWN:int = -1;
      
      public static const ID_ADMIN:int = 0;
       
      
      public var id:int;
      
      private var _3373707name:String;
      
      public var password:String;
      
      public var gateway:Gateway;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function User()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public static function createByCredentials(param1:String, param2:String, param3:Gateway) : User
      {
         var _loc4_:User = new User();
         _loc4_.id = -1;
         _loc4_.name = param1;
         _loc4_.password = param2;
         _loc4_.gateway = param3;
         return _loc4_;
      }
      
      public function get isAdmin() : Boolean
      {
         return this.id == ID_ADMIN;
      }
      
      public function get isDefaultLogin() : Boolean
      {
         return this.name == "admin" && this.password == "0000";
      }
      
      public function clone() : User
      {
         var _loc1_:User = new User();
         _loc1_.id = this.id;
         _loc1_.name = this.name;
         _loc1_.password = this.password;
         _loc1_.gateway = this.gateway;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "[User: id=\'" + this.id + "\' name=\'" + this.name + "\' password=\'" + this.password + "\' gateway=\'" + this.gateway + "\']";
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
