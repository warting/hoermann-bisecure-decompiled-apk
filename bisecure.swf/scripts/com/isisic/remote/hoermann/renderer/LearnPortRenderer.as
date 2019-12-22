package com.isisic.remote.hoermann.renderer
{
   import flash.display.GradientType;
   import flash.geom.Matrix;
   import spark.components.LabelItemRenderer;
   
   public class LearnPortRenderer extends LabelItemRenderer
   {
       
      
      public function LearnPortRenderer()
      {
         super();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Matrix = null;
         var _loc3_:Number = getStyle("backgroundColor");
         var _loc4_:Number = getStyle("selectionColor");
         graphics.beginFill(_loc3_);
         graphics.lineStyle();
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         if(selected)
         {
            this.graphics.beginFill(_loc4_);
            this.graphics.lineStyle();
            this.graphics.drawRect(0,0,param1,param2);
            this.graphics.endFill();
         }
         else
         {
            graphics.beginFill(_loc3_);
            graphics.lineStyle();
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         if(down)
         {
            _loc5_ = [0,0];
            _loc6_ = [0.2,0.1];
            _loc7_ = [0,255];
            _loc8_ = new Matrix();
            _loc8_.createGradientBox(param1,param2,Math.PI / 2,0,0);
            graphics.beginGradientFill(GradientType.LINEAR,_loc5_,_loc6_,_loc7_,_loc8_);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         opaqueBackground = _loc3_;
         drawBorder(param1,param2);
         if(!this.enabled)
         {
            this.alpha = 0.5;
         }
      }
   }
}
