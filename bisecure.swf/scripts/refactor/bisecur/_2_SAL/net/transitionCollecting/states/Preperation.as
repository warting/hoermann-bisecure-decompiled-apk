package refactor.bisecur._2_SAL.net.transitionCollecting.states
{
   import com.codecatalyst.promise.Promise;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.transitionCollecting.StateContext;
   import refactor.logicware._5_UTIL.Log;
   
   public class Preperation extends StateBase
   {
       
      
      public function Preperation()
      {
         super();
      }
      
      override public function Enter(param1:StateContext) : void
      {
         var context:StateContext = param1;
         Promise.all([GatewayValues.instance.getGrouptype(context.groupId),GatewayValues.instance.getRequestablePort(context.groupId)]).then(function(param1:Array):void
         {
            var _loc4_:Object = null;
            var _loc2_:uint = 255;
            var _loc3_:uint = 255;
            for each(_loc4_ in param1)
            {
               switch(_loc4_.response)
               {
                  case "GroupType":
                     _loc3_ = _loc4_.type;
                     continue;
                  case "RequestablePort":
                     _loc2_ = _loc4_.portId;
                     continue;
                  default:
                     Log.warning("[PreparationState] unexpected response from promise: " + JSON.stringify(_loc4_));
                     continue;
               }
            }
            context.onPreparationFinished(_loc3_,_loc2_);
         },function(param1:Error):void
         {
            context.onError(this,param1);
         });
      }
      
      override public function Exit(param1:StateContext) : void
      {
      }
   }
}
