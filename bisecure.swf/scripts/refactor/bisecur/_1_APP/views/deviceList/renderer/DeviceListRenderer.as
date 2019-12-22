package refactor.bisecur._1_APP.views.deviceList.renderer
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit_White;
   import com.isisic.remote.hoermann.events.HmGroupEvent;
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
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import refactor.bisecur._1_APP.components.popups.Toast;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class DeviceListRenderer extends RoundetTableItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _205771398btnEdit:Button;
      
      private var _3064427ctrl:DeviceListRendererCtrl;
      
      private var _3226745icon:SkinnableContainer;
      
      private var _1671708693labelGroup:HGroup;
      
      private var _801844101lblState:Label;
      
      private var _897752650lblStateValue:Label;
      
      private var _25846365lblTime:Label;
      
      private var _801230270lblTitle:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DeviceListRenderer()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._DeviceListRenderer_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_deviceList_renderer_DeviceListRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DeviceListRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._DeviceListRenderer_HGroup1_i(),this._DeviceListRenderer_Button1_i()];
         this._DeviceListRenderer_DeviceListRendererCtrl1_i();
         this.addEventListener("initialize",this.___DeviceListRenderer_RoundetTableItemRenderer1_initialize);
         this.addEventListener("creationComplete",this.___DeviceListRenderer_RoundetTableItemRenderer1_creationComplete);
         this.addEventListener("removed",this.___DeviceListRenderer_RoundetTableItemRenderer1_removed);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DeviceListRenderer._watcherSetupUtil = param1;
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
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.ctrl.onData(param1 as DeviceListRendererItem);
      }
      
      protected function onEditClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         dispatchEvent(new HmGroupEvent(HmGroupEvent.EDIT));
      }
      
      protected function onRemoved(param1:Event) : void
      {
      }
      
      private function _DeviceListRenderer_DeviceListRendererCtrl1_i() : DeviceListRendererCtrl
      {
         var _loc1_:DeviceListRendererCtrl = new DeviceListRendererCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._DeviceListRenderer_VGroup1_c(),this._DeviceListRenderer_SkinnableContainer1_i()];
         _loc1_.id = "labelGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelGroup = _loc1_;
         BindingManager.executeBindings(this,"labelGroup",this.labelGroup);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._DeviceListRenderer_Label1_i(),this._DeviceListRenderer_Label2_i(),this._DeviceListRenderer_Label3_i(),this._DeviceListRenderer_Label4_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DeviceListRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "actorTitle";
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblTitle = _loc1_;
         BindingManager.executeBindings(this,"lblTitle",this.lblTitle);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "actorState";
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblState";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblState = _loc1_;
         BindingManager.executeBindings(this,"lblState",this.lblState);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "actorState";
         _loc1_.percentWidth = 100;
         _loc1_.id = "lblStateValue";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblStateValue = _loc1_;
         BindingManager.executeBindings(this,"lblStateValue",this.lblStateValue);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.styleName = "actorTime";
         _loc1_.percentWidth = 85;
         _loc1_.setStyle("textAlign","right");
         _loc1_.id = "lblTime";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lblTime = _loc1_;
         BindingManager.executeBindings(this,"lblTime",this.lblTime);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentHeight = 100;
         _loc1_.layout = this._DeviceListRenderer_VerticalLayout1_c();
         _loc1_.setStyle("backgroundColor",11259375);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "icon";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _DeviceListRenderer_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.paddingTop = 0;
         _loc1_.paddingBottom = 0;
         _loc1_.paddingLeft = 0;
         _loc1_.paddingRight = 0;
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _DeviceListRenderer_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.right = 0;
         _loc1_.addEventListener("click",this.__btnEdit_click);
         _loc1_.id = "btnEdit";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnEdit = _loc1_;
         BindingManager.executeBindings(this,"btnEdit",this.btnEdit);
         return _loc1_;
      }
      
      public function __btnEdit_click(param1:MouseEvent) : void
      {
         this.onEditClick(param1);
      }
      
      public function ___DeviceListRenderer_RoundetTableItemRenderer1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___DeviceListRenderer_RoundetTableItemRenderer1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      public function ___DeviceListRenderer_RoundetTableItemRenderer1_removed(param1:Event) : void
      {
         this.onRemoved(param1);
      }
      
      private function _DeviceListRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():DeviceListRenderer
         {
            return this;
         },null,"ctrl.view");
         result[1] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"labelGroup.y");
         result[2] = new Binding(this,function():Number
         {
            return borderRadius + marginLeft;
         },null,"labelGroup.x");
         result[3] = new Binding(this,function():Number
         {
            return width - marginLeft - marginRight - borderRadius * 2;
         },null,"labelGroup.width");
         result[4] = new Binding(this,function():Number
         {
            return height - marginTop - marginBottom - borderRadius * 2;
         },null,"labelGroup.height");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.Name;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblTitle.text");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.StateLabel;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblState.text");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.StateValue;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblStateValue.text");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = ctrl.StateTime;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblTime.text");
         result[9] = new Binding(this,function():Number
         {
            return icon.height;
         },null,"icon.width");
         result[10] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgEdit_White);
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[11] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"btnEdit.y");
         result[12] = new Binding(this,function():Boolean
         {
            return ctrl.item.rendererState.editMode;
         },null,"btnEdit.visible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnEdit() : Button
      {
         return this._205771398btnEdit;
      }
      
      public function set btnEdit(param1:Button) : void
      {
         var _loc2_:Object = this._205771398btnEdit;
         if(_loc2_ !== param1)
         {
            this._205771398btnEdit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnEdit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ctrl() : DeviceListRendererCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:DeviceListRendererCtrl) : void
      {
         var _loc2_:Object = this._3064427ctrl;
         if(_loc2_ !== param1)
         {
            this._3064427ctrl = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ctrl",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : SkinnableContainer
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:SkinnableContainer) : void
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
      public function get labelGroup() : HGroup
      {
         return this._1671708693labelGroup;
      }
      
      public function set labelGroup(param1:HGroup) : void
      {
         var _loc2_:Object = this._1671708693labelGroup;
         if(_loc2_ !== param1)
         {
            this._1671708693labelGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblState() : Label
      {
         return this._801844101lblState;
      }
      
      public function set lblState(param1:Label) : void
      {
         var _loc2_:Object = this._801844101lblState;
         if(_loc2_ !== param1)
         {
            this._801844101lblState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblStateValue() : Label
      {
         return this._897752650lblStateValue;
      }
      
      public function set lblStateValue(param1:Label) : void
      {
         var _loc2_:Object = this._897752650lblStateValue;
         if(_loc2_ !== param1)
         {
            this._897752650lblStateValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblStateValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lblTime() : Label
      {
         return this._25846365lblTime;
      }
      
      public function set lblTime(param1:Label) : void
      {
         var _loc2_:Object = this._25846365lblTime;
         if(_loc2_ !== param1)
         {
            this._25846365lblTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lblTime",_loc2_,param1));
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
   }
}
