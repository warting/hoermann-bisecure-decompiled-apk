package spark.components
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.registerClassAlias;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   import mx.effects.Parallel;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.LayoutManager;
   import spark.components.supportClasses.NavigationStack;
   import spark.components.supportClasses.ViewDescriptor;
   import spark.components.supportClasses.ViewNavigatorAction;
   import spark.components.supportClasses.ViewNavigatorBase;
   import spark.components.supportClasses.ViewReturnObject;
   import spark.core.ContainerDestructionPolicy;
   import spark.effects.Animate;
   import spark.effects.animation.Animation;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.transitions.SlideViewTransition;
   import spark.transitions.ViewTransitionBase;
   import spark.transitions.ViewTransitionDirection;
   
   use namespace mx_internal;
   
   public class ViewNavigator extends ViewNavigatorBase
   {
      
      private static const ACTION_BAR_ANIMATION_DURATION:Number = 250;
      
      private static const DEFAULT_VIEW_TRANSITION_DURATION:Number = 300;
      
      private static var classAliasesRegistered:Boolean = false;
      
      private static var viewTransitionSuspendCount:int = 0;
      
      private static var eventDispatcher:EventDispatcher;
       
      
      [SkinPart(required="false")]
      public var actionBar:ActionBar;
      
      private var actionBarProps:Object;
      
      private var actionBarVisibilityEffect:IEffect;
      
      private var contentGroupProps:Object;
      
      private var animateActionBarVisbility:Boolean = false;
      
      private var actionBarVisibilityInvalidated:Boolean = false;
      
      private var backKeyWasPressed:Boolean = false;
      
      private var currentViewDescriptor:ViewDescriptor = null;
      
      private var delayedNavigationActions:Vector.<Object>;
      
      mx_internal var viewChangeRequested:Boolean = false;
      
      private var emptyViewDescriptor:ViewDescriptor = null;
      
      private var enterFrameCount:int = 0;
      
      private var explicitMouseEnabled:Boolean;
      
      private var explicitMouseChildren:Boolean;
      
      private var overlayControlsInvalidated:Boolean = false;
      
      private var pendingViewDescriptor:ViewDescriptor = null;
      
      private var pendingViewTransition:ViewTransitionBase = null;
      
      mx_internal var activeTransition:ViewTransitionBase;
      
      private var showingActionBar:Boolean;
      
      mx_internal var viewChanging:Boolean = false;
      
      private var _defaultPushTransition:ViewTransitionBase;
      
      private var _defaultPopTransition:ViewTransitionBase;
      
      private var _firstView:Class;
      
      private var _firstViewData:Object;
      
      private var _poppedViewReturnedObject:ViewReturnObject = null;
      
      private var _actionContent:Array;
      
      private var actionContentInvalidated:Boolean = false;
      
      private var _actionLayout:LayoutBase;
      
      private var actionLayoutInvalidated:Boolean = false;
      
      private var _navigationContent:Array;
      
      private var navigationContentInvalidated:Boolean = false;
      
      private var _navigationLayout:LayoutBase;
      
      private var navigationLayoutInvalidated:Boolean = false;
      
      private var _title:String;
      
      private var titleInvalidated:Boolean = false;
      
      private var _titleContent:Array;
      
      private var titleContentInvalidated:Boolean = false;
      
      private var _titleLayout:LayoutBase;
      
      private var titleLayoutInvalidated:Boolean = false;
      
      public function ViewNavigator()
      {
         this.delayedNavigationActions = new Vector.<Object>();
         super();
         if(!classAliasesRegistered)
         {
            registerClassAlias("ViewDescriptor",ViewDescriptor);
            registerClassAlias("NavigationStack",NavigationStack);
            classAliasesRegistered = true;
         }
         var _loc1_:SlideViewTransition = new SlideViewTransition();
         _loc1_.duration = DEFAULT_VIEW_TRANSITION_DURATION;
         _loc1_.direction = ViewTransitionDirection.LEFT;
         this.defaultPushTransition = _loc1_;
         var _loc2_:SlideViewTransition = new SlideViewTransition();
         _loc2_.duration = DEFAULT_VIEW_TRANSITION_DURATION;
         _loc2_.direction = ViewTransitionDirection.RIGHT;
         this.defaultPopTransition = _loc2_;
      }
      
      mx_internal static function suspendTransitions() : void
      {
         viewTransitionSuspendCount++;
      }
      
      mx_internal static function resumeTransitions() : void
      {
         if(viewTransitionSuspendCount == 0)
         {
            return;
         }
         viewTransitionSuspendCount--;
         if(viewTransitionSuspendCount == 0)
         {
            eventDispatcher.dispatchEvent(new Event("viewTransitionReady"));
         }
      }
      
      private function get actionBarPropertyInvalidated() : Boolean
      {
         return this.actionContentInvalidated || this.actionLayoutInvalidated || this.navigationContentInvalidated || this.navigationLayoutInvalidated || this.titleInvalidated || this.titleContentInvalidated || this.titleLayoutInvalidated || this.overlayControlsInvalidated;
      }
      
      override mx_internal function setActive(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:* = false;
         if(param1 == isActive)
         {
            return;
         }
         if(param2)
         {
            navigationStack.popToFirstView();
         }
         if(param1)
         {
            this.createTopView();
            if(this.activeView)
            {
               if(this.activeView.initialized && !this.activeView.invalidatePropertiesFlag && !this.activeView.invalidateSizeFlag && !this.activeView.invalidateDisplayListFlag)
               {
                  this.completeViewCommitProcess();
               }
               else
               {
                  this.activeView.addEventListener(FlexEvent.UPDATE_COMPLETE,this.view_updateCompleteHandler);
               }
            }
            this.invalidateActionBarProperties();
         }
         else if(this.activeView)
         {
            _loc3_ = this.activeView.destructionPolicy != ContainerDestructionPolicy.NEVER;
            if(_loc3_ || param2)
            {
               this.destroyViewInstance(navigationStack.topView,!param2);
            }
            else
            {
               this.deactiveView(this.activeView);
            }
         }
         super.setActive(param1,param2);
      }
      
      [Bindable("viewChangeComplete")]
      override public function get activeView() : View
      {
         if(this.pendingViewDescriptor)
         {
            return this.pendingViewDescriptor.instance;
         }
         if(this.currentViewDescriptor && this.currentViewDescriptor != this.emptyViewDescriptor)
         {
            return this.currentViewDescriptor.instance;
         }
         return null;
      }
      
      override mx_internal function get exitApplicationOnBackKey() : Boolean
      {
         return !this.backKeyWasPressed && this.length <= 1;
      }
      
      public function get context() : Object
      {
         if(this.pendingViewDescriptor)
         {
            return this.pendingViewDescriptor.context;
         }
         if(this.currentViewDescriptor)
         {
            return this.currentViewDescriptor.context;
         }
         return null;
      }
      
      public function get defaultPushTransition() : ViewTransitionBase
      {
         return this._defaultPushTransition;
      }
      
      public function set defaultPushTransition(param1:ViewTransitionBase) : void
      {
         this._defaultPushTransition = param1;
      }
      
      public function get defaultPopTransition() : ViewTransitionBase
      {
         return this._defaultPopTransition;
      }
      
      public function set defaultPopTransition(param1:ViewTransitionBase) : void
      {
         this._defaultPopTransition = param1;
      }
      
      public function get firstView() : Class
      {
         return this._firstView;
      }
      
      public function set firstView(param1:Class) : void
      {
         this._firstView = param1;
      }
      
      public function get firstViewData() : Object
      {
         return this._firstViewData;
      }
      
      public function set firstViewData(param1:Object) : void
      {
         this._firstViewData = param1;
      }
      
      [Bindable("lengthChanged")]
      public function get length() : int
      {
         return navigationStack.length;
      }
      
      override mx_internal function set navigationStack(param1:NavigationStack) : void
      {
         super.navigationStack = param1;
         this.viewChangeRequested = true;
         invalidateProperties();
      }
      
      public function get poppedViewReturnedObject() : ViewReturnObject
      {
         return this._poppedViewReturnedObject;
      }
      
      public function get actionContent() : Array
      {
         return this._actionContent;
      }
      
      public function set actionContent(param1:Array) : void
      {
         this._actionContent = param1;
         if(!this.activeView || this.activeView && !this.activeView.actionContent)
         {
            this.actionContentInvalidated = true;
            invalidateProperties();
         }
      }
      
      public function get actionLayout() : LayoutBase
      {
         return this._actionLayout;
      }
      
      public function set actionLayout(param1:LayoutBase) : void
      {
         this._actionLayout = param1;
         if(!this.activeView || this.activeView && !this.activeView.actionLayout)
         {
            this.actionLayoutInvalidated = true;
            invalidateProperties();
         }
      }
      
      public function get navigationContent() : Array
      {
         return this._navigationContent;
      }
      
      public function set navigationContent(param1:Array) : void
      {
         this._navigationContent = param1;
         if(!this.activeView || this.activeView && !this.activeView.navigationContent)
         {
            this.navigationContentInvalidated = true;
            invalidateProperties();
         }
      }
      
      public function get navigationLayout() : LayoutBase
      {
         return this._navigationLayout;
      }
      
      public function set navigationLayout(param1:LayoutBase) : void
      {
         this._navigationLayout = param1;
         if(!this.activeView || this.activeView && !this.activeView.navigationLayout)
         {
            this.navigationLayoutInvalidated = true;
            invalidateProperties();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._title;
      }
      
      private function set _110371416title(param1:String) : void
      {
         if(this._title != param1)
         {
            this._title = param1;
            if(!this.activeView || this.activeView && !this.activeView.title && !this.activeView.titleContent && !this.titleContent)
            {
               this.titleInvalidated = true;
               invalidateProperties();
            }
         }
      }
      
      public function get titleContent() : Array
      {
         return this._titleContent;
      }
      
      public function set titleContent(param1:Array) : void
      {
         this._titleContent = param1;
         if(!this.activeView || this.activeView && !this.activeView.titleContent)
         {
            this.titleContentInvalidated = true;
            invalidateProperties();
         }
      }
      
      public function get titleLayout() : LayoutBase
      {
         return this._titleLayout;
      }
      
      public function set titleLayout(param1:LayoutBase) : void
      {
         this._titleLayout = param1;
         if(!this.activeView || this.activeView && !this.activeView.titleLayout)
         {
            this.titleLayoutInvalidated = true;
            invalidateProperties();
         }
      }
      
      public function popAll(param1:ViewTransitionBase = null) : void
      {
         if(navigationStack.length == 0 || !this.canRemoveCurrentView())
         {
            return;
         }
         this.scheduleAction(ViewNavigatorAction.POP_ALL,null,null,null,param1);
      }
      
      public function popView(param1:ViewTransitionBase = null) : void
      {
         if(navigationStack.length == 0 || !this.canRemoveCurrentView())
         {
            return;
         }
         this.scheduleAction(ViewNavigatorAction.POP,null,null,null,param1);
      }
      
      public function popToFirstView(param1:ViewTransitionBase = null) : void
      {
         if(navigationStack.length < 2 || !this.canRemoveCurrentView())
         {
            return;
         }
         this.scheduleAction(ViewNavigatorAction.POP_TO_FIRST,null,null,null,param1);
      }
      
      public function pushView(param1:Class, param2:Object = null, param3:Object = null, param4:ViewTransitionBase = null) : void
      {
         if(param1 == null || !this.canRemoveCurrentView())
         {
            return;
         }
         this.scheduleAction(ViewNavigatorAction.PUSH,param1,param2,param3,param4);
      }
      
      public function replaceView(param1:Class, param2:Object = null, param3:Object = null, param4:ViewTransitionBase = null) : void
      {
         if(param1 == null || !this.canRemoveCurrentView())
         {
            return;
         }
         this.scheduleAction(ViewNavigatorAction.REPLACE,param1,param2,param3,param4);
      }
      
      public function showActionBar(param1:Boolean = true) : void
      {
         if(!this.actionBar)
         {
            return;
         }
         if(this.actionBarVisibilityEffect && this.showingActionBar)
         {
            return;
         }
         this.showingActionBar = true;
         this.animateActionBarVisbility = param1;
         this.actionBarVisibilityInvalidated = true;
         invalidateProperties();
      }
      
      public function hideActionBar(param1:Boolean = true) : void
      {
         if(!this.actionBar)
         {
            return;
         }
         if(this.actionBarVisibilityEffect && !this.showingActionBar)
         {
            return;
         }
         this.showingActionBar = false;
         this.animateActionBarVisbility = param1;
         this.actionBarVisibilityInvalidated = true;
         invalidateProperties();
      }
      
      override public function backKeyUpHandler() : void
      {
         if(!this.backKeyWasPressed && this.activeView && !this.activeView.backKeyHandledByView())
         {
            this.popView();
            this.backKeyWasPressed = true;
         }
      }
      
      protected function committingNavigatorAction() : void
      {
         this.viewChanging = true;
         this.explicitMouseChildren = mouseChildren;
         this.explicitMouseEnabled = mouseEnabled;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override mx_internal function canRemoveCurrentView() : Boolean
      {
         var _loc1_:View = null;
         if(!this.currentViewDescriptor)
         {
            return true;
         }
         _loc1_ = this.currentViewDescriptor.instance;
         return _loc1_ == null || _loc1_.canRemove();
      }
      
      private function clearActionBarInvalidationFlags() : void
      {
         this.actionContentInvalidated = false;
         this.actionLayoutInvalidated = false;
         this.navigationContentInvalidated = false;
         this.navigationLayoutInvalidated = false;
         this.titleInvalidated = false;
         this.titleContentInvalidated = false;
         this.titleLayoutInvalidated = false;
         this.overlayControlsInvalidated = false;
      }
      
      override protected function commitProperties() : void
      {
         if(!isActive)
         {
            return;
         }
         if(!initialized && navigationStack.length == 0 && !this.currentViewDescriptor)
         {
            if(this.firstView)
            {
               navigationStack.pushView(this.firstView,this.firstViewData);
            }
            this.viewChangeRequested = true;
         }
         if(this.viewChangeRequested)
         {
            this.commitNavigatorAction();
         }
         if(this.actionBarPropertyInvalidated)
         {
            this.updateControlsForView(this.activeView);
         }
         if(this.actionBarVisibilityInvalidated)
         {
            this.commitVisibilityChanges();
         }
         if(disableNextControlAnimation)
         {
            disableNextControlAnimation = false;
         }
         super.commitProperties();
      }
      
      private function get lastActionWasAPop() : Boolean
      {
         return lastAction == ViewNavigatorAction.POP || lastAction == ViewNavigatorAction.POP_ALL || lastAction == ViewNavigatorAction.POP_TO_FIRST || lastAction == ViewNavigatorAction.REPLACE;
      }
      
      private function scheduleAction(param1:String, param2:Class = null, param3:Object = null, param4:Object = null, param5:ViewTransitionBase = null) : void
      {
         if(param1 == ViewNavigatorAction.PUSH || param1 == ViewNavigatorAction.REPLACE)
         {
            if(!param2)
            {
               return;
            }
         }
         if(this.delayedNavigationActions.length == 0)
         {
            if(!this.viewChanging)
            {
               addEventListener(Event.ENTER_FRAME,this.executeDelayedActions);
            }
         }
         this.delayedNavigationActions.push({
            "action":param1,
            "viewClass":param2,
            "data":param3,
            "transition":param5,
            "context":param4
         });
         if(this.activeView)
         {
            this.activeView.dispatchEvent(new Event("_navigationChange_"));
         }
      }
      
      private function executeDelayedActions(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            removeEventListener(Event.ENTER_FRAME,this.executeDelayedActions);
         }
         if(this.delayedNavigationActions.length == 0)
         {
            return;
         }
         var _loc3_:int = this.delayedNavigationActions.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.delayedNavigationActions[_loc4_];
            this.executeAction(_loc2_.action,_loc2_.viewClass,_loc2_.data,_loc2_.context,_loc2_.transition);
            _loc4_++;
         }
         this.delayedNavigationActions.length = 0;
         this.viewChangeRequested = true;
         invalidateProperties();
      }
      
      private function executeAction(param1:String, param2:Class = null, param3:Object = null, param4:Object = null, param5:ViewTransitionBase = null) : void
      {
         var _loc6_:ViewTransitionBase = null;
         lastAction = param1;
         if(param1 == ViewNavigatorAction.PUSH)
         {
            _loc6_ = this.defaultPushTransition;
            navigationStack.pushView(param2,param3,param4);
         }
         else if(param1 == ViewNavigatorAction.REPLACE)
         {
            _loc6_ = this.defaultPushTransition;
            navigationStack.popView();
            navigationStack.pushView(param2,param3,param4);
         }
         else
         {
            _loc6_ = this.defaultPopTransition;
            if(param1 == ViewNavigatorAction.POP)
            {
               navigationStack.popView();
            }
            else if(param1 == ViewNavigatorAction.POP_TO_FIRST)
            {
               navigationStack.popToFirstView();
            }
            else if(param1 == ViewNavigatorAction.POP_ALL)
            {
               navigationStack.clear();
            }
         }
         this.pendingViewTransition = param5;
         if(this.pendingViewTransition == null)
         {
            this.pendingViewTransition = _loc6_;
         }
      }
      
      private function invalidateActionBarProperties() : void
      {
         this.actionContentInvalidated = true;
         this.actionLayoutInvalidated = true;
         this.navigationContentInvalidated = true;
         this.navigationLayoutInvalidated = true;
         this.titleInvalidated = true;
         this.titleContentInvalidated = true;
         this.overlayControlsInvalidated = true;
         this.titleLayoutInvalidated = true;
         invalidateProperties();
      }
      
      private function commitVisibilityChanges() : void
      {
         if(this.viewChanging)
         {
            this.actionBarVisibilityInvalidated = false;
            return;
         }
         if(this.actionBarVisibilityEffect)
         {
            this.actionBarVisibilityEffect.end();
         }
         if(this.actionBar && this.showingActionBar != this.actionBar.visible)
         {
            if(!disableNextControlAnimation && transitionsEnabled && this.animateActionBarVisbility)
            {
               this.actionBarProps = {
                  "target":this.actionBar,
                  "showing":this.showingActionBar
               };
               this.actionBarVisibilityEffect = !!this.showingActionBar?this.createActionBarShowEffect():this.createActionBarHideEffect();
               this.actionBarVisibilityEffect.addEventListener(EffectEvent.EFFECT_END,this.visibilityAnimation_effectEndHandler);
               this.actionBarVisibilityEffect.play();
            }
            else
            {
               this.actionBar.visible = this.actionBar.includeInLayout = this.showingActionBar;
               if(this.activeView)
               {
                  this.activeView.setActionBarVisible(this.showingActionBar);
               }
            }
         }
         this.actionBarVisibilityInvalidated = false;
      }
      
      protected function createActionBarHideEffect() : IEffect
      {
         return this.createActionBarVisibilityEffect(false);
      }
      
      protected function createActionBarShowEffect() : IEffect
      {
         return this.createActionBarVisibilityEffect(true);
      }
      
      private function createActionBarVisibilityEffect(param1:Boolean) : IEffect
      {
         var _loc2_:IEffect = null;
         var _loc3_:Parallel = new Parallel();
         this.actionBarProps.start = captureAnimationValues(this.actionBar);
         this.contentGroupProps = {
            "target":contentGroup,
            "start":captureAnimationValues(contentGroup)
         };
         this.actionBar.visible = this.actionBar.includeInLayout = param1;
         this.prepareActionBarForAnimation(param1);
         var _loc4_:Animate = new Animate();
         _loc4_.target = this.actionBar;
         _loc4_.duration = ACTION_BAR_ANIMATION_DURATION;
         _loc4_.motionPaths = new Vector.<MotionPath>();
         _loc4_.motionPaths.push(new SimpleMotionPath("y",this.actionBarProps.start.y,this.actionBarProps.end.y));
         _loc2_ = _loc4_;
         _loc3_.addChild(_loc2_);
         _loc2_ = this.createContentVisibilityEffect(this.contentGroupProps);
         _loc2_.target = contentGroup;
         _loc3_.addChild(_loc2_);
         return _loc3_;
      }
      
      private function prepareActionBarForAnimation(param1:Boolean) : void
      {
         var _loc2_:* = false;
         if(overlayControls)
         {
            _loc2_ = this.actionBar.y + this.actionBar.height / 2 <= height / 2;
         }
         else
         {
            _loc2_ = this.actionBar.y <= contentGroup.y;
         }
         LayoutManager.getInstance().validateNow();
         this.actionBarProps.end = captureAnimationValues(this.actionBar);
         this.contentGroupProps.end = captureAnimationValues(contentGroup);
         if(_loc2_)
         {
            if(param1)
            {
               this.actionBarProps.start.y = -this.actionBar.height;
            }
            else
            {
               this.actionBarProps.end.y = -this.actionBar.height;
            }
         }
         else if(param1)
         {
            this.actionBarProps.start.y = this.height;
         }
         else
         {
            this.actionBarProps.end.y = this.height;
         }
         this.actionBar.visible = true;
         this.actionBar.includeInLayout = false;
         this.actionBar.cacheAsBitmap = true;
      }
      
      private function createContentVisibilityEffect(param1:Object) : IEffect
      {
         var _loc2_:Animate = new Animate();
         _loc2_.target = contentGroup;
         _loc2_.duration = ACTION_BAR_ANIMATION_DURATION;
         _loc2_.motionPaths = new Vector.<MotionPath>();
         _loc2_.motionPaths.push(new SimpleMotionPath("height",param1.start.height,param1.end.height));
         _loc2_.motionPaths.push(new SimpleMotionPath("y",param1.start.y,param1.end.y));
         contentGroup.includeInLayout = false;
         return _loc2_;
      }
      
      private function visibilityAnimation_effectEndHandler(param1:EffectEvent) : void
      {
         param1.target.removeEventListener(EffectEvent.EFFECT_END,this.visibilityAnimation_effectEndHandler);
         this.actionBarVisibilityEffect = null;
         if(this.activeView)
         {
            this.activeView.setActionBarVisible(this.actionBarProps.showing);
         }
         if(this.actionBarProps.start != undefined)
         {
            this.actionBar.visible = this.actionBar.includeInLayout = !this.actionBarProps.start.visible;
            this.actionBar.cacheAsBitmap = this.actionBarProps.start.cacheAsBitmap;
         }
         this.actionBarProps = null;
         if(this.contentGroupProps)
         {
            contentGroup.includeInLayout = this.contentGroupProps.start.includeInLayout;
            if(isNaN(this.contentGroupProps.start.explicitHeight))
            {
               contentGroup.explicitHeight = NaN;
            }
            if(isNaN(this.contentGroupProps.start.explicitWidth))
            {
               contentGroup.explicitWidth = NaN;
            }
            if(!isNaN(this.contentGroupProps.start.percentWidth))
            {
               contentGroup.percentWidth = this.contentGroupProps.start.percentWidth;
            }
            if(!isNaN(this.contentGroupProps.start.percentHeight))
            {
               contentGroup.percentHeight = this.contentGroupProps.start.percentHeight;
            }
            this.contentGroupProps = null;
         }
      }
      
      protected function navigatorActionCommitted() : void
      {
         if(this.currentViewDescriptor)
         {
            this.destroyViewInstance(this.currentViewDescriptor);
         }
         this.currentViewDescriptor = this.pendingViewDescriptor;
         this.pendingViewDescriptor = null;
         if(this.emptyViewDescriptor && this.currentViewDescriptor != this.emptyViewDescriptor)
         {
            this.emptyViewDescriptor = null;
         }
         updateFocus();
         this._poppedViewReturnedObject = null;
         mouseChildren = this.explicitMouseChildren;
         mouseEnabled = this.explicitMouseEnabled;
         addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function view_updateCompleteHandler(param1:FlexEvent) : void
      {
         param1.target.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.view_updateCompleteHandler);
         this.completeViewCommitProcess();
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.completeViewCommitProcess();
      }
      
      private function completeViewCommitProcess() : void
      {
         var _loc1_:View = null;
         if(this.delayedNavigationActions.length > 0)
         {
            this.executeDelayedActions();
            this.commitNavigatorAction();
            return;
         }
         this.viewChanging = false;
         if(this.currentViewDescriptor)
         {
            _loc1_ = this.currentViewDescriptor.instance;
            if(_loc1_)
            {
               _loc1_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
               _loc1_.setActive(true);
            }
         }
         if(hasEventListener("viewChangeComplete"))
         {
            dispatchEvent(new Event("viewChangeComplete"));
         }
         this.backKeyWasPressed = false;
         lastAction = ViewNavigatorAction.NONE;
      }
      
      protected function commitNavigatorAction() : void
      {
         var _loc1_:View = null;
         if(!isActive)
         {
            this.viewChangeRequested = false;
            return;
         }
         if(hasEventListener("viewChangeStart"))
         {
            dispatchEvent(new Event("viewChangeStart"));
         }
         if(this.actionBarVisibilityEffect)
         {
            this.actionBarVisibilityEffect.end();
         }
         if(this.activeView && this.lastActionWasAPop)
         {
            this._poppedViewReturnedObject = this.createViewReturnObject(this.currentViewDescriptor);
         }
         this.committingNavigatorAction();
         this.pendingViewDescriptor = navigationStack.topView;
         if(this.pendingViewDescriptor == null)
         {
            this.emptyViewDescriptor = new ViewDescriptor(View);
            this.pendingViewDescriptor = this.emptyViewDescriptor;
         }
         if(this.pendingViewDescriptor.viewClass != null)
         {
            _loc1_ = this.createViewInstance(this.pendingViewDescriptor);
            this.viewChangeRequested = false;
            _loc1_.visible = false;
            this.activeTransition = !!transitionsEnabled?this.pendingViewTransition:null;
            addEventListener(FlexEvent.UPDATE_COMPLETE,this.prepareViewTransition);
         }
         this.pendingViewTransition = null;
      }
      
      override mx_internal function createTopView() : void
      {
         if(this.activeView)
         {
            return;
         }
         this.invalidateActionBarProperties();
         if(navigationStack.length == 0)
         {
            if(this.firstView != null)
            {
               navigationStack.pushView(this.firstView,this.firstViewData);
            }
            else
            {
               return;
            }
         }
         this.currentViewDescriptor = navigationStack.topView;
         var _loc1_:View = this.currentViewDescriptor.instance;
         if(!_loc1_)
         {
            _loc1_ = this.createViewInstance(this.currentViewDescriptor);
            _loc1_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
         }
         this.viewChangeRequested = false;
      }
      
      private function createViewInstance(param1:ViewDescriptor) : View
      {
         var _loc2_:View = null;
         if(param1.instance == null)
         {
            _loc2_ = new param1.viewClass();
            param1.instance = _loc2_;
         }
         else
         {
            _loc2_ = param1.instance;
            _loc2_.setCurrentState(_loc2_.getCurrentViewState(),false);
         }
         if(param1.data == null && param1.persistenceData != null)
         {
            param1.data = _loc2_.deserializeData(param1.persistenceData);
         }
         _loc2_.setNavigator(this);
         _loc2_.data = param1.data;
         _loc2_.percentWidth = _loc2_.percentHeight = 100;
         addElement(_loc2_);
         return _loc2_;
      }
      
      private function createViewReturnObject(param1:ViewDescriptor) : ViewReturnObject
      {
         var _loc2_:View = param1.instance;
         if(_loc2_)
         {
            return new ViewReturnObject(_loc2_.createReturnObject(),param1.context);
         }
         return null;
      }
      
      private function destroyViewInstance(param1:ViewDescriptor, param2:Boolean = false) : void
      {
         var _loc3_:View = param1.instance;
         if(!_loc3_)
         {
            return;
         }
         this.deactiveView(_loc3_);
         removeElement(_loc3_);
         if(lastAction == ViewNavigatorAction.PUSH || param2)
         {
            param1.data = _loc3_.data;
            param1.persistenceData = _loc3_.serializeData();
         }
         if(this.lastActionWasAPop || _loc3_.destructionPolicy != ContainerDestructionPolicy.NEVER)
         {
            _loc3_.setNavigator(null);
            param1.instance = null;
         }
      }
      
      private function deactiveView(param1:View) : void
      {
         if(param1.isActive)
         {
            param1.setActive(false);
         }
         param1.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
      }
      
      override public function saveViewData() : Object
      {
         var _loc1_:Object = super.saveViewData();
         if(this.currentViewDescriptor && this.currentViewDescriptor.instance)
         {
            this.currentViewDescriptor.persistenceData = this.currentViewDescriptor.instance.serializeData();
         }
         if(!_loc1_)
         {
            _loc1_ = {};
         }
         _loc1_.navigationStack = navigationStack;
         return _loc1_;
      }
      
      override public function loadViewData(param1:Object) : void
      {
         super.loadViewData(param1);
         if(param1)
         {
            this.navigationStack = param1.navigationStack as NavigationStack;
         }
      }
      
      private function prepareViewTransition(param1:Event) : void
      {
         var _loc2_:View = null;
         var _loc3_:View = null;
         removeEventListener(FlexEvent.UPDATE_COMPLETE,this.prepareViewTransition);
         if(this.currentViewDescriptor)
         {
            _loc2_ = this.currentViewDescriptor.instance;
            _loc2_.setActive(false);
            _loc2_.validateNow();
         }
         if(this.pendingViewDescriptor)
         {
            _loc3_ = this.pendingViewDescriptor.instance;
            _loc3_.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
         }
         if(this.activeTransition)
         {
            this.activeTransition.addEventListener(FlexEvent.TRANSITION_END,this.transitionComplete);
            this.activeTransition.startView = _loc2_;
            this.activeTransition.endView = _loc3_;
            this.activeTransition.navigator = this;
            this.activeTransition.preInit();
            if(stage)
            {
               stage.dispatchEvent(new Event("viewTransitionPrepare"));
            }
         }
         if(stage && viewTransitionSuspendCount > 0)
         {
            if(!eventDispatcher)
            {
               eventDispatcher = new EventDispatcher();
            }
            eventDispatcher.addEventListener("viewTransitionReady",this.completeTransitionPreparations);
         }
         else
         {
            this.completeTransitionPreparations();
         }
      }
      
      private function completeTransitionPreparations(param1:Event = null) : void
      {
         var _loc2_:View = null;
         if(param1)
         {
            param1.target.removeEventListener("viewTransitionReady",this.completeTransitionPreparations);
         }
         if(this.pendingViewDescriptor)
         {
            _loc2_ = this.pendingViewDescriptor.instance;
            _loc2_.visible = true;
         }
         if(this.activeTransition)
         {
            this.activeTransition.captureStartValues();
         }
         if(hasEventListener("lengthChanged"))
         {
            dispatchEvent(new Event("lengthChanged"));
         }
         if(this.actionBar)
         {
            this.invalidateActionBarProperties();
            this.updateControlsForView(_loc2_);
         }
         if(initialized)
         {
            if(parentNavigator)
            {
               UIComponent(parentNavigator).validateNow();
            }
            else
            {
               validateNow();
            }
         }
         if(this.activeTransition)
         {
            this.activeTransition.captureEndValues();
            this.activeTransition.prepareForPlay();
            this.enterFrameCount = 0;
            addEventListener(Event.ENTER_FRAME,this.startViewTransition);
         }
         else
         {
            this.navigatorActionCommitted();
         }
      }
      
      private function startViewTransition(param1:Event) : void
      {
         this.enterFrameCount++;
         if(this.enterFrameCount < 2)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.startViewTransition);
         if(hasEventListener(FlexEvent.TRANSITION_START))
         {
            dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_START,false,false));
         }
         Animation.pulse();
         this.activeTransition.play();
      }
      
      private function transitionComplete(param1:Event) : void
      {
         ViewTransitionBase(param1.target).removeEventListener(FlexEvent.TRANSITION_END,this.transitionComplete);
         if(hasEventListener(FlexEvent.TRANSITION_END))
         {
            dispatchEvent(new FlexEvent(FlexEvent.TRANSITION_END,false,false));
         }
         this.activeTransition = null;
         this.navigatorActionCommitted();
      }
      
      override public function updateControlsForView(param1:View) : void
      {
         super.updateControlsForView(param1);
         if(!this.actionBar)
         {
            return;
         }
         if(param1 == null)
         {
            this.actionBar.actionContent = this.actionContent;
            this.actionBar.actionLayout = this.actionLayout;
            this.actionBar.navigationContent = this.navigationContent;
            this.actionBar.navigationLayout = this.navigationLayout;
            this.actionBar.title = this.title;
            this.actionBar.titleContent = this.titleContent;
            this.actionBar.titleLayout = this.titleLayout;
            overlayControls = false;
         }
         else
         {
            if(this.actionContentInvalidated)
            {
               this.actionBar.actionContent = param1 && param1.actionContent?param1.actionContent:this.actionContent;
               this.actionContentInvalidated = false;
            }
            if(this.actionLayoutInvalidated)
            {
               this.actionBar.actionLayout = param1 && param1.actionLayout?param1.actionLayout:this.actionLayout;
               this.actionLayoutInvalidated = false;
            }
            if(this.navigationContentInvalidated)
            {
               this.actionBar.navigationContent = param1 && param1.navigationContent?param1.navigationContent:this.navigationContent;
               this.navigationContentInvalidated = false;
            }
            if(this.navigationLayoutInvalidated)
            {
               this.actionBar.navigationLayout = param1 && param1.navigationLayout?param1.navigationLayout:this.navigationLayout;
               this.navigationLayoutInvalidated = false;
            }
            if(this.titleInvalidated)
            {
               this.actionBar.title = param1 && param1.title?param1.title:this.title;
               this.titleInvalidated = false;
            }
            if(this.titleContentInvalidated)
            {
               this.actionBar.titleContent = param1 && param1.titleContent?param1.titleContent:this.titleContent;
               this.titleContentInvalidated = false;
            }
            if(this.titleLayoutInvalidated)
            {
               this.actionBar.titleLayout = param1 && param1.titleLayout?param1.titleLayout:this.titleLayout;
               this.titleLayoutInvalidated = false;
            }
            if(this.overlayControlsInvalidated)
            {
               if(overlayControls != param1.overlayControls)
               {
                  overlayControls = param1.overlayControls;
                  super.commitProperties();
               }
               this.overlayControlsInvalidated = false;
            }
            this.actionBar.visible = this.actionBar.includeInLayout = param1 && param1.actionBarVisible;
            this.actionBarVisibilityInvalidated = false;
            this.actionBar.invalidateSize();
            this.actionBar.invalidateDisplayList();
         }
      }
      
      private function view_propertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:Object = param1.property;
         if(this.actionBar)
         {
            _loc3_ = true;
            if(_loc2_ == "title")
            {
               this.titleInvalidated = true;
            }
            else if(_loc2_ == "titleContent")
            {
               this.titleContentInvalidated = true;
            }
            else if(_loc2_ == "titleLayout")
            {
               this.titleLayoutInvalidated = true;
            }
            else if(_loc2_ == "actionContent")
            {
               this.actionContentInvalidated = true;
            }
            else if(_loc2_ == "actionLayout")
            {
               this.actionLayoutInvalidated = true;
            }
            else if(_loc2_ == "navigationContent")
            {
               this.navigationContentInvalidated = true;
            }
            else if(_loc2_ == "navigationLayout")
            {
               this.navigationLayoutInvalidated = true;
            }
            else
            {
               _loc3_ = false;
            }
            if(_loc3_)
            {
               invalidateProperties();
            }
         }
         if(_loc2_ == "overlayControls")
         {
            this.overlayControlsInvalidated = true;
            invalidateProperties();
         }
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         super.partAdded(param1,param2);
         if(param2 == this.actionBar)
         {
            this.actionContentInvalidated = true;
            this.actionLayoutInvalidated = true;
            this.navigationContentInvalidated = true;
            this.navigationLayoutInvalidated = true;
            this.titleInvalidated = true;
            this.titleContentInvalidated = true;
            this.titleLayoutInvalidated = true;
            invalidateProperties();
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         super.partRemoved(param1,param2);
         if(param2 == this.actionBar)
         {
            this.actionBar.actionContent = null;
            this.actionBar.actionLayout = null;
            this.actionBar.titleContent = null;
            this.actionBar.titleLayout = null;
            this.actionBar.navigationContent = null;
            this.actionBar.navigationContent = null;
         }
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this.title;
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
