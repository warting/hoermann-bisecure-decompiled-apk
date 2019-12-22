package com.isisic.remote.hoermann.views.options
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.components.BottomBar;
   import com.isisic.remote.hoermann.components.GatewayDisplay;
   import com.isisic.remote.hoermann.components.HmList;
   import com.isisic.remote.hoermann.components.overlays.screens.OptionsScreenOverlay;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.events.BottomBarEvent;
   import com.isisic.remote.hoermann.global.AppData;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.GatewayData;
   import com.isisic.remote.hoermann.views.options.settings.ChangeGatewayName;
   import com.isisic.remote.hoermann.views.options.settings.ChangePasswordScreen;
   import com.isisic.remote.hoermann.views.options.settings.DefaultGatewayScreen;
   import com.isisic.remote.hoermann.views.options.settings.ManagePopups;
   import com.isisic.remote.hoermann.views.options.settings.ResetLoginScreen;
   import com.isisic.remote.hoermann.views.options.settings.WifiSettingsScreen;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.net.ConnectionTypes;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.View;
   import spark.events.IndexChangeEvent;
   
   use namespace mx_internal;
   
   public class OptionsScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _3016817bbar:BottomBar;
      
      private var _205678947btnBack:Button;
      
      private var _1206766158gwDisplay:GatewayDisplay;
      
      private var _341169060optionsList:HmList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _321162577optionsProvider:ArrayCollection;
      
      private var context:ConnectionContext;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function OptionsScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._OptionsScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_OptionsScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return OptionsScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._OptionsScreen_Button1_i()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._OptionsScreen_Array2_c);
         this.addEventListener("initialize",this.___OptionsScreen_View1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         OptionsScreen._watcherSetupUtil = param1;
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
      
      private function initComp() : void
      {
         this.context = HoermannRemote.appData.activeConnection;
         var options:Array = [{
            "name":Lang.getString("OPTIONS_LEARNED_PORTS") + " - / " + AppData.MAX_PORTS,
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
         if(HoermannRemote.appData.isAdmin)
         {
            options.push({
               "name":Lang.getString("OPTIONS_CHANGE_GATEWAY_NAME"),
               "view":ChangeGatewayName
            });
            if(HoermannRemote.appData.activeConnection.connectionType == ConnectionTypes.LOCAL)
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
         this.optionsProvider = new ArrayCollection(options);
         HoermannRemote.gatewayData.addEventListener(GatewayData.PORT_COUNT_CHANGED,this.updatePortCount);
         HoermannRemote.gatewayData.updatePortCount(this.context);
         if(HoermannRemote.gatewayData.portCount > 0)
         {
            this.updatePortCount();
         }
         this.bbar.addEventListener(BottomBarEvent.HELP,function(param1:Event):void
         {
            new OptionsScreenOverlay(btnBack,bbar.callout).open(null);
         });
      }
      
      private function updatePortCount(param1:Event = null) : void
      {
         if(param1)
         {
            HoermannRemote.gatewayData.removeEventListener(GatewayData.PORT_COUNT_CHANGED,this.updatePortCount);
         }
         this.optionsProvider.getItemAt(0).name = Lang.getString("OPTIONS_LEARNED_PORTS") + " " + HoermannRemote.gatewayData.portCount + " / " + AppData.MAX_PORTS;
         this.optionsProvider.refresh();
      }
      
      private function onOptionSelected(param1:IndexChangeEvent) : void
      {
         param1.preventDefault();
         if(Features.presenterVersion)
         {
            if(this.optionsList.selectedItem.view == WifiSettingsScreen)
            {
               Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
               return;
            }
         }
         if(!this.optionsList.selectedItem || !this.optionsList.selectedItem.view)
         {
            return;
         }
         this.navigator.pushView(this.optionsList.selectedItem.view);
      }
      
      private function _OptionsScreen_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.__btnBack_click);
         _loc1_.id = "btnBack";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnBack = _loc1_;
         BindingManager.executeBindings(this,"btnBack",this.btnBack);
         return _loc1_;
      }
      
      public function __btnBack_click(param1:MouseEvent) : void
      {
         this.navigator.popView();
      }
      
      private function _OptionsScreen_Array2_c() : Array
      {
         var _loc1_:Array = [this._OptionsScreen_GatewayDisplay1_i(),this._OptionsScreen_HmList1_i(),this._OptionsScreen_BottomBar1_i()];
         return _loc1_;
      }
      
      private function _OptionsScreen_GatewayDisplay1_i() : GatewayDisplay
      {
         var _loc1_:GatewayDisplay = new GatewayDisplay();
         _loc1_.percentWidth = 100;
         _loc1_.id = "gwDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gwDisplay = _loc1_;
         BindingManager.executeBindings(this,"gwDisplay",this.gwDisplay);
         return _loc1_;
      }
      
      private function _OptionsScreen_HmList1_i() : HmList
      {
         var _loc1_:HmList = new HmList();
         _loc1_.left = 50;
         _loc1_.right = 50;
         _loc1_.itemRenderer = this._OptionsScreen_ClassFactory1_c();
         _loc1_.addEventListener("changing",this.__optionsList_changing);
         _loc1_.id = "optionsList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.optionsList = _loc1_;
         BindingManager.executeBindings(this,"optionsList",this.optionsList);
         return _loc1_;
      }
      
      private function _OptionsScreen_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = OptionsRenderer;
         return _loc1_;
      }
      
      public function __optionsList_changing(param1:IndexChangeEvent) : void
      {
         this.onOptionSelected(param1);
      }
      
      private function _OptionsScreen_BottomBar1_i() : BottomBar
      {
         var _loc1_:BottomBar = new BottomBar();
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.id = "bbar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bbar = _loc1_;
         BindingManager.executeBindings(this,"bbar",this.bbar);
         return _loc1_;
      }
      
      public function ___OptionsScreen_View1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      private function _OptionsScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         result[2] = new Binding(this,function():Object
         {
            return gwDisplay.height;
         },null,"optionsList.top");
         result[3] = new Binding(this,function():Object
         {
            return bbar.height;
         },null,"optionsList.bottom");
         result[4] = new Binding(this,function():IList
         {
            return optionsProvider;
         },null,"optionsList.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bbar() : BottomBar
      {
         return this._3016817bbar;
      }
      
      public function set bbar(param1:BottomBar) : void
      {
         var _loc2_:Object = this._3016817bbar;
         if(_loc2_ !== param1)
         {
            this._3016817bbar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bbar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get btnBack() : Button
      {
         return this._205678947btnBack;
      }
      
      public function set btnBack(param1:Button) : void
      {
         var _loc2_:Object = this._205678947btnBack;
         if(_loc2_ !== param1)
         {
            this._205678947btnBack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnBack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gwDisplay() : GatewayDisplay
      {
         return this._1206766158gwDisplay;
      }
      
      public function set gwDisplay(param1:GatewayDisplay) : void
      {
         var _loc2_:Object = this._1206766158gwDisplay;
         if(_loc2_ !== param1)
         {
            this._1206766158gwDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gwDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get optionsList() : HmList
      {
         return this._341169060optionsList;
      }
      
      public function set optionsList(param1:HmList) : void
      {
         var _loc2_:Object = this._341169060optionsList;
         if(_loc2_ !== param1)
         {
            this._341169060optionsList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get optionsProvider() : ArrayCollection
      {
         return this._321162577optionsProvider;
      }
      
      private function set optionsProvider(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._321162577optionsProvider;
         if(_loc2_ !== param1)
         {
            this._321162577optionsProvider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"optionsProvider",_loc2_,param1));
            }
         }
      }
   }
}
