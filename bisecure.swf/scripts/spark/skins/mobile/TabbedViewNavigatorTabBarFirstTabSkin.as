package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.TabbedViewNavigatorTabBarTabSkinBase;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_down;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_up;
   
   public class TabbedViewNavigatorTabBarFirstTabSkin extends TabbedViewNavigatorTabBarTabSkinBase
   {
       
      
      public function TabbedViewNavigatorTabBarFirstTabSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_up;
               downBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_down;
               selectedBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarFirstButton_up;
               downBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarFirstButton_down;
               selectedBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarFirstButton_up;
               downBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarFirstButton_down;
               selectedBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
               break;
            case DPIClassification.DPI_120:
               upBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarFirstButton_up;
               downBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarFirstButton_down;
               selectedBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
               break;
            default:
               upBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarFirstButton_up;
               downBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarFirstButton_down;
               selectedBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarFirstButton_selected;
         }
      }
   }
}
