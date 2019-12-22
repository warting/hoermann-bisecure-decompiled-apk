package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class GatewayScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var edit:IVisualElement;
      
      private var editDesc:Label;
      
      private var add:IVisualElement;
      
      private var addDesc:Label;
      
      private var portal:IVisualElement;
      
      private var portalDesc:Label;
      
      private var email:IVisualElement;
      
      private var emailDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function GatewayScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement)
      {
         super();
         this.edit = param1;
         this.add = param2;
         this.portal = param3;
         this.email = param4;
         this.menu = param5;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.editDesc = new Label();
         this.editDesc.text = Lang.getString("DESC_GWSCREEN_EDIT");
         this.editDesc.styleName = "desc1";
         this.addElement(this.editDesc);
         this.addArrow(new AutoDrawOverlayAction(this.editDesc,this.edit));
         this.addDesc = new Label();
         this.addDesc.text = Lang.getString("DESC_GWSCREEN_ADD");
         this.addElement(this.addDesc);
         this.addArrow(new AutoDrawOverlayAction(this.addDesc,this.add));
         this.portalDesc = new Label();
         this.portalDesc.text = Lang.getString("DESC_GWSCREEN_PORTAL");
         this.portalDesc.styleName = "desc2";
         this.addElement(this.portalDesc);
         this.addArrow(new AutoDrawOverlayAction(this.portalDesc,this.portal));
         this.emailDesc = new Label();
         this.emailDesc.text = Lang.getString("DESC_EMAIL");
         this.emailDesc.styleName = "desc3";
         this.addElement(this.emailDesc);
         this.addArrow(new AutoDrawOverlayAction(this.emailDesc,this.email));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
         this.menuDesc.styleName = "desc4";
         this.addElement(this.menuDesc);
         this.addArrow(new AutoDrawOverlayAction(this.menuDesc,this.menu));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.editDesc.measuredWidth > param1 * (40 / 100))
         {
            this.editDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.editDesc.width = this.editDesc.measuredWidth;
         }
         var _loc3_:Point = globalToLocal(this.edit.parent.localToGlobal(new Point(this.edit.x,this.edit.y)));
         this.editDesc.right = param1 - _loc3_.x + param1 * (5 / 100);
         this.editDesc.y = this.edit.height + (param2 - this.edit.height) * (10 / 100);
         if(this.addDesc.measuredWidth > param1 * (40 / 100))
         {
            this.addDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.addDesc.width = this.addDesc.measuredWidth;
         }
         this.addDesc.right = param1 * (5 / 100);
         this.addDesc.y = this.editDesc.y + this.editDesc.height + param2 * (15 / 100);
         if(this.portalDesc.measuredWidth > param1 * (40 / 100))
         {
            this.portalDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.portalDesc.width = this.portalDesc.measuredWidth;
         }
         this.portalDesc.left = param1 * (5 / 100);
         this.portalDesc.y = this.portal.height + (param2 - this.portal.height) * (18 / 100);
         if(this.emailDesc.measuredWidth > param1 * (40 / 100))
         {
            this.emailDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.emailDesc.width = this.emailDesc.measuredWidth;
         }
         this.emailDesc.right = param1 * (50 / 100);
         this.emailDesc.bottom = this.email.height + (param2 - this.email.height) * (15 / 100);
         if(this.menuDesc.measuredWidth > param1 * (40 / 100))
         {
            this.menuDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.menuDesc.width = this.menuDesc.measuredWidth;
         }
         this.menuDesc.right = param1 * (5 / 100);
         this.menuDesc.bottom = this.menu.height + (param2 - this.menu.height) * (30 / 100);
      }
   }
}
