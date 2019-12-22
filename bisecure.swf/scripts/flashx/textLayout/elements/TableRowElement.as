package flashx.textLayout.elements
{
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TableRowElement extends TableFormattedElement
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var height:Number;
      
      public var rowIndex:int;
      
      public var parcelIndex:int;
      
      public var columnIndex:Number = 0;
      
      public var iMaxRowDepth:Number = 0;
      
      public var beyondParcel:Boolean = false;
      
      public var composedHeight:Number = 0;
      
      public var totalHeight:Number = 0;
      
      public var isMaxHeight:Boolean = false;
      
      public function TableRowElement(param1:ITextLayoutFormat = null)
      {
         super();
         if(param1)
         {
            this.format = param1;
         }
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "tr";
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return param1 is TableCellElement;
      }
      
      override tlf_internal function modelChanged(param1:String, param2:FlowElement, param3:int, param4:int, param5:Boolean = true, param6:Boolean = true) : void
      {
         super.modelChanged(param1,param2,param3,param4,param5,param6);
      }
      
      public function getCells() : Vector.<TableCellElement>
      {
         var _loc1_:TableElement = getTable();
         if(!_loc1_)
         {
            return null;
         }
         return _loc1_.getCellsForRow(this);
      }
      
      public function get cells() : Array
      {
         var _loc1_:TableElement = getTable();
         if(!_loc1_)
         {
            return null;
         }
         return _loc1_.getCellsForRowArray(this);
      }
      
      public function get numCells() : int
      {
         var _loc1_:TableElement = getTable();
         if(!_loc1_)
         {
            return 0;
         }
         return _loc1_.getCellsForRow(this).length;
      }
      
      public function getCellAt(param1:int) : TableCellElement
      {
         var _loc2_:Vector.<TableCellElement> = this.getCells();
         if(!_loc2_ || param1 < 0 || param1 >= _loc2_.length)
         {
            return null;
         }
         return _loc2_[param1];
      }
      
      public function addCell(param1:TableCellElement) : TableCellElement
      {
         var _loc2_:TableElement = getTable();
         var _loc3_:int = numChildren;
         if(!_loc2_)
         {
            throw new Error("Table must be set");
         }
         param1.rowIndex = this.rowIndex;
         if(param1.colIndex == -1)
         {
            param1.colIndex = _loc3_;
         }
         this.cells.push(param1);
         return param1;
      }
      
      public function addCellAt(param1:int) : TableCellElement
      {
         throw new Error("Add cell at is not implemented");
      }
      
      public function getColumnCount() : int
      {
         return int(this.numCells) || int(numChildren);
      }
   }
}
