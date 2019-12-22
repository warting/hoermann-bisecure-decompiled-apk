package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class ManagePopupsScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var chkInfo:IVisualElement;
      
      private var infoDesc:Label;
      
      private var chkWarn:IVisualElement;
      
      private var warnDesc:Label;
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var cancel:IVisualElement;
      
      private var cancelDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function ManagePopupsScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement)
      {
         super();
         this.chkInfo = param1;
         this.chkWarn = param2;
         this.submit = param3;
         this.cancel = param4;
         this.menu = param5;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.infoDesc = new Label();
         this.infoDesc.text = Lang.getString("DESC_MANAGE_POPUPS_INFOS");
         this.addElement(this.infoDesc);
         this.warnDesc = new Label();
         this.warnDesc.text = Lang.getString("DESC_MANAGE_POPUPS_WARNINGS");
         this.addElement(this.warnDesc);
         this.submitDesc = new Label();
         this.submitDesc.text = Lang.getString("DESC_MANAGE_POPUPS_SUBMIT");
         this.addElement(this.submitDesc);
         this.addArrow(new AutoDrawOverlayAction(this.submitDesc,this.submit,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.cancelDesc = new Label();
         this.cancelDesc.text = Lang.getString("DESC_MANAGE_POPUPS_CANCEL");
         this.addElement(this.cancelDesc);
         this.addArrow(new AutoDrawOverlayAction(this.cancelDesc,this.cancel,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = this.globalToLocal(this.submit.parent.localToGlobal(new Point(this.submit.x,this.submit.y)));
         var _loc4_:Point = this.globalToLocal(this.chkInfo.parent.localToGlobal(new Point(this.chkInfo.x,this.chkInfo.y)));
         var _loc5_:Point = this.globalToLocal(this.chkWarn.parent.localToGlobal(new Point(this.chkWarn.x,this.chkWarn.y)));
         if(this.infoDesc.measuredWidth > param1 * (40 / 100))
         {
            this.infoDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.infoDesc.width = this.infoDesc.measuredWidth;
         }
         this.infoDesc.x = param1 * (30 / 100);
         this.infoDesc.y = _loc4_.y - param2 * (20 / 100);
         if(this.infoDesc.y < param2 * (5 / 100))
         {
            this.infoDesc.y = param2 * (5 / 100);
         }
         if(this.infoDesc.measuredWidth > param1 * (40 / 100))
         {
            this.infoDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.infoDesc.width = this.infoDesc.measuredWidth;
         }
         if(this.warnDesc.measuredWidth > param1 * (40 / 100))
         {
            this.warnDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.warnDesc.width = this.warnDesc.measuredWidth;
         }
         this.warnDesc.y = _loc5_.y + (this.chkWarn.height / 2 - this.warnDesc.height / 2);
         this.warnDesc.x = _loc5_.x + this.chkWarn.width / 2 + param1 * (5 / 100);
         if(this.warnDesc.x + this.warnDesc.width > param1 - param1 * (5 / 100))
         {
            this.warnDesc.x = param1 - this.warnDesc.width - param1 * (5 / 100);
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
         this.drawArrow(new Point(this.infoDesc.x,this.infoDesc.y + this.infoDesc.height / 2),new Point(_loc4_.x + 30,_loc4_.y - 10),new Point(_loc4_.x - param1 * (5 / 100),this.infoDesc.y + (_loc4_.y - this.infoDesc.y) / 2));
         this.drawArrow(new Point(this.warnDesc.x,this.warnDesc.y + this.warnDesc.height / 3),new Point(_loc5_.x + 60,_loc5_.y + this.chkWarn.height / 2),new Point(_loc5_.x + (this.warnDesc.x - _loc5_.x) / 2,this.warnDesc.y + (_loc5_.y - this.warnDesc.y) / 2));
         this.canvas.graphics.lineStyle();
      }
   }
}
