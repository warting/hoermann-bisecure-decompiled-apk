package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.components.GatewayDisplay;
   import refactor.bisecur._2_SAL.AppCache;
   
   public class _refactor_bisecur__1_APP_components_GatewayDisplayWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_components_GatewayDisplayWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GatewayDisplay.watcherSetupUtil = new _refactor_bisecur__1_APP_components_GatewayDisplayWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new StaticPropertyWatcher("sharedCache",null,[param4[5]],null);
         param5[5] = new PropertyWatcher("connection",{"none":true},[param4[5]],null);
         param5[6] = new PropertyWatcher("isCommunicating",{"isCommunicatingChanged":true},[param4[5]],null);
         param5[1] = new PropertyWatcher("horizontalPadding",{"propertyChange":true},[param4[2],param4[3]],param2);
         param5[7] = new StaticPropertyWatcher("description",{"propertyChange":true},[param4[6]],param3);
         param5[0] = new PropertyWatcher("verticalPadding",{"propertyChange":true},[param4[0],param4[1]],param2);
         param5[2] = new PropertyWatcher("gwName",{"propertyChange":true},[param4[4]],param2);
         param5[3] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[4].updateParent(AppCache);
         param5[4].addChild(param5[5]);
         param5[5].addChild(param5[6]);
         param5[1].updateParent(param1);
         param5[7].updateParent(GatewayDisplay);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
      }
   }
}
