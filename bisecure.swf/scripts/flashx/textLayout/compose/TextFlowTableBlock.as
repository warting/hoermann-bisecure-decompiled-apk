package flashx.textLayout.compose
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.text.engine.TextLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.elements.CellContainer;
   import flashx.textLayout.elements.CellCoordinates;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TableBlockContainer;
   import flashx.textLayout.elements.TableCellElement;
   import flashx.textLayout.elements.TableElement;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TextFlowTableBlock extends TextFlowLine
   {
       
      
      private var _textHeight:Number;
      
      public var parentTable:TableElement;
      
      public var blockIndex:uint = 0;
      
      private var _container:TableBlockContainer;
      
      private var _cells:Array;
      
      public function TextFlowTableBlock(param1:uint)
      {
         this.blockIndex = param1;
         this._container = new TableBlockContainer();
         super(null,null);
      }
      
      override tlf_internal function initialize(param1:ParagraphElement, param2:Number = 0, param3:Number = 0, param4:int = 0, param5:int = 0, param6:TextLine = null) : void
      {
         this._container.userData = this;
         _lineOffset = param3;
         super.initialize(param1,param2,param3,param4,param5,param6);
      }
      
      override tlf_internal function setController(param1:ContainerController, param2:int) : void
      {
         super.setController(param1,param2);
         if(param1)
         {
            controller.addComposedTableBlock(this.container);
         }
      }
      
      private function getCells() : Array
      {
         if(this._cells == null)
         {
            this._cells = [];
         }
         return this._cells;
      }
      
      public function getCellsInRange(param1:CellCoordinates, param2:CellCoordinates) : Vector.<TableCellElement>
      {
         if(!this.parentTable)
         {
            return null;
         }
         return this.parentTable.getCellsInRange(param1,param2,this);
      }
      
      public function clear() : void
      {
         this.clearCells();
      }
      
      public function clearCells() : void
      {
         this._container.removeChildren();
         this.getCells().length = 0;
      }
      
      public function addCell(param1:CellContainer) : void
      {
         var _loc2_:Array = this.getCells();
         if(_loc2_.indexOf(param1) < 0)
         {
            _loc2_.push(param1);
            this._container.addChild(param1);
         }
      }
      
      public function drawBackground(param1:*) : void
      {
      }
      
      public function get container() : TableBlockContainer
      {
         return this._container;
      }
      
      public function updateCompositionShapes() : void
      {
         var _loc2_:CellContainer = null;
         var _loc1_:Array = this.getCells();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.element.updateCompositionShapes();
         }
      }
      
      public function set height(param1:Number) : void
      {
         this._textHeight = param1;
      }
      
      override public function get height() : Number
      {
         return this._textHeight;
      }
      
      public function set width(param1:Number) : void
      {
         this._container.width = param1;
      }
      
      public function get width() : Number
      {
         return this._container.width;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = this._container.x = param1;
      }
      
      override public function get x() : Number
      {
         return this._container.x;
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = this._container.y = param1;
      }
      
      override public function get y() : Number
      {
         return this._container.y;
      }
      
      public function getTableCells() : Vector.<TableCellElement>
      {
         var _loc3_:CellContainer = null;
         var _loc1_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         var _loc2_:Array = this.getCells();
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(_loc3_.element);
         }
         return _loc1_;
      }
      
      override public function get textHeight() : Number
      {
         return this._textHeight;
      }
      
      override tlf_internal function hiliteBlockSelection(param1:Shape, param2:SelectionFormat, param3:DisplayObject, param4:int, param5:int, param6:TextFlowLine, param7:TextFlowLine) : void
      {
      }
   }
}
