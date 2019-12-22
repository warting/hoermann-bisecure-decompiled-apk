package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import spark.skins.ios7.ViewMenuSkin;
   
   public class _spark_skins_ios7_ViewMenuSkinWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _spark_skins_ios7_ViewMenuSkinWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ViewMenuSkin.watcherSetupUtil = new _spark_skins_ios7_ViewMenuSkinWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("hostComponent",{"propertyChange":true},[param4[12],param4[13]],param2);
         param5[2] = new PropertyWatcher("height",{"heightChanged":true},[param4[12],param4[13]],null);
         param5[0] = new PropertyWatcher("chromeGroup",{"propertyChange":true},[param4[0],param4[2],param4[4],param4[6],param4[8],param4[9],param4[10],param4[11],param4[12],param4[13]],param2);
         param5[3] = new PropertyWatcher("height",{"heightChanged":true},[param4[12],param4[13]],null);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[2]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[3]);
      }
   }
}
