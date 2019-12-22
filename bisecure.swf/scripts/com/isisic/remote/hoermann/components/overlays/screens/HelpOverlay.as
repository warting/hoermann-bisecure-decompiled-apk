package com.isisic.remote.hoermann.components.overlays.screens
{
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlay;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayAction;
   import com.isisic.remote.hoermann.components.overlays.AutoDrawOverlayDirection;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import mx.core.IVisualElement;
   import spark.components.Label;
   
   public class HelpOverlay extends AutoDrawOverlay
   {
       
      
      private var help:IVisualElement;
      
      private var helpDesc:Label;
      
      public function HelpOverlay(param1:IVisualElement)
      {
         super();
         this.help = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.helpDesc = new Label();
         this.helpDesc.text = Lang.getString("DESC_HELP");
         this.addElement(this.helpDesc);
         this.addArrow(new AutoDrawOverlayAction(this.helpDesc,this.help,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.helpDesc.measuredWidth > param2 * (50 / 100))
         {
            this.helpDesc.width = param2 * (50 / 100);
         }
         else
         {
            this.helpDesc.width = this.helpDesc.measuredWidth;
         }
         this.helpDesc.right = param2 * (5 / 100);
         this.helpDesc.bottom = this.help.height + (param1 - this.help.height) * (20 / 100);
      }
   }
}
