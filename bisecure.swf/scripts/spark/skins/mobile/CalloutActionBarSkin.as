package spark.skins.mobile
{
   import mx.core.DPIClassification;
   
   public class CalloutActionBarSkin extends ActionBarSkin
   {
       
      
      public function CalloutActionBarSkin()
      {
         super();
         borderClass = null;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutContentGroupHeight = 108;
               break;
            case DPIClassification.DPI_480:
               layoutContentGroupHeight = 84;
               break;
            case DPIClassification.DPI_320:
               layoutContentGroupHeight = 54;
               break;
            case DPIClassification.DPI_240:
               layoutContentGroupHeight = 42;
               break;
            case DPIClassification.DPI_120:
               layoutContentGroupHeight = 21;
               break;
            default:
               layoutContentGroupHeight = 28;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
      }
   }
}
