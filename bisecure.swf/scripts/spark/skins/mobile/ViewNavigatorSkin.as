package spark.skins.mobile
{
   import spark.components.ActionBar;
   import spark.components.Group;
   import spark.components.ViewNavigator;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class ViewNavigatorSkin extends MobileSkin
   {
       
      
      public var contentGroup:Group;
      
      public var actionBar:ActionBar;
      
      public var hostComponent:ViewNavigator;
      
      private var _isOverlay:Boolean;
      
      public function ViewNavigatorSkin()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         this.contentGroup = new Group();
         this.contentGroup.id = "contentGroup";
         this.actionBar = new ActionBar();
         this.actionBar.id = "actionBar";
         addChild(this.contentGroup);
         addChild(this.actionBar);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = Math.max(this.actionBar.getPreferredBoundsWidth(),this.contentGroup.getPreferredBoundsWidth());
         if(currentState == "portraitAndOverlay" || currentState == "landscapeAndOverlay")
         {
            measuredHeight = Math.max(this.actionBar.getPreferredBoundsHeight(),this.contentGroup.getPreferredBoundsHeight());
         }
         else
         {
            measuredHeight = this.actionBar.getPreferredBoundsHeight() + this.contentGroup.getPreferredBoundsHeight();
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
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Number = 0;
         if(this.actionBar.includeInLayout)
         {
            _loc3_ = Math.min(this.actionBar.getPreferredBoundsHeight(),param2);
            this.actionBar.setLayoutBoundsSize(param1,_loc3_);
            this.actionBar.setLayoutBoundsPosition(0,0);
            _loc3_ = this.actionBar.getLayoutBoundsHeight();
            _loc4_ = !!this._isOverlay?Number(0.75):Number(1);
            this.actionBar.setStyle("backgroundAlpha",_loc4_);
         }
         if(this.contentGroup.includeInLayout)
         {
            _loc5_ = !!this._isOverlay?Number(param2):Number(Math.max(param2 - _loc3_,0));
            _loc6_ = !!this._isOverlay?Number(0):Number(_loc3_);
            this.contentGroup.setLayoutBoundsSize(param1,_loc5_);
            this.contentGroup.setLayoutBoundsPosition(0,_loc6_);
         }
      }
   }
}
