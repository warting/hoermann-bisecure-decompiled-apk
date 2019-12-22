package refactor.bisecur._2_SAL.net.transitionCollecting.states
{
   import com.isisic.remote.hoermann.global.ActorClasses;
   import com.isisic.remote.lw.net.lw_network;
   import flash.utils.ByteArray;
   import refactor.bisecur._2_SAL.net.HCP;
   import refactor.bisecur._2_SAL.net.HmTransition;
   import refactor.bisecur._2_SAL.net.transitionCollecting.StateContext;
   import refactor.bisecur._2_SAL.stateHelper.IStateHelper;
   import refactor.bisecur._2_SAL.stateHelper.StateHelperFactory;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   import refactor.logicware._2_SAL.mcp.MCPErrors;
   import refactor.logicware._5_UTIL.Log;
   
   use namespace lw_network;
   
   public class Parsing extends StateBase
   {
       
      
      public function Parsing()
      {
         super();
      }
      
      public static function parseHmTransition(param1:ByteArray) : HmTransition
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         param1.position = 0;
         var _loc2_:HmTransition = new HmTransition();
         _loc2_.actual = param1.readUnsignedByte();
         _loc2_.desired = param1.readUnsignedByte();
         var _loc3_:* = int(param1.readUnsignedByte());
         var _loc4_:int = param1.readUnsignedByte();
         _loc2_.error = false;
         _loc2_.autoClose = false;
         if(_loc3_ >> 6 > 0)
         {
            if((_loc3_ & 128) > 0)
            {
               _loc2_.error = true;
            }
            if((_loc3_ & 64) > 0)
            {
               _loc2_.autoClose = true;
               if((_loc3_ & 16) > 0)
               {
               }
            }
            _loc3_ = _loc3_ & ~240;
         }
         if(_loc2_.error == false)
         {
            _loc2_.driveTime = (_loc3_ << 8) + _loc4_;
         }
         var _loc5_:int = param1.readUnsignedByte();
         var _loc6_:int = param1.readUnsignedByte();
         _loc2_.gk = (_loc5_ << 8) + _loc6_;
         _loc2_.hcp = null;
         if(_loc5_ < 252)
         {
            _loc11_ = param1.readUnsignedByte();
            _loc12_ = param1.readUnsignedByte();
            _loc2_.hcp = HCP.fromRaw(_loc11_,_loc12_);
         }
         _loc2_.exst = [];
         var _loc7_:int = 0;
         while(_loc7_ < 8)
         {
            _loc2_.exst.push(param1.readUnsignedByte());
            _loc7_++;
         }
         _loc2_.exst.reverse();
         _loc2_.time = new Date();
         if(_loc2_.hcp != null && _loc2_.hcp.driving == false)
         {
            if(_loc2_.driveTime > 0 || _loc2_.hcp.forecastLeadTime)
            {
               _loc2_.driveTime = 2;
               _loc2_.ignoreRetries = true;
               _loc2_.hcp = null;
            }
         }
         else if(_loc2_.hcp != null && _loc2_.hcp.driving == true)
         {
            if(_loc2_.driveTime <= 0)
            {
               _loc2_.driveTime = 2;
               _loc2_.ignoreRetries = true;
            }
         }
         if(_loc2_.gk == ActorClasses.ESE && HmTransitionHelper.isDriving(_loc2_))
         {
            _loc2_.driveTime = 5;
            _loc2_.ignoreRetries = true;
         }
         var _loc8_:IStateHelper = StateHelperFactory.getDefaultHelper();
         var _loc9_:IStateHelper = StateHelperFactory.getStateHelper(_loc2_);
         var _loc10_:HmTransition = _loc9_.forceTransition(_loc2_);
         if(_loc10_ == null)
         {
            _loc2_ = _loc8_.forceTransition(_loc2_);
         }
         else
         {
            _loc2_ = _loc10_;
         }
         return _loc2_;
      }
      
      override public function Enter(param1:StateContext) : void
      {
         var _loc2_:ByteArray = param1.transitionData;
         if(_loc2_ == null || _loc2_.length <= 4)
         {
            Log.warning("[TransitionCollector] Received HM_TRANSITION with invalid payload!");
            param1.onError(this,new Error("Invalid TransitionResponse!",MCPErrors.INVALID_PAYLOAD));
            return;
         }
         var _loc3_:HmTransition = Parsing.parseHmTransition(_loc2_);
         if(_loc3_.ignoreRetries)
         {
            param1.resetRequestCounter();
         }
         param1.onTransitionParsed(_loc3_);
      }
      
      override public function Exit(param1:StateContext) : void
      {
      }
   }
}
