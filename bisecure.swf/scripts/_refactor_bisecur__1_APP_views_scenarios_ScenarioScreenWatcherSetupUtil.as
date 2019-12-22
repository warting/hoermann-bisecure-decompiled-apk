package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.scenarios.ScenarioScreen;
   
   public class _refactor_bisecur__1_APP_views_scenarios_ScenarioScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_scenarios_ScenarioScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ScenarioScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_scenarios_ScenarioScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[16] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[15]],param2);
         param5[17] = new PropertyWatcher("height",{"heightChanged":true},[param4[15]],null);
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4],param4[5],param4[17]],param2);
         param5[5] = new PropertyWatcher("listProvider",{"propertyChange":true},[param4[5],param4[17]],null);
         param5[6] = new PropertyWatcher("length",{"collectionChange":true},[param4[5]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[8] = new PropertyWatcher("btnAdd",{"propertyChange":true},[param4[7],param4[10]],param2);
         param5[9] = new PropertyWatcher("helpArrow",{"propertyChange":true},[param4[8],param4[13]],param2);
         param5[14] = new PropertyWatcher("width",{"widthChanged":true},[param4[13]],null);
         param5[10] = new PropertyWatcher("height",{"heightChanged":true},[param4[8]],null);
         param5[7] = new PropertyWatcher("helpAddGW",{"propertyChange":true},[param4[6],param4[9],param4[11]],param2);
         param5[11] = new PropertyWatcher("y",{"yChanged":true},[param4[9]],null);
         param5[12] = new PropertyWatcher("height",{"heightChanged":true},[param4[9]],null);
         param5[13] = new PropertyWatcher("height",{"heightChanged":true},[param4[12]],param2);
         param5[18] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[16]],param2);
         param5[19] = new PropertyWatcher("height",{"heightChanged":true},[param4[16]],null);
         param5[16].updateParent(param1);
         param5[16].addChild(param5[17]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[5]);
         param5[5].addChild(param5[6]);
         param5[0].addChild(param5[1]);
         param5[8].updateParent(param1);
         param5[9].updateParent(param1);
         param5[9].addChild(param5[14]);
         param5[9].addChild(param5[10]);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[11]);
         param5[7].addChild(param5[12]);
         param5[13].updateParent(param1);
         param5[18].updateParent(param1);
         param5[18].addChild(param5[19]);
      }
   }
}
