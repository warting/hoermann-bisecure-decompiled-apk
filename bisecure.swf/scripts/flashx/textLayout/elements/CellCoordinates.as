package flashx.textLayout.elements
{
   public class CellCoordinates
   {
       
      
      private var _column:int;
      
      private var _row:int;
      
      public var table:TableElement;
      
      public function CellCoordinates(param1:int, param2:int, param3:TableElement = null)
      {
         super();
         this._row = param1;
         this._column = param2;
         this.table = param3;
      }
      
      public static function areEqual(param1:CellCoordinates, param2:CellCoordinates) : Boolean
      {
         return param1.row == param2.row && param1.column == param2.column;
      }
      
      public function get column() : int
      {
         return this._column;
      }
      
      public function set column(param1:int) : void
      {
         this._column = param1;
      }
      
      public function get row() : int
      {
         return this._row;
      }
      
      public function set row(param1:int) : void
      {
         this._row = param1;
      }
      
      public function isValid() : Boolean
      {
         return this.column > -1 && this.row > -1;
      }
      
      public function clone() : CellCoordinates
      {
         return new CellCoordinates(this.row,this.column);
      }
   }
}
