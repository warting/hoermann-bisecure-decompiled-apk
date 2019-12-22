package flashx.textLayout.elements
{
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   public final class TableColElement extends TableFormattedElement
   {
       
      
      public var x:Number;
      
      public var colIndex:int;
      
      public function TableColElement(param1:ITextLayoutFormat = null)
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
         return "col";
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return false;
      }
      
      override tlf_internal function modelChanged(param1:String, param2:FlowElement, param3:int, param4:int, param5:Boolean = true, param6:Boolean = true) : void
      {
         super.modelChanged(param1,param2,param3,param4,param5,param6);
      }
      
      public function get cells() : Vector.<TableCellElement>
      {
         if(!table)
         {
            return null;
         }
         return table.getCellsForColumn(this);
      }
      
      public function get numCells() : int
      {
         if(!table)
         {
            return 0;
         }
         return table.getCellsForColumn(this).length;
      }
   }
}
