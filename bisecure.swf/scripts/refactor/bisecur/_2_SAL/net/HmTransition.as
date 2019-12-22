package refactor.bisecur._2_SAL.net
{
   import com.isisic.remote.lw.net.lw_network;
   import me.mweber.basic.helper.StringHelper;
   
   public class HmTransition
   {
       
      
      public var actual:int;
      
      public var desired:int;
      
      public var driveTime:int;
      
      public var hcp:HCP;
      
      public var gk:int;
      
      public var error:Boolean;
      
      public var autoClose:Boolean;
      
      public var exst:Array;
      
      public var time:Date;
      
      lw_network var ignoreRetries:Boolean = false;
      
      public function HmTransition()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:* = "";
         var _loc2_:int = this.exst.length - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = "0x" + StringHelper.fillWith(this.exst[_loc2_].toString(16),"0",2) + " ";
            _loc2_--;
         }
         return "soll: 0x" + StringHelper.fillWith(this.actual.toString(16),"0") + " " + "ist: 0x" + StringHelper.fillWith(this.desired.toString(16),"0") + " " + "fahrzeit: 0d" + StringHelper.fillWith(this.driveTime.toString(10),"0") + " " + "gk: 0x" + StringHelper.fillWith(this.gk.toString(16),"0",4) + " " + "hcp: " + this.hcp + "exst: " + _loc1_ + "error: " + this.error + " autoClose: " + this.autoClose;
      }
   }
}
