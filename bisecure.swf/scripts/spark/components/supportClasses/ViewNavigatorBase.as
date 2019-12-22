package spark.components.supportClasses
{
   import flash.display.Stage;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexGlobals;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import spark.components.SkinnableContainer;
   import spark.components.View;
   import spark.utils.MultiDPIBitmapSource;
   import spark.utils.PlatformMobileHelper;
   
   use namespace mx_internal;
   
   public class ViewNavigatorBase extends SkinnableContainer
   {
      
      private static const __includeClasses:Array = [PlatformMobileHelper];
       
      
      mx_internal var disableNextControlAnimation:Boolean = false;
      
      private var _active:Boolean = true;
      
      private var _icon:Object;
      
      private var _label:String = "";
      
      private var _lastAction:String = "none";
      
      protected var _navigationStack:NavigationStack;
      
      private var _overlayControls:Boolean = false;
      
      private var _parentNavigator:ViewNavigatorBase;
      
      private var _transitionsEnabled:Boolean = true;
      
      public function ViewNavigatorBase()
      {
         super();
         this._navigationStack = new NavigationStack();
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      mx_internal function setActive(param1:Boolean, param2:Boolean = false) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
         }
      }
      
      public function get activeView() : View
      {
         return null;
      }
      
      mx_internal function get exitApplicationOnBackKey() : Boolean
      {
         return true;
      }
      
      public function get icon() : Object
      {
         return this._icon;
      }
      
      public function set icon(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PropertyChangeEvent = null;
         if(this._icon != param1)
         {
            _loc2_ = this._icon;
            this._icon = param1;
            if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,this._icon);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : String
      {
         return this._label;
      }
      
      private function set _102727412label(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:PropertyChangeEvent = null;
         if(this._label != param1)
         {
            _loc2_ = this._label;
            this._label = param1;
            if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
               _loc3_ = PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,this._label);
               dispatchEvent(_loc3_);
            }
         }
      }
      
      mx_internal function get lastAction() : String
      {
         return this._lastAction;
      }
      
      mx_internal function set lastAction(param1:String) : void
      {
         this._lastAction = param1;
      }
      
      mx_internal function get navigationStack() : NavigationStack
      {
         return this._navigationStack;
      }
      
      mx_internal function set navigationStack(param1:NavigationStack) : void
      {
         if(param1 == null)
         {
            this._navigationStack = new NavigationStack();
         }
         else
         {
            this._navigationStack = param1;
         }
      }
      
      mx_internal function get overlayControls() : Boolean
      {
         return this._overlayControls;
      }
      
      mx_internal function set overlayControls(param1:Boolean) : void
      {
         if(param1 != this._overlayControls)
         {
            this._overlayControls = param1;
            invalidateSkinState();
            if(skin)
            {
               skin.invalidateSize();
               skin.invalidateDisplayList();
            }
         }
      }
      
      public function get parentNavigator() : ViewNavigatorBase
      {
         return this._parentNavigator;
      }
      
      mx_internal function setParentNavigator(param1:ViewNavigatorBase) : void
      {
         this._parentNavigator = param1;
      }
      
      public function get transitionsEnabled() : Boolean
      {
         return this._transitionsEnabled;
      }
      
      public function set transitionsEnabled(param1:Boolean) : void
      {
         this._transitionsEnabled = param1;
      }
      
      public function backKeyUpHandler() : void
      {
      }
      
      public function saveViewData() : Object
      {
         var _loc1_:Object = this.icon;
         if(_loc1_ is Class)
         {
            return {
               "label":this.label,
               "iconClassName":getQualifiedClassName(_loc1_),
               "multiSource":_loc1_ is MultiDPIBitmapSource
            };
         }
         if(_loc1_ is String)
         {
            return {
               "label":this.label,
               "iconStringName":_loc1_
            };
         }
         return {"label":this.label};
      }
      
      public function loadViewData(param1:Object) : void
      {
         var _loc2_:String = null;
         this.label = param1.label;
         if("iconClassName" in param1)
         {
            _loc2_ = param1.iconClassName;
            if(param1.multiSource)
            {
               this.icon = MultiDPIBitmapSource(getDefinitionByName(_loc2_)).getMultiSource();
            }
            else
            {
               this.icon = getDefinitionByName(_loc2_);
            }
         }
         else if("iconStringName" in param1)
         {
            this.icon = param1.iconStringName;
         }
      }
      
      public function updateControlsForView(param1:View) : void
      {
         if(this.parentNavigator)
         {
            this.parentNavigator.updateControlsForView(param1);
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         var _loc1_:* = FlexGlobals.topLevelApplication.aspectRatio;
         if(this._overlayControls)
         {
            _loc1_ = _loc1_ + "AndOverlay";
         }
         return _loc1_;
      }
      
      mx_internal function canRemoveCurrentView() : Boolean
      {
         return true;
      }
      
      mx_internal function captureAnimationValues(param1:UIComponent) : Object
      {
         var _loc2_:Object = {
            "x":param1.x,
            "y":param1.y,
            "width":param1.width,
            "height":param1.height,
            "explicitWidth":param1.explicitWidth,
            "explicitHeight":param1.explicitHeight,
            "percentWidth":param1.percentWidth,
            "percentHeight":param1.percentHeight,
            "visible":param1.visible,
            "includeInLayout":param1.includeInLayout,
            "cacheAsBitmap":param1.cacheAsBitmap
         };
         return _loc2_;
      }
      
      mx_internal function createTopView() : void
      {
      }
      
      private function creationCompleteHandler(param1:FlexEvent) : void
      {
         removeEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
         FlexGlobals.topLevelApplication.addEventListener(ResizeEvent.RESIZE,this.stage_resizeHandler,false,0,true);
      }
      
      mx_internal function updateFocus() : void
      {
         var _loc1_:Stage = systemManager.stage;
         if(!_loc1_.focus || !_loc1_.focus.stage || _loc1_.focus == this)
         {
            if(this.activeView)
            {
               _loc1_.focus = this.activeView;
            }
            else
            {
               _loc1_.focus = this;
            }
         }
      }
      
      mx_internal function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.disableNextControlAnimation = true;
         invalidateSkinState();
      }
      
      override protected function attachSkin() : void
      {
         super.attachSkin();
         this.updateControlsForView(this.activeView);
      }
      
      override public function initialize() : void
      {
         super.initialize();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this.label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
            }
         }
      }
   }
}
