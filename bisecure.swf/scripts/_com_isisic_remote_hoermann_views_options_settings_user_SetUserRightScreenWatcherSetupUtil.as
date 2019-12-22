package
{
   import com.isisic.remote.hoermann.views.options.settings.user.SetUserRightScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_settings_user_SetUserRightScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_settings_user_SetUserRightScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SetUserRightScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_settings_user_SetUserRightScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],null);
         param5[7] = new PropertyWatcher("rightProvider",{"propertyChange":true},[param4[5]],param2);
         param5[5] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[4]],param2);
         param5[6] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[7].updateParent(param1);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
      }
   }
}
