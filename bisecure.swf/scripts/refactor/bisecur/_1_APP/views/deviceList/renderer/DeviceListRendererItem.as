package refactor.bisecur._1_APP.views.deviceList.renderer
{
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.HmGroup;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import refactor.logicware._5_UTIL.IDisposable;
   
   public class DeviceListRendererItem extends EventDispatcher implements IDisposable
   {
       
      
      private var _231708046rendererState:DeviceListRendererSate;
      
      public var device:HmGroup;
      
      public function DeviceListRendererItem(param1:ConstructorLock#165)
      {
         super();
      }
      
      public static function create(param1:HmGroup) : DeviceListRendererItem
      {
         var _loc2_:DeviceListRendererItem = new DeviceListRendererItem(null);
         _loc2_.rendererState = DeviceListRendererSate.sharedState;
         _loc2_.device = param1;
         return _loc2_;
      }
      
      public static function toggleEditMode() : Boolean
      {
         setEditMode(!getEditMode());
         return getEditMode();
      }
      
      public static function setEditMode(param1:Boolean) : void
      {
         DeviceListRendererSate.sharedState.editMode = param1;
      }
      
      public static function getEditMode() : Boolean
      {
         return DeviceListRendererSate.sharedState.editMode;
      }
      
      public static function setIsRefreshing(param1:Boolean) : void
      {
         DeviceListRendererSate.sharedState.isRefreshing = param1;
      }
      
      public function notifyItemChanged() : *
      {
         dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,true,false,PropertyChangeEventKind.UPDATE));
      }
      
      public function dispose() : void
      {
         this.rendererState = null;
         this.device = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererState() : DeviceListRendererSate
      {
         return this._231708046rendererState;
      }
      
      public function set rendererState(param1:DeviceListRendererSate) : void
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
   }
}

class ConstructorLock#165
{
    
   
   function ConstructorLock#165()
   {
      super();
   }
}

import flash.events.Event;
import flash.events.EventDispatcher;
import mx.events.PropertyChangeEvent;

class DeviceListRendererSate extends EventDispatcher
{
   
   public static const sharedState:DeviceListRendererSate = new DeviceListRendererSate();
    
   
   private var _1601832653editMode:Boolean;
   
   [Bindable("refreshingChanged")]
   private var _isRefreshing:Boolean;
   
   function DeviceListRendererSate()
   {
      super();
   }
   
   [Bindable("refreshingChanged")]
   public function get isRefreshing() : Boolean
   {
      return this._isRefreshing;
   }
   
   public function set isRefreshing(param1:Boolean) : void
   {
      this._isRefreshing = param1;
      dispatchEvent(new Event("refreshingChanged"));
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
