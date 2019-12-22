package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.manageUsers.ManageUsersScreen;
   
   public class _refactor_bisecur__1_APP_views_manageUsers_ManageUsersScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_manageUsers_ManageUsersScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ManageUsersScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_manageUsers_ManageUsersScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[5]],param2);
         param5[6] = new PropertyWatcher("height",{"heightChanged":true},[param4[5]],null);
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4],param4[7]],param2);
         param5[9] = new PropertyWatcher("listProvider",{"propertyChange":true},[param4[7]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[7] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[6]],param2);
         param5[8] = new PropertyWatcher("height",{"heightChanged":true},[param4[6]],null);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[9]);
         param5[0].addChild(param5[1]);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
      }
   }
}
