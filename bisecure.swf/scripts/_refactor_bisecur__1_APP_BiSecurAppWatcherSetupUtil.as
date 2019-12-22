package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.BiSecurApp;
   
   public class _refactor_bisecur__1_APP_BiSecurAppWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_BiSecurAppWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BiSecurApp.watcherSetupUtil = new _refactor_bisecur__1_APP_BiSecurAppWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}
