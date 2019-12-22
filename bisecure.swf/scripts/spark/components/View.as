package spark.components
{
   import flash.events.Event;
   import mx.core.FlexGlobals;
   import mx.core.IDataRenderer;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import spark.events.ViewNavigatorEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   use namespace mx_internal;
   
   public class View extends SkinnableContainer implements IDataRenderer
   {
       
      
      private var _active:Boolean = false;
      
      private var _overlayControls:Boolean = false;
      
      private var _destructionPolicy:String = "auto";
      
      private var _navigator:ViewNavigator = null;
      
      private var _actionBarVisible:Boolean = true;
      
      private var _actionContent:Array;
      
      private var _actionLayout:LayoutBase;
      
      private var _viewMenuItems:Vector.<ViewMenuItem>;
      
      private var _navigationContent:Array;
      
      private var _navigationLayout:LayoutBase;
      
      private var _tabBarVisible:Boolean = true;
      
      private var _title:String;
      
      private var _titleContent:Array;
      
      private var _titleLayout:LayoutBase;
      
      private var _data:Object;
      
      public function View()
      {
         super();
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      mx_internal function setActive(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(this._active != param1)
         {
            this._active = param1;
            if(this._active)
            {
               this.updateOrientationState();
            }
            _loc2_ = !!this._active?ViewNavigatorEvent.VIEW_ACTIVATE:ViewNavigatorEvent.VIEW_DEACTIVATE;
            if(hasEventListener(_loc2_))
            {
               dispatchEvent(new ViewNavigatorEvent(_loc2_,false,false,this.navigator.lastAction));
            }
         }
      }
      
      mx_internal function canRemove() : Boolean
      {
         var _loc1_:ViewNavigatorEvent = null;
         if(hasEventListener(ViewNavigatorEvent.REMOVING))
         {
            _loc1_ = new ViewNavigatorEvent(ViewNavigatorEvent.REMOVING,false,true,this.navigator.lastAction);
            return dispatchEvent(_loc1_);
         }
         return true;
      }
      
      mx_internal function backKeyHandledByView() : Boolean
      {
         var _loc1_:FlexEvent = null;
         var _loc2_:* = false;
         if(hasEventListener(FlexEvent.BACK_KEY_PRESSED))
         {
            _loc1_ = new FlexEvent(FlexEvent.BACK_KEY_PRESSED,false,true);
            _loc2_ = !dispatchEvent(_loc1_);
            return _loc2_;
         }
         return false;
      }
      
      mx_internal function menuKeyHandledByView() : Boolean
      {
         var _loc1_:FlexEvent = null;
         var _loc2_:* = false;
         if(hasEventListener(FlexEvent.MENU_KEY_PRESSED))
         {
            _loc1_ = new FlexEvent(FlexEvent.MENU_KEY_PRESSED,false,true);
            _loc2_ = !dispatchEvent(_loc1_);
            return _loc2_;
         }
         return false;
      }
      
      public function get overlayControls() : Boolean
      {
         return this._overlayControls;
      }
      
      public function set overlayControls(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:PropertyChangeEvent = null;
         if(this._overlayControls != param1)
         {
            _loc2_ = this._overlayControls;
            this._overlayControls = param1;
            if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"overlayControls",_loc2_,this._overlayControls);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      public function get destructionPolicy() : String
      {
         return this._destructionPolicy;
      }
      
      public function set destructionPolicy(param1:String) : void
      {
         this._destructionPolicy = param1;
      }
      
      [Bindable("navigatorChanged")]
      public function get navigator() : ViewNavigator
      {
         return this._navigator;
      }
      
      mx_internal function setNavigator(param1:ViewNavigator) : void
      {
         this._navigator = param1;
         if(hasEventListener("navigatorChanged"))
         {
            dispatchEvent(new Event("navigatorChanged"));
         }
      }
      
      public function get actionBarVisible() : Boolean
      {
         return this._actionBarVisible;
      }
      
      public function set actionBarVisible(param1:Boolean) : void
      {
         this._actionBarVisible = param1;
         if(this.isActive && this.navigator)
         {
            if(this._actionBarVisible)
            {
               this.navigator.showActionBar();
            }
            else
            {
               this.navigator.hideActionBar();
            }
         }
      }
      
      mx_internal function setActionBarVisible(param1:Boolean) : void
      {
         this._actionBarVisible = param1;
      }
      
      public function get actionContent() : Array
      {
         return this._actionContent;
      }
      
      public function set actionContent(param1:Array) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:Array = this._actionContent;
         this._actionContent = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"actionContent",_loc2_,this._actionContent);
            dispatchEvent(_loc3_);
         }
      }
      
      public function get actionLayout() : LayoutBase
      {
         return this._actionLayout;
      }
      
      public function set actionLayout(param1:LayoutBase) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:LayoutBase = param1;
         this._actionLayout = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"actionLayout",_loc2_,this._actionLayout);
            dispatchEvent(_loc3_);
         }
      }
      
      public function get viewMenuItems() : Vector.<ViewMenuItem>
      {
         return this._viewMenuItems;
      }
      
      public function set viewMenuItems(param1:Vector.<ViewMenuItem>) : void
      {
         this._viewMenuItems = param1;
      }
      
      public function get navigationContent() : Array
      {
         return this._navigationContent;
      }
      
      public function set navigationContent(param1:Array) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:Array = this._navigationContent;
         this._navigationContent = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"navigationContent",_loc2_,this._navigationContent);
            dispatchEvent(_loc3_);
         }
      }
      
      public function get navigationLayout() : LayoutBase
      {
         return this._navigationLayout;
      }
      
      public function set navigationLayout(param1:LayoutBase) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:LayoutBase = this._navigationLayout;
         this._navigationLayout = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"navigationLayout",this._navigationLayout,param1);
            dispatchEvent(_loc3_);
         }
      }
      
      public function get tabBarVisible() : Boolean
      {
         return this._tabBarVisible;
      }
      
      public function set tabBarVisible(param1:Boolean) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:Boolean = this._tabBarVisible;
         this._tabBarVisible = param1;
         if(this.isActive && this.navigator)
         {
            if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"tabBarVisible",_loc2_,param1);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      mx_internal function setTabBarVisible(param1:Boolean) : void
      {
         this._tabBarVisible = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._title;
      }
      
      private function set _110371416title(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:PropertyChangeEvent = null;
         if(this._title != param1)
         {
            _loc2_ = this._title;
            this._title = param1;
            if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,this._title);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      public function get titleContent() : Array
      {
         return this._titleContent;
      }
      
      public function set titleContent(param1:Array) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:Array = this._titleContent;
         this._titleContent = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"titleContent",_loc2_,this._titleContent);
            dispatchEvent(_loc3_);
         }
      }
      
      public function get titleLayout() : LayoutBase
      {
         return this._titleLayout;
      }
      
      public function set titleLayout(param1:LayoutBase) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:LayoutBase = this._titleLayout;
         this._titleLayout = param1;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"titleLayout",_loc2_,this._titleLayout);
            dispatchEvent(_loc3_);
         }
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         if(hasEventListener(FlexEvent.DATA_CHANGE))
         {
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         }
      }
      
      public function createReturnObject() : Object
      {
         return null;
      }
      
      public function getCurrentViewState() : String
      {
         var _loc1_:String = FlexGlobals.topLevelApplication.aspectRatio;
         if(hasState(_loc1_))
         {
            return _loc1_;
         }
         return currentState;
      }
      
      private function application_resizeHandler(param1:Event) : void
      {
         if(this.isActive)
         {
            this.updateOrientationState();
         }
      }
      
      mx_internal function updateOrientationState() : void
      {
         setCurrentState(this.getCurrentViewState(),false);
      }
      
      override public function initialize() : void
      {
         super.initialize();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
      }
      
      private function creationCompleteHandler(param1:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
         FlexGlobals.topLevelApplication.addEventListener(ResizeEvent.RESIZE,this.application_resizeHandler,false,0,true);
         this.updateOrientationState();
      }
      
      public function serializeData() : Object
      {
         return this.data;
      }
      
      public function deserializeData(param1:Object) : Object
      {
         return param1;
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
