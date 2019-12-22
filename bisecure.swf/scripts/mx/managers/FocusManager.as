package mx.managers
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.core.FlexSprite;
   import mx.core.IButton;
   import mx.core.IChildList;
   import mx.core.IIMESupport;
   import mx.core.IRawChildrenContainer;
   import mx.core.ISWFLoader;
   import mx.core.IToggleButton;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.utils.Platform;
   
   use namespace mx_internal;
   
   public class FocusManager extends EventDispatcher implements IFocusManager
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static const FROM_INDEX_UNSPECIFIED:int = -2;
      
      public static var mixins:Array;
      
      mx_internal static var ieshifttab:Boolean = true;
       
      
      private var LARGE_TAB_INDEX:int = 99999;
      
      mx_internal var calculateCandidates:Boolean = true;
      
      mx_internal var popup:Boolean;
      
      mx_internal var IMEEnabled:Boolean;
      
      mx_internal var lastAction:String;
      
      public var browserMode:Boolean;
      
      public var desktopMode:Boolean;
      
      private var browserFocusComponent:InteractiveObject;
      
      mx_internal var focusableObjects:Array;
      
      private var focusableCandidates:Array;
      
      private var activated:Boolean;
      
      private var windowActivated:Boolean;
      
      mx_internal var focusChanged:Boolean;
      
      mx_internal var fauxFocus:DisplayObject;
      
      mx_internal var _showFocusIndicator:Boolean = false;
      
      private var defButton:IButton;
      
      private var _defaultButton:IButton;
      
      private var _defaultButtonEnabled:Boolean = true;
      
      private var _focusPane:Sprite;
      
      private var _form:IFocusManagerContainer;
      
      private var _lastFocus:IFocusManagerComponent;
      
      public function FocusManager(param1:IFocusManagerContainer, param2:Boolean = false)
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IActiveWindowManager = null;
         super();
         this.popup = param2;
         this.IMEEnabled = true;
         this.browserMode = Capabilities.playerType == "ActiveX" && !param2;
         this.desktopMode = Platform.isAir && !param2;
         this.windowActivated = !this.desktopMode;
         param1.focusManager = this;
         this._form = param1;
         this.focusableObjects = [];
         this.focusPane = new FlexSprite();
         this.focusPane.name = "focusPane";
         this.addFocusables(DisplayObject(param1));
         param1.addEventListener(Event.ADDED,this.addedHandler);
         param1.addEventListener(Event.REMOVED,this.removedHandler);
         param1.addEventListener(FlexEvent.SHOW,this.showHandler);
         param1.addEventListener(FlexEvent.HIDE,this.hideHandler);
         param1.addEventListener(FlexEvent.HIDE,this.childHideHandler,true);
         param1.addEventListener("_navigationChange_",this.viewHideHandler,true);
         if(param1.systemManager is SystemManager)
         {
            if(param1 != SystemManager(param1.systemManager).application)
            {
               param1.addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
            }
         }
         if(mixins)
         {
            _loc3_ = mixins.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               new mixins[_loc4_](this);
               _loc4_++;
            }
         }
         try
         {
            _loc5_ = IActiveWindowManager(param1.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
            if(_loc5_)
            {
               _loc5_.addFocusManager(param1);
            }
            if(hasEventListener("initialize"))
            {
               dispatchEvent(new Event("initialize"));
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function get showFocusIndicator() : Boolean
      {
         return this._showFocusIndicator;
      }
      
      public function set showFocusIndicator(param1:Boolean) : void
      {
         var _loc2_:* = this._showFocusIndicator != param1;
         this._showFocusIndicator = param1;
         if(hasEventListener("showFocusIndicator"))
         {
            dispatchEvent(new Event("showFocusIndicator"));
         }
      }
      
      public function get defaultButton() : IButton
      {
         return this._defaultButton;
      }
      
      public function set defaultButton(param1:IButton) : void
      {
         var _loc2_:IButton = !!param1?IButton(param1):null;
         if(_loc2_ != this._defaultButton)
         {
            if(this._defaultButton)
            {
               this._defaultButton.emphasized = false;
            }
            if(this.defButton)
            {
               this.defButton.emphasized = false;
            }
            this._defaultButton = _loc2_;
            if(this.defButton != this._lastFocus || this._lastFocus == this._defaultButton)
            {
               this.defButton = _loc2_;
               if(_loc2_)
               {
                  _loc2_.emphasized = true;
               }
            }
         }
      }
      
      public function get defaultButtonEnabled() : Boolean
      {
         return this._defaultButtonEnabled;
      }
      
      public function set defaultButtonEnabled(param1:Boolean) : void
      {
         this._defaultButtonEnabled = param1;
         if(this.defButton)
         {
            this.defButton.emphasized = param1;
         }
      }
      
      public function get focusPane() : Sprite
      {
         return this._focusPane;
      }
      
      public function set focusPane(param1:Sprite) : void
      {
         this._focusPane = param1;
      }
      
      mx_internal function get form() : IFocusManagerContainer
      {
         return this._form;
      }
      
      mx_internal function set form(param1:IFocusManagerContainer) : void
      {
         this._form = param1;
      }
      
      mx_internal function get lastFocus() : IFocusManagerComponent
      {
         return this._lastFocus;
      }
      
      mx_internal function set lastFocus(param1:IFocusManagerComponent) : void
      {
         this._lastFocus = param1;
      }
      
      public function get nextTabIndex() : int
      {
         return this.getMaxTabIndex() + 1;
      }
      
      private function getMaxTabIndex() : int
      {
         var _loc4_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:int = this.focusableObjects.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.focusableObjects[_loc3_].tabIndex;
            if(!isNaN(_loc4_))
            {
               _loc1_ = Math.max(_loc1_,_loc4_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getFocus() : IFocusManagerComponent
      {
         var _loc1_:Stage = this.form.systemManager.stage;
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:InteractiveObject = _loc1_.focus;
         if(!_loc2_ && this._lastFocus || _loc2_ is TextField && _loc2_.parent == _loc1_)
         {
            return this._lastFocus;
         }
         return this.findFocusManagerComponent(_loc2_);
      }
      
      public function setFocus(param1:IFocusManagerComponent) : void
      {
         param1.setFocus();
         if(hasEventListener("setFocus"))
         {
            dispatchEvent(new Event("setFocus"));
         }
      }
      
      private function focusInHandler(param1:FocusEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:IIMESupport = null;
         var _loc2_:InteractiveObject = InteractiveObject(param1.target);
         if(hasEventListener(FocusEvent.FOCUS_IN))
         {
            if(!dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN,false,true,_loc2_)))
            {
               return;
            }
         }
         if(this.isParent(DisplayObjectContainer(this.form),_loc2_))
         {
            if(this._defaultButton)
            {
               if(_loc2_ is IButton && _loc2_ != this._defaultButton && !(_loc2_ is IToggleButton))
               {
                  this._defaultButton.emphasized = false;
               }
               else if(this._defaultButtonEnabled)
               {
                  this._defaultButton.emphasized = true;
               }
            }
            this._lastFocus = this.findFocusManagerComponent(InteractiveObject(_loc2_));
            if(Capabilities.hasIME)
            {
               if(this._lastFocus is IIMESupport)
               {
                  _loc4_ = IIMESupport(this._lastFocus);
                  if(_loc4_.enableIME)
                  {
                     _loc3_ = true;
                  }
               }
               if(this.IMEEnabled)
               {
                  IME.enabled = _loc3_;
               }
            }
            if(this._lastFocus is IButton && !(this._lastFocus is IToggleButton))
            {
               this.defButton = this._lastFocus as IButton;
            }
            else if(this.defButton && this.defButton != this._defaultButton)
            {
               this.defButton = this._defaultButton;
            }
         }
      }
      
      private function focusOutHandler(param1:FocusEvent) : void
      {
         var _loc2_:InteractiveObject = InteractiveObject(param1.target);
      }
      
      private function activateHandler(param1:Event) : void
      {
         if(this.activated && !this.desktopMode)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
            if(this._lastFocus && (!this.browserMode || ieshifttab))
            {
               this._lastFocus.setFocus();
            }
            this.lastAction = "ACTIVATE";
         }
      }
      
      private function deactivateHandler(param1:Event) : void
      {
         if(this.activated && !this.desktopMode)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
         }
      }
      
      private function activateWindowHandler(param1:Event) : void
      {
         this.windowActivated = true;
         if(this.activated)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
            if(this._lastFocus && !this.browserMode)
            {
               this._lastFocus.setFocus();
            }
            this.lastAction = "ACTIVATE";
         }
      }
      
      private function deactivateWindowHandler(param1:Event) : void
      {
         this.windowActivated = false;
         if(this.activated)
         {
            dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
            if(this.form.systemManager.stage)
            {
               this.form.systemManager.stage.focus = null;
            }
         }
      }
      
      public function showFocus() : void
      {
         if(!this.showFocusIndicator)
         {
            this.showFocusIndicator = true;
            if(this._lastFocus)
            {
               this._lastFocus.drawFocus(true);
            }
         }
      }
      
      public function hideFocus() : void
      {
         if(this.showFocusIndicator)
         {
            this.showFocusIndicator = false;
            if(this._lastFocus)
            {
               this._lastFocus.drawFocus(false);
            }
         }
      }
      
      public function activate() : void
      {
         if(this.activated)
         {
            return;
         }
         var _loc1_:ISystemManager = this.form.systemManager;
         if(_loc1_)
         {
            if(_loc1_.isTopLevelRoot())
            {
               _loc1_.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
               _loc1_.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
               _loc1_.stage.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
               _loc1_.stage.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
            }
            else
            {
               _loc1_.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler,false,0,true);
               _loc1_.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler,false,0,true);
               _loc1_.addEventListener(Event.ACTIVATE,this.activateHandler,false,0,true);
               _loc1_.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
            }
         }
         this.form.addEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownCaptureHandler,true);
         this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.defaultButtonKeyHandler);
         this.form.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         if(_loc1_)
         {
            _loc1_.addEventListener("windowActivate",this.activateWindowHandler,true,0,true);
            _loc1_.addEventListener("windowDeactivate",this.deactivateWindowHandler,true,0,true);
         }
         this.activated = true;
         dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_ACTIVATE));
         if(this._lastFocus)
         {
            this.setFocus(this._lastFocus);
         }
         if(hasEventListener("activateFM"))
         {
            dispatchEvent(new Event("activateFM"));
         }
      }
      
      public function deactivate() : void
      {
         var _loc1_:ISystemManager = this.form.systemManager;
         if(_loc1_)
         {
            if(_loc1_.isTopLevelRoot())
            {
               _loc1_.stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
               _loc1_.stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
               _loc1_.stage.removeEventListener(Event.ACTIVATE,this.activateHandler);
               _loc1_.stage.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
            }
            else
            {
               _loc1_.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.mouseFocusChangeHandler);
               _loc1_.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
               _loc1_.removeEventListener(Event.ACTIVATE,this.activateHandler);
               _loc1_.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
            }
         }
         this.form.removeEventListener(FocusEvent.FOCUS_IN,this.focusInHandler,true);
         this.form.removeEventListener(FocusEvent.FOCUS_OUT,this.focusOutHandler,true);
         this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         this.form.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownCaptureHandler,true);
         this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.defaultButtonKeyHandler);
         this.form.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler,true);
         this.activated = false;
         dispatchEvent(new FlexEvent(FlexEvent.FLEX_WINDOW_DEACTIVATE));
         if(hasEventListener("deactivateFM"))
         {
            dispatchEvent(new Event("deactivateFM"));
         }
      }
      
      public function findFocusManagerComponent(param1:InteractiveObject) : IFocusManagerComponent
      {
         return this.findFocusManagerComponent2(param1) as IFocusManagerComponent;
      }
      
      private function findFocusManagerComponent2(param1:InteractiveObject) : DisplayObject
      {
         try
         {
            while(param1)
            {
               if(param1 is IFocusManagerComponent && IFocusManagerComponent(param1).focusEnabled || param1 is ISWFLoader)
               {
                  return param1;
               }
               param1 = param1.parent;
            }
         }
         catch(error:SecurityError)
         {
         }
         return null;
      }
      
      private function isParent(param1:DisplayObjectContainer, param2:DisplayObject) : Boolean
      {
         if(param1 == param2)
         {
            return false;
         }
         if(param1 is IRawChildrenContainer)
         {
            return IRawChildrenContainer(param1).rawChildren.contains(param2);
         }
         return param1.contains(param2);
      }
      
      private function isEnabledAndVisible(param1:DisplayObject) : Boolean
      {
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(this.form);
         while(param1 != _loc2_)
         {
            if(param1 is IUIComponent)
            {
               if(!IUIComponent(param1).enabled)
               {
                  return false;
               }
            }
            if(param1 is IVisualElement)
            {
               if(IVisualElement(param1).designLayer && !IVisualElement(param1).designLayer.effectiveVisibility)
               {
                  return false;
               }
            }
            if(!param1.visible)
            {
               return false;
            }
            param1 = param1.parent;
            if(!param1)
            {
               return false;
            }
         }
         return true;
      }
      
      private function sortByTabIndex(param1:InteractiveObject, param2:InteractiveObject) : int
      {
         var _loc3_:int = param1.tabIndex;
         var _loc4_:int = param2.tabIndex;
         if(_loc3_ == -1)
         {
            _loc3_ = int.MAX_VALUE;
         }
         if(_loc4_ == -1)
         {
            _loc4_ = int.MAX_VALUE;
         }
         return _loc3_ > _loc4_?1:_loc3_ < _loc4_?-1:int(this.sortByDepth(DisplayObject(param1),DisplayObject(param2)));
      }
      
      private function sortFocusableObjectsTabIndex() : void
      {
         var _loc3_:IFocusManagerComponent = null;
         this.focusableCandidates = [];
         var _loc1_:int = this.focusableObjects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.focusableObjects[_loc2_] as IFocusManagerComponent;
            if(_loc3_ && _loc3_.tabIndex && !isNaN(Number(_loc3_.tabIndex)) || this.focusableObjects[_loc2_] is ISWFLoader)
            {
               this.focusableCandidates.push(this.focusableObjects[_loc2_]);
            }
            _loc2_++;
         }
         this.focusableCandidates.sort(this.sortByTabIndex);
      }
      
      private function sortByDepth(param1:DisplayObject, param2:DisplayObject) : Number
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc8_:String = "0000";
         var _loc9_:DisplayObject = DisplayObject(param1);
         var _loc10_:DisplayObject = DisplayObject(param2);
         while(_loc9_ != DisplayObject(this.form) && _loc9_.parent)
         {
            _loc5_ = this.getChildIndex(_loc9_.parent,_loc9_);
            _loc6_ = _loc5_.toString(16);
            if(_loc6_.length < 4)
            {
               _loc7_ = _loc8_.substring(0,4 - _loc6_.length) + _loc6_;
            }
            _loc3_ = _loc7_ + _loc3_;
            _loc9_ = _loc9_.parent;
         }
         while(_loc10_ != DisplayObject(this.form) && _loc10_.parent)
         {
            _loc5_ = this.getChildIndex(_loc10_.parent,_loc10_);
            _loc6_ = _loc5_.toString(16);
            if(_loc6_.length < 4)
            {
               _loc7_ = _loc8_.substring(0,4 - _loc6_.length) + _loc6_;
            }
            _loc4_ = _loc7_ + _loc4_;
            _loc10_ = _loc10_.parent;
         }
         return _loc3_ > _loc4_?Number(1):_loc3_ < _loc4_?Number(-1):Number(0);
      }
      
      private function getChildIndex(param1:DisplayObjectContainer, param2:DisplayObject) : int
      {
         var parent:DisplayObjectContainer = param1;
         var child:DisplayObject = param2;
         try
         {
            return parent.getChildIndex(child);
         }
         catch(e:Error)
         {
            if(parent is IRawChildrenContainer)
            {
               return IRawChildrenContainer(parent).rawChildren.getChildIndex(child);
            }
            throw e;
         }
         throw new Error("FocusManager.getChildIndex failed");
      }
      
      private function sortFocusableObjects() : void
      {
         var _loc3_:InteractiveObject = null;
         this.focusableCandidates = [];
         var _loc1_:int = this.focusableObjects.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.focusableObjects[_loc2_];
            if(_loc3_.tabIndex && !isNaN(Number(_loc3_.tabIndex)) && _loc3_.tabIndex > 0)
            {
               this.sortFocusableObjectsTabIndex();
               return;
            }
            this.focusableCandidates.push(_loc3_);
            _loc2_++;
         }
         this.focusableCandidates.sort(this.sortByDepth);
      }
      
      mx_internal function sendDefaultButtonEvent() : void
      {
         this.defButton.dispatchEvent(new MouseEvent("click"));
      }
      
      mx_internal function addFocusables(param1:DisplayObject, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:IFocusManagerComponent = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:Boolean = false;
         var _loc7_:IChildList = null;
         var _loc8_:int = 0;
         if(param1 is IFocusManagerComponent && !param2)
         {
            _loc3_ = false;
            if(param1 is IFocusManagerComponent)
            {
               _loc4_ = IFocusManagerComponent(param1);
               if(_loc4_.focusEnabled)
               {
                  if(_loc4_.tabFocusEnabled && this.isTabVisible(param1))
                  {
                     _loc3_ = true;
                  }
               }
            }
            if(_loc3_)
            {
               if(this.focusableObjects.indexOf(param1) == -1)
               {
                  this.focusableObjects.push(param1);
                  this.calculateCandidates = true;
               }
            }
            param1.addEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
            param1.addEventListener("tabIndexChange",this.tabIndexChangeHandler);
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc5_ = DisplayObjectContainer(param1);
            if(param1 is IFocusManagerComponent)
            {
               param1.addEventListener("hasFocusableChildrenChange",this.hasFocusableChildrenChangeHandler);
               _loc6_ = IFocusManagerComponent(param1).hasFocusableChildren;
            }
            else
            {
               param1.addEventListener("tabChildrenChange",this.tabChildrenChangeHandler);
               _loc6_ = _loc5_.tabChildren;
            }
            if(_loc6_)
            {
               if(param1 is IRawChildrenContainer)
               {
                  _loc7_ = IRawChildrenContainer(param1).rawChildren;
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.numChildren)
                  {
                     try
                     {
                        this.addFocusables(_loc7_.getChildAt(_loc8_));
                     }
                     catch(error:SecurityError)
                     {
                     }
                     _loc8_++;
                  }
               }
               else
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_.numChildren)
                  {
                     try
                     {
                        this.addFocusables(_loc5_.getChildAt(_loc8_));
                     }
                     catch(error:SecurityError)
                     {
                     }
                     _loc8_++;
                  }
               }
            }
         }
      }
      
      private function isTabVisible(param1:DisplayObject) : Boolean
      {
         var _loc2_:DisplayObject = DisplayObject(this.form.systemManager);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:DisplayObjectContainer = param1.parent;
         while(_loc3_ && _loc3_ != _loc2_)
         {
            if(!_loc3_.tabChildren)
            {
               return false;
            }
            if(_loc3_ is IFocusManagerComponent && !IFocusManagerComponent(_loc3_).hasFocusableChildren)
            {
               return false;
            }
            _loc3_ = _loc3_.parent;
         }
         return true;
      }
      
      private function isValidFocusCandidate(param1:DisplayObject, param2:String) : Boolean
      {
         var _loc3_:IFocusManagerGroup = null;
         if(param1 is IFocusManagerComponent)
         {
            if(!IFocusManagerComponent(param1).focusEnabled)
            {
               return false;
            }
         }
         if(!this.isEnabledAndVisible(param1))
         {
            return false;
         }
         if(param1 is IFocusManagerGroup)
         {
            _loc3_ = IFocusManagerGroup(param1);
            if(param2 == _loc3_.groupName)
            {
               return false;
            }
         }
         return true;
      }
      
      private function getIndexOfFocusedObject(param1:DisplayObject) : int
      {
         var _loc4_:IUIComponent = null;
         if(!param1)
         {
            return -1;
         }
         var _loc2_:int = this.focusableCandidates.length;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.focusableCandidates[_loc3_] == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.focusableCandidates[_loc3_] as IUIComponent;
            if(_loc4_ && _loc4_.owns(param1))
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function getIndexOfNextObject(param1:int, param2:Boolean, param3:Boolean, param4:String) : int
      {
         var _loc7_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc10_:IFocusManagerGroup = null;
         var _loc11_:IFocusManagerGroup = null;
         var _loc12_:IFocusManagerGroup = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc5_:int = this.focusableCandidates.length;
         var _loc6_:int = param1;
         while(true)
         {
            if(param2)
            {
               param1--;
            }
            else
            {
               param1++;
            }
            if(param3)
            {
               if(param2 && param1 < 0)
               {
                  break;
               }
               if(!param2 && param1 == _loc5_)
               {
                  break;
               }
            }
            else
            {
               param1 = (param1 + _loc5_) % _loc5_;
               if(_loc6_ == param1)
               {
                  break;
               }
               if(_loc6_ == -1)
               {
                  _loc6_ = param1;
               }
            }
            if(this.isValidFocusCandidate(this.focusableCandidates[param1],param4))
            {
               _loc7_ = DisplayObject(this.findFocusManagerComponent2(this.focusableCandidates[param1]));
               if(_loc7_ is IFocusManagerGroup)
               {
                  _loc10_ = IFocusManagerGroup(_loc7_);
                  _loc12_ = null;
                  _loc8_ = 0;
                  while(_loc8_ < this.focusableCandidates.length)
                  {
                     _loc9_ = this.focusableCandidates[_loc8_];
                     if(_loc9_ is IFocusManagerGroup)
                     {
                        _loc11_ = IFocusManagerGroup(_loc9_);
                        if(_loc11_.groupName == _loc10_.groupName && this.isEnabledAndVisible(_loc9_) && _loc11_["document"] == _loc10_["document"])
                        {
                           if(_loc11_.selected)
                           {
                              _loc12_ = _loc11_;
                              break;
                           }
                           if(!param2 && _loc12_ == null || param2)
                           {
                              _loc12_ = _loc11_;
                           }
                        }
                     }
                     _loc8_++;
                  }
                  if(_loc10_ != _loc12_)
                  {
                     _loc13_ = false;
                     _loc8_ = param1;
                     _loc14_ = 0;
                     while(_loc14_ < this.focusableCandidates.length - 1)
                     {
                        if(!param2)
                        {
                           _loc8_++;
                           if(_loc8_ == this.focusableCandidates.length)
                           {
                              _loc8_ = 0;
                           }
                        }
                        else
                        {
                           _loc8_--;
                           if(_loc8_ == -1)
                           {
                              _loc8_ = this.focusableCandidates.length - 1;
                           }
                        }
                        _loc9_ = this.focusableCandidates[_loc8_];
                        if(this.isEnabledAndVisible(_loc9_))
                        {
                           if(_loc13_)
                           {
                              if(_loc9_ is IFocusManagerGroup)
                              {
                                 _loc11_ = IFocusManagerGroup(_loc9_);
                                 if(_loc11_.groupName == _loc10_.groupName && _loc11_["document"] == _loc10_["document"])
                                 {
                                    if(_loc11_.selected)
                                    {
                                       param1 = _loc8_;
                                       break;
                                    }
                                 }
                              }
                           }
                           else if(_loc9_ is IFocusManagerGroup)
                           {
                              _loc11_ = IFocusManagerGroup(_loc9_);
                              if(_loc11_.groupName == _loc10_.groupName && _loc11_["document"] == _loc10_["document"])
                              {
                                 if(_loc11_ == _loc12_)
                                 {
                                    if(InteractiveObject(_loc9_).tabIndex != InteractiveObject(_loc7_).tabIndex && !_loc10_.selected)
                                    {
                                       return this.getIndexOfNextObject(param1,param2,param3,param4);
                                    }
                                    param1 = _loc8_;
                                    break;
                                 }
                              }
                              else
                              {
                                 _loc10_ = _loc11_;
                                 param1 = _loc8_;
                                 if(_loc11_.selected)
                                 {
                                    break;
                                 }
                                 _loc13_ = true;
                              }
                           }
                           else
                           {
                              param1 = _loc8_;
                              break;
                           }
                        }
                        _loc14_++;
                     }
                  }
               }
               return param1;
            }
         }
         return param1;
      }
      
      private function setFocusToNextObject(param1:FocusEvent) : void
      {
         this.focusChanged = false;
         if(this.focusableObjects.length == 0)
         {
            return;
         }
         var _loc2_:FocusInfo = this.getNextFocusManagerComponent2(param1.shiftKey,this.fauxFocus);
         if(!this.popup && (_loc2_.wrapped || !_loc2_.displayObject))
         {
            if(hasEventListener("focusWrapping"))
            {
               if(!dispatchEvent(new FocusEvent("focusWrapping",false,true,null,param1.shiftKey)))
               {
                  return;
               }
            }
         }
         if(!_loc2_.displayObject)
         {
            param1.preventDefault();
            return;
         }
         this.setFocusToComponent(_loc2_.displayObject,param1.shiftKey);
      }
      
      private function setFocusToComponent(param1:Object, param2:Boolean) : void
      {
         this.focusChanged = false;
         if(param1)
         {
            if(hasEventListener("setFocusToComponent"))
            {
               if(!dispatchEvent(new FocusEvent("setFocusToComponent",false,true,InteractiveObject(param1),param2)))
               {
                  return;
               }
            }
            if(param1 is IFocusManagerComplexComponent)
            {
               IFocusManagerComplexComponent(param1).assignFocus(!!param2?"bottom":"top");
               this.focusChanged = true;
            }
            else if(param1 is IFocusManagerComponent)
            {
               this.setFocus(IFocusManagerComponent(param1));
               this.focusChanged = true;
            }
         }
      }
      
      mx_internal function setFocusToNextIndex(param1:int, param2:Boolean) : void
      {
         if(this.focusableObjects.length == 0)
         {
            return;
         }
         if(this.calculateCandidates)
         {
            this.sortFocusableObjects();
            this.calculateCandidates = false;
         }
         var _loc3_:FocusInfo = this.getNextFocusManagerComponent2(param2,null,param1);
         if(!this.popup && _loc3_.wrapped)
         {
            if(hasEventListener("setFocusToNextIndex"))
            {
               if(!dispatchEvent(new FocusEvent("setFocusToNextIndex",false,true,null,param2)))
               {
                  return;
               }
            }
         }
         this.setFocusToComponent(_loc3_.displayObject,param2);
      }
      
      public function getNextFocusManagerComponent(param1:Boolean = false) : IFocusManagerComponent
      {
         var _loc2_:FocusInfo = this.getNextFocusManagerComponent2(param1,this.fauxFocus);
         return !!_loc2_?_loc2_.displayObject as IFocusManagerComponent:null;
      }
      
      private function getNextFocusManagerComponent2(param1:Boolean = false, param2:DisplayObject = null, param3:int = -2) : FocusInfo
      {
         var _loc10_:DisplayObject = null;
         var _loc11_:String = null;
         var _loc12_:IFocusManagerGroup = null;
         if(this.focusableObjects.length == 0)
         {
            return null;
         }
         if(this.calculateCandidates)
         {
            this.sortFocusableObjects();
            this.calculateCandidates = false;
         }
         var _loc4_:int = param3;
         if(param3 == FROM_INDEX_UNSPECIFIED)
         {
            _loc10_ = param2;
            if(!_loc10_)
            {
               _loc10_ = this.form.systemManager.stage.focus;
            }
            else if(_loc10_ == this.form.systemManager.stage)
            {
               _loc10_ == null;
            }
            _loc10_ = DisplayObject(this.findFocusManagerComponent2(InteractiveObject(_loc10_)));
            _loc11_ = "";
            if(_loc10_ is IFocusManagerGroup)
            {
               _loc12_ = IFocusManagerGroup(_loc10_);
               _loc11_ = _loc12_.groupName;
            }
            _loc4_ = this.getIndexOfFocusedObject(_loc10_);
         }
         var _loc5_:Boolean = false;
         var _loc6_:int = _loc4_;
         if(_loc4_ == -1)
         {
            if(param1)
            {
               _loc4_ = this.focusableCandidates.length;
            }
            _loc5_ = true;
         }
         var _loc7_:int = this.getIndexOfNextObject(_loc4_,param1,_loc5_,_loc11_);
         var _loc8_:Boolean = false;
         if(param1)
         {
            if(_loc7_ >= _loc4_)
            {
               _loc8_ = true;
            }
         }
         else if(_loc7_ <= _loc4_)
         {
            _loc8_ = true;
         }
         var _loc9_:FocusInfo = new FocusInfo();
         _loc9_.displayObject = this.findFocusManagerComponent2(this.focusableCandidates[_loc7_]);
         _loc9_.wrapped = _loc8_;
         return _loc9_;
      }
      
      private function getTopLevelFocusTarget(param1:InteractiveObject) : InteractiveObject
      {
         while(true)
         {
            if(param1 != InteractiveObject(this.form))
            {
               if(param1 is IFocusManagerComponent && IFocusManagerComponent(param1).focusEnabled && IFocusManagerComponent(param1).mouseFocusEnabled && (param1 is IUIComponent?Boolean(IUIComponent(param1).enabled):Boolean(true)))
               {
                  break;
               }
               if(hasEventListener("getTopLevelFocusTarget"))
               {
                  if(!dispatchEvent(new FocusEvent("getTopLevelFocusTarget",false,true,param1.parent)))
                  {
                     return null;
                  }
               }
               param1 = param1.parent;
               if(param1 != null)
               {
                  continue;
               }
            }
            return null;
         }
         return param1;
      }
      
      override public function toString() : String
      {
         return Object(this.form).toString() + ".focusManager";
      }
      
      private function clearBrowserFocusComponent() : void
      {
         if(this.browserFocusComponent)
         {
            if(this.browserFocusComponent.tabIndex == this.LARGE_TAB_INDEX)
            {
               this.browserFocusComponent.tabIndex = -1;
            }
            this.browserFocusComponent = null;
         }
      }
      
      private function addedHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(_loc2_.stage)
         {
            this.addFocusables(DisplayObject(param1.target));
         }
      }
      
      private function removedHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         var _loc4_:DisplayObject = !!this.focusPane?this.focusPane.parent:null;
         if(_loc4_ && _loc3_ != this.focusPane)
         {
            if(_loc3_ is DisplayObjectContainer && this.isParent(DisplayObjectContainer(_loc3_),this.focusPane))
            {
               if(_loc4_ is ISystemManager)
               {
                  ISystemManager(_loc4_).focusPane = null;
               }
               else
               {
                  IUIComponent(_loc4_).focusPane = null;
               }
            }
         }
         if(_loc3_ is IFocusManagerComponent)
         {
            _loc2_ = 0;
            while(_loc2_ < this.focusableObjects.length)
            {
               if(_loc3_ == this.focusableObjects[_loc2_])
               {
                  if(_loc3_ == this._lastFocus)
                  {
                     this._lastFocus.drawFocus(false);
                     this._lastFocus = null;
                  }
                  this.focusableObjects.splice(_loc2_,1);
                  this.focusableCandidates = [];
                  this.calculateCandidates = true;
                  break;
               }
               _loc2_++;
            }
            _loc3_.removeEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
            _loc3_.removeEventListener("tabIndexChange",this.tabIndexChangeHandler);
         }
         this.removeFocusables(_loc3_,false);
      }
      
      private function removeFocusables(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         if(param1 is DisplayObjectContainer)
         {
            if(!param2)
            {
               param1.removeEventListener("tabChildrenChange",this.tabChildrenChangeHandler);
               param1.removeEventListener("hasFocusableChildrenChange",this.hasFocusableChildrenChangeHandler);
            }
            _loc3_ = 0;
            while(_loc3_ < this.focusableObjects.length)
            {
               if(this.isParent(DisplayObjectContainer(param1),this.focusableObjects[_loc3_]))
               {
                  if(this.focusableObjects[_loc3_] == this._lastFocus)
                  {
                     this._lastFocus.drawFocus(false);
                     this._lastFocus = null;
                  }
                  this.focusableObjects[_loc3_].removeEventListener("tabFocusEnabledChange",this.tabFocusEnabledChangeHandler);
                  this.focusableObjects[_loc3_].removeEventListener("tabIndexChange",this.tabIndexChangeHandler);
                  this.focusableObjects.splice(_loc3_,1);
                  _loc3_--;
                  this.focusableCandidates = [];
                  this.calculateCandidates = true;
               }
               _loc3_++;
            }
         }
      }
      
      private function showHandler(param1:Event) : void
      {
         var _loc2_:IActiveWindowManager = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(_loc2_)
         {
            _loc2_.activate(this.form);
         }
      }
      
      private function hideHandler(param1:Event) : void
      {
         var _loc2_:IActiveWindowManager = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         if(_loc2_)
         {
            _loc2_.deactivate(this.form);
         }
      }
      
      private function childHideHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = DisplayObject(param1.target);
         if(this.lastFocus && !this.isEnabledAndVisible(DisplayObject(this.lastFocus)) && DisplayObject(this.form).stage)
         {
            DisplayObject(this.form).stage.focus = null;
            this.lastFocus = null;
         }
      }
      
      private function viewHideHandler(param1:Event) : void
      {
         var _loc2_:DisplayObjectContainer = param1.target as DisplayObjectContainer;
         var _loc3_:DisplayObject = this.lastFocus as DisplayObject;
         if(_loc2_ && _loc3_ && _loc2_.contains(_loc3_))
         {
            this.lastFocus = null;
         }
      }
      
      private function creationCompleteHandler(param1:FlexEvent) : void
      {
         var _loc3_:IActiveWindowManager = null;
         var _loc2_:DisplayObject = DisplayObject(this.form);
         if(_loc2_.parent && _loc2_.visible && !this.activated)
         {
            _loc3_ = IActiveWindowManager(this.form.systemManager.getImplementation("mx.managers::IActiveWindowManager"));
            if(_loc3_)
            {
               _loc3_.activate(this.form);
            }
         }
      }
      
      private function tabIndexChangeHandler(param1:Event) : void
      {
         this.calculateCandidates = true;
      }
      
      private function tabFocusEnabledChangeHandler(param1:Event) : void
      {
         this.calculateCandidates = true;
         var _loc2_:IFocusManagerComponent = IFocusManagerComponent(param1.target);
         var _loc3_:int = this.focusableObjects.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.focusableObjects[_loc4_] == _loc2_)
            {
               break;
            }
            _loc4_++;
         }
         if(_loc2_.tabFocusEnabled)
         {
            if(_loc4_ == _loc3_ && this.isTabVisible(DisplayObject(_loc2_)))
            {
               if(this.focusableObjects.indexOf(_loc2_) == -1)
               {
                  this.focusableObjects.push(_loc2_);
               }
            }
         }
         else if(_loc4_ < _loc3_)
         {
            this.focusableObjects.splice(_loc4_,1);
         }
      }
      
      private function tabChildrenChangeHandler(param1:Event) : void
      {
         if(param1.target != param1.currentTarget)
         {
            return;
         }
         this.calculateCandidates = true;
         var _loc2_:DisplayObjectContainer = DisplayObjectContainer(param1.target);
         if(_loc2_.tabChildren)
         {
            this.addFocusables(_loc2_,true);
         }
         else
         {
            this.removeFocusables(_loc2_,true);
         }
      }
      
      private function hasFocusableChildrenChangeHandler(param1:Event) : void
      {
         if(param1.target != param1.currentTarget)
         {
            return;
         }
         this.calculateCandidates = true;
         var _loc2_:IFocusManagerComponent = IFocusManagerComponent(param1.target);
         if(_loc2_.hasFocusableChildren)
         {
            this.addFocusables(DisplayObject(_loc2_),true);
         }
         else
         {
            this.removeFocusables(DisplayObject(_loc2_),true);
         }
      }
      
      private function mouseFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc2_:TextField = null;
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.relatedObject == null && "isRelatedObjectInaccessible" in param1 && param1["isRelatedObjectInaccessible"] == true)
         {
            return;
         }
         if(param1.relatedObject is TextField)
         {
            _loc2_ = param1.relatedObject as TextField;
            if(_loc2_.type == "input" || _loc2_.selectable)
            {
               return;
            }
         }
         param1.preventDefault();
      }
      
      mx_internal function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         var _loc2_:ISystemManager = this.form.systemManager;
         if(hasEventListener("keyFocusChange"))
         {
            if(!dispatchEvent(new FocusEvent("keyFocusChange",false,true,InteractiveObject(param1.target))))
            {
               return;
            }
         }
         this.showFocusIndicator = true;
         this.focusChanged = false;
         var _loc3_:* = this.browserFocusComponent != null;
         if(this.browserFocusComponent)
         {
            this.clearBrowserFocusComponent();
         }
         if((param1.keyCode == Keyboard.TAB || this.browserMode && param1.keyCode == 0) && !param1.isDefaultPrevented())
         {
            if(_loc3_)
            {
               if(hasEventListener("browserFocusComponent"))
               {
                  dispatchEvent(new FocusEvent("browserFocusComponent",false,false,InteractiveObject(param1.target)));
               }
               return;
            }
            if(ieshifttab && this.lastAction == "ACTIVATE")
            {
               this.fauxFocus = _loc2_.stage;
            }
            this.setFocusToNextObject(param1);
            if(ieshifttab && this.lastAction == "ACTIVATE")
            {
               this.fauxFocus = null;
            }
            if(this.focusChanged || _loc2_ == _loc2_.getTopLevelRoot())
            {
               param1.preventDefault();
            }
         }
      }
      
      mx_internal function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:IFocusManagerGroup = null;
         var _loc2_:ISystemManager = this.form.systemManager;
         if(hasEventListener("keyDownFM"))
         {
            if(!dispatchEvent(new FocusEvent("keyDownFM",false,true,InteractiveObject(param1.target))))
            {
               return;
            }
         }
         if(_loc2_ is SystemManager)
         {
            SystemManager(_loc2_).idleCounter = 0;
         }
         if(param1.keyCode == Keyboard.TAB)
         {
            this.lastAction = "KEY";
            if(this.calculateCandidates)
            {
               this.sortFocusableObjects();
               this.calculateCandidates = false;
            }
         }
         if(this.browserMode)
         {
            if(this.browserFocusComponent)
            {
               this.clearBrowserFocusComponent();
            }
            if(param1.keyCode == Keyboard.TAB && this.focusableCandidates.length > 0)
            {
               _loc3_ = this.fauxFocus;
               if(!_loc3_)
               {
                  _loc3_ = this.form.systemManager.stage.focus;
               }
               _loc3_ = DisplayObject(this.findFocusManagerComponent2(InteractiveObject(_loc3_)));
               _loc4_ = "";
               if(_loc3_ is IFocusManagerGroup)
               {
                  _loc7_ = IFocusManagerGroup(_loc3_);
                  _loc4_ = _loc7_.groupName;
               }
               _loc5_ = this.getIndexOfFocusedObject(_loc3_);
               _loc6_ = this.getIndexOfNextObject(_loc5_,param1.shiftKey,false,_loc4_);
               if(param1.shiftKey)
               {
                  if(_loc6_ >= _loc5_)
                  {
                     this.browserFocusComponent = this.getBrowserFocusComponent(param1.shiftKey);
                     if(this.browserFocusComponent.tabIndex == -1)
                     {
                        this.browserFocusComponent.tabIndex = 0;
                     }
                  }
               }
               else if(_loc6_ <= _loc5_)
               {
                  this.browserFocusComponent = this.getBrowserFocusComponent(param1.shiftKey);
                  if(this.browserFocusComponent.tabIndex == -1)
                  {
                     this.browserFocusComponent.tabIndex = this.LARGE_TAB_INDEX;
                  }
               }
            }
         }
      }
      
      private function defaultButtonKeyHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:ISystemManager = this.form.systemManager;
         if(hasEventListener("defaultButtonKeyHandler"))
         {
            if(!dispatchEvent(new FocusEvent("defaultButtonKeyHandler",false,true)))
            {
               return;
            }
         }
         if(this.defaultButtonEnabled && param1.keyCode == Keyboard.ENTER && this.defButton && this.defButton.enabled)
         {
            this.sendDefaultButtonEvent();
         }
      }
      
      private function mouseDownCaptureHandler(param1:MouseEvent) : void
      {
         this.showFocusIndicator = false;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:ISystemManager = this.form.systemManager;
         var _loc3_:DisplayObject = this.getTopLevelFocusTarget(InteractiveObject(param1.target));
         if(!_loc3_)
         {
            return;
         }
         if((_loc3_ != this._lastFocus || this.lastAction == "ACTIVATE") && !(_loc3_ is TextField))
         {
            this.setFocus(IFocusManagerComponent(_loc3_));
         }
         else if(!this._lastFocus)
         {
         }
         if(hasEventListener("mouseDownFM"))
         {
            dispatchEvent(new FocusEvent("mouseDownFM",false,false,InteractiveObject(_loc3_)));
         }
         this.lastAction = "MOUSEDOWN";
      }
      
      private function getBrowserFocusComponent(param1:Boolean) : InteractiveObject
      {
         var _loc3_:int = 0;
         var _loc2_:InteractiveObject = this.form.systemManager.stage.focus;
         if(!_loc2_)
         {
            _loc3_ = !!param1?0:int(this.focusableCandidates.length - 1);
            _loc2_ = this.focusableCandidates[_loc3_];
         }
         return _loc2_;
      }
   }
}

import flash.display.DisplayObject;

class FocusInfo
{
    
   
   public var displayObject:DisplayObject;
   
   public var wrapped:Boolean;
   
   function FocusInfo()
   {
      super();
   }
}
