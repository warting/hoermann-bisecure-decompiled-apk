package refactor.bisecur._1_APP.components.stateImages
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgUnavailable;
   import com.isisic.remote.hoermann.assets.images.devices.light.Fxg_L_StateOff;
   import com.isisic.remote.hoermann.assets.images.devices.light.Fxg_L_StateOn;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import mx.binding.Binding;
   import mx.binding.BindingManager;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import refactor.bisecur._1_APP.skins.stateImage.StateImageSkin;
   import refactor.bisecur._2_SAL.stateHelper.ActorState;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.Group;
   
   use namespace mx_internal;
   
   public class LightStateImage extends StateImageBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _1411499280stateContainer:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _additionalIcon:IVisualElement;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LightStateImage()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._LightStateImage_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_components_stateImages_LightStateImageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return LightStateImage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._LightStateImage_Array1_c);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LightStateImage._watcherSetupUtil = param1;
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
            this.skinClass = StateImageSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function updateState(param1:StateUpdateProperties) : void
      {
         super.updateState(param1);
         if(param1.showState && param1.requestable)
         {
            switch(param1.actorState)
            {
               case ActorState.ON:
                  this.setStateImage(new Fxg_L_StateOn(),param1.additionalIcon);
                  break;
               case ActorState.OFF:
                  this.setStateImage(new Fxg_L_StateOff(),param1.additionalIcon);
                  break;
               default:
                  this.setStateImage(null,new FxgUnavailable());
                  Log.error("[JackStateImage] ActorState \'" + param1.actorState + "\' is not available for JackStateImage!");
            }
         }
         else if(param1.showState && !param1.requestable)
         {
            this.setStateImage(new Fxg_L_StateOn(),param1.additionalIcon);
         }
         else
         {
            this.setStateImage(null,param1.additionalIcon);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Point = null;
         super.updateDisplayList(param1,param2);
         if(this._additionalIcon != null)
         {
            _loc3_ = 60;
            _loc4_ = new Point(this._additionalIcon.width,this._additionalIcon.height);
            this._additionalIcon.height = this.stateContainer.height * (_loc3_ / 100);
            this._additionalIcon.width = this._additionalIcon.height * (_loc4_.x / _loc4_.y);
            this._additionalIcon.x = this.stateContainer.width / 2 - this._additionalIcon.width / 2;
            this._additionalIcon.y = this.stateContainer.height / 2 - this._additionalIcon.height / 2;
         }
      }
      
      private function setStateImage(param1:IVisualElement, param2:IVisualElement) : void
      {
         if(this.stateContainer == null)
         {
            callLater(this.setStateImage,[param1,param2]);
            return;
         }
         this.stateContainer.removeAllElements();
         if(param1 != null)
         {
            param1.percentWidth = 100;
            param1.percentHeight = 100;
            this.stateContainer.addElement(param1);
         }
         this._additionalIcon = null;
         if(param2)
         {
            this._additionalIcon = param2;
            this.stateContainer.addElement(param2);
         }
         invalidateDisplayList();
      }
      
      private function _LightStateImage_Array1_c() : Array
      {
         var _loc1_:Array = [this._LightStateImage_Group1_i()];
         return _loc1_;
      }
      
      private function _LightStateImage_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.id = "stateContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.stateContainer = _loc1_;
         BindingManager.executeBindings(this,"stateContainer",this.stateContainer);
         return _loc1_;
      }
      
      private function _LightStateImage_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"this.imageRect","stateContainer");
         result[1] = new Binding(this,null,null,"stateContainer.height","stateHeight");
         result[2] = new Binding(this,function():Number
         {
            return stateHeight * (109 / 123);
         },null,"stateContainer.width");
         result[3] = new Binding(this,function():Number
         {
            return width - stateContainer.width - 18;
         },null,"stateContainer.x");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get stateContainer() : Group
      {
         return this._1411499280stateContainer;
      }
      
      public function set stateContainer(param1:Group) : void
      {
         var _loc2_:Object = this._1411499280stateContainer;
         if(_loc2_ !== param1)
         {
            this._1411499280stateContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stateContainer",_loc2_,param1));
            }
         }
      }
   }
}
