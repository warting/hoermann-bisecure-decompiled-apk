package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.ActorState;
   
   public class HET_E2_SL_StateHelper extends StateHelperBase
   {
       
      
      public function HET_E2_SL_StateHelper()
      {
         super();
      }
      
      override public function forceState(param1:HmTransition, param2:Boolean) : String
      {
         if(!param2)
         {
            return null;
         }
         var _loc3_:PinParser = new PinParser#3178(param1);
         switch(_loc3_.pinDefinition)
         {
            case PinParser#3178.P1_LOW_P3_HIGH:
               return ActorState.RETRACTED;
            case PinParser#3178.P1_HIGH_P3_LOW:
               return ActorState.EXTENDED;
            case PinParser#3178.P1_HIGH_P3_HIGH:
               return ActorState.NOT_RETRACTED;
            case PinParser#3178.P1_LOW_P3_LOW:
               return ActorState.EXTENDED;
            default:
               return null;
         }
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         if(!param3)
         {
            return "";
         }
         var _loc4_:PinParser = new PinParser#3178(param2);
         switch(_loc4_.pinDefinition)
         {
            case PinParser#3178.P1_LOW_P3_HIGH:
               return Lang.getString("DRIVE_MESSAGE_RETRACTED");
            case PinParser#3178.P1_HIGH_P3_LOW:
               return Lang.getString("DRIVE_MESSAGE_EXTENDED");
            case PinParser#3178.P1_HIGH_P3_HIGH:
               return Lang.getString("DRIVE_MESSAGE_NOT_RETRACTED");
            case PinParser#3178.P1_LOW_P3_LOW:
               return Lang.getString("DRIVE_MESSAGE_ERROR");
            default:
               return "";
         }
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         return "";
      }
      
      override public function showDriveDirection(param1:HmTransition, param2:Boolean) : Boolean
      {
         return false;
      }
   }
}

import refactor.bisecur._2_SAL.net.HmTransition;

class PinParser#3178
{
   
   public static const PINS_UNDEFINED:int = -1;
   
   public static const P1_LOW_P3_LOW:int = 0;
   
   public static const P1_LOW_P3_HIGH:int = 1;
   
   public static const P1_HIGH_P3_LOW:int = 2;
   
   public static const P1_HIGH_P3_HIGH:int = 3;
    
   
   private var _pin1:Boolean;
   
   private var _pin3:Boolean;
   
   private var _pinDefinition:int = -1;
   
   function PinParser#3178(param1:HmTransition)
   {
      super();
      this._pin1 = !(param1.exst[5] & 2);
      this._pin3 = !(param1.exst[5] & 1);
      if(!this.pin1 && !this.pin3)
      {
         this._pinDefinition = P1_LOW_P3_LOW;
      }
      else if(!this.pin1 && this.pin3)
      {
         this._pinDefinition = P1_LOW_P3_HIGH;
      }
      else if(this.pin1 && !this.pin3)
      {
         this._pinDefinition = P1_HIGH_P3_LOW;
      }
      else if(this.pin1 && this.pin3)
      {
         this._pinDefinition = P1_HIGH_P3_HIGH;
      }
   }
   
   public function get pin1() : Boolean
   {
      return this._pin1;
   }
   
   public function get pin3() : Boolean
   {
      return this._pin3;
   }
   
   public function get pinDefinition() : int
   {
      return this._pinDefinition;
   }
}
