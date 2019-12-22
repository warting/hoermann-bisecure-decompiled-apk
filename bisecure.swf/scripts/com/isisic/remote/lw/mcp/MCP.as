package com.isisic.remote.lw.mcp
{
   import com.isisic.remote.lw.Debug;
   import flash.utils.ByteArray;
   
   public class MCP
   {
      
      public static const BYTE_MULTIPLIER:int = 2;
      
      public static const ADDRESS_SIZE:int = 6 * BYTE_MULTIPLIER;
      
      public static const LENGTH_SIZE:int = 2 * BYTE_MULTIPLIER;
      
      public static const TAG_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const TOKEN_SIZE:int = 4 * BYTE_MULTIPLIER;
      
      public static const COMMAND_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const CHECKSUM_SIZE:int = 1 * BYTE_MULTIPLIER;
      
      public static const FRAME_SIZE:int = LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE + COMMAND_SIZE + CHECKSUM_SIZE;
      
      public static const TMCP_MIN_SIZE:int = MCP.ADDRESS_SIZE * 2 + MCP.FRAME_SIZE + 2;
      
      public static var validateChecksum:Boolean = true;
       
      
      public var tag:int;
      
      public var token:uint;
      
      public var command:int;
      
      public var payload:ByteArray;
      
      public var response:Boolean = false;
      
      public var validToken:Boolean = false;
      
      public function MCP()
      {
         super();
      }
      
      public static function fromByteArray(param1:ByteArray) : MCP
      {
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc2_:String = "";
         while(param1.bytesAvailable)
         {
            _loc6_ = param1.readUnsignedByte().toString(16).toUpperCase();
            _loc2_ = _loc2_ + ("0x" + (_loc6_.length < 2?"0" + _loc6_:_loc6_) + " ");
         }
         param1.position = 0;
         var _loc3_:int = param1.bytesAvailable;
         if(LENGTH_SIZE == 4)
         {
            _loc7_ = param1.readUnsignedByte();
            _loc8_ = param1.readUnsignedByte();
            _loc4_ = (_loc7_ << 8) + _loc8_;
         }
         else if(LENGTH_SIZE == 2)
         {
            _loc4_ = param1.readUnsignedByte();
         }
         var _loc5_:MCP = new MCP();
         _loc5_.tag = param1.readUnsignedByte();
         _loc5_.token = param1.readUnsignedInt();
         _loc5_.command = param1.readUnsignedByte();
         if((_loc5_.command & 128) == 128)
         {
            _loc5_.response = true;
            _loc5_.command = _loc5_.command & ~128;
         }
         if(_loc3_ > FRAME_SIZE / BYTE_MULTIPLIER)
         {
            _loc5_.payload = new ByteArray();
            param1.readBytes(_loc5_.payload,0,_loc3_ - FRAME_SIZE / BYTE_MULTIPLIER);
         }
         if(MCP.validateChecksum)
         {
            _loc9_ = param1.readUnsignedByte();
            if(_loc5_.checksum != _loc9_)
            {
               _loc10_ = _loc5_.checksum.toString(16).toUpperCase();
               _loc10_ = "0x" + (_loc10_.length < 2?"0":"") + _loc10_;
               _loc11_ = _loc9_.toString(16).toUpperCase();
               _loc11_ = "0x" + (_loc11_.length < 2?"0":"") + _loc11_;
               Debug.warning("MCP checksum validation failed!" + "(Calculated Checksum: " + _loc10_ + "  received Checksum: " + _loc11_ + ")");
               return null;
            }
         }
         return _loc5_;
      }
      
      public static function fromString(param1:String) : MCP
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         if(LENGTH_SIZE == 4)
         {
            _loc2_ = int("0x" + param1.substr(0,LENGTH_SIZE));
         }
         else if(LENGTH_SIZE == 2)
         {
            _loc2_ = int("0x" + param1.substr(0,LENGTH_SIZE));
         }
         var _loc3_:MCP = new MCP();
         _loc3_.tag = int("0x" + param1.substr(LENGTH_SIZE,TAG_SIZE));
         _loc3_.token = int("0x" + param1.substr(LENGTH_SIZE + TAG_SIZE,TOKEN_SIZE));
         _loc3_.command = int("0x" + param1.substr(LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE,COMMAND_SIZE));
         if((_loc3_.command & 128) == 128)
         {
            _loc3_.response = true;
            _loc3_.command = _loc3_.command & ~128;
         }
         var _loc4_:int = LENGTH_SIZE + TAG_SIZE + TOKEN_SIZE + COMMAND_SIZE;
         _loc3_.payload = new ByteArray();
         var _loc6_:int = _loc4_;
         while(_loc6_ < _loc4_ + (_loc2_ - FRAME_SIZE / BYTE_MULTIPLIER) * BYTE_MULTIPLIER)
         {
            _loc5_ = int("0x" + param1.substr(_loc6_,BYTE_MULTIPLIER));
            _loc3_.payload.writeByte(_loc5_);
            _loc6_ = _loc6_ + 2;
         }
         _loc3_.payload.position = 0;
         return _loc3_;
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
      
      public function toByteArray() : ByteArray
      {
         var _loc3_:String = null;
         var _loc1_:ByteArray = new ByteArray();
         if(LENGTH_SIZE == 4)
         {
            if(this.length > 65535)
            {
               Debug.warning("Can not convert MCP to ByteArray: To Large (max size: 0d255 actual size: 0d" + this.length + ")");
               return null;
            }
            _loc1_.writeShort(this.length);
         }
         else if(LENGTH_SIZE == 2)
         {
            if(this.length > 255)
            {
               Debug.warning("Can not convert MCP to ByteArray: To Large (max size: 0d255 actual size: 0d" + this.length + ")");
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
         var _loc3_:String = null;
         var _loc1_:String = "";
         var _loc2_:ByteArray = this.toByteArray();
         while(_loc2_.bytesAvailable)
         {
            _loc3_ = _loc2_.readUnsignedByte().toString(16).toUpperCase();
            _loc1_ = _loc1_ + (_loc3_.length < 2?"0" + _loc3_:_loc3_);
         }
         return _loc1_;
      }
      
      public function clear() : void
      {
         this.response = false;
         this.tag = 0;
         this.token = 0;
      }
   }
}
