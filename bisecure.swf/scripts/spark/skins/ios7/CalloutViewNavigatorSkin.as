package spark.skins.ios7
{
   import flash.display.Graphics;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.core.SpriteVisualElement;
   import spark.skins.mobile.ViewNavigatorSkin;
   
   use namespace mx_internal;
   
   public class CalloutViewNavigatorSkin extends ViewNavigatorSkin
   {
       
      
      mx_internal var gap:Number;
      
      mx_internal var contentCornerRadius:Number;
      
      private var contentMask:SpriteVisualElement;
      
      public function CalloutViewNavigatorSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.contentCornerRadius = 28;
               this.gap = 48;
               break;
            case DPIClassification.DPI_480:
               this.contentCornerRadius = 14;
               this.gap = 24;
               break;
            case DPIClassification.DPI_320:
               this.contentCornerRadius = 10;
               this.gap = 16;
               break;
            case DPIClassification.DPI_240:
               this.contentCornerRadius = 7;
               this.gap = 12;
               break;
            case DPIClassification.DPI_240:
               this.contentCornerRadius = 4;
               this.gap = 6;
               break;
            default:
               this.contentCornerRadius = 5;
               this.gap = 8;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.contentMask = new SpriteVisualElement();
         contentGroup.mask = this.contentMask;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = Math.max(actionBar.getPreferredBoundsWidth(),contentGroup.getPreferredBoundsWidth());
         measuredHeight = actionBar.getPreferredBoundsHeight() + contentGroup.getPreferredBoundsHeight() + this.gap;
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = 0;
         if(actionBar.includeInLayout)
         {
            _loc3_ = Math.min(actionBar.getPreferredBoundsHeight(),param2);
            setElementSize(actionBar,param1,_loc3_);
            setElementPosition(actionBar,0,0);
            _loc3_ = actionBar.getLayoutBoundsHeight();
         }
         var _loc4_:Number = 0;
         if(contentGroup.includeInLayout)
         {
            _loc4_ = Math.max(param2 - _loc3_ - this.gap,0);
            setElementSize(contentGroup,param1,_loc4_);
            setElementPosition(contentGroup,0,_loc3_ + this.gap);
         }
         setElementSize(this.contentMask,param1,_loc4_);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc7_:Graphics = null;
         super.drawBackground(param1,param2);
         var _loc3_:Number = this.contentCornerRadius * 2;
         var _loc4_:Number = getStyle("contentBackgroundAlpha");
         var _loc5_:Number = contentGroup.getLayoutBoundsWidth();
         var _loc6_:Number = contentGroup.getLayoutBoundsHeight();
         graphics.beginFill(getStyle("contentBackgroundColor"),_loc4_);
         graphics.endFill();
         if(this.contentMask)
         {
            _loc7_ = this.contentMask.graphics;
            _loc7_.clear();
            _loc7_.beginFill(0,1);
            _loc7_.drawRoundRect(0,0,_loc5_,_loc6_,_loc3_,_loc3_);
            _loc7_.endFill();
         }
      }
   }
}
