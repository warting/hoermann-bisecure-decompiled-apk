package
{
   import com.isisic.remote.hoermann.components.stateImages.LightStateImage;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_components_stateImages_LightStateImageWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_components_stateImages_LightStateImageWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LightStateImage.watcherSetupUtil = new _com_isisic_remote_hoermann_components_stateImages_LightStateImageWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("stateHeight",{"propertyChange":true},[param4[1],param4[2]],param2);
         param5[2] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],param2);
         param5[0] = new PropertyWatcher("stateContainer",{"propertyChange":true},[param4[0],param4[3]],param2);
         param5[3] = new PropertyWatcher("width",{"widthChanged":true},[param4[3]],null);
         param5[1].updateParent(param1);
         param5[2].updateParent(param1);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[3]);
      }
   }
}
