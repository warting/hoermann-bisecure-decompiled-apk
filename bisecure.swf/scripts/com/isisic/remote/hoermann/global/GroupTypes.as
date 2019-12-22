package com.isisic.remote.hoermann.global
{
   public final class GroupTypes
   {
      
      public static const NONE:uint = 0;
      
      public static const SECTIONAL_DOOR:int = 1;
      
      public static const HORIZONTAL_SECTIONAL_DOOR:int = 2;
      
      public static const SWING_GATE_SINGLE:int = 3;
      
      public static const SWING_GATE_DOUBLE:int = 4;
      
      public static const SLIDING_GATE:int = 5;
      
      public static const DOOR:int = 6;
      
      public static const LIGHT:int = 7;
      
      public static const OTHER:int = 8;
      
      public static const JACK:int = 9;
      
      public static const SMARTKEY:int = 10;
      
      public static const PILOMAT_POLLER:int = 11;
      
      public static const PILOMAT_DURCHFAHRTSSPERRE:int = 12;
      
      public static const PILOMAT_HUBBALKEN:int = 13;
      
      public static const PILOMAT_REIFENKILLER:int = 14;
      
      public static const BARRIER:int = 15;
      
      public static const NAMES:Object = {
         1:"SECTIONAL_DOOR",
         2:"HORIZONTAL_SECTIONAL_DOOR",
         3:"SWING_GATE_SINGLE",
         4:"SWING_GATE_DOUBLE",
         5:"SLIDING_GATE",
         6:"DOOR",
         7:"LIGHT",
         8:"OTHER",
         9:"JACK",
         10:"SMARTKEY",
         11:"PILOMAT_POLLER",
         12:"PILOMAT_DURCHFAHRTSSPERRE",
         13:"PILOMAT_HUBBALKEN",
         14:"PILOMAT_REIFENKILLER",
         15:"BARRIER"
      };
      
      public static const PORTS:Object = {
         1:[PortTypes.IMPULS,PortTypes.UP,PortTypes.DOWN,PortTypes.HALF,PortTypes.LIGHT],
         2:[PortTypes.IMPULS,PortTypes.UP,PortTypes.DOWN,PortTypes.HALF,PortTypes.LIGHT],
         3:[PortTypes.IMPULS,PortTypes.HALF,PortTypes.UP,PortTypes.DOWN,PortTypes.LIGHT],
         4:[PortTypes.IMPULS,PortTypes.WALK,PortTypes.UP,PortTypes.DOWN,PortTypes.LIGHT],
         5:[PortTypes.IMPULS,PortTypes.UP,PortTypes.DOWN,PortTypes.HALF,PortTypes.LIGHT],
         6:[PortTypes.AUTO_CLOSE,PortTypes.IMPULS,PortTypes.LIGHT,PortTypes.ON_OFF],
         7:[PortTypes.ON,PortTypes.OFF,PortTypes.ON_OFF,PortTypes.IMPULS],
         8:[PortTypes.ON,PortTypes.OFF,PortTypes.ON_OFF,PortTypes.IMPULS],
         9:[PortTypes.ON,PortTypes.OFF,PortTypes.ON_OFF,PortTypes.IMPULS],
         10:[PortTypes.LOCK,PortTypes.UNLOCK,PortTypes.OPEN_DOOR],
         11:[PortTypes.LIFT,PortTypes.SINK],
         12:[PortTypes.LIFT,PortTypes.SINK],
         13:[PortTypes.LIFT,PortTypes.SINK],
         14:[PortTypes.LIFT,PortTypes.SINK],
         15:[PortTypes.IMPULS,PortTypes.UP,PortTypes.DOWN]
      };
      
      private static const SORTING_RULE:Array = [SECTIONAL_DOOR,HORIZONTAL_SECTIONAL_DOOR,SWING_GATE_SINGLE,SWING_GATE_DOUBLE,SLIDING_GATE,DOOR,SMARTKEY,JACK,LIGHT,PILOMAT_POLLER,PILOMAT_DURCHFAHRTSSPERRE,PILOMAT_HUBBALKEN,PILOMAT_REIFENKILLER,OTHER];
       
      
      public function GroupTypes()
      {
         super();
      }
      
      public static function groupArraySorting(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:int = SORTING_RULE.indexOf(int(param1.id));
         var _loc5_:int = SORTING_RULE.indexOf(int(param2.id));
         if(_loc4_ < _loc5_)
         {
            return -1;
         }
         if(_loc4_ > _loc5_)
         {
            return 1;
         }
         return 0;
      }
      
      public static function groupIDSorting(param1:Object, param2:Object, param3:Array = null) : int
      {
         if(param1.id < param2.id)
         {
            return -1;
         }
         if(param1.id > param2.id)
         {
            return 1;
         }
         return 0;
      }
   }
}
