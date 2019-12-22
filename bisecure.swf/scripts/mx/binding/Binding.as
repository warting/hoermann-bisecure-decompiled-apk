package mx.binding
{
   import flash.utils.Dictionary;
   import mx.collections.errors.ItemPendingError;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Binding
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      mx_internal static var allowedErrors:Object = generateAllowedErrors();
       
      
      mx_internal var _isEnabled:Boolean;
      
      mx_internal var isExecuting:Boolean;
      
      mx_internal var isHandlingEvent:Boolean;
      
      mx_internal var disabledRequests:Dictionary;
      
      private var hasHadValue:Boolean;
      
      public var uiComponentWatcher:int;
      
      public var twoWayCounterpart:Binding;
      
      public var isTwoWayPrimary:Boolean;
      
      private var wrappedFunctionSuccessful:Boolean;
      
      mx_internal var document:Object;
      
      mx_internal var srcFunc:Function;
      
      mx_internal var destFunc:Function;
      
      mx_internal var destFuncFailed:Boolean;
      
      mx_internal var destString:String;
      
      mx_internal var srcString:String;
      
      private var lastValue:Object;
      
      public function Binding(param1:Object, param2:Function, param3:Function, param4:String, param5:String = null)
      {
         super();
         this.document = param1;
         this.srcFunc = param2;
         this.destFunc = param3;
         this.destString = param4;
         this.srcString = param5;
         this.destFuncFailed = false;
         if(this.srcFunc == null)
         {
            this.srcFunc = this.defaultSrcFunc;
         }
         if(this.destFunc == null)
         {
            this.destFunc = this.defaultDestFunc;
         }
         this._isEnabled = true;
         this.isExecuting = false;
         this.isHandlingEvent = false;
         this.hasHadValue = false;
         this.uiComponentWatcher = -1;
         BindingManager.addBinding(param1,param4,this);
      }
      
      mx_internal static function generateAllowedErrors() : Object
      {
         var _loc1_:Object = {};
         _loc1_[1507] = 1;
         _loc1_[2005] = 1;
         return _loc1_;
      }
      
      private static function nodeSeqEqual(param1:XMLList, param2:XMLList) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.length();
         if(_loc3_ == param2.length())
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_ && param1[_loc4_] === param2[_loc4_])
            {
               _loc4_++;
            }
            return _loc4_ == _loc3_;
         }
         return false;
      }
      
      mx_internal function get isEnabled() : Boolean
      {
         return this._isEnabled;
      }
      
      mx_internal function set isEnabled(param1:Boolean) : void
      {
         this._isEnabled = param1;
         if(param1)
         {
            this.processDisabledRequests();
         }
      }
      
      private function defaultDestFunc(param1:Object) : void
      {
         var _loc2_:Array = this.destString.split(".");
         var _loc3_:Object = this.document;
         var _loc4_:uint = 0;
         if(_loc2_[0] == "this")
         {
            _loc4_++;
         }
         while(_loc4_ < _loc2_.length - 1)
         {
            _loc3_ = _loc3_[_loc2_[_loc4_++]];
            if(_loc3_ == null)
            {
               this.destFuncFailed = true;
               if(BindingManager.debugDestinationStrings[this.destString])
               {
                  trace("Binding: destString = " + this.destString + ", error = 1009");
               }
               return;
            }
         }
         _loc3_[_loc2_[_loc4_]] = param1;
      }
      
      private function defaultSrcFunc() : Object
      {
         return this.document[this.srcString];
      }
      
      public function execute(param1:Object = null) : void
      {
         var o:Object = param1;
         if(!this.isEnabled)
         {
            if(o != null)
            {
               this.registerDisabledExecute(o);
            }
            return;
         }
         if(this.twoWayCounterpart && !this.twoWayCounterpart.hasHadValue && this.twoWayCounterpart.isTwoWayPrimary)
         {
            this.twoWayCounterpart.execute();
            this.hasHadValue = true;
            return;
         }
         if(this.isExecuting || this.twoWayCounterpart && this.twoWayCounterpart.isExecuting)
         {
            this.hasHadValue = true;
            return;
         }
         try
         {
            this.isExecuting = true;
            this.wrapFunctionCall(this,this.innerExecute,o);
            return;
         }
         catch(error:Error)
         {
            if(allowedErrors[error.errorID] == null)
            {
               throw error;
            }
            return;
         }
         finally
         {
            this.isExecuting = false;
         }
      }
      
      private function registerDisabledExecute(param1:Object) : void
      {
         if(param1 != null)
         {
            this.disabledRequests = this.disabledRequests != null?this.disabledRequests:new Dictionary(true);
            this.disabledRequests[param1] = true;
         }
      }
      
      private function processDisabledRequests() : void
      {
         var _loc1_:* = null;
         if(this.disabledRequests != null)
         {
            for(_loc1_ in this.disabledRequests)
            {
               this.execute(_loc1_);
            }
            this.disabledRequests = null;
         }
      }
      
      protected function wrapFunctionCall(param1:Object, param2:Function, param3:Object = null, ... rest) : Object
      {
         var result:Object = null;
         var thisArg:Object = param1;
         var wrappedFunction:Function = param2;
         var object:Object = param3;
         var args:Array = rest;
         this.wrappedFunctionSuccessful = false;
         try
         {
            result = wrappedFunction.apply(thisArg,args);
            if(this.destFuncFailed == true)
            {
               this.destFuncFailed = false;
               return null;
            }
            this.wrappedFunctionSuccessful = true;
            return result;
         }
         catch(error:Error)
         {
            if(error is ItemPendingError)
            {
               (error as ItemPendingError).addResponder(new EvalBindingResponder(this,object));
               if(BindingManager.debugDestinationStrings[destString])
               {
                  trace("Binding: destString = " + destString + ", error = " + error);
               }
            }
            else if(error is RangeError)
            {
               if(BindingManager.debugDestinationStrings[destString])
               {
                  trace("Binding: destString = " + destString + ", error = " + error);
               }
            }
            else
            {
               if(error.errorID != 1006 && error.errorID != 1009 && error.errorID != 1010 && error.errorID != 1055 && error.errorID != 1069)
               {
                  throw error;
               }
               if(BindingManager.debugDestinationStrings[destString])
               {
                  trace("Binding: destString = " + destString + ", error = " + error);
               }
            }
         }
         return null;
      }
      
      private function innerExecute() : void
      {
         this.destFuncFailed = false;
         var _loc1_:Object = this.wrapFunctionCall(this.document,this.srcFunc);
         if(BindingManager.debugDestinationStrings[this.destString])
         {
            trace("Binding: destString = " + this.destString + ", srcFunc result = " + _loc1_);
         }
         if(this.hasHadValue || this.wrappedFunctionSuccessful)
         {
            if(!(this.lastValue is XML && this.lastValue.hasComplexContent() && this.lastValue === _loc1_) && !(this.lastValue is XMLList && this.lastValue.hasComplexContent() && _loc1_ is XMLList && nodeSeqEqual(this.lastValue as XMLList,_loc1_ as XMLList)))
            {
               this.destFunc.call(this.document,_loc1_);
               if(this.destFuncFailed == false)
               {
                  this.lastValue = _loc1_;
                  this.hasHadValue = true;
               }
            }
         }
      }
      
      public function watcherFired(param1:Boolean, param2:int) : void
      {
         var commitEvent:Boolean = param1;
         var cloneIndex:int = param2;
         if(this.isHandlingEvent)
         {
            return;
         }
         try
         {
            this.isHandlingEvent = true;
            this.execute(cloneIndex);
            return;
         }
         finally
         {
            this.isHandlingEvent = false;
         }
      }
   }
}
