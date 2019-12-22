package refactor.bisecur._1_APP.views.bootloader
{
   import com.isisic.remote.hoermann.global.CustomFeatures;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.lw.IDisposable;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import refactor.bisecur._1_APP.views.gateways.GatewayScreen;
   import refactor.bisecur._2_SAL.appUpgrades.AppUpgrader;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
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
         DAOFactory.createDAOS();
         AppUpgrader.UpgradeApp(function():void
         {
            new CustomFeatures().load().apply().dispose();
            Features.apply();
            MultiDevice.exec();
            navigator.replaceView(GatewayScreen,null,null,new ViewTransitionBase());
            dispose();
         });
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
