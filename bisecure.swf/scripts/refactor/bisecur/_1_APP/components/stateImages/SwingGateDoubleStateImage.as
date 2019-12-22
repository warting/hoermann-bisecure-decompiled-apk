package refactor.bisecur._1_APP.components.stateImages
{
   import com.isisic.remote.hoermann.assets.images.devices.general.FxgArrowUp;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateLeft1;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateLeft2;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateLeft3;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateLeftClosed;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateLeftOpened;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateRight1;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateRight2;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateRight3;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateRightClosed;
   import com.isisic.remote.hoermann.assets.images.devices.swingGateDouble.Fxg_SGD_StateRightOpened;
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
   
   public class SwingGateDoubleStateImage extends StateImageBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
       
      
      private var _1411499280stateContainer:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _additionalIcon:IVisualElement;
      
      private var _secondAdditionalIcon:IVisualElement;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SwingGateDoubleStateImage()
      {
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         var bindings:Array = this._SwingGateDoubleStateImage_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_refactor_bisecur__1_APP_components_stateImages_SwingGateDoubleStateImageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SwingGateDoubleStateImage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.stateViews = 2;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SwingGateDoubleStateImage_Array1_c);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SwingGateDoubleStateImage._watcherSetupUtil = param1;
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
      
      private function getRotatableIndicators(param1:Boolean) : Array
      {
         var _loc2_:RotatableBusyIndicator = new RotatableBusyIndicator();
         _loc2_.width = 125;
         _loc2_.height = 125;
         _loc2_.icon = new FxgArrowUp();
         _loc2_.animationDuration = 2000;
         var _loc3_:RotatableBusyIndicator = new RotatableBusyIndicator();
         _loc3_.width = 125;
         _loc3_.height = 125;
         _loc3_.icon = new FxgArrowUp();
         _loc3_.animationDuration = 2000;
         var _loc4_:MoveLeftAnimation = new MoveLeftAnimation();
         _loc4_.paddingLeft = 30;
         _loc4_.paddingRight = 30;
         var _loc5_:MoveRightAnimation = new MoveRightAnimation();
         _loc5_.paddingLeft = 30;
         _loc5_.paddingRight = 30;
         if(param1)
         {
            _loc2_.animation = _loc5_;
            _loc2_.contentRotate = 90;
            _loc3_.animation = _loc4_;
            _loc3_.contentRotate = 270;
         }
         else
         {
            _loc2_.animation = _loc4_;
            _loc2_.contentRotate = 270;
            _loc3_.animation = _loc5_;
            _loc3_.contentRotate = 90;
         }
         _loc2_.startAnimation();
         _loc3_.startAnimation();
         return [_loc2_,_loc3_];
      }
      
      override protected function updateState(param1:StateUpdateProperties) : void
      {
         var _loc3_:Array = null;
         var _loc4_:IVisualElement = null;
         var _loc5_:IVisualElement = null;
         var _loc6_:Array = null;
         super.updateState(param1);
         var _loc2_:IVisualElement = null;
         if(param1.transition != null && param1.additionalIcon is BusyIndicator)
         {
            if(HmTransitionHelper.isDriving(param1.transition))
            {
               _loc3_ = [null,null];
               if(HmTransitionHelper.isDrivingToClose(param1.transition))
               {
                  _loc3_ = this.getRotatableIndicators(true);
               }
               else if(HmTransitionHelper.isDrivingToOpen(param1.transition))
               {
                  _loc3_ = this.getRotatableIndicators(false);
               }
               else
               {
                  _loc3_ = [param1.additionalIcon,null];
               }
               param1.additionalIcon = _loc3_[0];
               _loc2_ = _loc3_[1];
            }
         }
         if(param1.showState && param1.requestable)
         {
            if(param1.actorState.indexOf(":") > -1)
            {
               _loc6_ = param1.actorState.split(":");
               _loc4_ = this.getLeftImageForState(_loc6_[0]);
               _loc5_ = this.getRightImageForState(_loc6_[1]);
            }
            else
            {
               _loc4_ = this.getLeftImageForState(param1.actorState);
               _loc5_ = this.getRightImageForState(param1.actorState);
            }
            this.setStateImage(_loc4_,_loc5_,param1.additionalIcon,_loc2_);
         }
         else if(param1.showState && !param1.requestable)
         {
            this.setStateImage(new Fxg_SGD_StateLeftClosed(),new Fxg_SGD_StateRightClosed(),param1.additionalIcon,_loc2_);
         }
         else
         {
            this.setStateImage(null,null,param1.additionalIcon,_loc2_);
         }
      }
      
      private function getLeftImageForState(param1:String) : IVisualElement
      {
         switch(param1)
         {
            case ActorState.CLOSED:
               return new Fxg_SGD_StateLeftClosed();
            case ActorState.HALF_3:
               return new Fxg_SGD_StateLeft3();
            case ActorState.HALF_2:
               return new Fxg_SGD_StateLeft2();
            case ActorState.HALF_1:
               return new Fxg_SGD_StateLeft1();
            case ActorState.OPEN:
               return new Fxg_SGD_StateLeftOpened();
            default:
               return null;
         }
      }
      
      private function getRightImageForState(param1:String) : IVisualElement
      {
         switch(param1)
         {
            case ActorState.CLOSED:
               return new Fxg_SGD_StateRightClosed();
            case ActorState.HALF_3:
               return new Fxg_SGD_StateRight3();
            case ActorState.HALF_2:
               return new Fxg_SGD_StateRight2();
            case ActorState.HALF_1:
               return new Fxg_SGD_StateRight1();
            case ActorState.OPEN:
               return new Fxg_SGD_StateRightOpened();
            default:
               return null;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this._additionalIcon != null && this._secondAdditionalIcon == null)
         {
            _loc4_ = 60;
            _loc3_ = new Point(this._additionalIcon.width,this._additionalIcon.height);
            this._additionalIcon.height = this.stateContainer.height * (_loc4_ / 100);
            this._additionalIcon.width = this._additionalIcon.height * (_loc3_.x / _loc3_.y);
            Log.debug("[SwingGateDoubleStateImage] stateHeight = " + stateHeight + "\n\t\tstateContainer.height = " + this.stateContainer.height);
            this._additionalIcon.x = this.stateContainer.width / 2 - this._additionalIcon.width / 2;
            this._additionalIcon.y = this.stateContainer.height / 2 - this._additionalIcon.height / 2;
         }
         else if(this._additionalIcon != null && this._secondAdditionalIcon != null)
         {
            _loc3_ = new Point(this._additionalIcon.width,this._additionalIcon.height);
            this._additionalIcon.width = this.stateContainer.width / 2 - 3;
            this._additionalIcon.height = this._additionalIcon.width * (_loc3_.y / _loc3_.x);
            this._additionalIcon.x = 0;
            this._additionalIcon.y = (this.stateContainer.height - this._additionalIcon.height) / 2;
            this._secondAdditionalIcon.width = this._additionalIcon.width;
            this._secondAdditionalIcon.height = this._additionalIcon.height;
            this._secondAdditionalIcon.x = this._additionalIcon.x + this._additionalIcon.width + 6;
            this._secondAdditionalIcon.y = this._additionalIcon.y;
         }
      }
      
      private function setStateImage(param1:IVisualElement, param2:IVisualElement, param3:IVisualElement, param4:IVisualElement = null) : void
      {
         var _loc5_:Point = null;
         if(this.stateContainer == null)
         {
            callLater(this.setStateImage,[param1,param2,param3]);
            return;
         }
         this.stateContainer.removeAllElements();
         if(param1 != null)
         {
            param1.percentWidth = 100;
            param1.percentHeight = 100;
            this.stateContainer.addElement(param1);
         }
         if(param2 != null)
         {
            param2.percentWidth = 100;
            param2.percentHeight = 100;
            this.stateContainer.addElement(param2);
         }
         this._additionalIcon = null;
         this._secondAdditionalIcon = null;
         if(param3 != null && param4 == null)
         {
            this._additionalIcon = param3;
            this.stateContainer.addElement(param3);
         }
         else if(param3 != null && param4 != null)
         {
            this._additionalIcon = param3;
            this._secondAdditionalIcon = param4;
            this.stateContainer.addElement(param3);
            this.stateContainer.addElement(param4);
         }
         invalidateDisplayList();
      }
      
      private function _SwingGateDoubleStateImage_Array1_c() : Array
      {
         var _loc1_:Array = [this._SwingGateDoubleStateImage_Group1_i()];
         return _loc1_;
      }
      
      private function _SwingGateDoubleStateImage_Group1_i() : Group
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
      
      private function _SwingGateDoubleStateImage_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"this.imageRect","stateContainer");
         result[1] = new Binding(this,null,null,"stateContainer.height","stateHeight");
         result[2] = new Binding(this,function():Number
         {
            return stateHeight * (115 / 90);
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
