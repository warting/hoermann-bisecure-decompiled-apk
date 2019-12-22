package
{
   import com.isisic.remote.hoermann.views.gateways.SelectGateway;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_gateways_SelectGatewayWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_gateways_SelectGatewayWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SelectGateway.watcherSetupUtil = new _com_isisic_remote_hoermann_views_gateways_SelectGatewayWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("gateways",{"propertyChange":true},[param4[4]],param2);
         param5[3] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],null);
         param5[5].updateParent(param1);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
      }
   }
}
