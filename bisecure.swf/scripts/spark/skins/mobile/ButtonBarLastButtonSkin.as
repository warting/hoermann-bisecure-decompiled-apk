package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;
   import spark.skins.mobile640.assets.ButtonBarLastButton_down;
   import spark.skins.mobile640.assets.ButtonBarLastButton_selected;
   import spark.skins.mobile640.assets.ButtonBarLastButton_up;
   
   public class ButtonBarLastButtonSkin extends ButtonBarButtonSkinBase
   {
       
      
      public function ButtonBarLastButtonSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile640.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile640.assets.ButtonBarLastButton_selected;
               cornerRadius = 24;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile480.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile480.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile480.assets.ButtonBarLastButton_selected;
               cornerRadius = 16;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile320.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile320.assets.ButtonBarLastButton_selected;
               cornerRadius = 12;
               break;
            case DPIClassification.DPI_240:
               upBorderSkin = spark.skins.mobile240.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile240.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile240.assets.ButtonBarLastButton_selected;
               cornerRadius = 8;
               break;
            case DPIClassification.DPI_120:
               upBorderSkin = spark.skins.mobile120.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile120.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile120.assets.ButtonBarLastButton_selected;
               cornerRadius = 4;
               break;
            default:
               upBorderSkin = spark.skins.mobile160.assets.ButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile160.assets.ButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile160.assets.ButtonBarLastButton_selected;
               cornerRadius = 6;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         graphics.beginFill(getStyle("chromeColor"));
         graphics.drawRoundRectComplex(0,0,param1,param2,0,cornerRadius,0,cornerRadius);
         graphics.endFill();
      }
   }
}
