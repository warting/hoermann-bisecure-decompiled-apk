package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.debug.showDaoData.ShowDaoDataScreen;
   
   public class _refactor_bisecur__1_APP_views_debug_showDaoData_ShowDaoDataScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_debug_showDaoData_ShowDaoDataScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ShowDaoDataScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_debug_showDaoData_ShowDaoDataScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[1],param4[2]],param2);
         param5[2] = new PropertyWatcher("txtOut",{"propertyChange":true},[param4[2]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[2]);
      }
   }
}
