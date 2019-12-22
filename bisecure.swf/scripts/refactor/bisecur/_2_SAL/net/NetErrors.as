package refactor.bisecur._2_SAL.net
{
   public class NetErrors
   {
      
      public static const UNEXPECTED_MESSAGE:int = -1;
      
      public static const NETWORK_TIMEOUT:int = -2;
      
      public static const MAX_RETRIES:int = -3;
      
      public static const NAMES:Object = {
         "-1":"UNEXPECTED_MESSAGE",
         "-2":"NETWORK_TIMEOUT",
         "-3":"MAX_RETRIES"
      };
       
      
      public function NetErrors()
      {
         super();
      }
   }
}
