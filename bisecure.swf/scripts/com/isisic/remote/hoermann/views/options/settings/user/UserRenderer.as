package com.isisic.remote.hoermann.views.options.settings.user
{
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.events.HmUserEvent;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.ScreenSizes;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.gwFirmwareFeatures.userEdit.UserEditFeatures;
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
   
   use namespace mx_internal;
   
   public class UserRenderer extends RoundetTableItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _UserRenderer_Label1:Label;
      
      private var _205771398btnEdit:Button;
      
      private var _1671708693labelGroup:HGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function UserRenderer()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._UserRenderer_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_isisic_remote_hoermann_views_options_settings_user_UserRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return UserRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._UserRenderer_HGroup1_i(),this._UserRenderer_Button1_i()];
         this.addEventListener("initialize",this.___UserRenderer_RoundetTableItemRenderer1_initialize);
         this.addEventListener("creationComplete",this.___UserRenderer_RoundetTableItemRenderer1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         UserRenderer._watcherSetupUtil = param1;
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
         ChangeWatcher.watch(this.btnEdit,"visible",this.onChange);
      }
      
      protected function onComplete() : void
      {
         this.onChange(null);
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
      
      override public function get preferedMinHeight() : Number
      {
         switch(MultiDevice.screenSize)
         {
            case ScreenSizes.XXLARGE:
               return 300;
            case ScreenSizes.XLARGE:
               return 198;
            case ScreenSizes.LARGE:
               return 150;
            case ScreenSizes.NORMAL:
               return 150;
            case ScreenSizes.SMALL:
               return 150;
            default:
               return 150;
         }
      }
      
      protected function onEditClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         dispatchEvent(new HmUserEvent(HmUserEvent.DELETE));
      }
      
      private function _UserRenderer_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._UserRenderer_Label1_i()];
         _loc1_.id = "labelGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelGroup = _loc1_;
         BindingManager.executeBindings(this,"labelGroup",this.labelGroup);
         return _loc1_;
      }
      
      private function _UserRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_UserRenderer_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._UserRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_UserRenderer_Label1",this._UserRenderer_Label1);
         return _loc1_;
      }
      
      private function _UserRenderer_Button1_i() : Button
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
      
      public function ___UserRenderer_RoundetTableItemRenderer1_initialize(param1:FlexEvent) : void
      {
         this.initComp();
      }
      
      public function ___UserRenderer_RoundetTableItemRenderer1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _UserRenderer_bindingsSetup() : Array
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
            var _loc1_:* = this.data.name;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_UserRenderer_Label1.text");
         result[5] = new Binding(this,function():Object
         {
            return UserEditFeatures.feature.getIcon();
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[6] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"btnEdit.y");
         result[7] = new Binding(this,function():Boolean
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
   }
}
