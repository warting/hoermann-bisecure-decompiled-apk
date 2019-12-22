package refactor.bisecur._1_APP.skins.stateImage
{
   import flash.display.GraphicsPathCommand;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import refactor.bisecur._1_APP.components.stateImages.StateImageBase;
   
   public class JackStateImageSkin extends StateImageSkin
   {
       
      
      public function JackStateImageSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:Boolean = false;
         if(imageRect != (hostComponent as StateImageBase).imageRect)
         {
            imageRect = (hostComponent as StateImageBase).imageRect;
         }
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = outlineThickness;
         var _loc4_:uint = 16777215;
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc7_:Rectangle = new Rectangle(_loc3_ / 2,_loc3_ / 2,param1 - _loc3_,param2 - _loc3_);
         var _loc8_:Point = new Point(_loc3_,_loc3_);
         var _loc9_:Number = (param1 - (imageRect.x + imageRect.width)) * 2;
         if(param1 < _loc9_ + imageRect.width)
         {
            (hostComponent as StateImageBase).stateHeight = (param1 - _loc9_) * (imageRect.height / imageRect.width);
         }
         _loc5_.push(GraphicsPathCommand.MOVE_TO);
         _loc6_.push(_loc7_.x);
         _loc6_.push(_loc7_.height + _loc7_.y);
         if(imageRect && imageRect.height > 0 && imageRect.width > 0)
         {
            _loc10_ = (hostComponent as StateImageBase).showState;
            if(_loc10_)
            {
               _loc5_.push(GraphicsPathCommand.LINE_TO);
               _loc6_.push(imageRect.x + imageRect.width / 4);
               _loc6_.push(_loc7_.height + _loc7_.y);
               _loc5_.push(GraphicsPathCommand.CURVE_TO);
               _loc6_.push(imageRect.x + imageRect.width / 2);
               _loc6_.push(_loc7_.height + _loc7_.y);
               _loc6_.push(imageRect.x + imageRect.width / 2);
               _loc6_.push(imageRect.height - imageRect.height / 4);
               _loc5_.push(GraphicsPathCommand.LINE_TO);
               _loc6_.push(imageRect.x + imageRect.width / 2);
               _loc6_.push(imageRect.height - imageRect.height / 3);
            }
            else
            {
               _loc5_.push(GraphicsPathCommand.LINE_TO);
               _loc6_.push(imageRect.x - _loc3_ / 2 - _loc8_.x);
               _loc6_.push(_loc7_.height + _loc7_.y);
            }
         }
         graphics.clear();
         graphics.lineStyle(_loc3_,_loc4_);
         graphics.drawPath(_loc5_,_loc6_);
         graphics.lineStyle();
      }
   }
}
