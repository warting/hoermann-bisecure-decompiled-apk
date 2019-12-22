package com.codecatalyst.promise
{
   import com.codecatalyst.promise.logger.LogLevel;
   import com.codecatalyst.util.nextTick;
   import com.codecatalyst.util.optionally;
   import com.codecatalyst.util.spread;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Promise
   {
      
      private static const adapters:Array = [];
      
      private static const loggers:Array = [];
       
      
      private var resolver:Resolver;
      
      public function Promise(param1:Resolver)
      {
         super();
         this.resolver = param1;
      }
      
      public static function when(param1:*) : Promise
      {
         var _loc2_:Function = null;
         var _loc3_:Deferred = null;
         var _loc4_:Promise = null;
         for each(_loc2_ in adapters)
         {
            _loc4_ = _loc2_(param1) as Promise;
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         _loc3_ = new Deferred();
         _loc3_.resolve(param1);
         return _loc3_.promise;
      }
      
      public static function isThenable(param1:*) : Boolean
      {
         return param1 != null && (param1 is Object || param1 is Function) && "then" in param1 && param1.then is Function;
      }
      
      public static function all(param1:*) : Promise
      {
         var process:Function = null;
         var promisesOrValues:* = param1;
         process = function(param1:Array):Promise
         {
            var results:Array = null;
            var deferred:Deferred = null;
            var index:uint = 0;
            var promisesOrValues:Array = param1;
            var remainingToResolve:uint = promisesOrValues.length;
            results = new Array(promisesOrValues.length);
            deferred = new Deferred();
            if(remainingToResolve > 0)
            {
               var resolve:Function = function(param1:*, param2:uint):Promise
               {
                  var fulfill:Function = null;
                  var item:* = param1;
                  var index:uint = param2;
                  fulfill = function(param1:*):*
                  {
                     results[index] = param1;
                     if(--remainingToResolve == 0)
                     {
                        deferred.resolve(results);
                     }
                     return param1;
                  };
                  return Promise.when(item).then(fulfill,deferred.reject);
               };
               index = 0;
               while(index < promisesOrValues.length)
               {
                  if(index in promisesOrValues)
                  {
                     resolve(promisesOrValues[index],index);
                  }
                  else
                  {
                     remainingToResolve--;
                  }
                  index++;
               }
            }
            else
            {
               deferred.resolve(results);
            }
            return deferred.promise;
         };
         if(!(promisesOrValues is Array || Promise.isThenable(promisesOrValues)))
         {
            throw new Error("Invalid parameter: expected an Array or Promise of an Array.");
         }
         return Promise.when(promisesOrValues).then(process);
      }
      
      public static function any(param1:*) : Promise
      {
         var extract:Function = null;
         var transform:Function = null;
         var promisesOrValues:* = param1;
         extract = function(param1:Array):*
         {
            return param1[0];
         };
         transform = function(param1:*):void
         {
            if(param1 is Error && param1.message == "Too few Promises were resolved.")
            {
               throw new Error("No Promises were resolved.");
            }
            throw param1;
         };
         if(!(promisesOrValues is Array || Promise.isThenable(promisesOrValues)))
         {
            throw new Error("Invalid parameter: expected an Array or Promise of an Array.");
         }
         return Promise.some(promisesOrValues,1).then(extract,transform);
      }
      
      public static function some(param1:*, param2:uint) : Promise
      {
         var process:Function = null;
         var promisesOrValues:* = param1;
         var howMany:uint = param2;
         process = function(param1:Array):Promise
         {
            var values:Array = null;
            var remainingToResolve:uint = 0;
            var remainingToReject:uint = 0;
            var deferred:Deferred = null;
            var index:uint = 0;
            var promisesOrValues:Array = param1;
            values = [];
            remainingToResolve = howMany;
            remainingToReject = promisesOrValues.length - remainingToResolve + 1;
            deferred = new Deferred();
            if(promisesOrValues.length < howMany)
            {
               deferred.reject(new Error("Too few Promises were resolved."));
            }
            else
            {
               var onResolve:Function = function(param1:*):*
               {
                  if(remainingToResolve > 0)
                  {
                     values.push(param1);
                  }
                  remainingToResolve--;
                  if(remainingToResolve == 0)
                  {
                     deferred.resolve(values);
                  }
                  return param1;
               };
               var onReject:Function = function(param1:*):*
               {
                  remainingToReject--;
                  if(remainingToReject == 0)
                  {
                     deferred.reject(new Error("Too few Promises were resolved."));
                  }
                  throw param1;
               };
               index = 0;
               while(index < promisesOrValues.length)
               {
                  if(index in promisesOrValues)
                  {
                     Promise.when(promisesOrValues[index]).then(onResolve,onReject);
                  }
                  index++;
               }
            }
            return deferred.promise;
         };
         if(!(promisesOrValues is Array || Promise.isThenable(promisesOrValues)))
         {
            throw new Error("Invalid parameter: expected an Array or Promise of an Array.");
         }
         return Promise.when(promisesOrValues).then(process);
      }
      
      public static function delay(param1:*, param2:Number) : Promise
      {
         var deferred:Deferred = null;
         var timerCompleteHandler:Function = null;
         var timer:Timer = null;
         var promiseOrValue:* = param1;
         var milliseconds:Number = param2;
         timerCompleteHandler = function():void
         {
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
            deferred.resolve(promiseOrValue);
         };
         deferred = new Deferred();
         timer = new Timer(Math.max(milliseconds,0),1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
         timer.start();
         return deferred.promise;
      }
      
      public static function timeout(param1:*, param2:Number) : Promise
      {
         var deferred:Deferred = null;
         var timerCompleteHandler:Function = null;
         var timer:Timer = null;
         var promiseOrValue:* = param1;
         var milliseconds:Number = param2;
         timerCompleteHandler = function():void
         {
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
            deferred.reject(new TimeoutError());
         };
         deferred = new Deferred();
         timer = new Timer(Math.max(milliseconds,0),1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
         timer.start();
         Promise.when(promiseOrValue).then(deferred.resolve,deferred.reject);
         return deferred.promise;
      }
      
      public static function map(param1:*, param2:Function) : Promise
      {
         var process:Function = null;
         var promisesOrValues:* = param1;
         var mapFunction:Function = param2;
         process = function(param1:Array):Promise
         {
            var results:Array = null;
            var deferred:Deferred = null;
            var index:uint = 0;
            var promisesOrValues:Array = param1;
            var remainingToResolve:uint = promisesOrValues.length;
            results = new Array(promisesOrValues.length);
            deferred = new Deferred();
            if(remainingToResolve > 0)
            {
               var resolve:Function = function(param1:*, param2:uint):Promise
               {
                  var transform:Function = null;
                  var fulfill:Function = null;
                  var item:* = param1;
                  var index:uint = param2;
                  transform = function(param1:*):*
                  {
                     return optionally(mapFunction,[param1,index,results]);
                  };
                  fulfill = function(param1:*):void
                  {
                     results[index] = param1;
                     if(--remainingToResolve == 0)
                     {
                        deferred.resolve(results);
                     }
                  };
                  return Promise.when(item).then(transform).then(fulfill,deferred.reject);
               };
               index = 0;
               while(index < promisesOrValues.length)
               {
                  if(index in promisesOrValues)
                  {
                     resolve(promisesOrValues[index],index);
                  }
                  else
                  {
                     remainingToResolve--;
                  }
                  index++;
               }
            }
            else
            {
               deferred.resolve(results);
            }
            return deferred.promise;
         };
         if(!(promisesOrValues is Array || Promise.isThenable(promisesOrValues)))
         {
            throw new Error("Invalid parameter: expected an Array or Promise of an Array.");
         }
         if(!(mapFunction is Function))
         {
            throw new Error("Invalid parameter: expected a function.");
         }
         return Promise.when(promisesOrValues).then(process);
      }
      
      public static function reduce(param1:*, param2:Function, ... rest) : Promise
      {
         var process:Function = null;
         var promisesOrValues:* = param1;
         var reduceFunction:Function = param2;
         var reduceArray:Function = function(param1:Array, param2:Function, ... rest):*
         {
            var _loc4_:uint = 0;
            var _loc5_:uint = param1.length;
            var _loc6_:* = null;
            if(rest.length == 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  if(_loc4_ in param1)
                  {
                     _loc6_ = param1[_loc4_];
                     _loc4_++;
                     break;
                  }
                  _loc4_++;
               }
            }
            else
            {
               _loc6_ = rest[0];
            }
            while(_loc4_ < _loc5_)
            {
               if(_loc4_ in param1)
               {
                  _loc6_ = param2(_loc6_,param1[_loc4_],_loc4_,param1);
                  _loc4_++;
               }
            }
            return _loc6_;
         };
         process = function(param1:Array):Promise
         {
            var reduceFnWrapper:Function = null;
            var initialValue:* = undefined;
            var promisesOrValues:Array = param1;
            reduceFnWrapper = function(param1:*, param2:*, param3:uint, param4:Array):Promise
            {
               var execute:Function = null;
               var previousValueOrPromise:* = param1;
               var currentValueOrPromise:* = param2;
               var currentIndex:uint = param3;
               var array:Array = param4;
               execute = function(param1:*, param2:*):*
               {
                  return optionally(reduceFunction,[param1,param2,currentIndex,array]);
               };
               return Promise.all([previousValueOrPromise,currentValueOrPromise]).then(spread(execute));
            };
            if(rest.length > 0)
            {
               initialValue = rest[0];
               return reduceArray(promisesOrValues,reduceFnWrapper,initialValue);
            }
            return reduceArray(promisesOrValues,reduceFnWrapper);
         };
         if(!(promisesOrValues is Array || Promise.isThenable(promisesOrValues)))
         {
            throw new Error("Invalid parameter: expected an Array or Promise of an Array.");
         }
         if(!(reduceFunction is Function))
         {
            throw new Error("Invalid parameter: expected a function.");
         }
         return Promise.when(promisesOrValues).then(process);
      }
      
      public static function log(param1:String, param2:int, param3:String, ... rest) : void
      {
         var _loc6_:Function = null;
         var _loc5_:Array = [param1,param2,param3].concat(rest);
         for each(_loc6_ in loggers)
         {
            _loc6_.apply(_loc6_,_loc5_);
         }
      }
      
      public static function registerAdapter(param1:Function) : void
      {
         if(adapters.indexOf(param1) == -1)
         {
            adapters.push(param1);
         }
      }
      
      public static function unregisterAdapter(param1:Function) : void
      {
         var _loc2_:int = adapters.indexOf(param1);
         if(_loc2_ > -1)
         {
            adapters.splice(_loc2_,1);
         }
      }
      
      public static function registerLogger(param1:Function) : void
      {
         if(loggers.indexOf(param1) == -1)
         {
            loggers.push(param1);
         }
      }
      
      public static function unregisterLogger(param1:Function) : void
      {
         var _loc2_:int = loggers.indexOf(param1);
         if(_loc2_ > -1)
         {
            loggers.splice(_loc2_,1);
         }
      }
      
      private static function scheduleRethrowError(param1:*) : void
      {
         nextTick(rethrowError,[param1]);
      }
      
      private static function rethrowError(param1:*) : void
      {
         if(param1 is Error)
         {
            throw param1.getStackTrace() + "\nRethrown from:";
         }
         throw param1;
      }
      
      public function then(param1:Function = null, param2:Function = null) : Promise
      {
         return this.resolver.then(param1,param2);
      }
      
      public function otherwise(param1:Function) : Promise
      {
         return this.resolver.then(null,param1);
      }
      
      public function always(param1:Function) : Promise
      {
         var onFulfilled:Function = null;
         var onRejected:Function = null;
         var onCompleted:Function = param1;
         onFulfilled = function(param1:*):*
         {
            var value:* = param1;
            try
            {
               onCompleted();
            }
            catch(error:Error)
            {
               scheduleRethrowError(error);
            }
            return value;
         };
         onRejected = function(param1:*):*
         {
            var reason:* = param1;
            try
            {
               onCompleted();
            }
            catch(error:Error)
            {
               scheduleRethrowError(error);
            }
            throw reason;
         };
         return this.resolver.then(onFulfilled,onRejected);
      }
      
      public function done() : void
      {
         this.resolver.then(null,scheduleRethrowError);
      }
      
      public function cancel(param1:*) : void
      {
         this.resolver.reject(new CancellationError(param1));
      }
      
      public function log(param1:String, param2:String = null) : Promise
      {
         var onFulfilled:Function = null;
         var onRejected:Function = null;
         var category:String = param1;
         var identifier:String = param2;
         onFulfilled = function(param1:*):*
         {
            var value:* = param1;
            try
            {
               Promise.log(category,LogLevel.DEBUG,(identifier || "Promise") + " resolved with value: " + value);
            }
            catch(error:Error)
            {
               scheduleRethrowError(error);
            }
            return value;
         };
         onRejected = function(param1:*):*
         {
            var reason:* = param1;
            try
            {
               Promise.log(category,LogLevel.ERROR,(identifier || "Promise") + " rejected with reason: " + reason);
            }
            catch(error:Error)
            {
               scheduleRethrowError(error);
            }
            throw reason;
         };
         return this.resolver.then(onFulfilled,onRejected);
      }
   }
}
