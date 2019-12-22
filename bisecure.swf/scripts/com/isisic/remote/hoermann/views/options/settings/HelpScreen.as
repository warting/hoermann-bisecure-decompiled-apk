package com.isisic.remote.hoermann.views.options.settings
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgBack;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.LocationChangeEvent;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import me.mweber.views.WebView;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.controls.Spacer;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import spark.components.BusyIndicator;
   import spark.components.Button;
   import spark.components.View;
   
   use namespace mx_internal;
   
   public class HelpScreen extends View implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _205678947btnBack:Button;
      
      private var _711999985indicator:BusyIndicator;
      
      private var _1223471129webView:WebView;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HelpScreen()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._HelpScreen_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_settings_HelpScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HelpScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.navigationContent = [this._HelpScreen_Button1_i()];
         this.actionContent = [this._HelpScreen_BusyIndicator1_i(),this._HelpScreen_Spacer1_c()];
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._HelpScreen_Array3_c);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HelpScreen._watcherSetupUtil = param1;
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
      
      private function _HelpScreen_Button1_i() : Button
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
      
      private function _HelpScreen_BusyIndicator1_i() : BusyIndicator
      {
         var _loc1_:BusyIndicator = new BusyIndicator();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.styleName = "whiteWheel";
         _loc1_.id = "indicator";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.indicator = _loc1_;
         BindingManager.executeBindings(this,"indicator",this.indicator);
         return _loc1_;
      }
      
      private function _HelpScreen_Spacer1_c() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.width = 15;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _HelpScreen_Array3_c() : Array
      {
         var _loc1_:Array = [this._HelpScreen_WebView1_i()];
         return _loc1_;
      }
      
      private function _HelpScreen_WebView1_i() : WebView
      {
         var _loc1_:WebView = new WebView();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.source = "http://www.bisecur-home.com/videos/gateway-installation";
         _loc1_.addEventListener("locationChange",this.__webView_locationChange);
         _loc1_.id = "webView";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.webView = _loc1_;
         BindingManager.executeBindings(this,"webView",this.webView);
         return _loc1_;
      }
      
      public function __webView_locationChange(param1:LocationChangeEvent) : void
      {
         this.indicator.visible = false;
      }
      
      private function _HelpScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = Lang.getString("OPTIONS_HELP");
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgBack);
         },function(param1:Object):void
         {
            btnBack.setStyle("icon",param1);
         },"btnBack.icon");
         return result;
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
      public function get indicator() : BusyIndicator
      {
         return this._711999985indicator;
      }
      
      public function set indicator(param1:BusyIndicator) : void
      {
         var _loc2_:Object = this._711999985indicator;
         if(_loc2_ !== param1)
         {
            this._711999985indicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"indicator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get webView() : WebView
      {
         return this._1223471129webView;
      }
      
      public function set webView(param1:WebView) : void
      {
         var _loc2_:Object = this._1223471129webView;
         if(_loc2_ !== param1)
         {
            this._1223471129webView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"webView",_loc2_,param1));
            }
         }
      }
   }
}
