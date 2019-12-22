package mx.managers.systemClasses
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import mx.core.IChildList;
   import mx.core.IFlexModuleFactory;
   import mx.core.IRawChildrenContainer;
   import mx.core.IUIComponent;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.events.DynamicEvent;
   import mx.events.Request;
   import mx.managers.IActiveWindowManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class ActiveWindowManager extends EventDispatcher implements IActiveWindowManager
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var systemManager:ISystemManager;
      
      mx_internal var forms:Array;
      
      mx_internal var form:Object;
      
      private var _numModalWindows:int = 0;
      
      public function ActiveWindowManager(param1:ISystemManager = null)
      {
         this.forms = [];
         super();
         if(!param1)
         {
            return;
         }
         this.systemManager = param1;
         if(param1.isTopLevelRoot() || param1.getSandboxRoot() == param1)
         {
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,true);
         }
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Singleton.registerClass("mx.managers::IActiveWindowManager",ActiveWindowManager);
      }
      
      private static function areRemotePopUpsEqual(param1:Object, param2:Object) : Boolean
      {
         if(!(param1 is RemotePopUp))
         {
            return false;
         }
         if(!(param2 is RemotePopUp))
         {
            return false;
         }
         var _loc3_:RemotePopUp = RemotePopUp(param1);
         var _loc4_:RemotePopUp = RemotePopUp(param2);
         if(_loc3_.window == _loc4_.window && _loc3_.bridge && _loc4_.bridge)
         {
            return true;
         }
         return false;
      }
      
      private static function getChildListIndex(param1:IChildList, param2:Object) : int
      {
         var _loc3_:int = -1;
         try
         {
            _loc3_ = param1.getChildIndex(DisplayObject(param2));
         }
         catch(e:ArgumentError)
         {
         }
         return _loc3_;
      }
      
      public function get numModalWindows() : int
      {
         return this._numModalWindows;
      }
      
      public function set numModalWindows(param1:int) : void
      {
         this._numModalWindows = param1;
         this.systemManager.numModalWindows = param1;
      }
      
      public function activate(param1:Object) : void
      {
         this.activateForm(param1);
      }
      
      private function activateForm(param1:Object) : void
      {
         var _loc2_:DynamicEvent = null;
         var _loc3_:DynamicEvent = null;
         var _loc4_:IFocusManagerContainer = null;
         if(this.form)
         {
            if(this.form != param1 && this.forms.length > 1)
            {
               if(hasEventListener("activateForm"))
               {
                  _loc2_ = new DynamicEvent("activateForm",false,true);
                  _loc2_.form = param1;
               }
               if(!_loc2_ || dispatchEvent(_loc2_))
               {
                  _loc4_ = IFocusManagerContainer(this.form);
                  _loc4_.focusManager.deactivate();
               }
            }
         }
         this.form = param1;
         if(hasEventListener("activatedForm"))
         {
            _loc3_ = new DynamicEvent("activatedForm",false,true);
            _loc3_.form = param1;
         }
         if(!_loc3_ || dispatchEvent(_loc3_))
         {
            if(param1.focusManager)
            {
               param1.focusManager.activate();
            }
         }
      }
      
      public function deactivate(param1:Object) : void
      {
         this.deactivateForm(Object(param1));
      }
      
      private function deactivateForm(param1:Object) : void
      {
         var _loc2_:DynamicEvent = null;
         var _loc3_:DynamicEvent = null;
         if(this.form)
         {
            if(this.form == param1 && this.forms.length > 1)
            {
               if(hasEventListener("deactivateForm"))
               {
                  _loc2_ = new DynamicEvent("deactivateForm",false,true);
                  _loc2_.form = this.form;
               }
               if(!_loc2_ || dispatchEvent(_loc2_))
               {
                  this.form.focusManager.deactivate();
               }
               this.form = this.findLastActiveForm(param1);
               if(this.form)
               {
                  if(hasEventListener("deactivatedForm"))
                  {
                     _loc3_ = new DynamicEvent("deactivatedForm",false,true);
                     _loc3_.form = this.form;
                  }
                  if(!_loc3_ || dispatchEvent(_loc3_))
                  {
                     if(this.form)
                     {
                        this.form.focusManager.activate();
                     }
                  }
               }
            }
         }
      }
      
      private function findLastActiveForm(param1:Object) : Object
      {
         var _loc2_:int = this.forms.length;
         var _loc3_:int = this.forms.length - 1;
         while(_loc3_ >= 0)
         {
            if(!this.areFormsEqual(this.forms[_loc3_],param1) && this.canActivatePopUp(this.forms[_loc3_]))
            {
               return this.forms[_loc3_];
            }
            _loc3_--;
         }
         return null;
      }
      
      private function areFormsEqual(param1:Object, param2:Object) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         if(param1 is RemotePopUp && param2 is RemotePopUp)
         {
            return areRemotePopUpsEqual(param1,param2);
         }
         return false;
      }
      
      private function canActivatePopUp(param1:Object) : Boolean
      {
         var _loc2_:Request = null;
         if(hasEventListener("canActivateForm"))
         {
            _loc2_ = new Request("canActivateForm",false,true);
            _loc2_.value = param1;
            if(!dispatchEvent(_loc2_))
            {
               return _loc2_.value;
            }
         }
         if(this.canActivateLocalComponent(param1))
         {
            return true;
         }
         return false;
      }
      
      private function canActivateLocalComponent(param1:Object) : Boolean
      {
         if(param1 is Sprite && param1 is IUIComponent && Sprite(param1).visible && IUIComponent(param1).enabled)
         {
            return true;
         }
         return false;
      }
      
      public function addFocusManager(param1:IFocusManagerContainer) : void
      {
         this.forms.push(param1);
      }
      
      public function removeFocusManager(param1:IFocusManagerContainer) : void
      {
         var _loc2_:int = this.forms.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.forms[_loc3_] == param1)
            {
               if(this.form == param1)
               {
                  this.deactivate(param1);
               }
               if(hasEventListener("removeFocusManager"))
               {
                  dispatchEvent(new FocusEvent("removeFocusManager",false,false,InteractiveObject(param1)));
               }
               this.forms.splice(_loc3_,1);
               return;
            }
            _loc3_++;
         }
      }
      
      private function findHighestModalForm() : int
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc1_:int = this.forms.length;
         var _loc2_:IChildList = this.systemManager.rawChildren;
         var _loc3_:int = _loc1_ - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = this.forms[_loc3_];
            if(_loc4_ is DisplayObject)
            {
               _loc5_ = _loc2_.getChildIndex(_loc4_ as DisplayObject);
               if(_loc5_ > 0)
               {
                  _loc6_ = _loc2_.getChildAt(_loc5_ - 1);
                  if(_loc6_.name == "modalWindow")
                  {
                     return _loc3_;
                  }
               }
            }
            _loc3_--;
         }
         return 0;
      }
      
      private function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Request = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:IChildList = null;
         var _loc13_:DisplayObject = null;
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         if(hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            if(!dispatchEvent(new FocusEvent(MouseEvent.MOUSE_DOWN,false,true,InteractiveObject(param1.target))))
            {
               return;
            }
         }
         var _loc2_:int = 0;
         if(this.numModalWindows > 0)
         {
            _loc2_ = this.findHighestModalForm();
         }
         if(!this.systemManager.isTopLevelRoot() || this.forms.length > 1)
         {
            _loc3_ = this.forms.length;
            _loc4_ = DisplayObject(param1.target);
            _loc5_ = this.systemManager.document is IRawChildrenContainer?Boolean(IRawChildrenContainer(this.systemManager.document).rawChildren.contains(_loc4_)):Boolean(this.systemManager.document.contains(_loc4_));
            while(_loc4_)
            {
               _loc6_ = _loc2_;
               while(_loc6_ < _loc3_)
               {
                  _loc7_ = this.forms[_loc6_];
                  if(hasEventListener("actualForm"))
                  {
                     _loc8_ = new Request("actualForm",false,true);
                     _loc8_.value = this.forms[_loc6_];
                     if(!dispatchEvent(_loc8_))
                     {
                        _loc7_ = this.forms[_loc6_].window;
                     }
                  }
                  if(_loc7_ == _loc4_)
                  {
                     _loc9_ = 0;
                     if(_loc4_ != this.form && _loc4_ is IFocusManagerContainer || !this.systemManager.isTopLevelRoot() && _loc4_ == this.form)
                     {
                        if(this.systemManager.isTopLevelRoot())
                        {
                           this.activate(IFocusManagerContainer(_loc4_));
                        }
                        if(_loc4_ == this.systemManager.document)
                        {
                           if(hasEventListener("activateApplication"))
                           {
                              dispatchEvent(new Event("activateApplication"));
                           }
                        }
                        else if(_loc4_ is DisplayObject)
                        {
                           if(hasEventListener("activateWindow"))
                           {
                              dispatchEvent(new FocusEvent("activateWindow",false,false,InteractiveObject(_loc4_)));
                           }
                        }
                     }
                     if(this.systemManager.popUpChildren.contains(_loc4_))
                     {
                        _loc12_ = this.systemManager.popUpChildren;
                     }
                     else
                     {
                        _loc12_ = this.systemManager;
                     }
                     _loc10_ = _loc12_.getChildIndex(_loc4_);
                     _loc11_ = _loc10_;
                     if(_loc4_ == this.forms[_loc2_])
                     {
                        return;
                     }
                     _loc3_ = this.forms.length;
                     _loc9_ = _loc2_;
                     for(; _loc9_ < _loc3_; _loc9_++)
                     {
                        _loc14_ = false;
                        if(hasEventListener("isRemote"))
                        {
                           _loc8_ = new Request("isRemote",false,true);
                           _loc8_.value = this.forms[_loc9_];
                           _loc14_ = false;
                           if(!dispatchEvent(_loc8_))
                           {
                              _loc14_ = _loc8_.value as Boolean;
                           }
                        }
                        if(_loc14_)
                        {
                           if(this.forms[_loc9_].window is String)
                           {
                              continue;
                           }
                           _loc13_ = this.forms[_loc9_].window;
                        }
                        else
                        {
                           _loc13_ = this.forms[_loc9_];
                        }
                        if(_loc14_)
                        {
                           _loc15_ = getChildListIndex(_loc12_,_loc13_);
                           if(_loc15_ > _loc10_)
                           {
                              _loc11_ = Math.max(_loc15_,_loc11_);
                           }
                        }
                        else if(_loc12_.contains(_loc13_))
                        {
                           if(_loc12_.getChildIndex(_loc13_) > _loc10_)
                           {
                              _loc11_ = Math.max(_loc12_.getChildIndex(_loc13_),_loc11_);
                              continue;
                           }
                           continue;
                        }
                     }
                     if(_loc11_ > _loc10_ && !_loc5_)
                     {
                        _loc12_.setChildIndex(_loc4_,_loc11_);
                     }
                     return;
                  }
                  _loc6_++;
               }
               _loc4_ = _loc4_.parent;
            }
         }
         else if(hasEventListener("activateApplication"))
         {
            dispatchEvent(new Event("activateApplication"));
         }
      }
   }
}
