package spark.layouts
{
   import mx.core.IVisualElement;
   import spark.components.supportClasses.GroupBase;
   import spark.core.NavigationUnit;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class ViewMenuLayout extends LayoutBase
   {
       
      
      private var numColsInRow:Array;
      
      private var _horizontalGap:Number = 2;
      
      private var _verticalGap:Number = 2;
      
      private var _requestedMaxColumnCount:int = 3;
      
      private var rowHeight:Number = 0;
      
      public function ViewMenuLayout()
      {
         super();
      }
      
      [Bindable("propertyChange")]
      public function get horizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set horizontalGap(param1:Number) : void
      {
         if(param1 == this._horizontalGap)
         {
            return;
         }
         this._horizontalGap = param1;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Bindable("propertyChange")]
      public function get verticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function set verticalGap(param1:Number) : void
      {
         if(param1 == this._verticalGap)
         {
            return;
         }
         this._verticalGap = param1;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      public function get requestedMaxColumnCount() : int
      {
         return this._requestedMaxColumnCount;
      }
      
      public function set requestedMaxColumnCount(param1:int) : void
      {
         if(this._requestedMaxColumnCount == param1)
         {
            return;
         }
         this._requestedMaxColumnCount = param1;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      override public function measure() : void
      {
         var _loc8_:IVisualElement = null;
         super.measure();
         var _loc1_:GroupBase = target;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = _loc1_.numElements;
         var _loc3_:int = Math.ceil(_loc2_ / this.requestedMaxColumnCount);
         var _loc4_:int = Math.ceil(_loc2_ / _loc3_);
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_)
         {
            _loc8_ = _loc1_.getElementAt(_loc7_);
            _loc5_ = Math.max(_loc5_,_loc8_.getPreferredBoundsWidth());
            _loc6_ = Math.max(_loc6_,_loc8_.getPreferredBoundsHeight());
            _loc7_++;
         }
         _loc1_.measuredWidth = Math.ceil(_loc5_ * _loc4_) + (_loc4_ - 1) * this.horizontalGap;
         _loc1_.measuredHeight = Math.ceil(_loc6_ * _loc3_) + (_loc3_ - 1) * this.verticalGap;
         this.rowHeight = _loc6_;
      }
      
      override public function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:IVisualElement = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:GroupBase = target;
         if(!_loc3_)
         {
            return;
         }
         this.numColsInRow = [];
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = _loc3_.numElements;
         var _loc10_:int = Math.ceil(_loc9_ / this.requestedMaxColumnCount);
         var _loc11_:int = Math.ceil(_loc9_ / _loc10_);
         var _loc12_:int = _loc9_ % _loc11_ > 0?int(_loc11_ - _loc9_ % _loc11_):0;
         var _loc13_:int = 0;
         while(_loc13_ < _loc10_)
         {
            _loc14_ = _loc12_ > 0?int(_loc11_ - 1):int(_loc11_);
            _loc15_ = param1 - (_loc14_ - 1) * this.horizontalGap;
            _loc16_ = _loc7_ = Math.floor(_loc15_ / _loc14_);
            this.numColsInRow.push(_loc14_);
            _loc8_ = Math.round(_loc15_ - _loc16_ * _loc14_);
            _loc17_ = 0;
            while(_loc17_ < _loc14_)
            {
               _loc18_ = _loc3_.getElementAt(_loc6_);
               if(_loc8_ > 0)
               {
                  _loc7_ = _loc7_ + 1;
                  _loc8_--;
               }
               _loc18_.setLayoutBoundsPosition(_loc4_,_loc5_);
               _loc18_.setLayoutBoundsSize(_loc7_,this.rowHeight);
               _loc4_ = _loc4_ + (_loc7_ + this.horizontalGap);
               _loc7_ = _loc16_;
               _loc6_++;
               _loc17_++;
            }
            _loc4_ = 0;
            _loc5_ = _loc5_ + (this.rowHeight + this.verticalGap);
            _loc9_ = _loc9_ - _loc14_;
            _loc12_ = _loc9_ % _loc11_ > 0?int(_loc11_ - _loc9_ % _loc11_):0;
            _loc13_++;
         }
      }
      
      override public function getNavigationDestinationIndex(param1:int, param2:uint, param3:Boolean) : int
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!target || target.numElements < 1)
         {
            return -1;
         }
         var _loc4_:int = target.numElements - 1;
         var _loc5_:int = 0;
         var _loc6_:int = Math.ceil(target.numElements / this.requestedMaxColumnCount);
         if(param1 == -1)
         {
            if(param2 == NavigationUnit.RIGHT || param2 == NavigationUnit.DOWN)
            {
               return 0;
            }
            return -1;
         }
         var _loc7_:int = this.getRowForIndex(param1);
         if(param2 == NavigationUnit.LEFT || param2 == NavigationUnit.RIGHT)
         {
            _loc5_ = param1 + (param2 == NavigationUnit.LEFT?-1:1);
            if(this.getRowForIndex(_loc5_) != _loc7_)
            {
               _loc5_ = param1;
            }
         }
         else if(param2 == NavigationUnit.UP)
         {
            if(_loc7_ == 0)
            {
               return param1;
            }
            _loc8_ = this.numColsInRow[_loc7_];
            _loc9_ = this.numColsInRow[_loc7_ - 1];
            _loc5_ = param1 - _loc9_;
            if(this.getRowForIndex(_loc5_) != _loc7_ - 1 && _loc8_ != _loc9_)
            {
               _loc5_--;
            }
         }
         else if(param2 == NavigationUnit.DOWN)
         {
            if(_loc7_ == _loc6_ - 1)
            {
               return param1;
            }
            _loc5_ = param1 + this.numColsInRow[_loc7_];
         }
         if(_loc5_ > _loc4_)
         {
            _loc5_ = _loc4_;
         }
         else if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         return _loc5_;
      }
      
      private function getRowForIndex(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.numColsInRow.length)
         {
            param1 = param1 - this.numColsInRow[_loc2_];
            if(param1 >= 0)
            {
               _loc2_++;
               continue;
            }
            break;
         }
         return _loc2_;
      }
      
      private function invalidateTargetSizeAndDisplayList() : void
      {
         var _loc1_:GroupBase = target;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.invalidateSize();
         _loc1_.invalidateDisplayList();
      }
   }
}
