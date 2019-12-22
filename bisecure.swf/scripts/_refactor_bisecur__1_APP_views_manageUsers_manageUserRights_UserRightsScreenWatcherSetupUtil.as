package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.manageUsers.manageUserRights.UserRightsScreen;
   
   public class _refactor_bisecur__1_APP_views_manageUsers_manageUserRights_UserRightsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_manageUsers_manageUserRights_UserRightsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         UserRightsScreen.watcherSetupUtil = new _refactor_bisecur__1_APP_views_manageUsers_manageUserRights_UserRightsScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[4]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[0] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[6]],param2);
         param5[8] = new PropertyWatcher("listProvider",{"propertyChange":true},[param4[6]],null);
         param5[3] = new PropertyWatcher("Text_Save",{"propertyChange":true},[param4[3]],null);
         param5[2] = new PropertyWatcher("Icon_Back",{"propertyChange":true},[param4[2]],null);
         param5[1] = new PropertyWatcher("Title",{"propertyChange":true},[param4[0]],null);
         param5[6] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[5]],param2);
         param5[7] = new PropertyWatcher("height",{"heightChanged":true},[param4[5]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[8]);
         param5[0].addChild(param5[3]);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[1]);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
      }
   }
}
