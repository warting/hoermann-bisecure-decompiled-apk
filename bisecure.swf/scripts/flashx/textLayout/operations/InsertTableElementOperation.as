package flashx.textLayout.operations
{
   import flashx.textLayout.edit.ElementMark;
   import flashx.textLayout.edit.MementoList;
   import flashx.textLayout.edit.ModelEdit;
   import flashx.textLayout.edit.PointFormat;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.TableElement;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class InsertTableElementOperation extends FlowTextOperation
   {
       
      
      private var delSelOp:DeleteTextOperation;
      
      private var _table:TableElement;
      
      private var selPos:int = 0;
      
      private var _mementoList:MementoList;
      
      private var _postOpSelectionState:SelectionState;
      
      private var _listParentMarker:ElementMark;
      
      public function InsertTableElementOperation(param1:SelectionState, param2:TableElement)
      {
         super(param1);
         this._mementoList = new MementoList(param1.textFlow);
         this._table = param2;
      }
      
      override public function doOperation() : Boolean
      {
         var _loc1_:ITextLayoutFormat = null;
         var _loc5_:int = 0;
         var _loc6_:FlowGroupElement = null;
         var _loc7_:FlowLeafElement = null;
         var _loc8_:PointFormat = null;
         this.selPos = absoluteStart;
         if(absoluteStart != absoluteEnd)
         {
            _loc7_ = textFlow.findLeaf(absoluteStart);
            _loc8_ = new PointFormat(textFlow.findLeaf(absoluteStart).format);
            this._mementoList.push(ModelEdit.deleteText(textFlow,absoluteStart,absoluteEnd,true));
            _loc1_ = _loc8_;
         }
         else
         {
            _loc1_ = originalSelectionState.pointFormat;
         }
         var _loc2_:FlowGroupElement = textFlow;
         var _loc3_:int = absoluteStart;
         var _loc4_:int = 0;
         if(_loc3_ >= 0)
         {
            _loc4_ = _loc2_.findChildIndexAtPosition(_loc3_);
            _loc6_ = _loc2_.getChildAt(_loc4_) as FlowGroupElement;
            this._mementoList.push(ModelEdit.splitElement(textFlow,_loc6_,_loc3_ - _loc6_.parentRelativeStart));
         }
         if(_loc3_ >= _loc2_.textLength - 1)
         {
            _loc5_ = _loc2_.numChildren;
         }
         else
         {
            _loc5_ = _loc4_ + 1;
         }
         if(_loc4_ == _loc2_.numChildren)
         {
            _loc6_ = _loc2_.getChildAt(_loc2_.numChildren - 1) as FlowGroupElement;
            this._mementoList.push(ModelEdit.addElement(textFlow,this._table,_loc2_,_loc2_.numChildren));
         }
         else
         {
            this._mementoList.push(ModelEdit.addElement(textFlow,this._table,_loc2_,_loc5_));
         }
         if(originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
         {
            textFlow.normalize();
            this._postOpSelectionState = new SelectionState(textFlow,this._table.getAbsoluteStart(),this._table.getAbsoluteStart() + this._table.textLength - 1);
            textFlow.interactionManager.setSelectionState(this._postOpSelectionState);
         }
         return true;
      }
      
      override public function undo() : SelectionState
      {
         this._mementoList.undo();
         return originalSelectionState;
      }
      
      override public function redo() : SelectionState
      {
         this._mementoList.redo();
         return this._postOpSelectionState;
      }
   }
}
