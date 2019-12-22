package com.isisic.remote.hoermann.views.options
{
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import me.mweber.itemRenderer.RoundetTableItemRenderer;
   import spark.components.Label;
   
   public class OptionsRenderer extends RoundetTableItemRenderer
   {
       
      
      private var lblTitle:Label;
      
      public function OptionsRenderer()
      {
         super();
      }
      
      override public function get preferedMinHeight() : Number
      {
         switch(MultiDevice.screenSize)
         {
            case ScreenSizes.XXLARGE:
               return 300;
            case ScreenSizes.XLARGE:
               return 198;
            case ScreenSizes.LARGE:
               return 150;
            case ScreenSizes.NORMAL:
               return 150;
            case ScreenSizes.SMALL:
               return 150;
            default:
               return 150;
         }
      }
      
      override protected function layoutComponents(param1:Number, param2:Number) : void
      {
         super.layoutComponents(param1,param2);
         this.lblTitle.x = marginLeft + borderRadius;
         this.lblTitle.y = marginTop + (param2 - marginTop - marginBottom) / 2 - this.lblTitle.measureText("A").height / 2;
         this.lblTitle.width = param1 - marginLeft - marginRight - borderRadius * 2;
      }
      
      override public function set data(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         super.data = param1;
         this.lblTitle.text = param1.name;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblTitle = new Label();
         this.addElement(this.lblTitle);
      }
   }
}
