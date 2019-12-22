package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.skins.mobile.supportClasses.ActionBarButtonSkinBase;
   import spark.skins.mobile320.assets.TransparentNavigationButton_down;
   import spark.skins.mobile320.assets.TransparentNavigationButton_up;
   import spark.skins.mobile640.assets.TransparentActionButton_down;
   import spark.skins.mobile640.assets.TransparentActionButton_up;
   
   public class TransparentNavigationButtonSkin extends ActionBarButtonSkinBase
   {
       
      
      public function TransparentNavigationButtonSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.TransparentActionButton_up;
               downBorderSkin = spark.skins.mobile640.assets.TransparentActionButton_down;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile480.assets.TransparentActionButton_up;
               downBorderSkin = spark.skins.mobile480.assets.TransparentActionButton_down;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.TransparentNavigationButton_up;
               downBorderSkin = spark.skins.mobile320.assets.TransparentNavigationButton_down;
               break;
            default:
               upBorderSkin = spark.skins.mobile.assets.TransparentNavigationButton_up;
               downBorderSkin = spark.skins.mobile.assets.TransparentNavigationButton_down;
         }
      }
      
      override mx_internal function layoutBorder(param1:Number, param2:Number) : void
      {
         setElementSize(border,param1 + layoutBorderSize,param2);
         setElementPosition(border,0,0);
      }
   }
}
