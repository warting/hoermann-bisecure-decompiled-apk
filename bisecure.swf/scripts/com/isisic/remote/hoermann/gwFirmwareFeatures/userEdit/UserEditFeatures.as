package com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit
{
   import com.isisic.remote.hoermann.global.valueObjects.GatewayVersions;
   
   public class UserEditFeatures
   {
      
      private static var _feature:IUserEditFeature;
       
      
      public function UserEditFeatures(param1:SingletonEnforcer#178)
      {
         super();
         throw new Error("UserEditFeatures should not be initialized!");
      }
      
      public static function get feature() : IUserEditFeature
      {
         if(_feature == null)
         {
            initFeature();
         }
         return _feature;
      }
      
      public static function resetFeature() : void
      {
         _feature = null;
      }
      
      private static function initFeature() : void
      {
         if(HoermannRemote.gatewayData.softwareVersionNumber < GatewayVersions.NR_EE001425_10)
         {
            _feature = new SimpleDeleteFeature();
         }
         else
         {
            _feature = new UserCRUDFeature();
         }
      }
   }
}

class SingletonEnforcer#178
{
    
   
   function SingletonEnforcer#178()
   {
      super();
   }
}
