package refactor.logicware._2_SAL.mcp
{
   import com.isisic.remote.lw.Debug;
   import flash.utils.ByteArray;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class MCPPackage
   {
      
      private static var packagePool:Array = null;
      
      public static const BYTE_MULTIPLIER:int = 2;
      
      public static const LENGTH_SIZE:int = 2 * BYTE_MULTIPLIER;
      
      public static const TAG_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const TOKEN_SIZE:int = 4 * BYTE_MULTIPLIER;
      
      public static const COMMAND_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const CHECKSUM_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const FRAME_SIZE:int = LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE + COMMAND_SIZE + CHECKSUM_SIZE;
      
      public static var validateChecksum:Boolean = true;
       
      
      private var _isPooled:Boolean = false;
      
      public var tag:int;
      
      public var token:uint;
      
      public var command:int;
      
      public var payload:ByteArray;
      
      public var response:Boolean = false;
      
      public var validToken:Boolean = false;
      
      public function MCPPackage()
      {
         super();
      }
      
      public static function getFromPool() : MCPPackage
      {
         var _loc1_:MCPPackage = null;
         var _loc2_:int = 0;
         if(packagePool == null)
         {
            packagePool = [];
            _loc2_ = 0;
            while(_loc2_ < 5)
            {
               _loc1_ = new MCPPackage();
               _loc1_._isPooled = true;
               packagePool.push(_loc1_);
               _loc2_++;
            }
         }
         if(packagePool.length > 0)
         {
            return packagePool.pop();
         }
         return new MCPPackage();
      }
      
      public function putToPool() : Boolean
      {
         this.tag = 0;
         this.token = 0;
         this.command = 0;
         this.payload = null;
         this.response = false;
         this.validToken = false;
         if(!this._isPooled)
         {
            return false;
         }
         packagePool.push(this);
         return true;
      }
      
      public function get length() : int
      {
         var _loc1_:int = FRAME_SIZE / BYTE_MULTIPLIER;
         if(this.payload)
         {
            _loc1_ = _loc1_ + this.payload.length;
         }
         return _loc1_;
      }
      
      public function get checksum() : int
      {
         var _loc2_:int = 0;
         var _loc1_:uint = this.length;
         _loc1_ = _loc1_ + this.tag;
         _loc1_ = _loc1_ + (this.token & 255);
         _loc1_ = _loc1_ + (this.token >> 8 & 255);
         _loc1_ = _loc1_ + (this.token >> 16 & 255);
         _loc1_ = _loc1_ + (this.token >> 24 & 255);
         _loc1_ = _loc1_ + (this.command | (!!this.response?128:0));
         if(this.payload != null)
         {
            _loc2_ = this.payload.position;
            this.payload.position = 0;
            while(this.payload.bytesAvailable)
            {
               _loc1_ = _loc1_ + this.payload.readUnsignedByte();
            }
            this.payload.position = _loc2_;
         }
         _loc1_ = _loc1_ & 255;
         return _loc1_;
      }
      
      public function reset() : void
      {
         if(this.payload != null)
         {
            this.payload.position = 0;
         }
      }
      
      public function serialize() : String
      {
         var _loc3_:String = null;
         var _loc1_:String = "";
         var _loc2_:ByteArray = this._toByteArray();
         while(_loc2_.bytesAvailable)
         {
            _loc3_ = _loc2_.readUnsignedByte().toString(16);
            _loc1_ = _loc1_ + (_loc3_.length < 2?"0" + _loc3_:_loc3_);
         }
         return _loc1_.toUpperCase();
      }
      
      public function deserialize(param1:String) : MCPPackage
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         if(LENGTH_SIZE == 4)
         {
            _loc2_ = int("0x" + param1.substr(0,LENGTH_SIZE));
         }
         else if(LENGTH_SIZE == 2)
         {
            _loc2_ = int("0x" + param1.substr(0,LENGTH_SIZE));
         }
         this.tag = int("0x" + param1.substr(LENGTH_SIZE,TAG_SIZE));
         this.token = int("0x" + param1.substr(LENGTH_SIZE + TAG_SIZE,TOKEN_SIZE));
         this.command = int("0x" + param1.substr(LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE,COMMAND_SIZE));
         if((this.command & 128) == 128)
         {
            this.response = true;
            this.command = this.command & ~128;
         }
         var _loc3_:int = LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE + COMMAND_SIZE;
         this.payload = new ByteArray();
         var _loc5_:int = _loc3_;
         while(_loc5_ < _loc3_ + (_loc2_ - FRAME_SIZE / BYTE_MULTIPLIER) * BYTE_MULTIPLIER)
         {
            _loc4_ = int("0x" + param1.substr(_loc5_,BYTE_MULTIPLIER));
            this.payload.writeByte(_loc4_);
            _loc5_ = _loc5_ + 2;
         }
         this.payload.position = 0;
         return this;
      }
      
      private function _toByteArray() : ByteArray
      {
         var _loc3_:String = null;
         var _loc1_:ByteArray = new ByteArray();
         if(LENGTH_SIZE == 4)
         {
            if(this.length > 65535)
            {
               Debug.warning("Can not convert MCPPackage to ByteArray: To Large (max size: 0d255 actual size: 0d" + this.length + ")");
               return null;
            }
            _loc1_.writeShort(this.length);
         }
         else if(LENGTH_SIZE == 2)
         {
            if(this.length > 255)
            {
               Debug.warning("Can not convert MCPPackage to ByteArray: To Large (max size: 0d255 actual size: 0d" + this.length + ")");
               return null;
            }
            _loc1_.writeByte(this.length);
         }
         _loc1_.writeByte(this.tag);
         _loc1_.writeUnsignedInt(this.token);
         if(this.response)
         {
            _loc1_.writeByte(this.command | 128);
         }
         else
         {
            _loc1_.writeByte(this.command);
         }
         if(this.payload != null)
         {
            this.payload.position = 0;
            _loc1_.writeBytes(this.payload);
         }
         _loc1_.writeByte(this.checksum);
         _loc1_.position = 0;
         var _loc2_:String = "";
         while(_loc1_.bytesAvailable)
         {
            _loc3_ = _loc1_.readUnsignedByte().toString(16).toUpperCase();
            _loc2_ = _loc2_ + ("0x" + (_loc3_.length < 2?"0" + _loc3_:_loc3_) + " ");
         }
         _loc1_.position = 0;
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:* = int(this.command);
         var _loc2_:String = MCPCommands.NAMES[_loc1_];
         if(this.response)
         {
            _loc1_ = _loc1_ & 128;
         }
         return "[MCPPackage: " + "tag=\'" + this.tag.toString(16) + "\' " + "token=\'" + this.token.toString(16) + "\' " + "command=\'" + _loc2_ + " (" + StringHelper.int2hex(_loc1_) + ")\' " + "payload=\'" + StringHelper.byteArray2hex(this.payload) + "\' " + "]";
      }
      
      public function clear() : void
      {
         this.response = false;
         this.tag = 0;
         this.token = 0;
      }
   }
}
