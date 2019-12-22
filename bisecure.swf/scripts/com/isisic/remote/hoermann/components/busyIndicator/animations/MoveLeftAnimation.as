package com.isisic.remote.hoermann.components.busyIndicator.animations
{
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.effects.Effect;
   import spark.effects.Move;
   
   public class MoveLeftAnimation implements IAnimation
   {
       
      
      public var paddingLeft:Number = 20;
      
      public var paddingRight:Number = 20;
      
      public function MoveLeftAnimation()
      {
         super();
      }
      
      public function getStartPosition(param1:IVisualElement, param2:IVisualElement) : Point
      {
         return new Point(param2.width + this.paddingRight,(param2.height - param1.height) / 2);
      }
      
      public function getEffect(param1:IVisualElement, param2:IVisualElement) : Effect
      {
         var _loc3_:Point = this.getStartPosition(param1,param2);
         var _loc4_:Move = new Move(param1);
         _loc4_.xFrom = _loc3_.x;
         _loc4_.yFrom = _loc3_.y;
         _loc4_.xTo = param1.width * -1 - this.paddingLeft;
         _loc4_.yTo = _loc3_.y;
         return _loc4_;
      }
   }
}
