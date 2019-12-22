package com.isisic.remote.hoermann.views.actors
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit_White;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.components.stateImages.LightStateImage;
   import com.isisic.remote.hoermann.components.stateImages.StateImageBase;
   import com.isisic.remote.hoermann.events.HmGroupEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StateHelper;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.hoermann.net.HmProcessorEvent;
   import com.isisic.remote.hoermann.net.HmTransition;
   import com.isisic.remote.hoermann.skins.stateImageSkins.TransparentStateImageSkin;
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import me.mweber.itemRenderer.RoundetTableItemRenderer;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.utils.ChangeWatcher;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class ActorRenderer extends RoundetTableItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _205771398btnEdit:Button;
      
      private var _3226745icon:SkinnableContainer;
      
      private var _1671708693labelGroup:HGroup;
      
      private var _801844101lblState:Label;
      
      private var _897752650lblStateValue:Label;
      
      private var _25846365lblTime:Label;
      
      private var _801230270lblTitle:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var stateImage:StateImageBase;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ActorRenderer()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ActorRenderer_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_actors_ActorRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ActorRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._ActorRenderer_HGroup1_i(),this._ActorRenderer_Button1_i()];
         this.addEventListener("initialize",this.___ActorRenderer_RoundetTableItemRenderer1_initialize);
         this.addEventListener("creationComplete",this.___ActorRenderer_RoundetTableItemRenderer1_creationComplete);
         this.addEventListener("removed",this.___ActorRenderer_RoundetTableItemRenderer1_removed);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ActorRenderer._watcherSetupUtil = param1;
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
         ChangeWatcher.watch(this.btnEdit,"visible",this.onChange);
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
      
      protected function onComplete() : void
      {
         this.onChange(null);
         HmProcessor.defaultProcessor.addEventListener(HmProcessorEvent.TRANSITION_LOADED,this.onTransitionLoaded);
      }
      
      private function onChange(param1:Event) : void
      {
         if(HoermannRemote.app.editMode)
         {
            marginRight = marginLeft + this.btnEdit.width;
         }
         else
         {
            marginRight = marginLeft;
         }
         this.invalidateDisplayList();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.updateStateImage();
         if(data != null)
         {
            this.lblTime.text = StateHelper.getTransitionTime(this.data.id);
         }
         else
         {
            this.lblTime.text = "";
         }
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
         if(HmProcessor.defaultProcessor)
         {
            HmProcessor.defaultProcessor.addEventListener(HmProcessorEvent.TRANSITION_LOADED,this.onTransitionLoaded);
         }
      }
      
      protected function onTransitionLoaded(param1:HmProcessorEvent) : void
      {
         if(this.data == null)
         {
            Debug.warning("[ActorRenderer] Can not render new State! (data is null)");
            return;
         }
         this.updateStateImage();
         this.data.state = StateHelper.getStateLabel(this.data);
         this.data.stateValue = StateHelper.getStateValue(this.data);
         this.lblTime.text = StateHelper.getTransitionTime(this.data.id);
      }
      
      protected function updateStateImage() : void
      {
         var _loc1_:HmTransition = null;
         if(this.stateImage != null)
         {
            this.icon.removeElement(this.stateImage);
            this.stateImage.dispose();
            this.stateImage = null;
         }
         if(this.data != null)
         {
            this.stateImage = StateHelper.getStateImage(this.data);
            _loc1_ = HmProcessor.defaultProcessor.transitions[data.id];
            this.stateImage.groupId = data.id;
            this.stateImage.percentWidth = 100;
            this.stateImage.stateHeight = this.preferedMinHeight * 0.8 - borderRadius * 2;
            this.stateImage.imageRectPaddingRight = 0;
            this.stateImage.transition = _loc1_;
            if(this.stateImage is LightStateImage)
            {
               this.stateImage.setStyle("skinClass",TransparentStateImageSkin);
            }
            this.icon.addElement(this.stateImage);
         }
      }
      
      private function _ActorRenderer_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._ActorRenderer_VGroup1_c(),this._ActorRenderer_SkinnableContainer1_i()];
         _loc1_.id = "labelGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelGroup = _loc1_;
         BindingManager.executeBindings(this,"labelGroup",this.labelGroup);
         return _loc1_;
      }
      
      private function _ActorRenderer_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ActorRenderer_Label1_i(),this._ActorRenderer_Label2_i(),this._ActorRenderer_Label3_i(),this._ActorRenderer_Label4_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ActorRenderer_Label1_i() : Label
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
      
      private function _ActorRenderer_Label2_i() : Label
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
      
      private function _ActorRenderer_Label3_i() : Label
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
      
      private function _ActorRenderer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
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
      
      private function _ActorRenderer_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentHeight = 100;
         _loc1_.layout = this._ActorRenderer_VerticalLayout1_c();
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
      
      private function _ActorRenderer_VerticalLayout1_c() : VerticalLayout
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
      
      private function _ActorRenderer_Button1_i() : Button
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
      
      public function ___ActorRenderer_RoundetTableItemRenderer1_initialize(param1:FlexEvent) : void
      {
         this.onInit();
      }
      
      public function ___ActorRenderer_RoundetTableItemRenderer1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      public function ___ActorRenderer_RoundetTableItemRenderer1_removed(param1:Event) : void
      {
         this.onRemoved(param1);
      }
      
      private function _ActorRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"labelGroup.y");
         result[1] = new Binding(this,function():Number
         {
            return borderRadius + marginLeft;
         },null,"labelGroup.x");
         result[2] = new Binding(this,function():Number
         {
            return width - marginLeft - marginRight - borderRadius * 2;
         },null,"labelGroup.width");
         result[3] = new Binding(this,function():Number
         {
            return height - marginTop - marginBottom - borderRadius * 2;
         },null,"labelGroup.height");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = data.name;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblTitle.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = data.state;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblState.text");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = data.stateValue;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"lblStateValue.text");
         result[7] = new Binding(this,function():Number
         {
            return icon.height;
         },null,"icon.width");
         result[8] = new Binding(this,function():Object
         {
            return MultiDevice.getFxg(ImgEdit_White);
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[9] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"btnEdit.y");
         result[10] = new Binding(this,function():Boolean
         {
            return HoermannRemote.app.editMode;
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
