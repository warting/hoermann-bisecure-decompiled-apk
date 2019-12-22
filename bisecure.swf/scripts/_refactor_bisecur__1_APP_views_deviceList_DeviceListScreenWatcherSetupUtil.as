package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.deviceList.DeviceListScreen;
   
   public class _refactor_bisecur__1_APP_views_deviceList_DeviceListScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_deviceList_DeviceListScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DeviceListScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_deviceList_DeviceListScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[17] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[19]],param2);
         param5[18] = new PropertyWatcher("height",{"heightChanged":true},[param4[19]],null);
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9],param4[18],param4[21],param4[22]],param2);
         param5[16] = new PropertyWatcher("AddButtonHint",{"propertyChange":true},[param4[18]],null);
         param5[21] = new PropertyWatcher("listProvider",{"propertyChange":true},[param4[21]],null);
         param5[7] = new PropertyWatcher("addButtonHintVisible",{"addButtonHelpVisible":true},[param4[9]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[22] = new PropertyWatcher("isRefreshEnabled",{"refreshEnabledChange":true},[param4[22]],null);
         param5[5] = new PropertyWatcher("isEditEnabled",{"propertyChange":true},[param4[5],param4[8]],null);
         param5[4] = new PropertyWatcher("isEditVisible",{"propertyChange":true},[param4[4],param4[7]],null);
         param5[9] = new PropertyWatcher("btnAdd",{"propertyChange":true},[param4[11],param4[14]],param2);
         param5[10] = new PropertyWatcher("helpArrow",{"propertyChange":true},[param4[12],param4[17]],param2);
         param5[15] = new PropertyWatcher("width",{"widthChanged":true},[param4[17]],null);
         param5[11] = new PropertyWatcher("height",{"heightChanged":true},[param4[12]],null);
         param5[8] = new PropertyWatcher("helpAddGW",{"propertyChange":true},[param4[10],param4[13],param4[15]],param2);
         param5[12] = new PropertyWatcher("y",{"yChanged":true},[param4[13]],null);
         param5[13] = new PropertyWatcher("height",{"heightChanged":true},[param4[13]],null);
         param5[14] = new PropertyWatcher("height",{"heightChanged":true},[param4[16]],param2);
         param5[19] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[20]],param2);
         param5[20] = new PropertyWatcher("height",{"heightChanged":true},[param4[20]],null);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[16]);
         param5[0].addChild(param5[21]);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[22]);
         param5[0].addChild(param5[5]);
         param5[0].addChild(param5[4]);
         param5[9].updateParent(param1);
         param5[10].updateParent(param1);
         param5[10].addChild(param5[15]);
         param5[10].addChild(param5[11]);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[12]);
         param5[8].addChild(param5[13]);
         param5[14].updateParent(param1);
         param5[19].updateParent(param1);
         param5[19].addChild(param5[20]);
      }
   }
}
