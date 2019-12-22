package flashx.textLayout.elements
{
   import flash.text.engine.ElementFormat;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.BaseCompose;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TableLeafElement extends FlowLeafElement
   {
       
      
      private var _table:TableElement;
      
      public function TableLeafElement(param1:TableElement)
      {
         super();
         this._table = param1;
      }
      
      override tlf_internal function createContentElement() : void
      {
         if(_blockElement)
         {
            return;
         }
         this.computedFormat;
         var _loc1_:IFlowComposer = this.getTextFlow().flowComposer;
         var _loc2_:ISWFContext = _loc1_ && _loc1_.swfContext?_loc1_.swfContext:BaseCompose.globalSWFContext;
         var _loc3_:ElementFormat = FlowLeafElement.computeElementFormatHelper(this._table.computedFormat,this._table.getParagraph(),_loc2_);
         _blockElement = new TextElement(_text,_loc3_);
         super.createContentElement();
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "table";
      }
      
      override public function get text() : String
      {
         return String.fromCharCode(22);
      }
      
      override public function getText(param1:int = 0, param2:int = -1, param3:String = "\n") : String
      {
         return this._table.getText(param1,param2,param3);
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
         super.normalizeRange(param1,param2);
      }
      
      override tlf_internal function mergeToPreviousIfPossible() : Boolean
      {
         return false;
      }
      
      override public function getNextLeaf(param1:FlowGroupElement = null) : FlowLeafElement
      {
         return this._table.getNextLeafHelper(param1,this);
      }
      
      override public function getPreviousLeaf(param1:FlowGroupElement = null) : FlowLeafElement
      {
         return this._table.getPreviousLeafHelper(param1,this);
      }
      
      override public function getCharAtPosition(param1:int) : String
      {
         return this.getText(param1,param1);
      }
      
      override public function get computedFormat() : ITextLayoutFormat
      {
         return this._table.computedFormat;
      }
      
      override public function get textLength() : int
      {
         return this._table.textLength;
      }
      
      override tlf_internal function updateAdornments(param1:TextLine, param2:String) : int
      {
         return 0;
      }
      
      override public function get parent() : FlowGroupElement
      {
         return this._table;
      }
      
      override public function getTextFlow() : TextFlow
      {
         return this._table.getTextFlow();
      }
      
      override public function getParagraph() : ParagraphElement
      {
         return this._table.getParagraph();
      }
      
      override public function getElementRelativeStart(param1:FlowElement) : int
      {
         return this._table.getElementRelativeStart(param1);
      }
   }
}
