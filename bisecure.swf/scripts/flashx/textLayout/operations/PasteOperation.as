package flashx.textLayout.operations
{
   import flashx.textLayout.conversion.ConverterBase;
   import flashx.textLayout.edit.ModelEdit;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.edit.TextFlowEdit;
   import flashx.textLayout.edit.TextScrap;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class PasteOperation extends FlowTextOperation
   {
       
      
      private var _textScrap:TextScrap;
      
      private var _numCharsAdded:int = 0;
      
      private var _deleteTextOperation:DeleteTextOperation;
      
      private var _applyParagraphSettings:Array;
      
      private var _pointFormat:ITextLayoutFormat;
      
      private var _applyPointFormat:ApplyFormatOperation;
      
      public function PasteOperation(param1:SelectionState, param2:TextScrap)
      {
         this._pointFormat = param1.pointFormat;
         super(param1);
         this._textScrap = param2;
      }
      
      override public function doOperation() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:FlowLeafElement = null;
         var _loc5_:ParagraphElement = null;
         if(this._textScrap != null)
         {
            if(absoluteStart != absoluteEnd)
            {
               this._deleteTextOperation = new DeleteTextOperation(originalSelectionState);
               this._deleteTextOperation.doOperation();
            }
            _loc1_ = false;
            _loc2_ = this._textScrap.isPlainText();
            if(!_loc2_)
            {
               _loc4_ = textFlow.findLeaf(absoluteStart);
               _loc5_ = _loc4_.getParagraph();
               if(_loc5_.textLength == 1)
               {
                  _loc1_ = true;
               }
            }
            _loc3_ = TextFlowEdit.insertTextScrap(textFlow,absoluteStart,this._textScrap,_loc2_);
            if(textFlow.interactionManager)
            {
               textFlow.interactionManager.notifyInsertOrDelete(absoluteStart,_loc3_ - absoluteStart);
            }
            this._numCharsAdded = _loc3_ - absoluteStart;
            if(_loc1_)
            {
               this.applyPreserveSettings();
            }
            else if(this._pointFormat && _loc2_)
            {
               this._applyPointFormat = new ApplyFormatOperation(new SelectionState(textFlow,absoluteStart,absoluteStart + this._numCharsAdded),this._pointFormat,null,null);
               this._applyPointFormat.doOperation();
            }
         }
         return true;
      }
      
      private function applyPreserveSettings() : void
      {
         var _loc5_:ParagraphElement = null;
         var _loc6_:ApplyFormatToElementOperation = null;
         var _loc1_:TextFlow = this._textScrap.textFlow;
         var _loc2_:ParagraphElement = _loc1_.getFirstLeaf().getParagraph();
         this._applyParagraphSettings = [];
         var _loc3_:TextLayoutFormat = new TextLayoutFormat(_loc2_.format);
         _loc3_.setStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE,undefined);
         var _loc4_:ApplyFormatToElementOperation = new ApplyFormatToElementOperation(originalSelectionState,textFlow.findLeaf(absoluteStart).getParagraph(),_loc3_);
         _loc4_.doOperation();
         this._applyParagraphSettings.push(_loc4_);
         if(_loc1_.numChildren > 1)
         {
            _loc5_ = _loc1_.getLastLeaf().getParagraph();
            _loc3_ = new TextLayoutFormat(_loc5_.format);
            _loc3_.setStyle(ConverterBase.MERGE_TO_NEXT_ON_PASTE,undefined);
            _loc6_ = new ApplyFormatToElementOperation(originalSelectionState,textFlow.findLeaf(absoluteStart + _loc1_.textLength - 1).getParagraph(),_loc3_);
            _loc6_.doOperation();
            this._applyParagraphSettings.push(_loc6_);
         }
      }
      
      override public function undo() : SelectionState
      {
         var _loc1_:int = 0;
         if(this._textScrap != null)
         {
            if(this._applyPointFormat)
            {
               this._applyPointFormat.undo();
            }
            if(this._applyParagraphSettings)
            {
               _loc1_ = this._applyParagraphSettings.length - 1;
               while(_loc1_ >= 0)
               {
                  this._applyParagraphSettings[_loc1_].undo();
                  _loc1_--;
               }
            }
            ModelEdit.deleteText(textFlow,absoluteStart,absoluteStart + this._numCharsAdded,false);
            if(this._deleteTextOperation)
            {
               this._deleteTextOperation.undo();
            }
         }
         return originalSelectionState;
      }
      
      override public function redo() : SelectionState
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._textScrap != null)
         {
            if(this._deleteTextOperation)
            {
               this._deleteTextOperation.redo();
            }
            _loc1_ = TextFlowEdit.insertTextScrap(textFlow,absoluteStart,this._textScrap,this._textScrap.isPlainText());
            if(textFlow.interactionManager)
            {
               textFlow.interactionManager.notifyInsertOrDelete(absoluteStart,_loc1_ - absoluteStart);
            }
            if(this._applyParagraphSettings)
            {
               _loc2_ = this._applyParagraphSettings.length - 1;
               while(_loc2_ >= 0)
               {
                  this._applyParagraphSettings[_loc2_].redo();
                  _loc2_--;
               }
            }
            if(this._applyPointFormat)
            {
               this._applyPointFormat.redo();
            }
         }
         return new SelectionState(textFlow,absoluteStart + this._numCharsAdded,absoluteStart + this._numCharsAdded,null);
      }
      
      public function get textScrap() : TextScrap
      {
         return this._textScrap;
      }
      
      public function set textScrap(param1:TextScrap) : void
      {
         this._textScrap = param1;
      }
   }
}
