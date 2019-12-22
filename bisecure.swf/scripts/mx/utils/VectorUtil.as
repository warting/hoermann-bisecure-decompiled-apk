package mx.utils
{
   public class VectorUtil
   {
       
      
      public function VectorUtil()
      {
         super();
      }
      
      public static function getFirstItem(param1:Vector.<int>) : int
      {
         return param1 && param1.length?int(param1[0]):-1;
      }
      
      public static function toArrayInt(param1:Vector.<int>) : Array
      {
         return !!param1?VectorToArray(param1):[];
      }
      
      public static function toArrayObject(param1:Vector.<Object>) : Array
      {
         return !!param1?VectorToArray(param1):[];
      }
      
      private static function VectorToArray(param1:Object) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
