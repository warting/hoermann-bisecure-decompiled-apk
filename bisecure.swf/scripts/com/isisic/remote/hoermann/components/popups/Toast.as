package com.isisic.remote.hoermann.components.popups
{
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.utils.getDefinitionByName;
   import me.mweber.basic.AutoDisposeTimer;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import spark.components.BorderContainer;
   import spark.components.Label;
   import spark.components.SkinnablePopUpContainer;
   import spark.events.PopUpEvent;
   import spark.layouts.HorizontalLayout;
   
   use namespace mx_internal;
   
   public class Toast extends SkinnablePopUpContainer implements IBindingClient
   {
      
      public static const DURATION_LONG:int = 3500;
      
      public static const DURATION_SHORT:int = 2000;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _954925063message:String;
      
      private var _1766135109messageDisplay:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function Toast()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._Toast_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_components_popups_ToastWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return Toast[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._Toast_Array1_c);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function show(param1:String, param2:int) : Toast
      {
         var toast:Toast = null;
         var onOpen:Function = null;
         var message:String = param1;
         var duration:int = param2;
         toast = new Toast();
         toast.message = message;
         toast.addEventListener(PopUpEvent.OPEN,onOpen = function(param1:PopUpEvent):void
         {
            var event:PopUpEvent = param1;
            toast.removeEventListener(PopUpEvent.OPEN,onOpen);
            new AutoDisposeTimer(duration,function(param1:TimerEvent):void
            {
               toast.close(true);
            }).start();
         });
         toast.open(UIComponent(HoermannRemote.app));
         return toast;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         Toast._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         x = (param1.width - this.width) / 2;
         y = param1.height - this.height * 1.25;
      }
      
      private function _Toast_Array1_c() : Array
      {
         var _loc1_:Array = [this._Toast_BorderContainer1_c()];
         return _loc1_;
      }
      
      private function _Toast_BorderContainer1_c() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.styleName = "toastMessage";
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.layout = this._Toast_HorizontalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._Toast_Array2_c);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _Toast_HorizontalLayout1_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.paddingTop = 5;
         _loc1_.paddingBottom = 5;
         _loc1_.paddingLeft = 10;
         _loc1_.paddingRight = 10;
         return _loc1_;
      }
      
      private function _Toast_Array2_c() : Array
      {
         var _loc1_:Array = [this._Toast_Label1_i()];
         return _loc1_;
      }
      
      private function _Toast_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "messageDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.messageDisplay = _loc1_;
         BindingManager.executeBindings(this,"messageDisplay",this.messageDisplay);
         return _loc1_;
      }
      
      private function _Toast_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"messageDisplay.text","message");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get message() : String
      {
         return this._954925063message;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messageDisplay() : Label
      {
         return this._1766135109messageDisplay;
      }
      
      public function set messageDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1766135109messageDisplay;
         if(_loc2_ !== param1)
         {
            this._1766135109messageDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageDisplay",_loc2_,param1));
            }
         }
      }
   }
}
