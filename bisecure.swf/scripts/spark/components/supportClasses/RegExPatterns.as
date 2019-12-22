package spark.components.supportClasses
{
   public final class RegExPatterns
   {
      
      public static const CONTAINS:String = "contains";
      
      public static const ENDS_WITH:String = "endsWith";
      
      public static const EXACT:String = "exact";
      
      public static const NOT:String = "not";
      
      public static const NOT_EMPTY:String = "notEmpty";
      
      public static const STARTS_WITH:String = "startsWith";
       
      
      public function RegExPatterns()
      {
         super();
      }
      
      public static function createRegExp(param1:String, param2:String = "contains") : RegExp
      {
         return new RegExp(createPatternString(param1,param2),"i");
      }
      
      public static function createPatternString(param1:String, param2:String = "contains") : String
      {
         var _loc3_:* = "";
         switch(param2)
         {
            case ENDS_WITH:
               _loc3_ = "" + param1 + "$";
               break;
            case EXACT:
               _loc3_ = "^" + param1 + "$";
               break;
            case NOT:
               _loc3_ = "^((?!" + param1 + ").)*$";
               break;
            case NOT_EMPTY:
               _loc3_ = "^." + param1 + "{1,}$";
               break;
            case STARTS_WITH:
               _loc3_ = "^" + param1 + "";
               break;
            case CONTAINS:
            default:
               _loc3_ = "" + param1 + "";
         }
         return _loc3_;
      }
   }
}
