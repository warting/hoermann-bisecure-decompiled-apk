package spark.components
{
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.events.KeyboardEvent;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.NavigationStack;
   import spark.components.supportClasses.ViewNavigatorApplicationBase;
   import spark.layouts.supportClasses.LayoutBase;
   
   use namespace mx_internal;
   
   public class ViewNavigatorApplication extends ViewNavigatorApplicationBase
   {
      
      private static const ACTION_CONTENT_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const ACTION_LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      private static const NAVIGATION_CONTENT_PROPERTY_FLAG:uint = 1 << 2;
      
      private static const NAVIGATION_LAYOUT_PROPERTY_FLAG:uint = 1 << 3;
      
      private static const TITLE_PROPERTY_FLAG:uint = 1 << 4;
      
      private static const TITLE_CONTENT_PROPERTY_FLAG:uint = 1 << 5;
      
      private static const TITLE_LAYOUT_PROPERTY_FLAG:uint = 1 << 6;
      
      private static const NAVIGATION_STACK_PROPERTY_FLAG:uint = 1 << 7;
       
      
      private var _752822871navigator:ViewNavigator;
      
      private var navigatorProperties:Object;
      
      private var _firstViewData:Object;
      
      private var _firstView:Class;
      
      public function ViewNavigatorApplication()
      {
         this.navigatorProperties = {};
         super();
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,this.activateHandler);
      }
      
      private function get navigationStack() : NavigationStack
      {
         if(this.navigator)
         {
            return this.navigator.navigationStack;
         }
         return this.navigatorProperties.navigationStack;
      }
      
      private function set navigationStack(param1:NavigationStack) : void
      {
         if(this.navigator)
         {
            this.navigator.navigationStack = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,NAVIGATION_STACK_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.navigationStack = param1;
         }
      }
      
      override mx_internal function get activeView() : View
      {
         if(this.navigator)
         {
            return this.navigator.activeView;
         }
         return null;
      }
      
      public function get actionBar() : ActionBar
      {
         if(this.navigator)
         {
            return this.navigator.actionBar;
         }
         return null;
      }
      
      override mx_internal function get exitApplicationOnBackKey() : Boolean
      {
         if(viewMenuOpen)
         {
            return false;
         }
         if(this.navigator)
         {
            return this.navigator.exitApplicationOnBackKey;
         }
         return super.exitApplicationOnBackKey;
      }
      
      public function get firstViewData() : Object
      {
         return this._firstViewData;
      }
      
      public function set firstViewData(param1:Object) : void
      {
         this._firstViewData = param1;
      }
      
      public function get firstView() : Class
      {
         return this._firstView;
      }
      
      public function set firstView(param1:Class) : void
      {
         this._firstView = param1;
      }
      
      public function get actionContent() : Array
      {
         if(this.navigator)
         {
            return this.navigator.actionContent;
         }
         return this.navigatorProperties.actionContent;
      }
      
      public function set actionContent(param1:Array) : void
      {
         if(this.navigator)
         {
            this.navigator.actionContent = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,ACTION_CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.actionContent = param1;
         }
      }
      
      public function get actionLayout() : LayoutBase
      {
         if(this.navigator)
         {
            return this.navigator.actionLayout;
         }
         return this.navigatorProperties.actionLayout;
      }
      
      public function set actionLayout(param1:LayoutBase) : void
      {
         if(this.navigator)
         {
            this.navigator.actionLayout = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,ACTION_LAYOUT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.actionLayout = param1;
         }
      }
      
      public function get navigationContent() : Array
      {
         if(this.navigator)
         {
            return this.navigator.navigationContent;
         }
         return this.navigatorProperties.navigationContent;
      }
      
      public function set navigationContent(param1:Array) : void
      {
         if(this.navigator)
         {
            this.navigator.navigationContent = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,NAVIGATION_CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.navigationContent = param1;
         }
      }
      
      public function get navigationLayout() : LayoutBase
      {
         if(this.navigator)
         {
            return this.navigator.navigationLayout;
         }
         return this.navigatorProperties.navigationLayout;
      }
      
      public function set navigationLayout(param1:LayoutBase) : void
      {
         if(this.navigator)
         {
            this.navigator.navigationLayout = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,NAVIGATION_LAYOUT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.navigationLayout = param1;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         if(this.navigator)
         {
            return this.navigator.title;
         }
         return this.navigatorProperties.title;
      }
      
      private function set _110371416title(param1:String) : void
      {
         if(this.navigator)
         {
            this.navigator.title = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,TITLE_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.title = param1;
         }
      }
      
      public function get titleContent() : Array
      {
         if(this.navigator)
         {
            return this.navigator.titleContent;
         }
         return this.navigatorProperties.titleContent;
      }
      
      public function set titleContent(param1:Array) : void
      {
         if(this.navigator)
         {
            this.navigator.titleContent = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,TITLE_CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.titleContent = param1;
         }
      }
      
      public function get titleLayout() : LayoutBase
      {
         if(this.navigator)
         {
            return this.navigator.titleLayout;
         }
         return this.navigatorProperties.titleLayout;
      }
      
      public function set titleLayout(param1:LayoutBase) : void
      {
         if(this.navigator)
         {
            this.navigator.titleLayout = param1;
            this.navigatorProperties = BitFlagUtil.update(this.navigatorProperties as uint,NAVIGATION_LAYOUT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.navigatorProperties.titleLayout = param1;
         }
      }
      
      private function activateHandler(param1:Event) : void
      {
         if(this.navigator && this.navigator.activeView)
         {
            if(!this.navigator.activeView.isActive)
            {
               this.navigator.activeView.setActive(true);
            }
            this.navigator.updateFocus();
         }
      }
      
      override protected function invokeHandler(param1:InvokeEvent) : void
      {
         super.invokeHandler(param1);
         if(this.navigator)
         {
            if(this.navigator.activeView)
            {
               systemManager.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler,false,0,true);
            }
            this.navigator.updateFocus();
         }
      }
      
      private function stage_resizeHandler(param1:Event) : void
      {
         systemManager.stage.removeEventListener(Event.RESIZE,this.stage_resizeHandler);
         this.activeView.updateOrientationState();
      }
      
      override protected function deactivateHandler(param1:Event) : void
      {
         if(this.navigator && this.navigator.activeView)
         {
            this.navigator.activeView.setActive(false);
         }
         super.deactivateHandler(param1);
      }
      
      override protected function backKeyUpHandler(param1:KeyboardEvent) : void
      {
         super.backKeyUpHandler(param1);
         if(viewMenuOpen)
         {
            viewMenuOpen = false;
         }
         else if(this.navigator)
         {
            this.navigator.backKeyUpHandler();
         }
      }
      
      override protected function saveNavigatorState() : void
      {
         super.saveNavigatorState();
         if(this.navigator)
         {
            persistenceManager.setProperty("navigatorState",this.navigator.saveViewData());
         }
      }
      
      override protected function loadNavigatorState() : void
      {
         super.loadNavigatorState();
         var _loc1_:Object = persistenceManager.getProperty("navigatorState");
         if(_loc1_)
         {
            this.navigator.loadViewData(_loc1_);
         }
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         var _loc3_:uint = 0;
         super.partAdded(param1,param2);
         if(param2 == this.navigator)
         {
            _loc3_ = 0;
            if(this.navigatorProperties.actionContent !== undefined)
            {
               this.navigator.actionContent = this.navigatorProperties.actionContent;
               _loc3_ = BitFlagUtil.update(_loc3_,ACTION_CONTENT_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.actionLayout !== undefined)
            {
               this.navigator.actionLayout = this.navigatorProperties.actionLayout;
               _loc3_ = BitFlagUtil.update(_loc3_,ACTION_LAYOUT_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.navigationContent !== undefined)
            {
               this.navigator.navigationContent = this.navigatorProperties.navigationContent;
               _loc3_ = BitFlagUtil.update(_loc3_,NAVIGATION_CONTENT_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.navigationLayout !== undefined)
            {
               this.navigator.navigationLayout = this.navigatorProperties.navigationLayout;
               _loc3_ = BitFlagUtil.update(_loc3_,NAVIGATION_LAYOUT_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.title !== undefined)
            {
               this.navigator.title = this.navigatorProperties.title;
               _loc3_ = BitFlagUtil.update(_loc3_,TITLE_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.titleContent !== undefined)
            {
               this.navigator.titleContent = this.navigatorProperties.titleContent;
               _loc3_ = BitFlagUtil.update(_loc3_,TITLE_CONTENT_PROPERTY_FLAG,true);
            }
            if(this.navigatorProperties.titleLayout !== undefined)
            {
               this.navigator.titleLayout = this.navigatorProperties.titleLayout;
               _loc3_ = BitFlagUtil.update(_loc3_,TITLE_LAYOUT_PROPERTY_FLAG,true);
            }
            this.navigatorProperties = _loc3_;
            this.navigator.firstView = this.firstView;
            this.navigator.firstViewData = this.firstViewData;
            this.navigator.navigationStack = this.navigationStack;
            systemManager.stage.focus = this.navigator;
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         super.partRemoved(param1,param2);
         if(param2 == this.navigator)
         {
            _loc3_ = {};
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,ACTION_CONTENT_PROPERTY_FLAG))
            {
               _loc3_.actionContent = this.navigator.actionContent;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,ACTION_LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.actionLayout = this.navigator.actionLayout;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,NAVIGATION_CONTENT_PROPERTY_FLAG))
            {
               _loc3_.navigationContent = this.navigator.navigationContent;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,NAVIGATION_LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.navigationLayout = this.navigator.navigationLayout;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,TITLE_PROPERTY_FLAG))
            {
               _loc3_.title = this.navigator.title;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,TITLE_CONTENT_PROPERTY_FLAG))
            {
               _loc3_.titleContent = this.navigator.titleContent;
            }
            if(BitFlagUtil.isSet(this.navigatorProperties as uint,TITLE_LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.titleLayout = this.navigator.titleLayout;
            }
            _loc3_.navigationStack = this.navigator.navigationStack;
            this.navigatorProperties = _loc3_;
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get navigator() : ViewNavigator
      {
         return this._752822871navigator;
      }
      
      [SkinPart(required="false")]
      public function set navigator(param1:ViewNavigator) : void
      {
         var _loc2_:Object = this._752822871navigator;
         if(_loc2_ !== param1)
         {
            this._752822871navigator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"navigator",_loc2_,param1));
            }
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
