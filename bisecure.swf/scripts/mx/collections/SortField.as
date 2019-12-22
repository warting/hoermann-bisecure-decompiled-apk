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
   
   public class SortField extends EventDispatcher implements ISortField
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var resourceManager:IResourceManager;
      
      private var _caseInsensitive:Boolean;
      
      private var _compareFunction:Function;
      
      private var _descending:Boolean;
      
      private var _name:String;
      
      private var _numeric:Object;
      
      private var _sortCompareType:String = null;
      
      private var _usingCustomCompareFunction:Boolean;
      
      public function SortField(param1:String = null, param2:Boolean = false, param3:Boolean = false, param4:Object = null, param5:String = null, param6:Function = null)
      {
         this.resourceManager = ResourceManager.getInstance();
         super();
         this._name = param1;
         this._caseInsensitive = param2;
         this._descending = param3;
         this._numeric = param4;
         this._sortCompareType = param5;
         if(param6 != null)
         {
            this.compareFunction = param6;
         }
         else if(this.updateSortCompareType() == false)
         {
            this._compareFunction = this.stringCompare;
         }
      }
      
      public function get arraySortOnOptions() : int
      {
         if(this.usingCustomCompareFunction || this.name == null || this._compareFunction == this.xmlCompare || this._compareFunction == this.dateCompare)
         {
            return -1;
         }
         var _loc1_:* = 0;
         if(this.caseInsensitive)
         {
            _loc1_ = _loc1_ | Array.CASEINSENSITIVE;
         }
         if(this.descending)
         {
            _loc1_ = _loc1_ | Array.DESCENDING;
         }
         if(this.numeric == true || this._compareFunction == this.numericCompare)
         {
            _loc1_ = _loc1_ | Array.NUMERIC;
         }
         return _loc1_;
      }
      
      [Bindable("caseInsensitiveChanged")]
      public function get caseInsensitive() : Boolean
      {
         return this._caseInsensitive;
      }
      
      mx_internal function setCaseInsensitive(param1:Boolean) : void
      {
         if(param1 != this._caseInsensitive)
         {
            this._caseInsensitive = param1;
            dispatchEvent(new Event("caseInsensitiveChanged"));
         }
      }
      
      public function get compareFunction() : Function
      {
         return this._compareFunction;
      }
      
      public function set compareFunction(param1:Function) : void
      {
         this._compareFunction = param1;
         this._usingCustomCompareFunction = param1 != null;
      }
      
      [Bindable("descendingChanged")]
      public function get descending() : Boolean
      {
         return this._descending;
      }
      
      public function set descending(param1:Boolean) : void
      {
         if(this._descending != param1)
         {
            this._descending = param1;
            dispatchEvent(new Event("descendingChanged"));
         }
      }
      
      [Bindable("nameChanged")]
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
         dispatchEvent(new Event("nameChanged"));
      }
      
      [Bindable("numericChanged")]
      public function get numeric() : Object
      {
         return this._numeric;
      }
      
      public function set numeric(param1:Object) : void
      {
         if(this._numeric != param1)
         {
            this._numeric = param1;
            dispatchEvent(new Event("numericChanged"));
         }
      }
      
      [Bindable("sortCompareTypeChanged")]
      public function get sortCompareType() : String
      {
         return this._sortCompareType;
      }
      
      public function set sortCompareType(param1:String) : void
      {
         if(this._sortCompareType != param1)
         {
            this._sortCompareType = param1;
            dispatchEvent(new Event("sortCompareTypeChanged"));
         }
         this.updateSortCompareType();
      }
      
      public function get usingCustomCompareFunction() : Boolean
      {
         return this._usingCustomCompareFunction;
      }
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      public function initializeDefaultCompareFunction(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         var _loc4_:String = null;
         if(!this.usingCustomCompareFunction)
         {
            if(this._sortCompareType)
            {
               if(this.updateSortCompareType() == true)
               {
                  return;
               }
            }
            if(this.numeric == true)
            {
               this._compareFunction = this.numericCompare;
            }
            else if(this.caseInsensitive || this.numeric == false)
            {
               this._compareFunction = this.stringCompare;
            }
            else
            {
               if(this._name)
               {
                  _loc2_ = this.getSortFieldValue(param1);
               }
               if(_loc2_ == null)
               {
                  _loc2_ = param1;
               }
               _loc3_ = typeof _loc2_;
               switch(_loc3_)
               {
                  case "string":
                     this._compareFunction = this.stringCompare;
                     break;
                  case "object":
                     if(_loc2_ is Date)
                     {
                        this._compareFunction = this.dateCompare;
                     }
                     else
                     {
                        this._compareFunction = this.stringCompare;
                        try
                        {
                           _loc4_ = _loc2_.toString();
                        }
                        catch(error2:Error)
                        {
                        }
                        if(!_loc4_ || _loc4_ == "[object Object]")
                        {
                           this._compareFunction = this.nullCompare;
                        }
                     }
                     break;
                  case "xml":
                     this._compareFunction = this.xmlCompare;
                     break;
                  case "boolean":
                  case "number":
                     this._compareFunction = this.numericCompare;
               }
            }
         }
      }
      
      public function reverse() : void
      {
         this.descending = !this.descending;
      }
      
      public function updateSortCompareType() : Boolean
      {
         if(!this._sortCompareType)
         {
            return false;
         }
         switch(this._sortCompareType)
         {
            case SortFieldCompareTypes.DATE:
               this._compareFunction = this.dateCompare;
               return true;
            case SortFieldCompareTypes.NULL:
               this._compareFunction = this.nullCompare;
               return true;
            case SortFieldCompareTypes.NUMERIC:
               this._compareFunction = this.numericCompare;
               return true;
            case SortFieldCompareTypes.STRING:
               this._compareFunction = this.stringCompare;
               return true;
            case SortFieldCompareTypes.XML:
               this._compareFunction = this.xmlCompare;
               return true;
            default:
               return false;
         }
      }
      
      public function objectHasSortField(param1:Object) : Boolean
      {
         return this.getSortFieldValue(param1) !== undefined;
      }
      
      protected function getSortFieldValue(param1:Object) : *
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = param1[this._name];
         }
         catch(error:Error)
         {
         }
         return _loc2_;
      }
      
      private function nullCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc8_:String = null;
         var _loc5_:Boolean = false;
         if(param1 == null && param2 == null)
         {
            return 0;
         }
         if(this._name)
         {
            _loc3_ = this.getSortFieldValue(param1);
            _loc4_ = this.getSortFieldValue(param2);
         }
         if(_loc3_ == null && _loc4_ == null)
         {
            return 0;
         }
         if(_loc3_ == null && !this._name)
         {
            _loc3_ = param1;
         }
         if(_loc4_ == null && !this._name)
         {
            _loc4_ = param2;
         }
         var _loc6_:* = typeof _loc3_;
         var _loc7_:* = typeof _loc4_;
         if(_loc6_ == "string" || _loc7_ == "string")
         {
            _loc5_ = true;
            this._compareFunction = this.stringCompare;
         }
         else if(_loc6_ == "object" || _loc7_ == "object")
         {
            if(_loc3_ is Date || _loc4_ is Date)
            {
               _loc5_ = true;
               this._compareFunction = this.dateCompare;
            }
         }
         else if(_loc6_ == "xml" || _loc7_ == "xml")
         {
            _loc5_ = true;
            this._compareFunction = this.xmlCompare;
         }
         else if(_loc6_ == "number" || _loc7_ == "number" || _loc6_ == "boolean" || _loc7_ == "boolean")
         {
            _loc5_ = true;
            this._compareFunction = this.numericCompare;
         }
         if(_loc5_)
         {
            return this._compareFunction(_loc3_,_loc4_);
         }
         _loc8_ = this.resourceManager.getString("collections","noComparatorSortField",[this.name]);
         throw new SortError(_loc8_);
      }
      
      private function numericCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:Number = this._name == null?Number(Number(param1)):Number(Number(this.getSortFieldValue(param1)));
         var _loc4_:Number = this._name == null?Number(Number(param2)):Number(Number(this.getSortFieldValue(param2)));
         return ObjectUtil.numericCompare(_loc3_,_loc4_);
      }
      
      private function dateCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:Date = this._name == null?param1 as Date:this.getSortFieldValue(param1) as Date;
         var _loc4_:Date = this._name == null?param2 as Date:this.getSortFieldValue(param2) as Date;
         return ObjectUtil.dateCompare(_loc3_,_loc4_);
      }
      
      protected function stringCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:String = this._name == null?String(param1):String(this.getSortFieldValue(param1));
         var _loc4_:String = this._name == null?String(param2):String(this.getSortFieldValue(param2));
         return ObjectUtil.stringCompare(_loc3_,_loc4_,this._caseInsensitive);
      }
      
      protected function xmlCompare(param1:Object, param2:Object) : int
      {
         var _loc3_:String = this._name == null?param1.toString():this.getSortFieldValue(param1).toString();
         var _loc4_:String = this._name == null?param2.toString():this.getSortFieldValue(param2).toString();
         if(this.numeric == true)
         {
            return ObjectUtil.numericCompare(parseFloat(_loc3_),parseFloat(_loc4_));
         }
         return ObjectUtil.stringCompare(_loc3_,_loc4_,this._caseInsensitive);
      }
   }
}
