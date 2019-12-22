package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.scenarios.renderer.ScenarioRenderer;
   
   public class _refactor_bisecur__1_APP_views_scenarios_renderer_ScenarioRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_scenarios_renderer_ScenarioRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ScenarioRenderer.watcherSetupUtil = new _refactor_bisecur__1_APP_views_scenarios_renderer_ScenarioRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("marginRight",{"propertyChange":true},[param4[3]],param2);
         param5[1] = new PropertyWatcher("borderRadius",{"propertyChange":true},[param4[1],param4[2],param4[3],param4[4],param4[7]],param2);
         param5[7] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[5],param4[8]],param2);
         param5[9] = new PropertyWatcher("item",{"propertyChange":true},[param4[8]],null);
         param5[10] = new PropertyWatcher("rendererState",{"propertyChange":true},[param4[8]],null);
         param5[11] = new PropertyWatcher("editMode",null,[param4[8]],null);
         param5[8] = new PropertyWatcher("Title",{"propertyChange":true},[param4[5]],null);
         param5[3] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],param2);
         param5[6] = new PropertyWatcher("marginBottom",{"propertyChange":true},[param4[4]],param2);
         param5[0] = new PropertyWatcher("marginTop",{"propertyChange":true},[param4[1],param4[4],param4[7]],param2);
         param5[2] = new PropertyWatcher("marginLeft",{"propertyChange":true},[param4[2],param4[3]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],param2);
         param5[4].updateParent(param1);
         param5[1].updateParent(param1);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[9]);
         param5[9].addChild(param5[10]);
         param5[10].addChild(param5[11]);
         param5[7].addChild(param5[8]);
         param5[3].updateParent(param1);
         param5[6].updateParent(param1);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
         param5[5].updateParent(param1);
      }
   }
}
