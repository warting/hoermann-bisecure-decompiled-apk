package spark.components
{
   import flash.events.Event;
   import mx.core.DesignLayer;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.states.State;
   import spark.components.supportClasses.SkinnableComponent;
   
   public class BusyIndicator extends SkinnableComponent
   {
       
      
      private var effectiveVisibility:Boolean = false;
      
      private var effectiveVisibilityChanged:Boolean = true;
      
      public function BusyIndicator()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
         states = [new State({"name":"notRotatingState"}),new State({"name":"rotatingState"})];
         mx_internal::skinDestructionPolicy = "auto";
      }
      
      override protected function commitProperties() : void
      {
         if(this.effectiveVisibilityChanged)
         {
            this.computeEffectiveVisibility();
            if(this.canRotate())
            {
               currentState = "rotatingState";
            }
            else
            {
               currentState = "notRotatingState";
            }
            invalidateSkinState();
            this.effectiveVisibilityChanged = false;
         }
         super.commitProperties();
      }
      
      override protected function getCurrentSkinState() : String
      {
         return currentState;
      }
      
      override public function setVisible(param1:Boolean, param2:Boolean = false) : void
      {
         super.setVisible(param1,param2);
         this.effectiveVisibilityChanged = true;
         invalidateProperties();
      }
      
      override public function set designLayer(param1:DesignLayer) : void
      {
         super.designLayer = param1;
         this.effectiveVisibilityChanged = true;
         invalidateProperties();
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         this.computeEffectiveVisibility();
         if(this.canRotate())
         {
            currentState = "rotatingState";
         }
         this.addVisibilityListeners();
         invalidateSkinState();
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         currentState = "notRotatingState";
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         this.removeVisibilityListeners();
         invalidateSkinState();
      }
      
      private function computeEffectiveVisibility() : void
      {
         if(designLayer && !designLayer.effectiveVisibility)
         {
            this.effectiveVisibility = false;
            return;
         }
         this.effectiveVisibility = true;
         var _loc1_:IVisualElement = this;
         while(_loc1_)
         {
            if(!_loc1_.visible)
            {
               if(!(_loc1_ is IUIComponent) || !IUIComponent(_loc1_).isPopUp)
               {
                  this.effectiveVisibility = false;
                  break;
               }
            }
            _loc1_ = _loc1_.parent as IVisualElement;
         }
      }
      
      private function canRotate() : Boolean
      {
         if(this.effectiveVisibility && stage != null)
         {
            return true;
         }
         return false;
      }
      
      private function addVisibilityListeners() : void
      {
         var _loc1_:IVisualElement = this.parent as IVisualElement;
         while(_loc1_)
         {
            _loc1_.addEventListener(FlexEvent.HIDE,this.visibilityChangedHandler,false,0,true);
            _loc1_.addEventListener(FlexEvent.SHOW,this.visibilityChangedHandler,false,0,true);
            _loc1_ = _loc1_.parent as IVisualElement;
         }
      }
      
      private function removeVisibilityListeners() : void
      {
         var _loc1_:IVisualElement = this;
         while(_loc1_)
         {
            _loc1_.removeEventListener(FlexEvent.HIDE,this.visibilityChangedHandler,false);
            _loc1_.removeEventListener(FlexEvent.SHOW,this.visibilityChangedHandler,false);
            _loc1_ = _loc1_.parent as IVisualElement;
         }
      }
      
      private function visibilityChangedHandler(param1:FlexEvent) : void
      {
         this.effectiveVisibilityChanged = true;
         invalidateProperties();
      }
      
      override protected function layer_PropertyChange(param1:PropertyChangeEvent) : void
      {
         super.layer_PropertyChange(param1);
         if(param1.property == "effectiveVisibility")
         {
            this.effectiveVisibilityChanged = true;
            invalidateProperties();
         }
      }
   }
}
