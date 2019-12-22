package refactor.bisecur._2_SAL.net.cache
{
   import refactor.bisecur._5_UTIL.CallbackHelper;
   
   public class CacheBase
   {
       
      
      private var _isCacheValid:Boolean = false;
      
      private var _isValidatingCache:Boolean = false;
      
      private var callbackBuffer:Vector.<Function>;
      
      public function CacheBase()
      {
         this.callbackBuffer = new Vector.<Function>(0);
         super();
      }
      
      public function get isCacheValid() : Boolean
      {
         return this._isCacheValid;
      }
      
      protected function get isValidatingCache() : Boolean
      {
         return this._isValidatingCache;
      }
      
      public function invalidateCache() : void
      {
         this._isCacheValid = false;
      }
      
      protected function validateCache(param1:Function = null) : void
      {
         this.putCallback(param1);
         this._isValidatingCache = true;
      }
      
      protected function finishCacheValidation(param1:Array) : void
      {
         var _loc2_:Function = null;
         this._isValidatingCache = false;
         this._isCacheValid = true;
         while((_loc2_ = this.getCallback()) != null)
         {
            CallbackHelper.callCallback(_loc2_,param1);
         }
      }
      
      private function putCallback(param1:Function) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.callbackBuffer.push(param1);
      }
      
      private function getCallback() : Function
      {
         if(this.callbackBuffer.length < 0)
         {
            return null;
         }
         return this.callbackBuffer.shift();
      }
   }
}
