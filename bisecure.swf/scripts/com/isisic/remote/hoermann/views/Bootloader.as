package com.isisic.remote.hoermann.views
{
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.JSONConfig;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.views.gateways.GatewayScreen;
   import com.isisic.remote.lw.IDisposable;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import spark.components.View;
   import spark.transitions.ViewTransitionBase;
   
   public class Bootloader extends View implements IDisposable
   {
      
      public static var useAutoLogin:Boolean = true;
       
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function Bootloader()
      {
         super();
         mx_internal::_document = this;
         this.addEventListener("creationComplete",this.___Bootloader_View1_creationComplete);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function onComplete() : void
      {
         var _loc1_:AsConfig = null;
         if(!HoermannRemote.appData)
         {
            _loc1_ = new JSONConfig();
            HoermannRemote.appData = new AppData(_loc1_);
            HoermannRemote.gatewayData = new GatewayData();
            HoermannRemote.appData.useAutoLogin = useAutoLogin;
         }
         navigator.replaceView(GatewayScreen,null,null,new ViewTransitionBase());
         this.dispose();
      }
      
      public function dispose() : void
      {
         this.removeAllElements();
      }
      
      public function ___Bootloader_View1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
   }
}
