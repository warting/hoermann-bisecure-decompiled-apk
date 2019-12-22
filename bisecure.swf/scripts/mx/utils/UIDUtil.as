package mx.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.IUIComponent;
   import mx.core.IUID;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class UIDUtil
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static const ALPHA_CHAR_CODES:Array = [48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70];
      
      private static const DASH:int = 45;
      
      private static const UIDBuffer:ByteArray = new ByteArray();
      
      private static var uidDictionary:Dictionary = new Dictionary(true);
       
      
      public function UIDUtil()
      {
         super();
      }
      
      public static function createUID() : String
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         UIDBuffer.position = 0;
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            UIDBuffer.writeByte(DASH);
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
               _loc2_++;
            }
            _loc1_++;
         }
         UIDBuffer.writeByte(DASH);
         var _loc3_:uint = new Date().getTime();
         var _loc4_:String = _loc3_.toString(16).toUpperCase();
         _loc1_ = 8;
         while(_loc1_ > _loc4_.length)
         {
            UIDBuffer.writeByte(48);
            _loc1_--;
         }
         UIDBuffer.writeUTFBytes(_loc4_);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            UIDBuffer.writeByte(ALPHA_CHAR_CODES[int(Math.random() * 16)]);
            _loc1_++;
         }
         return UIDBuffer.toString();
      }
      
      public static function fromByteArray(param1:ByteArray) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         if(param1 != null && param1.length >= 16 && param1.bytesAvailable >= 16)
         {
            UIDBuffer.position = 0;
            _loc2_ = 0;
            _loc3_ = 0;
            while(_loc3_ < 16)
            {
               if(_loc3_ == 4 || _loc3_ == 6 || _loc3_ == 8 || _loc3_ == 10)
               {
                  UIDBuffer.writeByte(DASH);
               }
               _loc4_ = param1.readByte();
               UIDBuffer.writeByte(ALPHA_CHAR_CODES[(_loc4_ & 240) >>> 4]);
               UIDBuffer.writeByte(ALPHA_CHAR_CODES[_loc4_ & 15]);
               _loc3_++;
            }
            return UIDBuffer.toString();
         }
         return null;
      }
      
      public static function isUID(param1:String) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         if(param1 != null && param1.length == 36)
         {
            _loc2_ = 0;
            while(_loc2_ < 36)
            {
               _loc3_ = param1.charCodeAt(_loc2_);
               if(_loc2_ == 8 || _loc2_ == 13 || _loc2_ == 18 || _loc2_ == 23)
               {
                  if(_loc3_ != DASH)
                  {
                     return false;
                  }
               }
               else if(_loc3_ < 48 || _loc3_ > 70 || _loc3_ > 57 && _loc3_ < 65)
               {
                  return false;
               }
               _loc2_++;
            }
            return true;
         }
         return false;
      }
      
      public static function toByteArray(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(isUID(param1))
         {
            _loc2_ = new ByteArray();
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1.charAt(_loc3_);
               if(_loc4_ != "-")
               {
                  _loc5_ = getDigit(_loc4_);
                  _loc3_++;
                  _loc6_ = getDigit(param1.charAt(_loc3_));
                  _loc2_.writeByte((_loc5_ << 4 | _loc6_) & 255);
               }
               _loc3_++;
            }
            _loc2_.position = 0;
            return _loc2_;
         }
         return null;
      }
      
      public static function getUID(param1:Object) : String
      {
         var result:String = null;
         var xitem:XML = null;
         var nodeKind:String = null;
         var notificationFunction:Function = null;
         var item:Object = param1;
         result = null;
         if(item == null)
         {
            return result;
         }
         if(item is IUID)
         {
            result = IUID(item).uid;
            if(result == null || result.length == 0)
            {
               result = createUID();
               IUID(item).uid = result;
            }
         }
         else if(item is IPropertyChangeNotifier && !(item is IUIComponent))
         {
            result = IPropertyChangeNotifier(item).uid;
            if(result == null || result.length == 0)
            {
               result = createUID();
               IPropertyChangeNotifier(item).uid = result;
            }
         }
         else
         {
            if(item is String)
            {
               return item as String;
            }
            try
            {
               if(item is XMLList && item.length == 1)
               {
                  item = item[0];
               }
               if(item is XML)
               {
                  xitem = XML(item);
                  nodeKind = xitem.nodeKind();
                  if(nodeKind == "text" || nodeKind == "attribute")
                  {
                     return xitem.toString();
                  }
                  notificationFunction = xitem.notification();
                  if(!(notificationFunction is Function))
                  {
                     notificationFunction = XMLNotifier.initializeXMLForNotification();
                     xitem.setNotification(notificationFunction);
                  }
                  if(notificationFunction["uid"] == undefined)
                  {
                     result = notificationFunction["uid"] = createUID();
                  }
                  result = notificationFunction["uid"];
               }
               else
               {
                  if("mx_internal_uid" in item)
                  {
                     return item.mx_internal_uid;
                  }
                  if("uid" in item)
                  {
                     return item.uid;
                  }
                  result = uidDictionary[item];
                  if(!result)
                  {
                     result = createUID();
                     try
                     {
                        item.mx_internal_uid = result;
                     }
                     catch(e:Error)
                     {
                        uidDictionary[item] = result;
                     }
                  }
               }
            }
            catch(e:Error)
            {
               result = item.toString();
            }
         }
         return result;
      }
      
      private static function getDigit(param1:String) : uint
      {
         switch(param1)
         {
            case "A":
            case "a":
               return 10;
            case "B":
            case "b":
               return 11;
            case "C":
            case "c":
               return 12;
            case "D":
            case "d":
               return 13;
            case "E":
            case "e":
               return 14;
            case "F":
            case "f":
               return 15;
            default:
               return new uint(param1);
         }
      }
   }
}
