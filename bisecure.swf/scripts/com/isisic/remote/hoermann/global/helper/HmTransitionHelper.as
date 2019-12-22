package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.global.ActorClasses;
   import com.isisic.remote.hoermann.global.stateHelper.ActorState;
   import com.isisic.remote.hoermann.net.HmTransition;
   
   public class HmTransitionHelper
   {
       
      
      public function HmTransitionHelper()
      {
         super();
      }
      
      public static function getActorState(param1:HmTransition) : String
      {
         var _loc2_:Number = param1 == null?Number(0):Number(param1.actual);
         var _loc3_:Number = _loc2_ / 2;
         return getActorStateFromPercent(_loc3_);
      }
      
      public static function getActorStateFromPercent(param1:Number) : String
      {
         if(param1 == 0)
         {
            return ActorState.CLOSED;
         }
         if(param1 > 0 && param1 < 33.5)
         {
            return ActorState.HALF_3;
         }
         if(param1 >= 33.5 && param1 < 66.5)
         {
            return ActorState.HALF_2;
         }
         if(param1 >= 66.5 && param1 < 100)
         {
            return ActorState.HALF_1;
         }
         if(param1 == 100)
         {
            return ActorState.OPEN;
         }
         return ActorState.CLOSED;
      }
      
      public static function hasError(param1:HmTransition) : Boolean
      {
         if(param1.error)
         {
            return true;
         }
         if(param1.hcp != null)
         {
            return param1.hcp.error;
         }
         return false;
      }
      
      public static function hasHint(param1:HmTransition) : Boolean
      {
         if(param1.hcp != null)
         {
            if(param1.hcp.notReferenced)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isOpened(param1:HmTransition) : Boolean
      {
         if(param1.hcp != null)
         {
            return param1.hcp.positionOpen;
         }
         return param1.actual == 200;
      }
      
      public static function isClosed(param1:HmTransition) : Boolean
      {
         if(param1.hcp != null)
         {
            return param1.hcp.positionClose;
         }
         return param1.actual == 0;
      }
      
      public static function isDefinedHalfOpened(param1:HmTransition) : Boolean
      {
         if(param1.gk == ActorClasses.ESE)
         {
            return param1.actual == 100;
         }
         if(param1.hcp != null)
         {
            return param1.hcp.halfOpened;
         }
         return false;
      }
      
      public static function isHalfOpened(param1:HmTransition) : Boolean
      {
         if(param1.hcp != null)
         {
            return param1.hcp.halfOpened;
         }
         return param1.actual > 0 && param1.actual < 200;
      }
      
      public static function isDriving(param1:HmTransition) : Boolean
      {
         if(param1.hcp != null)
         {
            return param1.hcp.driving || param1.driveTime != 0;
         }
         return param1.driveTime != 0;
      }
      
      public static function isDrivingToClose(param1:HmTransition) : Boolean
      {
         if(!isDriving(param1))
         {
            return false;
         }
         if(param1.hcp != null)
         {
            return param1.hcp.drivingToClose;
         }
         if(param1.actual > param1.desired && param1.driveTime > 0)
         {
            return true;
         }
         return false;
      }
      
      public static function isDrivingToOpen(param1:HmTransition) : Boolean
      {
         if(!isDriving(param1))
         {
            return false;
         }
         if(param1.hcp != null)
         {
            return !param1.hcp.drivingToClose;
         }
         if(param1.actual < param1.desired && param1.driveTime > 0)
         {
            return true;
         }
         return false;
      }
   }
}
