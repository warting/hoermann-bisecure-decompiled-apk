package me.mweber.itemRenderer
{
   import flash.display.CapsStyle;
   import flash.display.GradientType;
   import flash.display.JointStyle;
   import flash.geom.Matrix;
   import mx.events.PropertyChangeEvent;
   import spark.components.DataGroup;
   
   public class RoundetTableItemRenderer extends BetterItemRenderer
   {
       
      
      private var _1044792121marginTop:Number = 0;
      
      private var _289173127marginBottom:Number = 0;
      
      private var _1970934485marginLeft:Number = 0;
      
      private var _975087886marginRight:Number = 0;
      
      private var _1349188574borderRadius:Number = 30;
      
      public function RoundetTableItemRenderer()
      {
         super();
      }
      
      override protected function measure() : void
      {
         super.measure();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:RoundetTableItemRenderer = this.getFirstRenderer();
         if(_loc3_ != null && itemIndex != 0)
         {
            this.minHeight = _loc3_.minHeight - (_loc3_.marginTop + _loc3_.marginBottom);
         }
         if(this.itemIndex == 0)
         {
            if(this.getStyle("marginTop") !== undefined && this.getStyle("marginTop") != this.marginTop)
            {
               this.minHeight = this.minHeight - (this.marginBottom + this.marginTop);
               this.marginBottom = 0;
               this.marginTop = this.getStyle("marginTop");
               this.minHeight = minHeight + this.marginTop;
            }
         }
         else if(this.isLastItem)
         {
            if(this.getStyle("marginBottom") !== undefined && this.getStyle("marginBottom") != this.marginBottom)
            {
               this.minHeight = this.minHeight - (this.marginBottom + this.marginTop);
               this.marginTop = 0;
               this.marginBottom = this.getStyle("marginBottom");
               this.minHeight = minHeight + this.marginBottom;
            }
         }
         else
         {
            this.minHeight = minHeight - this.marginTop - this.marginBottom;
            this.marginTop = 0;
            this.marginBottom = 0;
         }
         if(this.getStyle("marginLeft") !== undefined && this.getStyle("marginLeft") != this.marginLeft)
         {
            this.marginLeft = this.getStyle("marginLeft");
         }
         if(this.getStyle("marginRight") !== undefined && this.getStyle("marginRight") != this.marginRight)
         {
            this.marginRight = this.getStyle("marginRight");
         }
         if(this.getStyle("borderRadius") !== undefined && this.getStyle("borderRadius") != this.borderRadius)
         {
            this.borderRadius = this.getStyle("borderRadius");
         }
         super.updateDisplayList(param1,param2);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc6_:* = undefined;
         var _loc10_:Array = null;
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Matrix = null;
         var _loc3_:Number = this.getStyle("borderSize") !== undefined?Number(this.getStyle("borderSize")):Number(3);
         var _loc4_:uint = this.getStyle("borderColor") !== undefined?uint(this.getStyle("borderColor")):uint(0);
         var _loc5_:Number = this.getStyle("borderAlpha") !== undefined?Number(this.getStyle("borderAlpha")):Number(0.3);
         var _loc7_:* = getStyle("downColor");
         var _loc8_:Boolean = true;
         var _loc9_:* = undefined;
         if(down && _loc7_ !== undefined)
         {
            _loc6_ = _loc7_;
         }
         else if(selected)
         {
            _loc6_ = getStyle("selectionColor");
         }
         else if(hovered)
         {
            _loc6_ = getStyle("rollOverColor");
         }
         else if(showsCaret)
         {
            _loc6_ = getStyle("selectionColor");
         }
         else
         {
            _loc11_ = getStyle("alternatingItemColors");
            if(_loc11_)
            {
               _loc10_ = _loc11_ is Array?_loc11_ as Array:[_loc11_];
            }
            if(_loc10_ && _loc10_.length > 0)
            {
               styleManager.getColorNames(_loc10_);
               _loc6_ = _loc10_[itemIndex % _loc10_.length];
            }
            else
            {
               _loc8_ = false;
            }
         }
         this.graphics.lineStyle(_loc3_,_loc4_,_loc5_,false,"normal",CapsStyle.NONE,JointStyle.MITER);
         graphics.beginFill(_loc6_,!!_loc8_?Number(1):Number(0));
         switch(true)
         {
            case this.itemIndex == 0 && this.isLastItem:
               this.graphics.drawRoundRect(this.marginLeft + _loc3_ / 2,this.marginTop + _loc3_ / 2,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginTop - _loc3_ / 2,this.borderRadius);
               break;
            case this.itemIndex == 0:
               this.graphics.drawRoundRectComplex(this.marginLeft + _loc3_ / 2,this.marginTop + _loc3_ / 2,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginTop - _loc3_ / 2,this.borderRadius,this.borderRadius,0,0);
               break;
            case this.isLastItem:
               this.graphics.drawRoundRectComplex(this.marginLeft + _loc3_ / 2,0,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginBottom - _loc3_ / 2,0,0,this.borderRadius,this.borderRadius);
               break;
            default:
               this.graphics.drawRect(this.marginLeft + _loc3_ / 2,0,param1 - this.marginLeft - this.marginRight - _loc3_,param2);
         }
         graphics.endFill();
         this.graphics.lineStyle();
         if(selected || down)
         {
            _loc12_ = [0,0];
            _loc13_ = [0.2,0.1];
            _loc14_ = [0,255];
            _loc15_ = new Matrix();
            _loc15_.createGradientBox(param1,param2,Math.PI / 2,0,0);
            graphics.beginGradientFill(GradientType.LINEAR,_loc12_,_loc13_,_loc14_,_loc15_);
            switch(true)
            {
               case this.itemIndex == 0 && this.isLastItem:
                  this.graphics.drawRoundRect(this.marginLeft + _loc3_ / 2,this.marginTop + _loc3_ / 2,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginTop - _loc3_ / 2,this.borderRadius);
                  break;
               case this.itemIndex == 0:
                  this.graphics.drawRoundRectComplex(this.marginLeft + _loc3_ / 2,this.marginTop + _loc3_ / 2,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginTop - _loc3_ / 2,this.borderRadius,this.borderRadius,0,0);
                  break;
               case this.isLastItem:
                  this.graphics.drawRoundRectComplex(this.marginLeft + _loc3_ / 2,0,param1 - this.marginLeft - this.marginRight - _loc3_,param2 - this.marginBottom - _loc3_ / 2,0,0,this.borderRadius,this.borderRadius);
                  break;
               default:
                  this.graphics.drawRect(this.marginLeft + _loc3_ / 2,0,param1 - this.marginLeft - this.marginRight - _loc3_,param2);
            }
            graphics.endFill();
         }
         else if(_loc8_ && itemIndex > 0 && !isLastItem && this.marginLeft == 0 && !this.marginRight == 0)
         {
            _loc9_ = _loc6_;
         }
         opaqueBackground = _loc9_;
      }
      
      override protected function drawBorder(param1:Number, param2:Number) : void
      {
      }
      
      override protected function layoutComponents(param1:Number, param2:Number) : void
      {
         super.layoutComponents(param1,param2);
      }
      
      protected function getFirstRenderer() : RoundetTableItemRenderer
      {
         var _loc1_:DataGroup = parent as DataGroup;
         if(_loc1_ != null && _loc1_.numElements > 0)
         {
            return _loc1_.getElementAt(0) as RoundetTableItemRenderer;
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get marginTop() : Number
      {
         return this._1044792121marginTop;
      }
      
      public function set marginTop(param1:Number) : void
      {
         var _loc2_:Object = this._1044792121marginTop;
         if(_loc2_ !== param1)
         {
            this._1044792121marginTop = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"marginTop",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get marginBottom() : Number
      {
         return this._289173127marginBottom;
      }
      
      public function set marginBottom(param1:Number) : void
      {
         var _loc2_:Object = this._289173127marginBottom;
         if(_loc2_ !== param1)
         {
            this._289173127marginBottom = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"marginBottom",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get marginLeft() : Number
      {
         return this._1970934485marginLeft;
      }
      
      public function set marginLeft(param1:Number) : void
      {
         var _loc2_:Object = this._1970934485marginLeft;
         if(_loc2_ !== param1)
         {
            this._1970934485marginLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"marginLeft",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get marginRight() : Number
      {
         return this._975087886marginRight;
      }
      
      public function set marginRight(param1:Number) : void
      {
         var _loc2_:Object = this._975087886marginRight;
         if(_loc2_ !== param1)
         {
            this._975087886marginRight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"marginRight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get borderRadius() : Number
      {
         return this._1349188574borderRadius;
      }
      
      public function set borderRadius(param1:Number) : void
      {
         var _loc2_:Object = this._1349188574borderRadius;
         if(_loc2_ !== param1)
         {
            this._1349188574borderRadius = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderRadius",_loc2_,param1));
            }
         }
      }
   }
}
