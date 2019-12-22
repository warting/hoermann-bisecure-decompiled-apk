package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.views.deviceList.renderer.DeviceListRenderer;
   
   public class _refactor_bisecur__1_APP_views_deviceList_renderer_DeviceListRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_views_deviceList_renderer_DeviceListRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DeviceListRenderer.watcherSetupUtil = new _refactor_bisecur__1_APP_views_deviceList_renderer_DeviceListRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("marginRight",{"propertyChange":true},[param4[3]],param2);
         param5[1] = new PropertyWatcher("borderRadius",{"propertyChange":true},[param4[1],param4[2],param4[3],param4[4],param4[11]],param2);
         param5[7] = new PropertyWatcher("ctrl",{"propertyChange":true},[param4[5],param4[6],param4[7],param4[8],param4[12]],param2);
         param5[15] = new PropertyWatcher("item",{"propertyChange":true},[param4[12]],null);
         param5[16] = new PropertyWatcher("rendererState",{"propertyChange":true},[param4[12]],null);
         param5[17] = new PropertyWatcher("editMode",null,[param4[12]],null);
         param5[11] = new PropertyWatcher("StateTime",{"StateTimeUpdated":true},[param4[8]],null);
         param5[10] = new PropertyWatcher("StateValue",{"propertyChange":true},[param4[7]],null);
         param5[8] = new PropertyWatcher("Name",{"propertyChange":true},[param4[5]],null);
         param5[9] = new PropertyWatcher("StateLabel",{"propertyChange":true},[param4[6]],null);
         param5[3] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],param2);
         param5[12] = new PropertyWatcher("icon",{"propertyChange":true},[param4[9]],param2);
         param5[13] = new PropertyWatcher("height",{"heightChanged":true},[param4[9]],null);
         param5[6] = new PropertyWatcher("marginBottom",{"propertyChange":true},[param4[4]],param2);
         param5[0] = new PropertyWatcher("marginTop",{"propertyChange":true},[param4[1],param4[4],param4[11]],param2);
         param5[2] = new PropertyWatcher("marginLeft",{"propertyChange":true},[param4[2],param4[3]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],param2);
         param5[4].updateParent(param1);
         param5[1].updateParent(param1);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[15]);
         param5[15].addChild(param5[16]);
         param5[16].addChild(param5[17]);
         param5[7].addChild(param5[11]);
         param5[7].addChild(param5[10]);
         param5[7].addChild(param5[8]);
         param5[7].addChild(param5[9]);
         param5[3].updateParent(param1);
         param5[12].updateParent(param1);
         param5[12].addChild(param5[13]);
         param5[6].updateParent(param1);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
         param5[5].updateParent(param1);
      }
   }
}
