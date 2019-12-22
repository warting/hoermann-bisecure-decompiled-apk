package com.codecatalyst.promise
{
   import com.codecatalyst.util.optionally;
   
   class Consequence
   {
       
      
      private var resolver:Resolver = null;
      
      private var onFulfilled:Function = null;
      
      private var onRejected:Function = null;
      
      function Consequence(param1:Function, param2:Function)
      {
         super();
         this.onFulfilled = param1;
         this.onRejected = param2;
         this.resolver = new Resolver();
      }
      
      public function get promise() : Promise
      {
         return this.resolver.promise;
      }
      
      public function trigger(param1:String, param2:*) : void
      {
         switch(param1)
         {
            case CompletionAction.FULFILL:
               this.propagate(param2,this.onFulfilled,this.resolver.resolve);
               break;
            case CompletionAction.REJECT:
               this.propagate(param2,this.onRejected,this.resolver.reject);
         }
      }
      
      private function propagate(param1:*, param2:Function, param3:Function) : void
      {
         if(param2 is Function)
         {
            this.schedule(this.transform,[param1,param2]);
         }
         else
         {
            param3.call(this.resolver,param1);
         }
      }
      
      private function transform(param1:*, param2:Function) : void
      {
         var value:* = param1;
         var callback:Function = param2;
         try
         {
            this.resolver.resolve(optionally(callback,[value]));
            return;
         }
         catch(error:*)
         {
            resolver.reject(error);
            return;
         }
      }
      
      private function schedule(param1:Function, param2:Array = null) : void
      {
         CallbackQueue.instance.schedule(param1,param2);
      }
   }
}

import flash.utils.clearInterval;
import flash.utils.setInterval;

class CallbackQueue
{
   
   public static const instance:CallbackQueue = new CallbackQueue();
    
   
   protected const queuedCallbacks:Array = new Array(10000);
   
   protected var intervalId:int = 0;
   
   protected var queuedCallbackCount:uint = 0;
   
   function CallbackQueue()
   {
      super();
   }
   
   public function schedule(param1:Function, param2:Array = null) : void
   {
      var _loc3_:* = this.queuedCallbackCount++;
      this.queuedCallbacks[_loc3_] = new Callback(param1,param2);
      if(this.queuedCallbackCount == 1)
      {
         this.intervalId = setInterval(this.execute,0);
      }
   }
   
   protected function execute() : void
   {
      clearInterval(this.intervalId);
      var _loc1_:uint = 0;
      while(_loc1_ < this.queuedCallbackCount)
      {
         (this.queuedCallbacks[_loc1_] as Callback).execute();
         this.queuedCallbacks[_loc1_] = null;
         _loc1_++;
      }
      this.queuedCallbackCount = 0;
   }
}

class Callback
{
    
   
   protected var closure:Function;
   
   protected var parameters:Array;
   
   function Callback(param1:Function, param2:Array = null)
   {
      super();
      this.closure = param1;
      this.parameters = param2;
   }
   
   public function execute() : void
   {
      this.closure.apply(null,this.parameters);
   }
}
