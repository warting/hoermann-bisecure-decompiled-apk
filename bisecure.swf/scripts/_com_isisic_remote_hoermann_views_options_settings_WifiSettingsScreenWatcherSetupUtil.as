package
{
   import com.isisic.remote.hoermann.views.options.settings.WifiSettingsScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_settings_WifiSettingsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_settings_WifiSettingsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         WifiSettingsScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_settings_WifiSettingsScreenWatcherSetupUtil();
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
