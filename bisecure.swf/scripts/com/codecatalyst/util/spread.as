package com.codecatalyst.util
{
   public function spread(param1:Function, param2:* = null) : Function
   {
      var execute:Function = null;
      var targetFunction:Function = param1;
      var scope:* = param2;
      execute = function(param1:Array):*
      {
         return targetFunction.apply(scope,param1);
      };
      return execute;
   }
}
