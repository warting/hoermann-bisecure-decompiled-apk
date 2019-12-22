package spark.components.supportClasses
{
   import flash.events.IEventDispatcher;
   
   public interface IDataProviderEnhance extends IEventDispatcher
   {
       
      
      function get isFirstRow() : Boolean;
      
      function get isLastRow() : Boolean;
      
      function findRowIndex(param1:String, param2:String, param3:int = 0, param4:String = "exact") : int;
      
      function findRowIndices(param1:String, param2:Array, param3:String = "exact") : Array;
      
      function moveIndexFirstRow() : void;
      
      function moveIndexLastRow() : void;
      
      function moveIndexNextRow() : void;
      
      function moveIndexPreviousRow() : void;
      
      function moveIndexFindRow(param1:String, param2:String, param3:int = 0, param4:String = "exact") : Boolean;
   }
}
