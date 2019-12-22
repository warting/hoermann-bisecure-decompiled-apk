package refactor.bisecur._1_APP.views.manageUsers.renderer
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit.IUserEditFeature;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class UserRendererItem implements IDisposable, IEventDispatcher
   {
       
      
      private var _231708046rendererState:UserRendererSate;
      
      private var _3599307user:User;
      
      private var _1476418367userEditFeature:IUserEditFeature;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function UserRendererItem(param1:ConstructorLock#193)
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public static function create(param1:User, param2:IUserEditFeature) : UserRendererItem
      {
         var _loc3_:UserRendererItem = new UserRendererItem(null);
         _loc3_.rendererState = UserRendererSate.sharedState;
         _loc3_.user = param1;
         _loc3_.userEditFeature = param2;
         return _loc3_;
      }
      
      public static function toggleEditMode() : Boolean
      {
         setEditMode(!getEditMode());
         return getEditMode();
      }
      
      public static function setEditMode(param1:Boolean) : void
      {
         UserRendererSate.sharedState.editMode = param1;
      }
      
      public static function getEditMode() : Boolean
      {
         return UserRendererSate.sharedState.editMode;
      }
      
      public function dispose() : void
      {
         this.rendererState = null;
         this.user = null;
         this.userEditFeature = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererState() : UserRendererSate
      {
         return this._231708046rendererState;
      }
      
      public function set rendererState(param1:UserRendererSate) : void
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
      
      [Bindable(event="propertyChange")]
      public function get user() : User
      {
         return this._3599307user;
      }
      
      public function set user(param1:User) : void
      {
         var _loc2_:Object = this._3599307user;
         if(_loc2_ !== param1)
         {
            this._3599307user = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"user",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userEditFeature() : IUserEditFeature
      {
         return this._1476418367userEditFeature;
      }
      
      public function set userEditFeature(param1:IUserEditFeature) : void
      {
         var _loc2_:Object = this._1476418367userEditFeature;
         if(_loc2_ !== param1)
         {
            this._1476418367userEditFeature = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userEditFeature",_loc2_,param1));
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

class ConstructorLock#193
{
    
   
   function ConstructorLock#193()
   {
      super();
   }
}

import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;

class UserRendererSate extends EventDispatcher
{
   
   public static const sharedState:UserRendererSate = new UserRendererSate();
    
   
   private var _1601832653editMode:Boolean;
   
   function UserRendererSate()
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
