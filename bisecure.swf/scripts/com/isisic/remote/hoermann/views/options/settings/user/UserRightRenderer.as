package com.isisic.remote.hoermann.views.options.settings.user
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgCheck;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.lw.Debug;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import me.mweber.itemRenderer.RoundetTableItemRenderer;
   import spark.components.Label;
   
   public class UserRightRenderer extends RoundetTableItemRenderer
   {
       
      
      private var lblTitle:Label;
      
      private var imgSelected:ImgCheck;
      
      public function UserRightRenderer()
      {
         super();
      }
      
      override public function get preferedMinHeight() : Number
      {
         switch(MultiDevice.screenSize)
         {
            case ScreenSizes.XXLARGE:
               return 300;
            case ScreenSizes.XLARGE:
               return 198;
            case ScreenSizes.LARGE:
               return 150;
            case ScreenSizes.NORMAL:
               return 150;
            case ScreenSizes.SMALL:
               return 150;
            default:
               return 150;
         }
      }
      
      override protected function layoutComponents(param1:Number, param2:Number) : void
      {
         super.layoutComponents(param1,param2);
         var _loc3_:Number = this.imgSelected.height / this.imgSelected.width;
         this.imgSelected.height = param2 - marginTop - marginBottom - borderRadius * 2;
         this.imgSelected.width = this.imgSelected.height * _loc3_;
         this.imgSelected.right = borderRadius + marginRight;
         this.imgSelected.y = marginTop + (param2 - marginTop - marginBottom) / 2 - this.imgSelected.height / 2;
         this.lblTitle.x = marginLeft + borderRadius;
         this.lblTitle.y = marginTop + (param2 - marginTop - marginBottom) / 2 - this.lblTitle.measureText("A").height / 2;
         this.lblTitle.width = param1 - marginLeft - marginRight - borderRadius * 3 - this.imgSelected.width;
         Debug.debug("imgSelected: height= " + param2 + " - (" + borderRadius + " * 2)");
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.lblTitle.text = param1.name;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblTitle = new Label();
         this.addElement(this.lblTitle);
         this.imgSelected = new ImgCheck();
         this.imgSelected.visible = false;
         this.addElement(this.imgSelected);
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.imgSelected.visible = param1;
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc6_:* = undefined;
         var _loc10_:Array = null;
         var _loc3_:Number = this.getStyle("borderSize") !== undefined?Number(this.getStyle("borderSize")):Number(3);
         var _loc4_:uint = this.getStyle("borderColor") !== undefined?uint(this.getStyle("borderColor")):uint(0);
         var _loc5_:Number = this.getStyle("borderAlpha") !== undefined?Number(this.getStyle("borderAlpha")):Number(0.3);
         var _loc7_:* = getStyle("downColor");
         var _loc8_:Boolean = true;
         var _loc9_:* = undefined;
         var _loc11_:Object = getStyle("alternatingItemColors");
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
         this.graphics.lineStyle(_loc3_,_loc4_,_loc5_,false,"normal",CapsStyle.NONE,JointStyle.MITER);
         graphics.beginFill(_loc6_,!!_loc8_?Number(1):Number(0));
         switch(true)
         {
            case this.itemIndex == 0 && this.isLastItem:
               this.graphics.drawRoundRect(marginLeft + _loc3_ / 2,marginTop + _loc3_ / 2,param1 - marginLeft - marginRight - _loc3_,param2 - marginTop - _loc3_ / 2,borderRadius);
               break;
            case this.itemIndex == 0:
               this.graphics.drawRoundRectComplex(marginLeft + _loc3_ / 2,marginTop + _loc3_ / 2,param1 - marginLeft - marginRight - _loc3_,param2 - marginTop - _loc3_ / 2,borderRadius,borderRadius,0,0);
               break;
            case this.isLastItem:
               this.graphics.drawRoundRectComplex(marginLeft + _loc3_ / 2,0,param1 - marginLeft - marginRight - _loc3_,param2 - marginBottom - _loc3_ / 2,0,0,borderRadius,borderRadius);
               break;
            default:
               this.graphics.drawRect(marginLeft + _loc3_ / 2,0,param1 - marginLeft - marginRight - _loc3_,param2);
         }
         graphics.endFill();
         this.graphics.lineStyle();
         if(!(selected || down))
         {
            if(_loc8_ && itemIndex > 0 && !isLastItem && marginLeft == 0 && !marginRight == 0)
            {
               _loc9_ = _loc6_;
            }
         }
         opaqueBackground = _loc9_;
      }
   }
}
