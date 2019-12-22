package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayDirection;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class ResetLoginScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var cancel:IVisualElement;
      
      private var cancelDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function ResetLoginScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement)
      {
         super();
         this.submit = param1;
         this.cancel = param2;
         this.menu = param3;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.submitDesc = new Label();
         this.submitDesc.text = Lang.getString("DESC_RESET_LOGIN_SUBMIT");
         this.addElement(this.submitDesc);
         this.addArrow(new AutoDrawOverlayAction(this.submitDesc,this.submit,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.cancelDesc = new Label();
         this.cancelDesc.text = Lang.getString("DESC_RESET_LOGIN_CANCEL");
         this.addElement(this.cancelDesc);
         this.addArrow(new AutoDrawOverlayAction(this.cancelDesc,this.cancel,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Point = this.globalToLocal(this.submit.parent.localToGlobal(new Point(this.submit.x,this.submit.y)));
         if(this.submitDesc.measuredWidth > param1 * (40 / 100))
         {
            this.submitDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.submitDesc.width = this.submitDesc.measuredWidth;
         }
         this.submitDesc.x = _loc3_.x + this.submit.width / 2 - this.submitDesc.width / 2 + 25;
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
         this.menuDesc.right = param1 * (5 / 100);
         this.menuDesc.bottom = this.menu.height + (param2 - this.menu.height) * (12 / 100);
      }
   }
}
