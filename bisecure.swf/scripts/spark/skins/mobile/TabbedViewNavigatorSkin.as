package spark.skins.mobile
{
   import spark.components.ButtonBar;
   import spark.components.Group;
   import spark.components.TabbedViewNavigator;
   import spark.components.supportClasses.ButtonBarBase;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class TabbedViewNavigatorSkin extends MobileSkin
   {
       
      
      public var hostComponent:TabbedViewNavigator;
      
      public var contentGroup:Group;
      
      public var tabBar:ButtonBarBase;
      
      private var _isOverlay:Boolean;
      
      public function TabbedViewNavigatorSkin()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         if(!this.contentGroup)
         {
            this.contentGroup = new Group();
            this.contentGroup.id = "contentGroup";
            addChild(this.contentGroup);
         }
         if(!this.tabBar)
         {
            this.tabBar = new ButtonBar();
            this.tabBar.id = "tabBar";
            this.tabBar.requireSelection = true;
            addChild(this.tabBar);
         }
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         this._isOverlay = currentState.indexOf("Overlay") >= 1;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = Math.max(this.tabBar.getPreferredBoundsWidth(),this.contentGroup.getPreferredBoundsWidth());
         if(currentState == "portraitAndOverlay" || currentState == "landscapeAndOverlay")
         {
            measuredHeight = Math.max(this.tabBar.getPreferredBoundsHeight(),this.contentGroup.getPreferredBoundsHeight());
         }
         else
         {
            measuredHeight = this.tabBar.getPreferredBoundsHeight() + this.contentGroup.getPreferredBoundsHeight();
         }
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Number = 0;
         if(this.tabBar.includeInLayout)
         {
            _loc3_ = Math.min(this.tabBar.getPreferredBoundsHeight(),param2);
            this.tabBar.setLayoutBoundsSize(param1,_loc3_);
            this.tabBar.setLayoutBoundsPosition(0,param2 - _loc3_);
            _loc3_ = this.tabBar.getLayoutBoundsHeight();
            _loc4_ = !!this._isOverlay?Number(0.75):Number(1);
            this.tabBar.setStyle("backgroundAlpha",_loc4_);
         }
         if(this.contentGroup.includeInLayout)
         {
            _loc5_ = !!this._isOverlay?Number(param2):Number(Math.max(param2 - _loc3_,0));
            this.contentGroup.setLayoutBoundsSize(param1,_loc5_);
            this.contentGroup.setLayoutBoundsPosition(0,0);
         }
      }
   }
}
