package refactor.bisecur._2_SAL.gwFirmwareFeatures
{
   import refactor.bisecur._2_SAL.gwFirmwareFeatures.userEdit.UserEditFeatures;
   
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
