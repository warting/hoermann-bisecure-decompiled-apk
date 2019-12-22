package com.isisic.remote.hoermann.views.channels
{
   import spark.skins.mobile.SkinnableContainerSkin;
   
   public class ChannelContentSkin extends SkinnableContainerSkin
   {
       
      
      public function ChannelContentSkin()
      {
         super();
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = this.getStyle("borderSize") !== undefined?Number(this.getStyle("borderSize")):Number(3);
         var _loc4_:uint = this.getStyle("borderColor") !== undefined?uint(this.getStyle("borderColor")):uint(0);
         var _loc5_:Number = this.getStyle("borderAlpha") !== undefined?Number(this.getStyle("borderAlpha")):Number(0.3);
         var _loc6_:Number = this.getStyle("cornerRadius") !== undefined?Number(this.getStyle("cornerRadius")):Number(30);
         graphics.lineStyle(_loc3_,_loc4_,_loc5_);
         graphics.beginFill(getStyle("bgColor"),getStyle("bgAlpha"));
         graphics.drawRoundRect(0,0,param1,param2,_loc6_);
         graphics.endFill();
      }
   }
}
