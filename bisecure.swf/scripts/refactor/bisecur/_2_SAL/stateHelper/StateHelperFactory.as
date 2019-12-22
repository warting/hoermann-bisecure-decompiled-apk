package refactor.bisecur._2_SAL.stateHelper
{
   import com.isisic.remote.hoermann.global.ActorClasses;
   import flash.utils.getQualifiedClassName;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.stateHelper.implementation.Default_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.ESE_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.FES_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.HET_E1_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.HET_E2_SL_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.HET_E2_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.HET_S_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.Portamatic_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.Smartkey_StateHelper;
   import refactor.bisecur._2_SAL.stateHelper.implementation.VERSAMATIC_DOUBLE_StateHelper;
   import refactor.logicware._5_UTIL.ArrayHelper;
   
   public class StateHelperFactory
   {
      
      private static var instantiatedHelper:Array = [];
       
      
      public function StateHelperFactory()
      {
         super();
         throw new SyntaxError("StateHelperFactory should not be initialized!");
      }
      
      public static function getStateHelper(param1:HmTransition) : IStateHelper
      {
         var _loc2_:IStateHelper = null;
         if(param1 == null || param1.gk >= ActorClasses.UNDEFINED_OFFSET)
         {
            return getDefaultHelper();
         }
         switch(param1.gk)
         {
            case ActorClasses.ESE:
               _loc2_ = getHelper(ESE_StateHelper);
               break;
            case ActorClasses.HET_E1:
               _loc2_ = getHelper(HET_E1_StateHelper);
               break;
            case ActorClasses.HET_E2:
               _loc2_ = getHelper(HET_E2_StateHelper);
               break;
            case ActorClasses.HET_S:
               _loc2_ = getHelper(HET_S_StateHelper);
               break;
            case ActorClasses.HET_E2_SL:
               _loc2_ = getHelper(HET_E2_SL_StateHelper);
               break;
            case ActorClasses.PORTAMATIC:
               _loc2_ = getHelper(Portamatic_StateHelper);
               break;
            case ActorClasses.FES1:
            case ActorClasses.FES1_1:
               _loc2_ = getHelper(FES_StateHelper);
               break;
            case ActorClasses.VERSAMATIC_GELENKARM_DOUBLE:
            case ActorClasses.VERSAMATIC_GLEITSCHIENE_DOUBLE:
               _loc2_ = getHelper(VERSAMATIC_DOUBLE_StateHelper);
               break;
            case ActorClasses.SMART_KEY:
               _loc2_ = getHelper(Smartkey_StateHelper);
               break;
            default:
               _loc2_ = getDefaultHelper();
         }
         return _loc2_;
      }
      
      public static function getDefaultHelper() : IStateHelper
      {
         return getHelper(Default_StateHelper);
      }
      
      private static function getHelper(param1:Class) : IStateHelper
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:IStateHelper = ArrayHelper.findByProperty("name",_loc2_,instantiatedHelper) as IStateHelper;
         if(_loc3_ == null)
         {
            _loc3_ = new param1();
            instantiatedHelper.push({
               "name":_loc2_,
               "instance":_loc3_
            });
         }
         return _loc3_;
      }
   }
}
