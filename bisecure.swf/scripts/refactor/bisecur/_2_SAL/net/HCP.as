package refactor.bisecur._2_SAL.net
{
   import me.mweber.basic.helper.StringHelper;
   
   public class HCP
   {
       
      
      public var positionOpen:Boolean;
      
      public var positionClose:Boolean;
      
      public var optionRelais:Boolean;
      
      public var lightBarrier:Boolean;
      
      public var error:Boolean;
      
      public var drivingToClose:Boolean;
      
      public var driving:Boolean;
      
      public var halfOpened:Boolean;
      
      public var forecastLeadTime:Boolean;
      
      public var learned:Boolean;
      
      public var notReferenced:Boolean;
      
      public var hcpByte1:String;
      
      public var hcpByte2:String;
      
      public function HCP()
      {
         super();
      }
      
      public static function fromRaw(param1:int, param2:int) : HCP
      {
         var _loc3_:HCP = new HCP();
         _loc3_.hcpByte1 = param1.toString(2);
         while(_loc3_.hcpByte1.length < 8)
         {
            _loc3_.hcpByte1 = "0" + _loc3_.hcpByte1;
         }
         _loc3_.hcpByte2 = param2.toString(2);
         while(_loc3_.hcpByte2.length < 8)
         {
            _loc3_.hcpByte2 = "0" + _loc3_.hcpByte2;
         }
         _loc3_.positionOpen = Boolean(param1 & 1);
         _loc3_.positionClose = Boolean(param1 & 2);
         _loc3_.optionRelais = Boolean(param1 & 4);
         _loc3_.lightBarrier = Boolean(param1 & 8);
         _loc3_.error = Boolean(param1 & 16);
         _loc3_.drivingToClose = Boolean(param1 & 32);
         _loc3_.driving = Boolean(param1 & 64);
         _loc3_.halfOpened = Boolean(param1 & 128);
         _loc3_.forecastLeadTime = Boolean(param2 & 1);
         _loc3_.learned = Boolean(param2 & 2);
         _loc3_.notReferenced = Boolean(param2 & 4);
         return _loc3_;
      }
      
      public function toString() : String
      {
         var _loc1_:* = 0;
         _loc1_ = _loc1_ | (!!this.positionOpen?1:0);
         _loc1_ = _loc1_ | (!!this.positionClose?2:0);
         _loc1_ = _loc1_ | (!!this.optionRelais?4:0);
         _loc1_ = _loc1_ | (!!this.lightBarrier?8:0);
         _loc1_ = _loc1_ | (!!this.error?16:0);
         _loc1_ = _loc1_ | (!!this.drivingToClose?32:0);
         _loc1_ = _loc1_ | (!!this.driving?64:0);
         _loc1_ = _loc1_ | (!!this.halfOpened?128:0);
         var _loc2_:* = 0;
         _loc2_ = _loc2_ | (!!this.forecastLeadTime?1:0);
         _loc2_ = _loc2_ | (!!this.learned?2:0);
         _loc2_ = _loc2_ | (!!this.notReferenced?4:0);
         return "0x" + StringHelper.fillWith(_loc1_.toString(16),"0") + " 0x" + StringHelper.fillWith(_loc2_.toString(16),"0");
      }
   }
}
