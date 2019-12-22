package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayDirection;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class HomeScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var actors:IVisualElement;
      
      private var actorsDesc:Label;
      
      private var scenarios:IVisualElement;
      
      private var scenariosDesc:Label;
      
      private var prefs:IVisualElement;
      
      private var prefsDesc:Label;
      
      private var users:IVisualElement;
      
      private var usersDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function HomeScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement)
      {
         super();
         this.actors = param1;
         this.scenarios = param2;
         this.prefs = param3;
         this.users = param4;
         this.menu = param5;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.actorsDesc = new Label();
         this.actorsDesc.text = Lang.getString("DESC_HOME_ACTORS");
         this.addElement(this.actorsDesc);
         this.addArrow(new AutoDrawOverlayAction(this.actorsDesc,this.actors,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.scenariosDesc = new Label();
         this.scenariosDesc.text = Lang.getString("DESC_HOME_SCENARIOS");
         this.addElement(this.scenariosDesc);
         this.addArrow(new AutoDrawOverlayAction(this.scenariosDesc,this.scenarios,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.RIGHT));
         this.prefsDesc = new Label();
         this.prefsDesc.text = Lang.getString("DESC_HOME_PREFERENCES");
         this.addElement(this.prefsDesc);
         this.addArrow(new AutoDrawOverlayAction(this.prefsDesc,this.prefs,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.RIGHT));
         if(this.users)
         {
            this.usersDesc = new Label();
            this.usersDesc.text = Lang.getString("DESC_HOME_USERS");
            this.addElement(this.usersDesc);
            this.addArrow(new AutoDrawOverlayAction(this.usersDesc,this.users,AutoDrawOverlayDirection.TOP,AutoDrawOverlayDirection.BOTTOM));
         }
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc5_:Point = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:Point = this.globalToLocal(this.scenarios.parent.localToGlobal(new Point(this.scenarios.x,this.scenarios.y)));
         var _loc4_:Point = this.globalToLocal(this.prefs.parent.localToGlobal(new Point(this.prefs.x,this.prefs.y)));
         if(this.users)
         {
            _loc5_ = this.globalToLocal(this.users.parent.localToGlobal(new Point(this.users.x,this.users.y)));
         }
         if(this.actorsDesc.measuredWidth > param1 * (50 / 100))
         {
            this.actorsDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.actorsDesc.width = this.actorsDesc.measuredWidth;
         }
         this.actorsDesc.x = param1 * (40 / 100);
         this.actorsDesc.y = param2 * (5 / 100);
         if(this.scenariosDesc.measuredWidth > param1 * (50 / 100))
         {
            this.scenariosDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.scenariosDesc.width = this.scenariosDesc.measuredWidth;
         }
         this.scenariosDesc.right = param1 * (2 / 100);
         this.scenariosDesc.y = _loc3_.y + param2 * (2 / 100);
         if(this.prefsDesc.measuredWidth > param1 * (40 / 100))
         {
            this.prefsDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.prefsDesc.width = this.prefsDesc.measuredWidth;
         }
         this.prefsDesc.right = param1 * (5 / 100);
         this.prefsDesc.y = _loc4_.y + this.prefs.height;
         if(this.users)
         {
            if(this.usersDesc.measuredWidth > param1 * (50 / 100))
            {
               this.usersDesc.width = param1 * (50 / 100);
            }
            else
            {
               this.usersDesc.width = this.usersDesc.measuredWidth;
            }
            this.usersDesc.left = param1 * (5 / 100);
            this.usersDesc.y = _loc5_.y + this.users.height + param2 * (15 / 100);
         }
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
