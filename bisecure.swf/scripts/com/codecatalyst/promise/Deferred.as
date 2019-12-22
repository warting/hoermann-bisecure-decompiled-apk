package com.codecatalyst.promise
{
   public class Deferred
   {
       
      
      protected var resolver:Resolver;
      
      public function Deferred()
      {
         super();
         this.resolver = new Resolver();
      }
      
      public static function resolve(param1:*) : Promise
      {
         var _loc2_:Deferred = new Deferred();
         _loc2_.resolve(param1);
         return _loc2_.promise;
      }
      
      public static function reject(param1:*) : Promise
      {
         var _loc2_:Deferred = new Deferred();
         _loc2_.reject(param1);
         return _loc2_.promise;
      }
      
      public function get promise() : Promise
      {
         return this.resolver.promise;
      }
      
      public function resolve(param1:*) : void
      {
         this.resolver.resolve(param1);
      }
      
      public function reject(param1:*) : void
      {
         this.resolver.reject(param1);
      }
   }
}
