package mx.styles
{
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class CSSStyleDeclaration extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static const NOT_A_COLOR:uint = 4294967295;
      
      private static const FILTERMAP_PROP:String = "__reserved__filterMap";
      
      private static function emptyObjectFactory():void
      {
      } 
      
      private var clones:Dictionary;
      
      mx_internal var selectorRefCount:int = 0;
      
      public var selectorIndex:int = 0;
      
      mx_internal var effects:Array;
      
      private var styleManager:IStyleManager2;
      
      private var _defaultFactory:Function;
      
      private var _factory:Function;
      
      private var _overrides:Object;
      
      private var _selector:CSSSelector;
      
      private var _selectorString:String;
      
      public function CSSStyleDeclaration(param1:Object = null, param2:IStyleManager2 = null, param3:Boolean = true)
      {
         this.clones = new Dictionary(true);
         super();
         if(!param2)
         {
            param2 = Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2;
         }
         this.styleManager = param2;
         if(param1)
         {
            if(param1 is CSSSelector)
            {
               this.selector = param1 as CSSSelector;
            }
            else
            {
               this.selectorString = param1.toString();
            }
            if(param3)
            {
               param2.setStyleDeclaration(this.selectorString,this,false);
            }
         }
      }
      
      public function get defaultFactory() : Function
      {
         return this._defaultFactory;
      }
      
      public function set defaultFactory(param1:Function) : void
      {
         this._defaultFactory = param1;
      }
      
      public function get factory() : Function
      {
         return this._factory;
      }
      
      public function set factory(param1:Function) : void
      {
         this._factory = param1;
      }
      
      public function get overrides() : Object
      {
         return this._overrides;
      }
      
      public function set overrides(param1:Object) : void
      {
         this._overrides = param1;
      }
      
      public function get selector() : CSSSelector
      {
         return this._selector;
      }
      
      public function set selector(param1:CSSSelector) : void
      {
         this._selector = param1;
         this._selectorString = null;
      }
      
      mx_internal function get selectorString() : String
      {
         if(this._selectorString == null && this._selector != null)
         {
            this._selectorString = this._selector.toString();
         }
         return this._selectorString;
      }
      
      mx_internal function set selectorString(param1:String) : void
      {
         var _loc2_:CSSCondition = null;
         if(param1.charAt(0) == ".")
         {
            _loc2_ = new CSSCondition(CSSConditionKind.CLASS,param1.substr(1));
            this._selector = new CSSSelector("",[_loc2_]);
         }
         else
         {
            this._selector = new CSSSelector(param1);
         }
         this._selectorString = param1;
      }
      
      public function get specificity() : int
      {
         return !!this._selector?int(this._selector.specificity):0;
      }
      
      public function get subject() : String
      {
         if(this._selector != null)
         {
            if(this._selector.subject == "" && this._selector.conditions)
            {
               return "*";
            }
            return this._selector.subject;
         }
         return null;
      }
      
      mx_internal function getPseudoCondition() : String
      {
         return this.selector != null?this.selector.getPseudoCondition():null;
      }
      
      mx_internal function isAdvanced() : Boolean
      {
         var _loc1_:CSSCondition = null;
         if(this.selector != null)
         {
            if(this.selector.ancestor)
            {
               return true;
            }
            if(this.selector.conditions)
            {
               if(this.subject != "*" && this.subject != "global")
               {
                  return true;
               }
               for each(_loc1_ in this.selector.conditions)
               {
                  if(_loc1_.kind != CSSConditionKind.CLASS)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function matchesStyleClient(param1:IAdvancedStyleClient) : Boolean
      {
         return this.selector != null?Boolean(this.selector.matchesStyleClient(param1)):false;
      }
      
      mx_internal function equals(param1:CSSStyleDeclaration) : Boolean
      {
         var _loc2_:Object = null;
         if(param1 == null)
         {
            return false;
         }
         if(ObjectUtil.compare(this.overrides,param1.overrides) != 0)
         {
            return false;
         }
         if(this.factory == null && param1.factory != null || this.factory != null && param1.factory == null)
         {
            return false;
         }
         if(this.factory != null)
         {
            if(ObjectUtil.compare(new this.factory(),new param1.factory()) != 0)
            {
               return false;
            }
         }
         if(this.defaultFactory == null && param1.defaultFactory != null || this.defaultFactory != null && param1.defaultFactory == null)
         {
            return false;
         }
         if(this.defaultFactory != null)
         {
            if(ObjectUtil.compare(new this.defaultFactory(),new param1.defaultFactory()) != 0)
            {
               return false;
            }
         }
         if(ObjectUtil.compare(this.effects,param1.effects))
         {
            return false;
         }
         return true;
      }
      
      public function getStyle(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.overrides)
         {
            if(param1 in this.overrides && this.overrides[param1] === undefined)
            {
               return undefined;
            }
            _loc3_ = this.overrides[param1];
            if(_loc3_ !== undefined)
            {
               return _loc3_;
            }
         }
         if(this.factory != null)
         {
            this.factory.prototype = {};
            _loc2_ = new this.factory();
            _loc3_ = _loc2_[param1];
            if(_loc3_ !== undefined)
            {
               return _loc3_;
            }
         }
         if(this.defaultFactory != null)
         {
            this.defaultFactory.prototype = {};
            _loc2_ = new this.defaultFactory();
            _loc3_ = _loc2_[param1];
            if(_loc3_ !== undefined)
            {
               return _loc3_;
            }
         }
         return undefined;
      }
      
      public function setStyle(param1:String, param2:*) : void
      {
         var _loc7_:int = 0;
         var _loc8_:ISystemManager = null;
         var _loc9_:Object = null;
         var _loc3_:Object = this.getStyle(param1);
         var _loc4_:Boolean = false;
         if(this.selectorRefCount > 0 && this.factory == null && this.defaultFactory == null && !this.overrides && _loc3_ !== param2)
         {
            _loc4_ = true;
         }
         if(param2 !== undefined)
         {
            this.setLocalStyle(param1,param2);
         }
         else
         {
            if(param2 == _loc3_)
            {
               return;
            }
            this.setLocalStyle(param1,param2);
         }
         var _loc5_:Array = SystemManagerGlobals.topLevelSystemManagers;
         var _loc6_:int = _loc5_.length;
         if(_loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = _loc5_[_loc7_];
               _loc9_ = _loc8_.getImplementation("mx.managers::ISystemManagerChildManager");
               _loc9_.regenerateStyleCache(true);
               _loc7_++;
            }
         }
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            _loc9_ = _loc8_.getImplementation("mx.managers::ISystemManagerChildManager");
            _loc9_.notifyStyleChangeInChildren(param1,true);
            _loc7_++;
         }
      }
      
      mx_internal function setLocalStyle(param1:String, param2:*) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc3_:Object = this.getStyle(param1);
         if(param2 === undefined)
         {
            this.clearStyleAttr(param1);
            return;
         }
         if(param2 is String)
         {
            if(!this.styleManager)
            {
               this.styleManager = Singleton.getInstance("mx.styles::IStyleManager2") as IStyleManager2;
            }
            _loc5_ = this.styleManager.getColorName(param2);
            if(_loc5_ != NOT_A_COLOR)
            {
               param2 = _loc5_;
            }
         }
         if(this.defaultFactory != null)
         {
            _loc4_ = new this.defaultFactory();
            if(_loc4_[param1] !== param2)
            {
               if(!this.overrides)
               {
                  this.overrides = {};
               }
               this.overrides[param1] = param2;
            }
            else if(this.overrides)
            {
               delete this.overrides[param1];
            }
         }
         if(this.factory != null)
         {
            _loc4_ = new this.factory();
            if(_loc4_[param1] !== param2)
            {
               if(!this.overrides)
               {
                  this.overrides = {};
               }
               this.overrides[param1] = param2;
            }
            else if(this.overrides)
            {
               delete this.overrides[param1];
            }
         }
         if(this.defaultFactory == null && this.factory == null)
         {
            if(!this.overrides)
            {
               this.overrides = {};
            }
            this.overrides[param1] = param2;
         }
         this.updateClones(param1,param2);
      }
      
      public function clearStyle(param1:String) : void
      {
         this.setStyle(param1,undefined);
      }
      
      mx_internal function createProtoChainRoot() : Object
      {
         var _loc1_:Object = {};
         if(this.defaultFactory != null)
         {
            this.defaultFactory.prototype = _loc1_;
            _loc1_ = new this.defaultFactory();
         }
         if(this.factory != null)
         {
            this.factory.prototype = _loc1_;
            _loc1_ = new this.factory();
         }
         this.clones[_loc1_] = 1;
         return _loc1_;
      }
      
      mx_internal function addStyleToProtoChain(param1:Object, param2:DisplayObject, param3:Object = null) : Object
      {
         var _loc8_:CSSStyleDeclaration = null;
         var _loc10_:Object = null;
         var _loc11_:CSSStyleDeclaration = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = param1;
         var _loc6_:Vector.<CSSStyleDeclaration> = new Vector.<CSSStyleDeclaration>();
         var _loc7_:IStyleManager2 = this.styleManager.parent;
         while(_loc7_)
         {
            _loc11_ = _loc7_.getStyleDeclaration(this.selectorString);
            if(_loc11_)
            {
               _loc6_.unshift(_loc11_);
            }
            _loc7_ = _loc7_.parent;
         }
         for each(_loc8_ in _loc6_)
         {
            if(_loc8_.defaultFactory != null)
            {
               param1 = _loc8_.addDefaultStyleToProtoChain(param1,param2,param3);
            }
         }
         if(this.defaultFactory != null)
         {
            param1 = this.addDefaultStyleToProtoChain(param1,param2,param3);
         }
         var _loc9_:Boolean = false;
         for each(_loc8_ in _loc6_)
         {
            if(_loc8_.factory != null || _loc8_.overrides != null)
            {
               param1 = _loc8_.addFactoryAndOverrideStylesToProtoChain(param1,param2,param3);
               _loc9_ = true;
            }
         }
         _loc10_ = param1;
         if(this.factory != null || this.overrides != null)
         {
            param1 = this.addFactoryAndOverrideStylesToProtoChain(param1,param2,param3);
            if(_loc10_ != param1)
            {
               _loc4_ = true;
            }
         }
         if(this.defaultFactory != null && !_loc4_)
         {
            if(_loc9_)
            {
               emptyObjectFactory.prototype = param1;
               param1 = new emptyObjectFactory();
               emptyObjectFactory.prototype = null;
            }
            _loc4_ = true;
         }
         if(_loc4_)
         {
            this.clones[param1] = 1;
         }
         return param1;
      }
      
      mx_internal function addDefaultStyleToProtoChain(param1:Object, param2:DisplayObject, param3:Object = null) : Object
      {
         var _loc4_:Object = null;
         if(this.defaultFactory != null)
         {
            _loc4_ = param1;
            if(param3)
            {
               param1 = {};
            }
            this.defaultFactory.prototype = param1;
            param1 = new this.defaultFactory();
            this.defaultFactory.prototype = null;
            if(param3)
            {
               param1 = this.applyFilter(_loc4_,param1,param3);
            }
         }
         return param1;
      }
      
      mx_internal function addFactoryAndOverrideStylesToProtoChain(param1:Object, param2:DisplayObject, param3:Object = null) : Object
      {
         var _loc5_:* = null;
         var _loc4_:Object = param1;
         if(param3)
         {
            param1 = {};
         }
         if(this.factory != null)
         {
            this.factory.prototype = param1;
            param1 = new this.factory();
            this.factory.prototype = null;
         }
         if(this.overrides)
         {
            if(this.factory == null)
            {
               emptyObjectFactory.prototype = param1;
               param1 = new emptyObjectFactory();
               emptyObjectFactory.prototype = null;
            }
            for(_loc5_ in this.overrides)
            {
               if(this.overrides[_loc5_] === undefined)
               {
                  delete param1[_loc5_];
               }
               else
               {
                  param1[_loc5_] = this.overrides[_loc5_];
               }
            }
         }
         if(param3)
         {
            if(this.factory != null || this.overrides)
            {
               param1 = this.applyFilter(_loc4_,param1,param3);
            }
            else
            {
               param1 = _loc4_;
            }
         }
         if(this.factory != null || this.overrides)
         {
            this.clones[param1] = 1;
         }
         return param1;
      }
      
      mx_internal function applyFilter(param1:Object, param2:Object, param3:Object) : Object
      {
         var _loc5_:* = null;
         var _loc4_:Object = {};
         emptyObjectFactory.prototype = param1;
         _loc4_ = new emptyObjectFactory();
         emptyObjectFactory.prototype = null;
         for(_loc5_ in param2)
         {
            if(param3[_loc5_] != null)
            {
               _loc4_[param3[_loc5_]] = param2[_loc5_];
            }
         }
         param2 = _loc4_;
         param2[FILTERMAP_PROP] = param3;
         return param2;
      }
      
      mx_internal function clearOverride(param1:String) : void
      {
         if(this.overrides && this.overrides[param1] !== undefined)
         {
            delete this.overrides[param1];
         }
      }
      
      private function clearStyleAttr(param1:String) : void
      {
         var _loc2_:* = undefined;
         if(!this.overrides)
         {
            this.overrides = {};
         }
         this.overrides[param1] = undefined;
         for(_loc2_ in this.clones)
         {
            delete _loc2_[param1];
         }
      }
      
      mx_internal function updateClones(param1:String, param2:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         for(_loc3_ in this.clones)
         {
            _loc4_ = _loc3_[FILTERMAP_PROP];
            if(_loc4_)
            {
               if(_loc4_[param1] != null)
               {
                  _loc3_[_loc4_[param1]] = param2;
               }
            }
            else
            {
               _loc3_[param1] = param2;
            }
         }
      }
   }
}
