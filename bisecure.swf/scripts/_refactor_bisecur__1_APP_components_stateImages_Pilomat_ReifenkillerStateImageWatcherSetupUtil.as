package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import refactor.bisecur._1_APP.components.stateImages.Pilomat_ReifenkillerStateImage;
   
   public class _refactor_bisecur__1_APP_components_stateImages_Pilomat_ReifenkillerStateImageWatcherSetupUtil implements IWatcherSetupUtil2
   {
       
      
      public function _refactor_bisecur__1_APP_components_stateImages_Pilomat_ReifenkillerStateImageWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Pilomat_ReifenkillerStateImage.watcherSetupUtil = new _refactor_bisecur__1_APP_components_stateImages_Pilomat_ReifenkillerStateImageWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("stateContainer",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}
