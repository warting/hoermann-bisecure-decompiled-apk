package refactor.bisecur._1_APP.components.stateImages
{
   import com.isisic.remote.hoermann.assets.images.devices.SlidingGate.Fxg_SG_StateClosed;
   import com.isisic.remote.hoermann.assets.images.devices.SlidingGate.Fxg_SG_StateHalf1;
   import com.isisic.remote.hoermann.assets.images.devices.SlidingGate.Fxg_SG_StateHalf2;
   import com.isisic.remote.hoermann.assets.images.devices.SlidingGate.Fxg_SG_StateHalf3;
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgArrowUp;
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgUnavailable;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateSingle.Fxg_SGS_StateOpened;
   import com.isisic.remote.hoermann.components.busyIndicator.CustomBusyIndicator;
   import com.isisic.remote.hoermann.components.busyIndicator.RotatableBusyIndicator;
   import com.isisic.remote.hoermann.components.busyIndicator.animations.MoveLeftAnimation;
   import com.isisic.remote.hoermann.components.busyIndicator.animations.MoveRightAnimation;
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
   import refactor.bisecur._1_APP.skins.stateImage.GateStateImageSkin;
   import refactor.bisecur._2_SAL.stateHelper.ActorState;
   import refactor.bisecur._5_UTIL.HmTransitionHelper;
   import refactor.logicware._5_UTIL.Log;
   import spark.components.BusyIndicator;
   import spark.components.Group;
   
   use namespace mx_internal;
   
   public class SlidingGateStateImage extends StateImageBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _1411499280stateContainer:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _additionalIcon:IVisualElement;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SlidingGateStateImage()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._SlidingGateStateImage_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_components_stateImages_SlidingGateStateImageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SlidingGateStateImage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SlidingGateStateImage_Array1_c);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SlidingGateStateImage._watcherSetupUtil = param1;
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
            this.skinClass = GateStateImageSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function updateState(param1:StateUpdateProperties) : void
      {
         var _loc2_:RotatableBusyIndicator = null;
         super.updateState(param1);
         if(param1.transition != null && param1.additionalIcon is BusyIndicator && param1.showDrivingDirection)
         {
            if(HmTransitionHelper.isDriving(param1.transition))
            {
               _loc2_ = new RotatableBusyIndicator();
               _loc2_.width = 125;
               _loc2_.height = 125;
               _loc2_.icon = new FxgArrowUp();
               _loc2_.animationDuration = 2000;
               if(HmTransitionHelper.isDrivingToClose(param1.transition))
               {
                  _loc2_.animation = new MoveRightAnimation();
                  _loc2_.contentRotate = 90;
                  param1.additionalIcon = _loc2_;
                  _loc2_.startAnimation();
               }
               else if(HmTransitionHelper.isDrivingToOpen(param1.transition))
               {
                  _loc2_.animation = new MoveLeftAnimation();
                  _loc2_.contentRotate = 270;
                  param1.additionalIcon = _loc2_;
                  _loc2_.startAnimation();
               }
            }
         }
         if(param1.showState && param1.requestable)
         {
            switch(param1.actorState)
            {
               case ActorState.CLOSED:
                  this.setStateImage(new Fxg_SG_StateClosed(),param1.additionalIcon);
                  break;
               case ActorState.HALF_3:
                  this.setStateImage(new Fxg_SG_StateHalf3(),param1.additionalIcon);
                  break;
               case ActorState.HALF_2:
                  this.setStateImage(new Fxg_SG_StateHalf2(),param1.additionalIcon);
                  break;
               case ActorState.HALF_1:
                  this.setStateImage(new Fxg_SG_StateHalf1(),param1.additionalIcon);
                  break;
               case ActorState.OPEN:
                  this.setStateImage(new Fxg_SGS_StateOpened(),param1.additionalIcon);
                  break;
               default:
                  this.setStateImage(null,new FxgUnavailable());
                  Log.error("[SlidingGateStateImage] ActorState \'" + param1.actorState + "\' is not available for SlidingGateStateImage!");
            }
         }
         else if(param1.showState && !param1.requestable)
         {
            this.setStateImage(new Fxg_SG_StateClosed(),param1.additionalIcon);
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
            if(this._additionalIcon is CustomBusyIndicator)
            {
               _loc3_ = 100;
            }
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
      
      private function _SlidingGateStateImage_Array1_c() : Array
      {
         var _loc1_:Array = [this._SlidingGateStateImage_Group1_i()];
         return _loc1_;
      }
      
      private function _SlidingGateStateImage_Group1_i() : Group
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
      
      private function _SlidingGateStateImage_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"this.imageRect","stateContainer");
         result[1] = new Binding(this,function():Number
         {
            return stateHeight - outlineThickness;
         },null,"stateContainer.height");
         result[2] = new Binding(this,function():Number
         {
            return stateHeight * (115 / 95);
         },null,"stateContainer.width");
         result[3] = new Binding(this,function():Number
         {
            return width - stateContainer.width - (imageRectPaddingRight + outlineThickness * 4.5);
         },null,"stateContainer.x");
         result[4] = new Binding(this,null,null,"stateContainer.y","outlineThickness");
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
