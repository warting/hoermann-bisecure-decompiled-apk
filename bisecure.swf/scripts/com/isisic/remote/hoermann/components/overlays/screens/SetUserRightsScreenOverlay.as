package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayDirection;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class SetUserRightsScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var back:IVisualElement;
      
      private var backDesc:Label;
      
      private var save:IVisualElement;
      
      private var saveDesc:Label;
      
      private var chRightsDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function SetUserRightsScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement)
      {
         super();
         this.back = param1;
         this.save = param2;
         this.menu = param3;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.backDesc = new Label();
         this.backDesc.text = Lang.getString("DESC_SET_RIGHTS_BACK");
         this.addElement(this.backDesc);
         this.addArrow(new AutoDrawOverlayAction(this.backDesc,this.back,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.saveDesc = new Label();
         this.saveDesc.text = Lang.getString("DESC_SET_RIGHTS_SAVE");
         this.addElement(this.saveDesc);
         this.addArrow(new AutoDrawOverlayAction(this.saveDesc,this.save,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.chRightsDesc = new Label();
         this.chRightsDesc.text = Lang.getString("DESC_SET_RIGHTS");
         this.addElement(this.chRightsDesc);
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
         this.backDesc.x = param1 * (10 / 100);
         this.backDesc.y = this.back.height + param2 * (15 / 100);
         if(this.saveDesc.measuredWidth > param1 * (50 / 100))
         {
            this.saveDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.saveDesc.width = this.saveDesc.measuredWidth;
         }
         this.saveDesc.right = param1 * (5 / 100);
         this.saveDesc.y = this.backDesc.height + this.backDesc.y + param2 * (10 / 100);
         if(this.chRightsDesc.measuredWidth > param1 * (40 / 100))
         {
            this.chRightsDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.chRightsDesc.width = this.chRightsDesc.measuredWidth;
         }
         this.chRightsDesc.x = param1 * (10 / 100);
         this.chRightsDesc.y = this.saveDesc.y + this.saveDesc.height + param2 * (5 / 100);
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
