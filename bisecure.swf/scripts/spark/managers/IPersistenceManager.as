package spark.managers
{
   public interface IPersistenceManager
   {
       
      
      function clear() : void;
      
      function save() : Boolean;
      
      function load() : Boolean;
      
      function getProperty(param1:String) : Object;
      
      function setProperty(param1:String, param2:Object) : void;
   }
}
