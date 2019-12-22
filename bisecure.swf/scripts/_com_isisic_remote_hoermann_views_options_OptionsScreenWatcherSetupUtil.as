package
{
   import com.isisic.remote.hoermann.views.options.OptionsScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_OptionsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_OptionsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         OptionsScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_OptionsScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[2]],param2);
         param5[3] = new PropertyWatcher("height",{"heightChanged":true},[param4[2]],null);
         param5[6] = new PropertyWatcher("optionsProvider",{"propertyChange":true},[param4[4]],param2);
         param5[4] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[3]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],null);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
         param5[6].updateParent(param1);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
      }
   }
}
