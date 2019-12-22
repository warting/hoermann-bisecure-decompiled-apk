package com.isisic.remote.hoermann.global
{
   public final class PortTypes
   {
      
      public static const NONE:int = 0;
      
      public static const IMPULS:int = 1;
      
      public static const AUTO_CLOSE:int = 2;
      
      public static const ON_OFF:int = 3;
      
      public static const UP:int = 4;
      
      public static const DOWN:int = 5;
      
      public static const HALF:int = 6;
      
      public static const WALK:int = 7;
      
      public static const LIGHT:int = 8;
      
      public static const ON:int = 9;
      
      public static const OFF:int = 10;
      
      public static const LOCK:int = 11;
      
      public static const UNLOCK:int = 12;
      
      public static const OPEN_DOOR:int = 13;
      
      public static const LIFT:int = 14;
      
      public static const SINK:int = 15;
      
      public static const NAMES:Object = {
         1:"IMPULS",
         2:"AUTO_CLOSE",
         3:"ON_OFF",
         4:"UP",
         5:"DOWN",
         6:"HALF",
         7:"WALK",
         8:"LIGHT",
         9:"ON",
         10:"OFF",
         11:"LOCK",
         12:"UNLOCK",
         13:"OPEN_DOOR",
         14:"LIFT",
         15:"SINK"
      };
      
      private static const SORTING_RULE:Object = {
         1:0,
         8:1,
         6:2,
         7:3,
         4:4,
         5:5,
         2:6,
         3:7,
         9:8,
         10:9,
         11:10,
         12:11,
         13:12,
         14:13,
         15:14
      };
       
      
      public function PortTypes()
      {
         super();
      }
      
      public static function portArraySorting(param1:Object, param2:Object) : int
      {
         if(PortTypes.SORTING_RULE[param1.type] < PortTypes.SORTING_RULE[param2.type])
         {
            return -1;
         }
         if(PortTypes.SORTING_RULE[param1.type] > PortTypes.SORTING_RULE[param2.type])
         {
            return 1;
         }
         return 0;
      }
   }
}
