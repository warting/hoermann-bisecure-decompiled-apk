package refactor.bisecur._5_UTIL
{
   import com.isisic.remote.hoermann.components.ValueButton;
   import com.isisic.remote.hoermann.global.ActorClasses;
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import refactor.bisecur._1_APP.components.stateImages.BarrierStateImage;
   import refactor.bisecur._1_APP.components.stateImages.DoorStateImage;
   import refactor.bisecur._1_APP.components.stateImages.HorizontalSectionalDoorStateImage;
   import refactor.bisecur._1_APP.components.stateImages.JackStateImage;
   import refactor.bisecur._1_APP.components.stateImages.LightStateImage;
   import refactor.bisecur._1_APP.components.stateImages.Pilomat_DurchfahrtssperreStateImage;
   import refactor.bisecur._1_APP.components.stateImages.Pilomat_HubbalkenStateImage;
   import refactor.bisecur._1_APP.components.stateImages.Pilomat_PollerStateImage;
   import refactor.bisecur._1_APP.components.stateImages.Pilomat_ReifenkillerStateImage;
   import refactor.bisecur._1_APP.components.stateImages.SectionalDoorStateImage;
   import refactor.bisecur._1_APP.components.stateImages.SlidingGateStateImage;
   import refactor.bisecur._1_APP.components.stateImages.StateImageBase;
   import refactor.bisecur._1_APP.components.stateImages.SwingGateDoubleStateImage;
   import refactor.bisecur._1_APP.components.stateImages.SwingGateSingleStateImage;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.IStateHelper;
   import refactor.bisecur._2_SAL.stateHelper.StateHelperFactory;
   import spark.formatters.DateTimeFormatter;
   
   public final class StateHelper
   {
      
      private static var formatter:DateTimeFormatter;
       
      
      public function StateHelper()
      {
         super();
      }
      
      public static function getStateLabel(param1:Object) : String
      {
         var _loc2_:HmProcessor = AppCache.sharedCache.hmProcessor;
         var _loc3_:int = param1.id;
         if(!_loc2_ || !_loc2_.collector || !_loc2_.collector.transitions)
         {
            return "";
         }
         var _loc4_:HmTransition = _loc2_.collector.transitions[param1.id];
         var _loc5_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc6_:IStateHelper = StateHelperFactory.getStateHelper(_loc4_);
         var _loc7_:Boolean = _loc2_.collector.isGroupRequestable(_loc3_);
         var _loc8_:String = _loc6_.getStateLabel(param1,_loc4_,_loc7_);
         if(_loc8_ == null)
         {
            _loc8_ = _loc5_.getStateLabel(param1,_loc4_,_loc7_);
         }
         return _loc8_;
      }
      
      public static function getStateValue(param1:Object) : String
      {
         var _loc2_:HmProcessor = AppCache.sharedCache.hmProcessor;
         if(!_loc2_ || !_loc2_.collector || !_loc2_.collector.transitions)
         {
            return "";
         }
         var _loc3_:HmTransition = _loc2_.collector.transitions[param1.id];
         var _loc4_:Boolean = _loc2_.collector.isGroupRequestable(param1.id);
         var _loc5_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc6_:IStateHelper = StateHelperFactory.getStateHelper(_loc3_);
         var _loc7_:String = _loc6_.getStateValue(param1,_loc3_,_loc4_);
         if(_loc7_ == null)
         {
            _loc7_ = _loc5_.getStateValue(param1,_loc3_,_loc4_);
         }
         return _loc7_;
      }
      
      public static function getStateImage(param1:Object) : StateImageBase
      {
         if(param1 == null)
         {
            return new StateImageBase();
         }
         switch(param1.type)
         {
            case GroupTypes.SECTIONAL_DOOR:
               return new SectionalDoorStateImage();
            case GroupTypes.HORIZONTAL_SECTIONAL_DOOR:
               return new HorizontalSectionalDoorStateImage();
            case GroupTypes.SWING_GATE_SINGLE:
               return new SwingGateSingleStateImage();
            case GroupTypes.SWING_GATE_DOUBLE:
               return new SwingGateDoubleStateImage();
            case GroupTypes.SLIDING_GATE:
               return new SlidingGateStateImage();
            case GroupTypes.DOOR:
               return new DoorStateImage();
            case GroupTypes.LIGHT:
               return new LightStateImage();
            case GroupTypes.OTHER:
               return new JackStateImage();
            case GroupTypes.JACK:
               return new JackStateImage();
            case GroupTypes.SMARTKEY:
               return new DoorStateImage();
            case GroupTypes.PILOMAT_POLLER:
               return new Pilomat_PollerStateImage();
            case GroupTypes.PILOMAT_DURCHFAHRTSSPERRE:
               return new Pilomat_DurchfahrtssperreStateImage();
            case GroupTypes.PILOMAT_HUBBALKEN:
               return new Pilomat_HubbalkenStateImage();
            case GroupTypes.PILOMAT_REIFENKILLER:
               return new Pilomat_ReifenkillerStateImage();
            case GroupTypes.BARRIER:
               return new BarrierStateImage();
            default:
               return new StateImageBase();
         }
      }
      
      public static function setupControlButton(param1:ValueButton, param2:Object, param3:Object) : void
      {
         var _loc5_:Boolean = false;
         var _loc4_:HmTransition = getTransition(param3.id);
         if(_loc4_ == null)
         {
            return;
         }
         if(_loc4_.gk == ActorClasses.HET_E1)
         {
            if(param2.type == PortTypes.ON_OFF || param2.type == PortTypes.ON)
            {
               if((_loc4_.exst[7] & 2) == 2)
               {
                  param1.showDown = true;
               }
               else
               {
                  param1.showDown = false;
               }
            }
         }
         if(param3.type == GroupTypes.LIGHT || param3.type == GroupTypes.OTHER || param3.type == GroupTypes.JACK)
         {
            _loc5_ = false;
            if(param2.type == PortTypes.ON_OFF)
            {
               _loc5_ = true;
               for each(param2 in param3.ports)
               {
                  if(param2.type == PortTypes.ON)
                  {
                     _loc5_ = false;
                     break;
                  }
               }
            }
            else if(param2.type == PortTypes.ON)
            {
               _loc5_ = true;
            }
            if(_loc4_.actual == 0)
            {
               param1.showDown = _loc5_;
            }
            else
            {
               param1.showDown = false;
            }
         }
      }
      
      public static function getTransitionTime(param1:int) : String
      {
         var _loc2_:HmTransition = getTransition(param1);
         if(_loc2_ == null)
         {
            return "";
         }
         if(_loc2_.time == null)
         {
            return "-";
         }
         if(_loc2_.driveTime != 0)
         {
            return "";
         }
         if(!formatter)
         {
            formatter = new DateTimeFormatter();
         }
         formatter.dateTimePattern = "HH:mm:ss";
         return Lang.getString("GENERAL_REFESHED") + ": " + formatter.format(_loc2_.time);
      }
      
      private static function isRequestable(param1:int) : Boolean
      {
         var _loc2_:HmProcessor = AppCache.sharedCache.hmProcessor;
         if(!_loc2_ || !_loc2_.collector)
         {
            return false;
         }
         var _loc3_:Boolean = _loc2_.collector.isGroupRequestable(param1);
         return _loc3_;
      }
      
      private static function getTransition(param1:int) : HmTransition
      {
         if(!isRequestable(param1))
         {
            return null;
         }
         var _loc2_:AppCache = AppCache.sharedCache;
         var _loc3_:HmProcessor = _loc2_.hmProcessor;
         var _loc4_:Object = _loc3_.transitions;
         var _loc5_:HmTransition = _loc4_[param1];
         return _loc5_;
      }
   }
}
