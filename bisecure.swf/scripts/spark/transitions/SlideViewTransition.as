package spark.transitions
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.effects.IEffect;
   import spark.components.Group;
   import spark.components.TabbedViewNavigator;
   import spark.effects.Animate;
   import spark.effects.Move;
   import spark.effects.animation.MotionPath;
   import spark.effects.animation.SimpleMotionPath;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class SlideViewTransition extends ViewTransitionBase
   {
       
      
      private var animateTabBar:Boolean = false;
      
      private var cachedActionBar:BitmapImage;
      
      private var cachedActionBarGlobalPosition:Point;
      
      private var cachedStartViewGlobalPosition:Point;
      
      private var cachedTabBar:BitmapImage;
      
      private var cachedTabBarGlobalPosition:Point;
      
      private var startViewProps:Object;
      
      private var endViewProps:Object;
      
      private var navigatorProps:Object;
      
      private var transitionGroup:Group;
      
      private var endViewNeedsValidations:Boolean;
      
      private var startViewNeedsValidations:Boolean;
      
      private var moveEffect:Move;
      
      private var consolidatedEffect:Animate;
      
      private var _direction:String = "left";
      
      private var _mode:String = "push";
      
      public function SlideViewTransition()
      {
         this.cachedActionBarGlobalPosition = new Point();
         this.cachedTabBarGlobalPosition = new Point();
         super();
         duration = 300;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(param1:String) : void
      {
         this._mode = param1;
      }
      
      override mx_internal function preInit() : void
      {
         if(this.mode == SlideViewTransitionMode.UNCOVER)
         {
            setComponentChildIndex(endView,navigator,0);
         }
      }
      
      override public function captureStartValues() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Boolean = false;
         super.captureStartValues();
         this.navigatorProps = {};
         this.navigatorProps.initialHeight = navigator.height;
         this.animateTabBar = false;
         if(tabBar && startView)
         {
            this.animateTabBar = startView.overlayControls != endView.overlayControls || startView.tabBarVisible != endView.tabBarVisible;
         }
         if(this.mode != SlideViewTransitionMode.PUSH)
         {
            _loc2_ = endView.visible;
            endView.visible = false;
            if(tabBar && !this.animateTabBar)
            {
               cachedNavigator = getSnapshot(targetNavigator.contentGroup,0,cachedNavigatorGlobalPosition);
            }
            else
            {
               cachedNavigator = getSnapshot(targetNavigator,0,cachedNavigatorGlobalPosition);
            }
            endView.visible = _loc2_;
         }
         else
         {
            this.cachedActionBar = getSnapshot(navigator.actionBar,4,this.cachedActionBarGlobalPosition);
         }
         if(tabBar)
         {
            this.cachedTabBar = getSnapshot(TabbedViewNavigator(parentNavigator).tabBar,4,this.cachedTabBarGlobalPosition);
            this.navigatorProps.tabBarIncludeInLayout = tabBar.includeInLayout;
            this.navigatorProps.tabBarCacheAsBitmap = tabBar.cacheAsBitmap;
         }
         if(startView)
         {
            this.startViewProps = {
               "includeInLayout":startView.includeInLayout,
               "visible":startView.visible,
               "cacheAsBitmap":startView.cacheAsBitmap,
               "opaqueBackground":startView.opaqueBackground
            };
            startView.includeInLayout = false;
            this.cachedStartViewGlobalPosition = this.getTargetNavigatorCoordinates(startView);
         }
      }
      
      override protected function createViewEffect() : IEffect
      {
         var _loc2_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc1_:Array = [];
         this.endViewNeedsValidations = false;
         this.startViewNeedsValidations = false;
         if(startView)
         {
            this.startViewProps.x = startView.x;
            this.startViewProps.y = startView.y;
            startView.cacheAsBitmap = true;
            if(startView.getStyle("backgroundAlpha") >= 1)
            {
               startView.opaqueBackground = startView.getStyle("backgroundColor");
            }
            if(startView.contentGroup)
            {
               this.startViewProps.cgIncludeInLayout = startView.contentGroup.includeInLayout;
               startView.contentGroup.includeInLayout = false;
            }
            if(this.mode != SlideViewTransitionMode.COVER)
            {
               if(startView.transformRequiresValidations())
               {
                  this.startViewNeedsValidations = true;
               }
               _loc1_.push(startView);
            }
         }
         if(endView)
         {
            this.endViewProps = {
               "cacheAsBitmap":endView.cacheAsBitmap,
               "opaqueBackground":endView.opaqueBackground
            };
            endView.cacheAsBitmap = true;
            if(endView.getStyle("backgroundAlpha") >= 1)
            {
               endView.opaqueBackground = endView.getStyle("backgroundColor");
            }
            if(endView.contentGroup)
            {
               this.endViewProps.cgIncludeInLayout = endView.contentGroup.includeInLayout;
               endView.contentGroup.includeInLayout = false;
            }
            if(this.mode != SlideViewTransitionMode.UNCOVER)
            {
               if(endView.transformRequiresValidations())
               {
                  this.endViewNeedsValidations = true;
               }
               _loc1_.push(endView);
            }
         }
         var _loc3_:Number = 0;
         switch(this.direction)
         {
            case ViewTransitionDirection.DOWN:
               _loc4_ = "$y";
               _loc2_ = navigator.height;
               _loc3_ = -navigator.contentGroup[_loc4_];
               _loc5_ = true;
               break;
            case ViewTransitionDirection.UP:
               _loc4_ = "$y";
               _loc2_ = -navigator.height;
               _loc3_ = navigator.contentGroup[_loc4_];
               _loc5_ = true;
               break;
            case ViewTransitionDirection.RIGHT:
               _loc4_ = "$x";
               _loc2_ = navigator.width;
               break;
            case ViewTransitionDirection.LEFT:
            default:
               _loc4_ = "$x";
               _loc2_ = -navigator.width;
         }
         if(this.mode != SlideViewTransitionMode.UNCOVER)
         {
            endView[_loc4_] = -_loc2_ - _loc3_;
         }
         var _loc6_:Move = new Move();
         _loc6_.targets = _loc1_;
         _loc6_.duration = duration;
         _loc6_.easer = easer;
         if(_loc5_)
         {
            _loc6_.yBy = _loc2_ + _loc3_;
         }
         else
         {
            _loc6_.xBy = _loc2_ + _loc3_;
         }
         if(this.startViewNeedsValidations || this.endViewNeedsValidations)
         {
            _loc6_.addEventListener("effectUpdate",this.effectUpdateHandler);
         }
         this.moveEffect = _loc6_;
         return _loc6_;
      }
      
      private function effectUpdateHandler(param1:Event) : void
      {
         if(this.startViewNeedsValidations)
         {
            startView.validateDisplayList();
         }
         if(this.endViewNeedsValidations)
         {
            endView.validateDisplayList();
         }
      }
      
      override protected function createConsolidatedEffect() : IEffect
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc1_:Array = [];
         this.endViewNeedsValidations = false;
         this.startViewNeedsValidations = false;
         this.navigatorProps.navigatorContentGroupIncludeInLayout = navigator.contentGroup.includeInLayout;
         navigator.contentGroup.includeInLayout = false;
         if(tabBar)
         {
            this.navigatorProps.topNavigatorContentGroupIncludeInLayout = targetNavigator.contentGroup.includeInLayout;
            targetNavigator.contentGroup.includeInLayout = false;
         }
         this.transitionGroup = new Group();
         this.transitionGroup.includeInLayout = false;
         if(startView && this.mode == SlideViewTransitionMode.PUSH)
         {
            if(startView.transformRequiresValidations())
            {
               this.startViewNeedsValidations = true;
            }
            _loc1_.push(startView);
         }
         if(this.mode != SlideViewTransitionMode.UNCOVER)
         {
            if(endView.transformRequiresValidations())
            {
               this.endViewNeedsValidations = true;
            }
            _loc1_.push(endView);
         }
         if(this.mode == SlideViewTransitionMode.COVER)
         {
            addComponentToContainerAt(this.transitionGroup,targetNavigator.skin,0);
            addCachedElementToGroup(this.transitionGroup,cachedNavigator,cachedNavigatorGlobalPosition);
         }
         else if(this.mode == SlideViewTransitionMode.UNCOVER)
         {
            if(this.animateTabBar)
            {
               addComponentToContainer(this.transitionGroup,targetNavigator.skin);
            }
            else
            {
               addComponentToContainer(this.transitionGroup,navigator.skin);
            }
            startView.visible = false;
         }
         else
         {
            addComponentToContainer(this.transitionGroup,targetNavigator.skin);
         }
         if(actionBar)
         {
            if(this.mode != SlideViewTransitionMode.UNCOVER)
            {
               _loc1_.push(actionBar);
            }
            this.navigatorProps.actionBarIncludeInLayout = actionBar.includeInLayout;
            actionBar.includeInLayout = false;
            this.navigatorProps.actionBarCacheAsBitmap = actionBar.cacheAsBitmap;
            actionBar.cacheAsBitmap = true;
         }
         if(this.mode == SlideViewTransitionMode.COVER)
         {
            this.startViewProps = {"visible":startView.visible};
            startView.visible = false;
         }
         else if(startView)
         {
            this.navigatorProps.startViewX = startView.x;
            this.navigatorProps.startViewY = startView.y;
            _loc7_ = this.getTargetNavigatorCoordinates(startView);
            _loc8_ = _loc7_.x - this.cachedStartViewGlobalPosition.x;
            if(_loc8_ != 0)
            {
               startView.x = startView.x - _loc8_;
            }
            _loc8_ = _loc7_.y - this.cachedStartViewGlobalPosition.y;
            if(_loc8_ != 0)
            {
               startView.y = startView.y - _loc8_;
            }
            this.navigatorProps.startViewCacheAsBitmap = startView.contentGroup.cacheAsBitmap;
            startView.contentGroup.cacheAsBitmap = true;
         }
         if(endView)
         {
            this.navigatorProps.endViewCacheAsBitmap = endView.contentGroup.cacheAsBitmap;
            endView.contentGroup.cacheAsBitmap = true;
         }
         if(this.cachedActionBar)
         {
            this.cachedActionBar.includeInLayout = false;
            addCachedElementToGroup(this.transitionGroup,this.cachedActionBar,this.cachedActionBarGlobalPosition);
         }
         if(tabBar)
         {
            this.navigatorProps.tabBarCacheAsBitmap = tabBar.cacheAsBitmap;
            tabBar.cacheAsBitmap = true;
            if(this.animateTabBar)
            {
               this.navigatorProps.tabBarIncludeInLayout = tabBar.includeInLayout;
               tabBar.includeInLayout = false;
               if(this.mode != SlideViewTransitionMode.UNCOVER)
               {
                  _loc1_.push(tabBar);
                  if(this.cachedTabBar)
                  {
                     this.cachedTabBar.includeInLayout = false;
                     addCachedElementToGroup(this.transitionGroup,this.cachedTabBar,this.cachedTabBarGlobalPosition);
                  }
               }
            }
         }
         switch(this.direction)
         {
            case ViewTransitionDirection.RIGHT:
               _loc3_ = "x";
               _loc2_ = targetNavigator.width;
               break;
            case ViewTransitionDirection.DOWN:
               _loc3_ = "y";
               _loc2_ = targetNavigator.height;
               _loc4_ = true;
               break;
            case ViewTransitionDirection.UP:
               _loc3_ = "y";
               _loc2_ = -targetNavigator.height;
               _loc4_ = true;
               break;
            case ViewTransitionDirection.LEFT:
            default:
               _loc3_ = "x";
               _loc2_ = -targetNavigator.width;
         }
         if(this.mode != SlideViewTransitionMode.UNCOVER)
         {
            endView[_loc3_] = -_loc2_ + endView[_loc3_];
            if(actionBar)
            {
               actionBar[_loc3_] = -_loc2_ + actionBar[_loc3_];
            }
            if(this.animateTabBar)
            {
               tabBar[_loc3_] = -_loc2_ + tabBar[_loc3_];
            }
         }
         else if(cachedNavigator)
         {
            cachedNavigator.includeInLayout = false;
            addCachedElementToGroup(this.transitionGroup,cachedNavigator,cachedNavigatorGlobalPosition);
         }
         this.transitionGroup.validateNow();
         if(this.cachedActionBar && this.mode != SlideViewTransitionMode.COVER)
         {
            _loc1_.push(this.cachedActionBar.displayObject);
         }
         if(this.cachedTabBar && this.mode == SlideViewTransitionMode.PUSH)
         {
            _loc1_.push(this.cachedTabBar.displayObject);
         }
         if(cachedNavigator && this.mode == SlideViewTransitionMode.UNCOVER)
         {
            _loc1_.push(cachedNavigator.displayObject);
         }
         var _loc5_:Animate = new Animate();
         var _loc6_:Vector.<MotionPath> = new Vector.<MotionPath>();
         _loc6_.push(new SimpleMotionPath(_loc3_,null,null,_loc2_));
         _loc5_.motionPaths = _loc6_;
         _loc5_.duration = duration;
         _loc5_.easer = easer;
         _loc5_.targets = _loc1_;
         if(this.startViewNeedsValidations || this.endViewNeedsValidations)
         {
            _loc5_.addEventListener("effectUpdate",this.effectUpdateHandler);
         }
         this.consolidatedEffect = _loc5_;
         return _loc5_;
      }
      
      override protected function cleanUp() : void
      {
         if(this.navigatorProps.scrollRectSet)
         {
            navigator.scrollRect = null;
         }
         if(startView)
         {
            startView.includeInLayout = this.startViewProps.includeInLayout;
            startView.visible = this.startViewProps.visible;
            startView.cacheAsBitmap = this.startViewProps.cacheAsBitmap;
            startView.opaqueBackground = this.startViewProps.opaqueBackground;
         }
         if(!consolidatedTransition)
         {
            if(startView)
            {
               startView.x = this.startViewProps.x;
               startView.y = this.startViewProps.y;
               if(startView.contentGroup)
               {
                  startView.contentGroup.includeInLayout = this.startViewProps.cgIncludeInLayout;
               }
            }
            if(endView)
            {
               endView.cacheAsBitmap = this.endViewProps.cacheAsBitmap;
               endView.opaqueBackground = this.endViewProps.opaqueBackground;
               if(endView.contentGroup)
               {
                  endView.contentGroup.includeInLayout = this.endViewProps.cgIncludeInLayout;
               }
               this.endViewProps = null;
            }
            if(this.moveEffect)
            {
               this.moveEffect.removeEventListener("effectUpdate",this.effectUpdateHandler);
            }
            this.moveEffect = null;
         }
         else
         {
            if(tabBar)
            {
               tabBar.includeInLayout = this.navigatorProps.tabBarIncludeInLayout;
               tabBar.cacheAsBitmap = this.navigatorProps.tabBarCacheAsBitmap;
               targetNavigator.contentGroup.includeInLayout = this.navigatorProps.topNavigatorContentGroupIncludeInLayout;
            }
            if(actionBar)
            {
               actionBar.includeInLayout = this.navigatorProps.actionBarIncludeInLayout;
               actionBar.cacheAsBitmap = this.navigatorProps.actionBarCacheAsBitmap;
            }
            if(startView)
            {
               startView.contentGroup.cacheAsBitmap = this.navigatorProps.startViewCacheAsBitmap;
               startView.setLayoutBoundsPosition(this.navigatorProps.startViewX,this.navigatorProps.startViewY);
               startView.visible = true;
            }
            if(endView)
            {
               endView.contentGroup.cacheAsBitmap = this.navigatorProps.endViewCacheAsBitmap;
            }
            navigator.contentGroup.includeInLayout = this.navigatorProps.navigatorContentGroupIncludeInLayout;
            if(this.transitionGroup)
            {
               if(this.mode == SlideViewTransitionMode.UNCOVER)
               {
                  if(this.animateTabBar)
                  {
                     removeComponentFromContainer(this.transitionGroup,targetNavigator.skin);
                  }
                  else
                  {
                     removeComponentFromContainer(this.transitionGroup,navigator.skin);
                  }
               }
               else
               {
                  removeComponentFromContainer(this.transitionGroup,targetNavigator.skin);
               }
            }
            this.consolidatedEffect.removeEventListener("effectUpdate",this.effectUpdateHandler);
            this.consolidatedEffect = null;
         }
         this.transitionGroup = null;
         cachedNavigator = null;
         this.cachedActionBar = null;
         this.cachedTabBar = null;
         this.startViewProps = null;
         super.cleanUp();
      }
      
      override public function prepareForPlay() : void
      {
         actionBarTransitionDirection = this.direction;
         this.applyScrollRect();
         super.prepareForPlay();
      }
      
      private function getTargetNavigatorCoordinates(param1:IVisualElement) : Point
      {
         var _loc2_:Point = DisplayObject(param1).localToGlobal(new Point());
         return targetNavigator.globalToLocal(_loc2_);
      }
      
      mx_internal function applyScrollRect() : void
      {
         if(!navigator.scrollRect)
         {
            this.navigatorProps.scrollRectSet = true;
            navigator.scrollRect = new Rectangle(0,0,navigator.width,Math.max(navigator.height,this.navigatorProps.initialHeight));
         }
      }
   }
}
