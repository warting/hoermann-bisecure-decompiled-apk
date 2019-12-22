package mx.utils
{
   import mx.collections.IList;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ArrayUtil
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function toArray(param1:Object) : Array
      {
         if(param1 == null)
         {
            return [];
         }
         if(param1 is Array)
         {
            return param1 as Array;
         }
         if(param1 is IList)
         {
            return (param1 as IList).toArray();
         }
         return [param1];
      }
      
      public static function getItemIndex(param1:Object, param2:Array) : int
      {
         var _loc3_:int = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param2[_loc4_] === param1)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function arraysMatch(param1:Array, param2:Array, param3:Boolean = true) : Boolean
      {
         var _loc6_:String = null;
         if(!param1 || !param2)
         {
            return false;
         }
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc4_:Array = ObjectUtil.getEnumerableProperties(param1);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(!param2.hasOwnProperty(_loc6_))
            {
               return false;
            }
            if(param3 && param1[_loc6_] !== param2[_loc6_])
            {
               return false;
            }
            if(!param3 && param1[_loc6_] != param2[_loc6_])
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }
      
      public static function arrayValuesMatch(param1:Array, param2:Array, param3:Boolean = true) : Boolean
      {
         if(!param1 || !param2)
         {
            return false;
         }
         var _loc4_:Array = getArrayValues(param1);
         _loc4_.sort();
         var _loc5_:Array = getArrayValues(param2);
         _loc5_.sort();
         return arraysMatch(_loc4_,_loc5_,param3);
      }
      
      public static function getArrayValues(param1:Array) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = [];
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:Array = ObjectUtil.getEnumerableProperties(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc2_.push(param1[_loc4_]);
         }
         return _loc2_;
      }
   }
}
