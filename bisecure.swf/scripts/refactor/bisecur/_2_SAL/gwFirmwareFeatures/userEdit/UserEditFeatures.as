package refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.global.valueObjects.GatewayVersions;
   import refactor.bisecur._2_SAL.net.cache.metadata.GatewayMetadata;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   
   public class UserEditFeatures
   {
      
      private static var _feature:IUserEditFeature;
       
      
      public function UserEditFeatures(param1:SingletonEnforcer#153)
      {
         super();
         throw new Error("UserEditFeatures should not be initialized!");
      }
      
      public static function loadFeature(param1:Function) : void
      {
         var callback:Function = param1;
         if(_feature != null)
         {
            CallbackHelper.callCallback(callback,[_feature]);
            return;
         }
         GatewayMetadata.instance.getGatewayVersion(function(param1:Object, param2:int, param3:Error):void
         {
            if(param2 < GatewayVersions.NR_EE001425_10)
            {
               _feature = new SimpleDeleteFeature();
            }
            else
            {
               _feature = new UserCRUDFeature();
            }
            CallbackHelper.callCallback(callback,[_feature]);
         });
      }
      
      public static function resetFeature() : void
      {
         _feature = null;
      }
   }
}

class SingletonEnforcer#153
{
    
   
   function SingletonEnforcer#153()
   {
      super();
   }
}
