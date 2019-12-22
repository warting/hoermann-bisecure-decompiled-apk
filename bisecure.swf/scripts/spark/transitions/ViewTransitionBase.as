package spark.transitions
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   import mx.effects.Parallel;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.geom.TransformOffsets;
   import spark.components.ActionBar;
   import spark.components.Group;
   import spark.components.TabbedViewNavigator;
   import spark.components.View;
   import spark.components.ViewNavigator;
   import spark.components.supportClasses.ButtonBarBase;
   import spark.components.supportClasses.ViewNavigatorBase;
   import spark.effects.Animate;
   import spark.effects.Fade;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.effects.easing.IEaser;
   import spark.effects.easing.Sine;
   import spark.primitives.BitmapImage;
   import spark.utils.BitmapUtil;
   
   use namespace mx_internal;
   
   public class ViewTransitionBase extends EventDispatcher
   {
      
      mx_internal static const ACTION_BAR_MODE_FADE:String = "fade";
      
      mx_internal static const ACTION_BAR_MODE_FADE_AND_SLIDE:String = "fadeAndSlide";
      
      mx_internal static const ACTION_BAR_MODE_NONE:String = "none";
      
      private static var renderLastFrame:Boolean = true;
      
      private static var activeTransitions:Vector.<ViewTransitionBase> = new Vector.<ViewTransitionBase>();
       
      
      protected var consolidatedTransition:Boolean = false;
      
      private var cachedActionBarHeight:Number;
      
      private var cachedActionBarWidth:Number;
      
      private var transitionGroup:Group;
      
      private var verticalTransition:Boolean;
      
      private var _duration:Number = 250;
      
      private var _easer:IEaser;
      
      private var _effect:IEffect;
      
      private var _endView:View;
      
      private var _navigator:ViewNavigator;
      
      private var _startView:View;
      
      private var _suspendBackgroundProcessing:Boolean = true;
      
      private var _transitionControlsWithContent:Boolean;
      
      mx_internal var actionBarTransitionMode:String = "fadeAndSlide";
      
      mx_internal var actionBarTransitionDirection:String = "left";
      
      mx_internal var cachedNavigator:BitmapImage;
      
      mx_internal var cachedNavigatorGlobalPosition:Point;
      
      mx_internal var cachedActionGroup:BitmapImage;
      
      mx_internal var cachedActionGroupGlobalPosition:Point;
      
      mx_internal var cachedTitleGroup:BitmapImage;
      
      mx_internal var cachedTitleGroupGlobalPosition:Point;
      
      mx_internal var cachedNavigationGroup:BitmapImage;
      
      mx_internal var cachedNavigationGroupGlobalPosition:Point;
      
      protected var targetNavigator:ViewNavigatorBase;
      
      protected var parentNavigator:ViewNavigatorBase;
      
      protected var actionBar:ActionBar;
      
      protected var tabBar:ButtonBarBase;
      
      public function ViewTransitionBase()
      {
         this._easer = new Sine(0.5);
         this.cachedNavigatorGlobalPosition = new Point();
         this.cachedActionGroupGlobalPosition = new Point();
         this.cachedTitleGroupGlobalPosition = new Point();
         this.cachedNavigationGroupGlobalPosition = new Point();
         super();
      }
      
      mx_internal static function endTransitions() : void
      {
         renderLastFrame = false;
         var _loc1_:int = 0;
         while(_loc1_ < activeTransitions.length)
         {
            activeTransitions[_loc1_].effect.end();
            _loc1_++;
         }
         renderLastFrame = true;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function set duration(param1:Number) : void
      {
         this._duration = param1;
      }
      
      public function get easer() : IEaser
      {
         return this._easer;
      }
      
      public function set easer(param1:IEaser) : void
      {
         this._easer = param1;
      }
      
      mx_internal function get effect() : IEffect
      {
         return this._effect;
      }
      
      mx_internal function set effect(param1:IEffect) : void
      {
         this._effect = param1;
      }
      
      public function get endView() : View
      {
         return this._endView;
      }
      
      public function set endView(param1:View) : void
      {
         this._endView = param1;
      }
      
      public function get navigator() : ViewNavigator
      {
         return this._navigator;
      }
      
      public function set navigator(param1:ViewNavigator) : void
      {
         this._navigator = param1;
      }
      
      public function get startView() : View
      {
         return this._startView;
      }
      
      public function set startView(param1:View) : void
      {
         this._startView = param1;
      }
      
      public function get suspendBackgroundProcessing() : Boolean
      {
         return this._suspendBackgroundProcessing;
      }
      
      public function set suspendBackgroundProcessing(param1:Boolean) : void
      {
         this._suspendBackgroundProcessing = param1;
      }
      
      public function get transitionControlsWithContent() : Boolean
      {
         return this._transitionControlsWithContent;
      }
      
      public function set transitionControlsWithContent(param1:Boolean) : void
      {
         this._transitionControlsWithContent = param1;
      }
      
      mx_internal function preInit() : void
      {
      }
      
      public function captureStartValues() : void
      {
         this.parentNavigator = this.navigator.parentNavigator;
         if(this.parentNavigator is TabbedViewNavigator)
         {
            this.targetNavigator = this.parentNavigator;
            this.tabBar = TabbedViewNavigator(this.parentNavigator).tabBar;
         }
         else
         {
            this.targetNavigator = this.navigator;
         }
         if(this.navigator)
         {
            this.actionBar = this.navigator.actionBar;
         }
         if(!this.consolidatedTransition)
         {
            this.consolidatedTransition = !this.canTransitionControlBarContent();
         }
         if(!this.consolidatedTransition)
         {
            if(this.componentIsVisible(this.actionBar))
            {
               this.cachedActionBarWidth = this.actionBar.width;
               this.cachedActionBarHeight = this.actionBar.height;
               if(this.actionBar.titleGroup && this.actionBar.titleGroup.visible)
               {
                  this.cachedTitleGroup = this.getSnapshot(this.actionBar.titleGroup,4,this.cachedTitleGroupGlobalPosition);
               }
               else if(this.actionBar.titleDisplay && this.actionBar.titleDisplay is UIComponent && UIComponent(this.actionBar.titleDisplay).visible)
               {
                  this.cachedTitleGroup = this.getSnapshot(UIComponent(this.actionBar.titleDisplay),4,this.cachedTitleGroupGlobalPosition);
               }
               if(this.startView.actionContent != this.endView.actionContent)
               {
                  this.cachedActionGroup = this.getSnapshot(this.actionBar.actionGroup,4,this.cachedActionGroupGlobalPosition);
               }
               if(this.startView.navigationContent != this.endView.navigationContent)
               {
                  this.cachedNavigationGroup = this.getSnapshot(this.actionBar.navigationGroup,4,this.cachedNavigationGroupGlobalPosition);
               }
            }
         }
      }
      
      public function captureEndValues() : void
      {
         if(!this.consolidatedTransition && this.actionBar)
         {
            this.consolidatedTransition = this.actionBar.height != this.cachedActionBarHeight || this.actionBar.width != this.cachedActionBarWidth;
         }
      }
      
      public function play() : void
      {
         if(this.effect)
         {
            activeTransitions.push(this);
            this.effect.addEventListener(EffectEvent.EFFECT_END,this.effectComplete);
            if(hasEventListener(FlexEvent.TRANSITION_START))
            {
               dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_START));
            }
            if(this.navigator && this.navigator.stage && this.navigator.stage.hasEventListener(FlexEvent.TRANSITION_START))
            {
               this.navigator.stage.dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_START));
            }
            this.effect.play();
         }
         else
         {
            this.transitionComplete();
         }
      }
      
      public function prepareForPlay() : void
      {
         var _loc1_:IEffect = null;
         var _loc2_:IEffect = null;
         var _loc3_:IEffect = null;
         if(!this.consolidatedTransition)
         {
            this.effect = new Parallel();
            if(this.actionBar)
            {
               _loc2_ = this.createActionBarEffect();
               if(_loc2_)
               {
                  Parallel(this.effect).addChild(_loc2_);
               }
            }
            if(this.targetNavigator is TabbedViewNavigator)
            {
               if(TabbedViewNavigator(this.targetNavigator).tabBar)
               {
                  _loc3_ = this.createTabBarEffect();
                  if(_loc3_)
                  {
                     Parallel(this.effect).addChild(_loc3_);
                  }
               }
            }
            _loc1_ = this.createViewEffect();
            if(_loc1_)
            {
               Parallel(this.effect).addChild(_loc1_);
            }
         }
         else
         {
            this.effect = this.createConsolidatedEffect();
         }
         if(this.suspendBackgroundProcessing)
         {
            UIComponent.suspendBackgroundProcessing();
         }
      }
      
      protected function createActionBarEffect() : IEffect
      {
         var _loc1_:TransformOffsets = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc11_:UIComponent = null;
         var _loc12_:Fade = null;
         var _loc13_:Fade = null;
         var _loc4_:UIComponent = this.actionBar.skin;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         if(!this.actionBar || this.actionBarTransitionMode == ACTION_BAR_MODE_NONE || !this.actionBarTransitionMode)
         {
            return null;
         }
         this.transitionGroup = new Group();
         this.transitionGroup.autoLayout = false;
         this.transitionGroup.includeInLayout = false;
         this.transitionGroup.width = this.actionBar.width;
         this.transitionGroup.height = this.actionBar.height;
         this.addComponentToContainer(this.transitionGroup,_loc4_);
         var _loc8_:Parallel = new Parallel();
         switch(this.actionBarTransitionDirection)
         {
            case ViewTransitionDirection.RIGHT:
               _loc3_ = "x";
               _loc2_ = -this.actionBar.width / 2.5;
               break;
            case ViewTransitionDirection.DOWN:
               _loc3_ = "y";
               _loc2_ = -this.actionBar.height / 2.5;
               this.verticalTransition = true;
               break;
            case ViewTransitionDirection.UP:
               _loc3_ = "y";
               _loc2_ = this.actionBar.height / 2.5;
               this.verticalTransition = true;
               break;
            case ViewTransitionDirection.LEFT:
            default:
               _loc3_ = "x";
               _loc2_ = this.actionBar.width / 2.5;
         }
         this.transitionGroup.clipAndEnableScrolling = true;
         if(this.actionBarTransitionMode == ACTION_BAR_MODE_FADE)
         {
            _loc2_ = 0;
         }
         if(this.actionBar.titleGroup || this.actionBar.titleDisplay)
         {
            _loc11_ = this.actionBar.titleGroup;
            if(!_loc11_ || !_loc11_.visible)
            {
               _loc11_ = this.actionBar.titleDisplay as UIComponent;
            }
            if(_loc11_)
            {
               _loc1_ = new TransformOffsets();
               _loc1_[_loc3_] = _loc2_;
               _loc5_.push(_loc1_);
               _loc11_.cacheAsBitmap = true;
               _loc11_.alpha = 0;
               _loc11_.postLayoutTransformOffsets = _loc1_;
               _loc7_.push(_loc11_);
               if(this.verticalTransition)
               {
                  this.transitionGroup.addElementAt(_loc11_,0);
               }
            }
            if(this.cachedTitleGroup)
            {
               this.addCachedElementToGroup(this.transitionGroup,this.cachedTitleGroup,this.cachedTitleGroupGlobalPosition);
            }
         }
         if(this.cachedNavigationGroup)
         {
            this.addCachedElementToGroup(this.transitionGroup,this.cachedNavigationGroup,this.cachedNavigationGroupGlobalPosition);
         }
         if(this.cachedActionGroup)
         {
            this.addCachedElementToGroup(this.transitionGroup,this.cachedActionGroup,this.cachedActionGroupGlobalPosition);
         }
         if(this.endView)
         {
            if(this.endView.navigationContent)
            {
               _loc1_ = new TransformOffsets();
               _loc1_[_loc3_] = _loc2_;
               _loc5_.push(_loc1_);
               this.actionBar.navigationGroup.postLayoutTransformOffsets = _loc1_;
               this.actionBar.navigationGroup.cacheAsBitmap = true;
               this.actionBar.navigationGroup.alpha = 0;
               _loc7_.push(this.actionBar.navigationGroup);
               if(this.verticalTransition)
               {
                  this.transitionGroup.addElementAt(this.actionBar.navigationGroup,0);
               }
            }
            if(this.endView.actionContent)
            {
               _loc1_ = new TransformOffsets();
               _loc1_[_loc3_] = _loc2_;
               _loc5_.push(_loc1_);
               this.actionBar.actionGroup.postLayoutTransformOffsets = _loc1_;
               this.actionBar.actionGroup.cacheAsBitmap = true;
               this.actionBar.actionGroup.alpha = 0;
               _loc7_.push(this.actionBar.actionGroup);
               if(this.verticalTransition)
               {
                  this.transitionGroup.addElementAt(this.actionBar.actionGroup,0);
               }
            }
         }
         this.transitionGroup.validateNow();
         if(this.cachedTitleGroup)
         {
            _loc1_ = new TransformOffsets();
            _loc5_.push(_loc1_);
            this.cachedTitleGroup.postLayoutTransformOffsets = _loc1_;
            _loc6_.push(this.cachedTitleGroup.displayObject);
         }
         if(this.cachedNavigationGroup)
         {
            _loc1_ = new TransformOffsets();
            _loc5_.push(_loc1_);
            this.cachedNavigationGroup.postLayoutTransformOffsets = _loc1_;
            _loc6_.push(this.cachedNavigationGroup.displayObject);
         }
         if(this.cachedActionGroup)
         {
            _loc1_ = new TransformOffsets();
            _loc5_.push(_loc1_);
            this.cachedActionGroup.postLayoutTransformOffsets = _loc1_;
            _loc6_.push(this.cachedActionGroup.displayObject);
         }
         if(_loc7_.length == 0 && _loc6_.length == 0)
         {
            return null;
         }
         if(_loc7_.length > 0)
         {
            _loc12_ = new Fade();
            _loc12_.targets = _loc7_;
            _loc12_.duration = this.duration;
            _loc12_.alphaFrom = 0;
            _loc12_.alphaTo = 1;
            _loc8_.addChild(_loc12_);
         }
         if(_loc6_.length > 0)
         {
            _loc13_ = new Fade();
            _loc13_.targets = _loc6_;
            _loc13_.duration = this.duration;
            _loc13_.alphaFrom = 1;
            _loc13_.alphaTo = 0;
            _loc8_.addChild(_loc13_);
         }
         var _loc9_:Vector.<MotionPath> = new Vector.<MotionPath>();
         _loc9_.push(new SimpleMotionPath(_loc3_,null,null,-_loc2_));
         var _loc10_:Animate = new Animate();
         _loc10_.targets = _loc5_;
         _loc10_.motionPaths = _loc9_;
         _loc10_.easer = new Sine(0.7);
         _loc10_.duration = this.duration;
         _loc10_.addEventListener(EffectEvent.EFFECT_UPDATE,this.actionBarMoveEffect_effectUpdateHandler);
         _loc10_.addEventListener(EffectEvent.EFFECT_END,this.actionBarMoveEffect_effectEndedHandler);
         _loc8_.addChild(_loc10_);
         return _loc8_;
      }
      
      protected function createTabBarEffect() : IEffect
      {
         return null;
      }
      
      protected function createViewEffect() : IEffect
      {
         return null;
      }
      
      protected function createConsolidatedEffect() : IEffect
      {
         return null;
      }
      
      protected function transitionComplete() : void
      {
         var _loc1_:Stage = null;
         if(this.navigator)
         {
            _loc1_ = this.navigator.stage;
         }
         this.cleanUp();
         activeTransitions.splice(activeTransitions.indexOf(this),1);
         if(hasEventListener(FlexEvent.TRANSITION_END))
         {
            dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_END));
         }
         if(_loc1_ && _loc1_.hasEventListener(FlexEvent.TRANSITION_END))
         {
            _loc1_.dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_END));
         }
      }
      
      protected function cleanUp() : void
      {
         var _loc1_:UIComponent = null;
         var _loc2_:uint = 0;
         if(!this.consolidatedTransition && this.transitionGroup)
         {
            if(this.cachedTitleGroup)
            {
               this.transitionGroup.removeElement(this.cachedTitleGroup);
            }
            if(this.cachedNavigationGroup)
            {
               this.transitionGroup.removeElement(this.cachedNavigationGroup);
            }
            if(this.cachedActionGroup)
            {
               this.transitionGroup.removeElement(this.cachedActionGroup);
               this.actionBar.actionGroup.cacheAsBitmap = false;
            }
            if(this.actionBar)
            {
               if(this.actionBar.titleGroup && this.actionBar.titleGroup.visible)
               {
                  this.actionBar.titleGroup.postLayoutTransformOffsets = null;
                  this.actionBar.titleGroup.cacheAsBitmap = false;
               }
               if(this.actionBar.titleDisplay && this.actionBar.titleDisplay is DisplayObject && DisplayObject(this.actionBar.titleDisplay).visible)
               {
                  (this.actionBar.titleDisplay as UIComponent).postLayoutTransformOffsets = null;
                  DisplayObject(this.actionBar.titleDisplay).cacheAsBitmap = false;
               }
               if(this.verticalTransition)
               {
                  _loc1_ = this.actionBar.titleGroup;
                  if(!_loc1_ || !_loc1_.visible)
                  {
                     _loc1_ = this.actionBar.titleDisplay as UIComponent;
                  }
                  if(_loc1_)
                  {
                     this.transitionGroup.removeElement(_loc1_);
                     this.addComponentToContainer(_loc1_,this.actionBar.skin);
                  }
               }
               if(this.endView.navigationContent && this.verticalTransition)
               {
                  this.transitionGroup.removeElement(this.actionBar.navigationGroup);
                  if(this.actionBar.titleDisplay)
                  {
                     _loc2_ = this.actionBar.skin.getChildIndex(this.actionBar.titleDisplay as DisplayObject);
                     this.addComponentToContainerAt(this.actionBar.navigationGroup,this.actionBar.skin,_loc2_);
                  }
                  else
                  {
                     this.addComponentToContainer(this.actionBar.navigationGroup,this.actionBar.skin);
                  }
               }
               if(this.endView.actionContent && this.verticalTransition)
               {
                  this.transitionGroup.removeElement(this.actionBar.actionGroup);
                  if(this.actionBar.titleDisplay)
                  {
                     _loc2_ = this.actionBar.skin.getChildIndex(this.actionBar.titleDisplay as DisplayObject);
                     this.addComponentToContainerAt(this.actionBar.actionGroup,this.actionBar.skin,_loc2_);
                  }
                  else
                  {
                     this.addComponentToContainer(this.actionBar.actionGroup,this.actionBar.skin);
                  }
               }
               this.removeComponentFromContainer(this.transitionGroup,this.actionBar.skin);
               this.actionBar.skin.scrollRect = null;
               if(this.actionBar.width != this.cachedActionBarWidth || this.actionBar.height != this.cachedActionBarHeight)
               {
                  this.actionBar.skin.invalidateDisplayList();
               }
               if(this.actionBar.actionGroup)
               {
                  this.actionBar.actionGroup.postLayoutTransformOffsets = null;
               }
               if(this.actionBar.navigationGroup)
               {
                  this.actionBar.navigationGroup.postLayoutTransformOffsets = null;
               }
            }
            this.verticalTransition = false;
            this.cachedActionBarHeight = 0;
            this.cachedActionBarWidth = 0;
            this.transitionGroup = null;
            this.cachedTitleGroup = null;
            this.cachedNavigationGroup = null;
            this.cachedActionGroup = null;
         }
         this.consolidatedTransition = false;
         this.actionBar = null;
         this.tabBar = null;
         this.parentNavigator = null;
         this.targetNavigator = null;
         this.navigator = null;
         this.startView = null;
         this.endView = null;
         if(this.suspendBackgroundProcessing)
         {
            UIComponent.resumeBackgroundProcessing();
         }
      }
      
      protected function canTransitionControlBarContent() : Boolean
      {
         var _loc1_:ButtonBarBase = null;
         var _loc2_:ActionBar = null;
         if(this.transitionControlsWithContent)
         {
            return false;
         }
         if(this.targetNavigator is TabbedViewNavigator)
         {
            _loc1_ = TabbedViewNavigator(this.targetNavigator).tabBar;
            if(this.componentIsVisible(_loc1_) != this.endView.tabBarVisible)
            {
               return false;
            }
         }
         if(this.navigator is ViewNavigator)
         {
            _loc2_ = ViewNavigator(this.navigator).actionBar;
            if(this.componentIsVisible(_loc2_) != this.endView.actionBarVisible)
            {
               return false;
            }
         }
         if(!this.startView || !this.endView)
         {
            return false;
         }
         if(this.startView.overlayControls != this.endView.overlayControls)
         {
            return false;
         }
         return true;
      }
      
      protected function getSnapshot(param1:UIComponent, param2:int = 4, param3:Point = null) : BitmapImage
      {
         var inverted:Matrix = null;
         var pt:Point = null;
         var target:UIComponent = param1;
         var padding:int = param2;
         var globalPosition:Point = param3;
         if(!target || !target.visible || target.width == 0 || target.height == 0)
         {
            return null;
         }
         var snapshot:BitmapImage = new BitmapImage();
         snapshot.alwaysCreateDisplayObject = true;
         var bounds:Rectangle = new Rectangle();
         try
         {
            snapshot.source = BitmapUtil.getSnapshotWithPadding(target,padding,true,bounds);
         }
         catch(e:SecurityError)
         {
            return null;
         }
         snapshot.width = bounds.width;
         snapshot.height = bounds.height;
         var m:Matrix = new Matrix();
         m.translate(bounds.left,bounds.top);
         var parent:DisplayObjectContainer = target.parent;
         if(parent)
         {
            inverted = parent.transform.concatenatedMatrix.clone();
            inverted.invert();
            m.concat(inverted);
         }
         snapshot.setLayoutMatrix(m,false);
         snapshot.includeInLayout = false;
         if(globalPosition)
         {
            pt = !!parent?parent.localToGlobal(new Point(snapshot.x,snapshot.y)):new Point();
            globalPosition.x = pt.x;
            globalPosition.y = pt.y;
         }
         return snapshot;
      }
      
      private function actionBarMoveEffect_effectEndedHandler(param1:EffectEvent) : void
      {
         param1.target.removeEventListener(EffectEvent.EFFECT_UPDATE,this.actionBarMoveEffect_effectUpdateHandler);
         param1.target.removeEventListener(EffectEvent.EFFECT_END,this.actionBarMoveEffect_effectEndedHandler);
      }
      
      private function actionBarMoveEffect_effectUpdateHandler(param1:EffectEvent) : void
      {
         if(!this.actionBar)
         {
            return;
         }
         if(this.verticalTransition)
         {
            if(this.actionBar.actionGroup && this.actionBar.actionGroup.postLayoutTransformOffsets)
            {
               this.actionBar.actionGroup.$y = this.actionBar.actionGroup.y + this.actionBar.actionGroup.postLayoutTransformOffsets.y;
            }
            if(this.actionBar.navigationGroup && this.actionBar.navigationGroup.postLayoutTransformOffsets)
            {
               this.actionBar.navigationGroup.$y = this.actionBar.navigationGroup.y + this.actionBar.navigationGroup.postLayoutTransformOffsets.y;
            }
            if(this.actionBar.titleDisplay && UIComponent(this.actionBar.titleDisplay).postLayoutTransformOffsets)
            {
               UIComponent(this.actionBar.titleDisplay).$y = UIComponent(this.actionBar.titleDisplay).y + UIComponent(this.actionBar.titleDisplay).postLayoutTransformOffsets.y;
            }
            if(this.actionBar.titleGroup && this.actionBar.titleGroup.postLayoutTransformOffsets)
            {
               this.actionBar.titleGroup.$y = this.actionBar.titleGroup.y + this.actionBar.titleGroup.postLayoutTransformOffsets.y;
            }
            if(this.cachedTitleGroup && this.cachedTitleGroup.displayObject)
            {
               this.cachedTitleGroup.displayObject.y = this.cachedTitleGroup.y + this.cachedTitleGroup.postLayoutTransformOffsets.y;
            }
            if(this.cachedNavigationGroup && this.cachedNavigationGroup.displayObject)
            {
               this.cachedNavigationGroup.displayObject.y = this.cachedNavigationGroup.y + this.cachedNavigationGroup.postLayoutTransformOffsets.y;
            }
            if(this.cachedActionGroup && this.cachedActionGroup.displayObject)
            {
               this.cachedActionGroup.displayObject.y = this.cachedActionGroup.y + this.cachedActionGroup.postLayoutTransformOffsets.y;
            }
         }
         else
         {
            if(this.actionBar.actionGroup && this.actionBar.actionGroup.postLayoutTransformOffsets)
            {
               this.actionBar.actionGroup.$x = this.actionBar.actionGroup.x + this.actionBar.actionGroup.postLayoutTransformOffsets.x;
            }
            if(this.actionBar.navigationGroup && this.actionBar.navigationGroup.postLayoutTransformOffsets)
            {
               this.actionBar.navigationGroup.$x = this.actionBar.navigationGroup.x + this.actionBar.navigationGroup.postLayoutTransformOffsets.x;
            }
            if(this.actionBar.titleDisplay && UIComponent(this.actionBar.titleDisplay).postLayoutTransformOffsets)
            {
               UIComponent(this.actionBar.titleDisplay).$x = UIComponent(this.actionBar.titleDisplay).x + UIComponent(this.actionBar.titleDisplay).postLayoutTransformOffsets.x;
            }
            if(this.actionBar.titleGroup && this.actionBar.titleGroup.postLayoutTransformOffsets)
            {
               this.actionBar.titleGroup.$x = this.actionBar.titleGroup.x + this.actionBar.titleGroup.postLayoutTransformOffsets.x;
            }
            if(this.cachedTitleGroup && this.cachedTitleGroup.displayObject)
            {
               this.cachedTitleGroup.displayObject.x = this.cachedTitleGroup.x + this.cachedTitleGroup.postLayoutTransformOffsets.x;
            }
            if(this.cachedNavigationGroup && this.cachedNavigationGroup.displayObject)
            {
               this.cachedNavigationGroup.displayObject.x = this.cachedNavigationGroup.x + this.cachedNavigationGroup.postLayoutTransformOffsets.x;
            }
            if(this.cachedActionGroup && this.cachedActionGroup.displayObject)
            {
               this.cachedActionGroup.displayObject.x = this.cachedActionGroup.x + this.cachedActionGroup.postLayoutTransformOffsets.x;
            }
         }
      }
      
      private function effectComplete(param1:EffectEvent) : void
      {
         this.effect.removeEventListener(EffectEvent.EFFECT_END,this.effectComplete);
         if(!this.consolidatedTransition)
         {
            this.actionBarMoveEffect_effectUpdateHandler(null);
         }
         if(renderLastFrame)
         {
            this.navigator.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
         else
         {
            this.enterFrameHandler(null);
         }
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         if(param1)
         {
            this.navigator.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
         this.effect = null;
         this.transitionComplete();
      }
      
      mx_internal function componentIsVisible(param1:UIComponent) : Boolean
      {
         return param1 && param1.visible && param1.width && param1.height && param1.alpha;
      }
      
      mx_internal function addComponentToContainerAt(param1:UIComponent, param2:UIComponent, param3:int) : void
      {
         if(param2 is IVisualElementContainer)
         {
            IVisualElementContainer(param2).addElementAt(param1,param3);
         }
         else
         {
            param2.addChildAt(param1,param3);
         }
      }
      
      mx_internal function addComponentToContainer(param1:UIComponent, param2:UIComponent) : void
      {
         if(param2 is IVisualElementContainer)
         {
            IVisualElementContainer(param2).addElement(param1);
         }
         else
         {
            param2.addChild(param1);
         }
      }
      
      mx_internal function removeComponentFromContainer(param1:UIComponent, param2:UIComponent) : void
      {
         if(param2 is IVisualElementContainer)
         {
            IVisualElementContainer(param2).removeElement(param1);
         }
         else
         {
            param2.removeChild(param1);
         }
      }
      
      mx_internal function setComponentChildIndex(param1:UIComponent, param2:UIComponent, param3:int) : void
      {
         if(param2 is IVisualElementContainer)
         {
            IVisualElementContainer(param2).setElementIndex(param1,param3);
         }
         else
         {
            param2.setChildIndex(param1,param3);
         }
      }
      
      mx_internal function addCachedElementToGroup(param1:Group, param2:BitmapImage, param3:Point) : void
      {
         param1.addElement(param2);
         var _loc4_:Point = param1.globalToLocal(param3);
         param2.x = _loc4_.x;
         param2.y = _loc4_.y;
      }
      
      mx_internal function getComponentChildIndex(param1:UIComponent, param2:UIComponent) : int
      {
         if(param2 is IVisualElementContainer)
         {
            return IVisualElementContainer(param2).getElementIndex(param1);
         }
         return param2.getChildIndex(param1);
      }
   }
}
