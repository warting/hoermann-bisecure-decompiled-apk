package spark.skins.mobile
{
   import spark.components.Group;
   import spark.components.SkinnableContainer;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class SkinnableContainerSkin extends MobileSkin
   {
       
      
      public var contentGroup:Group;
      
      public var hostComponent:SkinnableContainer;
      
      public function SkinnableContainerSkin()
      {
         super();
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         alpha = currentState.indexOf("disabled") == -1?Number(1):Number(0.5);
      }
      
      override protected function createChildren() : void
      {
         this.contentGroup = new Group();
         this.contentGroup.id = "contentGroup";
         this.contentGroup.left = this.contentGroup.right = this.contentGroup.top = this.contentGroup.bottom = 0;
         this.contentGroup.minWidth = this.contentGroup.minHeight = 0;
         addChild(this.contentGroup);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = this.contentGroup.getPreferredBoundsWidth();
         measuredHeight = this.contentGroup.getPreferredBoundsHeight();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         this.contentGroup.setLayoutBoundsSize(param1,param2);
         this.contentGroup.setLayoutBoundsPosition(0,0);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         graphics.beginFill(getStyle("backgroundColor"),getStyle("backgroundAlpha"));
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
