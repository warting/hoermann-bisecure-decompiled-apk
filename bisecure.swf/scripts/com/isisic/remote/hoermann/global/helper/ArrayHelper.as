package com.isisic.remote.hoermann.global.helper
{
   public class ArrayHelper
   {
       
      
      public function ArrayHelper()
      {
         super();
      }
      
      public static function in_array(param1:*, param2:Array) : Boolean
      {
         return param2.indexOf(param1) >= 0;
      }
      
      public static function findByProperty(param1:String, param2:*, param3:Array) : *
      {
         var _loc4_:* = undefined;
         for each(_loc4_ in param3)
         {
            if(_loc4_[param1] == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function indexOfByProperty(param1:String, param2:*, param3:Array) : int
      {
         var _loc4_:int = 0;
         while(_loc4_ < param3.length)
         {
            if(param3[_loc4_][param1] == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function property_in_array(param1:String, param2:*, param3:Array) : Boolean
      {
         return findByProperty(param1,param2,param3) != null;
      }
      
      public static function removeItem(param1:*, param2:Array) : Boolean
      {
         var _loc3_:int = param2.indexOf(param1);
         if(_loc3_ < 0)
         {
            return false;
         }
         param2.splice(_loc3_,1);
         return true;
      }
      
      public static function removeItemByProperty(param1:String, param2:*, param3:Array) : Boolean
      {
         var _loc4_:int = indexOfByProperty(param1,param2,param3);
         if(_loc4_ < 0)
         {
            return false;
         }
         param3.splice(_loc4_,1);
         return true;
      }
      
      public static function mergeOn(param1:String, param2:Array, param3:Array) : Array
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc4_:Boolean = false;
         for each(_loc5_ in param3)
         {
            _loc4_ = false;
            for each(_loc6_ in param2)
            {
               if(_loc6_.hasOwnProperty(param1) && _loc5_.hasOwnProperty(param1) && _loc6_[param1] == _loc5_[param1])
               {
                  _loc4_ = true;
               }
            }
            if(!_loc4_)
            {
               param2.push(_loc5_);
            }
         }
         return param2;
      }
   }
}
