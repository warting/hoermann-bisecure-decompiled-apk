package flashx.textLayout.elements
{
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.TextFlowTableBlock;
   import flashx.textLayout.events.ModelChange;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class TableElement extends TableFormattedElement
   {
       
      
      private var _computedWidth:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      private var columns:Vector.<TableColElement>;
      
      private var rows:Vector.<TableRowElement>;
      
      private var damagedColumns:Vector.<TableColElement>;
      
      private var damageRows:Vector.<TableRowElement>;
      
      private var _hasCellDamage:Boolean = true;
      
      private var _headerRowCount:uint = 0;
      
      private var _footerRowCount:uint = 0;
      
      private var _tableRowsComputed:Boolean;
      
      private var _headerRows:Vector.<Vector.<TableCellElement>>;
      
      private var _footerRows:Vector.<Vector.<TableCellElement>>;
      
      private var _bodyRows:Vector.<Vector.<TableCellElement>>;
      
      private var _composedRowIndex:uint = 0;
      
      private var _tableBlocks:Vector.<TextFlowTableBlock>;
      
      private var _tableBlockIndex:uint = 0;
      
      private var _tableBlockDict:Dictionary;
      
      private var _leaf:TableLeafElement;
      
      private var _defaultRowFormat:ITextLayoutFormat;
      
      private var _defaultColumnFormat:ITextLayoutFormat;
      
      public function TableElement()
      {
         this.columns = new Vector.<TableColElement>();
         this.rows = new Vector.<TableRowElement>();
         this.damagedColumns = new Vector.<TableColElement>();
         this.damageRows = new Vector.<TableRowElement>();
         super();
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "table";
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return param1 is TableCellElement || param1 is TableRowElement || param1 is TableColElement;
      }
      
      override tlf_internal function modelChanged(param1:String, param2:FlowElement, param3:int, param4:int, param5:Boolean = true, param6:Boolean = true) : void
      {
         if(param1 != ModelChange.ELEMENT_ADDED)
         {
            if(param1 == ModelChange.ELEMENT_REMOVAL)
            {
               if(this.headerRowCount > 0 || this.footerRowCount > 0)
               {
               }
            }
         }
         super.modelChanged(param1,param2,param3,param4,param5,param6);
      }
      
      override public function set cellSpacing(param1:*) : void
      {
         this.markCellsDamaged();
         this.hasCellDamage = true;
         this.normalizeCells();
         super.cellSpacing = param1;
      }
      
      public function get numRows() : int
      {
         return this.rows.length;
      }
      
      public function get numColumns() : int
      {
         return this.columns.length;
      }
      
      public function get numCells() : int
      {
         return this.getCells().length;
      }
      
      public function set numRows(param1:int) : void
      {
         var _loc4_:TableRowElement = null;
         while(param1 < this.numRows)
         {
            this.rows.pop();
         }
         var _loc2_:int = this.numRows;
         var _loc3_:int = _loc2_;
         while(_loc3_ < param1)
         {
            _loc4_ = this.createRowElement(_loc3_,this.defaultRowFormat);
            this.rows.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function set numColumns(param1:int) : void
      {
         var _loc4_:TableColElement = null;
         while(param1 < this.numColumns)
         {
            this.columns.pop();
         }
         var _loc2_:int = this.numColumns;
         var _loc3_:int = _loc2_;
         while(_loc3_ < param1)
         {
            _loc4_ = this.createColumnElement(_loc3_,this.defaultColumnFormat);
            this.columns.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function get defaultRowFormat() : ITextLayoutFormat
      {
         if(!this._defaultRowFormat)
         {
            this._defaultRowFormat = new TextLayoutFormat(computedFormat);
         }
         return this._defaultRowFormat;
      }
      
      public function set defaultRowFormat(param1:ITextLayoutFormat) : void
      {
         this._defaultRowFormat = param1;
      }
      
      public function get defaultColumnFormat() : ITextLayoutFormat
      {
         if(!this._defaultColumnFormat)
         {
            this._defaultColumnFormat = new TextLayoutFormat(computedFormat);
         }
         return this._defaultColumnFormat;
      }
      
      public function set defaultColumnFormat(param1:ITextLayoutFormat) : void
      {
         this._defaultColumnFormat = param1;
      }
      
      override public function addChild(param1:FlowElement) : FlowElement
      {
         if(param1 is TableFormattedElement)
         {
            TableFormattedElement(param1).table = this;
         }
         super.addChild(param1);
         return param1;
      }
      
      override public function removeChild(param1:FlowElement) : FlowElement
      {
         super.removeChild(param1);
         if(param1 is TableFormattedElement)
         {
            TableFormattedElement(param1).table = null;
         }
         return param1;
      }
      
      public function addRow(param1:ITextLayoutFormat = null) : void
      {
         this.addRowAt(this.rows.length,param1);
      }
      
      public function addRowAt(param1:int, param2:ITextLayoutFormat = null) : void
      {
         if(param1 < 0 || param1 > this.rows.length)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
         }
         var _loc3_:TableRowElement = this.createRowElement(param1,param2);
         this.rows.splice(param1,0,_loc3_);
         _loc3_.composedHeight = _loc3_.computedFormat.minCellHeight;
         _loc3_.isMaxHeight = _loc3_.computedFormat.minCellHeight == _loc3_.computedFormat.maxCellHeight;
         _loc3_.setParentAndRelativeStartOnly(this,1);
      }
      
      public function addColumn(param1:ITextLayoutFormat = null) : void
      {
         this.addColumnAt(this.columns.length,param1);
      }
      
      public function addColumnAt(param1:int, param2:ITextLayoutFormat = null) : void
      {
         if(param1 < 0 || param1 > this.columns.length)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
         }
         if(!param2)
         {
            param2 = this.defaultColumnFormat;
         }
         var _loc3_:TableColElement = this.createColumnElement(param1,param2);
         this.columns.splice(param1,0,_loc3_);
      }
      
      public function getColumnAt(param1:int) : TableColElement
      {
         if(param1 < 0 || param1 >= this.numColumns)
         {
            return null;
         }
         return this.columns[param1];
      }
      
      public function getRowAt(param1:int) : TableRowElement
      {
         if(param1 < 0 || param1 >= this.numRows)
         {
            return null;
         }
         return this.rows[param1];
      }
      
      public function getRowIndex(param1:TableRowElement) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.rows.length)
         {
            if(this.rows[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getCellsForRow(param1:TableRowElement) : Vector.<TableCellElement>
      {
         return this.getCellsForRowAt(param1.rowIndex);
      }
      
      public function getCellsForRowArray(param1:TableRowElement) : Array
      {
         return this.getCellsForRowAtArray(param1.rowIndex);
      }
      
      public function getCellsForRowAt(param1:int) : Vector.<TableCellElement>
      {
         var _loc3_:TableCellElement = null;
         var _loc2_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         if(param1 < 0)
         {
            return _loc2_;
         }
         for each(_loc3_ in mxmlChildren)
         {
            if(_loc3_.rowIndex == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getCellsForRowAtArray(param1:int) : Array
      {
         var _loc3_:TableCellElement = null;
         var _loc2_:Array = [];
         if(param1 < 0)
         {
            return _loc2_;
         }
         for each(_loc3_ in mxmlChildren)
         {
            if(_loc3_.rowIndex == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getCellsForColumn(param1:TableColElement) : Vector.<TableCellElement>
      {
         if(this.columns.indexOf(param1) < 0)
         {
            return null;
         }
         return this.getCellsForColumnAt(param1.colIndex);
      }
      
      public function getCellsForColumnAt(param1:int) : Vector.<TableCellElement>
      {
         var _loc3_:TableCellElement = null;
         var _loc2_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         if(param1 < 0)
         {
            return _loc2_;
         }
         for each(_loc3_ in mxmlChildren)
         {
            if(_loc3_.colIndex == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function hasMergedCells() : Boolean
      {
         var _loc1_:TableCellElement = null;
         var _loc2_:* = undefined;
         if(mxmlChildren == null)
         {
            return false;
         }
         for each(_loc2_ in mxmlChildren)
         {
            _loc1_ = _loc2_ as TableCellElement;
            if(_loc1_ && (_loc1_.columnSpan > 1 || _loc1_.rowSpan > 1))
            {
               return true;
            }
         }
         return false;
      }
      
      public function insertColumn(param1:TableColElement = null, param2:Array = null) : Boolean
      {
         return this.insertColumnAt(this.numColumns,param1,param2);
      }
      
      public function insertColumnAt(param1:int, param2:TableColElement = null, param3:Array = null) : Boolean
      {
         var _loc7_:TableCellElement = null;
         if(param1 < 0 || param1 > this.columns.length)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
         }
         if(!param2)
         {
            param2 = this.createColumnElement(param1,this.defaultColumnFormat);
         }
         this.columns.splice(param1,0,param2);
         var _loc4_:Vector.<CellCoords> = this.getBlockedCoords(-1,param1);
         var _loc5_:int = this.getCellIndex(0,param1);
         if(_loc5_ < 0)
         {
            _loc5_ = numChildren;
         }
         var _loc6_:int = 0;
         if(param3 == null)
         {
            param3 = [];
         }
         while(param3.length < this.numRows)
         {
            param3.push(new TableCellElement());
         }
         for each(_loc7_ in param3)
         {
            while(_loc4_.length && _loc4_[0].row == _loc6_)
            {
               _loc6_++;
               _loc4_.shift();
            }
            _loc5_ = this.getCellIndex(_loc6_,param1);
            if(_loc5_ < 0)
            {
               _loc5_ = this.getCellIndex(_loc6_,param1 - 1);
               _loc5_++;
            }
            if(_loc6_ < this.numRows)
            {
               addChildAt(_loc5_,_loc7_);
            }
            _loc6_++;
         }
         return true;
      }
      
      public function insertRow(param1:TableRowElement = null, param2:Array = null) : Boolean
      {
         return this.insertRowAt(this.numRows,param1,param2);
      }
      
      public function insertRowAt(param1:int, param2:TableRowElement = null, param3:Array = null) : Boolean
      {
         var _loc6_:TableCellElement = null;
         if(param1 < 0 || param1 > this.rows.length)
         {
            throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
         }
         if(!param2)
         {
            param2 = this.createRowElement(param1,this.defaultRowFormat);
         }
         this.rows.splice(param1,0,param2);
         param2.composedHeight = param2.computedFormat.minCellHeight;
         param2.isMaxHeight = param2.computedFormat.minCellHeight == param2.computedFormat.maxCellHeight;
         var _loc4_:int = this.getCellIndex(param1,0);
         if(_loc4_ < 0)
         {
            _loc4_ = numChildren;
         }
         var _loc5_:int = 0;
         if(param3 == null)
         {
            param3 = [];
         }
         var _loc7_:int = 0;
         for each(_loc6_ in param3)
         {
            _loc7_ = _loc7_ + _loc6_.columnSpan;
         }
         while(_loc7_ < this.numColumns)
         {
            param3.push(new TableCellElement());
            _loc7_++;
         }
         for each(_loc6_ in param3)
         {
            if(_loc5_ < this.numColumns)
            {
               addChildAt(_loc4_++,_loc6_);
               _loc6_.damage();
            }
            _loc5_ = _loc5_ + (_loc6_.columnSpan - 1);
         }
         return true;
      }
      
      public function removeRow(param1:TableRowElement) : TableRowElement
      {
         var _loc2_:int = this.rows.indexOf(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.removeRowAt(_loc2_);
      }
      
      public function removeRowWithContent(param1:TableRowElement) : Array
      {
         var _loc2_:int = this.rows.indexOf(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.removeRowWithContentAt(_loc2_);
      }
      
      public function removeRowAt(param1:int) : TableRowElement
      {
         if(param1 < 0 || param1 > this.rows.length - 1)
         {
            return null;
         }
         var _loc2_:TableRowElement = TableRowElement(this.rows.splice(param1,1)[0]);
         this.normalizeCells();
         this.hasCellDamage = true;
         return _loc2_;
      }
      
      public function removeRowWithContentAt(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:TableCellElement = null;
         var _loc2_:Array = [];
         if(mxmlChildren)
         {
            _loc3_ = mxmlChildren.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = mxmlChildren[_loc3_];
               if(_loc4_ is TableCellElement)
               {
                  _loc5_ = _loc4_ as TableCellElement;
                  if(_loc5_.rowIndex == param1)
                  {
                     _loc2_.unshift(this.removeChild(_loc5_));
                  }
               }
               _loc3_--;
            }
         }
         this.removeRowAt(param1);
         return _loc2_;
      }
      
      public function removeAllRowsWithContent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.numRows > -1)
         {
            _loc1_ = this.numRows - 1;
            while(_loc1_ > -1)
            {
               this.removeRowWithContentAt(_loc1_--);
            }
         }
      }
      
      public function removeAllRows() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.numRows > -1)
         {
            _loc1_ = this.numRows;
            while(_loc3_ < _loc1_)
            {
               this.removeRowAt(_loc3_);
               _loc3_++;
            }
         }
      }
      
      public function removeColumn(param1:TableColElement) : TableColElement
      {
         var _loc2_:int = this.columns.indexOf(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.removeColumnAt(_loc2_);
      }
      
      public function removeColumnWithContent(param1:TableColElement) : Array
      {
         var _loc2_:int = this.columns.indexOf(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         return this.removeColumnWithContentAt(_loc2_);
      }
      
      public function removeColumnAt(param1:int) : TableColElement
      {
         if(param1 < 0 || param1 > this.columns.length - 1)
         {
            return null;
         }
         var _loc2_:TableColElement = this.columns.splice(param1,1)[0];
         this.normalizeCells();
         this.hasCellDamage = true;
         return _loc2_;
      }
      
      public function removeColumnWithContentAt(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:TableCellElement = null;
         var _loc2_:Array = [];
         if(mxmlChildren)
         {
            _loc3_ = mxmlChildren.length - 1;
            while(_loc3_ >= 0)
            {
               _loc4_ = mxmlChildren[_loc3_];
               if(_loc4_ is TableCellElement)
               {
                  _loc5_ = _loc4_ as TableCellElement;
                  if(_loc5_.colIndex == param1)
                  {
                     _loc2_.unshift(this.removeChild(_loc5_));
                  }
               }
               _loc3_--;
            }
         }
         this.removeColumnAt(param1);
         return _loc2_;
      }
      
      override tlf_internal function removed() : void
      {
         this.hasCellDamage = true;
      }
      
      private function getBlockedCoords(param1:int = -1, param2:int = -1) : Vector.<CellCoords>
      {
         var _loc4_:* = undefined;
         var _loc5_:TableCellElement = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:Vector.<CellCoords> = new Vector.<CellCoords>();
         if(mxmlChildren)
         {
            for each(_loc4_ in mxmlChildren)
            {
               _loc5_ = _loc4_ as TableCellElement;
               if(_loc5_ != null)
               {
                  if(!(_loc5_.columnSpan == 1 && _loc5_.rowSpan == 1))
                  {
                     _loc6_ = _loc5_.rowIndex;
                     if(!(param1 >= 0 && _loc6_ != param1))
                     {
                        if(!(param2 >= 0 && param2 != _loc7_))
                        {
                           _loc7_ = _loc5_.colIndex;
                           _loc8_ = _loc6_ + _loc5_.rowSpan - 1;
                           _loc9_ = _loc7_ + _loc5_.columnSpan - 1;
                           _loc10_ = _loc6_;
                           while(_loc10_ <= _loc8_)
                           {
                              _loc11_ = _loc7_;
                              while(_loc11_ <= _loc9_)
                              {
                                 if(!(_loc10_ == _loc6_ && _loc11_ == _loc7_))
                                 {
                                    _loc3_.push(new CellCoords(_loc11_,_loc10_));
                                 }
                                 _loc11_++;
                              }
                              _loc10_++;
                           }
                        }
                     }
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public function normalizeCells() : void
      {
         var _loc1_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:TableCellElement = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         this.numColumns;
         this.numRows;
         var _loc2_:Vector.<CellCoords> = new Vector.<CellCoords>();
         if(!mxmlChildren)
         {
            return;
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         loop0:
         for each(_loc5_ in mxmlChildren)
         {
            if(_loc5_ is TableCellElement)
            {
               _loc6_ = _loc5_ as TableCellElement;
               if(_loc6_.rowIndex != _loc3_ || _loc6_.colIndex != _loc4_)
               {
                  _loc6_.rowIndex = _loc3_;
                  _loc6_.colIndex = _loc4_;
                  _loc6_.damage();
               }
               _loc7_ = _loc3_ + _loc6_.rowSpan - 1;
               _loc8_ = _loc4_ + _loc6_.columnSpan - 1;
               _loc9_ = _loc3_;
               while(_loc9_ <= _loc7_)
               {
                  _loc10_ = _loc4_;
                  while(_loc10_ <= _loc8_)
                  {
                     if(!(_loc9_ == _loc3_ && _loc10_ == _loc4_))
                     {
                        _loc2_.push(new CellCoords(_loc10_,_loc9_));
                     }
                     _loc10_++;
                  }
                  _loc9_++;
               }
               while(true)
               {
                  _loc4_++;
                  if(_loc4_ >= this.numColumns)
                  {
                     _loc4_ = 0;
                     _loc3_++;
                  }
                  _loc11_ = true;
                  _loc1_ = 0;
                  while(_loc1_ < _loc2_.length)
                  {
                     if(_loc2_[_loc1_].column == _loc4_ && _loc2_[_loc1_].row == _loc3_)
                     {
                        _loc11_ = false;
                        _loc2_.splice(_loc1_,1);
                     }
                     _loc1_++;
                  }
                  if(_loc11_)
                  {
                     break;
                  }
                  if(!1)
                  {
                     continue loop0;
                  }
               }
            }
         }
      }
      
      public function setColumnWidth(param1:int, param2:*) : Boolean
      {
         var _loc3_:TableColElement = this.getColumnAt(param1);
         if(!_loc3_)
         {
            return false;
         }
         _loc3_.tableColumnWidth = param2;
         return true;
      }
      
      public function setRowHeight(param1:int, param2:*) : Boolean
      {
         var _loc3_:TableRowElement = this.getRowAt(param1);
         if(!_loc3_)
         {
            return false;
         }
         return true;
      }
      
      public function getColumnWidth(param1:int) : *
      {
         var _loc2_:TableColElement = this.getColumnAt(param1) as TableColElement;
         if(_loc2_)
         {
            return _loc2_.tableColumnWidth;
         }
         return 0;
      }
      
      public function composeCells() : void
      {
         var _loc2_:TableCellElement = null;
         var _loc3_:TableRowElement = null;
         var _loc4_:Number = NaN;
         var _loc5_:TableColElement = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Vector.<TableCellElement> = null;
         this.normalizeCells();
         this._composedRowIndex = 0;
         if(!this.hasCellDamage)
         {
            return;
         }
         var _loc1_:Vector.<TableCellElement> = this.getDamagedCells();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.compose();
         }
         for each(_loc3_ in this.rows)
         {
            _loc6_ = _loc3_.computedFormat.minCellHeight;
            _loc7_ = _loc3_.computedFormat.maxCellHeight;
            _loc3_.totalHeight = _loc3_.composedHeight = _loc6_;
            if(_loc7_ > _loc6_)
            {
               _loc3_.isMaxHeight = false;
            }
            else
            {
               _loc3_.isMaxHeight = true;
            }
         }
         _loc4_ = 0;
         for each(_loc5_ in this.columns)
         {
            _loc5_.x = _loc4_;
            _loc4_ = _loc4_ + _loc5_.columnWidth;
         }
         if(mxmlChildren)
         {
            _loc8_ = 0;
            while(_loc8_ < mxmlChildren.length)
            {
               if(mxmlChildren[_loc8_] is TableCellElement)
               {
                  _loc2_ = mxmlChildren[_loc8_] as TableCellElement;
                  while(this.rows.length < _loc2_.rowIndex + 1)
                  {
                     this.addRow(this.defaultRowFormat);
                  }
                  _loc3_ = this.getRowAt(_loc2_.rowIndex);
                  if(!_loc3_)
                  {
                     throw new Error("this should not happen...");
                  }
                  if(!_loc3_.isMaxHeight)
                  {
                     _loc9_ = _loc2_.getComposedHeight();
                     if(_loc2_.rowSpan > 1)
                     {
                        _loc3_.totalHeight = Math.max(_loc3_.totalHeight,_loc9_);
                     }
                     else
                     {
                        _loc3_.composedHeight = Math.max(_loc3_.composedHeight,_loc9_);
                        _loc3_.composedHeight = Math.min(_loc3_.composedHeight,_loc3_.computedFormat.maxCellHeight);
                        _loc3_.totalHeight = Math.max(_loc3_.composedHeight,_loc3_.totalHeight);
                     }
                     if(_loc3_.composedHeight == _loc3_.computedFormat.maxCellHeight)
                     {
                        _loc3_.isMaxHeight = true;
                     }
                  }
               }
               _loc8_++;
            }
         }
         if(!this._tableRowsComputed)
         {
            this._bodyRows = new Vector.<Vector.<TableCellElement>>();
            if(mxmlChildren)
            {
               _loc8_ = 0;
               while(_loc8_ < mxmlChildren.length)
               {
                  if(mxmlChildren[_loc8_] is TableCellElement)
                  {
                     _loc2_ = mxmlChildren[_loc8_] as TableCellElement;
                     while(_loc2_.rowIndex >= this._bodyRows.length)
                     {
                        this._bodyRows.push(new Vector.<TableCellElement>());
                     }
                     _loc10_ = this._bodyRows[_loc2_.rowIndex] as Vector.<TableCellElement>;
                     if(!_loc10_)
                     {
                        _loc10_ = new Vector.<TableCellElement>();
                        this._bodyRows[_loc2_.rowIndex] = _loc10_;
                     }
                     if(_loc10_.length > _loc2_.colIndex && _loc10_[_loc2_.colIndex])
                     {
                        throw new Error("Two cells cannot have the same coordinates");
                     }
                     _loc10_.push(_loc2_);
                  }
                  _loc8_++;
               }
            }
            if(this.headerRowCount > 0)
            {
               this._headerRows = this._bodyRows.splice(0,this.headerRowCount);
            }
            else
            {
               this._headerRows = null;
            }
            if(this.footerRowCount > 0)
            {
               this._footerRows = this._bodyRows.splice(-this.footerRowCount,Number.MAX_VALUE);
            }
            else
            {
               this._footerRows = null;
            }
         }
      }
      
      public function getHeaderRows() : Vector.<Vector.<TableCellElement>>
      {
         return this._headerRows;
      }
      
      public function getFooterRows() : Vector.<Vector.<TableCellElement>>
      {
         return this._footerRows;
      }
      
      public function getBodyRows() : Vector.<Vector.<TableCellElement>>
      {
         return this._bodyRows;
      }
      
      public function getNextRow() : Vector.<TableCellElement>
      {
         if(this._composedRowIndex >= this._bodyRows.length)
         {
            return null;
         }
         return this._bodyRows[this._composedRowIndex++];
      }
      
      public function getNextCell(param1:TableCellElement) : TableCellElement
      {
         var _loc2_:TableCellElement = null;
         var _loc3_:FlowElement = null;
         for each(_loc3_ in mxmlChildren)
         {
            _loc2_ = _loc3_ as TableCellElement;
            if(_loc2_)
            {
               if(_loc2_.rowIndex == param1.rowIndex && _loc2_.colIndex - 1 == param1.colIndex)
               {
                  return _loc2_;
               }
               if(_loc2_.rowIndex - 1 == param1.rowIndex && _loc2_.colIndex == 0)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function getPreviousCell(param1:TableCellElement) : TableCellElement
      {
         var _loc2_:TableCellElement = null;
         var _loc5_:FlowElement = null;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         for each(_loc5_ in mxmlChildren)
         {
            _loc2_ = _loc5_ as TableCellElement;
            if(_loc2_)
            {
               if(_loc2_.rowIndex == param1.rowIndex && _loc2_.colIndex + 1 == param1.colIndex)
               {
                  return _loc2_;
               }
               if(_loc2_.rowIndex + 1 == param1.rowIndex)
               {
                  _loc4_ = _loc2_.rowIndex;
                  if(_loc3_ < _loc2_.colIndex)
                  {
                     _loc3_ = _loc2_.colIndex;
                  }
               }
            }
         }
         if(_loc4_ > -1 && _loc3_ > -1)
         {
            return this.getCellAt(_loc4_,_loc3_);
         }
         return null;
      }
      
      public function getCellAt(param1:int, param2:int) : TableCellElement
      {
         var _loc3_:TableCellElement = null;
         var _loc4_:FlowElement = null;
         for each(_loc4_ in mxmlChildren)
         {
            _loc3_ = _loc4_ as TableCellElement;
            if(_loc3_ && _loc3_.rowIndex == param1 && _loc3_.colIndex == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getHeaderHeight() : Number
      {
         return 0;
      }
      
      public function getFooterHeight() : Number
      {
         return 0;
      }
      
      public function normalizeColumnWidths(param1:Number = 600) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:TableColElement = null;
         var _loc6_:Number = NaN;
         var _loc2_:* = computedFormat.columnCount;
         if(_loc2_)
         {
            if(_loc2_ != FormatValue.AUTO)
            {
               _loc6_ = computedFormat.columnCount;
            }
         }
         while(_loc6_ > this.columns.length)
         {
            this.addColumn();
         }
         switch(typeof computedFormat.tableWidth)
         {
            case "number":
               _loc3_ = param1;
               break;
            case "string":
               if(computedFormat.tableWidth.indexOf("%") > 0)
               {
                  _loc3_ = param1 / (parseFloat(computedFormat.tableWidth) / 100);
                  break;
               }
            default:
               _loc3_ = param1;
         }
         if(isNaN(_loc3_))
         {
            _loc3_ = 600;
         }
         if(_loc3_ > 20000)
         {
            _loc3_ = 600;
         }
         this._computedWidth = _loc3_;
         var _loc4_:int = this.numColumns;
         for each(_loc5_ in this.columns)
         {
            if(typeof _loc5_.columnWidth == "number")
            {
               _loc3_ = _loc3_ - _loc5_.columnWidth;
               _loc4_--;
            }
         }
         for each(_loc5_ in this.columns)
         {
            if(typeof _loc5_.columnWidth != "number")
            {
               _loc5_.columnWidth = _loc3_ / _loc4_;
            }
         }
      }
      
      private function getDamagedCells() : Vector.<TableCellElement>
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         for each(_loc2_ in this.mxmlChildren)
         {
            if(_loc2_ is TableCellElement && _loc2_.isDamaged())
            {
               _loc1_.push(_loc2_ as TableCellElement);
            }
         }
         return _loc1_;
      }
      
      private function markCellsDamaged() : void
      {
         var _loc1_:* = undefined;
         if(!mxmlChildren)
         {
            return;
         }
         for each(_loc1_ in this.mxmlChildren)
         {
            if(_loc1_ is TableCellElement)
            {
               _loc1_.damage();
            }
         }
      }
      
      public function getCells() : Vector.<TableCellElement>
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         for each(_loc2_ in mxmlChildren)
         {
            if(_loc2_ is TableCellElement)
            {
               _loc1_.push(_loc2_ as TableCellElement);
            }
         }
         return _loc1_;
      }
      
      public function getCellsArray() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in mxmlChildren)
         {
            if(_loc2_ is TableCellElement)
            {
               _loc1_.push(_loc2_ as TableCellElement);
            }
         }
         return _loc1_;
      }
      
      public function get width() : Number
      {
         return this._computedWidth;
      }
      
      public function set width(param1:*) : void
      {
         this.normalizeColumnWidths(param1);
      }
      
      public function get hasCellDamage() : Boolean
      {
         return this._hasCellDamage;
      }
      
      public function set hasCellDamage(param1:Boolean) : void
      {
         this._hasCellDamage = param1;
      }
      
      public function get headerRowCount() : uint
      {
         return this._headerRowCount;
      }
      
      public function set headerRowCount(param1:uint) : void
      {
         if(param1 != this._headerRowCount)
         {
            this._tableRowsComputed = false;
         }
         this._headerRowCount = param1;
      }
      
      public function get footerRowCount() : uint
      {
         return this._footerRowCount;
      }
      
      public function set footerRowCount(param1:uint) : void
      {
         if(param1 != this._footerRowCount)
         {
            this._tableRowsComputed = false;
         }
         this._footerRowCount = param1;
      }
      
      public function getFirstBlock() : TextFlowTableBlock
      {
         if(this._tableBlocks == null)
         {
            this._tableBlocks = new Vector.<TextFlowTableBlock>();
         }
         if(this._tableBlocks.length == 0)
         {
            this._tableBlocks.push(new TextFlowTableBlock(0));
         }
         this._tableBlockIndex = 0;
         this._tableBlocks[0].parentTable = this;
         return this._tableBlocks[0];
      }
      
      public function getNextBlock() : TextFlowTableBlock
      {
         if(this._tableBlocks == null)
         {
            this._tableBlocks = new Vector.<TextFlowTableBlock>();
         }
         this._tableBlockIndex++;
         while(this._tableBlocks.length <= this._tableBlockIndex)
         {
            this._tableBlocks.push(new TextFlowTableBlock(this._tableBlocks.length));
         }
         this._tableBlocks[this._tableBlockIndex].parentTable = this;
         return this._tableBlocks[this._tableBlockIndex];
      }
      
      override public function get textLength() : int
      {
         return 1;
      }
      
      private function getCellIndex(param1:int, param2:int) : int
      {
         var _loc4_:* = undefined;
         var _loc5_:TableCellElement = null;
         if(param1 == 0 && param2 == 0)
         {
            return 0;
         }
         var _loc3_:int = 0;
         while(_loc3_ < mxmlChildren.length)
         {
            _loc4_ = mxmlChildren[_loc3_];
            if(_loc4_ is TableCellElement)
            {
               _loc5_ = _loc4_ as TableCellElement;
               if(_loc5_.rowIndex == param1 && _loc5_.colIndex == param2)
               {
                  return _loc3_;
               }
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function getCellsInRange(param1:CellCoordinates, param2:CellCoordinates, param3:TextFlowTableBlock = null) : Vector.<TableCellElement>
      {
         var _loc9_:int = 0;
         var _loc10_:TableCellElement = null;
         var _loc4_:CellCoordinates = param1.clone();
         var _loc5_:CellCoordinates = param2.clone();
         if(_loc5_.row < _loc4_.row || _loc5_.row == _loc4_.row && _loc5_.column < _loc4_.column)
         {
            _loc4_ = param2.clone();
            _loc5_ = param1.clone();
         }
         if(_loc5_.column < _loc4_.column)
         {
            _loc9_ = _loc4_.column;
            _loc4_.column = _loc5_.column;
            _loc5_.column = _loc9_;
         }
         var _loc6_:TableCellElement = this.findCell(_loc4_);
         var _loc7_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         if(!param3 || this.getCellBlock(_loc6_) == param3)
         {
            _loc7_.push(_loc6_);
         }
         var _loc8_:int = mxmlChildren.indexOf(_loc6_);
         while(++_loc8_ < mxmlChildren.length)
         {
            _loc10_ = mxmlChildren[_loc8_];
            if(_loc10_.rowIndex > _loc5_.row || _loc10_.rowIndex == _loc5_.row && _loc10_.colIndex > _loc5_.column)
            {
               break;
            }
            if(!(_loc10_.colIndex > _loc5_.column || _loc10_.colIndex < _loc4_.column))
            {
               if(!param3 || this.getCellBlock(_loc10_) == param3)
               {
                  _loc7_.push(_loc10_);
               }
            }
         }
         return _loc7_;
      }
      
      public function findCell(param1:CellCoordinates) : TableCellElement
      {
         var _loc4_:TableCellElement = null;
         var _loc5_:TableCellElement = null;
         var _loc2_:int = (param1.row + 1) * (param1.column + 1) - 1;
         if(_loc2_ >= numChildren)
         {
            _loc2_ = numChildren - 1;
         }
         var _loc3_:TableCellElement = mxmlChildren[_loc2_];
         while(_loc2_ != numChildren - 1)
         {
            _loc4_ = mxmlChildren[_loc2_ + 1];
            if(_loc4_.rowIndex > param1.row || _loc4_.rowIndex == param1.row && _loc4_.colIndex > param1.column)
            {
               break;
            }
            _loc3_ = _loc4_;
            _loc2_++;
         }
         while(!(_loc3_.colIndex <= param1.column && _loc3_.colIndex + _loc3_.columnSpan - 1 >= param1.column && _loc3_.rowIndex <= param1.row && _loc3_.rowIndex + _loc3_.rowSpan - 1 >= param1.row))
         {
            if(_loc3_.colIndex == 0 && _loc3_.rowIndex == 0)
            {
               break;
            }
            if(_loc2_ == 0)
            {
               break;
            }
            _loc5_ = mxmlChildren[_loc2_ - 1];
            _loc3_ = _loc5_;
            _loc2_--;
         }
         return _loc3_;
      }
      
      public function addCellToBlock(param1:TableCellElement, param2:TextFlowTableBlock) : void
      {
         param2.addCell(param1.container);
         this.tableBlockDict[param1] = param2;
      }
      
      public function getCellBlock(param1:TableCellElement) : TextFlowTableBlock
      {
         return this.tableBlockDict[param1];
      }
      
      private function get tableBlockDict() : Dictionary
      {
         if(this._tableBlockDict == null)
         {
            this._tableBlockDict = new Dictionary();
         }
         return this._tableBlockDict;
      }
      
      public function get tableBlocks() : Vector.<TextFlowTableBlock>
      {
         return this._tableBlocks;
      }
      
      public function getTableBlocksInRange(param1:CellCoordinates, param2:CellCoordinates) : Vector.<TextFlowTableBlock>
      {
         var _loc3_:CellCoordinates = param1.clone();
         if(param2.column < param1.column)
         {
            _loc3_ = param2.clone();
            param2 = param1.clone();
         }
         var _loc4_:Vector.<TextFlowTableBlock> = new Vector.<TextFlowTableBlock>();
         var _loc5_:TextFlowTableBlock = this.getCellBlock(this.findCell(_loc3_));
         if(_loc5_)
         {
            _loc4_.push(_loc5_);
         }
         while(_loc5_)
         {
            _loc3_.row++;
            if(_loc3_.row > param2.row)
            {
               break;
            }
            if(this.getCellBlock(this.findCell(_loc3_)) != _loc5_)
            {
               _loc5_ = this.getCellBlock(this.findCell(_loc3_));
               if(_loc5_)
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         return _loc4_;
      }
      
      override tlf_internal function getNextLeafHelper(param1:FlowGroupElement, param2:FlowElement) : FlowLeafElement
      {
         return parent.getNextLeafHelper(param1,this);
      }
      
      override tlf_internal function getPreviousLeafHelper(param1:FlowGroupElement, param2:FlowElement) : FlowLeafElement
      {
         return parent.getPreviousLeafHelper(param1,this);
      }
      
      private function getLeaf() : TableLeafElement
      {
         if(this._leaf == null)
         {
            this._leaf = new TableLeafElement(this);
         }
         return this._leaf;
      }
      
      override public function findLeaf(param1:int) : FlowLeafElement
      {
         return this.getLeaf();
      }
      
      override public function getLastLeaf() : FlowLeafElement
      {
         return this.getLeaf();
      }
      
      override public function getFirstLeaf() : FlowLeafElement
      {
         return this.getLeaf();
      }
      
      override tlf_internal function createContentElement() : void
      {
      }
      
      override tlf_internal function releaseContentElement() : void
      {
      }
      
      tlf_internal function createRowElement(param1:int, param2:ITextLayoutFormat) : TableRowElement
      {
         var _loc3_:TableRowElement = new TableRowElement(param2);
         _loc3_.rowIndex = param1;
         _loc3_.table = this;
         return _loc3_;
      }
      
      tlf_internal function createColumnElement(param1:int, param2:ITextLayoutFormat) : TableColElement
      {
         var _loc3_:TableColElement = new TableColElement(param2);
         _loc3_.colIndex = param1;
         _loc3_.table = this;
         return _loc3_;
      }
      
      override tlf_internal function normalizeRange(param1:uint, param2:uint) : void
      {
      }
   }
}

class CellCoords
{
    
   
   public var column:int;
   
   public var row:int;
   
   function CellCoords(param1:int, param2:int)
   {
      super();
      this.column = param1;
      this.row = param2;
   }
}
