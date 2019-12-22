package
{
   import com.isisic.remote.hoermann.components.stateImages.Pilomat_DurchfahrtssperreStateImage;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_isisic_remote_hoermann_components_stateImages_Pilomat_DurchfahrtssperreStateImageWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _com_isisic_remote_hoermann_components_stateImages_Pilomat_DurchfahrtssperreStateImageWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Pilomat_DurchfahrtssperreStateImage.watcherSetupUtil = new _com_isisic_remote_hoermann_components_stateImages_Pilomat_DurchfahrtssperreStateImageWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("stateContainer",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}
