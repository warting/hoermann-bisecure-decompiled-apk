package
{
   import com.isisic.remote.hoermann.views.gateways.GatewayScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_gateways_GatewayScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_gateways_GatewayScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GatewayScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_gateways_GatewayScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[10] = new PropertyWatcher("btnAdd",{"propertyChange":true},[param4[8],param4[11]],param2);
         param5[11] = new PropertyWatcher("helpArrow",{"propertyChange":true},[param4[9],param4[14]],param2);
         param5[16] = new PropertyWatcher("width",{"widthChanged":true},[param4[14]],null);
         param5[12] = new PropertyWatcher("height",{"heightChanged":true},[param4[9]],null);
         param5[9] = new PropertyWatcher("helpAddGW",{"propertyChange":true},[param4[7],param4[10],param4[12]],param2);
         param5[13] = new PropertyWatcher("y",{"yChanged":true},[param4[10]],null);
         param5[14] = new PropertyWatcher("height",{"heightChanged":true},[param4[10]],null);
         param5[6] = new PropertyWatcher("_gatewayProvider",{"propertyChange":true},[param4[5],param4[6]],param2);
         param5[7] = new PropertyWatcher("dataProvider",{"propertyChange":true},[param4[5],param4[6]],null);
         param5[8] = new PropertyWatcher("length",{"collectionChange":true},[param4[6]],null);
         param5[4] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[4]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[15] = new PropertyWatcher("height",{"heightChanged":true},[param4[13]],param2);
         param5[10].updateParent(param1);
         param5[11].updateParent(param1);
         param5[11].addChild(param5[16]);
         param5[11].addChild(param5[12]);
         param5[9].updateParent(param1);
         param5[9].addChild(param5[13]);
         param5[9].addChild(param5[14]);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[7].addChild(param5[8]);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[15].updateParent(param1);
      }
   }
}
