package flashx.textLayout.elements
{
   public class TableFormattedElement extends ContainerFormattedElement
   {
       
      
      private var _table:TableElement;
      
      public function TableFormattedElement()
      {
         super();
      }
      
      public function getTable() : TableElement
      {
         var _loc1_:FlowGroupElement = this;
         while(_loc1_.parent != null && !(_loc1_.parent is TableElement))
         {
            _loc1_ = _loc1_.parent;
         }
         return _loc1_.parent as TableElement;
      }
      
      public function get table() : TableElement
      {
         if(this._table)
         {
            return this._table;
         }
         var _loc1_:FlowGroupElement = this;
         while(_loc1_.parent != null && !(_loc1_.parent is TableElement))
         {
            _loc1_ = _loc1_.parent;
         }
         this._table = _loc1_.parent as TableElement;
         return this._table;
      }
      
      public function set table(param1:TableElement) : void
      {
         this._table = param1;
      }
   }
}
