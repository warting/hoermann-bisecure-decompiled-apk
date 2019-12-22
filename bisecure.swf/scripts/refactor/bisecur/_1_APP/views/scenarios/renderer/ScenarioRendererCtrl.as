package refactor.bisecur._1_APP.views.scenarios.renderer
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ScenarioRendererCtrl implements IEventDispatcher
   {
       
      
      private var _80818744Title:String = "";
      
      private var _3242771item:ScenarioRendererItem;
      
      public var view:ScenarioRenderer;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function ScenarioRendererCtrl()
      {
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onInit() : void
      {
         ChangeWatcher.watch(this.view.btnEdit,"visible",this.onChange);
      }
      
      public function onCreationComplete() : void
      {
         this.onChange(null);
      }
      
      public function onData(param1:ScenarioRendererItem) : void
      {
         this.item = param1;
         if(param1 == null)
         {
            this.Title = "";
         }
         else
         {
            this.Title = param1.scenario.name;
         }
      }
      
      private function onChange(param1:Event) : void
      {
         if(this.item.rendererState.editMode)
         {
            this.view.marginRight = this.view.marginLeft + this.view.btnEdit.width;
         }
         else
         {
            this.view.marginRight = this.view.marginLeft;
         }
         this.view.invalidateDisplayList();
      }
      
      [Bindable(event="propertyChange")]
      public function get Title() : String
      {
         return this._80818744Title;
      }
      
      public function set Title(param1:String) : void
      {
         var _loc2_:Object = this._80818744Title;
         if(_loc2_ !== param1)
         {
            this._80818744Title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : ScenarioRendererItem
      {
         return this._3242771item;
      }
      
      public function set item(param1:ScenarioRendererItem) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
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
