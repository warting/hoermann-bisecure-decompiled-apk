package com.codecatalyst.util
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public function nextTick(param1:Function, param2:Array = null) : void
   {
      var execute:Function = null;
      var intervalId:int = 0;
      var callback:Function = param1;
      var parameters:Array = param2;
      execute = function():void
      {
         clearInterval(intervalId);
         callback.apply(null,parameters);
      };
      intervalId = setInterval(execute,0);
   }
}
