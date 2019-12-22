package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.components.popups.Toast;
   
   public class _refactor_bisecur__1_APP_components_popups_ToastWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_components_popups_ToastWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Toast.watcherSetupUtil = new _refactor_bisecur__1_APP_components_popups_ToastWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("message",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}
