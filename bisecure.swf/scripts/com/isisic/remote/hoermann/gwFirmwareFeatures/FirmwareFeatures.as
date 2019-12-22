package com.isisic.remote.hoermann.gwFirmwareFeatures
{
   import com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit.UserEditFeatures;
   
   public class FirmwareFeatures
   {
       
      
      public function FirmwareFeatures()
      {
         super();
      }
      
      public static function resetFeatures() : void
      {
         UserEditFeatures.resetFeature();
      }
   }
}
