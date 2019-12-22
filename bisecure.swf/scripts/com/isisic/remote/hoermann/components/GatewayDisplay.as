package com.isisic.remote.hoermann.components
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.DPIClassification;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.FlexGlobals;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.BusyIndicator;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.layouts.HorizontalLayout;
   
   use namespace mx_internal;
   
   public class GatewayDisplay extends SkinnableContainer implements IBindingClient
   {
      
      private static var _1724546052description:String = "";
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
       
      
      public var _GatewayDisplay_BusyIndicator1:BusyIndicator;
      
      public var _GatewayDisplay_HorizontalLayout1:HorizontalLayout;
      
      private var _3079825desc:Label;
      
      private var _1233845349gwName:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _453515085horizontalPadding:Number;
      
      private var _121291845verticalPadding:Number = 10;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GatewayDisplay()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._GatewayDisplay_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_components_GatewayDisplayWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return GatewayDisplay[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.layout = this._GatewayDisplay_HorizontalLayout1_i();
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._GatewayDisplay_Array1_c);
         this.addEventListener("initialize",this.___GatewayDisplay_SkinnableContainer1_initialize);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GatewayDisplay._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public static function get description() : String
      {
         return GatewayDisplay._1724546052description;
      }
      
      public static function set description(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = GatewayDisplay._1724546052description;
         if(_loc2_ !== param1)
         {
            GatewayDisplay._1724546052description = param1;
            _loc3_ = GatewayDisplay.staticEventDispatcher;
            if(_loc3_ != null && _loc3_.hasEventListener("propertyChange"))
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(GatewayDisplay,"description",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
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
      
      private function onInit() : void
      {
         switch(FlexGlobals.topLevelApplication.applicationDPI)
         {
            case DPIClassification.DPI_320:
               this.horizontalPadding = 26;
               break;
            case DPIClassification.DPI_240:
               this.horizontalPadding = 20;
               break;
            default:
               this.horizontalPadding = 13;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.gwName.text = HoermannRemote.appData.activeGateway.name;
      }
      
      private function _GatewayDisplay_HorizontalLayout1_i() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         _loc1_.horizontalAlign = "left";
         this._GatewayDisplay_HorizontalLayout1 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayDisplay_HorizontalLayout1",this._GatewayDisplay_HorizontalLayout1);
         return _loc1_;
      }
      
      private function _GatewayDisplay_Array1_c() : Array
      {
         var _loc1_:Array = [this._GatewayDisplay_Group1_c()];
         return _loc1_;
      }
      
      private function _GatewayDisplay_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.mxmlContent = [this._GatewayDisplay_HGroup1_c(),this._GatewayDisplay_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _GatewayDisplay_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.left = 0;
         _loc1_.mxmlContent = [this._GatewayDisplay_Label1_i(),this._GatewayDisplay_BusyIndicator1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _GatewayDisplay_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontWeight","bold");
         _loc1_.id = "gwName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gwName = _loc1_;
         BindingManager.executeBindings(this,"gwName",this.gwName);
         return _loc1_;
      }
      
      private function _GatewayDisplay_BusyIndicator1_i() : BusyIndicator
      {
         var _loc1_:BusyIndicator = new BusyIndicator();
         _loc1_.styleName = "whiteWheel";
         _loc1_.id = "_GatewayDisplay_BusyIndicator1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._GatewayDisplay_BusyIndicator1 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayDisplay_BusyIndicator1",this._GatewayDisplay_BusyIndicator1);
         return _loc1_;
      }
      
      private function _GatewayDisplay_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.right = 0;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontWeight","bold");
         _loc1_.id = "desc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.desc = _loc1_;
         BindingManager.executeBindings(this,"desc",this.desc);
         return _loc1_;
      }
      
      public function ___GatewayDisplay_SkinnableContainer1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      private function _GatewayDisplay_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return verticalPadding;
         },null,"_GatewayDisplay_HorizontalLayout1.paddingTop");
         result[1] = new Binding(this,function():Number
         {
            return verticalPadding;
         },null,"_GatewayDisplay_HorizontalLayout1.paddingBottom");
         result[2] = new Binding(this,function():Number
         {
            return horizontalPadding;
         },null,"_GatewayDisplay_HorizontalLayout1.paddingLeft");
         result[3] = new Binding(this,function():Number
         {
            return horizontalPadding;
         },null,"_GatewayDisplay_HorizontalLayout1.paddingRight");
         result[4] = new Binding(this,function():Number
         {
            return gwName.height;
         },null,"_GatewayDisplay_BusyIndicator1.height");
         result[5] = new Binding(this,function():Boolean
         {
            return HoermannRemote.appData.activeConnection.processor.processing;
         },null,"_GatewayDisplay_BusyIndicator1.visible");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = GatewayDisplay.description;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"desc.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get desc() : Label
      {
         return this._3079825desc;
      }
      
      public function set desc(param1:Label) : void
      {
         var _loc2_:Object = this._3079825desc;
         if(_loc2_ !== param1)
         {
            this._3079825desc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"desc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gwName() : Label
      {
         return this._1233845349gwName;
      }
      
      public function set gwName(param1:Label) : void
      {
         var _loc2_:Object = this._1233845349gwName;
         if(_loc2_ !== param1)
         {
            this._1233845349gwName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gwName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get horizontalPadding() : Number
      {
         return this._453515085horizontalPadding;
      }
      
      private function set horizontalPadding(param1:Number) : void
      {
         var _loc2_:Object = this._453515085horizontalPadding;
         if(_loc2_ !== param1)
         {
            this._453515085horizontalPadding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalPadding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get verticalPadding() : Number
      {
         return this._121291845verticalPadding;
      }
      
      private function set verticalPadding(param1:Number) : void
      {
         var _loc2_:Object = this._121291845verticalPadding;
         if(_loc2_ !== param1)
         {
            this._121291845verticalPadding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalPadding",_loc2_,param1));
            }
         }
      }
   }
}
