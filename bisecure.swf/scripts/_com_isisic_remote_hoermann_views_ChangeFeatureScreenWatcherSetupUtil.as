package
{
   import com.isisic.remote.hoermann.views.ChangeFeatureScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_ChangeFeatureScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_ChangeFeatureScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChangeFeatureScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_ChangeFeatureScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("showChannelOnButton",{"propertyChange":true},[param4[1]],param2);
         param5[4] = new PropertyWatcher("useDevPortal",{"propertyChange":true},[param4[4]],param2);
         param5[10] = new PropertyWatcher("writeInfo",{"propertyChange":true},[param4[10]],param2);
         param5[29] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch9",{"propertyChange":true},[param4[21]],param2);
         param5[30] = new PropertyWatcher("selected",{"propertyChange":true},[param4[21]],null);
         param5[3] = new PropertyWatcher("scenarioHotfix",{"propertyChange":true},[param4[3]],param2);
         param5[27] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch8",{"propertyChange":true},[param4[20]],param2);
         param5[28] = new PropertyWatcher("selected",{"propertyChange":true},[param4[20]],null);
         param5[25] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch7",{"propertyChange":true},[param4[19]],param2);
         param5[26] = new PropertyWatcher("selected",{"propertyChange":true},[param4[19]],null);
         param5[23] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch6",{"propertyChange":true},[param4[18]],param2);
         param5[24] = new PropertyWatcher("selected",{"propertyChange":true},[param4[18]],null);
         param5[21] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch5",{"propertyChange":true},[param4[17]],param2);
         param5[22] = new PropertyWatcher("selected",{"propertyChange":true},[param4[17]],null);
         param5[12] = new PropertyWatcher("writeError",{"propertyChange":true},[param4[12]],param2);
         param5[19] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch4",{"propertyChange":true},[param4[16]],param2);
         param5[20] = new PropertyWatcher("selected",{"propertyChange":true},[param4[16]],null);
         param5[11] = new PropertyWatcher("writeWarning",{"propertyChange":true},[param4[11]],param2);
         param5[9] = new PropertyWatcher("writeDebug",{"propertyChange":true},[param4[9]],param2);
         param5[2] = new PropertyWatcher("presenterVersion",{"propertyChange":true},[param4[2]],param2);
         param5[5] = new PropertyWatcher("addDevicePortal",{"propertyChange":true},[param4[5]],param2);
         param5[7] = new PropertyWatcher("traceIn",{"propertyChange":true},[param4[7]],param2);
         param5[17] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch3",{"propertyChange":true},[param4[15]],param2);
         param5[18] = new PropertyWatcher("selected",{"propertyChange":true},[param4[15]],null);
         param5[15] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch2",{"propertyChange":true},[param4[14]],param2);
         param5[16] = new PropertyWatcher("selected",{"propertyChange":true},[param4[14]],null);
         param5[13] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch1",{"propertyChange":true},[param4[13]],param2);
         param5[14] = new PropertyWatcher("selected",{"propertyChange":true},[param4[13]],null);
         param5[33] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch11",{"propertyChange":true},[param4[23]],param2);
         param5[34] = new PropertyWatcher("selected",{"propertyChange":true},[param4[23]],null);
         param5[6] = new PropertyWatcher("enableDdns",{"propertyChange":true},[param4[6]],param2);
         param5[35] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch12",{"propertyChange":true},[param4[24]],param2);
         param5[36] = new PropertyWatcher("selected",{"propertyChange":true},[param4[24]],null);
         param5[8] = new PropertyWatcher("traceOut",{"propertyChange":true},[param4[8]],param2);
         param5[31] = new PropertyWatcher("_ChangeFeatureScreen_ToggleSwitch10",{"propertyChange":true},[param4[22]],param2);
         param5[32] = new PropertyWatcher("selected",{"propertyChange":true},[param4[22]],null);
         param5[1].updateParent(param1);
         param5[4].updateParent(param1);
         param5[10].updateParent(param1);
         param5[29].updateParent(param1);
         param5[29].addChild(param5[30]);
         param5[3].updateParent(param1);
         param5[27].updateParent(param1);
         param5[27].addChild(param5[28]);
         param5[25].updateParent(param1);
         param5[25].addChild(param5[26]);
         param5[23].updateParent(param1);
         param5[23].addChild(param5[24]);
         param5[21].updateParent(param1);
         param5[21].addChild(param5[22]);
         param5[12].updateParent(param1);
         param5[19].updateParent(param1);
         param5[19].addChild(param5[20]);
         param5[11].updateParent(param1);
         param5[9].updateParent(param1);
         param5[2].updateParent(param1);
         param5[5].updateParent(param1);
         param5[7].updateParent(param1);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
         param5[15].updateParent(param1);
         param5[15].addChild(param5[16]);
         param5[13].updateParent(param1);
         param5[13].addChild(param5[14]);
         param5[33].updateParent(param1);
         param5[33].addChild(param5[34]);
         param5[6].updateParent(param1);
         param5[35].updateParent(param1);
         param5[35].addChild(param5[36]);
         param5[8].updateParent(param1);
         param5[31].updateParent(param1);
         param5[31].addChild(param5[32]);
      }
   }
}
