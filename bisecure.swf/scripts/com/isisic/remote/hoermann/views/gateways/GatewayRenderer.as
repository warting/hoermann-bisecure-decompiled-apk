package com.isisic.remote.hoermann.views.gateways
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgDelete;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgGlobal;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgLocal;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgOffline;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.events.GatewayEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import me.mweber.itemRenderer.RoundetTableItemRenderer;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.utils.ChangeWatcher;
   import mx.controls.Spacer;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.states.State;
   import spark.components.BusyIndicator;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class GatewayRenderer extends RoundetTableItemRenderer implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _GatewayRenderer_Spacer1:Spacer;
      
      public var _GatewayRenderer_VGroup1:VGroup;
      
      private var _150190887btnDelete:Button;
      
      private var _3226745icon:Group;
      
      private var _26197890lblHost:Label;
      
      private var _1109219399lblMac:Label;
      
      private var _801230270lblTitle:Label;
      
      private var _110371416title:SkinnableContainer;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var deleteChangeWatcher:ChangeWatcher;
      
      private var scanStateChangeWatcher:ChangeWatcher;
      
      private var _scanActive:Boolean = false;
      
      private var _enabled:Boolean;
      
      private var iconDisplay:IVisualElement;
      
      private var iconContainer:IVisualElement;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GatewayRenderer()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._GatewayRenderer_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_gateways_GatewayRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return GatewayRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._GatewayRenderer_SkinnableContainer1_i(),this._GatewayRenderer_Group1_i(),this._GatewayRenderer_Button1_i()];
         this.currentState = "normal";
         this.addEventListener("initialize",this.___GatewayRenderer_RoundetTableItemRenderer1_initialize);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"hovered",
            "overrides":[]
         }),new State({
            "name":"selected",
            "overrides":[]
         })];
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GatewayRenderer._watcherSetupUtil = param1;
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
      
      override public function get preferedMinHeight() : Number
      {
         switch(MultiDevice.screenSize)
         {
            case ScreenSizes.XXLARGE:
               return 500;
            case ScreenSizes.XLARGE:
               return 330;
            case ScreenSizes.LARGE:
               return 250;
            case ScreenSizes.NORMAL:
               return 250;
            case ScreenSizes.SMALL:
               return 250;
            default:
               return 250;
         }
      }
      
      private function init() : void
      {
         if(this.isInitialized)
         {
            return;
         }
         this.deleteChangeWatcher = ChangeWatcher.watch(this.btnDelete,"visible",this.onDeleteChange,false,true);
         this.onDeleteChange(null);
         this._enabled = this.enabled;
         if(HoermannRemote.app.navigator.activeView is GatewayScreen)
         {
            (HoermannRemote.app.navigator.activeView as GatewayScreen).gatewayProvider.addEventListener("scanActiveChanged",this.onScanStateChanged,false,0,true);
            this._scanActive = (HoermannRemote.app.navigator.activeView as GatewayScreen).gatewayProvider.scanActive;
         }
         this.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      private function get isInitialized() : Boolean
      {
         return this.deleteChangeWatcher != null;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         this.invalidateDisplayList();
      }
      
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      private function dispose() : void
      {
         if(this.deleteChangeWatcher != null)
         {
            this.deleteChangeWatcher.unwatch();
            this.deleteChangeWatcher = null;
         }
         if(this.scanStateChangeWatcher != null)
         {
            this.scanStateChangeWatcher.unwatch();
            this.scanStateChangeWatcher = null;
         }
      }
      
      [Bindable(event="dataChange")]
      private function get isDeletable() : Boolean
      {
         if(!this.data.isPortal)
         {
            return true;
         }
         return false;
      }
      
      private function onDeleteChange(param1:Event) : void
      {
         this.invalidateDisplayList();
      }
      
      private function onScanStateChanged(param1:Event) : void
      {
         this._scanActive = param1.target.scanActive;
         if(this.isInitialized && data != null)
         {
            this.setIcon(data,this._scanActive);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(!this.enabled)
         {
            _loc3_ = getStyle("colorDisabled") !== undefined?uint(getStyle("colorDisabled")):uint(10066329);
            this.lblTitle.setStyle("color",_loc3_);
            this.lblHost.setStyle("color",_loc3_);
            this.lblMac.setStyle("color",_loc3_);
         }
         else
         {
            _loc4_ = getStyle("color") !== undefined?uint(getStyle("color")):uint(16777215);
            this.lblTitle.setStyle("color",_loc4_);
            this.lblHost.setStyle("color",14606046);
            this.lblMac.setStyle("color",14606046);
         }
         super.updateDisplayList(param1,param2);
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:Object = param1;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_ == null)
         {
            this.dispose();
            return;
         }
         this.init();
         this.lblTitle.text = _loc2_.name;
         if(_loc2_.isPortal)
         {
            this.lblHost.text = Lang.getString("GENERAL_PORTAL_SERVER");
         }
         else
         {
            this.lblHost.text = _loc2_.host;
         }
         this.lblMac.text = this.formatMac(_loc2_.mac.toUpperCase());
         this.enabled = _loc2_.available;
         this.setIcon(_loc2_,this._scanActive);
         this.dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      private function setIcon(param1:Object, param2:Boolean) : void
      {
         var _loc3_:VGroup = null;
         var _loc4_:BusyIndicator = null;
         this.iconDisplay = null;
         this.iconContainer = null;
         if(param1.available)
         {
            this.iconDisplay = !!param1.isPortal?new ImgGlobal():new ImgLocal();
         }
         else if(param2)
         {
            _loc3_ = new VGroup();
            _loc3_.horizontalAlign = HorizontalAlign.CENTER;
            _loc3_.verticalAlign = VerticalAlign.MIDDLE;
            _loc4_ = new BusyIndicator();
            _loc4_.percentHeight = 60;
            _loc4_.percentWidth = 60;
            _loc4_.styleName = "whiteWheel";
            _loc3_.addElement(_loc4_);
            this.iconDisplay = _loc4_;
            this.iconContainer = _loc3_;
         }
         else
         {
            this.iconDisplay = new ImgOffline();
            this.iconDisplay.alpha = 0;
         }
         this.icon.removeAllElements();
         if(this.iconContainer == null)
         {
            this.iconDisplay.width = this.icon.width;
            this.iconDisplay.height = this.icon.height;
            this.icon.addElement(this.iconDisplay);
         }
         else
         {
            this.iconContainer.width = this.icon.width;
            this.iconContainer.height = this.icon.height;
            this.icon.addElement(this.iconContainer);
         }
      }
      
      override protected function layoutComponents(param1:Number, param2:Number) : void
      {
         super.layoutComponents(param1,param2);
         var _loc3_:Number = 0;
         if(this.iconContainer == null)
         {
            this.iconDisplay.width = this.icon.width - _loc3_;
            this.iconDisplay.height = this.icon.height - _loc3_;
         }
         else
         {
            this.iconContainer.width = this.icon.width - _loc3_;
            this.iconContainer.height = this.icon.height - _loc3_;
         }
      }
      
      protected function onDelete(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         this.dispatchEvent(new GatewayEvent(GatewayEvent.DELETE,true));
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1 - (this.btnDelete.width + this.marginRight) * int(HoermannRemote.app.editMode),param2);
      }
      
      protected function formatMac(param1:String) : String
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1.substr(_loc3_,2));
            _loc3_ = _loc3_ + 2;
         }
         return _loc2_.join(":");
      }
      
      private function _GatewayRenderer_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "title";
         _loc1_.layout = this._GatewayRenderer_VerticalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._GatewayRenderer_Array3_c);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "title";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.title = _loc1_;
         BindingManager.executeBindings(this,"title",this.title);
         return _loc1_;
      }
      
      private function _GatewayRenderer_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.verticalAlign = "middle";
         return _loc1_;
      }
      
      private function _GatewayRenderer_Array3_c() : Array
      {
         var _loc1_:Array = [this._GatewayRenderer_Label1_i(),this._GatewayRenderer_Spacer1_i(),this._GatewayRenderer_VGroup1_i()];
         return _loc1_;
      }
      
      private function _GatewayRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "title";
         _loc1_.maxDisplayedLines = 1;
         _loc1_.id = "lblTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblTitle = _loc1_;
         BindingManager.executeBindings(this,"lblTitle",this.lblTitle);
         return _loc1_;
      }
      
      private function _GatewayRenderer_Spacer1_i() : Spacer
      {
         var _loc1_:Spacer = new Spacer();
         _loc1_.id = "_GatewayRenderer_Spacer1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._GatewayRenderer_Spacer1 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayRenderer_Spacer1",this._GatewayRenderer_Spacer1);
         return _loc1_;
      }
      
      private function _GatewayRenderer_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._GatewayRenderer_Label2_i(),this._GatewayRenderer_Label3_i()];
         _loc1_.id = "_GatewayRenderer_VGroup1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._GatewayRenderer_VGroup1 = _loc1_;
         BindingManager.executeBindings(this,"_GatewayRenderer_VGroup1",this._GatewayRenderer_VGroup1);
         return _loc1_;
      }
      
      private function _GatewayRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "subTitle";
         _loc1_.text = "000000000000";
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblMac";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblMac = _loc1_;
         BindingManager.executeBindings(this,"lblMac",this.lblMac);
         return _loc1_;
      }
      
      private function _GatewayRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "subTitle";
         _loc1_.text = "127.0.0.1";
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblHost";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblHost = _loc1_;
         BindingManager.executeBindings(this,"lblHost",this.lblHost);
         return _loc1_;
      }
      
      private function _GatewayRenderer_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.id = "icon";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _GatewayRenderer_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.right = 0;
         _loc1_.addEventListener("click",this.__btnDelete_click);
         _loc1_.id = "btnDelete";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnDelete = _loc1_;
         BindingManager.executeBindings(this,"btnDelete",this.btnDelete);
         return _loc1_;
      }
      
      public function __btnDelete_click(param1:MouseEvent) : void
      {
         this.onDelete(param1);
      }
      
      public function ___GatewayRenderer_RoundetTableItemRenderer1_initialize(param1:FlexEvent) : void
      {
         this.init();
      }
      
      private function _GatewayRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return marginTop + borderRadius;
         },null,"title.top");
         result[1] = new Binding(this,function():Object
         {
            return borderRadius + marginLeft;
         },null,"title.left");
         result[2] = new Binding(this,function():Object
         {
            return borderRadius + marginBottom;
         },null,"title.bottom");
         result[3] = new Binding(this,function():Number
         {
            return width - marginLeft - marginRight - borderRadius * 2 - icon.width;
         },null,"title.width");
         result[4] = new Binding(this,function():Number
         {
            return borderRadius / 2;
         },null,"_GatewayRenderer_Spacer1.height");
         result[5] = new Binding(this,function():Number
         {
            return borderRadius / 2;
         },null,"_GatewayRenderer_VGroup1.paddingLeft");
         result[6] = new Binding(this,function():int
         {
            return borderRadius / 4;
         },null,"_GatewayRenderer_VGroup1.gap");
         result[7] = new Binding(this,function():Object
         {
            return marginTop + borderRadius;
         },null,"icon.top");
         result[8] = new Binding(this,function():Object
         {
            return marginBottom + borderRadius;
         },null,"icon.bottom");
         result[9] = new Binding(this,function():Object
         {
            return marginRight + borderRadius;
         },null,"icon.right");
         result[10] = new Binding(this,function():Number
         {
            return icon.height;
         },null,"icon.width");
         result[11] = new Binding(this,function():Boolean
         {
            return !btnDelete.visible;
         },null,"icon.visible");
         result[12] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgDelete);
         },function(param1:Object):void
         {
            btnDelete.setStyle("icon",param1);
         },"btnDelete.icon");
         result[13] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"btnDelete.y");
         result[14] = new Binding(this,function():Boolean
         {
            return HoermannRemote.app.editMode;
         },null,"btnDelete.visible");
         result[15] = new Binding(this,function():Boolean
         {
            return this.isDeletable;
         },null,"btnDelete.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnDelete() : Button
      {
         return this._150190887btnDelete;
      }
      
      public function set btnDelete(param1:Button) : void
      {
         var _loc2_:Object = this._150190887btnDelete;
         if(_loc2_ !== param1)
         {
            this._150190887btnDelete = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnDelete",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : Group
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:Group) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblHost() : Label
      {
         return this._26197890lblHost;
      }
      
      public function set lblHost(param1:Label) : void
      {
         var _loc2_:Object = this._26197890lblHost;
         if(_loc2_ !== param1)
         {
            this._26197890lblHost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblHost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblMac() : Label
      {
         return this._1109219399lblMac;
      }
      
      public function set lblMac(param1:Label) : void
      {
         var _loc2_:Object = this._1109219399lblMac;
         if(_loc2_ !== param1)
         {
            this._1109219399lblMac = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblMac",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblTitle() : Label
      {
         return this._801230270lblTitle;
      }
      
      public function set lblTitle(param1:Label) : void
      {
         var _loc2_:Object = this._801230270lblTitle;
         if(_loc2_ !== param1)
         {
            this._801230270lblTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : SkinnableContainer
      {
         return this._110371416title;
      }
      
      public function set title(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}
