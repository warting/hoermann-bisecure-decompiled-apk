package com.isisic.remote.hoermann.global.stateHelper.implementation
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgError;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Locked;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Unlocked;
   import com.isisic.remote.hoermann.global.helper.HmTransitionHelper;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.net.HmTransition;
   import com.isisic.remote.lw.Debug;
   import mx.core.IVisualElement;
   
   public class Portamatic_StateHelper extends StateHelperBase
   {
       
      
      public function Portamatic_StateHelper()
      {
         super();
      }
      
      private static function getInputState(param1:HmTransition) : int
      {
         switch(PortamaticExstParser#2908.getConfigMode(param1.exst))
         {
            case PortamaticConfiguration#2908.NONE:
               return PortamaticInputState#2908.UNKNOWN;
            case PortamaticConfiguration#2908.BOLT_CHANGER:
               return getLockState_Changer(param1);
            case PortamaticConfiguration#2908.BOLT_CLOSER:
               return getLockState_Closer(param1);
            case PortamaticConfiguration#2908.BOLT_OPENER:
               return getLockState_Opener(param1);
            case PortamaticConfiguration#2908.STOP_CLOSER:
               return getStopState_Closer(param1);
            case PortamaticConfiguration#2908.STOP_OPENER:
               return getStopState_Opener(param1);
            default:
               Debug.warning("[PortamaticStateHelper] unknown configuration mode: " + PortamaticExstParser#2908.getConfigMode(param1.exst));
               return PortamaticInputState#2908.UNKNOWN;
         }
      }
      
      private static function getLockState_Changer(param1:HmTransition) : int
      {
         var _loc2_:Boolean = PortamaticExstParser#2908.getE1(param1.exst);
         var _loc3_:Boolean = PortamaticExstParser#2908.getE2(param1.exst);
         if(_loc2_ && !_loc3_)
         {
            return PortamaticInputState#2908.BOLT_LOCKED;
         }
         if(!_loc2_ && _loc3_)
         {
            return PortamaticInputState#2908.BOLT_UNLOCKED;
         }
         return PortamaticInputState#2908.BOLT_ERROR;
      }
      
      private static function getLockState_Closer(param1:HmTransition) : int
      {
         var _loc2_:Boolean = PortamaticExstParser#2908.getE1(param1.exst);
         if(_loc2_)
         {
            return PortamaticInputState#2908.BOLT_LOCKED;
         }
         return PortamaticInputState#2908.BOLT_UNLOCKED;
      }
      
      private static function getLockState_Opener(param1:HmTransition) : int
      {
         var _loc2_:Boolean = PortamaticExstParser#2908.getE2(param1.exst);
         if(!_loc2_)
         {
            return PortamaticInputState#2908.BOLT_LOCKED;
         }
         return PortamaticInputState#2908.BOLT_UNLOCKED;
      }
      
      private static function getStopState_Closer(param1:HmTransition) : int
      {
         var _loc2_:Boolean = PortamaticExstParser#2908.getE1(param1.exst);
         if(_loc2_)
         {
            return PortamaticInputState#2908.STOP_ACTIVE;
         }
         return PortamaticInputState#2908.STOP_INACTIVE;
      }
      
      private static function getStopState_Opener(param1:HmTransition) : int
      {
         var _loc2_:Boolean = PortamaticExstParser#2908.getE2(param1.exst);
         if(!_loc2_)
         {
            return PortamaticInputState#2908.STOP_ACTIVE;
         }
         return PortamaticInputState#2908.STOP_INACTIVE;
      }
      
      override public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         var _loc3_:int = 0;
         if(HmTransitionHelper.isClosed(param1) && PortamaticExstParser#2908.isLockMode(param1.exst))
         {
            _loc3_ = getInputState(param1);
            switch(_loc3_)
            {
               case PortamaticInputState#2908.BOLT_LOCKED:
                  return new Fxg_Locked();
               case PortamaticInputState#2908.BOLT_UNLOCKED:
                  return new Fxg_Unlocked();
               case PortamaticInputState#2908.BOLT_ERROR:
                  return new FxgError();
            }
         }
         return null;
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         var _loc4_:int = getInputState(param2);
         if(param2 != null && param2.autoClose)
         {
            if(param2.actual == 0)
            {
               return Lang.getString("DRIVE_MESSAGE_CLOSED");
            }
            if(param2.actual == 200)
            {
               return Lang.getString("DRIVE_MESSAGE_OPENED");
            }
            return Lang.getString("DRIVE_MESSAGE_HALF");
         }
         if(_loc4_ == PortamaticInputState#2908.BOLT_ERROR)
         {
            return Lang.getString("DRIVE_MESSAGE_ERROR");
         }
         return null;
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         var _loc4_:int = getInputState(param2);
         if(PortamaticExstParser#2908.isStopMode(param2.exst) && _loc4_ == PortamaticInputState#2908.STOP_ACTIVE)
         {
            if(HmTransitionHelper.isClosed(param2) || HmTransitionHelper.isOpened(param2))
            {
               return Lang.getString("DRIVE_MESSAGE_STOP_ACTIVE");
            }
            return getStatePercent(param2) + " - " + Lang.getString("DRIVE_MESSAGE_STOP_ACTIVE");
         }
         if(PortamaticExstParser#2908.isLockMode(param2.exst))
         {
            if(HmTransitionHelper.isClosed(param2))
            {
               if(_loc4_ == PortamaticInputState#2908.BOLT_LOCKED)
               {
                  return Lang.getString("DRIVE_MESSAGE_LOCKED");
               }
               if(_loc4_ == PortamaticInputState#2908.BOLT_UNLOCKED)
               {
                  return Lang.getString("DRIVE_MESSAGE_UNLOCKED");
               }
               if(_loc4_ == PortamaticInputState#2908.BOLT_ERROR)
               {
                  return "";
               }
            }
         }
         return null;
      }
   }
}

class PortamaticConfiguration#2908
{
   
   public static const NONE:int = 0;
   
   public static const BOLT_CHANGER:int = 1;
   
   public static const BOLT_CLOSER:int = 2;
   
   public static const BOLT_OPENER:int = 3;
   
   public static const STOP_CLOSER:int = 4;
   
   public static const STOP_OPENER:int = 5;
    
   
   function PortamaticConfiguration#2908()
   {
      super();
   }
}

class PortamaticInputState#2908
{
   
   public static const UNKNOWN:int = -1;
   
   public static const BOLT_ERROR:int = 0;
   
   public static const BOLT_LOCKED:int = 1;
   
   public static const BOLT_UNLOCKED:int = 2;
   
   public static const STOP_ACTIVE:int = 3;
   
   public static const STOP_INACTIVE:int = 4;
    
   
   function PortamaticInputState#2908()
   {
      super();
   }
}

class PortamaticExstParser#2908
{
    
   
   function PortamaticExstParser#2908()
   {
      super();
   }
   
   public static function getConfigMode(param1:Array) : int
   {
      return param1[6];
   }
   
   public static function isLockMode(param1:Array) : Boolean
   {
      var _loc2_:int = getConfigMode(param1);
      if(_loc2_ >= 1 && _loc2_ <= 3)
      {
         return true;
      }
      return false;
   }
   
   public static function isStopMode(param1:Array) : Boolean
   {
      var _loc2_:int = getConfigMode(param1);
      if(_loc2_ >= 4 && _loc2_ <= 5)
      {
         return true;
      }
      return false;
   }
   
   public static function getE1(param1:Array) : Boolean
   {
      return (param1[5] & 1) == 1;
   }
   
   public static function getE2(param1:Array) : Boolean
   {
      return (param1[5] & 2) == 2;
   }
}
