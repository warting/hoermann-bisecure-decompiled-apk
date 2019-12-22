package refactor.bisecur._1_APP.views.scenarios.renderer
{
   import com.isisic.remote.hoermann.assets.images.buttons.ImgEdit_White;
   import com.isisic.remote.hoermann.global.ScreenSizes;
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
   import refactor.logicware._5_UTIL.Log;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   
   use namespace mx_internal;
   
   public class ScenarioRenderer extends RoundetTableItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      public var _ScenarioRenderer_Label1:Label;
      
      private var _205771398btnEdit:Button;
      
      private var _3064427ctrl:ScenarioRendererCtrl;
      
      private var _1671708693labelGroup:HGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ScenarioRenderer()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._ScenarioRenderer_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_views_scenarios_renderer_ScenarioRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ScenarioRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._ScenarioRenderer_HGroup1_i(),this._ScenarioRenderer_Button1_i()];
         this._ScenarioRenderer_ScenarioRendererCtrl1_i();
         this.addEventListener("initialize",this.___ScenarioRenderer_RoundetTableItemRenderer1_initialize);
         this.addEventListener("creationComplete",this.___ScenarioRenderer_RoundetTableItemRenderer1_creationComplete);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ScenarioRenderer._watcherSetupUtil = param1;
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
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 != null && !(param1 is ScenarioRendererItem))
         {
            Log.error("[ScenarioRenderer] received invalid Data! (data is not an instance of ScenarioRendererItem)");
            throw new Error("data is not an instance of ScenarioRendererItem");
         }
         this.ctrl.onData(param1 as ScenarioRendererItem);
      }
      
      private function _ScenarioRenderer_ScenarioRendererCtrl1_i() : ScenarioRendererCtrl
      {
         var _loc1_:ScenarioRendererCtrl = new ScenarioRendererCtrl();
         this.ctrl = _loc1_;
         BindingManager.executeBindings(this,"ctrl",this.ctrl);
         return _loc1_;
      }
      
      private function _ScenarioRenderer_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._ScenarioRenderer_Label1_i()];
         _loc1_.id = "labelGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelGroup = _loc1_;
         BindingManager.executeBindings(this,"labelGroup",this.labelGroup);
         return _loc1_;
      }
      
      private function _ScenarioRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.id = "_ScenarioRenderer_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ScenarioRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ScenarioRenderer_Label1",this._ScenarioRenderer_Label1);
         return _loc1_;
      }
      
      private function _ScenarioRenderer_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.right = 0;
         _loc1_.id = "btnEdit";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.btnEdit = _loc1_;
         BindingManager.executeBindings(this,"btnEdit",this.btnEdit);
         return _loc1_;
      }
      
      public function ___ScenarioRenderer_RoundetTableItemRenderer1_initialize(param1:FlexEvent) : void
      {
         this.ctrl.onInit();
      }
      
      public function ___ScenarioRenderer_RoundetTableItemRenderer1_creationComplete(param1:FlexEvent) : void
      {
         this.ctrl.onCreationComplete();
      }
      
      private function _ScenarioRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():ScenarioRenderer
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
            var _loc1_:* = ctrl.Title;
            return _loc1_ == undefined?null:String(_loc1_);
         },null,"_ScenarioRenderer_Label1.text");
         result[6] = new Binding(this,function():Object
         {
            return new ImgEdit_White();
         },function(param1:Object):void
         {
            btnEdit.setStyle("icon",param1);
         },"btnEdit.icon");
         result[7] = new Binding(this,function():Number
         {
            return marginTop + borderRadius;
         },null,"btnEdit.y");
         result[8] = new Binding(this,function():Boolean
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
      public function get ctrl() : ScenarioRendererCtrl
      {
         return this._3064427ctrl;
      }
      
      public function set ctrl(param1:ScenarioRendererCtrl) : void
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
