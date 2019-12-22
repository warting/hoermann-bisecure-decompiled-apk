package com.isisic.remote.hoermann.skins.stateImageSkins
{
   import com.isisic.remote.hoermann.components.stateImages.StateImageBase;
   import flash.display.GraphicsPathCommand;
   import flash.geom.Rectangle;
   import mx.core.IVisualElement;
   import spark.skins.mobile.SkinnableContainerSkin;
   
   public class StateImageSkin extends SkinnableContainerSkin
   {
       
      
      protected var imageRect:IVisualElement;
      
      public function StateImageSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(isNaN(param2))
         {
            param2 = 5;
         }
         super.updateDisplayList(param1,param2);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         if(this.imageRect != (hostComponent as StateImageBase).imageRect)
         {
            this.imageRect = (hostComponent as StateImageBase).imageRect;
         }
         super.drawBackground(param1,param2);
         var _loc3_:Number = this.outlineThickness;
         var _loc4_:uint = 16777215;
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc7_:Rectangle = new Rectangle(_loc3_ / 2,_loc3_ / 2,param1 - _loc3_,param2 - _loc3_);
         var _loc8_:Number = (param1 - (this.imageRect.x + this.imageRect.width)) * 2;
         if(param1 < _loc8_ + this.imageRect.width)
         {
            (hostComponent as StateImageBase).stateHeight = (param1 - _loc8_) * (this.imageRect.height / this.imageRect.width);
         }
         _loc5_.push(GraphicsPathCommand.MOVE_TO);
         _loc6_.push(_loc7_.x);
         _loc6_.push(_loc7_.height + _loc7_.y);
         _loc5_.push(GraphicsPathCommand.LINE_TO);
         _loc6_.push(_loc7_.width + _loc7_.x);
         _loc6_.push(_loc7_.height + _loc7_.y);
         graphics.clear();
         graphics.lineStyle(_loc3_,_loc4_);
         graphics.drawPath(_loc5_,_loc6_);
         graphics.lineStyle();
      }
      
      protected function get outlineThickness() : int
      {
         if(this.imageRect != (hostComponent as StateImageBase).imageRect)
         {
            this.imageRect = (hostComponent as StateImageBase).imageRect;
         }
         var _loc1_:int = 1;
         var _loc2_:Number = 21;
         while(this.imageRect.height > _loc2_)
         {
            _loc2_ = _loc1_ * 21;
            _loc1_++;
         }
         (hostComponent as StateImageBase).outlineThickness = _loc1_;
         return _loc1_;
      }
   }
}
