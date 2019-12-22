package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.home.HomeScreen;
   
   public class _refactor_bisecur__1_APP_views_home_HomeScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_home_HomeScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         HomeScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_home_HomeScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[5],param4[7],param4[9]],param2);
         param5[2] = new PropertyWatcher("LogoutText",{"propertyChange":true},[param4[2]],null);
         param5[7] = new PropertyWatcher("ActorsText",{"propertyChange":true},[param4[5]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[9] = new PropertyWatcher("OptionsText",{"propertyChange":true},[param4[9]],null);
         param5[8] = new PropertyWatcher("ScenariosText",{"propertyChange":true},[param4[7]],null);
         param5[3] = new PropertyWatcher("gwName",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("height",{"heightChanged":true},[param4[3]],null);
         param5[5] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[4]],param2);
         param5[6] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[9]);
         param5[0].addChild(param5[8]);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
      }
   }
}
