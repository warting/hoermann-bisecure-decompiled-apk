package
{
   import com.isisic.remote.hoermann.views.gateways.GatewayRenderer;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_gateways_GatewayRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_gateways_GatewayRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GatewayRenderer.watcherSetupUtil = new _com_isisic_remote_hoermann_views_gateways_GatewayRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("marginRight",{"propertyChange":true},[param4[3],param4[9]],param2);
         param5[14] = new PropertyWatcher("isDeletable",{"dataChange":true},[param4[15]],param2);
         param5[12] = new StaticPropertyWatcher("app",{"propertyChange":true},[param4[14]],null);
         param5[13] = new PropertyWatcher("editMode",{"propertyChange":true},[param4[14]],null);
         param5[1] = new PropertyWatcher("borderRadius",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9],param4[13]],param2);
         param5[9] = new PropertyWatcher("btnDelete",{"propertyChange":true},[param4[11]],param2);
         param5[10] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param4[11]],null);
         param5[4] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],param2);
         param5[6] = new PropertyWatcher("icon",{"propertyChange":true},[param4[3],param4[10]],param2);
         param5[7] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],null);
         param5[8] = new PropertyWatcher("height",{"heightChanged":true},[param4[10]],null);
         param5[3] = new PropertyWatcher("marginBottom",{"propertyChange":true},[param4[2],param4[8]],param2);
         param5[0] = new PropertyWatcher("marginTop",{"propertyChange":true},[param4[0],param4[7],param4[13]],param2);
         param5[2] = new PropertyWatcher("marginLeft",{"propertyChange":true},[param4[1],param4[3]],param2);
         param5[5].updateParent(param1);
         param5[14].updateParent(param1);
         param5[12].updateParent(HoermannRemote);
         param5[12].addChild(param5[13]);
         param5[1].updateParent(param1);
         param5[9].updateParent(param1);
         param5[9].addChild(param5[10]);
         param5[4].updateParent(param1);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[6].addChild(param5[8]);
         param5[3].updateParent(param1);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}
