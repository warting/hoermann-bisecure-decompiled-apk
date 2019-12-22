package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.settings.subSettings.WifiSettingsScreen;
   
   public class _refactor_bisecur__1_APP_views_settings_subSettings_WifiSettingsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_settings_subSettings_WifiSettingsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         WifiSettingsScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_settings_subSettings_WifiSettingsScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[1]],param2);
         param5[2] = new PropertyWatcher("height",{"heightChanged":true},[param4[1]],null);
         param5[7] = new PropertyWatcher("btnScan",{"propertyChange":true},[param4[6]],param2);
         param5[8] = new PropertyWatcher("height",{"heightChanged":true},[param4[6]],null);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[2]);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
      }
   }
}
