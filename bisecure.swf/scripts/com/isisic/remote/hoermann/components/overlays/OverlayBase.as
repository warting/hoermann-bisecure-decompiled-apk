package com.isisic.remote.hoermann.components.overlays
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import spark.components.SkinnablePopUpContainer;
   import spark.components.View;
   import spark.components.ViewNavigator;
   import spark.core.SpriteVisualElement;
   
   public class OverlayBase extends SkinnablePopUpContainer
   {
       
      
      protected var canvas:SpriteVisualElement;
      
      public function OverlayBase()
      {
         var self:OverlayBase = null;
         super();
         self = this;
         this.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            self.close();
         });
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(param1 == null)
         {
            param1 = HoermannRemote.app;
         }
         if(param1 is UIComponent)
         {
            this.styleName = (param1 as UIComponent).styleName;
         }
         if(param1 is ViewNavigator)
         {
            (param1 as ViewNavigator).activeView.addEventListener(FlexEvent.BACK_KEY_PRESSED,this.onBackKey);
         }
         else if(param1 is View)
         {
            (param1 as View).navigator.activeView.addEventListener(FlexEvent.BACK_KEY_PRESSED,this.onBackKey);
         }
         else
         {
            HoermannRemote.app.navigator.activeView.addEventListener(FlexEvent.BACK_KEY_PRESSED,this.onBackKey);
         }
         super.open(param1,param2);
         this.width = param1.width;
         this.height = param1.height;
      }
      
      private function onBackKey(param1:FlexEvent) : void
      {
         this.close();
         param1.preventDefault();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.canvas = new SpriteVisualElement();
         this.canvas.percentHeight = 100;
         this.canvas.percentWidth = 100;
         this.addElement(this.canvas);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.canvas.graphics.clear();
      }
      
      protected function drawArrow(param1:Point, param2:Point, param3:Point, param4:Point = null) : void
      {
         var _loc5_:Number = NaN;
         if(param4 != null)
         {
            _loc5_ = this.polarAngle(new Point(param2.x,param2.y),new Point(param4.x,param4.y));
         }
         else
         {
            _loc5_ = this.polarAngle(new Point(param2.x,param2.y),new Point(param3.x,param3.y));
         }
         this.canvas.graphics.moveTo(param1.x,param1.y);
         if(param4 == null)
         {
            this.canvas.graphics.curveTo(param3.x,param3.y,param2.x,param2.y);
         }
         else
         {
            this.canvas.graphics.cubicCurveTo(param3.x,param3.y,param4.x,param4.y,param2.x,param2.y);
         }
         this.canvas.graphics.moveTo(param2.x - 20 * Math.cos((_loc5_ - 45) * Math.PI / 180),param2.y - 20 * Math.sin((_loc5_ - 45) * Math.PI / 180));
         this.canvas.graphics.lineTo(param2.x + 5 * Math.cos(_loc5_ * Math.PI / 180),param2.y + 5 * Math.sin(_loc5_ * Math.PI / 180));
         this.canvas.graphics.lineTo(param2.x - 20 * Math.cos((_loc5_ + 45) * Math.PI / 180),param2.y - 20 * Math.sin((_loc5_ + 45) * Math.PI / 180));
      }
      
      protected function polarAngle(param1:Point, param2:Point = null) : Number
      {
         if(!param2)
         {
            param2 = new Point(0,0);
         }
         return Math.atan2(param1.y - param2.y,param1.x - param2.x) * 180 / Math.PI;
      }
   }
}
