package refactor.bisecur._2_SAL.stateHelper.implementation
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgError;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Locked;
   import com.isisic.remote.hoermann.assets.images.devices.general.Fxg_Unlocked;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import refactor.bisecur._2_SAL.net.HmTransition;
   
   public class HET_E1_StateHelper extends StateHelperBase
   {
       
      
      public function HET_E1_StateHelper()
      {
         super();
      }
      
      override public function getAdditionalStateImage(param1:HmTransition, param2:Boolean) : IVisualElement
      {
         var _loc3_:Boolean = HET_E1_ExstParser#3192.getE1(param1.exst);
         var _loc4_:Boolean = HET_E1_ExstParser#3192.getE2(param1.exst);
         if(_loc3_ && !_loc4_)
         {
            return new Fxg_Locked();
         }
         if(!_loc3_ && _loc4_)
         {
            return new Fxg_Unlocked();
         }
         return new FxgError();
      }
      
      override public function getStateValue(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         if(param2.actual == 0)
         {
            return Lang.getString("DRIVE_MESSAGE_LOCKED");
         }
         if(param2.actual == 200)
         {
            return Lang.getString("DRIVE_MESSAGE_UNLOCKED");
         }
         return Lang.getString("DRIVE_MESSAGE_ERROR");
      }
      
      override public function getStateLabel(param1:Object, param2:HmTransition, param3:Boolean) : String
      {
         if(HET_E1_ExstParser#3192.getRelais2(param2.exst))
         {
            return Lang.getString("DRIVE_MESSAGE_PERMANENT_UNLOCKED");
         }
         return Lang.getString("DRIVE_MESSAGE_PERMANENT_LOCKED");
      }
   }
}

class HET_E1_ExstParser#3192
{
    
   
   function HET_E1_ExstParser#3192()
   {
      super();
   }
   
   public static function getRelais1(param1:Array) : Boolean
   {
      return (param1[7] & 1) == 1;
   }
   
   public static function getRelais2(param1:Array) : Boolean
   {
      return (param1[7] & 2) == 2;
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
