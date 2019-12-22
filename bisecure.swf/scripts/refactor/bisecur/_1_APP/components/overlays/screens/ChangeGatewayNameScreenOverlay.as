package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class ChangeGatewayNameScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var gwName:IVisualElement;
      
      private var gwNameDesc:Label;
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var cancel:IVisualElement;
      
      private var cancelDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function ChangeGatewayNameScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement)
      {
         super();
         this.gwName = param1;
         this.submit = param2;
         this.cancel = param3;
         this.menu = param4;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.gwNameDesc = new Label();
         this.gwNameDesc.text = Lang.getString("DESC_GW_NAME");
         this.addElement(this.gwNameDesc);
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
         var _loc4_:Point = this.globalToLocal(this.gwName.parent.localToGlobal(new Point(this.gwName.x,this.gwName.y)));
         if(this.gwNameDesc.measuredWidth > param1 * (40 / 100))
         {
            this.gwNameDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.gwNameDesc.width = this.gwNameDesc.measuredWidth;
         }
         this.gwNameDesc.x = param1 * (30 / 100);
         this.gwNameDesc.y = _loc4_.y - param2 * (10 / 100);
         if(this.gwNameDesc.y < param2 * (5 / 100))
         {
            this.gwNameDesc.y = param2 * (5 / 100);
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
         this.drawArrow(new Point(this.gwNameDesc.x,this.gwNameDesc.y + this.gwNameDesc.height / 2),new Point(this.gwNameDesc.x - param1 * (5 / 100),_loc4_.y),new Point(this.gwNameDesc.x - param1 * (5 / 100) - 15,this.gwNameDesc.y + (_loc4_.y - this.gwNameDesc.y) / 2));
         this.canvas.graphics.lineStyle();
      }
   }
}
