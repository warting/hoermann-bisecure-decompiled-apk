package spark.components.supportClasses
{
   import flash.desktop.NativeApplication;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.StageOrientationEvent;
   import flash.system.Capabilities;
   import flash.ui.Keyboard;
   import mx.core.IFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.FlexMouseEvent;
   import mx.events.ResizeEvent;
   import mx.utils.Platform;
   import spark.components.Application;
   import spark.components.View;
   import spark.components.ViewMenu;
   import spark.components.ViewMenuItem;
   import spark.events.PopUpEvent;
   import spark.managers.IPersistenceManager;
   import spark.managers.PersistenceManager;
   
   use namespace mx_internal;
   
   public class ViewNavigatorApplicationBase extends Application
   {
       
      
      [SkinPart(required="false")]
      public var viewMenu:IFactory;
      
      private var backKeyEventPreventDefaulted:Boolean = false;
      
      private var currentViewMenu:ViewMenu;
      
      private var lastFocus:InteractiveObject;
      
      private var menuKeyEventPreventDefaulted:Boolean = false;
      
      private var mouseShield:Sprite;
      
      private var _persistenceManager:IPersistenceManager;
      
      private var _persistNavigatorState:Boolean = false;
      
      private var _persistenceInitialized:Boolean = false;
      
      public function ViewNavigatorApplicationBase()
      {
         super();
      }
      
      mx_internal function get activeView() : View
      {
         return null;
      }
      
      mx_internal function get exitApplicationOnBackKey() : Boolean
      {
         return true;
      }
      
      public function get persistenceManager() : IPersistenceManager
      {
         if(!this._persistenceManager)
         {
            this.initializePersistenceManager();
         }
         return this._persistenceManager;
      }
      
      public function get persistNavigatorState() : Boolean
      {
         return this._persistNavigatorState;
      }
      
      public function set persistNavigatorState(param1:Boolean) : void
      {
         this._persistNavigatorState = param1;
         if(initialized && this._persistNavigatorState && !this._persistenceInitialized)
         {
            this.initializePersistenceManager();
         }
      }
      
      public function get viewMenuOpen() : Boolean
      {
         return this.currentViewMenu && this.currentViewMenu.isOpen;
      }
      
      public function set viewMenuOpen(param1:Boolean) : void
      {
         if(param1 == this.viewMenuOpen)
         {
            return;
         }
         if(!this.viewMenu || !this.activeView.viewMenuItems || this.activeView.viewMenuItems.length == 0)
         {
            return;
         }
         if(param1)
         {
            this.openViewMenu();
         }
         else
         {
            this.closeViewMenu();
         }
      }
      
      protected function invokeHandler(param1:InvokeEvent) : void
      {
         this.addDeactivateListeners();
      }
      
      private function activateHandler(param1:Event) : void
      {
         this.addDeactivateListeners();
      }
      
      protected function deactivateHandler(param1:Event) : void
      {
         var _loc2_:* = false;
         this.removeDeactivateListeners();
         if(this.persistNavigatorState)
         {
            _loc2_ = false;
            if(hasEventListener(FlexEvent.NAVIGATOR_STATE_SAVING))
            {
               _loc2_ = !dispatchEvent(new FlexEvent(FlexEvent.NAVIGATOR_STATE_SAVING,false,true));
            }
            if(!_loc2_)
            {
               this.saveNavigatorState();
            }
         }
         if(this._persistenceManager)
         {
            this.persistenceManager.save();
         }
      }
      
      protected function backKeyUpHandler(param1:KeyboardEvent) : void
      {
      }
      
      protected function menuKeyUpHandler(param1:KeyboardEvent) : void
      {
         if(this.activeView && !this.activeView.menuKeyHandledByView())
         {
            this.viewMenuOpen = !this.viewMenuOpen;
         }
      }
      
      protected function createPersistenceManager() : IPersistenceManager
      {
         return new PersistenceManager();
      }
      
      protected function saveNavigatorState() : void
      {
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         this.persistenceManager.setProperty("versionNumber",_loc1_._loc2_::versionNumber.toString());
      }
      
      protected function loadNavigatorState() : void
      {
      }
      
      private function addApplicationListeners() : void
      {
         systemManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.deviceKeyDownHandler,false,-1);
         systemManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.deviceKeyUpHandler,false,-1);
         systemManager.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.orientationChangeHandler);
         NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,this.invokeHandler);
         NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,this.activateHandler);
      }
      
      private function addDeactivateListeners() : void
      {
         var _loc1_:String = Capabilities.os;
         var _loc2_:Boolean = Platform.isDesktop;
         if(!_loc2_)
         {
            NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,this.deactivateHandler);
         }
         NativeApplication.nativeApplication.addEventListener(Event.EXITING,this.deactivateHandler);
      }
      
      private function removeDeactivateListeners() : void
      {
         var _loc1_:String = Capabilities.os;
         var _loc2_:Boolean = Platform.isDesktop;
         if(!_loc2_)
         {
            NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,this.deactivateHandler);
         }
         NativeApplication.nativeApplication.removeEventListener(Event.EXITING,this.deactivateHandler);
      }
      
      private function deviceKeyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         if(_loc2_ == Keyboard.BACK)
         {
            this.backKeyEventPreventDefaulted = param1.isDefaultPrevented();
            if(!this.exitApplicationOnBackKey)
            {
               param1.preventDefault();
            }
         }
         else if(_loc2_ == Keyboard.MENU)
         {
            this.menuKeyEventPreventDefaulted = param1.isDefaultPrevented();
         }
      }
      
      private function deviceKeyUpHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = param1.keyCode;
         if(_loc2_ == Keyboard.BACK && !this.backKeyEventPreventDefaulted && !this.exitApplicationOnBackKey)
         {
            this.backKeyUpHandler(param1);
         }
         else if(_loc2_ == Keyboard.MENU && !this.menuKeyEventPreventDefaulted)
         {
            this.menuKeyUpHandler(param1);
         }
      }
      
      private function orientationChangeHandler(param1:StageOrientationEvent) : void
      {
         if(this.currentViewMenu)
         {
            this.currentViewMenu.width = getLayoutBoundsWidth();
            this.currentViewMenu.height = getLayoutBoundsHeight();
         }
      }
      
      private function viewMenu_clickHandler(param1:MouseEvent) : void
      {
         if(param1.target is ViewMenuItem)
         {
            this.viewMenuOpen = false;
         }
      }
      
      private function viewMenu_mouseDownOutsideHandler(param1:FlexMouseEvent) : void
      {
         this.viewMenuOpen = false;
      }
      
      private function openViewMenu() : void
      {
         if(!this.currentViewMenu)
         {
            this.currentViewMenu = ViewMenu(this.viewMenu.newInstance());
            this.currentViewMenu.items = this.activeView.viewMenuItems;
            this.lastFocus = getFocus();
            if(isSoftKeyboardActive)
            {
               systemManager.stage.focus = null;
            }
            this.currentViewMenu.width = getLayoutBoundsWidth();
            this.currentViewMenu.height = getLayoutBoundsHeight();
            this.currentViewMenu.setFocus();
            this.currentViewMenu.addEventListener(MouseEvent.CLICK,this.viewMenu_clickHandler);
            this.currentViewMenu.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.viewMenu_mouseDownOutsideHandler);
            this.currentViewMenu.addEventListener(PopUpEvent.CLOSE,this.viewMenuClose_handler);
            this.currentViewMenu.addEventListener(PopUpEvent.OPEN,this.viewMenuOpen_handler);
            addEventListener(ResizeEvent.RESIZE,this.resizeHandler);
         }
         this.attachMouseShield();
         this.currentViewMenu.open(this,false);
      }
      
      private function closeViewMenu() : void
      {
         if(this.currentViewMenu)
         {
            this.currentViewMenu.close();
            this.removeMouseShield();
         }
      }
      
      private function viewMenuOpen_handler(param1:PopUpEvent) : void
      {
         if(this.activeView.hasEventListener("viewMenuOpen"))
         {
            this.activeView.dispatchEvent(new Event("viewMenuOpen"));
         }
      }
      
      private function viewMenuClose_handler(param1:PopUpEvent) : void
      {
         this.currentViewMenu.removeEventListener(PopUpEvent.OPEN,this.viewMenuOpen_handler);
         this.currentViewMenu.removeEventListener(PopUpEvent.CLOSE,this.viewMenuClose_handler);
         this.currentViewMenu.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,this.viewMenu_mouseDownOutsideHandler);
         this.currentViewMenu.removeEventListener(MouseEvent.CLICK,this.viewMenu_clickHandler);
         removeEventListener(ResizeEvent.RESIZE,this.resizeHandler);
         if(this.activeView.hasEventListener("viewMenuClose"))
         {
            this.activeView.dispatchEvent(new Event("viewMenuClose"));
         }
         this.currentViewMenu.caretIndex = -1;
         this.currentViewMenu.validateProperties();
         this.currentViewMenu.items = null;
         this.currentViewMenu = null;
         systemManager.stage.focus = this.lastFocus;
      }
      
      private function resizeHandler(param1:ResizeEvent) : void
      {
         this.currentViewMenu.width = getLayoutBoundsWidth();
         this.currentViewMenu.height = getLayoutBoundsHeight();
         this.currentViewMenu.invalidateSkinState();
      }
      
      mx_internal function attachMouseShield() : void
      {
         var _loc1_:Graphics = null;
         if(skin)
         {
            this.mouseShield = new Sprite();
            _loc1_ = this.mouseShield.graphics;
            _loc1_.beginFill(0,0);
            _loc1_.drawRect(0,0,getLayoutBoundsWidth(),getLayoutBoundsHeight());
            _loc1_.endFill();
            skin.addChild(this.mouseShield);
         }
      }
      
      mx_internal function removeMouseShield() : void
      {
         if(this.mouseShield && skin)
         {
            skin.removeChild(this.mouseShield);
            this.mouseShield = null;
         }
      }
      
      override public function initialize() : void
      {
         var _loc1_:Boolean = false;
         super.initialize();
         this.addApplicationListeners();
         if(this.persistNavigatorState)
         {
            this.initializePersistenceManager();
            _loc1_ = true;
            if(hasEventListener(FlexEvent.NAVIGATOR_STATE_LOADING))
            {
               _loc1_ = dispatchEvent(new FlexEvent(FlexEvent.NAVIGATOR_STATE_LOADING,false,true));
            }
            if(_loc1_)
            {
               this.loadNavigatorState();
            }
         }
      }
      
      private function initializePersistenceManager() : void
      {
         this._persistenceManager = this.createPersistenceManager();
         this._persistenceManager.load();
         this._persistenceInitialized = true;
      }
   }
}
