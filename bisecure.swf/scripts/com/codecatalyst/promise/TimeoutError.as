package com.codecatalyst.promise
{
   public class TimeoutError extends Error
   {
       
      
      public function TimeoutError(param1:String = null)
      {
         super(!!param1?param1:"Promise timed out.");
      }
   }
}
