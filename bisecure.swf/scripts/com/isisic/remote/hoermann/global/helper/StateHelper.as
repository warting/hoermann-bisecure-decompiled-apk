package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.components.ValueButton;
   import com.isisic.remote.hoermann.components.stateImages.DoorStateImage;
   import com.isisic.remote.hoermann.components.stateImages.HorizontalSectionalDoorStateImage;
   import com.isisic.remote.hoermann.components.stateImages.JackStateImage;
   import com.isisic.remote.hoermann.components.stateImages.LightStateImage;
   import com.isisic.remote.hoermann.components.stateImages.Pilomat_DurchfahrtssperreStateImage;
   import com.isisic.remote.hoermann.components.stateImages.Pilomat_HubbalkenStateImage;
   import com.isisic.remote.hoermann.components.stateImages.Pilomat_PollerStateImage;
   import com.isisic.remote.hoermann.components.stateImages.Pilomat_ReifenkillerStateImage;
   import com.isisic.remote.hoermann.components.stateImages.SectionalDoorStateImage;
   import com.isisic.remote.hoermann.components.stateImages.SlidingGateStateImage;
   import com.isisic.remote.hoermann.components.stateImages.StateImageBase;
   import com.isisic.remote.hoermann.components.stateImages.SwingGateDoubleStateImage;
   import com.isisic.remote.hoermann.components.stateImages.SwingGateSingleStateImage;
   import com.isisic.remote.hoermann.global.ActorClasses;
   import com.isisic.remote.hoermann.global.GroupTypes;
   import com.isisic.remote.hoermann.global.PortTypes;
   import com.isisic.remote.hoermann.global.stateHelper.IStateHelper;
   import com.isisic.remote.hoermann.global.stateHelper.StateHelperFactory;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.net.HmTransition;
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
         var _loc2_:int = param1.id;
         var _loc3_:HmTransition = HmProcessor.defaultProcessor.transitions[param1.id];
         var _loc4_:HmProcessor = HmProcessor.defaultProcessor;
         var _loc5_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc6_:IStateHelper = StateHelperFactory.getStateHelper(_loc3_);
         var _loc7_:Boolean = _loc4_.requestablePorts != null && _loc4_.requestablePorts[param1.id] != null && _loc4_.requestablePorts[param1.id] < 255;
         var _loc8_:String = _loc6_.getStateLabel(param1,_loc3_,_loc7_);
         if(_loc8_ == null)
         {
            _loc8_ = _loc5_.getStateLabel(param1,_loc3_,_loc7_);
         }
         return _loc8_;
      }
      
      public static function getStateValue(param1:Object) : String
      {
         var _loc2_:HmTransition = HmProcessor.defaultProcessor.transitions[param1.id];
         var _loc3_:HmProcessor = HmProcessor.defaultProcessor;
         var _loc4_:Boolean = _loc3_.requestablePorts != null && _loc3_.requestablePorts[param1.id] != null && _loc3_.requestablePorts[param1.id] < 255;
         var _loc5_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc6_:IStateHelper = StateHelperFactory.getStateHelper(_loc2_);
         var _loc7_:String = _loc6_.getStateValue(param1,_loc2_,_loc4_);
         if(_loc7_ == null)
         {
            _loc7_ = _loc5_.getStateValue(param1,_loc2_,_loc4_);
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
         var _loc2_:HmProcessor = HmProcessor.defaultProcessor;
         var _loc3_:Boolean = _loc2_ != null && _loc2_.requestablePorts != null && _loc2_.requestablePorts[param1] != null && _loc2_.requestablePorts[param1] < 255;
         return _loc3_;
      }
      
      private static function getTransition(param1:int) : HmTransition
      {
         var _loc2_:Boolean = isRequestable(param1);
         var _loc3_:HmTransition = HmProcessor.defaultProcessor.transitions[param1];
         if(!_loc2_)
         {
            return null;
         }
         return _loc3_;
      }
   }
}
