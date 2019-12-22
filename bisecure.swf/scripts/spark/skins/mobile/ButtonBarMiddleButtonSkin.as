package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;
   import spark.skins.mobile640.assets.ButtonBarMiddleButton_down;
   import spark.skins.mobile640.assets.ButtonBarMiddleButton_selected;
   import spark.skins.mobile640.assets.ButtonBarMiddleButton_up;
   
   public class ButtonBarMiddleButtonSkin extends ButtonBarButtonSkinBase
   {
       
      
      public function ButtonBarMiddleButtonSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile640.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile640.assets.ButtonBarMiddleButton_selected;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile480.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile480.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile480.assets.ButtonBarMiddleButton_selected;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile320.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile320.assets.ButtonBarMiddleButton_selected;
               break;
            case DPIClassification.DPI_240:
               upBorderSkin = spark.skins.mobile240.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile240.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile240.assets.ButtonBarMiddleButton_selected;
               break;
            case DPIClassification.DPI_120:
               upBorderSkin = spark.skins.mobile120.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile120.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile120.assets.ButtonBarMiddleButton_selected;
               break;
            default:
               upBorderSkin = spark.skins.mobile160.assets.ButtonBarMiddleButton_up;
               downBorderSkin = spark.skins.mobile160.assets.ButtonBarMiddleButton_down;
               selectedBorderSkin = spark.skins.mobile160.assets.ButtonBarMiddleButton_selected;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         graphics.beginFill(getStyle("chromeColor"));
         graphics.drawRoundRect(0,0,param1,param2,0,0);
         graphics.endFill();
      }
   }
}
