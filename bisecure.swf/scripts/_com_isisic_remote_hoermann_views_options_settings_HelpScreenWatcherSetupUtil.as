package
{
   import com.isisic.remote.hoermann.views.options.settings.HelpScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_settings_HelpScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_settings_HelpScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         HelpScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_settings_HelpScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}
