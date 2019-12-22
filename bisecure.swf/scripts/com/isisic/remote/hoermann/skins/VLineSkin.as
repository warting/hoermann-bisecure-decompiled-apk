package com.isisic.remote.hoermann.skins
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class VLineSkin extends MobileSkin
   {
       
      
      private var layoutContentHeight:uint;
      
      public function VLineSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_320:
               this.layoutContentHeight = 2;
               break;
            case DPIClassification.DPI_240:
               this.layoutContentHeight = 2;
               break;
            default:
               this.layoutContentHeight = 2;
         }
      }
      
      override protected function measure() : void
      {
         this.measuredHeight = this.layoutContentHeight;
         this.measuredWidth = 1;
         this.height = this.layoutContentHeight;
         this.width = 1;
         super.measure();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getStyle("foregroundColor");
         var _loc4_:uint = getStyle("backgroundColor");
         this.graphics.beginFill(_loc3_);
         this.graphics.drawRect(0,0,param1,param2 / 2);
         this.graphics.beginFill(_loc4_);
         this.graphics.drawRect(0,param2 / 2,param1,param2 / 2);
         this.graphics.endFill();
      }
   }
}
