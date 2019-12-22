package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.views.ChangeFeatureScreen;
   import com.isisic.remote.lw.Debug;
   import flash.desktop.NativeApplication;
   import me.mweber.basic.wrapper.gestures.longPress.LongPressEvent;
   import me.mweber.basic.wrapper.gestures.longPress.LongPressRecognizer;
   import me.mweber.components.popups.InputBox;
   import spark.events.PopUpEvent;
   
   use namespace ApplicationNamespace;
   
   public class AppInfoBox extends ErrorBox
   {
       
      
      private var longPressRecognizer:LongPressRecognizer;
      
      private var passwordInput:InputBox;
      
      public function AppInfoBox()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         var _loc3_:String = _loc1_._loc2_::["versionNumber"].toString();
         var _loc4_:String = _loc1_._loc2_::["name"];
         var _loc5_:String = "Universal";
         var _loc6_:String = !!Features.useDevPortal?"DEV":"RELEASE";
         this.title = "Details";
         this.contentText = "Air Version: " + NativeApplication.nativeApplication.runtimeVersion + "\n" + "\n" + "App Version: " + _loc3_ + "\n" + "Name: " + _loc4_ + "\n" + "DeviceFamily: " + _loc5_ + "\n";
         this.contentText = this.contentText + ("ApplicationMode: " + _loc6_ + "\n");
         this.contentText = this.contentText + "";
         this.closeable = true;
         this.closeTitle = Lang.getString("GENERAL_SUBMIT");
         this.longPressRecognizer = new LongPressRecognizer(this.lblContent,5000);
         this.longPressRecognizer.addEventListener(LongPressEvent.LONG_PRESS_RECOGNIZED,this.onLongPressRecognize);
         this.longPressRecognizer.addEventListener(LongPressEvent.LONG_PRESS_FINISHED,this.onLongPressFinished);
      }
      
      private function onLongPressRecognize(param1:LongPressEvent) : void
      {
         Debug.info("[AppInfoBox] longPress recognized!");
      }
      
      private function onLongPressFinished(param1:LongPressEvent) : void
      {
         if(this.isUpsideDown(param1))
         {
            if(this.passwordInput == null)
            {
               this.passwordInput = new InputBox();
               this.passwordInput.submitTitle = "OK";
               this.passwordInput.cancelTitle = "CANCEL";
               this.passwordInput.addEventListener(PopUpEvent.CLOSE,this.onPasswordInputClose);
            }
            this.passwordInput.open(HoermannRemote.app);
         }
      }
      
      private function onPasswordInputClose(param1:PopUpEvent) : void
      {
         if(param1.commit == false)
         {
            return;
         }
         if(param1.data == "0815dev")
         {
            HoermannRemote.app.navigator.pushView(ChangeFeatureScreen);
            this.close();
         }
      }
      
      private function isUpsideDown(param1:LongPressEvent) : Boolean
      {
         return this.systemManager != null && this.systemManager.stage != null && this.systemManager.stage.deviceOrientation == "upsideDown" || param1.mouseEvent != null && param1.mouseEvent.altKey;
      }
   }
}
