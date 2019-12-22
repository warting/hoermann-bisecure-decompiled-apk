package
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.lw.Debug;
   import flash.system.Capabilities;
   import me.mweber.basic.helper.ApplicationHelper;
   import me.mweber.basic.helper.CSSHelper;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.IVisualElement;
   import mx.styles.CSSStyleDeclaration;
   
   public final class MultiDevice
   {
      
      public static var screenSize:String;
      
      public static var htmlFontSize:Number;
       
      
      public function MultiDevice()
      {
         super();
      }
      
      public static function getFxg(param1:Class) : IVisualElement
      {
         var _loc2_:IVisualElement = new param1();
         if(Capabilities.os.indexOf("Win") > -1)
         {
            return _loc2_;
         }
         if(Capabilities.os.indexOf("Mac") > -1)
         {
            return _loc2_;
         }
         switch(screenSize)
         {
            case ScreenSizes.XXLARGE:
               _loc2_.width = _loc2_.width * 3;
               _loc2_.height = _loc2_.height * 3;
               break;
            case ScreenSizes.XLARGE:
               _loc2_.width = _loc2_.width * 1.5;
               _loc2_.height = _loc2_.height * 1.5;
               break;
            case ScreenSizes.LARGE:
               break;
            case ScreenSizes.NORMAL:
               break;
            case ScreenSizes.SMALL:
         }
         return _loc2_;
      }
      
      public static function screen_small() : void
      {
         htmlFontSize = 10;
         if(ApplicationHelper.currentOS() == "IOS")
         {
            htmlFontSize = 40;
         }
      }
      
      public static function screen_normal() : void
      {
         htmlFontSize = 10;
      }
      
      public static function screen_large() : void
      {
         if(HoermannRemote.app == null)
         {
            return;
         }
         htmlFontSize = 30;
         HoermannRemote.app.setStyle("fontSize",40);
         var _loc1_:CSSStyleDeclaration = HoermannRemote.app.styleManager.getStyleDeclaration(".channelContentTitle");
         if(!CSSHelper.applyForStylename("fontSize",50,".channelContentTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] title adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",40,".channelContentState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] state adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",50,"com.isisic.remote.hoermann.components.overlays.OverlayBase spark.components.Label",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] overlay adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",40,"*.mixed .popupTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",30,"*.mixed .popupContent",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",30,".actorTime",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",30,".actorState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",50,"spark.components.ActionBar #titleDisplay",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",35,"*.mixed .subTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] GatewayRenderer .subTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("circleFontSize",30,"com.isisic.remote.hoermann.views.notifications.NotificationIcon",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] NotificationIcon circleFontSize adjusting failed");
         }
      }
      
      public static function screen_xlarge() : void
      {
         if(HoermannRemote.app == null)
         {
            return;
         }
         htmlFontSize = 30;
         HoermannRemote.app.setStyle("fontSize",60);
         var _loc1_:CSSStyleDeclaration = HoermannRemote.app.styleManager.getStyleDeclaration(".channelContentTitle");
         if(!CSSHelper.applyForStylename("fontSize",60,".channelContentTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] title adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",50,".channelContentState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] state adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",60,"com.isisic.remote.hoermann.components.overlays.OverlayBase spark.components.Label",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] overlay adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",50,"*.mixed .popupTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",40,"*.mixed .popupContent",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",35,".actorTime",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",35,".actorState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",50,"spark.components.ActionBar #titleDisplay",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",35,"*.mixed .subTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] GatewayRenderer .subTitle adjusting failed!");
         }
      }
      
      public static function screen_xxlarge() : void
      {
         if(HoermannRemote.app == null)
         {
            return;
         }
         htmlFontSize = 30;
         HoermannRemote.app.setStyle("fontSize",80);
         var _loc1_:CSSStyleDeclaration = HoermannRemote.app.styleManager.getStyleDeclaration(".channelContentTitle");
         if(!CSSHelper.applyForStylename("fontSize",90,".channelContentTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] title adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",80,".channelContentState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] state adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",90,"com.isisic.remote.hoermann.components.overlays.OverlayBase spark.components.Label",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] overlay adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",80,"*.mixed .popupTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",70,"*.mixed .popupContent",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .popupTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",65,".actorTime",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",65,".actorState",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .actorState adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",90,"spark.components.ActionBar #titleDisplay",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] spark.components.ActionBar #titleDisplay adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",65,"*.mixed .subTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] *.mixed com.isisic.remote.hoermann.views.gateways.GatewayRenderer .subTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",70,".listNoteTitle",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .listNoteTitle adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("fontSize",60,".listNoteContent",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] .listNoteContent adjusting failed!");
         }
         if(!CSSHelper.applyForStylename("borderSize",2,"*.mixed com.isisic.remote.hoermann.skins.GateButtonSkin",HoermannRemote.app))
         {
            Debug.error("[MultiDevice] GateButtonSkin adjusting failed!");
         }
      }
      
      public static function dpi_160() : void
      {
      }
      
      public static function dpi_240() : void
      {
      }
      
      public static function dpi_320() : void
      {
      }
      
      public static function exec() : void
      {
         Debug.info("[MultiDevice] running compatibility");
         MultiDevice.exec_DPI();
         MultiDevice.exec_SceenSize();
      }
      
      public static function exec_DPI() : void
      {
         switch(FlexGlobals.topLevelApplication.applicationDPI)
         {
            case DPIClassification.DPI_160:
               MultiDevice.dpi_160();
               break;
            case DPIClassification.DPI_240:
               MultiDevice.dpi_240();
               break;
            case DPIClassification.DPI_320:
               MultiDevice.dpi_320();
         }
      }
      
      public static function exec_SceenSize() : void
      {
         if(Capabilities.os.indexOf("Win") > -1 || Capabilities.os.indexOf("Mac") > -1)
         {
            MultiDevice.screen_normal();
            MultiDevice.screenSize = ScreenSizes.NORMAL;
            Debug.info("[MultiDevice] Win or Mac OS detected => forcing ScreenSize: " + MultiDevice.screenSize);
            return;
         }
         var _loc1_:Number = !!Features.shouldForceDPI?Number(Features.forceDPI):Number(Capabilities.screenDPI);
         var _loc2_:Number = Capabilities.screenResolutionX;
         var _loc3_:Number = Capabilities.screenResolutionY;
         var _loc4_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         var _loc5_:Number = Math.sqrt(_loc4_) / _loc1_;
         var _loc6_:String = "UNKNOWN";
         if(_loc5_ >= 20)
         {
            MultiDevice.screen_xxlarge();
            MultiDevice.screenSize = ScreenSizes.XXLARGE;
            _loc6_ = ScreenSizes.XXLARGE;
         }
         else if(_loc5_ >= 8)
         {
            MultiDevice.screen_xlarge();
            MultiDevice.screenSize = ScreenSizes.XLARGE;
            _loc6_ = ScreenSizes.XLARGE;
         }
         else if(_loc5_ >= 6)
         {
            MultiDevice.screen_large();
            MultiDevice.screenSize = ScreenSizes.LARGE;
            _loc6_ = ScreenSizes.LARGE;
         }
         else if(_loc5_ >= 4)
         {
            MultiDevice.screen_normal();
            MultiDevice.screenSize = ScreenSizes.NORMAL;
            _loc6_ = ScreenSizes.NORMAL;
         }
         else
         {
            MultiDevice.screen_small();
            MultiDevice.screenSize = ScreenSizes.SMALL;
            _loc6_ = ScreenSizes.SMALL;
         }
         Debug.info("[MultiDevice] ScreenSize: " + _loc5_ + " => " + _loc6_);
      }
   }
}
