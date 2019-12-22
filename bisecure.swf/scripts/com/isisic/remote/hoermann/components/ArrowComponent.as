package com.isisic.remote.hoermann.components
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import spark.components.SkinnableContainer;
   
   public class ArrowComponent extends SkinnableContainer
   {
       
      
      private var _sourcePointer:IVisualElement;
      
      private var _destinationPointer:IVisualElement;
      
      private var _drawDebug:Boolean = false;
      
      private var _controlX;
      
      private var _controlY;
      
      public function ArrowComponent()
      {
         super();
         setStyle("backgroundAlpha",0);
      }
      
      public function get drawDebug() : Boolean
      {
         return this._drawDebug;
      }
      
      public function set drawDebug(param1:Boolean) : void
      {
         this._drawDebug = param1;
         invalidateDisplayList();
      }
      
      public function get controlX() : *
      {
         return this._controlX;
      }
      
      public function set controlX(param1:*) : void
      {
         this._controlX = param1;
         invalidateDisplayList();
      }
      
      public function get controlY() : *
      {
         return this._controlY;
      }
      
      public function set controlY(param1:*) : void
      {
         this._controlY = param1;
         invalidateDisplayList();
      }
      
      public function set sourcePointer(param1:IVisualElement) : void
      {
         this._sourcePointer = param1;
         this.sourcePointer.addEventListener("xChanged",this.onSourceChanged);
         this.sourcePointer.addEventListener("yChanged",this.onSourceChanged);
      }
      
      public function get sourcePointer() : IVisualElement
      {
         return this._sourcePointer;
      }
      
      public function set destinationPointer(param1:IVisualElement) : void
      {
         this._destinationPointer = param1;
         this.destinationPointer.addEventListener("xChanged",this.onDestinationChanged);
         this.destinationPointer.addEventListener("yChanged",this.onDestinationChanged);
      }
      
      public function get destinationPointer() : IVisualElement
      {
         return this._destinationPointer;
      }
      
      private function onSourceChanged(param1:Event) : void
      {
         invalidateDisplayList();
      }
      
      private function onDestinationChanged(param1:Event) : void
      {
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:uint = getStyle("backgroundColor") == undefined?uint(0):uint(getStyle("backgroundColor"));
         var _loc4_:Number = getStyle("thickness") == undefined?Number(5):Number(getStyle("thickness"));
         graphics.clear();
         if(this.drawDebug)
         {
            graphics.beginFill(2302755,0.4);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
            if(this.destinationPointer != null && this.destinationPointer.parent != null && this.sourcePointer != null && this.sourcePointer.parent != null)
            {
               _loc5_ = globalToLocal(this.destinationPointer.owner.localToGlobal(new Point(this.destinationPointer.x,this.destinationPointer.y)));
               _loc6_ = globalToLocal(this.sourcePointer.owner.localToGlobal(new Point(this.sourcePointer.x,this.sourcePointer.y)));
               graphics.beginFill(10035763,0.4);
               graphics.drawRect(_loc6_.x,_loc6_.y,this.sourcePointer.width,this.sourcePointer.height);
               graphics.endFill();
               graphics.beginFill(3381538,0.4);
               graphics.drawRect(_loc5_.x - 10,_loc5_.y - 10,this.destinationPointer.width + 20,this.destinationPointer.height + 20);
               graphics.endFill();
            }
         }
         graphics.lineStyle(_loc4_,_loc3_);
         this.drawArrow(graphics);
      }
      
      private function drawArrow(param1:Graphics) : void
      {
         var _loc5_:IVisualElement = null;
         var _loc6_:IVisualElement = null;
         if(this.source == null || this.destination == null)
         {
            return;
         }
         var _loc2_:Number = width / 2;
         var _loc3_:Number = height / 2;
         if(this.controlX != undefined)
         {
            if(this.controlX is IVisualElement)
            {
               _loc5_ = this.controlX as IVisualElement;
               _loc2_ = globalToLocal(_loc5_.owner.localToGlobal(new Point(_loc5_.x,_loc5_.y))).x;
               _loc2_ = _loc2_ + _loc5_.width / 2;
            }
            else if(this.controlX is String)
            {
               _loc2_ = this.getPositionByString(this.controlX as String).x;
            }
            else if(this.controlX is Number)
            {
               _loc2_ = this.controlX;
            }
         }
         if(this.controlY != undefined)
         {
            if(this.controlY is IVisualElement)
            {
               _loc6_ = this.controlY as IVisualElement;
               _loc3_ = globalToLocal(_loc6_.owner.localToGlobal(new Point(_loc6_.x,_loc6_.y))).y;
               _loc3_ = _loc3_ + _loc6_.height / 2;
            }
            else if(this.controlY is String)
            {
               _loc3_ = this.getPositionByString(this.controlY as String).y;
            }
            else if(this.controlY is Number)
            {
               _loc3_ = this.controlY;
            }
         }
         var _loc4_:Number = this.polarAngle(new Point(this.destination.x,this.destination.y),new Point(_loc2_,_loc3_));
         param1.moveTo(this.source.x,this.source.y);
         param1.curveTo(_loc2_,_loc3_,this.destination.x,this.destination.y);
         param1.moveTo(this.destination.x - 20 * Math.cos((_loc4_ - 45) * Math.PI / 180),this.destination.y - 20 * Math.sin((_loc4_ - 45) * Math.PI / 180));
         param1.lineTo(this.destination.x + 5 * Math.cos(_loc4_ * Math.PI / 180),this.destination.y + 5 * Math.sin(_loc4_ * Math.PI / 180));
         param1.lineTo(this.destination.x - 20 * Math.cos((_loc4_ + 45) * Math.PI / 180),this.destination.y - 20 * Math.sin((_loc4_ + 45) * Math.PI / 180));
         if(this.drawDebug)
         {
            param1.lineStyle(2,16777215);
            param1.moveTo(_loc2_ - 5,_loc3_ - 5);
            param1.lineTo(_loc2_ + 5,_loc3_ + 5);
            param1.moveTo(_loc2_ - 5,_loc3_ + 5);
            param1.lineTo(_loc2_ + 5,_loc3_ - 5);
         }
      }
      
      private function get source() : Point
      {
         if(this.sourcePointer == null || this.sourcePointer.owner == null)
         {
            return null;
         }
         var _loc1_:Point = globalToLocal(this.sourcePointer.owner.localToGlobal(new Point(this.sourcePointer.x,this.sourcePointer.y)));
         _loc1_.x = _loc1_.x + this.sourcePointer.width / 2;
         _loc1_.y = _loc1_.y + this.sourcePointer.height / 2;
         if(this.pointOutOfPounds(_loc1_))
         {
            this.setPointToBounds(_loc1_);
         }
         return _loc1_;
      }
      
      private function get destination() : Point
      {
         if(this.destinationPointer == null || this.destinationPointer.owner == null)
         {
            return null;
         }
         var _loc1_:Point = globalToLocal(this.destinationPointer.owner.localToGlobal(new Point(this.destinationPointer.x,this.destinationPointer.y)));
         _loc1_.x = _loc1_.x + this.destinationPointer.width / 2;
         _loc1_.y = _loc1_.y + this.destinationPointer.height / 2;
         if(this.pointOutOfPounds(_loc1_))
         {
            this.setPointToBounds(_loc1_);
         }
         return _loc1_;
      }
      
      private function getPositionByString(param1:String) : Point
      {
         switch(param1.toUpperCase())
         {
            case "TOP":
               return new Point(0,0);
            case "BOTTOM":
               return new Point(0,height);
            case "LEFT":
               return new Point(0,0);
            case "RIGHT":
               return new Point(width,0);
            default:
               return null;
         }
      }
      
      private function polarAngle(param1:Point, param2:Point = null) : Number
      {
         if(!param2)
         {
            param2 = new Point(0,0);
         }
         return Math.atan2(param1.y - param2.y,param1.x - param2.x) * 180 / Math.PI;
      }
      
      private function pointOutOfPounds(param1:Point) : Boolean
      {
         if(param1.x < 0 || param1.x > width)
         {
            return true;
         }
         if(param1.y < 0 || param1.y > height)
         {
            return true;
         }
         return false;
      }
      
      private function setPointToBounds(param1:Point) : void
      {
         if(param1.x < 0)
         {
            param1.x = 5;
         }
         if(param1.x > width)
         {
            param1.x = width - 5;
         }
         if(param1.y < 0)
         {
            param1.y = 5;
         }
         if(param1.y > height)
         {
            param1.y = height - 5;
         }
      }
   }
}
