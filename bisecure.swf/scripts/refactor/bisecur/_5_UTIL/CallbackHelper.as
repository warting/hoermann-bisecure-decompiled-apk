package refactor.bisecur._5_UTIL
{
   public class CallbackHelper
   {
      
      private static var defaultCallback:Function;
       
      
      public function CallbackHelper()
      {
         super();
      }
      
      public static function getDefaultCallback() : Function
      {
         if(defaultCallback == null)
         {
            defaultCallback = function(... rest):void
            {
            };
         }
         return defaultCallback;
      }
      
      public static function callCallback(param1:Function, param2:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.apply(null,param2.slice(0,param1.length));
      }
   }
}
