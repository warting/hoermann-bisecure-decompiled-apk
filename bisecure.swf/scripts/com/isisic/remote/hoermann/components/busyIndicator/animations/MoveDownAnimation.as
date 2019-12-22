package com.isisic.remote.hoermann.components.busyIndicator.animations
{
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.effects.Effect;
   import spark.effects.Move;
   
   public class MoveDownAnimation implements IAnimation
   {
       
      
      public var paddingTop:Number = 10;
      
      public var paddingBottom:Number = 10;
      
      public function MoveDownAnimation()
      {
         super();
      }
      
      public function getStartPosition(param1:IVisualElement, param2:IVisualElement) : Point
      {
         return new Point((param2.width - param1.width) / 2,param1.height * -1 - this.paddingTop);
      }
      
      public function getEffect(param1:IVisualElement, param2:IVisualElement) : Effect
      {
         var _loc3_:Point = this.getStartPosition(param1,param2);
         var _loc4_:Move = new Move(param1);
         _loc4_.xFrom = _loc3_.x;
         _loc4_.yFrom = _loc3_.y;
         _loc4_.xTo = _loc3_.x;
         _loc4_.yTo = param2.height + this.paddingBottom;
         return _loc4_;
      }
   }
}
