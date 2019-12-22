package
{
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.views.channels.ChannelScreen;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_views_channels_ChannelScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_views_channels_ChannelScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChannelScreen.watcherSetupUtil = new _com_isisic_remote_hoermann_views_channels_ChannelScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("gwDisplay",{"propertyChange":true},[param4[4]],param2);
         param5[5] = new PropertyWatcher("height",{"heightChanged":true},[param4[4]],null);
         param5[13] = new PropertyWatcher("stateGroup",{"propertyChange":true},[param4[12]],param2);
         param5[15] = new PropertyWatcher("y",{"yChanged":true},[param4[12]],null);
         param5[14] = new PropertyWatcher("height",{"heightChanged":true},[param4[12]],null);
         param5[16] = new PropertyWatcher("buttonGroup",{"propertyChange":true},[param4[13]],param2);
         param5[18] = new PropertyWatcher("y",{"yChanged":true},[param4[13]],null);
         param5[17] = new PropertyWatcher("height",{"heightChanged":true},[param4[13]],null);
         param5[0] = new PropertyWatcher("data",{"dataChange":true},[param4[0]],param2);
         param5[1] = new PropertyWatcher("name",null,[param4[0]],null);
         param5[3] = new PropertyWatcher("contentMargin",{"propertyChange":true},[param4[2],param4[3],param4[4]],param2);
         param5[11] = new PropertyWatcher("stateName",{"dataChange":true},[param4[10]],param2);
         param5[12] = new PropertyWatcher("stateValue",{"dataChange":true},[param4[11]],param2);
         param5[10] = new PropertyWatcher("labelWidth",{"dataChange":true},[param4[9]],param2);
         param5[7] = new PropertyWatcher("stateImage",{"propertyChange":true},[param4[8]],param2);
         param5[8] = new PropertyWatcher("imageRect",{"propertyChange":true},[param4[8]],null);
         param5[19] = new StaticPropertyWatcher("defaultProcessor",{"propertyChange":true},[param4[14]],null);
         param5[20] = new PropertyWatcher("transitionCollectingActive",{"processingChanged":true},[param4[14]],null);
         param5[6] = new PropertyWatcher("stateMargin",{"propertyChange":true},[param4[5],param4[6],param4[7]],param2);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[13].updateParent(param1);
         param5[13].addChild(param5[15]);
         param5[13].addChild(param5[14]);
         param5[16].updateParent(param1);
         param5[16].addChild(param5[18]);
         param5[16].addChild(param5[17]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[3].updateParent(param1);
         param5[11].updateParent(param1);
         param5[12].updateParent(param1);
         param5[10].updateParent(param1);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
         param5[19].updateParent(HmProcessor);
         param5[19].addChild(param5[20]);
         param5[6].updateParent(param1);
      }
   }
}
