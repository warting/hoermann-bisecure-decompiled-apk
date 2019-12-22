package
{
   import com.isisic.remote.hoermann.views.scenarios.ScenarioScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_scenarios_ScenarioScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_scenarios_ScenarioScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ScenarioScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_scenarios_ScenarioScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[15] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[14]],param2);
         param5[16] = new PropertyWatcher("height",{"heightChanged":true},[param4[14]],null);
         param5[7] = new PropertyWatcher("btnAdd",{"propertyChange":true},[param4[6],param4[9]],param2);
         param5[8] = new PropertyWatcher("helpArrow",{"propertyChange":true},[param4[7],param4[12]],param2);
         param5[13] = new PropertyWatcher("width",{"widthChanged":true},[param4[12]],null);
         param5[9] = new PropertyWatcher("height",{"heightChanged":true},[param4[7]],null);
         param5[6] = new PropertyWatcher("helpAddGW",{"propertyChange":true},[param4[5],param4[8],param4[10]],param2);
         param5[10] = new PropertyWatcher("y",{"yChanged":true},[param4[8]],null);
         param5[11] = new PropertyWatcher("height",{"heightChanged":true},[param4[8]],null);
         param5[4] = new PropertyWatcher("scenarioProvider",{"propertyChange":true},[param4[4],param4[16]],param2);
         param5[5] = new PropertyWatcher("length",{"collectionChange":true},[param4[4]],null);
         param5[12] = new PropertyWatcher("height",{"heightChanged":true},[param4[11]],param2);
         param5[17] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[15]],param2);
         param5[18] = new PropertyWatcher("height",{"heightChanged":true},[param4[15]],null);
         param5[15].updateParent(param1);
         param5[15].addChild(param5[16]);
         param5[7].updateParent(param1);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[13]);
         param5[8].addChild(param5[9]);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[10]);
         param5[6].addChild(param5[11]);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[12].updateParent(param1);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
      }
   }
}
