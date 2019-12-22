package spark.skins.mobile
{
   import flash.display.DisplayObject;
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.SelectableButtonSkinBase;
   import spark.skins.mobile640.assets.CheckBox_down;
   import spark.skins.mobile640.assets.CheckBox_downSymbol;
   import spark.skins.mobile640.assets.CheckBox_downSymbolSelected;
   import spark.skins.mobile640.assets.CheckBox_up;
   import spark.skins.mobile640.assets.CheckBox_upSymbol;
   import spark.skins.mobile640.assets.CheckBox_upSymbolSelected;
   
   public class CheckBoxSkin extends SelectableButtonSkinBase
   {
      
      private static const exclusions:Array = ["labelDisplay","labelDisplayShadow"];
       
      
      public function CheckBoxSkin()
      {
         super();
         layoutPaddingLeft = 0;
         layoutPaddingRight = 0;
         layoutPaddingTop = 0;
         layoutPaddingBottom = 0;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upIconClass = spark.skins.mobile640.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile640.assets.CheckBox_up;
               downIconClass = spark.skins.mobile640.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile640.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile640.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile640.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile640.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile640.assets.CheckBox_downSymbolSelected;
               layoutGap = 40;
               minWidth = 128;
               minHeight = 128;
               layoutBorderSize = 6;
               break;
            case DPIClassification.DPI_480:
               upIconClass = spark.skins.mobile480.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile480.assets.CheckBox_up;
               downIconClass = spark.skins.mobile480.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile480.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile480.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile480.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile480.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile480.assets.CheckBox_downSymbolSelected;
               layoutGap = 30;
               minWidth = 96;
               minHeight = 96;
               layoutBorderSize = 4;
               break;
            case DPIClassification.DPI_320:
               upIconClass = spark.skins.mobile320.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile320.assets.CheckBox_up;
               downIconClass = spark.skins.mobile320.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile320.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile320.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile320.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile320.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile320.assets.CheckBox_downSymbolSelected;
               layoutGap = 20;
               minWidth = 64;
               minHeight = 64;
               layoutBorderSize = 3;
               break;
            case DPIClassification.DPI_240:
               upIconClass = spark.skins.mobile240.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile240.assets.CheckBox_up;
               downIconClass = spark.skins.mobile240.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile240.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile240.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile240.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile240.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile240.assets.CheckBox_downSymbolSelected;
               layoutGap = 15;
               minWidth = 48;
               minHeight = 48;
               layoutBorderSize = 2;
               break;
            case DPIClassification.DPI_120:
               upIconClass = spark.skins.mobile120.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile120.assets.CheckBox_up;
               downIconClass = spark.skins.mobile120.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile120.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile120.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile120.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile120.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile120.assets.CheckBox_downSymbolSelected;
               layoutGap = 8;
               minWidth = 24;
               minHeight = 24;
               layoutBorderSize = 1;
               break;
            default:
               upIconClass = spark.skins.mobile160.assets.CheckBox_up;
               upSelectedIconClass = spark.skins.mobile160.assets.CheckBox_up;
               downIconClass = spark.skins.mobile160.assets.CheckBox_down;
               downSelectedIconClass = spark.skins.mobile160.assets.CheckBox_down;
               upSymbolIconClass = spark.skins.mobile160.assets.CheckBox_upSymbol;
               upSymbolIconSelectedClass = spark.skins.mobile160.assets.CheckBox_upSymbolSelected;
               downSymbolIconClass = spark.skins.mobile160.assets.CheckBox_downSymbol;
               downSymbolIconSelectedClass = spark.skins.mobile160.assets.CheckBox_downSymbolSelected;
               layoutGap = 10;
               minWidth = 32;
               minHeight = 32;
               layoutBorderSize = 2;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:DisplayObject = getIconDisplay();
         var _loc4_:Number = layoutBorderSize * 2;
         graphics.beginFill(getStyle("chromeColor"));
         graphics.drawRoundRect(_loc3_.x + layoutBorderSize,_loc3_.y + layoutBorderSize,_loc3_.width - _loc4_,_loc3_.height - _loc4_,layoutBorderSize,layoutBorderSize);
         graphics.endFill();
      }
      
      override protected function get focusSkinExclusions() : Array
      {
         return exclusions;
      }
   }
}
