package refactor.bisecur._1_APP.views.settings
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBarEvent;
   import refactor.bisecur._1_APP.components.overlays.screens.OptionsScreenOverlay;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import refactor.bisecur._1_APP.views.settings.subSettings.ChangeGatewayName;
   import refactor.bisecur._1_APP.views.settings.subSettings.ChangePasswordScreen;
   import refactor.bisecur._1_APP.views.settings.subSettings.DefaultGatewayScreen;
   import refactor.bisecur._1_APP.views.settings.subSettings.ManagePopups;
   import refactor.bisecur._1_APP.views.settings.subSettings.ResetLoginScreen;
   import refactor.bisecur._1_APP.views.settings.subSettings.WifiSettingsScreen;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.LocalConnectionContext;
   import refactor.logicware._5_UTIL.LogicwareSettings;
   import spark.events.IndexChangeEvent;
   
   public class SettingsScreenCtrl implements IEventDispatcher
   {
       
      
      public var Icon_Back:IVisualElement;
      
      private var _80818744Title:String;
      
      private var _96312495listProvider:ArrayCollection;
      
      public var view:SettingsScreen;
      
      private var context:ConnectionContext;
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function SettingsScreenCtrl()
      {
         this.Icon_Back = MultiDevice.getFxg(ImgBack);
         this._80818744Title = Lang.getString("OPTIONS");
         this._bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      public function onInit() : void
      {
         this.context = AppCache.sharedCache.connection;
         var options:Array = [{
            "name":Lang.getString("OPTIONS_LEARNED_PORTS") + " - / " + LogicwareSettings.MAX_PORTS,
            "view":null
         },{
            "name":Lang.getString("OPTIONS_RESET_LOGIN_DATA"),
            "view":ResetLoginScreen
         },{
            "name":Lang.getString("OPTIONS_CHANGE_PASSWORD"),
            "view":ChangePasswordScreen
         },{
            "name":Lang.getString("OPTIONS_SET_DEFAULT_GATEWAY"),
            "view":DefaultGatewayScreen
         },{
            "name":Lang.getString("OPTIONS_MANAGE_POPUPS"),
            "view":ManagePopups
         }];
         if(AppCache.sharedCache.loggedInUser.isAdmin)
         {
            options.push({
               "name":Lang.getString("OPTIONS_CHANGE_GATEWAY_NAME"),
               "view":ChangeGatewayName
            });
            if(this.context is LocalConnectionContext)
            {
               if(Features.showWifi)
               {
                  options.push({
                     "name":Lang.getString("OPTIONS_WIFI_SETTINGS"),
                     "view":WifiSettingsScreen
                  });
               }
            }
         }
         this.listProvider = new ArrayCollection(options);
         GatewayPorts.instance.getPortCount(function(param1:Object, param2:int, param3:Error):void
         {
            listProvider.getItemAt(0).name = Lang.getString("OPTIONS_LEARNED_PORTS") + " " + param2 + " / " + LogicwareSettings.MAX_PORTS;
            listProvider.refresh();
         });
      }
      
      public function onOptionSelected(param1:IndexChangeEvent) : void
      {
         param1.preventDefault();
         if(Features.presenterVersion)
         {
            if(this.view.optionsList.selectedItem.view == WifiSettingsScreen)
            {
               Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
               return;
            }
         }
         if(!this.view.optionsList.selectedItem || !this.view.optionsList.selectedItem.view)
         {
            return;
         }
         this.view.navigator.pushView(this.view.optionsList.selectedItem.view);
      }
      
      public function onHelp(param1:BottomBarEvent) : void
      {
         new OptionsScreenOverlay(this.view.btnBack,this.view.bbar.callout).open(null);
      }
      
      [Bindable(event="propertyChange")]
      public function get Title() : String
      {
         return this._80818744Title;
      }
      
      public function set Title(param1:String) : void
      {
         var _loc2_:Object = this._80818744Title;
         if(_loc2_ !== param1)
         {
            this._80818744Title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Title",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get listProvider() : ArrayCollection
      {
         return this._96312495listProvider;
      }
      
      public function set listProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._96312495listProvider;
         if(_loc2_ !== param1)
         {
            this._96312495listProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"listProvider",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}
