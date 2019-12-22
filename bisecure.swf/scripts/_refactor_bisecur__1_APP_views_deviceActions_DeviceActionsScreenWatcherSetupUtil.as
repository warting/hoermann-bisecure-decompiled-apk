package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.deviceActions.DeviceActionsScreen;
   
   public class _refactor_bisecur__1_APP_views_deviceActions_DeviceActionsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_deviceActions_DeviceActionsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DeviceActionsScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_deviceActions_DeviceActionsScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[5]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[5]],null);
         param5[13] = new PropertyWatcher("stateGroup",{"propertyChange":true},[param4[13]],param2);
         param5[15] = new PropertyWatcher("y",{"yChanged":true},[param4[13]],null);
         param5[14] = new PropertyWatcher("height",{"heightChanged":true},[param4[13]],null);
         param5[16] = new PropertyWatcher("buttonGroup",{"propertyChange":true},[param4[14]],param2);
         param5[18] = new PropertyWatcher("y",{"yChanged":true},[param4[14]],null);
         param5[17] = new PropertyWatcher("height",{"heightChanged":true},[param4[14]],null);
         param5[3] = new PropertyWatcher("contentMargin",{"propertyChange":true},[param4[3],param4[4],param4[5]],param2);
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[9],param4[10],param4[11],param4[12],param4[15]],param2);
         param5[11] = new PropertyWatcher("stateName",{"dataChange":true},[param4[11]],null);
         param5[12] = new PropertyWatcher("stateValue",{"dataChange":true},[param4[12]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[10] = new PropertyWatcher("labelWidth",{"dataChange":true},[param4[10]],null);
         param5[19] = new PropertyWatcher("isRefreshEnabled",{"refreshEnabledChange":true},[param4[15]],null);
         param5[7] = new PropertyWatcher("stateImage",{"propertyChange":true},[param4[9]],null);
         param5[8] = new PropertyWatcher("imageRect",{"propertyChange":true},[param4[9]],null);
         param5[6] = new PropertyWatcher("stateMargin",{"propertyChange":true},[param4[6],param4[7],param4[8]],param2);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[13].updateParent(param1);
         param5[13].addChild(param5[15]);
         param5[13].addChild(param5[14]);
         param5[16].updateParent(param1);
         param5[16].addChild(param5[18]);
         param5[16].addChild(param5[17]);
         param5[3].updateParent(param1);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[11]);
         param5[0].addChild(param5[12]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[10]);
         param5[0].addChild(param5[19]);
         param5[0].addChild(param5[7]);
         param5[7].addChild(param5[8]);
         param5[6].updateParent(param1);
      }
   }
}
