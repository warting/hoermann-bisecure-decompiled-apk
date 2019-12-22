package
{
   import com.isisic.remote.hoermann.views.options.settings.user.EditUsersScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_settings_user_EditUsersScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_settings_user_EditUsersScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EditUsersScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_settings_user_EditUsersScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[4]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[8] = new PropertyWatcher("provider",{"propertyChange":true},[param4[6]],param2);
         param5[6] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[5]],param2);
         param5[7] = new PropertyWatcher("height",{"heightChanged":true},[param4[5]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[8].updateParent(param1);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
      }
   }
}
