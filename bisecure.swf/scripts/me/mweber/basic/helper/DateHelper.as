package me.mweber.basic.helper
{
   public class DateHelper
   {
       
      
      public function DateHelper()
      {
         super();
      }
      
      public static function roundToMinutes(param1:Date, param2:int) : Date
      {
         var _loc3_:Number = param1.getTime();
         var _loc4_:Number = 60000 * param2;
         var _loc5_:Number = Math.round(_loc3_ / _loc4_) * _loc4_;
         param1.setTime(_loc5_);
         return param1;
      }
   }
}
