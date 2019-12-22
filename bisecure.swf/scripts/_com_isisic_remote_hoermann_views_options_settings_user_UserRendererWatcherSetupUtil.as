package
{
   import com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit.UserEditFeatures;
   import com.isisic.remote.hoermann.views.options.settings.user.UserRenderer;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_options_settings_user_UserRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_options_settings_user_UserRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         UserRenderer.watcherSetupUtil = new _com_isisic_remote_hoermann_views_options_settings_user_UserRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("marginRight",{"propertyChange":true},[param4[2]],param2);
         param5[9] = new StaticPropertyWatcher("feature",null,[param4[5]],null);
         param5[11] = new StaticPropertyWatcher("app",{"propertyChange":true},[param4[7]],null);
         param5[12] = new PropertyWatcher("editMode",{"propertyChange":true},[param4[7]],null);
         param5[1] = new PropertyWatcher("borderRadius",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3],param4[6]],param2);
         param5[7] = new PropertyWatcher("data",{"dataChange":true},[param4[4]],param2);
         param5[8] = new PropertyWatcher("name",null,[param4[4]],null);
         param5[3] = new PropertyWatcher("width",{"widthChanged":true},[param4[2]],param2);
         param5[6] = new PropertyWatcher("marginBottom",{"propertyChange":true},[param4[3]],param2);
         param5[0] = new PropertyWatcher("marginTop",{"propertyChange":true},[param4[0],param4[3],param4[6]],param2);
         param5[2] = new PropertyWatcher("marginLeft",{"propertyChange":true},[param4[1],param4[2]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],param2);
         param5[4].updateParent(param1);
         param5[9].updateParent(UserEditFeatures);
         param5[11].updateParent(HoermannRemote);
         param5[11].addChild(param5[12]);
         param5[1].updateParent(param1);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
         param5[3].updateParent(param1);
         param5[6].updateParent(param1);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
         param5[5].updateParent(param1);
      }
   }
}
