package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class OptionsScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var back:IVisualElement;
      
      private var backDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function OptionsScreenOverlay(param1:IVisualElement, param2:IVisualElement)
      {
         super();
         this.back = param1;
         this.menu = param2;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.backDesc = new Label();
         this.backDesc.text = Lang.getString("DESC_OTIONS_BACK");
         this.addElement(this.backDesc);
         this.addArrow(new AutoDrawOverlayAction(this.backDesc,this.back,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.backDesc.measuredWidth > param1 * (50 / 100))
         {
            this.backDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.backDesc.width = this.backDesc.measuredWidth;
         }
         this.backDesc.x = param1 * (20 / 100);
         this.backDesc.y = this.back.height + this.back.y + param2 * (20 / 100);
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
