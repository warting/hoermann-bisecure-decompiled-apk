package com.codecatalyst.promise
{
   class Resolver
   {
       
      
      private var _promise:Promise = null;
      
      private var consequences:Array;
      
      private var completed:Boolean = false;
      
      private var completionAction:String = null;
      
      private var completionValue;
      
      function Resolver()
      {
         this.consequences = [];
         super();
         this._promise = new Promise(this);
         this.consequences = [];
      }
      
      public function get promise() : Promise
      {
         return this._promise;
      }
      
      public function then(param1:Function = null, param2:Function = null) : Promise
      {
         var _loc3_:Consequence = new Consequence(param1,param2);
         if(this.completed)
         {
            _loc3_.trigger(this.completionAction,this.completionValue);
         }
         else
         {
            this.consequences.push(_loc3_);
         }
         return _loc3_.promise;
      }
      
      public function resolve(param1:*) : void
      {
         var thenFunction:Function = null;
         var isHandled:Boolean = false;
         var self:Resolver = null;
         var value:* = param1;
         if(this.completed)
         {
            return;
         }
         try
         {
            if(value == this.promise)
            {
               throw new TypeError("A Promise cannot be resolved with itself.");
            }
            if(value != null && (value is Object || value is Function) && "then" in value && (thenFunction = value.then) is Function)
            {
               isHandled = false;
               self = this;
               try
               {
                  thenFunction.call(value,function(param1:*):void
                  {
                     if(!isHandled)
                     {
                        isHandled = true;
                        self.resolve(param1);
                     }
                  },function(param1:*):void
                  {
                     if(!isHandled)
                     {
                        isHandled = true;
                        self.reject(param1);
                     }
                  });
               }
               catch(error:*)
               {
                  if(!isHandled)
                  {
                     reject(error);
                  }
               }
            }
            else
            {
               this.complete(CompletionAction.FULFILL,value);
            }
            return;
         }
         catch(error:*)
         {
            reject(error);
            return;
         }
      }
      
      public function reject(param1:*) : void
      {
         if(this.completed)
         {
            return;
         }
         this.complete(CompletionAction.REJECT,param1);
      }
      
      private function complete(param1:String, param2:*) : void
      {
         var _loc3_:Consequence = null;
         this.completionAction = param1;
         this.completionValue = param2;
         this.completed = true;
         for each(_loc3_ in this.consequences)
         {
            _loc3_.trigger(this.completionAction,this.completionValue);
         }
         this.consequences = [];
      }
   }
}
