package spark.skins.mobile
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.TabbedViewNavigatorTabBarTabSkinBase;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_down;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_selected;
   import spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_up;
   
   public class TabbedViewNavigatorTabBarLastTabSkin extends TabbedViewNavigatorTabBarTabSkinBase
   {
       
      
      public function TabbedViewNavigatorTabBarLastTabSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile640.assets.TabbedViewNavigatorButtonBarLastButton_selected;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile480.assets.TabbedViewNavigatorButtonBarLastButton_selected;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile320.assets.TabbedViewNavigatorButtonBarLastButton_selected;
               break;
            case DPIClassification.DPI_120:
               upBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile120.assets.TabbedViewNavigatorButtonBarLastButton_selected;
               break;
            default:
               upBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarLastButton_up;
               downBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarLastButton_down;
               selectedBorderSkin = spark.skins.mobile.assets.TabbedViewNavigatorButtonBarLastButton_selected;
         }
      }
   }
}
