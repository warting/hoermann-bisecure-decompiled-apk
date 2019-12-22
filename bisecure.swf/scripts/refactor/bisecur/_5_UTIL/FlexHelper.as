package refactor.bisecur._5_UTIL
{
   import mx.core.FlexGlobals;
   import spark.components.ViewNavigator;
   import spark.components.ViewNavigatorApplication;
   
   public class FlexHelper
   {
       
      
      public function FlexHelper()
      {
         super();
      }
      
      public static function getNavigator() : ViewNavigator
      {
         var _loc1_:ViewNavigator = null;
         if(FlexGlobals.topLevelApplication is ViewNavigatorApplication)
         {
            _loc1_ = (FlexGlobals.topLevelApplication as ViewNavigatorApplication).navigator;
         }
         return _loc1_;
      }
   }
}
