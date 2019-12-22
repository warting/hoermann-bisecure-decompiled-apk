package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   import refactor.logicware._5_UTIL.Log;
   
   public class Default_StateHelper extends StateHelperBase
   {
       
      
      public function Default_StateHelper()
      {
         super();
      }
      
      override public function forceTransition(param1:HmTransition) : HmTransition
      {
         return param1;
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         if(!param3 || param2 == null || HmTransitionHelper.isDriving(param2))
         {
            return "";
         }
         if(param1.type == GroupTypes.LIGHT || param1.type == GroupTypes.OTHER || param1.type == GroupTypes.JACK)
         {
            return "";
         }
         if(HmTransitionHelper.hasError(param2) || HmTransitionHelper.hasHint(param2) || HmTransitionHelper.isOpened(param2) || HmTransitionHelper.isClosed(param2) || HmTransitionHelper.isDriving(param2))
         {
            return "";
         }
         if(HmTransitionHelper.isDefinedHalfOpened(param2))
         {
            return getStatePercent(param2) + "(H)";
         }
         return getStatePercent(param2);
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         var _loc4_:HmProcessor = AppCache.sharedCache.hmProcessor;
         if(param2 != null && param2.autoClose)
         {
            Log.debug("[Default_StateHelper] AUTO_CLOSE");
         }
         switch(true)
         {
            case !param3:
               return "";
            case param2 == null:
               if(_loc4_.transitionCollectingActive)
               {
                  return "";
               }
               return Lang.getString("DRIVE_MESSAGE_NO_DATA");
            case param2.error:
               return Lang.getString("DRIVE_MESSAGE_ERROR");
            case param2.autoClose:
               return Lang.getString("DRIVE_MESSAGE_OPENED");
            case param2.driveTime != 0:
               return "";
            case param2.hcp != null:
               if(param1.type == GroupTypes.LIGHT || param1.type == GroupTypes.OTHER || param1.type == GroupTypes.JACK)
               {
                  if(param2.actual == 0)
                  {
                     return Lang.getString("GENERAL_ON");
                  }
                  return Lang.getString("GENERAL_OFF");
               }
               if(param2.hcp.error)
               {
                  return Lang.getString("DRIVE_MESSAGE_ERROR");
               }
               if(param2.hcp.notReferenced)
               {
                  return Lang.getString("DRIVE_MESSAGE_NOT_REFERENCED");
               }
               if(param2.hcp.positionOpen)
               {
                  return Lang.getString("DRIVE_MESSAGE_OPENED");
               }
               if(param2.hcp.positionClose)
               {
                  return Lang.getString("DRIVE_MESSAGE_CLOSED");
               }
               if(param2.hcp.halfOpened)
               {
                  return Lang.getString("DRIVE_MESSAGE_HALF");
               }
            default:
               if(param2.actual != param2.desired)
               {
                  return "";
               }
               if(param2.actual == 200)
               {
                  return Lang.getString("DRIVE_MESSAGE_OPENED");
               }
               if(param2.actual == 0)
               {
                  return Lang.getString("DRIVE_MESSAGE_CLOSED");
               }
               return Lang.getString("DRIVE_MESSAGE_HALF");
         }
      }
   }
}
