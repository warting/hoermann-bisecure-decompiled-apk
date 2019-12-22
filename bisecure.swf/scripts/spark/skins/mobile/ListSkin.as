package spark.skins.mobile
{
   import flash.display.BlendMode;
   import mx.core.ClassFactory;
   import mx.core.mx_internal;
   import spark.components.DataGroup;
   import spark.components.LabelItemRenderer;
   import spark.components.List;
   import spark.components.Scroller;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class ListSkin extends MobileSkin
   {
       
      
      public var hostComponent:List;
      
      public var scroller:Scroller;
      
      public var dataGroup:DataGroup;
      
      public function ListSkin()
      {
         super();
         minWidth = 112;
         blendMode = BlendMode.NORMAL;
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         alpha = currentState.indexOf("disabled") == -1?Number(1):Number(0.5);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VerticalLayout = null;
         if(!this.dataGroup)
         {
            _loc1_ = new VerticalLayout();
            _loc1_.requestedMinRowCount = 5;
            _loc1_.horizontalAlign = HorizontalAlign.JUSTIFY;
            _loc1_.gap = 0;
            this.dataGroup = new DataGroup();
            this.dataGroup.layout = _loc1_;
            this.dataGroup.itemRenderer = new ClassFactory(LabelItemRenderer);
         }
         if(!this.scroller)
         {
            this.scroller = new Scroller();
            this.scroller.minViewportInset = 1;
            this.scroller.hasFocusableChildren = false;
            this.scroller.ensureElementIsVisibleForSoftKeyboard = false;
            addChild(this.scroller);
         }
         if(!this.scroller.viewport)
         {
            this.scroller.viewport = this.dataGroup;
         }
      }
      
      override protected function measure() : void
      {
         measuredWidth = this.scroller.getPreferredBoundsWidth();
         measuredHeight = this.scroller.getPreferredBoundsHeight();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:int = !!getStyle("borderVisible")?1:0;
         graphics.beginFill(getStyle("contentBackgroundColor"),getStyle("contentBackgroundAlpha"));
         graphics.drawRect(_loc3_,_loc3_,param1 - 2 * _loc3_,param2 - 2 * _loc3_);
         graphics.endFill();
         if(getStyle("borderVisible"))
         {
            graphics.lineStyle(1,getStyle("borderColor"),getStyle("borderAlpha"),true);
            graphics.drawRect(0,0,param1 - 1,param2 - 1);
         }
         this.scroller.minViewportInset = _loc3_;
         setElementSize(this.scroller,param1,param2);
         setElementPosition(this.scroller,0,0);
      }
   }
}
