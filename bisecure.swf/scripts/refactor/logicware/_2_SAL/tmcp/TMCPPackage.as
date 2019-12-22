package refactor.logicware._2_SAL.tmcp
{
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   
   public class TMCPPackage
   {
      
      public static const BYTE_MULTIPLIER:int = 2;
      
      public static const ADDRESS_SIZE:int = 6 * BYTE_MULTIPLIER;
      
      public static const CHECKSUM_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const TMCP_MIN_SIZE:int = ADDRESS_SIZE * 2 + MCPPackage.FRAME_SIZE + CHECKSUM_SIZE;
       
      
      public var sourceAddress:String;
      
      public var destinationAddress:String;
      
      public var mcp:MCPPackage;
      
      public function TMCPPackage()
      {
         super();
      }
      
      public function calc_checksum(param1:String = null) : int
      {
         if(param1 == null)
         {
            param1 = this._serializeInternal(false);
         }
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = int(_loc2_ + param1.charCodeAt(_loc3_));
            _loc3_++;
         }
         _loc2_ = _loc2_ & 255;
         return _loc2_;
      }
      
      public function serialize() : String
      {
         return this._serializeInternal(true);
      }
      
      public function deserialize(param1:String) : TMCPPackage
      {
         this.sourceAddress = param1.substr(0,ADDRESS_SIZE);
         this.destinationAddress = param1.substr(ADDRESS_SIZE,ADDRESS_SIZE);
         var _loc2_:int = param1.length - (ADDRESS_SIZE * 2 + CHECKSUM_SIZE);
         this.mcp = new MCPPackage().deserialize(param1.substr(ADDRESS_SIZE * 2,_loc2_));
         return this;
      }
      
      public function toString() : String
      {
         return "[TMCPPackage: src=\'" + this.sourceAddress + "\' dst=\'" + this.destinationAddress + "\' mcp=" + this.mcp + "]";
      }
      
      private function _serializeInternal(param1:Boolean) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         _loc2_ = _loc2_ + this.sourceAddress;
         _loc2_ = _loc2_ + this.destinationAddress;
         _loc2_ = _loc2_ + this.mcp.serialize();
         if(param1)
         {
            _loc3_ = this.calc_checksum(_loc2_).toString(16);
            while(_loc3_.length < 2)
            {
               _loc3_ = "0" + _loc3_;
            }
            _loc2_ = _loc2_ + _loc3_;
         }
         return _loc2_.toUpperCase();
      }
   }
}
