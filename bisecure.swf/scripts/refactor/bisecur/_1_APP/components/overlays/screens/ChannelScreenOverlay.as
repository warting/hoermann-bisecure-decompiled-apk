package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class ChannelScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var back:IVisualElement;
      
      private var backDesc:Label;
      
      private var stateImg:IVisualElement;
      
      private var stateLbl:IVisualElement;
      
      private var stateDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      private var firstButton:IVisualElement;
      
      private var lastButton:IVisualElement;
      
      private var buttonDesc:Label;
      
      public function ChannelScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement, param6:IVisualElement)
      {
         super();
         this.back = param1;
         this.stateLbl = param2;
         this.stateImg = param3;
         this.menu = param4;
         this.firstButton = param5;
         this.lastButton = param6;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.backDesc = new Label();
         this.backDesc.text = Lang.getString("DESC_CHANNELS_BACK");
         this.addElement(this.backDesc);
         this.addArrow(new AutoDrawOverlayAction(this.backDesc,this.back,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.RIGHT));
         this.stateDesc = new Label();
         this.stateDesc.text = Lang.getString("DESC_CHANNELS_STATE");
         this.addElement(this.stateDesc);
         this.addArrow(new AutoDrawOverlayAction(this.stateDesc,this.stateImg,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         if(this.stateLbl)
         {
            this.addArrow(new AutoDrawOverlayAction(this.stateDesc,this.stateLbl,AutoDrawOverlayDirection.TOP,AutoDrawOverlayDirection.BOTTOM));
         }
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
         if(this.firstButton != null)
         {
            this.buttonDesc = new Label();
            this.buttonDesc.text = Lang.getString("DESC_CHANNELS_BUTTONS");
            this.addElement(this.buttonDesc);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc3_:Point = this.globalToLocal(this.stateImg.parent.localToGlobal(new Point(this.stateImg.x,this.stateImg.y)));
         if(this.backDesc.measuredWidth > param1 * (50 / 100))
         {
            this.backDesc.width = param1 * (50 / 100);
         }
         else
         {
            this.backDesc.width = this.backDesc.measuredWidth;
         }
         this.backDesc.x = this.back.width + param1 * (15 / 100);
         this.backDesc.y = this.back.y + (this.back.height - this.backDesc.height / 2);
         if(this.stateDesc.measuredWidth > param1 * (40 / 100))
         {
            this.stateDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.stateDesc.width = this.stateDesc.measuredWidth;
         }
         this.stateDesc.right = param1 * (10 / 100);
         this.stateDesc.y = this.stateImg.height + _loc3_.y + param2 * (15 / 100);
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
         super.updateDisplayList(param1,param2);
         if(this.firstButton == null)
         {
            return;
         }
         if(this.lastButton == null)
         {
            this.lastButton = this.firstButton;
         }
         var _loc4_:Point = this.globalToLocal(this.firstButton.parent.localToGlobal(new Point(this.firstButton.x,this.firstButton.y)));
         var _loc5_:Point = this.globalToLocal(this.lastButton.parent.localToGlobal(new Point(this.lastButton.x,this.lastButton.y)));
         if((_loc6_ = getStyle("arrowThickness")) == undefined)
         {
            _loc6_ = 5;
         }
         if((_loc7_ = getStyle("arrowColor")) == undefined)
         {
            _loc7_ = 10035763;
         }
         if((_loc8_ = getStyle("arrowAlpha")) == undefined)
         {
            _loc8_ = 0.5;
         }
         canvas.graphics.lineStyle(_loc6_,_loc7_,_loc8_);
         var _loc9_:Number = param1 * (2 / 100);
         var _loc10_:Number = 25;
         canvas.graphics.moveTo(_loc4_.x + _loc9_ - _loc10_,_loc4_.y - _loc10_);
         canvas.graphics.lineTo(_loc4_.x - _loc10_,_loc4_.y - _loc10_);
         canvas.graphics.lineTo(_loc4_.x - _loc10_,_loc5_.y + this.lastButton.height + _loc10_);
         canvas.graphics.lineTo(_loc4_.x + _loc9_ - _loc10_,_loc5_.y + this.lastButton.height + _loc10_);
         canvas.graphics.lineStyle();
         if(this.buttonDesc.measuredWidth > param1 * (40 / 100))
         {
            this.buttonDesc.width = param1 * (40 / 100);
         }
         else
         {
            this.buttonDesc.width = this.buttonDesc.measuredWidth;
         }
         this.buttonDesc.x = param1 * (5 / 100);
         this.buttonDesc.y = _loc5_.y + this.lastButton.height + param2 * (2 / 100);
      }
   }
}
