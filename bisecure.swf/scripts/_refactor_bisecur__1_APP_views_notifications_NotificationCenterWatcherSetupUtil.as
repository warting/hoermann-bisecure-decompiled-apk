package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.notifications.NotificationCenter;
   import refactor.bisecur._2_SAL.AppCache;
   
   public class _refactor_bisecur__1_APP_views_notifications_NotificationCenterWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_notifications_NotificationCenterWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         NotificationCenter.watcherSetupUtil = new _refactor_bisecur__1_APP_views_notifications_NotificationCenterWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new StaticPropertyWatcher("sharedCache",null,[param4[4]],null);
         param5[6] = new PropertyWatcher("loggedIn",null,[param4[4]],null);
         param5[4] = new PropertyWatcher("provider",{"propertyChange":true},[param4[3]],param2);
         param5[2] = new PropertyWatcher("bbar",{"propertyChange":true},[param4[2]],param2);
         param5[3] = new PropertyWatcher("height",{"heightChanged":true},[param4[2]],null);
         param5[5].updateParent(AppCache);
         param5[5].addChild(param5[6]);
         param5[4].updateParent(param1);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
      }
   }
}
