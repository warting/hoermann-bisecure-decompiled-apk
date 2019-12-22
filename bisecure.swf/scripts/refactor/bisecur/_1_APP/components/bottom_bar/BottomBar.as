package refactor.bisecur._1_APP.components.bottom_bar
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgHelp;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgMail;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgMenu;
   import com.isisic.remote.hoermann.assets.images.buttons.ImgRefresh;
   import com.isisic.remote.hoermann.assets.images.logos.ImgWM;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import me.mweber.basic.wrapper.animations.ShakeAnimation;
   import me.mweber.basic.wrapper.gestures.longPress.LongPressEvent;
   import me.mweber.basic.wrapper.gestures.longPress.LongPressRecognizer;
   import mx.controls.Spacer;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import refactor.bisecur._1_APP.components.popups.AppInfoBox;
   import refactor.bisecur._1_APP.components.popups.InfoBox;
   import refactor.bisecur._1_APP.components.popups.SetDebugInfoBox;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._1_APP.views.debug.showDaoData.ShowDaoDataScreen;
   import refactor.bisecur._1_APP.views.notifications.NotificationCenter;
   import refactor.bisecur._1_APP.views.notifications.NotificationIcon;
   import refactor.bisecur._1_APP.views.notifications.NotificationLoader;
   import refactor.bisecur._1_APP.views.onlineHelp.HelpScreen;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._5_UTIL.FlexHelper;
   import spark.components.ActionBar;
   import spark.components.Button;
   import spark.components.CalloutButton;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.ViewNavigator;
   import spark.layouts.VerticalLayout;
   
   public class BottomBar extends ActionBar
   {
      
      private static const Wortmarke:Class = ImgWM;
      
      private static const HilfeIcon:Class = ImgHelp;
      
      private static const MenuIcon:Class = ImgMenu;
      
      private static const RefreshIcon:Class = ImgRefresh;
      
      private static const MailIcon:Class = ImgMail;
      
      public static var debugLabel:Label;
      
      private static var _username:String = "";
       
      
      private var logo:IVisualElement;
      
      private var sp1:Spacer;
      
      public var help:Button;
      
      public var calloutNotifier:NotificationIcon;
      
      public var callout:CalloutButton;
      
      public var refresh:Button;
      
      public var email:Button;
      
      private var coInfo:Button;
      
      private var coNotifications:Button;
      
      private var coNotificationDisplay:NotificationIcon;
      
      var coLogout:Button;
      
      private var tmpInfoEnabled:Boolean = true;
      
      private var tmpHistEnabled:Boolean = true;
      
      private var tmpLogoutEnabled:Boolean = true;
      
      private var tmpNotificationsEnabled:Boolean = true;
      
      private var tmpRefreshVisible:Boolean = false;
      
      public function BottomBar()
      {
         super();
      }
      
      public static function set username(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         _username = param1;
      }
      
      public function get refreshEnabled() : Boolean
      {
         return this.refresh.enabled;
      }
      
      public function set refreshEnabled(param1:Boolean) : void
      {
         this.refresh.enabled = param1;
      }
      
      override protected function createChildren() : void
      {
         var self:BottomBar = null;
         super.createChildren();
         self = this;
         this.sp1 = new Spacer();
         this.sp1.width = this.horizontalPadding;
         this.logo = MultiDevice.getFxg(Wortmarke);
         if(Features.showDebugLabel)
         {
            debugLabel = new Label();
            debugLabel.percentHeight = 100;
            debugLabel.setStyle("color",13421772);
            this.navigationContent = [this.sp1,this.logo,debugLabel];
         }
         else
         {
            this.navigationContent = [this.sp1,this.logo];
         }
         this.help = new Button();
         this.help.setStyle("icon",MultiDevice.getFxg(HilfeIcon));
         var recognizer:LongPressRecognizer = new LongPressRecognizer(this.help as DisplayObject);
         recognizer.addEventListener(LongPressEvent.LONG_PRESS_RECOGNIZED,function(param1:Event):void
         {
            var _loc2_:ShakeAnimation = new ShakeAnimation(self.owner,true);
            _loc2_.start();
         });
         recognizer.addEventListener(LongPressEvent.LONG_PRESS_FINISHED,function(param1:Event):void
         {
            onAboutClick(null);
         });
         recognizer.addEventListener(LongPressEvent.LONG_PRESS_CANCELED,function(param1:LongPressEvent):void
         {
            self.dispatchEvent(new BottomBarEvent(BottomBarEvent.HELP,param1.mouseEvent.altKey,param1.mouseEvent.ctrlKey,param1.mouseEvent.shiftKey,true));
         });
         this.calloutNotifier = new NotificationIcon(MultiDevice.getFxg(MenuIcon));
         this.callout = new CalloutButton();
         this.callout.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(!callout.isDropDownOpen)
            {
               callout.openDropDown();
            }
         },false,0,true);
         this.callout.setStyle("icon",this.calloutNotifier);
         var grp:Group = new Group();
         var layout:VerticalLayout = new VerticalLayout();
         layout.gap = 2;
         grp.layout = layout;
         grp.styleName = "bottomCallout";
         var coDebug:Button = new Button();
         coDebug.label = "DEBUG";
         coDebug.percentWidth = 100;
         coDebug.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            FlexHelper.getNavigator().pushView(ShowDaoDataScreen);
         });
         this.coInfo = new Button();
         this.coInfo.label = Lang.getString("INFO");
         this.coInfo.percentWidth = 100;
         this.coInfo.addEventListener(MouseEvent.CLICK,this.onInfoClick);
         this.coInfo.addEventListener(FlexEvent.CREATION_COMPLETE,this.onInfoComplete);
         this.coLogout = new Button();
         if(_username == "")
         {
            this.coLogout.label = Lang.getString("LOGOUT");
         }
         else
         {
            this.coLogout.label = _username + " " + Lang.getString("LOGOUT_NAMED");
         }
         this.coLogout.percentWidth = 100;
         this.coLogout.addEventListener(MouseEvent.CLICK,this.onLogoutClick);
         this.coLogout.addEventListener(FlexEvent.CREATION_COMPLETE,this.onLogoutComplete);
         var coHelp:Button = new Button();
         coHelp.label = Lang.getString("OPTIONS_HELP");
         coHelp.percentWidth = 100;
         coHelp.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:ViewNavigator = FlexHelper.getNavigator();
            if(_loc2_ != null)
            {
               if(Features.presenterVersion)
               {
                  Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
                  return;
               }
               _loc2_.pushView(HelpScreen);
               dispatchEvent(new BottomBarEvent(BottomBarEvent.ONLINE_HELP));
            }
         });
         this.coNotifications = new Button();
         this.coNotifications.label = Lang.getString("NOTIFICATION_CENTER") + "     ";
         this.coNotifications.percentWidth = 100;
         this.coNotifications.addEventListener(FlexEvent.CREATION_COMPLETE,this.onNotificationsComplete);
         this.coNotifications.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:ViewNavigator = FlexHelper.getNavigator();
            if(_loc2_ != null)
            {
               if(Features.presenterVersion)
               {
                  Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
                  return;
               }
            }
            _loc2_.pushView(NotificationCenter);
            dispatchEvent(new BottomBarEvent(BottomBarEvent.NOTIFICATIONS));
         });
         this.coNotificationDisplay = new NotificationIcon(new Spacer(),"rect");
         this.coNotifications.setStyle("icon",this.coNotificationDisplay);
         this.coNotifications.setStyle("iconPlacement","right");
         grp.addElement(this.coInfo);
         grp.addElement(this.coLogout);
         grp.addElement(coHelp);
         grp.addElement(this.coNotifications);
         var coAbout:Button = new Button();
         coAbout.label = "Details";
         coAbout.percentWidth = 100;
         coAbout.addEventListener(MouseEvent.CLICK,this.onAboutClick);
         if(Features.netDebugging)
         {
            grp.addElement(coAbout);
         }
         var coNetDebug:Button = new Button();
         coNetDebug.label = "Net Log";
         coNetDebug.percentWidth = 100;
         coNetDebug.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            new SetDebugInfoBox().open(null);
         });
         if(Features.netDebugging)
         {
            grp.addElement(coNetDebug);
         }
         var container:Group = new Group();
         container.styleName = "BottomBar";
         container.addElement(grp);
         this.callout.calloutContent = new Array(container);
         this.refresh = new Button();
         this.refresh.setStyle("icon",MultiDevice.getFxg(RefreshIcon));
         this.refresh.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            self.dispatchEvent(new BottomBarEvent(BottomBarEvent.REFRESH,param1.altKey,param1.ctrlKey,param1.shiftKey,true));
         });
         this.refresh.addEventListener(FlexEvent.CREATION_COMPLETE,this.onRefreshCreationComplete);
         this.email = new Button();
         this.email.setStyle("icon",MultiDevice.getFxg(MailIcon));
         this.email.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(Features.presenterVersion)
            {
               Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
               return;
            }
            navigateToURL(new URLRequest("mailto:bisecur-home@hoermann.de?subject=" + Lang.getString("EMAIL_SUBJECT") + "&body=" + Lang.getString("EMAIL_BODY")));
         });
         this.actionContent = [this.refresh,this.email,this.help,this.callout];
      }
      
      protected function onAboutClick(param1:MouseEvent) : void
      {
         new AppInfoBox().open(null);
      }
      
      public function set infoEnabled(param1:Boolean) : void
      {
         this.tmpInfoEnabled = param1;
         if(this.coInfo)
         {
            this.onInfoComplete(null);
         }
      }
      
      public function get infoEnabled() : Boolean
      {
         return this.tmpInfoEnabled;
      }
      
      public function get histEnabled() : Boolean
      {
         return this.tmpHistEnabled;
      }
      
      public function set logoutEnabled(param1:Boolean) : void
      {
         this.tmpLogoutEnabled = param1;
         if(this.coLogout)
         {
            this.onLogoutComplete(null);
         }
      }
      
      public function get logoutEnabled() : Boolean
      {
         return this.tmpLogoutEnabled;
      }
      
      public function get notificationsEnabled() : Boolean
      {
         return this.tmpNotificationsEnabled;
      }
      
      public function set notificationsEnabled(param1:Boolean) : void
      {
         this.tmpNotificationsEnabled = param1;
         if(this.coNotifications)
         {
            this.onNotificationsComplete(null);
         }
      }
      
      public function set showRefresh(param1:Boolean) : void
      {
         this.tmpRefreshVisible = param1;
         if(this.refresh)
         {
            this.onRefreshCreationComplete(null);
         }
      }
      
      public function get showRefresh() : Boolean
      {
         return this.tmpRefreshVisible;
      }
      
      protected function onLogoutClick(param1:MouseEvent) : void
      {
         dispatchEvent(new BottomBarEvent(BottomBarEvent.LOGOUT));
         _username = "";
         this.coLogout.label = Lang.getString("LOGOUT");
         AppCache.sharedCache.logout();
      }
      
      protected function onInfoClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         var _loc2_:InfoBox = new InfoBox();
         _loc2_.open(null);
      }
      
      protected function onLogoutComplete(param1:FlexEvent) : void
      {
         this.coLogout.enabled = this.tmpLogoutEnabled;
      }
      
      protected function onInfoComplete(param1:FlexEvent) : void
      {
         this.coInfo.enabled = this.tmpInfoEnabled;
      }
      
      protected function onNotificationsComplete(param1:FlexEvent) : void
      {
         this.coNotifications.enabled = this.tmpNotificationsEnabled;
      }
      
      protected function onRefreshCreationComplete(param1:FlexEvent) : void
      {
         this.refresh.visible = this.tmpRefreshVisible;
      }
      
      private function get horizontalPadding() : Number
      {
         switch(FlexGlobals.topLevelApplication.applicationDPI)
         {
            case DPIClassification.DPI_320:
               return 26;
            case DPIClassification.DPI_240:
               return 20;
            default:
               return 13;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:NotificationLoader = NotificationLoader.instance;
         var _loc4_:int = _loc3_.notifications.length - _loc3_.seenNotifications.length;
         if(_loc4_ > 0)
         {
            this.calloutNotifier.info = _loc4_.toString();
            this.coNotificationDisplay.info = _loc4_.toString();
         }
      }
   }
}
