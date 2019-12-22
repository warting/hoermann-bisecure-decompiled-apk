package spark.components
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import mx.core.ISelectableList;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   import mx.effects.Parallel;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.managers.LayoutManager;
   import mx.resources.ResourceManager;
   import spark.components.supportClasses.ButtonBarBase;
   import spark.components.supportClasses.ViewNavigatorBase;
   import spark.effects.Animate;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.events.ElementExistenceEvent;
   import spark.events.IndexChangeEvent;
   import spark.events.RendererExistenceEvent;
   
   use namespace mx_internal;
   
   public class TabbedViewNavigator extends ViewNavigatorBase implements ISelectableList
   {
      
      private static const NO_PROPOSED_SELECTION:int = -1;
      
      private static const TAB_BAR_ANIMATION_DURATION:Number = 250;
       
      
      private var _881418178tabBar:ButtonBarBase;
      
      private var animateTabBarVisbility:Boolean = false;
      
      private var contentGroupProps:Object;
      
      private var changingEventDispatched:Boolean = false;
      
      private var dataProviderChanged:Boolean = false;
      
      private var explicitTabBarMouseEnabled:Boolean = false;
      
      private var lastSelectedIndex:int = -1;
      
      private var selectedIndexChanged:Boolean = false;
      
      private var selectedIndexAdjusted:Boolean = false;
      
      private var showingTabBar:Boolean;
      
      private var tabBarVisibilityEffect:IEffect;
      
      private var tabBarProps:Object;
      
      private var tabBarVisibilityChanged:Boolean = false;
      
      mx_internal var selectedNavigatorChangingView:Boolean = false;
      
      private var _maintainNavigationStack:Boolean = true;
      
      protected var _proposedSelectedIndex:int = -1;
      
      protected var _selectedIndex:int = -1;
      
      public function TabbedViewNavigator()
      {
         super();
         addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.elementAddHandler);
         addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.elementRemoveHandler);
      }
      
      [Bindable("viewChangeComplete")]
      override public function get activeView() : View
      {
         if(this.selectedNavigator)
         {
            return this.selectedNavigator.activeView;
         }
         return null;
      }
      
      override mx_internal function get exitApplicationOnBackKey() : Boolean
      {
         if(this.selectedNavigator)
         {
            return this.selectedNavigator.exitApplicationOnBackKey;
         }
         return super.exitApplicationOnBackKey;
      }
      
      mx_internal function get maintainNavigationStack() : Boolean
      {
         return this._maintainNavigationStack;
      }
      
      mx_internal function set maintainNavigationStack(param1:Boolean) : void
      {
         this._maintainNavigationStack = param1;
      }
      
      public function get navigators() : Vector.<ViewNavigatorBase>
      {
         var _loc1_:Array = currentContentGroup.getMXMLContent();
         if(!_loc1_)
         {
            return null;
         }
         return Vector.<ViewNavigatorBase>(_loc1_);
      }
      
      public function set navigators(param1:Vector.<ViewNavigatorBase>) : void
      {
         var _loc3_:ViewNavigatorBase = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
            this.setupNavigator(_loc3_);
         }
         mxmlContent = _loc2_;
         this.selectedIndexChanged = false;
         this.dataProviderChanged = true;
         invalidateProperties();
         this.internalDispatchEvent(CollectionEventKind.RESET);
      }
      
      [Bindable("change")]
      public function get selectedNavigator() : ViewNavigatorBase
      {
         if(this.length == 0 || this.selectedIndex < 0 || this.selectedIndex >= this.length)
         {
            return null;
         }
         return getElementAt(this.selectedIndex) as ViewNavigatorBase;
      }
      
      public function hideTabBar(param1:Boolean = true) : void
      {
         if(!this.tabBar)
         {
            return;
         }
         this.showingTabBar = false;
         this.animateTabBarVisbility = param1;
         this.tabBarVisibilityChanged = true;
         invalidateProperties();
      }
      
      public function showTabBar(param1:Boolean = true) : void
      {
         if(!this.tabBar)
         {
            return;
         }
         this.showingTabBar = true;
         this.animateTabBarVisbility = param1;
         this.tabBarVisibilityChanged = true;
         invalidateProperties();
      }
      
      override public function updateControlsForView(param1:View) : void
      {
         super.updateControlsForView(param1);
         if(param1)
         {
            if(this.tabBar)
            {
               this.tabBar.visible = this.tabBar.includeInLayout = param1.tabBarVisible;
            }
            overlayControls = param1.overlayControls;
         }
         else
         {
            if(this.tabBar)
            {
               this.tabBar.visible = this.tabBar.includeInLayout = true;
            }
            overlayControls = false;
         }
         this.tabBarVisibilityChanged = false;
      }
      
      override public function backKeyUpHandler() : void
      {
         if(this.selectedNavigator)
         {
            this.selectedNavigator.backKeyUpHandler();
         }
      }
      
      private function prepareTabBarForAnimation(param1:Boolean) : void
      {
         var _loc2_:* = false;
         if(overlayControls)
         {
            _loc2_ = this.tabBar.y + this.tabBar.height / 2 <= height / 2;
         }
         else
         {
            _loc2_ = this.tabBar.y <= contentGroup.y;
         }
         LayoutManager.getInstance().validateNow();
         this.tabBarProps.end = captureAnimationValues(this.tabBar);
         this.contentGroupProps.end = captureAnimationValues(contentGroup);
         if(this.tabBarVisibilityChanged)
         {
            if(_loc2_)
            {
               if(this.tabBarProps.start.visible)
               {
                  this.tabBarProps.end.y = -this.tabBar.height;
               }
               else
               {
                  this.tabBarProps.start.y = -this.tabBar.height;
               }
            }
            else if(this.tabBarProps.start.visible)
            {
               this.tabBarProps.end.y = this.height;
            }
            else
            {
               this.tabBarProps.start.y = this.height;
            }
         }
         this.tabBar.visible = true;
         this.tabBar.includeInLayout = false;
         this.tabBar.cacheAsBitmap = true;
      }
      
      override mx_internal function canRemoveCurrentView() : Boolean
      {
         return !this.selectedNavigator || this.selectedNavigator.canRemoveCurrentView();
      }
      
      private function addNavigatorListeners(param1:ViewNavigatorBase) : void
      {
         param1.addEventListener("viewChangeComplete",this.navigator_viewChangeCompleteHandler);
         param1.addEventListener("viewChangeStart",this.navigator_viewChangeStartHandler);
         param1.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.navigator_elementAddHandler);
         param1.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.navigator_elementRemoveHandler);
      }
      
      private function removeNavigatorListeners(param1:ViewNavigatorBase) : void
      {
         param1.removeEventListener("viewChangeComplete",this.navigator_viewChangeCompleteHandler);
         param1.removeEventListener("viewChangeStart",this.navigator_viewChangeStartHandler);
         param1.removeEventListener(ElementExistenceEvent.ELEMENT_ADD,this.navigator_elementAddHandler);
         param1.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.navigator_elementRemoveHandler);
      }
      
      private function setupNavigator(param1:ViewNavigatorBase) : void
      {
         param1.setParentNavigator(this);
         param1.visible = false;
         param1.includeInLayout = false;
         param1.setActive(false);
         this.startTrackingUpdates(param1);
      }
      
      private function cleanUpNavigator(param1:ViewNavigatorBase) : void
      {
         param1.setParentNavigator(null);
         if(param1.isActive)
         {
            param1.setActive(false);
         }
         if(param1.activeView)
         {
            param1.activeView.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
         }
         this.removeNavigatorListeners(param1);
         this.stopTrackingUpdates(param1);
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:IndexChangeEvent = null;
         var _loc2_:ViewNavigatorBase = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         if(this.selectedIndexChanged || this.selectedIndexAdjusted || this.dataProviderChanged)
         {
            _loc3_ = this._selectedIndex;
            if(this.selectedIndex >= this.length)
            {
               this.selectedIndex = this.length > 0?0:int(NO_PROPOSED_SELECTION);
            }
            _loc4_ = false;
            if(initialized && this.selectedIndexChanged && !this.changingEventDispatched)
            {
               if(!this.indexCanChange(this.selectedIndex))
               {
                  this._proposedSelectedIndex = NO_PROPOSED_SELECTION;
                  _loc4_ = true;
               }
            }
            this.changingEventDispatched = false;
            if(!_loc4_)
            {
               if(!this.selectedIndexAdjusted && !this.dataProviderChanged && this._selectedIndex >= 0 && this._selectedIndex < this.length)
               {
                  _loc2_ = getElementAt(this._selectedIndex) as ViewNavigatorBase;
                  _loc2_.setActive(false,!this.maintainNavigationStack);
                  _loc2_.visible = false;
                  _loc2_.includeInLayout = false;
                  if(_loc2_.activeView)
                  {
                     _loc2_.activeView.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
                  }
                  this.removeNavigatorListeners(_loc2_);
               }
               this.commitSelection();
               if(this._selectedIndex >= 0)
               {
                  updateFocus();
                  _loc2_ = getElementAt(this._selectedIndex) as ViewNavigatorBase;
                  _loc2_.setActive(true);
                  _loc2_.visible = true;
                  _loc2_.includeInLayout = true;
                  this.addNavigatorListeners(_loc2_);
                  _loc2_.updateControlsForView(_loc2_.activeView);
                  if(initialized)
                  {
                     currentContentGroup.validateNow();
                  }
                  if(_loc2_.activeView)
                  {
                     _loc2_.activeView.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
                  }
               }
               if(hasEventListener(IndexChangeEvent.CHANGE))
               {
                  _loc1_ = new IndexChangeEvent(IndexChangeEvent.CHANGE,false,false);
                  _loc1_.oldIndex = _loc3_;
                  _loc1_.newIndex = this._selectedIndex;
               }
            }
            this.selectedIndexAdjusted = false;
            this.dataProviderChanged = false;
            this.selectedIndexChanged = false;
         }
         if(this.tabBarVisibilityChanged)
         {
            this.commitVisibilityChanges();
         }
         if(disableNextControlAnimation)
         {
            disableNextControlAnimation = false;
         }
         super.commitProperties();
         if(_loc1_)
         {
            dispatchEvent(_loc1_);
         }
      }
      
      protected function commitSelection() : void
      {
         this._selectedIndex = this._proposedSelectedIndex;
         this._proposedSelectedIndex = NO_PROPOSED_SELECTION;
         this.lastSelectedIndex = this._selectedIndex;
         if(hasEventListener(FlexEvent.VALUE_COMMIT))
         {
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
      }
      
      private function commitVisibilityChanges() : void
      {
         if(this.selectedNavigatorChangingView)
         {
            return;
         }
         if(this.tabBarVisibilityEffect)
         {
            this.tabBarVisibilityEffect.end();
         }
         if(this.tabBar && this.showingTabBar != this.tabBar.visible)
         {
            if(!disableNextControlAnimation && transitionsEnabled && this.animateTabBarVisbility)
            {
               this.tabBarProps = {
                  "target":this.tabBar,
                  "showing":this.showingTabBar
               };
               this.tabBarVisibilityEffect = !!this.showingTabBar?this.createTabBarShowEffect():this.createTabBarHideEffect();
               this.tabBarVisibilityEffect.addEventListener(EffectEvent.EFFECT_END,this.visibilityAnimation_effectEndHandler);
               this.tabBarVisibilityEffect.play();
            }
            else
            {
               this.tabBar.visible = this.tabBar.includeInLayout = this.showingTabBar;
               if(this.activeView)
               {
                  this.activeView.setTabBarVisible(this.showingTabBar);
               }
            }
         }
         this.tabBarVisibilityChanged = false;
      }
      
      protected function createTabBarShowEffect() : IEffect
      {
         return this.createTabBarVisibilityEffect(true);
      }
      
      protected function createTabBarHideEffect() : IEffect
      {
         return this.createTabBarVisibilityEffect(false);
      }
      
      private function createTabBarVisibilityEffect(param1:Boolean) : IEffect
      {
         var _loc2_:IEffect = null;
         var _loc3_:Parallel = new Parallel();
         this.tabBarProps.start = captureAnimationValues(this.tabBar);
         this.contentGroupProps = {"start":captureAnimationValues(contentGroup)};
         this.tabBar.visible = this.tabBar.includeInLayout = this.showingTabBar;
         this.prepareTabBarForAnimation(param1);
         var _loc4_:Animate = new Animate();
         _loc4_.target = this.tabBar;
         _loc4_.duration = TAB_BAR_ANIMATION_DURATION;
         _loc4_.motionPaths = new Vector.<MotionPath>();
         _loc4_.motionPaths.push(new SimpleMotionPath("y",this.tabBarProps.start.y,this.tabBarProps.end.y));
         _loc2_ = _loc4_;
         _loc3_.addChild(_loc2_);
         _loc4_ = new Animate();
         _loc4_.target = contentGroup;
         _loc4_.duration = TAB_BAR_ANIMATION_DURATION;
         _loc4_.motionPaths = new Vector.<MotionPath>();
         _loc4_.motionPaths.push(new SimpleMotionPath("y",this.contentGroupProps.start.y,this.contentGroupProps.end.y));
         _loc4_.motionPaths.push(new SimpleMotionPath("height",this.contentGroupProps.start.height,this.contentGroupProps.end.height));
         contentGroup.includeInLayout = false;
         _loc3_.addChild(_loc4_);
         _loc3_.duration = TAB_BAR_ANIMATION_DURATION;
         return _loc3_;
      }
      
      private function navigator_elementAddHandler(param1:ElementExistenceEvent) : void
      {
         param1.element.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
      }
      
      private function navigator_elementRemoveHandler(param1:ElementExistenceEvent) : void
      {
         param1.element.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.view_propertyChangeHandler);
      }
      
      private function navigator_propertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         this.itemUpdated(param1.target,param1.property,param1.oldValue,param1.newValue);
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         super.partAdded(param1,param2);
         if(param2 == this.tabBar)
         {
            this.tabBar.addEventListener(IndexChangeEvent.CHANGING,this.tabBar_indexChanging);
            this.tabBar.dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD,this.tabBar_elementAddHandler);
            this.tabBar.dataProvider = this;
            this.tabBar.requireSelection = true;
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         super.partRemoved(param1,param2);
         if(param2 == this.tabBar)
         {
            this.tabBar.dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD,this.tabBar_elementAddHandler);
            this.tabBar.removeEventListener(IndexChangeEvent.CHANGING,this.tabBar_indexChanging);
            this.tabBar.dataProvider = null;
         }
      }
      
      override public function loadViewData(param1:Object) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc4_:ViewNavigatorBase = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         super.loadViewData(param1);
         var _loc3_:Number = param1.selectedIndex as Number;
         if(!isNaN(_loc3_) && _loc3_ < this.length)
         {
            this.selectedIndex = _loc3_;
         }
         _loc2_ = param1.childrenStates as Vector.<Object>;
         if(_loc2_)
         {
            _loc5_ = Math.min(_loc2_.length,this.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_ = getElementAt(_loc6_) as ViewNavigatorBase;
               _loc4_.loadViewData(_loc2_[_loc6_]);
               _loc6_++;
            }
         }
      }
      
      override public function saveViewData() : Object
      {
         var _loc1_:Object = super.saveViewData();
         var _loc2_:Vector.<Object> = new Vector.<Object>();
         var _loc3_:int = 0;
         while(_loc3_ < this.length)
         {
            _loc2_.push((getElementAt(_loc3_) as ViewNavigatorBase).saveViewData());
            _loc3_++;
         }
         if(!_loc1_)
         {
            _loc1_ = {};
         }
         _loc1_.selectedIndex = this.selectedIndex;
         _loc1_.childrenStates = _loc2_;
         return _loc1_;
      }
      
      private function navigator_viewChangeCompleteHandler(param1:Event) : void
      {
         if(hasEventListener("viewChangeComplete"))
         {
            dispatchEvent(param1);
         }
         this.selectedNavigatorChangingView = false;
         if(this.tabBar)
         {
            this.tabBar.mouseEnabled = this.explicitTabBarMouseEnabled;
         }
      }
      
      private function navigator_viewChangeStartHandler(param1:Event) : void
      {
         this.selectedNavigatorChangingView = true;
         if(this.tabBar)
         {
            this.explicitTabBarMouseEnabled = this.tabBar.mouseEnabled;
            this.tabBar.mouseEnabled = false;
         }
      }
      
      private function tabBar_elementAddHandler(param1:RendererExistenceEvent) : void
      {
         param1.target.addEventListener(MouseEvent.CLICK,this.tabBarRenderer_clickHandler);
      }
      
      private function tabBar_indexChanging(param1:IndexChangeEvent) : void
      {
         if(!this.indexCanChange(param1.newIndex))
         {
            param1.preventDefault();
            this.changingEventDispatched = false;
         }
      }
      
      private function elementRemoveHandler(param1:ElementExistenceEvent) : void
      {
         this.cleanUpNavigator(param1.element as ViewNavigatorBase);
         this.internalDispatchEvent(CollectionEventKind.REMOVE,param1.element,param1.index);
         if(numElements == 1)
         {
            this.selectedIndex = -1;
         }
      }
      
      private function elementAddHandler(param1:ElementExistenceEvent) : void
      {
         this.setupNavigator(param1.element as ViewNavigatorBase);
         this.internalDispatchEvent(CollectionEventKind.ADD,param1.element,param1.index);
         if(numElements == 1)
         {
            this.selectedIndex = 0;
         }
      }
      
      mx_internal function tabBarRenderer_clickHandler(param1:MouseEvent) : void
      {
         if(param1.target is IItemRenderer && IItemRenderer(param1.target).itemIndex == this.lastSelectedIndex)
         {
            if(this.selectedNavigator is ViewNavigator)
            {
               ViewNavigator(this.selectedNavigator).popToFirstView();
            }
         }
      }
      
      private function view_propertyChangeHandler(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "tabBarVisible")
         {
            if(param1.newValue)
            {
               this.showTabBar();
            }
            else
            {
               this.hideTabBar();
            }
         }
         else if(param1.property == "overlayControls")
         {
            overlayControls = param1.newValue;
         }
      }
      
      private function visibilityAnimation_effectEndHandler(param1:EffectEvent) : void
      {
         param1.target.removeEventListener(EffectEvent.EFFECT_END,this.visibilityAnimation_effectEndHandler);
         this.tabBarVisibilityEffect = null;
         if(this.activeView)
         {
            this.activeView.setTabBarVisible(this.tabBarProps.showing);
         }
         if(this.tabBarProps.start != undefined)
         {
            this.tabBar.visible = this.tabBar.includeInLayout = this.tabBarProps.end.visible;
            this.tabBar.cacheAsBitmap = this.tabBarProps.start.cacheAsBitmap;
         }
         this.tabBarProps = null;
         if(this.contentGroupProps)
         {
            contentGroup.includeInLayout = this.contentGroupProps.start.includeInLayout;
            contentGroup.cacheAsBitmap = this.contentGroupProps.start.cacheAsBitmap;
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
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         if(this._proposedSelectedIndex != NO_PROPOSED_SELECTION)
         {
            return this._proposedSelectedIndex;
         }
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(!this.dataProviderChanged && param1 == this.selectedIndex)
         {
            return;
         }
         if(this.activeView)
         {
            this.activeView.dispatchEvent(new Event("_navigationChange_"));
         }
         this._proposedSelectedIndex = param1;
         this.selectedIndexChanged = true;
         invalidateProperties();
      }
      
      private function indexCanChange(param1:int) : Boolean
      {
         var _loc2_:IndexChangeEvent = null;
         this.changingEventDispatched = true;
         if(!this.canRemoveCurrentView())
         {
            return false;
         }
         if(hasEventListener(IndexChangeEvent.CHANGING))
         {
            _loc2_ = new IndexChangeEvent(IndexChangeEvent.CHANGING,false,true);
            _loc2_.oldIndex = this._selectedIndex;
            _loc2_.newIndex = param1;
            if(!dispatchEvent(_loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get length() : int
      {
         return numElements;
      }
      
      public function addItem(param1:Object) : void
      {
         this.addItemAt(param1,this.length);
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         var _loc3_:String = null;
         if(!(param1 is ViewNavigatorBase))
         {
            return;
         }
         if(param2 < 0 || param2 > this.length)
         {
            _loc3_ = ResourceManager.getInstance().getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc3_);
         }
         this.setupNavigator(ViewNavigatorBase(param1));
         addElementAt(ViewNavigatorBase(param1),param2);
         if(this.selectedIndex == NO_PROPOSED_SELECTION || numElements == 1)
         {
            this.selectedIndex = 0;
         }
         else if(param2 <= this.selectedIndex)
         {
            this.selectedIndex++;
            this.selectedIndexAdjusted = true;
         }
      }
      
      public function getItemAt(param1:int, param2:int = 0) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= this.length)
         {
            _loc3_ = ResourceManager.getInstance().getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         return getElementAt(param1);
      }
      
      public function getItemIndex(param1:Object) : int
      {
         return getElementIndex(param1 as ViewNavigatorBase);
      }
      
      public function itemUpdated(param1:Object, param2:Object = null, param3:Object = null, param4:Object = null) : void
      {
         var _loc5_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc5_.kind = PropertyChangeEventKind.UPDATE;
         _loc5_.source = param1;
         _loc5_.property = param2;
         _loc5_.oldValue = param3;
         _loc5_.newValue = param4;
         this.internalDispatchEvent(CollectionEventKind.UPDATE,_loc5_);
      }
      
      public function removeAll() : void
      {
         if(this.selectedNavigator)
         {
            this.selectedNavigator.setActive(false);
         }
         this.navigators = null;
      }
      
      public function removeItem(param1:Object) : Boolean
      {
         var _loc2_:IVisualElement = removeElement(param1 as ViewNavigatorBase);
         return _loc2_ != null;
      }
      
      public function removeItemAt(param1:int) : Object
      {
         var _loc3_:String = null;
         if(param1 < 0 || param1 >= this.length)
         {
            _loc3_ = ResourceManager.getInstance().getString("collections","outOfBounds",[param1]);
            throw new RangeError(_loc3_);
         }
         if(param1 <= this.selectedIndex)
         {
            this.selectedIndex--;
            this.selectedIndexAdjusted = true;
         }
         var _loc2_:Object = removeElementAt(param1);
         return _loc2_;
      }
      
      public function setItemAt(param1:Object, param2:int) : Object
      {
         var _loc4_:String = null;
         var _loc5_:PropertyChangeEvent = null;
         if(!(param1 is ViewNavigator))
         {
            return null;
         }
         if(param2 < 0 || param2 >= this.length)
         {
            _loc4_ = ResourceManager.getInstance().getString("collections","outOfBounds",[param2]);
            throw new RangeError(_loc4_);
         }
         var _loc3_:Object = removeElementAt(param2);
         addElementAt(param1 as ViewNavigatorBase,param2);
         if(param2 == this.selectedIndex)
         {
            this.selectedIndexAdjusted = true;
            invalidateProperties();
         }
         if(hasEventListener(CollectionEvent.COLLECTION_CHANGE))
         {
            _loc5_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc5_.kind = PropertyChangeEventKind.UPDATE;
            _loc5_.oldValue = _loc3_;
            _loc5_.newValue = param1;
            _loc5_.property = param2;
            this.internalDispatchEvent(CollectionEventKind.REPLACE,_loc5_,param2);
         }
         return _loc3_;
      }
      
      public function toArray() : Array
      {
         return contentGroup.getMXMLContent();
      }
      
      private function internalDispatchEvent(param1:String, param2:Object = null, param3:int = -1) : void
      {
         var _loc4_:CollectionEvent = null;
         var _loc5_:PropertyChangeEvent = null;
         if(hasEventListener(CollectionEvent.COLLECTION_CHANGE))
         {
            _loc4_ = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            _loc4_.kind = param1;
            _loc4_.items.push(param2);
            _loc4_.location = param3;
            dispatchEvent(_loc4_);
         }
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE) && (param1 == CollectionEventKind.ADD || param1 == CollectionEventKind.REMOVE))
         {
            _loc5_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc5_.property = param3;
            if(param1 == CollectionEventKind.ADD)
            {
               _loc5_.newValue = param2;
            }
            else
            {
               _loc5_.oldValue = param2;
            }
            dispatchEvent(_loc5_);
         }
      }
      
      private function startTrackingUpdates(param1:Object) : void
      {
         if(param1 && param1 is IEventDispatcher)
         {
            IEventDispatcher(param1).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.navigator_propertyChangeHandler,false,0,true);
         }
      }
      
      private function stopTrackingUpdates(param1:Object) : void
      {
         if(param1 && param1 is IEventDispatcher)
         {
            IEventDispatcher(param1).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.navigator_propertyChangeHandler);
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get tabBar() : ButtonBarBase
      {
         return this._881418178tabBar;
      }
      
      [SkinPart(required="false")]
      public function set tabBar(param1:ButtonBarBase) : void
      {
         var _loc2_:Object = this._881418178tabBar;
         if(_loc2_ !== param1)
         {
            this._881418178tabBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabBar",_loc2_,param1));
            }
         }
      }
   }
}
