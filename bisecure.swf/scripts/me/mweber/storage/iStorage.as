package me.mweber.storage
{
   import flash.filesystem.File;
   
   public interface iStorage
   {
       
      
      function getProperty(param1:String) : *;
      
      function setProperty(param1:String, param2:*) : void;
      
      function getString(param1:String) : String;
      
      function setString(param1:String, param2:String) : void;
      
      function getNumber(param1:String) : Number;
      
      function setNumber(param1:String, param2:Number) : void;
      
      function getInt(param1:String) : int;
      
      function setInt(param1:String, param2:int) : void;
      
      function getBoolean(param1:String) : Boolean;
      
      function setBoolean(param1:String, param2:Boolean) : void;
      
      function getArray(param1:String) : Array;
      
      function setArray(param1:String, param2:Array) : void;
      
      function getDate(param1:String) : Date;
      
      function setDate(param1:String, param2:Date) : void;
      
      function open(param1:File) : void;
      
      function close() : void;
      
      function load() : void;
      
      function save() : void;
   }
}
