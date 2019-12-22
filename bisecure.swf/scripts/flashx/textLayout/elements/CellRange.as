package flashx.textLayout.elements
{
   public class CellRange
   {
       
      
      private var _table:TableElement;
      
      private var _anchorCoords:CellCoordinates;
      
      private var _activeCoords:CellCoordinates;
      
      public function CellRange(param1:TableElement, param2:CellCoordinates, param3:CellCoordinates)
      {
         super();
         this._table = param1;
         this._anchorCoords = this.clampToRange(param2);
         this._activeCoords = this.clampToRange(param3);
      }
      
      private function clampToRange(param1:CellCoordinates) : CellCoordinates
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1.row < 0)
         {
            param1.row = 0;
         }
         if(param1.column < 0)
         {
            param1.column = 0;
         }
         if(this._table == null)
         {
            return param1;
         }
         if(param1.row >= this._table.numRows)
         {
            param1.row = this._table.numRows - 1;
         }
         if(param1.column >= this._table.numColumns)
         {
            param1.column = this._table.numColumns - 1;
         }
         return param1;
      }
      
      public function updateRange(param1:CellCoordinates, param2:CellCoordinates) : Boolean
      {
         this.clampToRange(param1);
         this.clampToRange(param2);
         if(!CellCoordinates.areEqual(this._anchorCoords,param1) || !CellCoordinates.areEqual(this._activeCoords,param2))
         {
            this._anchorCoords = param1;
            this._activeCoords = param2;
            return true;
         }
         return false;
      }
      
      public function get table() : TableElement
      {
         return this._table;
      }
      
      public function set table(param1:TableElement) : void
      {
         this._table = param1;
      }
      
      public function get anchorCoordinates() : CellCoordinates
      {
         return this._anchorCoords;
      }
      
      public function set anchorCoordinates(param1:CellCoordinates) : void
      {
         this._anchorCoords = param1;
      }
      
      public function get activeCoordinates() : CellCoordinates
      {
         return this._activeCoords;
      }
      
      public function set activeCoordinates(param1:CellCoordinates) : void
      {
         this._activeCoords = param1;
      }
   }
}
