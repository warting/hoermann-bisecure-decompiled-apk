package spark.skins.android4
{
   import flash.display.DisplayObject;
   import mx.core.DPIClassification;
   import spark.skins.android4.assets.CheckBox_down;
   import spark.skins.android4.assets.CheckBox_downSelected;
   import spark.skins.android4.assets.CheckBox_downSymbolSelected;
   import spark.skins.android4.assets.CheckBox_up;
   import spark.skins.android4.assets.CheckBox_upSelected;
   import spark.skins.android4.assets.CheckBox_upSymbolSelected;
   import spark.skins.mobile.supportClasses.SelectableButtonSkinBase;
   
   public class CheckBoxSkin extends SelectableButtonSkinBase
   {
      
      private static const exclusions:Array = ["labelDisplay","labelDisplayShadow"];
       
      
      protected var symbolOffsetX:Number;
      
      protected var symbolOffsetY:Number;
      
      protected var iconWidth:Number;
      
      protected var iconHeight:Number;
      
      protected var symbolWidth:Number;
      
      protected var symbolHeight:Number;
      
      public function CheckBoxSkin()
      {
         super();
         layoutPaddingLeft = 0;
         layoutPaddingRight = 0;
         layoutPaddingTop = 0;
         layoutPaddingBottom = 0;
         upIconClass = CheckBox_up;
         upSelectedIconClass = CheckBox_upSelected;
         downIconClass = CheckBox_down;
         downSelectedIconClass = CheckBox_downSelected;
         upSymbolIconClass = null;
         upSymbolIconSelectedClass = CheckBox_upSymbolSelected;
         downSymbolIconSelectedClass = CheckBox_downSymbolSelected;
         downSymbolIconClass = null;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutGap = 16;
               minWidth = 128;
               minHeight = 128;
               layoutBorderSize = 6;
               this.iconWidth = 128;
               this.iconHeight = 128;
               this.symbolWidth = 64;
               this.symbolHeight = 64;
               this.symbolOffsetX = 32;
               this.symbolOffsetY = 32;
               break;
            case DPIClassification.DPI_480:
               layoutGap = 12;
               minWidth = 96;
               minHeight = 96;
               layoutBorderSize = 4;
               this.iconWidth = 96;
               this.iconHeight = 96;
               this.symbolWidth = 48;
               this.symbolHeight = 48;
               this.symbolOffsetX = 24;
               this.symbolOffsetY = 24;
               break;
            case DPIClassification.DPI_320:
               layoutGap = 8;
               minWidth = 64;
               minHeight = 64;
               layoutBorderSize = 3;
               this.iconWidth = 64;
               this.iconHeight = 64;
               this.symbolWidth = 32;
               this.symbolHeight = 32;
               this.symbolOffsetX = 16;
               this.symbolOffsetY = 16;
               break;
            case DPIClassification.DPI_240:
               layoutGap = 6;
               minWidth = 48;
               minHeight = 48;
               layoutBorderSize = 2;
               this.iconWidth = 48;
               this.iconHeight = 48;
               this.symbolWidth = 24;
               this.symbolHeight = 24;
               this.symbolOffsetX = 12;
               this.symbolOffsetY = 12;
               break;
            case DPIClassification.DPI_120:
               layoutGap = 3;
               minWidth = 24;
               minHeight = 24;
               layoutBorderSize = 1;
               this.iconWidth = 24;
               this.iconHeight = 24;
               this.symbolWidth = 12;
               this.symbolHeight = 12;
               this.symbolOffsetX = 6;
               this.symbolOffsetY = 6;
               break;
            default:
               layoutGap = 4;
               minWidth = 32;
               minHeight = 32;
               layoutBorderSize = 2;
               this.iconWidth = 32;
               this.iconHeight = 32;
               this.symbolWidth = 16;
               this.symbolHeight = 16;
               this.symbolOffsetX = 8;
               this.symbolOffsetY = 8;
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
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         if(symbolIcon != null)
         {
            symbolIcon.width = this.symbolWidth;
            symbolIcon.height = this.symbolHeight;
         }
         var _loc1_:DisplayObject = getIconDisplay();
         if(_loc1_ != null)
         {
            _loc1_.width = this.iconWidth;
            _loc1_.height = this.iconHeight;
         }
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc3_:DisplayObject = null;
         super.layoutContents(param1,param2);
         if(symbolIcon)
         {
            _loc3_ = getIconDisplay();
            setElementPosition(symbolIcon,this.symbolOffsetX,this.symbolOffsetY);
         }
      }
   }
}
