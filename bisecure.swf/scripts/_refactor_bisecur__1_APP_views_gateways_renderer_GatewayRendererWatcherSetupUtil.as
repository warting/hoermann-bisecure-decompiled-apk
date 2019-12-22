package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.gateways.renderer.GatewayRenderer;
   
   public class _refactor_bisecur__1_APP_views_gateways_renderer_GatewayRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_gateways_renderer_GatewayRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GatewayRenderer.watcherSetupUtil = new _refactor_bisecur__1_APP_views_gateways_renderer_GatewayRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("marginRight",{"propertyChange":true},[param4[4],param4[13]],param2);
         param5[19] = new PropertyWatcher("isDeletable",{"dataChange":true},[param4[19]],param2);
         param5[1] = new PropertyWatcher("borderRadius",{"propertyChange":true},[param4[1],param4[2],param4[3],param4[4],param4[6],param4[7],param4[8],param4[11],param4[12],param4[13],param4[17]],param2);
         param5[13] = new PropertyWatcher("btnDelete",{"propertyChange":true},[param4[15]],param2);
         param5[14] = new PropertyWatcher("visible",{
            "hide":true,
            "show":true
         },[param4[15]],null);
         param5[8] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[5],param4[9],param4[10],param4[18]],param2);
         param5[16] = new PropertyWatcher("item",{"propertyChange":true},[param4[18]],null);
         param5[17] = new PropertyWatcher("rendererState",{"propertyChange":true},[param4[18]],null);
         param5[18] = new PropertyWatcher("editMode",null,[param4[18]],null);
         param5[11] = new PropertyWatcher("host",{"propertyChange":true},[param4[10]],null);
         param5[9] = new PropertyWatcher("title",{"propertyChange":true},[param4[5]],null);
         param5[10] = new PropertyWatcher("mac",{"propertyChange":true},[param4[9]],null);
         param5[4] = new PropertyWatcher("width",{"widthChanged":true},[param4[4]],param2);
         param5[6] = new PropertyWatcher("icon",{"propertyChange":true},[param4[4],param4[14]],param2);
         param5[7] = new PropertyWatcher("width",{"widthChanged":true},[param4[4]],null);
         param5[12] = new PropertyWatcher("height",{"heightChanged":true},[param4[14]],null);
         param5[3] = new PropertyWatcher("marginBottom",{"propertyChange":true},[param4[3],param4[12]],param2);
         param5[0] = new PropertyWatcher("marginTop",{"propertyChange":true},[param4[1],param4[11],param4[17]],param2);
         param5[2] = new PropertyWatcher("marginLeft",{"propertyChange":true},[param4[2],param4[4]],param2);
         param5[5].updateParent(param1);
         param5[19].updateParent(param1);
         param5[1].updateParent(param1);
         param5[13].updateParent(param1);
         param5[13].addChild(param5[14]);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[16]);
         param5[16].addChild(param5[17]);
         param5[17].addChild(param5[18]);
         param5[8].addChild(param5[11]);
         param5[8].addChild(param5[9]);
         param5[8].addChild(param5[10]);
         param5[4].updateParent(param1);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[6].addChild(param5[12]);
         param5[3].updateParent(param1);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}
