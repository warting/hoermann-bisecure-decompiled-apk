package spark.components
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.StageOrientationEvent;
   import mx.core.FlexGlobals;
   import mx.core.InteractionMode;
   import mx.core.mx_internal;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerComponent;
   import spark.core.NavigationUnit;
   
   use namespace mx_internal;
   
   public class ViewMenu extends SkinnablePopUpContainer implements IFocusManagerComponent
   {
       
      
      private var isMouseDown:Boolean = false;
      
      private var _caretIndex:int = -1;
      
      private var oldCaretIndex:int = -1;
      
      private var caretIndexChanged:Boolean = false;
      
      private var _items:Vector.<ViewMenuItem>;
      
      public function ViewMenu()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
      }
      
      public function get caretIndex() : int
      {
         return this._caretIndex;
      }
      
      public function set caretIndex(param1:int) : void
      {
         if(this._caretIndex == param1)
         {
            return;
         }
         this.oldCaretIndex = this._caretIndex;
         this._caretIndex = param1;
         this.caretIndexChanged = true;
         invalidateProperties();
      }
      
      public function get items() : Vector.<ViewMenuItem>
      {
         return this._items;
      }
      
      public function set items(param1:Vector.<ViewMenuItem>) : void
      {
         var _loc3_:int = 0;
         this._items = param1;
         var _loc2_:Array = [];
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc2_.push(this._items[_loc3_]);
               _loc3_++;
            }
         }
         mxmlContent = _loc2_;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.caretIndexChanged)
         {
            this.caretIndexChanged = false;
            this.setShowsCaret(this.oldCaretIndex,false);
            this.setShowsCaret(this.caretIndex,true);
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         super.keyDownHandler(param1);
         if(!this.items || !layout || param1.isDefaultPrevented() || this.isMouseDown)
         {
            return;
         }
         this.adjustSelectionAndCaretUponNavigation(param1);
      }
      
      override protected function getCurrentSkinState() : String
      {
         var _loc1_:String = super.getCurrentSkinState();
         if(FlexGlobals.topLevelApplication.aspectRatio == "portrait")
         {
            return super.getCurrentSkinState();
         }
         return _loc1_ + "AndLandscape";
      }
      
      private function adjustSelectionAndCaretUponNavigation(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = mapKeycodeForLayoutDirection(param1);
         if(!NavigationUnit.isNavigationUnit(param1.keyCode))
         {
            return;
         }
         var _loc3_:int = layout.getNavigationDestinationIndex(this.caretIndex,_loc2_,false);
         if(_loc3_ == -1)
         {
            return;
         }
         param1.preventDefault();
         if(param1.ctrlKey || getStyle("interactionMode") == InteractionMode.TOUCH)
         {
            this.setShowsCaret(this.caretIndex,false);
            this._caretIndex = _loc3_;
            this.setShowsCaret(this.caretIndex,true);
         }
      }
      
      private function selectItemAt(param1:int) : void
      {
         if(param1 < 0 || !this.items || param1 >= this.items.length)
         {
            return;
         }
         var _loc2_:ViewMenuItem = ViewMenuItem(getElementAt(param1));
         if(_loc2_.enabled)
         {
            _loc2_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      private function setShowsCaret(param1:int, param2:Boolean) : void
      {
         if(param1 < 0 || !this.items || param1 >= this.items.length)
         {
            return;
         }
         var _loc3_:ViewMenuItem = ViewMenuItem(getElementAt(param1));
         _loc3_.showsCaret = param2;
         if(param2)
         {
            _loc3_.setFocus();
         }
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.orientationChangeHandler,true);
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
         systemManager.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.orientationChangeHandler,true);
      }
      
      private function orientationChangeHandler(param1:StageOrientationEvent) : void
      {
         invalidateSkinState();
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         this.caretIndex = -1;
         this.isMouseDown = true;
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
      }
      
      private function systemManager_mouseUpHandler(param1:Event) : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.systemManager_mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.systemManager_mouseUpHandler);
         this.isMouseDown = false;
      }
   }
}
