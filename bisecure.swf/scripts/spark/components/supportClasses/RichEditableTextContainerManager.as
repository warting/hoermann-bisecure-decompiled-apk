package spark.components.supportClasses
{
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ElementRange;
   import flashx.textLayout.edit.IEditManager;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.operations.ApplyFormatOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.tlf_internal;
   import flashx.undo.IUndoManager;
   import flashx.undo.UndoManager;
   import mx.core.mx_internal;
   import mx.events.SandboxMouseEvent;
   import mx.styles.IStyleClient;
   import spark.components.RichEditableText;
   import spark.components.TextSelectionHighlighting;
   
   use namespace mx_internal;
   use namespace tlf_internal;
   
   public class RichEditableTextContainerManager extends TextContainerManager
   {
      
      mx_internal static var hideCursor:Boolean = false;
       
      
      private var hasScrollRect:Boolean = false;
      
      private var textDisplay:RichEditableText;
      
      public function RichEditableTextContainerManager(param1:RichEditableText, param2:IConfiguration = null)
      {
         super(param1,param2);
         this.textDisplay = param1;
      }
      
      override public function drawBackgroundAndSetScrollRect(param1:Number, param2:Number) : Boolean
      {
         var _loc11_:* = undefined;
         var _loc3_:Number = this.textDisplay.width;
         var _loc4_:Number = this.textDisplay.height;
         var _loc5_:Rectangle = getContentBounds();
         if(isNaN(_loc3_))
         {
            _loc3_ = _loc5_.right;
         }
         if(isNaN(_loc4_))
         {
            _loc4_ = _loc5_.bottom;
         }
         var _loc6_:Number = 0;
         if(param1 == 0 && param2 == 0 && _loc5_.left >= _loc6_ && _loc5_.right <= _loc3_ && _loc5_.top >= 0 && _loc5_.bottom <= _loc4_)
         {
            if(this.hasScrollRect)
            {
               container.scrollRect = null;
               this.hasScrollRect = false;
            }
         }
         else
         {
            container.scrollRect = new Rectangle(param1,param2,_loc3_,_loc4_);
            this.hasScrollRect = true;
         }
         var _loc7_:uint = 0;
         var _loc8_:Number = 0;
         var _loc9_:IStyleClient = container as IStyleClient;
         if(_loc9_)
         {
            _loc11_ = _loc9_.getStyle("backgroundColor");
            if(_loc11_ !== undefined)
            {
               _loc7_ = uint(_loc11_);
               _loc8_ = _loc9_.getStyle("backgroundAlpha");
            }
         }
         var _loc10_:Graphics = container.graphics;
         _loc10_.clear();
         _loc10_.lineStyle();
         _loc10_.beginFill(_loc7_,_loc8_);
         _loc10_.drawRect(param1,param2,_loc3_,_loc4_);
         _loc10_.endFill();
         return this.hasScrollRect;
      }
      
      override tlf_internal function getContextMenu() : ContextMenu
      {
         return this.textDisplay.contextMenu != null?null:super.getContextMenu();
      }
      
      override protected function getUndoManager() : IUndoManager
      {
         if(!this.textDisplay.undoManager)
         {
            this.textDisplay.undoManager = new UndoManager();
            this.textDisplay.undoManager.undoAndRedoItemLimit = int.MAX_VALUE;
         }
         return this.textDisplay.undoManager;
      }
      
      override protected function getFocusedSelectionFormat() : SelectionFormat
      {
         var _loc1_:* = this.textDisplay.getStyle("focusedTextSelectionColor");
         var _loc2_:Number = editingMode == EditingMode.READ_WRITE?Number(1):Number(0);
         return new SelectionFormat(_loc1_,1,BlendMode.NORMAL,0,!!hideCursor?Number(0):Number(_loc2_),BlendMode.INVERT);
      }
      
      override protected function getUnfocusedSelectionFormat() : SelectionFormat
      {
         var _loc1_:* = this.textDisplay.getStyle("unfocusedTextSelectionColor");
         var _loc2_:Number = this.textDisplay.selectionHighlighting != TextSelectionHighlighting.WHEN_FOCUSED?Number(1):Number(0);
         return new SelectionFormat(_loc1_,_loc2_,BlendMode.NORMAL,_loc1_,0);
      }
      
      override protected function getInactiveSelectionFormat() : SelectionFormat
      {
         var _loc1_:* = this.textDisplay.getStyle("inactiveTextSelectionColor");
         var _loc2_:Number = 0;
         var _loc3_:Number = this.textDisplay.selectionHighlighting == TextSelectionHighlighting.ALWAYS?Number(1):Number(0);
         var _loc4_:Number = 0;
         return new SelectionFormat(_loc1_,_loc3_,BlendMode.NORMAL,_loc1_,_loc2_,BlendMode.INVERT,_loc4_);
      }
      
      override protected function createEditManager(param1:IUndoManager) : IEditManager
      {
         var _loc2_:IEditManager = super.createEditManager(param1);
         _loc2_.allowDelayedOperations = this.textDisplay.batchTextInput;
         _loc2_.delayUpdates = false;
         return _loc2_;
      }
      
      override public function setText(param1:String) : void
      {
         super.setText(param1);
         this.initForInputIfHaveFocus();
      }
      
      override public function setTextFlow(param1:TextFlow) : void
      {
         super.setTextFlow(param1);
         this.initForInputIfHaveFocus();
      }
      
      private function initForInputIfHaveFocus() : void
      {
         var _loc1_:ISelectionManager = null;
         var _loc2_:ContainerController = null;
         if(editingMode != EditingMode.READ_ONLY && this.textDisplay.getFocus() == this.textDisplay)
         {
            _loc1_ = beginInteraction();
            _loc2_ = getTextFlow().flowComposer.getControllerAt(0);
            _loc2_.requiredFocusInHandler(null);
            if(!preserveSelectionOnSetText)
            {
               _loc1_.selectRange(0,0);
            }
            endInteraction();
         }
      }
      
      mx_internal function applyFormatOperation(param1:ITextLayoutFormat, param2:ITextLayoutFormat, param3:ITextLayoutFormat, param4:int, param5:int) : Boolean
      {
         var _loc6_:TextFlow = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(param4 == -1 || param5 == -1)
         {
            return true;
         }
         _loc6_ = this.getTextFlowWithComposer();
         var _loc7_:SelectionState = new SelectionState(_loc6_,param4,param5);
         var _loc8_:IEditManager = _loc6_.interactionManager as IEditManager;
         if(_loc8_)
         {
            _loc11_ = this.getAbsoluteStart(param4,param5);
            _loc12_ = this.getAbsoluteEnd(param4,param5);
            if(_loc8_.absoluteStart == _loc11_ && _loc8_.absoluteEnd == _loc12_)
            {
               _loc7_.selectionManagerOperationState = true;
            }
         }
         var _loc9_:ApplyFormatOperation = new ApplyFormatOperation(_loc7_,param1,param2,param3);
         var _loc10_:Boolean = _loc9_.doOperation();
         if(_loc10_)
         {
            _loc6_.normalize();
            _loc6_.flowComposer.updateAllControllers();
         }
         return _loc10_;
      }
      
      mx_internal function getCommonCharacterFormat(param1:int, param2:int) : ITextLayoutFormat
      {
         var _loc4_:TextRange = null;
         var _loc5_:ElementRange = null;
         if(param1 == -1 || param2 == -1)
         {
            return null;
         }
         var _loc3_:TextFlow = this.getTextFlowWithComposer();
         if(_loc3_.interactionManager)
         {
            _loc4_ = new TextRange(_loc3_,param1,param2);
            return _loc3_.interactionManager.getCommonCharacterFormat(_loc4_);
         }
         _loc5_ = ElementRange.createElementRange(_loc3_,param1,param2);
         return _loc5_.getCommonCharacterFormat();
      }
      
      mx_internal function getCommonContainerFormat() : ITextLayoutFormat
      {
         var _loc1_:TextFlow = this.getTextFlowWithComposer();
         var _loc2_:ElementRange = ElementRange.createElementRange(_loc1_,0,_loc1_.textLength - 1);
         return _loc2_.getCommonContainerFormat();
      }
      
      mx_internal function getCommonParagraphFormat(param1:int, param2:int) : ITextLayoutFormat
      {
         if(param1 == -1 || param2 == -1)
         {
            return null;
         }
         var _loc3_:TextFlow = this.getTextFlowWithComposer();
         var _loc4_:ElementRange = ElementRange.createElementRange(_loc3_,param1,param2);
         return _loc4_.getCommonParagraphFormat();
      }
      
      mx_internal function insertTextOperation(param1:String, param2:int, param3:int) : Boolean
      {
         var _loc11_:int = 0;
         var _loc12_:SelectionState = null;
         var _loc13_:SelectionEvent = null;
         if(param2 == -1 || param3 == -1)
         {
            return false;
         }
         var _loc4_:TextFlow = this.getTextFlowWithComposer();
         var _loc5_:int = this.getAbsoluteStart(param2,param3);
         var _loc6_:int = this.getAbsoluteEnd(param2,param3);
         var _loc7_:ITextLayoutFormat = this.getCommonCharacterFormat(_loc5_,_loc5_);
         var _loc8_:SelectionState = new SelectionState(_loc4_,_loc5_,_loc6_,_loc7_);
         _loc8_.selectionManagerOperationState = true;
         var _loc9_:InsertTextOperation = new InsertTextOperation(_loc8_,param1);
         var _loc10_:Boolean = _loc9_.doOperation();
         if(_loc10_)
         {
            _loc4_.normalize();
            _loc4_.flowComposer.updateAllControllers();
            _loc11_ = _loc6_ - (_loc6_ - _loc5_) + param1.length;
            _loc12_ = new SelectionState(_loc4_,_loc11_,_loc11_);
            _loc13_ = new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,_loc12_);
            _loc4_.dispatchEvent(_loc13_);
            scrollToRange(_loc11_,_loc11_);
         }
         return _loc10_;
      }
      
      mx_internal function getTextFlowWithComposer() : TextFlow
      {
         var _loc2_:IEditManager = null;
         var _loc1_:TextFlow = getTextFlow();
         if(composeState != TextContainerManager.COMPOSE_COMPOSER)
         {
            convertToTextFlowWithComposer();
         }
         else if(_loc1_.interactionManager)
         {
            _loc2_ = _loc1_.interactionManager as IEditManager;
            if(_loc2_ && _loc2_.delayUpdates)
            {
               _loc2_.updateAllControllers();
            }
            else
            {
               _loc1_.interactionManager.flushPendingOperations();
            }
         }
         return _loc1_;
      }
      
      private function getAbsoluteStart(param1:int, param2:int) : int
      {
         return param1 < param2?int(param1):int(param2);
      }
      
      private function getAbsoluteEnd(param1:int, param2:int) : int
      {
         return param1 > param2?int(param1):int(param2);
      }
      
      override public function focusInHandler(param1:FocusEvent) : void
      {
         this.textDisplay.focusInHandler(param1);
         super.focusInHandler(param1);
      }
      
      override public function focusOutHandler(param1:FocusEvent) : void
      {
         this.textDisplay.focusOutHandler(param1);
         super.focusOutHandler(param1);
      }
      
      override public function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyboardEvent = null;
         this.textDisplay.keyDownHandler(param1);
         if(!param1.isDefaultPrevented())
         {
            _loc2_ = KeyboardEvent(param1.clone());
            super.keyDownHandler(_loc2_);
            if(_loc2_.isDefaultPrevented())
            {
               param1.preventDefault();
            }
         }
      }
      
      override public function keyUpHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:KeyboardEvent = null;
         if(!param1.isDefaultPrevented())
         {
            _loc2_ = KeyboardEvent(param1.clone());
            super.keyUpHandler(_loc2_);
            if(_loc2_.isDefaultPrevented())
            {
               param1.preventDefault();
            }
         }
      }
      
      override public function mouseDownHandler(param1:MouseEvent) : void
      {
         this.textDisplay.mouseDownHandler(param1);
         super.mouseDownHandler(param1);
      }
      
      override public function activateHandler(param1:Event) : void
      {
         var _loc2_:SelectionManager = null;
         if(param1.type == Event.ACTIVATE)
         {
            return;
         }
         super.activateHandler(param1);
         if(editingMode != EditingMode.READ_ONLY && this.textDisplay.getFocus() == this.textDisplay)
         {
            _loc2_ = SelectionManager(beginInteraction());
            _loc2_.setFocus();
            endInteraction();
         }
      }
      
      override public function deactivateHandler(param1:Event) : void
      {
         if(param1.type == Event.DEACTIVATE)
         {
            return;
         }
         super.deactivateHandler(param1);
      }
      
      override public function beginMouseCapture() : void
      {
         super.beginMouseCapture();
         this.textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpSomewhereHandler);
         this.textDisplay.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.mouseMoveSomewhereHandler);
      }
      
      override public function endMouseCapture() : void
      {
         super.endMouseCapture();
         this.textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseUpSomewhereHandler);
         this.textDisplay.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_MOVE_SOMEWHERE,this.mouseMoveSomewhereHandler);
      }
      
      private function mouseUpSomewhereHandler(param1:Event) : void
      {
         mouseUpSomewhere(param1);
      }
      
      private function mouseMoveSomewhereHandler(param1:Event) : void
      {
         mouseMoveSomewhere(param1);
      }
   }
}
