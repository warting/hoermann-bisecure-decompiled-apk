package com.isisic.remote.hoermann.components.busyIndicator.animations
{
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.effects.Effect;
   
   public interface IAnimation
   {
       
      
      function getStartPosition(param1:IVisualElement, param2:IVisualElement) : Point;
      
      function getEffect(param1:IVisualElement, param2:IVisualElement) : Effect;
   }
}
