package spark.skins.android4
{
   import flash.display.GradientType;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.IconPlacement;
   import spark.skins.mobile640.assets.ViewMenuItem_down;
   import spark.skins.mobile640.assets.ViewMenuItem_showsCaret;
   import spark.skins.mobile640.assets.ViewMenuItem_up;
   
   use namespace mx_internal;
   
   public class ViewMenuItemSkin extends ButtonSkin
   {
       
      
      protected var showsCaretBorderSkin:Class;
      
      public function ViewMenuItemSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               upBorderSkin = spark.skins.mobile640.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile640.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile640.assets.ViewMenuItem_showsCaret;
               layoutGap = 24;
               layoutPaddingLeft = 24;
               layoutPaddingRight = 24;
               layoutPaddingTop = 24;
               layoutPaddingBottom = 24;
               layoutBorderSize = 3;
               break;
            case DPIClassification.DPI_480:
               upBorderSkin = spark.skins.mobile.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile.assets.ViewMenuItem_showsCaret;
               layoutGap = 16;
               layoutPaddingLeft = 16;
               layoutPaddingRight = 16;
               layoutPaddingTop = 16;
               layoutPaddingBottom = 16;
               layoutBorderSize = 2;
               break;
            case DPIClassification.DPI_320:
               upBorderSkin = spark.skins.mobile320.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile320.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile320.assets.ViewMenuItem_showsCaret;
               layoutGap = 12;
               layoutPaddingLeft = 12;
               layoutPaddingRight = 12;
               layoutPaddingTop = 12;
               layoutPaddingBottom = 12;
               layoutBorderSize = 2;
               break;
            case DPIClassification.DPI_240:
               upBorderSkin = spark.skins.mobile.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile.assets.ViewMenuItem_showsCaret;
               layoutGap = 8;
               layoutPaddingLeft = 8;
               layoutPaddingRight = 8;
               layoutPaddingTop = 8;
               layoutPaddingBottom = 8;
               layoutBorderSize = 1;
               break;
            case DPIClassification.DPI_120:
               upBorderSkin = spark.skins.mobile120.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile120.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile120.assets.ViewMenuItem_showsCaret;
               layoutGap = 4;
               layoutPaddingLeft = 4;
               layoutPaddingRight = 4;
               layoutPaddingTop = 4;
               layoutPaddingBottom = 4;
               layoutBorderSize = 1;
               break;
            default:
               upBorderSkin = spark.skins.mobile.assets.ViewMenuItem_up;
               downBorderSkin = spark.skins.mobile.assets.ViewMenuItem_down;
               this.showsCaretBorderSkin = spark.skins.mobile.assets.ViewMenuItem_showsCaret;
               layoutGap = 6;
               layoutPaddingLeft = 6;
               layoutPaddingRight = 6;
               layoutPaddingTop = 6;
               layoutPaddingBottom = 6;
               layoutBorderSize = 1;
         }
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         var _loc1_:Class = super.getBorderClassForCurrentState();
         if(currentState == "showsCaret")
         {
            _loc1_ = this.showsCaretBorderSkin;
         }
         return _loc1_;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc3_:String = getStyle("iconPlacement");
         useCenterAlignment = _loc3_ == IconPlacement.LEFT || _loc3_ == IconPlacement.RIGHT;
         super.layoutContents(param1,param2);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         if(currentState == "showsCaret" || currentState == "down")
         {
            graphics.beginFill(getStyle("focusColor"));
         }
         else
         {
            colorMatrix.createGradientBox(param1,param2,Math.PI / 2,0,0);
            _loc3_ = getStyle("chromeColor");
            graphics.beginGradientFill(GradientType.LINEAR,[_loc3_,_loc3_],[1,1],[0,255],colorMatrix);
         }
         graphics.drawRect(0,0,param1,param2);
         graphics.lineStyle(0.5,0,0.2);
         graphics.drawRect(0,param2,param1,0.5);
         graphics.endFill();
      }
   }
}
