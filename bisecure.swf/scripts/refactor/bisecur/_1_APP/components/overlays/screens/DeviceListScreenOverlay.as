package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class DeviceListScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var back:IVisualElement;
      
      private var backDesc:Label;
      
      private var add:IVisualElement;
      
      private var addDesc:Label;
      
      private var edit:IVisualElement;
      
      private var editDesc:Label;
      
      private var refresh:IVisualElement;
      
      private var refreshDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function DeviceListScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement)
      {
         super();
         this.back = param1;
         this.add = param2;
         this.edit = param3;
         this.refresh = param4;
         this.menu = param5;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.backDesc = new Label();
         this.backDesc.text = Lang.getString("DESC_ACTORS_BACK");
         this.addElement(this.backDesc);
         this.addArrow(new AutoDrawOverlayAction(this.backDesc,this.back,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.addDesc = new Label();
         this.addDesc.visible = this.add.visible;
         this.addDesc.text = Lang.getString("DESC_ACTORS_ADD");
         this.addElement(this.addDesc);
         if(this.add.visible)
         {
            this.addArrow(new AutoDrawOverlayAction(this.addDesc,this.add,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         }
         this.editDesc = new Label();
         this.editDesc.visible = this.edit.visible;
         this.editDesc.text = Lang.getString("DESC_ACTORS_EDIT");
         this.addElement(this.editDesc);
         if(this.edit.visible)
         {
            this.addArrow(new AutoDrawOverlayAction(this.editDesc,this.edit,AutoDrawOverlayDirection.TOP,AutoDrawOverlayDirection.BOTTOM));
         }
         this.refreshDesc = new Label();
         this.refreshDesc.text = Lang.getString("DESC_ACTORS_REFRESH");
         this.addElement(this.refreshDesc);
         this.addArrow(new AutoDrawOverlayAction(this.refreshDesc,this.refresh,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.editDesc.measuredWidth > param1 * (50 / 100))
         {
            this.editDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.editDesc.width = this.editDesc.measuredWidth;
         }
         this.editDesc.left = param1 / 2 - this.editDesc.width / 2;
         this.editDesc.y = this.edit.height + param2 * (15 / 100);
         if(this.backDesc.measuredWidth > param1 * (50 / 100))
         {
            this.backDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.backDesc.width = this.backDesc.measuredWidth;
         }
         this.backDesc.x = param1 * (10 / 100);
         this.backDesc.y = this.editDesc.height + this.editDesc.y + param2 * (5 / 100);
         if(this.addDesc.measuredWidth > param1 * (50 / 100))
         {
            this.addDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.addDesc.width = this.addDesc.measuredWidth;
         }
         this.addDesc.right = param1 * (5 / 100);
         this.addDesc.y = this.editDesc.height + this.editDesc.y + param2 * (10 / 100);
         if(this.refreshDesc.measuredWidth > param1 * (40 / 100))
         {
            this.refreshDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.refreshDesc.width = this.refreshDesc.measuredWidth;
         }
         this.refreshDesc.right = param1 * (50 / 100);
         this.refreshDesc.bottom = this.refresh.height + (param2 - this.refresh.height) * (15 / 100);
         if(this.menuDesc.measuredWidth > param1 * (40 / 100))
         {
            this.menuDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.menuDesc.width = this.menuDesc.measuredWidth;
         }
         this.menuDesc.right = param1 * (5 / 100);
         this.menuDesc.bottom = this.menu.height + (param2 - this.menu.height) * (15 / 100);
      }
   }
}
