package spark.skins.ios7
{
   import spark.components.ButtonBarButton;
   import spark.components.DataGroup;
   import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
   import spark.skins.mobile.supportClasses.TabbedViewNavigatorTabBarHorizontalLayout;
   
   public class TabbedViewNavigatorTabBarSkin extends ButtonBarSkin
   {
       
      
      public function TabbedViewNavigatorTabBarSkin()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:TabbedViewNavigatorTabBarHorizontalLayout = null;
         if(!firstButton)
         {
            firstButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            firstButton.skinClass = ButtonBarFirstButtonSkin;
         }
         if(!lastButton)
         {
            lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            lastButton.skinClass = ButtonBarLastButtonSkin;
         }
         if(!middleButton)
         {
            middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            middleButton.skinClass = ButtonBarMiddleButtonSkin;
         }
         if(!dataGroup)
         {
            _loc1_ = new TabbedViewNavigatorTabBarHorizontalLayout();
            _loc1_.useVirtualLayout = false;
            dataGroup = new DataGroup();
            dataGroup.layout = _loc1_;
            addChild(dataGroup);
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:* = getStyle("backgroundAlpha");
         var _loc4_:Number = _loc3_ === undefined?Number(1):Number(getStyle("backgroundAlpha"));
         graphics.beginFill(getStyle("chromeColor"),_loc4_);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
