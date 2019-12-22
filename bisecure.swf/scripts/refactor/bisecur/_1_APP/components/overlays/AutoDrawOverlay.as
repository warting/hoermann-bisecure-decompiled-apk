package refactor.bisecur._1_APP.components.overlays
{
   import com.isisic.remote.lw.Debug;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   
   public class AutoDrawOverlay extends OverlayBase
   {
       
      
      private var _controlOffset:Number = 10;
      
      protected var pxCOffset:Number;
      
      protected var drawables:Array;
      
      public function AutoDrawOverlay()
      {
         super();
         this.drawables = [];
      }
      
      public function get controlOffset() : Number
      {
         return this._controlOffset;
      }
      
      public function set controlOffset(param1:Number) : void
      {
         this._controlOffset = param1;
         this.invalidateDisplayList();
      }
      
      public function addArrow(param1:AutoDrawOverlayAction) : void
      {
         this.drawables.push(param1);
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         this.pxCOffset = this.width * (this.controlOffset / 100);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      protected function setupLinestyle() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         if((_loc1_ = getStyle("arrowThickness")) == undefined)
         {
            _loc1_ = 5;
         }
         if((_loc2_ = getStyle("arrowColor")) == undefined)
         {
            _loc2_ = 10035763;
         }
         if((_loc3_ = getStyle("arrowAlpha")) == undefined)
         {
            _loc3_ = 0.5;
         }
         canvas.graphics.lineStyle(_loc1_,_loc2_,_loc3_);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:AutoDrawOverlayAction = null;
         super.updateDisplayList(param1,param2);
         this.setupLinestyle();
         for each(_loc3_ in this.drawables)
         {
            this.pointAt(_loc3_.from,_loc3_.to,_loc3_.fromDirection,_loc3_.toDirection);
         }
         canvas.graphics.lineStyle();
      }
      
      public function pointAt(param1:IVisualElement, param2:IVisualElement, param3:String = "auto", param4:String = "auto") : void
      {
         if(!param1.parent || !param2.parent)
         {
            if(!param1.parent)
            {
               Debug.warning("[AutoDrawOverlay] can not point to position (the from element is not on the display list)");
            }
            else
            {
               Debug.warning("[AutoDrawOverlay] can not point to position (the to element is not on the display list)");
            }
            return;
         }
         var _loc5_:Point = this.globalToLocal(param1.parent.localToGlobal(new Point(param1.x,param1.y)));
         var _loc6_:Point = this.globalToLocal(param2.parent.localToGlobal(new Point(param2.x,param2.y)));
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         if(param3 == AutoDrawOverlayDirection.AUTO)
         {
            param3 = this.findFromDirection(param1,param2);
         }
         if(param4 == AutoDrawOverlayDirection.AUTO)
         {
            param4 = this.findToDirection(param1,param2);
         }
         switch(param4)
         {
            case AutoDrawOverlayDirection.LEFT:
               _loc6_.y = _loc6_.y + param2.height / 2;
               break;
            case AutoDrawOverlayDirection.TOP:
               _loc6_.x = _loc6_.x + param2.width / 2;
               break;
            case AutoDrawOverlayDirection.RIGHT:
               _loc6_.y = _loc6_.y + param2.height / 2;
               _loc6_.x = _loc6_.x + param2.width;
               break;
            case AutoDrawOverlayDirection.BOTTOM:
               _loc6_.y = _loc6_.y + param2.height;
               _loc6_.x = _loc6_.x + param2.width / 2;
         }
         switch(param3)
         {
            case AutoDrawOverlayDirection.LEFT:
               _loc5_.y = _loc5_.y + param1.height / 2;
               _loc7_ = _loc5_.clone();
               if(param4 == AutoDrawOverlayDirection.RIGHT)
               {
                  _loc7_.x = _loc6_.x + this.pxCOffset / 2;
                  _loc7_.x = _loc7_.x + this.pxCOffset / 2;
               }
               else
               {
                  _loc7_.x = _loc6_.x - this.pxCOffset / 2;
                  _loc7_.y = _loc7_.y - this.pxCOffset / 2;
               }
               break;
            case AutoDrawOverlayDirection.TOP:
               _loc5_.x = _loc5_.x + param1.width / 2;
               _loc8_ = _loc5_.clone();
               _loc8_.x = _loc6_.x;
               _loc8_.y = _loc5_.y - this.pxCOffset;
               _loc7_ = _loc5_.clone();
               _loc7_.y = _loc7_.y - this.pxCOffset;
               break;
            case AutoDrawOverlayDirection.RIGHT:
               _loc5_.y = _loc5_.y + param1.height / 2;
               _loc5_.x = _loc5_.x + param1.width;
               _loc7_ = _loc5_.clone();
               if(param4 == AutoDrawOverlayDirection.LEFT)
               {
                  _loc7_.x = _loc6_.x - this.pxCOffset / 2;
                  _loc7_.y = _loc7_.y - this.pxCOffset / 2;
               }
               else
               {
                  _loc7_.x = _loc6_.x + this.pxCOffset / 2;
                  _loc7_.y = _loc7_.y + this.pxCOffset / 2;
               }
               break;
            case AutoDrawOverlayDirection.BOTTOM:
               _loc5_.y = _loc5_.y + param1.height;
               _loc5_.x = _loc5_.x + param1.width / 2;
               _loc8_ = _loc5_.clone();
               _loc8_.x = _loc6_.x;
               _loc8_.y = _loc5_.y + this.pxCOffset;
               _loc7_ = _loc5_.clone();
               _loc7_.y = _loc7_.y + this.pxCOffset;
         }
         this.drawArrow(_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      protected function findFromDirection(param1:IVisualElement, param2:IVisualElement) : String
      {
         var _loc3_:Point = this.globalToLocal(param1.parent.localToGlobal(new Point(param1.x,param1.y)));
         var _loc4_:Point = this.globalToLocal(param2.parent.localToGlobal(new Point(param2.x,param2.y)));
         if(_loc3_.x > _loc4_.x + param2.width)
         {
            return AutoDrawOverlayDirection.LEFT;
         }
         if(_loc4_.x > _loc3_.x + param1.width)
         {
            return AutoDrawOverlayDirection.RIGHT;
         }
         if(_loc4_.y + param2.height < _loc3_.y)
         {
            return AutoDrawOverlayDirection.TOP;
         }
         return AutoDrawOverlayDirection.BOTTOM;
      }
      
      protected function findToDirection(param1:IVisualElement, param2:IVisualElement) : String
      {
         var _loc3_:Point = this.globalToLocal(param1.parent.localToGlobal(new Point(param1.x,param1.y)));
         var _loc4_:Point = this.globalToLocal(param2.parent.localToGlobal(new Point(param2.x,param2.y)));
         if(_loc4_.y + param2.height < _loc3_.y)
         {
            return AutoDrawOverlayDirection.BOTTOM;
         }
         if(_loc4_.y > _loc3_.y + param1.height)
         {
            return AutoDrawOverlayDirection.TOP;
         }
         if(_loc4_.x + param2.width < _loc3_.x)
         {
            return AutoDrawOverlayDirection.RIGHT;
         }
         return AutoDrawOverlayDirection.LEFT;
      }
   }
}
