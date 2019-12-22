package spark.skins.mobile
{
   import spark.components.ButtonBar;
   import spark.components.ButtonBarButton;
   import spark.components.DataGroup;
   import spark.components.supportClasses.ButtonBarHorizontalLayout;
   import spark.skins.mobile.supportClasses.ButtonBarButtonClassFactory;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class ButtonBarSkin extends MobileSkin
   {
       
      
      public var hostComponent:ButtonBar;
      
      public var firstButton:ButtonBarButtonClassFactory;
      
      public var lastButton:ButtonBarButtonClassFactory;
      
      public var middleButton:ButtonBarButtonClassFactory;
      
      public var dataGroup:DataGroup;
      
      public function ButtonBarSkin()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:ButtonBarHorizontalLayout = null;
         if(!this.firstButton)
         {
            this.firstButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            this.firstButton.skinClass = ButtonBarFirstButtonSkin;
         }
         if(!this.lastButton)
         {
            this.lastButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            this.lastButton.skinClass = ButtonBarLastButtonSkin;
         }
         if(!this.middleButton)
         {
            this.middleButton = new ButtonBarButtonClassFactory(ButtonBarButton);
            this.middleButton.skinClass = ButtonBarMiddleButtonSkin;
         }
         if(!this.dataGroup)
         {
            this.dataGroup = new DataGroup();
            _loc1_ = new ButtonBarHorizontalLayout();
            _loc1_.gap = 0;
            this.dataGroup.layout = _loc1_;
            addChild(this.dataGroup);
         }
      }
      
      override protected function commitCurrentState() : void
      {
         alpha = currentState == "disabled"?Number(0.5):Number(1);
      }
      
      override protected function measure() : void
      {
         measuredWidth = this.dataGroup.measuredWidth;
         measuredHeight = this.dataGroup.measuredHeight;
         measuredMinWidth = this.dataGroup.measuredMinWidth;
         measuredMinHeight = this.dataGroup.measuredMinHeight;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         setElementPosition(this.dataGroup,0,0);
         setElementSize(this.dataGroup,param1,param2);
      }
   }
}
