package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class ChangePasswordScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var username:IVisualElement;
      
      private var usernameDesc:Label;
      
      private var password:IVisualElement;
      
      private var passwordDesc:Label;
      
      private var retype:IVisualElement;
      
      private var retypeDesc:Label;
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var cancel:IVisualElement;
      
      private var cancelDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function ChangePasswordScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement, param6:IVisualElement)
      {
         super();
         this.username = param1;
         this.password = param2;
         this.retype = param3;
         this.submit = param4;
         this.cancel = param5;
         this.menu = param6;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.usernameDesc = new Label();
         this.usernameDesc.text = Lang.getString("DESC_CHANGE_PASSWORD_USERNAME");
         this.addElement(this.usernameDesc);
         this.addArrow(new AutoDrawOverlayAction(this.usernameDesc,this.username,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.passwordDesc = new Label();
         this.passwordDesc.text = Lang.getString("DESC_CHANGE_PASSWORD_PWD");
         this.addElement(this.passwordDesc);
         this.retypeDesc = new Label();
         this.retypeDesc.text = Lang.getString("DESC_CHANGE_PASSWORD_RETYPE");
         this.addElement(this.retypeDesc);
         this.submitDesc = new Label();
         this.submitDesc.text = Lang.getString("DESC_CHANGE_PASSWORD_SUBMIT");
         this.addElement(this.submitDesc);
         this.addArrow(new AutoDrawOverlayAction(this.submitDesc,this.submit,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.cancelDesc = new Label();
         this.cancelDesc.text = Lang.getString("DESC_CHANGE_PASSWORD_CANCEL");
         this.addElement(this.cancelDesc);
         this.addArrow(new AutoDrawOverlayAction(this.cancelDesc,this.cancel,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = this.globalToLocal(this.submit.parent.localToGlobal(new Point(this.submit.x,this.submit.y)));
         var _loc4_:Point = this.globalToLocal(this.password.parent.localToGlobal(new Point(this.password.x,this.password.y)));
         var _loc5_:Point = this.globalToLocal(this.retype.parent.localToGlobal(new Point(this.retype.x,this.retype.y)));
         var _loc6_:Point = this.globalToLocal(this.username.parent.localToGlobal(new Point(this.username.x,this.username.y)));
         if(this.usernameDesc.measuredWidth > param1 * (40 / 100))
         {
            this.usernameDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.usernameDesc.width = this.usernameDesc.measuredWidth;
         }
         this.usernameDesc.x = _loc6_.x + this.username.width + 100;
         this.usernameDesc.y = _loc6_.y - 100;
         if(this.passwordDesc.measuredWidth > param1 * (40 / 100))
         {
            this.passwordDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.passwordDesc.width = this.passwordDesc.measuredWidth;
         }
         this.passwordDesc.right = param1 * (5 / 100);
         this.passwordDesc.y = _loc4_.y;
         if(this.retypeDesc.measuredWidth > param1 * (40 / 100))
         {
            this.retypeDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.retypeDesc.width = this.retypeDesc.measuredWidth;
         }
         this.retypeDesc.x = param1 * (5 / 100);
         this.retypeDesc.y = _loc5_.y;
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
         this.menuDesc.right = this.menu.width + param1 * (15 / 100);
         this.menuDesc.bottom = this.menu.height / 2 - this.menuDesc.height / 2;
         super.updateDisplayList(param1,param2);
         this.setupLinestyle();
         this.drawArrow(new Point(this.passwordDesc.x,this.passwordDesc.y + this.passwordDesc.height / 2),new Point(this.passwordDesc.x - this.password.width / 3,_loc4_.y + this.password.height - 10),new Point(this.passwordDesc.x - this.password.width / 3 - 10,this.passwordDesc.y + this.passwordDesc.height / 2 - param2 * (5 / 100)));
         this.drawArrow(new Point(this.retypeDesc.x + this.retypeDesc.width,this.retypeDesc.y + this.retypeDesc.height / 2),new Point(this.retypeDesc.x + this.retypeDesc.width + this.retype.width / 3,_loc5_.y + this.retype.height - 10),new Point(this.retypeDesc.x + this.retypeDesc.width + this.retype.width / 3 + 10,this.retypeDesc.y + this.retypeDesc.height / 2 - param2 * (5 / 100)));
         this.canvas.graphics.lineStyle();
      }
   }
}
