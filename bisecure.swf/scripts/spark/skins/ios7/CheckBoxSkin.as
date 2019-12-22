package spark.skins.ios7
{
   import flash.display.DisplayObject;
   import mx.core.DPIClassification;
   import spark.skins.ios7.assets.CheckBox_up;
   import spark.skins.ios7.assets.CheckBox_upSelected;
   import spark.skins.ios7.assets.CheckBox_upSymbolSelected;
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
         upSymbolIconClass = null;
         upSelectedIconClass = CheckBox_upSelected;
         upSymbolIconSelectedClass = CheckBox_upSymbolSelected;
         downIconClass = CheckBox_up;
         downSymbolIconClass = null;
         downSelectedIconClass = CheckBox_up;
         downSymbolIconSelectedClass = null;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutGap = 16;
               minWidth = 128;
               minHeight = 128;
               layoutBorderSize = 6;
               this.iconWidth = 128;
               this.iconHeight = 128;
               this.symbolWidth = 80;
               this.symbolHeight = 80;
               this.symbolOffsetX = 2;
               this.symbolOffsetY = 0;
               break;
            case DPIClassification.DPI_480:
               layoutGap = 12;
               minWidth = 96;
               minHeight = 96;
               layoutBorderSize = 4;
               this.iconWidth = 96;
               this.iconHeight = 96;
               this.symbolWidth = 60;
               this.symbolHeight = 60;
               this.symbolOffsetX = 2;
               this.symbolOffsetY = 0;
               break;
            case DPIClassification.DPI_320:
               layoutGap = 8;
               minWidth = 64;
               minHeight = 64;
               layoutBorderSize = 3;
               this.iconWidth = 64;
               this.iconHeight = 64;
               this.symbolWidth = 40;
               this.symbolHeight = 40;
               this.symbolOffsetX = 1;
               this.symbolOffsetY = 0;
               break;
            case DPIClassification.DPI_240:
               layoutGap = 6;
               minWidth = 48;
               minHeight = 48;
               layoutBorderSize = 2;
               this.iconWidth = 48;
               this.iconHeight = 48;
               this.symbolWidth = 30;
               this.symbolHeight = 30;
               this.symbolOffsetX = 0;
               this.symbolOffsetY = 0;
               break;
            case DPIClassification.DPI_120:
               layoutGap = 3;
               minWidth = 24;
               minHeight = 24;
               layoutBorderSize = 1;
               this.iconWidth = 24;
               this.iconHeight = 24;
               this.symbolWidth = 16;
               this.symbolHeight = 16;
               this.symbolOffsetX = 0;
               this.symbolOffsetY = -1;
               break;
            default:
               layoutGap = 4;
               minWidth = 32;
               minHeight = 32;
               layoutBorderSize = 2;
               this.iconWidth = 32;
               this.iconHeight = 32;
               this.symbolWidth = 20;
               this.symbolHeight = 20;
               this.symbolOffsetX = 0.5;
               this.symbolOffsetY = 0;
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
