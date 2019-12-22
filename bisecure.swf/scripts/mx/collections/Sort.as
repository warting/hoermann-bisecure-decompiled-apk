package mx.collections
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.collections.errors.SortError;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class Sort extends EventDispatcher implements ISort
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      public static const ANY_INDEX_MODE:String = "any";
      
      public static const FIRST_INDEX_MODE:String = "first";
      
      public static const LAST_INDEX_MODE:String = "last";
       
      
      private var resourceManager:IResourceManager;
      
      mx_internal var useSortOn:Boolean = true;
      
      private var _compareFunction:Function;
      
      private var usingCustomCompareFunction:Boolean;
      
      private var _fields:Array;
      
      private var _unique:Boolean;
      
      private var defaultEmptyField:ISortField;
      
      private var noFieldsDescending:Boolean = false;
      
      public function Sort(param1:Array = null, param2:Function = null, param3:Boolean = false)
      {
         this.resourceManager = ResourceManager.getInstance();
         super();
         this.fields = param1;
         this.compareFunction = param2;
         this.unique = param3;
      }
      
      public function get compareFunction() : Function
      {
         return !!this.usingCustomCompareFunction?this._compareFunction:this.internalCompare;
      }
      
      public function set compareFunction(param1:Function) : void
      {
         this._compareFunction = param1;
         this.usingCustomCompareFunction = this._compareFunction != null;
      }
      
      [Bindable("fieldsChanged")]
      public function get fields() : Array
      {
         return this._fields;
      }
      
      public function set fields(param1:Array) : void
      {
         this._fields = param1;
         dispatchEvent(new Event("fieldsChanged"));
      }
      
      public function get unique() : Boolean
      {
         return this._unique;
      }
      
      public function set unique(param1:Boolean) : void
      {
         this._unique = param1;
      }
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      public function findItem(param1:Array, param2:Object, param3:String, param4:Boolean = false, param5:Function = null) : int
      {
         var _loc6_:Function = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc11_:int = 0;
         var _loc16_:ISortField = null;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:* = false;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         if(!param1)
         {
            _loc8_ = this.resourceManager.getString("collections","noItems");
            throw new SortError(_loc8_);
         }
         if(param1.length == 0)
         {
            return !!param4?1:-1;
         }
         if(param5 == null)
         {
            _loc6_ = this.compareFunction;
            if(param2 && this.fields && this.fields.length > 0)
            {
               _loc7_ = [];
               _loc17_ = true;
               _loc18_ = 0;
               while(_loc18_ < this.fields.length)
               {
                  _loc16_ = this.fields[_loc18_] as ISortField;
                  if(_loc16_.name)
                  {
                     if(_loc16_.objectHasSortField(param2))
                     {
                        if(!_loc17_)
                        {
                           _loc8_ = this.resourceManager.getString("collections","findCondition",[_loc16_.name]);
                           throw new SortError(_loc8_);
                        }
                        _loc7_.push(_loc16_.name);
                     }
                     else
                     {
                        _loc17_ = false;
                     }
                  }
                  else
                  {
                     _loc7_.push(null);
                  }
                  _loc18_++;
               }
               if(_loc7_.length == 0)
               {
                  _loc8_ = this.resourceManager.getString("collections","findRestriction");
                  throw new SortError(_loc8_);
               }
               try
               {
                  this.initSortFields(param1[0]);
               }
               catch(initSortError:SortError)
               {
               }
            }
         }
         else
         {
            _loc6_ = param5;
         }
         var _loc9_:* = false;
         var _loc10_:Boolean = false;
         _loc11_ = 0;
         var _loc12_:int = 0;
         var _loc13_:int = param1.length - 1;
         var _loc14_:Object = null;
         var _loc15_:int = 1;
         loop1:
         while(true)
         {
            if(!(!_loc10_ && _loc12_ <= _loc13_))
            {
               if(!_loc9_ && !param4)
               {
                  return -1;
               }
               return _loc15_ > 0?int(_loc11_ + 1):int(_loc11_);
            }
            _loc11_ = Math.round((_loc12_ + _loc13_) / 2);
            _loc14_ = param1[_loc11_];
            _loc15_ = !!_loc7_?int(_loc6_(param2,_loc14_,_loc7_)):int(_loc6_(param2,_loc14_));
            switch(_loc15_)
            {
               case -1:
                  _loc13_ = _loc11_ - 1;
                  continue;
               case 0:
                  _loc10_ = true;
                  switch(param3)
                  {
                     case ANY_INDEX_MODE:
                        _loc9_ = true;
                        break;
                     case FIRST_INDEX_MODE:
                        _loc9_ = _loc11_ == _loc12_;
                        _loc19_ = _loc11_ - 1;
                        _loc20_ = true;
                        while(_loc20_ && !_loc9_ && _loc19_ >= _loc12_)
                        {
                           _loc14_ = param1[_loc19_];
                           _loc21_ = !!_loc7_?int(_loc6_(param2,_loc14_,_loc7_)):int(_loc6_(param2,_loc14_));
                           _loc20_ = _loc21_ == 0;
                           if(!_loc20_ || _loc20_ && _loc19_ == _loc12_)
                           {
                              _loc9_ = true;
                              _loc11_ = _loc19_ + (!!_loc20_?0:1);
                           }
                           _loc19_--;
                        }
                        break;
                     case LAST_INDEX_MODE:
                        _loc9_ = _loc11_ == _loc13_;
                        _loc19_ = _loc11_ + 1;
                        _loc20_ = true;
                        while(_loc20_ && !_loc9_ && _loc19_ <= _loc13_)
                        {
                           _loc14_ = param1[_loc19_];
                           _loc22_ = !!_loc7_?int(_loc6_(param2,_loc14_,_loc7_)):int(_loc6_(param2,_loc14_));
                           _loc20_ = _loc22_ == 0;
                           if(!_loc20_ || _loc20_ && _loc19_ == _loc13_)
                           {
                              _loc9_ = true;
                              _loc11_ = _loc19_ - (!!_loc20_?0:1);
                           }
                           _loc19_++;
                        }
                        break;
                     default:
                        break loop1;
                  }
                  continue;
               case 1:
                  _loc12_ = _loc11_ + 1;
                  continue;
               default:
                  continue;
            }
         }
         _loc8_ = this.resourceManager.getString("collections","unknownMode");
         throw new SortError(_loc8_);
      }
      
      public function propertyAffectsSort(param1:String) : Boolean
      {
         var _loc3_:ISortField = null;
         if(this.usingCustomCompareFunction || !this.fields)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.fields.length)
         {
            _loc3_ = this.fields[_loc2_];
            if(_loc3_.name == param1 || _loc3_.usingCustomCompareFunction)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function reverse() : void
      {
         var _loc1_:int = 0;
         if(this.fields)
         {
            _loc1_ = 0;
            while(_loc1_ < this.fields.length)
            {
               ISortField(this.fields[_loc1_]).reverse();
               _loc1_++;
            }
         }
         this.noFieldsDescending = !this.noFieldsDescending;
      }
      
      public function sort(param1:Array) : void
      {
         var fixedCompareFunction:Function = null;
         var message:String = null;
         var uniqueRet1:Object = null;
         var sortArgs:Object = null;
         var uniqueRet2:Object = null;
         var items:Array = param1;
         if(!items || items.length <= 1)
         {
            return;
         }
         if(this.usingCustomCompareFunction)
         {
            fixedCompareFunction = function(param1:Object, param2:Object):int
            {
               return compareFunction(param1,param2,_fields);
            };
            if(this.unique)
            {
               uniqueRet1 = items.sort(fixedCompareFunction,Array.UNIQUESORT);
               if(uniqueRet1 == 0)
               {
                  message = this.resourceManager.getString("collections","nonUnique");
                  throw new SortError(message);
               }
            }
            else
            {
               items.sort(fixedCompareFunction);
            }
         }
         else if(this.fields && this.fields.length > 0)
         {
            sortArgs = this.initSortFields(items[0],true);
            if(this.unique)
            {
               if(this.useSortOn && sortArgs && this.fields.length == 1)
               {
                  uniqueRet2 = items.sortOn(sortArgs.fields[0],sortArgs.options[0] | Array.UNIQUESORT);
               }
               else
               {
                  uniqueRet2 = items.sort(this.internalCompare,Array.UNIQUESORT);
               }
               if(uniqueRet2 == 0)
               {
                  message = this.resourceManager.getString("collections","nonUnique");
                  throw new SortError(message);
               }
            }
            else if(this.useSortOn && sortArgs)
            {
               items.sortOn(sortArgs.fields,sortArgs.options);
            }
            else
            {
               items.sort(this.internalCompare);
            }
         }
         else
         {
            items.sort(this.internalCompare);
         }
      }
      
      private function initSortFields(param1:Object, param2:Boolean = false) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:ISortField = null;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         _loc4_ = 0;
         while(_loc4_ < this.fields.length)
         {
            ISortField(this.fields[_loc4_]).initializeDefaultCompareFunction(param1);
            _loc4_++;
         }
         if(param2)
         {
            _loc3_ = {
               "fields":[],
               "options":[]
            };
            _loc4_ = 0;
            while(_loc4_ < this.fields.length)
            {
               _loc5_ = this.fields[_loc4_];
               _loc6_ = _loc5_.arraySortOnOptions;
               if(_loc6_ == -1)
               {
                  return null;
               }
               _loc3_.fields.push(_loc5_.name);
               _loc3_.options.push(_loc6_);
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      private function internalCompare(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ISortField = null;
         var _loc4_:int = 0;
         if(!this._fields)
         {
            _loc4_ = this.noFieldsCompare(param1,param2);
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = !!param3?int(param3.length):int(this._fields.length);
            while(_loc4_ == 0 && _loc5_ < _loc6_)
            {
               _loc7_ = ISortField(this._fields[_loc5_]);
               _loc4_ = _loc7_.compareFunction(param1,param2);
               if(_loc7_.descending)
               {
                  _loc4_ = _loc4_ * -1;
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private function noFieldsCompare(param1:Object, param2:Object, param3:Array = null) : int
      {
         var message:String = null;
         var a:Object = param1;
         var b:Object = param2;
         var fields:Array = param3;
         if(!this.defaultEmptyField)
         {
            this.defaultEmptyField = this.createEmptySortField();
            try
            {
               this.defaultEmptyField.initializeDefaultCompareFunction(a);
            }
            catch(e:SortError)
            {
               message = resourceManager.getString("collections","noComparator",[a]);
               throw new SortError(message);
            }
         }
         var result:int = this.defaultEmptyField.compareFunction(a,b);
         if(this.noFieldsDescending)
         {
            result = result * -1;
         }
         return result;
      }
      
      protected function createEmptySortField() : ISortField
      {
         return new SortField();
      }
   }
}
