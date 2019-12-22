package spark.layouts.supportClasses
{
   import mx.core.mx_internal;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class LayoutElementHelper
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function LayoutElementHelper()
      {
         super();
      }
      
      public static function pinBetween(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.min(param3,Math.max(param2,param1));
      }
      
      public static function parseConstraintValue(param1:Object) : Number
      {
         if(param1 is Number)
         {
            return Number(param1);
         }
         var _loc2_:String = param1 as String;
         if(!_loc2_)
         {
            return NaN;
         }
         var _loc3_:Array = parseConstraintExp(_loc2_);
         return _loc3_[0];
      }
      
      public static function parseConstraintExp(param1:Object, param2:Array = null) : Array
      {
         if(param1 is Number)
         {
            if(param2 == null)
            {
               return [param1 as Number,null];
            }
            param2[0] = param1 as Number;
            param2[1] = null;
            return param2;
         }
         if(!param1)
         {
            if(param2 == null)
            {
               return [NaN,null];
            }
            param2[0] = NaN;
            param2[1] = null;
            return param2;
         }
         var _loc3_:String = String(param1);
         var _loc4_:int = _loc3_.indexOf(":");
         if(_loc4_ == -1)
         {
            return [StringUtil.trim(_loc3_)];
         }
         if(param2 == null)
         {
            param2 = [];
         }
         var _loc5_:int = 0;
         while(StringUtil.isWhitespace(_loc3_.charAt(_loc5_)))
         {
            _loc5_++;
         }
         var _loc6_:int = _loc3_.length - 1;
         while(StringUtil.isWhitespace(_loc3_.charAt(_loc6_)))
         {
            _loc6_--;
         }
         var _loc7_:int = _loc4_ - 1;
         while(StringUtil.isWhitespace(_loc3_.charAt(_loc7_)))
         {
            _loc7_--;
         }
         var _loc8_:int = _loc4_ + 1;
         while(StringUtil.isWhitespace(_loc3_.charAt(_loc8_)))
         {
            _loc8_++;
         }
         param2[0] = _loc3_.substring(_loc8_,_loc6_ + 1);
         param2[1] = _loc3_.substring(_loc5_,_loc7_ + 1);
         return param2;
      }
   }
}
