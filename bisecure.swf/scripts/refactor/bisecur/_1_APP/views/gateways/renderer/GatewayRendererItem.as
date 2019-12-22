package refactor.bisecur._1_APP.views.gateways.renderer
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class GatewayRendererItem extends EventDispatcher implements IDisposable
   {
       
      
      private var _231708046rendererState:GatewayRendererState;
      
      private var _620542559gatewayInfos:GatewayInfos;
      
      public function GatewayRendererItem(param1:ConstructorLock#110)
      {
         super();
      }
      
      public static function create(param1:GatewayInfos) : GatewayRendererItem
      {
         var _loc2_:GatewayRendererItem = new GatewayRendererItem(null);
         _loc2_.rendererState = GatewayRendererItem.sharedState;
         _loc2_.gatewayInfos = param1;
         return _loc2_;
      }
      
      public static function toggleEditMode() : Boolean
      {
         setEditMode(!getEditMode());
         return getEditMode();
      }
      
      public static function setEditMode(param1:Boolean) : void
      {
         GatewayRendererItem.sharedState.editMode = param1;
      }
      
      public static function getEditMode() : Boolean
      {
         return GatewayRendererItem.sharedState.editMode;
      }
      
      public static function setIsRefreshing(param1:Boolean) : void
      {
         GatewayRendererItem.sharedState.isRefreshing = param1;
      }
      
      public function notifyItemChanged() : *
      {
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,true,false,PropertyChangeEventKind.UPDATE));
      }
      
      public function dispose() : void
      {
         this.rendererState = null;
         this.gatewayInfos = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererState() : GatewayRendererState
      {
         return this._231708046rendererState;
      }
      
      public function set rendererState(param1:GatewayRendererState) : void
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
      public function get gatewayInfos() : GatewayInfos
      {
         return this._620542559gatewayInfos;
      }
      
      public function set gatewayInfos(param1:GatewayInfos) : void
      {
         var _loc2_:Object = this._620542559gatewayInfos;
         if(_loc2_ !== param1)
         {
            this._620542559gatewayInfos = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gatewayInfos",_loc2_,param1));
            }
         }
      }
   }
}

class ConstructorLock#110
{
    
   
   function ConstructorLock#110()
   {
      super();
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.events.PropertyChangeEvent;

class GatewayRendererState implements IEventDispatcher
{
   
   public static const sharedState:GatewayRendererState = new GatewayRendererState();
    
   
   private var _1601832653editMode:Boolean;
   
   private var _1849446385isRefreshing:Boolean;
   
   private var _bindingEventDispatcher:EventDispatcher;
   
   function GatewayRendererState()
   {
      this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
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
   
   [Bindable(event="propertyChange")]
   public function get isRefreshing() : Boolean
   {
      return this._1849446385isRefreshing;
   }
   
   public function set isRefreshing(param1:Boolean) : void
   {
      var _loc2_:Object = this._1849446385isRefreshing;
      if(_loc2_ !== param1)
      {
         this._1849446385isRefreshing = param1;
         if(this.hasEventListener("propertyChange"))
         {
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isRefreshing",_loc2_,param1));
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
