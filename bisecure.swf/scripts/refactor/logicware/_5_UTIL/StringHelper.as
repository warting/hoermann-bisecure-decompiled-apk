package refactor.logicware._5_UTIL
{
   import flash.utils.ByteArray;
   import mx.utils.StringUtil;
   
   public class StringHelper
   {
       
      
      public function StringHelper()
      {
         super();
      }
      
      public static function ValueOrDefault(param1:String, param2:String = "") : String
      {
         if(IsNullOrEmpty(param1))
         {
            return param2;
         }
         return param1;
      }
      
      public static function IsNullOrEmpty(param1:String) : *
      {
         return param1 == null || StringUtil.trim(param1) == "";
      }
      
      public static function int2hex(param1:int) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length % 2 != 0)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      public static function byteArray2hex(param1:ByteArray, param2:Boolean = false) : String
      {
         var _loc4_:String = null;
         if(param1 == null)
         {
            return "null";
         }
         param1.position = 0;
         var _loc3_:String = "";
         while(param1.bytesAvailable)
         {
            _loc4_ = param1.readUnsignedByte().toString(16);
            while(_loc4_.length < 2)
            {
               _loc4_ = "0" + _loc4_;
            }
            _loc3_ = _loc3_ + (_loc4_ + (!!param2?" ":""));
         }
         param1.position = 0;
         return _loc3_;
      }
      
      public static function startsWith(param1:String, param2:String) : Boolean
      {
         return param1.indexOf(param2) == 0;
      }
      
      public static function countChar(param1:String, param2:String) : int
      {
         return param1.split(param2).length - 1;
      }
      
      public static function createMark(... rest) : String
      {
         rest.sort(Array.NUMERIC);
         var _loc2_:* = "";
         var _loc3_:int = rest[rest.length - 1];
         var _loc4_:int = rest.shift();
         var _loc5_:int = 0;
         while(_loc5_ <= _loc3_)
         {
            if(_loc5_ == _loc4_)
            {
               _loc4_ = rest.shift();
               _loc2_ = _loc2_ + "^";
            }
            else
            {
               _loc2_ = _loc2_ + " ";
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function fillWith(param1:String, param2:String, param3:int = 2) : String
      {
         while(param1.length < param3)
         {
            param1 = param2 + param1;
         }
         return param1;
      }
      
      public static function getByteLength(param1:String) : int
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return _loc2_.length;
      }
      
      public static function unescapeString(param1:String) : String
      {
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc2_:* = "";
         var _loc3_:int = 0;
         _loc4_ = 0;
         var _loc5_:int = param1.length;
         while(true)
         {
            _loc3_ = param1.indexOf("\\",_loc4_);
            if(_loc3_ >= 0)
            {
               _loc2_ = _loc2_ + param1.substr(_loc4_,_loc3_ - _loc4_);
               _loc4_ = _loc3_ + 2;
               _loc6_ = param1.charAt(_loc3_ + 1);
               switch(_loc6_)
               {
                  case "\"":
                     _loc2_ = _loc2_ + _loc6_;
                     break;
                  case "\\":
                     _loc2_ = _loc2_ + _loc6_;
                     break;
                  case "n":
                     _loc2_ = _loc2_ + "\n";
                     break;
                  case "r":
                     _loc2_ = _loc2_ + "\r";
                     break;
                  case "t":
                     _loc2_ = _loc2_ + "\t";
                     break;
                  case "u":
                     _loc7_ = "";
                     _loc8_ = _loc4_ + 4;
                     if(_loc8_ > _loc5_)
                     {
                        parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                     }
                     _loc9_ = _loc4_;
                     while(_loc9_ < _loc8_)
                     {
                        _loc10_ = param1.charAt(_loc9_);
                        if(!isHexDigit(_loc10_))
                        {
                           parseError("Excepted a hex digit, but found: " + _loc10_);
                        }
                        _loc7_ = _loc7_ + _loc10_;
                        _loc9_++;
                     }
                     _loc2_ = _loc2_ + String.fromCharCode(parseInt(_loc7_,16));
                     _loc4_ = _loc8_;
                     break;
                  case "f":
                     _loc2_ = _loc2_ + "\f";
                     break;
                  case "/":
                     _loc2_ = _loc2_ + "/";
                     break;
                  case "b":
                     _loc2_ = _loc2_ + "\b";
                     break;
                  default:
                     _loc2_ = _loc2_ + ("\\" + _loc6_);
               }
               if(_loc4_ >= _loc5_)
               {
                  break;
               }
               continue;
            }
            _loc2_ = _loc2_ + param1.substr(_loc4_);
            break;
         }
         return _loc2_;
      }
      
      private static function isDigit(param1:String) : Boolean
      {
         return param1 >= "0" && param1 <= "9";
      }
      
      private static function isHexDigit(param1:String) : Boolean
      {
         return isDigit(param1) || param1 >= "A" && param1 <= "F" || param1 >= "a" && param1 <= "f";
      }
      
      private static function parseError(param1:String) : void
      {
         throw new Error(param1);
      }
   }
}
