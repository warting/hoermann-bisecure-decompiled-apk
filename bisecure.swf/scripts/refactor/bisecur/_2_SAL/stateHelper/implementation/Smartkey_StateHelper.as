package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgError;
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgUnavailable;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_BatteryEmpty;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Locked;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Unlocked;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.ActorState;
   import refactor.logicware._5_UTIL.Log;
   
   public class Smartkey_StateHelper extends StateHelperBase
   {
       
      
      public function Smartkey_StateHelper()
      {
         super();
      }
      
      override public function showDriveDirection(param1:HmTransition, param2:Boolean) : Boolean
      {
         return false;
      }
      
      override public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         var _loc3_:SmartkeyInfos = this.getStateInfos(param1,param2);
         return _loc3_.additionalStateImage;
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         var _loc4_:SmartkeyInfos = this.getStateInfos(param2,param3);
         return _loc4_.stateValue;
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         var _loc4_:SmartkeyInfos = this.getStateInfos(param2,param3);
         Log.debug("[Smartkey_StateHelper] getStateLabelRequested: \n" + _loc4_.stateLabel + "\n" + param2.toString());
         return _loc4_.stateLabel;
      }
      
      override public function forceState(param1:HmTransition, param2:Boolean) : String
      {
         var _loc3_:SmartkeyInfos = this.getStateInfos(param1,param2);
         return _loc3_.state;
      }
      
      override public function showState(param1:HmTransition, param2:Boolean) : Boolean
      {
         var _loc3_:SmartkeyInfos = this.getStateInfos(param1,param2);
         return _loc3_.showState;
      }
      
      private function getStateInfos(param1:HmTransition, param2:Boolean) : SmartkeyInfos#192
      {
         var _loc3_:SmartkeyInfos = new SmartkeyInfos#192();
         if(param1 == null || param1.hcp == null)
         {
            _loc3_.showState = false;
            _loc3_.additionalStateImage = new FxgUnavailable();
            _loc3_.state = ActorState.OPEN;
            _loc3_.stateLabel = "";
            _loc3_.stateValue = "";
            return _loc3_;
         }
         var _loc4_:int = param1.exst[7];
         var _loc5_:int = param1.exst[6];
         var _loc6_:int = param1.exst[5];
         _loc3_.showState = true;
         switch(_loc4_)
         {
            case SmartkeyStates#192.UNBEKANNT:
               _loc3_.showState = false;
               _loc3_.additionalStateImage = new FxgError();
               _loc3_.state = ActorState.CLOSED;
               _loc3_.stateLabel = Lang.getString("DRIVE_MESSAGE_NOT_REFERENCED");
               _loc3_.stateValue = "";
               break;
            case SmartkeyStates#192.GEOEFFNET:
               _loc3_.additionalStateImage = new Fxg_Unlocked();
               _loc3_.state = ActorState.HALF_3;
               _loc3_.stateLabel = Lang.getString("DRIVE_MESSAGE_OPENED");
               _loc3_.stateValue = "";
               break;
            case SmartkeyStates#192.ENTRIEGELT:
               _loc3_.additionalStateImage = new Fxg_Unlocked();
               _loc3_.state = ActorState.CLOSED;
               _loc3_.stateLabel = Lang.getString("DRIVE_MESSAGE_UNLOCKED");
               _loc3_.stateValue = "";
               break;
            case SmartkeyStates#192.VERRIEGELT_1:
            case SmartkeyStates#192.VERRIEGELT_2:
            case SmartkeyStates#192.VERRIEGELT_3:
               _loc3_.additionalStateImage = new Fxg_Locked();
               _loc3_.state = ActorState.CLOSED;
               _loc3_.stateLabel = Lang.getString("DRIVE_MESSAGE_LOCKED");
               _loc3_.stateValue = "";
               break;
            case SmartkeyStates#192.FAHREND_R_GEOEFFNET:
            case SmartkeyStates#192.FAHREND_R_ENTRIEGELT:
            case SmartkeyStates#192.FAHREND_R_VERRIEGELT_1:
            case SmartkeyStates#192.FAHREND_R_VERRIEGELT_2:
            case SmartkeyStates#192.FAHREND_R_VERRIEGELT_3:
               _loc3_.additionalStateImage = null;
               _loc3_.state = null;
               _loc3_.stateLabel = null;
               _loc3_.stateValue = null;
         }
         if(_loc6_ != SmartkeyBatteryStates#192.BATTERY_OK)
         {
            _loc3_.additionalStateImage = new Fxg_BatteryEmpty();
            _loc3_.state = ActorState.CLOSED;
         }
         return _loc3_;
      }
   }
}

import mx.core.IVisualElement;

class SmartkeyInfos#192
{
    
   
   public var showState:Boolean;
   
   public var additionalStateImage:IVisualElement;
   
   public var state:String;
   
   public var stateLabel:String;
   
   public var stateValue:String;
   
   function SmartkeyInfos#192()
   {
      super();
   }
}

class SmartkeyStates#192
{
   
   public static const UNBEKANNT:int = 0;
   
   public static const GEOEFFNET:int = 1;
   
   public static const ENTRIEGELT:int = 2;
   
   public static const VERRIEGELT_1:int = 3;
   
   public static const VERRIEGELT_2:int = 4;
   
   public static const VERRIEGELT_3:int = 5;
   
   public static const FAHREND_R_GEOEFFNET:int = 17;
   
   public static const FAHREND_R_ENTRIEGELT:int = 18;
   
   public static const FAHREND_R_VERRIEGELT_1:int = 19;
   
   public static const FAHREND_R_VERRIEGELT_2:int = 20;
   
   public static const FAHREND_R_VERRIEGELT_3:int = 21;
    
   
   function SmartkeyStates#192()
   {
      super();
   }
}

class SmartkeyBatteryStates#192
{
   
   public static const BATTERY_OK:int = 0;
   
   public static const BATTERY_LOW:int = 1;
   
   public static const BATTERY_EMPTY:int = 2;
    
   
   function SmartkeyBatteryStates#192()
   {
      super();
   }
}
