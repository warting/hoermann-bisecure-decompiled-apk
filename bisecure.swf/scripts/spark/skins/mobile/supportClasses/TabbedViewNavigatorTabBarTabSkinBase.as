package spark.skins.mobile.supportClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.events.FlexEvent;
   import spark.components.ButtonBarButton;
   import spark.components.supportClasses.ButtonBase;
   import spark.components.supportClasses.ViewNavigatorBase;
   
   public class TabbedViewNavigatorTabBarTabSkinBase extends ButtonBarButtonSkinBase
   {
       
      
      public function TabbedViewNavigatorTabBarTabSkinBase()
      {
         super();
         useCenterAlignment = false;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               layoutBorderSize = 4;
               layoutPaddingTop = 24;
               layoutPaddingBottom = 24;
               layoutPaddingLeft = 24;
               layoutPaddingRight = 24;
               layoutGap = 20;
               measuredDefaultHeight = 204;
               break;
            case DPIClassification.DPI_480:
               layoutBorderSize = 3;
               layoutPaddingTop = 18;
               layoutPaddingBottom = 18;
               layoutPaddingLeft = 18;
               layoutPaddingRight = 18;
               layoutGap = 14;
               measuredDefaultHeight = 152;
               break;
            case DPIClassification.DPI_320:
               layoutBorderSize = 2;
               layoutPaddingTop = 12;
               layoutPaddingBottom = 12;
               layoutPaddingLeft = 12;
               layoutPaddingRight = 12;
               layoutGap = 10;
               measuredDefaultHeight = 102;
               break;
            case DPIClassification.DPI_240:
               layoutBorderSize = 1;
               layoutPaddingTop = 9;
               layoutPaddingBottom = 9;
               layoutPaddingLeft = 9;
               layoutPaddingRight = 9;
               layoutGap = 7;
               measuredDefaultHeight = 76;
               break;
            case DPIClassification.DPI_120:
               layoutBorderSize = 1;
               layoutPaddingTop = 5;
               layoutPaddingBottom = 5;
               layoutPaddingLeft = 5;
               layoutPaddingRight = 5;
               layoutGap = 4;
               measuredDefaultHeight = 38;
               break;
            default:
               layoutBorderSize = 1;
               layoutPaddingTop = 6;
               layoutPaddingBottom = 6;
               layoutPaddingLeft = 6;
               layoutPaddingRight = 6;
               layoutGap = 5;
               measuredDefaultHeight = 51;
         }
      }
      
      override public function set hostComponent(param1:ButtonBase) : void
      {
         if(hostComponent)
         {
            hostComponent.removeEventListener(FlexEvent.DATA_CHANGE,this.dataChanged);
         }
         super.hostComponent = param1;
         if(hostComponent)
         {
            hostComponent.addEventListener(FlexEvent.DATA_CHANGE,this.dataChanged);
            this.dataChanged();
         }
      }
      
      override protected function commitDisabled() : void
      {
         var _loc1_:Number = currentState.indexOf("disabled") >= 0?Number(0.25):Number(1);
         labelDisplay.alpha = _loc1_;
         labelDisplayShadow.alpha = _loc1_;
         var _loc2_:DisplayObject = getIconDisplay();
         if(_loc2_ != null)
         {
            _loc2_.alpha = _loc1_;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      private function dataChanged(param1:Event = null) : void
      {
         var _loc3_:ViewNavigatorBase = null;
         var _loc2_:ButtonBarButton = ButtonBarButton(hostComponent);
         if(_loc2_.data && _loc2_.data is ViewNavigatorBase)
         {
            _loc3_ = ViewNavigatorBase(_loc2_.data);
            _loc3_.addEventListener("enabledChanged",this.dataEnabledChanged);
            this.dataEnabledChanged();
         }
      }
      
      private function dataEnabledChanged(param1:Event = null) : void
      {
         hostComponent.enabled = ViewNavigatorBase(ButtonBarButton(hostComponent).data).enabled;
      }
   }
}
