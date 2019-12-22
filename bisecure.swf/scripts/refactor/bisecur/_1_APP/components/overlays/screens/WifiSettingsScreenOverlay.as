package refactor.bisecur._1_APP.components.overlays.screens
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlay;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayAction;
   import refactor.bisecur._1_APP.components.overlays.AutoDrawOverlayDirection;
   import spark.components.Label;
   
   public class WifiSettingsScreenOverlay extends AutoDrawOverlay
   {
       
      
      private var stateIcon:IVisualElement;
      
      private var stateLabel:IVisualElement;
      
      private var stateDesc:Label;
      
      private var ssidField:IVisualElement;
      
      private var ssidFieldDesc:Label;
      
      private var scanSsid:IVisualElement;
      
      private var scanSsidDesc:Label;
      
      private var passphrase:IVisualElement;
      
      private var passphraseDesc:Label;
      
      private var submit:IVisualElement;
      
      private var submitDesc:Label;
      
      private var back:IVisualElement;
      
      private var backDesc:Label;
      
      private var menu:IVisualElement;
      
      private var menuDesc:Label;
      
      public function WifiSettingsScreenOverlay(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement, param5:IVisualElement, param6:IVisualElement, param7:IVisualElement, param8:IVisualElement)
      {
         super();
         this.stateIcon = param1;
         this.stateLabel = param2;
         this.ssidField = param3;
         this.scanSsid = param4;
         this.passphrase = param5;
         this.submit = param6;
         this.back = param7;
         this.menu = param8;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         pxCOffset = 15;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.stateDesc = new Label();
         this.stateDesc.text = Lang.getString("DESC_WIFI_STATE");
         this.addElement(this.stateDesc);
         this.addArrow(new AutoDrawOverlayAction(this.stateDesc,this.stateIcon,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.addArrow(new AutoDrawOverlayAction(this.stateDesc,this.stateLabel,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.AUTO));
         this.ssidFieldDesc = new Label();
         this.ssidFieldDesc.text = Lang.getString("DESC_WIFI_NETWORK_NAME");
         this.addElement(this.ssidFieldDesc);
         this.addArrow(new AutoDrawOverlayAction(this.ssidFieldDesc,this.ssidField,AutoDrawOverlayDirection.RIGHT,AutoDrawOverlayDirection.AUTO));
         this.scanSsidDesc = new Label();
         this.scanSsidDesc.text = Lang.getString("DESC_WIFI_NETWORK_SCAN");
         this.addElement(this.scanSsidDesc);
         this.addArrow(new AutoDrawOverlayAction(this.scanSsidDesc,this.scanSsid,AutoDrawOverlayDirection.BOTTOM,AutoDrawOverlayDirection.TOP));
         this.passphraseDesc = new Label();
         this.passphraseDesc.text = Lang.getString("DESC_WIFI_PASSWORD");
         this.addElement(this.passphraseDesc);
         this.addArrow(new AutoDrawOverlayAction(this.passphraseDesc,this.passphrase,AutoDrawOverlayDirection.RIGHT,AutoDrawOverlayDirection.AUTO));
         this.submitDesc = new Label();
         this.submitDesc.text = Lang.getString("DESC_WIFI_SAVE");
         this.addElement(this.submitDesc);
         this.addArrow(new AutoDrawOverlayAction(this.submitDesc,this.submit,AutoDrawOverlayDirection.AUTO,AutoDrawOverlayDirection.AUTO));
         this.backDesc = new Label();
         this.backDesc.text = Lang.getString("DESC_WIFI_BACK");
         this.addElement(this.backDesc);
         this.addArrow(new AutoDrawOverlayAction(this.backDesc,this.back,AutoDrawOverlayDirection.LEFT,AutoDrawOverlayDirection.BOTTOM));
         this.menuDesc = new Label();
         this.menuDesc.text = Lang.getString("DESC_MENU");
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = globalToLocal(this.stateIcon.parent.localToGlobal(new Point(this.stateIcon.x,this.stateIcon.y)));
         var _loc4_:Point = globalToLocal(this.stateLabel.parent.localToGlobal(new Point(this.stateLabel.x,this.stateLabel.y)));
         this.stateDesc.x = _loc4_.x + this.stateLabel.width * 0.55;
         this.stateDesc.y = _loc3_.y - param2 * (15 / 100);
         if(this.stateDesc.y < 0)
         {
            this.stateDesc.y = 15;
         }
         var _loc5_:Point = globalToLocal(this.ssidField.parent.localToGlobal(new Point(this.ssidField.x,this.ssidField.y)));
         this.ssidFieldDesc.x = param1 * (10 / 100);
         this.ssidFieldDesc.y = _loc3_.y + this.stateIcon.height;
         var _loc6_:Point = globalToLocal(this.scanSsid.parent.localToGlobal(new Point(this.scanSsid.x,this.scanSsid.y)));
         this.scanSsidDesc.x = _loc6_.x + this.scanSsid.width - this.scanSsidDesc.width;
         this.scanSsidDesc.y = _loc6_.y - this.scanSsid.height * 2;
         var _loc7_:Point = globalToLocal(this.passphrase.parent.localToGlobal(new Point(this.passphrase.x,this.passphrase.y)));
         this.passphraseDesc.x = _loc7_.x + this.passphrase.width * 0.1;
         this.passphraseDesc.y = _loc5_.y + this.ssidField.height / 2;
         var _loc8_:Point = globalToLocal(this.back.parent.localToGlobal(new Point(this.back.x,this.back.y)));
         var _loc9_:Point = globalToLocal(this.submit.parent.localToGlobal(new Point(this.submit.x,this.submit.y)));
         this.backDesc.x = _loc8_.x + this.back.width * 0.6;
         this.backDesc.y = _loc9_.y + this.back.height + this.stateDesc.height;
         this.submitDesc.x = _loc9_.x + (this.submit.width / 2 - this.submitDesc.width / 2) + 10;
         this.submitDesc.y = _loc9_.y - this.submitDesc.height * 2;
         this.menuDesc.right = param1 * (5 / 100);
         this.menuDesc.bottom = this.menu.height + (param2 - this.menu.height) * (13 / 100);
         super.updateDisplayList(param1,param2);
      }
   }
}
