package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayDirection;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class DefaultGatewayScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var chkSave:IVisualElement;
      
      private var chkSaveDesc:Label;
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var cancel:IVisualElement;
      
      private var cancelDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function DefaultGatewayScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement)
      {
         super();
         this.chkSave = param1;
         this.submit = param2;
         this.cancel = param3;
         this.menu = param4;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.chkSaveDesc = new Label();
         this.chkSaveDesc.text = Lang.getString("DESC_DEFAULT_GW_SAVE");
         this.addElement(this.chkSaveDesc);
         this.submitDesc = new Label();
         this.submitDesc.text = Lang.getString("DESC_DEFAULT_GW_SUBMIT");
         this.addElement(this.submitDesc);
         this.addArrow(new AutoDrawOverlayAction(this.submitDesc,this.submit,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.cancelDesc = new Label();
         this.cancelDesc.text = Lang.getString("DESC_DEFAULT_GW_CANCEL");
         this.addElement(this.cancelDesc);
         this.addArrow(new AutoDrawOverlayAction(this.cancelDesc,this.cancel,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = this.globalToLocal(this.submit.parent.localToGlobal(new Point(this.submit.x,this.submit.y)));
         var _loc4_:Point = this.globalToLocal(this.chkSave.parent.localToGlobal(new Point(this.chkSave.x,this.chkSave.y)));
         if(this.chkSaveDesc.measuredWidth > param1 * (40 / 100))
         {
            this.chkSaveDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.chkSaveDesc.width = this.chkSaveDesc.measuredWidth;
         }
         this.chkSaveDesc.x = param1 * (30 / 100);
         this.chkSaveDesc.y = _loc4_.y - param2 * (20 / 100);
         if(this.chkSaveDesc.y < param2 * (5 / 100))
         {
            this.chkSaveDesc.y = param2 * (5 / 100);
         }
         if(this.submitDesc.measuredWidth > param1 * (40 / 100))
         {
            this.submitDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.submitDesc.width = this.submitDesc.measuredWidth;
         }
         this.submitDesc.x = _loc3_.x + this.submit.width / 2 - this.submitDesc.width / 2 - 25;
         this.submitDesc.y = this.submit.height + _loc3_.y + param2 * (10 / 100);
         if(this.cancelDesc.measuredWidth > param1 * (50 / 100))
         {
            this.cancelDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.cancelDesc.width = this.cancelDesc.measuredWidth;
         }
         this.cancelDesc.x = param1 * (10 / 100);
         this.cancelDesc.y = this.submitDesc.height + this.submitDesc.y + param2 * (5 / 100);
         if(this.menuDesc.measuredWidth > param1 * (40 / 100))
         {
            this.menuDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.menuDesc.width = this.menuDesc.measuredWidth;
         }
         this.menuDesc.right = this.menu.width + param1 * (15 / 100);
         this.menuDesc.bottom = this.menu.height / 2 - this.menuDesc.height / 2;
         super.updateDisplayList(param1,param2);
         this.setupLinestyle();
         this.drawArrow(new Point(this.chkSaveDesc.x,this.chkSaveDesc.y + this.chkSaveDesc.height / 2),new Point(_loc4_.x + 30,_loc4_.y - 10),new Point(_loc4_.x - param1 * (5 / 100),this.chkSaveDesc.y + (_loc4_.y - this.chkSaveDesc.y) / 2));
         this.canvas.graphics.lineStyle();
      }
   }
}
