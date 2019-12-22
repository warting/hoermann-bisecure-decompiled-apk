package com.codecatalyst.util
{
   public function optionally(param1:Function, param2:Array, param3:int = 0) : *
   {
      var parameterCount:int = 0;
      var targetFunction:Function = param1;
      var parameters:Array = param2;
      var requiredParameters:int = param3;
      try
      {
         return targetFunction.apply(null,parameters);
      }
      catch(e:ArgumentError)
      {
         parameterCount = Math.max(targetFunction.length,requiredParameters);
         if(parameterCount < parameters.length)
         {
            return targetFunction.apply(null,parameters.slice(0,parameterCount));
         }
         throw e;
         return;
      }
   }
}
