package com.isisic.remote.hoermann.views.home
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import spark.components.IconPlacement;
   import spark.skins.mobile.ButtonSkin;
   
   public class HomeButtonSkin extends ButtonSkin
   {
       
      
      private var paddingTop:Number = 0;
      
      private var borderHeight:Number = 0;
      
      private var iconRect:Rectangle;
      
      private var labelRect:Rectangle;
      
      private var buttonDownOverlay:Sprite;
      
      private var _lastHeight:Number;
      
      private var _lastWidth:Number;
      
      public function HomeButtonSkin()
      {
         super();
         this.setStyle("iconPlacement",IconPlacement.TOP);
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super.layoutContents(param1,param2);
         this.paddingTop = 0;
         this.borderHeight = param2 * 0.02;
         if(currentState == "down")
         {
            this.paddingTop = this.borderHeight;
            this.borderHeight = 0;
         }
         if(this.sizeChanged(param1,param2))
         {
            this.iconRect = new Rectangle(0,0,param1,param2 / 4 * 3);
            this.labelRect = new Rectangle(0,this.iconRect.height,param1,param2 / 4);
         }
         var _loc3_:DisplayObject = getIconDisplay();
         if(_loc3_ != null)
         {
            _loc4_ = Math.min(this.iconRect.width,this.iconRect.height) - param2 * 0.3;
            setElementSize(_loc3_,_loc4_,_loc4_);
            _loc5_ = (this.iconRect.width - _loc4_) / 2;
            _loc6_ = (this.iconRect.height - _loc4_) / 2 + this.paddingTop + this.iconRect.y;
            setElementPosition(_loc3_,_loc5_,_loc6_);
            _loc7_ = getChildIndex(_loc3_);
            _loc8_ = getChildIndex(this.buttonDownOverlay);
            if(_loc8_ < _loc7_)
            {
               setChildIndex(this.buttonDownOverlay,getChildIndex(getIconDisplay()));
            }
         }
         if(labelDisplay != null)
         {
            setElementPosition(labelDisplay,labelDisplay.x,(this.labelRect.height - labelDisplay.height) / 2 + this.paddingTop + this.labelRect.y);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         labelDisplay.multiline = true;
         removeChild(labelDisplayShadow);
         this.buttonDownOverlay = new Sprite();
         this.buttonDownOverlay.visible = false;
         addChild(this.buttonDownOverlay);
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc7_:Graphics = null;
         var _loc3_:Number = 8691397;
         var _loc4_:Number = 3301268;
         var _loc5_:Number = 15;
         var _loc6_:Number = param2 * 0.02;
         if(currentState == "down")
         {
            _loc7_ = this.buttonDownOverlay.graphics;
            _loc7_.clear();
            _loc7_.beginFill(204609,0.5);
            _loc7_.drawRoundRect(0,this.paddingTop,param1,param2 - this.borderHeight,_loc5_);
            _loc7_.endFill();
            this.buttonDownOverlay.visible = true;
         }
         else
         {
            this.buttonDownOverlay.visible = false;
         }
         _loc7_ = this.graphics;
         _loc7_.beginFill(_loc4_);
         _loc7_.drawRoundRect(0,param2 / 2,param1,param2 / 2,_loc5_);
         _loc7_.endFill();
         _loc7_.beginFill(_loc3_);
         _loc7_.drawRoundRect(0,this.paddingTop,param1,param2 - this.borderHeight,_loc5_);
         _loc7_.endFill();
         _loc7_.beginFill(_loc4_);
         _loc7_.drawRect(_loc6_,this.iconRect.y + this.iconRect.height + this.paddingTop,param1 - _loc6_ * 2,2);
         _loc7_.endFill();
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         return Sprite;
      }
      
      private function sizeChanged(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(param1 != this._lastWidth)
         {
            _loc3_ = true;
         }
         if(param2 != this._lastHeight)
         {
            _loc4_ = true;
         }
         this._lastWidth = param1;
         this._lastHeight = param2;
         return _loc3_ || _loc4_;
      }
   }
}
