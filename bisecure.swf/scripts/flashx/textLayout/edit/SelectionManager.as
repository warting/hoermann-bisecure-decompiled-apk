package flashx.textLayout.edit
{
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IMEEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.text.engine.TextRotation;
   import flash.ui.ContextMenu;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.ui.MouseCursorData;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.compose.TextFlowTableBlock;
   import flashx.textLayout.container.ColumnState;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.CellContainer;
   import flashx.textLayout.elements.CellCoordinates;
   import flashx.textLayout.elements.CellRange;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TableCellElement;
   import flashx.textLayout.elements.TableColElement;
   import flashx.textLayout.elements.TableElement;
   import flashx.textLayout.elements.TableRowElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.operations.CopyOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.NavigationUtil;
   
   use namespace tlf_internal;
   
   public class SelectionManager implements ISelectionManager
   {
      
      tlf_internal static var useTableSelectionCursors:Boolean = false;
      
      public static var SelectTable:String = "selectTable";
      
      public static var SelectTableRow:String = "selectTableRow";
      
      public static var SelectTableColumn:String = "selectTableColumn";
       
      
      private var _focusedSelectionFormat:SelectionFormat;
      
      private var _unfocusedSelectionFormat:SelectionFormat;
      
      private var _inactiveSelectionFormat:SelectionFormat;
      
      private var _focusedCellSelectionFormat:SelectionFormat;
      
      private var _unfocusedCellSelectionFormat:SelectionFormat;
      
      private var _inactiveCellSelectionFormat:SelectionFormat;
      
      private var _selFormatState:String = "unfocused";
      
      private var _isActive:Boolean;
      
      private var _textFlow:TextFlow;
      
      protected var _subManager:ISelectionManager;
      
      protected var _superManager:ISelectionManager;
      
      private var _currentTable:TableElement;
      
      private var _cellRange:CellRange;
      
      private var anchorMark:Mark;
      
      private var activeMark:Mark;
      
      private var _anchorCellPosition:CellCoordinates;
      
      private var _activeCellPosition:CellCoordinates;
      
      private var _pointFormat:ITextLayoutFormat;
      
      protected var ignoreNextTextEvent:Boolean = false;
      
      protected var allowOperationMerge:Boolean = false;
      
      private var _mouseOverSelectionArea:Boolean = false;
      
      private var marks:Array;
      
      private var cellMarks:Array;
      
      public var selectTableCursorPoints:Vector.<Number>;
      
      public var selectTableCursorDrawCommands:Vector.<int>;
      
      public function SelectionManager()
      {
         this.marks = [];
         this.cellMarks = [];
         this.selectTableCursorPoints = new <Number>[1,3,11,3,11,0,12,0,16,4,12,8,11,8,11,5,1,5,1,3];
         this.selectTableCursorDrawCommands = new <int>[1,2,2,2,2,2,2,2,2,2];
         super();
         this._textFlow = null;
         this.anchorMark = this.createMark();
         this.activeMark = this.createMark();
         this.anchorCellPosition = this.createCellMark();
         this.activeCellPosition = this.createCellMark();
         this._pointFormat = null;
         this._isActive = false;
         Mouse.registerCursor(SelectTable,this.createSelectTableCursor());
         Mouse.registerCursor(SelectTableRow,this.createSelectTableRowCursor());
         Mouse.registerCursor(SelectTableColumn,this.createSelectTableColumnCursor());
      }
      
      private static function computeSelectionIndexInContainer(param1:TextFlow, param2:ContainerController, param3:Number, param4:Number) : int
      {
         var _loc5_:int = 0;
         var _loc17_:TextFlowLine = null;
         var _loc18_:TextLine = null;
         var _loc21_:Rectangle = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Boolean = false;
         var _loc25_:Number = NaN;
         var _loc26_:Boolean = false;
         var _loc27_:TextLine = null;
         var _loc28_:Boolean = false;
         var _loc29_:int = 0;
         var _loc30_:Rectangle = null;
         var _loc31_:int = 0;
         var _loc32_:String = null;
         var _loc6_:int = -1;
         var _loc7_:int = param2.absoluteStart;
         var _loc8_:int = param2.textLength;
         var _loc9_:String = param1.computedFormat.blockProgression;
         var _loc10_:* = _loc9_ == BlockProgression.RL;
         var _loc11_:* = param1.computedFormat.direction == Direction.RTL;
         var _loc12_:Number = !!_loc10_?Number(param3):Number(param4);
         var _loc13_:int = locateNearestColumn(param2,param3,param4,param1.computedFormat.blockProgression,param1.computedFormat.direction);
         var _loc14_:Rectangle = null;
         var _loc15_:int = -1;
         var _loc16_:int = -1;
         var _loc19_:int = param1.flowComposer.numLines - 1;
         while(_loc19_ >= 0)
         {
            _loc17_ = param1.flowComposer.getLineAt(_loc19_);
            if(_loc17_.controller != param2 || _loc17_.columnIndex != _loc13_)
            {
               if(_loc16_ != -1)
               {
                  _loc6_ = _loc19_ + 1;
                  break;
               }
            }
            else if(!(_loc17_.absoluteStart < _loc7_ || _loc17_.absoluteStart >= _loc7_ + _loc8_))
            {
               _loc18_ = _loc17_.getTextLine();
               if(!(_loc18_ == null || _loc18_.parent == null))
               {
                  if(_loc16_ == -1)
                  {
                     _loc16_ = _loc19_;
                  }
                  _loc21_ = _loc18_.getBounds(DisplayObject(param2.container));
                  _loc22_ = !!_loc10_?Number(_loc21_.left):Number(_loc21_.bottom);
                  _loc23_ = -1;
                  if(_loc14_)
                  {
                     _loc25_ = !!_loc10_?Number(_loc14_.right):Number(_loc14_.top);
                     _loc23_ = (_loc22_ + _loc25_) / 2;
                  }
                  _loc24_ = !!_loc10_?_loc22_ > _loc12_:_loc22_ < _loc12_;
                  if(_loc24_ || _loc19_ == 0)
                  {
                     _loc26_ = _loc23_ != -1 && (!!_loc10_?_loc12_ < _loc23_:_loc12_ > _loc23_);
                     _loc6_ = _loc26_ && _loc19_ != _loc16_?int(_loc19_ + 1):int(_loc19_);
                     break;
                  }
                  _loc14_ = _loc21_;
                  _loc15_ = _loc19_;
               }
            }
            _loc19_--;
         }
         if(_loc6_ == -1)
         {
            _loc6_ = _loc15_;
            if(_loc6_ == -1)
            {
               return -1;
            }
         }
         var _loc20_:TextFlowLine = param1.flowComposer.getLineAt(_loc6_);
         if(_loc20_ is TextFlowTableBlock)
         {
            _loc5_ = TextFlowTableBlock(_loc20_).absoluteStart;
         }
         else
         {
            _loc27_ = _loc20_.getTextLine(true);
            param3 = param3 - _loc27_.x;
            param4 = param4 - _loc27_.y;
            _loc28_ = false;
            _loc29_ = -1;
            if(_loc11_)
            {
               _loc29_ = _loc27_.atomCount - 1;
            }
            else if(_loc20_.absoluteStart + _loc20_.textLength >= _loc20_.paragraph.getAbsoluteStart() + _loc20_.paragraph.textLength)
            {
               if(_loc27_.atomCount > 1)
               {
                  _loc29_ = _loc27_.atomCount - 2;
               }
            }
            else
            {
               _loc31_ = _loc20_.absoluteStart + _loc20_.textLength - 1;
               _loc32_ = _loc27_.textBlock.content.rawText.charAt(_loc31_);
               if(_loc32_ == " ")
               {
                  if(_loc27_.atomCount > 1)
                  {
                     _loc29_ = _loc27_.atomCount - 2;
                  }
               }
               else
               {
                  _loc28_ = true;
                  if(_loc27_.atomCount > 0)
                  {
                     _loc29_ = _loc27_.atomCount - 1;
                  }
               }
            }
            _loc30_ = _loc29_ > 0?_loc27_.getAtomBounds(_loc29_):new Rectangle(0,0,0,0);
            if(!_loc10_)
            {
               if(param3 < 0)
               {
                  param3 = 0;
               }
               else if(param3 > _loc30_.x + _loc30_.width)
               {
                  if(_loc28_)
                  {
                     return _loc20_.absoluteStart + _loc20_.textLength - 1;
                  }
                  if(_loc30_.x + _loc30_.width > 0)
                  {
                     param3 = _loc30_.x + _loc30_.width;
                  }
               }
            }
            else if(param4 < 0)
            {
               param4 = 0;
            }
            else if(param4 > _loc30_.y + _loc30_.height)
            {
               if(_loc28_)
               {
                  return _loc20_.absoluteStart + _loc20_.textLength - 1;
               }
               if(_loc30_.y + _loc30_.height > 0)
               {
                  param4 = _loc30_.y + _loc30_.height;
               }
            }
            _loc5_ = computeSelectionIndexInLine(param1,_loc27_,param3,param4);
         }
         return _loc5_ != -1?int(_loc5_):int(_loc7_ + _loc8_);
      }
      
      private static function locateNearestColumn(param1:ContainerController, param2:Number, param3:Number, param4:String, param5:String) : int
      {
         var _loc8_:Rectangle = null;
         var _loc9_:Rectangle = null;
         var _loc6_:int = 0;
         var _loc7_:ColumnState = param1.columnState;
         while(_loc6_ < _loc7_.columnCount - 1)
         {
            _loc8_ = _loc7_.getColumnAt(_loc6_);
            _loc9_ = _loc7_.getColumnAt(_loc6_ + 1);
            if(_loc8_.contains(param2,param3))
            {
               break;
            }
            if(_loc9_.contains(param2,param3))
            {
               _loc6_++;
               break;
            }
            if(param4 == BlockProgression.RL)
            {
               if(param3 < _loc8_.top || param3 < _loc9_.top && Math.abs(_loc8_.bottom - param3) <= Math.abs(_loc9_.top - param3))
               {
                  break;
               }
               if(param3 > _loc9_.top)
               {
                  _loc6_++;
                  break;
               }
            }
            else if(param5 == Direction.LTR)
            {
               if(param2 < _loc8_.left || param2 < _loc9_.left && Math.abs(_loc8_.right - param2) <= Math.abs(_loc9_.left - param2))
               {
                  break;
               }
               if(param2 < _loc9_.left)
               {
                  _loc6_++;
                  break;
               }
            }
            else
            {
               if(param2 > _loc8_.right || param2 > _loc9_.right && Math.abs(_loc8_.left - param2) <= Math.abs(_loc9_.right - param2))
               {
                  break;
               }
               if(param2 > _loc9_.right)
               {
                  _loc6_++;
                  break;
               }
            }
            _loc6_++;
         }
         return _loc6_;
      }
      
      private static function computeSelectionIndexInLine(param1:TextFlow, param2:TextLine, param3:Number, param4:Number) : int
      {
         var _loc12_:int = 0;
         if(!(param2.userData is TextFlowLine))
         {
            return -1;
         }
         var _loc5_:TextFlowLine = TextFlowLine(param2.userData);
         if(_loc5_.validity == TextLineValidity.INVALID)
         {
            return -1;
         }
         param2 = _loc5_.getTextLine(true);
         var _loc6_:* = param1.computedFormat.blockProgression == BlockProgression.RL;
         var _loc7_:Number = !!_loc6_?Number(param3):Number(param4);
         var _loc8_:Point = new Point();
         _loc8_.x = param3;
         _loc8_.y = param4;
         _loc8_ = param2.localToGlobal(_loc8_);
         var _loc9_:int = param2.getAtomIndexAtPoint(_loc8_.x,_loc8_.y);
         if(_loc9_ == -1)
         {
            _loc8_.x = param3;
            _loc8_.y = param4;
            if(_loc8_.x < 0 || _loc6_ && _loc7_ > param2.ascent)
            {
               _loc8_.x = 0;
            }
            if(_loc8_.y < 0 || !_loc6_ && _loc7_ > param2.descent)
            {
               _loc8_.y = 0;
            }
            _loc8_ = param2.localToGlobal(_loc8_);
            _loc9_ = param2.getAtomIndexAtPoint(_loc8_.x,_loc8_.y);
         }
         if(_loc9_ == -1)
         {
            _loc8_.x = param3;
            _loc8_.y = param4;
            _loc8_ = param2.localToGlobal(_loc8_);
            if(param2.parent)
            {
               _loc8_ = param2.parent.globalToLocal(_loc8_);
            }
            if(!_loc6_)
            {
               return _loc8_.x <= param2.x?int(_loc5_.absoluteStart):int(_loc5_.absoluteStart + _loc5_.textLength - 1);
            }
            return _loc8_.y <= param2.y?int(_loc5_.absoluteStart):int(_loc5_.absoluteStart + _loc5_.textLength - 1);
         }
         var _loc10_:Rectangle = param2.getAtomBounds(_loc9_);
         var _loc11_:* = false;
         if(_loc10_)
         {
            if(_loc6_ && param2.getAtomTextRotation(_loc9_) != TextRotation.ROTATE_0)
            {
               _loc11_ = param4 > _loc10_.y + _loc10_.height / 2;
            }
            else
            {
               _loc11_ = param3 > _loc10_.x + _loc10_.width / 2;
            }
         }
         if(param2.getAtomBidiLevel(_loc9_) % 2 != 0)
         {
            _loc12_ = !!_loc11_?int(param2.getAtomTextBlockBeginIndex(_loc9_)):int(param2.getAtomTextBlockEndIndex(_loc9_));
         }
         else
         {
            _loc12_ = !!_loc11_?int(param2.getAtomTextBlockEndIndex(_loc9_)):int(param2.getAtomTextBlockBeginIndex(_loc9_));
         }
         return _loc5_.paragraph.getTextBlockAbsoluteStart(param2.textBlock) + _loc12_;
      }
      
      private static function checkForDisplayed(param1:DisplayObject) : Boolean
      {
         var container:DisplayObject = param1;
         try
         {
            while(container)
            {
               if(!container.visible)
               {
                  return false;
               }
               container = container.parent;
               if(container is Stage)
               {
                  return true;
               }
            }
         }
         catch(e:Error)
         {
            return true;
         }
         return false;
      }
      
      private static function findController(param1:TextFlow, param2:Object, param3:Object, param4:Point) : ContainerController
      {
         var _loc7_:ContainerController = null;
         var _loc8_:Point = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc16_:ContainerController = null;
         var _loc17_:ContainerController = null;
         var _loc18_:Rectangle = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc5_:Number = param4.x;
         var _loc6_:Number = param4.y;
         var _loc9_:Point = DisplayObject(param2).localToGlobal(new Point(_loc5_,_loc6_));
         var _loc10_:int = 0;
         while(_loc10_ < param1.flowComposer.numControllers)
         {
            _loc16_ = param1.flowComposer.getControllerAt(_loc10_);
            if(_loc16_.container == param2 || _loc16_.container == param3)
            {
               _loc7_ = _loc16_;
               break;
            }
            _loc10_++;
         }
         if(_loc7_)
         {
            if(param2 != _loc7_.container)
            {
               _loc8_ = DisplayObject(_loc7_.container).globalToLocal(_loc9_);
               param4.x = _loc8_.x;
               param4.y = _loc8_.y;
            }
            return _loc7_;
         }
         var _loc11_:ContainerController = null;
         var _loc14_:Number = Number.MAX_VALUE;
         var _loc15_:int = 0;
         while(_loc15_ < param1.flowComposer.numControllers)
         {
            _loc17_ = param1.flowComposer.getControllerAt(_loc15_);
            if(checkForDisplayed(_loc17_.container as DisplayObject))
            {
               _loc18_ = _loc17_.getContentBounds();
               _loc19_ = !!isNaN(_loc17_.compositionWidth)?Number(_loc17_.getTotalPaddingLeft() + _loc18_.width):Number(_loc17_.compositionWidth);
               _loc20_ = !!isNaN(_loc17_.compositionHeight)?Number(_loc17_.getTotalPaddingTop() + _loc18_.height):Number(_loc17_.compositionHeight);
               _loc8_ = DisplayObject(_loc17_.container).globalToLocal(_loc9_);
               _loc21_ = 0;
               _loc22_ = 0;
               if(_loc17_.hasScrollRect)
               {
                  _loc8_.x = _loc8_.x - (_loc21_ = _loc17_.container.scrollRect.x);
                  _loc8_.y = _loc8_.y - (_loc22_ = _loc17_.container.scrollRect.y);
               }
               if(_loc8_.x >= 0 && _loc8_.x <= _loc19_ && _loc8_.y >= 0 && _loc8_.y <= _loc20_)
               {
                  _loc11_ = _loc17_;
                  _loc12_ = _loc8_.x + _loc21_;
                  _loc13_ = _loc8_.y + _loc22_;
                  break;
               }
               _loc23_ = 0;
               _loc24_ = 0;
               if(_loc8_.x < 0)
               {
                  _loc23_ = _loc8_.x;
                  if(_loc8_.y < 0)
                  {
                     _loc24_ = _loc8_.y;
                  }
                  else if(_loc8_.y > _loc20_)
                  {
                     _loc24_ = _loc8_.y - _loc20_;
                  }
               }
               else if(_loc8_.x > _loc19_)
               {
                  _loc23_ = _loc8_.x - _loc19_;
                  if(_loc8_.y < 0)
                  {
                     _loc24_ = _loc8_.y;
                  }
                  else if(_loc8_.y > _loc20_)
                  {
                     _loc24_ = _loc8_.y - _loc20_;
                  }
               }
               else if(_loc8_.y < 0)
               {
                  _loc24_ = -_loc8_.y;
               }
               else
               {
                  _loc24_ = _loc8_.y - _loc20_;
               }
               _loc25_ = _loc23_ * _loc23_ + _loc24_ * _loc24_;
               if(_loc25_ <= _loc14_)
               {
                  _loc14_ = _loc25_;
                  _loc11_ = _loc17_;
                  _loc12_ = _loc8_.x + _loc21_;
                  _loc13_ = _loc8_.y + _loc22_;
               }
            }
            _loc15_++;
         }
         param4.x = _loc12_;
         param4.y = _loc13_;
         return _loc11_;
      }
      
      tlf_internal static function computeCellCoordinates(param1:TextFlow, param2:Object, param3:Object, param4:Number, param5:Number) : CellCoordinates
      {
         var _loc6_:CellCoordinates = null;
         var _loc7_:Point = null;
         var _loc10_:TableCellElement = null;
         if(param2 is TextLine)
         {
            return null;
         }
         if(param2 is CellContainer)
         {
            _loc10_ = (param2 as CellContainer).element;
            return new CellCoordinates(_loc10_.rowIndex,_loc10_.colIndex,_loc10_.getTable());
         }
         var _loc8_:Point = new Point(param4,param5);
         var _loc9_:ContainerController = findController(param1,param2,param3,_loc8_);
         if(!_loc9_)
         {
            return null;
         }
         return _loc9_.findCellAtPosition(_loc8_);
      }
      
      tlf_internal static function computeSelectionIndex(param1:TextFlow, param2:Object, param3:Object, param4:Number, param5:Number) : int
      {
         var _loc7_:Point = null;
         var _loc9_:TextFlowLine = null;
         var _loc10_:ParagraphElement = null;
         var _loc11_:Point = null;
         var _loc12_:ContainerController = null;
         var _loc6_:int = 0;
         var _loc8_:Boolean = false;
         if(param2 is TextLine)
         {
            _loc9_ = TextLine(param2).userData as TextFlowLine;
            if(_loc9_)
            {
               _loc10_ = _loc9_.paragraph;
               if(_loc10_.getTextFlow() == param1)
               {
                  _loc8_ = true;
               }
            }
         }
         if(_loc8_)
         {
            _loc6_ = computeSelectionIndexInLine(param1,TextLine(param2),param4,param5);
         }
         else
         {
            _loc11_ = new Point(param4,param5);
            _loc12_ = findController(param1,param2,param3,_loc11_);
            _loc6_ = !!_loc12_?int(computeSelectionIndexInContainer(param1,_loc12_,_loc11_.x,_loc11_.y)):-1;
         }
         if(_loc6_ >= param1.textLength)
         {
            _loc6_ = param1.textLength - 1;
         }
         return _loc6_;
      }
      
      public function get currentTable() : TableElement
      {
         return this._currentTable;
      }
      
      public function set currentTable(param1:TableElement) : void
      {
         this._currentTable = param1;
      }
      
      public function hasCellRangeSelection() : Boolean
      {
         if(!this._currentTable)
         {
            return false;
         }
         if(!this._cellRange)
         {
            return false;
         }
         return true;
      }
      
      public function selectCellTextFlow(param1:TableCellElement) : void
      {
         var _loc2_:SelectionManager = null;
         if(param1 && param1.table)
         {
            _loc2_ = param1.textFlow.interactionManager as SelectionManager;
            this.clear();
            if(_loc2_)
            {
               _loc2_.currentTable = param1.table;
               _loc2_.selectAll();
               _loc2_.setFocus();
            }
         }
      }
      
      public function selectCell(param1:TableCellElement) : void
      {
         var _loc2_:CellCoordinates = null;
         var _loc3_:CellCoordinates = null;
         if(param1)
         {
            _loc2_ = new CellCoordinates(param1.rowIndex,param1.colIndex);
            _loc3_ = new CellCoordinates(param1.rowIndex,param1.colIndex);
            if(_loc2_.isValid())
            {
               this.selectCellRange(_loc2_,_loc3_);
            }
         }
      }
      
      public function selectCellAt(param1:TableElement, param2:int, param3:int) : void
      {
         var _loc4_:TableCellElement = param1.getCellAt(param2,param3);
         if(_loc4_)
         {
            this.selectCell(_loc4_);
         }
      }
      
      public function selectCells(param1:Vector.<TableCellElement>) : void
      {
         var _loc6_:TableCellElement = null;
         var _loc7_:TableElement = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:int = int.MAX_VALUE;
         var _loc4_:int = int.MIN_VALUE;
         var _loc5_:int = int.MIN_VALUE;
         for each(_loc6_ in param1)
         {
            if(_loc6_)
            {
               if(_loc7_ == null)
               {
                  _loc7_ = _loc6_.getTable();
               }
               _loc8_ = _loc6_.colIndex;
               _loc9_ = _loc6_.rowIndex;
               if(_loc8_ < _loc2_)
               {
                  _loc2_ = _loc8_;
               }
               if(_loc8_ > _loc4_)
               {
                  _loc4_ = _loc8_;
               }
               if(_loc9_ < _loc3_)
               {
                  _loc3_ = _loc9_;
               }
               if(_loc9_ > _loc5_)
               {
                  _loc5_ = _loc9_;
               }
            }
         }
         if(_loc2_ <= _loc4_ && _loc3_ <= _loc5_)
         {
            this.selectCellRange(new CellCoordinates(_loc3_,_loc2_,_loc7_),new CellCoordinates(_loc5_,_loc4_,_loc7_));
         }
      }
      
      public function selectRow(param1:TableRowElement) : void
      {
         var _loc2_:CellCoordinates = null;
         var _loc3_:CellCoordinates = null;
         if(param1)
         {
            _loc2_ = new CellCoordinates(param1.rowIndex,0);
            _loc3_ = new CellCoordinates(param1.rowIndex,param1.numCells);
            if(_loc2_.isValid() && _loc3_.isValid())
            {
               this.selectCellRange(_loc2_,_loc3_);
            }
         }
      }
      
      public function selectRowAt(param1:TableElement, param2:int) : void
      {
         var _loc3_:TableRowElement = !!param1?param1.getRowAt(param2):null;
         if(_loc3_)
         {
            this.selectRow(_loc3_);
         }
      }
      
      public function selectRows(param1:Array) : void
      {
         var _loc3_:TableElement = null;
         var _loc4_:TableCellElement = null;
         var _loc5_:int = 0;
         var _loc6_:TableRowElement = null;
         var _loc2_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         if(param1 && param1.length)
         {
            while(_loc5_ < param1.length)
            {
               _loc6_ = param1[_loc5_] as TableRowElement;
               if(_loc6_)
               {
                  for each(_loc4_ in _loc6_.cells)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
               _loc5_++;
            }
            this.selectCells(_loc2_);
         }
      }
      
      public function selectColumn(param1:TableColElement) : void
      {
         var _loc2_:TableElement = param1.table;
         if(param1 && _loc2_)
         {
            this.selectCells(_loc2_.getCellsForColumn(param1));
         }
      }
      
      public function selectColumnAt(param1:TableElement, param2:int) : void
      {
         var _loc3_:TableColElement = param1.getColumnAt(param2);
         if(_loc3_ && param1)
         {
            return this.selectColumn(_loc3_);
         }
      }
      
      public function selectColumns(param1:Array) : void
      {
         var _loc3_:TableCellElement = null;
         var _loc4_:int = 0;
         var _loc5_:TableColElement = null;
         var _loc2_:Vector.<TableCellElement> = new Vector.<TableCellElement>();
         if(param1 && param1.length)
         {
            while(_loc4_ < param1.length)
            {
               _loc5_ = param1[_loc4_] as TableColElement;
               if(_loc5_)
               {
                  for each(_loc3_ in _loc5_.cells)
                  {
                     _loc2_.push(_loc3_);
                  }
               }
               _loc4_++;
            }
            this.selectCells(_loc2_);
         }
      }
      
      public function selectTable(param1:TableElement) : void
      {
         var _loc2_:CellCoordinates = null;
         var _loc3_:CellCoordinates = null;
         if(param1)
         {
            _loc2_ = new CellCoordinates(0,0,param1);
            _loc3_ = new CellCoordinates(param1.numRows - 1,param1.numColumns - 1,param1);
            this.selectCellRange(_loc2_,_loc3_);
         }
      }
      
      public function selectCellRange(param1:CellCoordinates, param2:CellCoordinates) : void
      {
         var _loc3_:Vector.<TextFlowTableBlock> = null;
         var _loc4_:TextFlowTableBlock = null;
         var _loc5_:ContainerController = null;
         if(this.selectionType == SelectionType.TEXT)
         {
            this.clear();
         }
         this.clearCellSelections();
         if(param1 && param2)
         {
            this._cellRange = new CellRange(this._currentTable,param1,param2);
            this.activeCellPosition = param2;
            _loc3_ = this._currentTable.getTableBlocksInRange(param1,param2);
            for each(_loc4_ in _loc3_)
            {
               _loc4_.controller.clearSelectionShapes();
               _loc4_.controller.addCellSelectionShapes(this.currentCellSelectionFormat.rangeColor,_loc4_,param1,param2);
            }
            if(this.subManager)
            {
               this.subManager.selectRange(-1,-1);
               this.subManager = null;
            }
         }
         else
         {
            this._cellRange = null;
            this.activeCellPosition.column = -1;
            this.activeCellPosition.row = -1;
         }
         this.selectionChanged();
      }
      
      public function getCellRange() : CellRange
      {
         return this._cellRange;
      }
      
      public function setCellRange(param1:CellRange) : void
      {
         this.selectCellRange(param1.anchorCoordinates,param1.activeCoordinates);
      }
      
      protected function get pointFormat() : ITextLayoutFormat
      {
         return this._pointFormat;
      }
      
      public function getSelectionState() : SelectionState
      {
         if(this.subManager)
         {
            return this.subManager.getSelectionState();
         }
         return new SelectionState(this._textFlow,this.anchorMark.position,this.activeMark.position,this.pointFormat,this._cellRange);
      }
      
      public function setSelectionState(param1:SelectionState) : void
      {
         this.internalSetSelection(param1.textFlow,param1.anchorPosition,param1.activePosition,param1.pointFormat);
      }
      
      public function hasSelection() : Boolean
      {
         return this.selectionType == SelectionType.TEXT;
      }
      
      public function hasAnySelection() : Boolean
      {
         return this.selectionType != SelectionType.NONE;
      }
      
      public function get selectionType() : String
      {
         if(this.anchorMark.position != -1)
         {
            return SelectionType.TEXT;
         }
         if(this.anchorCellPosition.isValid())
         {
            return SelectionType.CELLS;
         }
         return SelectionType.NONE;
      }
      
      public function isRangeSelection() : Boolean
      {
         return this.anchorMark.position != -1 && this.anchorMark.position != this.activeMark.position;
      }
      
      public function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      public function set textFlow(param1:TextFlow) : void
      {
         if(this._textFlow != param1)
         {
            if(this._textFlow)
            {
               this.flushPendingOperations();
            }
            this.clear();
            this.clearCellSelections();
            this._cellRange = null;
            if(!param1)
            {
               this.setMouseCursor(MouseCursor.AUTO);
            }
            this._textFlow = param1;
            if(this._textFlow && this._textFlow.interactionManager != this)
            {
               this._textFlow.interactionManager = this;
            }
         }
      }
      
      public function get editingMode() : String
      {
         return EditingMode.READ_SELECT;
      }
      
      public function get windowActive() : Boolean
      {
         return this._selFormatState != SelectionFormatState.INACTIVE;
      }
      
      public function get focused() : Boolean
      {
         return this._selFormatState == SelectionFormatState.FOCUSED;
      }
      
      public function get currentSelectionFormat() : SelectionFormat
      {
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            return this.unfocusedSelectionFormat;
         }
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            return this.inactiveSelectionFormat;
         }
         return this.focusedSelectionFormat;
      }
      
      public function get currentCellSelectionFormat() : SelectionFormat
      {
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            return this.unfocusedCellSelectionFormat;
         }
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            return this.inactiveCellSelectionFormat;
         }
         return this.focusedCellSelectionFormat;
      }
      
      public function set focusedSelectionFormat(param1:SelectionFormat) : void
      {
         this._focusedSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.FOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get focusedSelectionFormat() : SelectionFormat
      {
         return !!this._focusedSelectionFormat?this._focusedSelectionFormat:!!this._textFlow?this._textFlow.configuration.focusedSelectionFormat:null;
      }
      
      public function set unfocusedSelectionFormat(param1:SelectionFormat) : void
      {
         this._unfocusedSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get unfocusedSelectionFormat() : SelectionFormat
      {
         return !!this._unfocusedSelectionFormat?this._unfocusedSelectionFormat:!!this._textFlow?this._textFlow.configuration.unfocusedSelectionFormat:null;
      }
      
      public function set inactiveSelectionFormat(param1:SelectionFormat) : void
      {
         this._inactiveSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            this.refreshSelection();
         }
      }
      
      public function get inactiveSelectionFormat() : SelectionFormat
      {
         return !!this._inactiveSelectionFormat?this._inactiveSelectionFormat:!!this._textFlow?this._textFlow.configuration.inactiveSelectionFormat:null;
      }
      
      public function set focusedCellSelectionFormat(param1:SelectionFormat) : void
      {
         this._focusedCellSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.FOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get focusedCellSelectionFormat() : SelectionFormat
      {
         return !!this._focusedCellSelectionFormat?this._focusedCellSelectionFormat:!!this._textFlow?this._textFlow.configuration.focusedSelectionFormat:null;
      }
      
      public function set unfocusedCellSelectionFormat(param1:SelectionFormat) : void
      {
         this._unfocusedCellSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.UNFOCUSED)
         {
            this.refreshSelection();
         }
      }
      
      public function get unfocusedCellSelectionFormat() : SelectionFormat
      {
         return !!this._unfocusedCellSelectionFormat?this._unfocusedCellSelectionFormat:!!this._textFlow?this._textFlow.configuration.unfocusedSelectionFormat:null;
      }
      
      public function set inactiveCellSelectionFormat(param1:SelectionFormat) : void
      {
         this._inactiveCellSelectionFormat = param1;
         if(this._selFormatState == SelectionFormatState.INACTIVE)
         {
            this.refreshSelection();
         }
      }
      
      public function get inactiveCellSelectionFormat() : SelectionFormat
      {
         return !!this._inactiveCellSelectionFormat?this._inactiveCellSelectionFormat:!!this._textFlow?this._textFlow.configuration.inactiveSelectionFormat:null;
      }
      
      tlf_internal function get selectionFormatState() : String
      {
         return this._selFormatState;
      }
      
      tlf_internal function setSelectionFormatState(param1:String) : void
      {
         var _loc2_:SelectionFormat = null;
         var _loc3_:SelectionFormat = null;
         if(param1 != this._selFormatState)
         {
            _loc2_ = this.currentSelectionFormat;
            this._selFormatState = param1;
            _loc3_ = this.currentSelectionFormat;
            if(!_loc3_.equals(_loc2_))
            {
               this.refreshSelection();
            }
         }
      }
      
      tlf_internal function cloneSelectionFormatState(param1:ISelectionManager) : void
      {
         var _loc2_:SelectionManager = param1 as SelectionManager;
         if(_loc2_)
         {
            this._isActive = _loc2_._isActive;
            this._mouseOverSelectionArea = _loc2_._mouseOverSelectionArea;
            this.setSelectionFormatState(_loc2_.selectionFormatState);
         }
      }
      
      private function selectionPoint(param1:Object, param2:InteractiveObject, param3:Number, param4:Number, param5:Boolean = false) : SelectionState
      {
         if(!this._textFlow)
         {
            return null;
         }
         if(!this.hasSelection())
         {
            param5 = false;
         }
         var _loc6_:int = this.anchorMark.position;
         var _loc7_:int = this.activeMark.position;
         _loc7_ = computeSelectionIndex(this._textFlow,param2,param1,param3,param4);
         if(_loc7_ == -1)
         {
            return null;
         }
         _loc7_ = Math.min(_loc7_,this._textFlow.textLength - 1);
         if(!param5)
         {
            _loc6_ = _loc7_;
         }
         if(_loc6_ == _loc7_)
         {
            _loc6_ = NavigationUtil.updateStartIfInReadOnlyElement(this._textFlow,_loc6_);
            _loc7_ = NavigationUtil.updateEndIfInReadOnlyElement(this._textFlow,_loc7_);
         }
         else
         {
            _loc7_ = NavigationUtil.updateEndIfInReadOnlyElement(this._textFlow,_loc7_);
         }
         return new SelectionState(this.textFlow,_loc6_,_loc7_);
      }
      
      public function setFocus() : void
      {
         if(!this._textFlow)
         {
            return;
         }
         if(this._textFlow.flowComposer)
         {
            this._textFlow.flowComposer.setFocus(this.activePosition,false);
         }
         this.setSelectionFormatState(SelectionFormatState.FOCUSED);
      }
      
      protected function setMouseCursor(param1:String) : void
      {
         Mouse.cursor = Configuration.getCursorString(this.textFlow.configuration,param1);
      }
      
      public function get anchorPosition() : int
      {
         return this.anchorMark.position;
      }
      
      public function get activePosition() : int
      {
         return this.activeMark.position;
      }
      
      public function get absoluteStart() : int
      {
         return this.anchorMark.position < this.activeMark.position?int(this.anchorMark.position):int(this.activeMark.position);
      }
      
      public function get absoluteEnd() : int
      {
         return this.anchorMark.position > this.activeMark.position?int(this.anchorMark.position):int(this.activeMark.position);
      }
      
      public function selectAll() : void
      {
         var _loc1_:int = 0;
         if(this.subManager)
         {
            this.subManager.selectAll();
         }
         else
         {
            _loc1_ = this._textFlow.textLength > 0?int(this._textFlow.textLength - 1):0;
            this.selectRange(0,_loc1_);
         }
      }
      
      public function selectRange(param1:int, param2:int) : void
      {
         var _loc3_:TableCellElement = null;
         this.flushPendingOperations();
         if(this.subManager && (param1 != -1 || param2 != -1))
         {
            this.subManager.selectRange(-1,-1);
            this.subManager = null;
         }
         if(this.textFlow.nestedInTable())
         {
            _loc3_ = this.textFlow.parentElement as TableCellElement;
            this.superManager = _loc3_.getTextFlow().interactionManager;
            this.superManager.currentTable = _loc3_.getTable();
            this.superManager.deselect();
            this.superManager.anchorCellPosition.column = _loc3_.colIndex;
            this.superManager.anchorCellPosition.row = _loc3_.rowIndex;
            this.superManager.subManager = this;
         }
         if(param1 != this.anchorMark.position || param2 != this.activeMark.position)
         {
            this.clearSelectionShapes();
            this.clearCellSelections();
            this._cellRange = null;
            this.internalSetSelection(this._textFlow,param1,param2,this._pointFormat);
            this.selectionChanged();
            this.allowOperationMerge = false;
         }
      }
      
      public function selectFirstPosition() : void
      {
         this.selectRange(0,0);
      }
      
      public function selectLastPosition() : void
      {
         this.selectRange(int.MAX_VALUE,int.MAX_VALUE);
      }
      
      public function deselect() : void
      {
         if(this.hasAnySelection())
         {
            this.clearSelectionShapes();
            this.clearCellSelections();
            this.addSelectionShapes();
         }
         this.selectRange(-1,-1);
         this._cellRange = null;
      }
      
      private function internalSetSelection(param1:TextFlow, param2:int, param3:int, param4:ITextLayoutFormat = null) : void
      {
         this._textFlow = param1;
         if(param2 < 0 || param3 < 0)
         {
            param2 = -1;
            param3 = -1;
         }
         else if(this.subManager)
         {
            this.subManager.flushPendingOperations();
            this.subManager = null;
         }
         var _loc5_:int = this._textFlow.textLength > 0?int(this._textFlow.textLength - 1):0;
         if(param2 != -1 && param3 != -1)
         {
            if(param2 > _loc5_)
            {
               param2 = _loc5_;
            }
            if(param3 > _loc5_)
            {
               param3 = _loc5_;
            }
         }
         this._pointFormat = param4;
         this.anchorMark.position = param2;
         this.activeMark.position = param3;
      }
      
      private function clear() : void
      {
         if(this.hasSelection())
         {
            this.flushPendingOperations();
            this.clearSelectionShapes();
            this.internalSetSelection(this._textFlow,-1,-1);
            this.selectionChanged();
            this.allowOperationMerge = false;
         }
      }
      
      private function clearCellSelections() : void
      {
         var _loc1_:Vector.<TextFlowTableBlock> = null;
         var _loc2_:TextFlowTableBlock = null;
         var _loc3_:ContainerController = null;
         if(this._cellRange)
         {
            _loc1_ = this._cellRange.table.getTableBlocksInRange(this._cellRange.anchorCoordinates,this._cellRange.activeCoordinates);
            for each(_loc2_ in _loc1_)
            {
               if(_loc3_ != _loc2_.controller)
               {
                  _loc2_.controller.clearSelectionShapes();
               }
               _loc3_ = _loc2_.controller;
            }
         }
         if(_loc2_)
         {
            _loc2_.controller.clearSelectionShapes();
         }
      }
      
      private function addSelectionShapes() : void
      {
         var _loc1_:int = 0;
         if(this._textFlow.flowComposer)
         {
            this.internalSetSelection(this._textFlow,this.anchorMark.position,this.activeMark.position,this._pointFormat);
            if(this.currentSelectionFormat && (this.absoluteStart == this.absoluteEnd && this.currentSelectionFormat.pointAlpha != 0 || this.absoluteStart != this.absoluteEnd && this.currentSelectionFormat.rangeAlpha != 0))
            {
               _loc1_ = 0;
               while(_loc1_ < this._textFlow.flowComposer.numControllers)
               {
                  this._textFlow.flowComposer.getControllerAt(_loc1_++).addSelectionShapes(this.currentSelectionFormat,this.absoluteStart,this.absoluteEnd);
               }
            }
         }
      }
      
      private function clearSelectionShapes() : void
      {
         var _loc2_:int = 0;
         var _loc1_:IFlowComposer = !!this._textFlow?this._textFlow.flowComposer:null;
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numControllers)
            {
               _loc1_.getControllerAt(_loc2_++).clearSelectionShapes();
            }
         }
      }
      
      public function refreshSelection() : void
      {
         if(this.hasAnySelection())
         {
            this.clearSelectionShapes();
            this.clearCellSelections();
            this.addSelectionShapes();
         }
      }
      
      public function clearSelection() : void
      {
         if(this.hasAnySelection())
         {
            this.clearSelectionShapes();
            this.clearCellSelections();
         }
      }
      
      tlf_internal function selectionChanged(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(param2)
         {
            this._pointFormat = null;
         }
         if(param1 && this._textFlow)
         {
            if(this.textFlow.parentElement && this.textFlow.parentElement.getTextFlow())
            {
               this.textFlow.parentElement.getTextFlow().dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,!!this.hasSelection()?this.getSelectionState():null));
            }
            else
            {
               this.textFlow.dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,!!this.hasSelection()?this.getSelectionState():null));
            }
         }
      }
      
      tlf_internal function setNewSelectionPoint(param1:Object, param2:InteractiveObject, param3:Number, param4:Number, param5:Boolean = false) : Boolean
      {
         var _loc6_:SelectionState = this.selectionPoint(param1,param2,param3,param4,param5);
         if(_loc6_ == null)
         {
            return false;
         }
         if(_loc6_.anchorPosition != this.anchorMark.position || _loc6_.activePosition != this.activeMark.position)
         {
            this.selectRange(_loc6_.anchorPosition,_loc6_.activePosition);
            return true;
         }
         return false;
      }
      
      public function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc3_:CellCoordinates = null;
         if(this.subManager)
         {
            this.subManager.selectRange(-1,-1);
         }
         var _loc2_:TableCellElement = this._textFlow.parentElement as TableCellElement;
         if(!_loc2_)
         {
            _loc3_ = computeCellCoordinates(this.textFlow,param1.target,param1.currentTarget,param1.localX,param1.localY);
         }
         if(_loc2_ || _loc3_)
         {
            if(_loc3_)
            {
               _loc2_ = _loc3_.table.findCell(_loc3_);
            }
            this.superManager = _loc2_.getTextFlow().interactionManager;
            if(param1.shiftKey && _loc2_.getTable() == this.superManager.currentTable)
            {
               this.flushPendingOperations();
               _loc3_ = new CellCoordinates(_loc2_.rowIndex,_loc2_.colIndex);
               if(!CellCoordinates.areEqual(_loc3_,this.superManager.anchorCellPosition) || this.superManager.activeCellPosition.isValid())
               {
                  this.superManager.selectCellRange(this.superManager.anchorCellPosition,_loc3_);
                  this.superManager.subManager = null;
                  this.allowOperationMerge = false;
                  param1.stopPropagation();
                  return;
               }
            }
            if(this.superManager == this)
            {
               if(_loc2_.textFlow.interactionManager)
               {
                  _loc2_.textFlow.interactionManager.mouseDownHandler(param1);
               }
               return;
            }
            this.superManager.currentTable = _loc2_.getTable();
            this.superManager.deselect();
            this.superManager.anchorCellPosition.column = _loc2_.colIndex;
            this.superManager.anchorCellPosition.row = _loc2_.rowIndex;
            this.superManager.subManager = this;
         }
         this.handleMouseEventForSelection(param1,param1.shiftKey,_loc2_ != null);
      }
      
      public function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc3_:TableCellElement = null;
         var _loc4_:CellCoordinates = null;
         var _loc5_:CellCoordinates = null;
         var _loc2_:String = this.textFlow.computedFormat.blockProgression;
         if(_loc2_ != BlockProgression.RL)
         {
            this.setMouseCursor(MouseCursor.IBEAM);
         }
         if(param1.buttonDown)
         {
            _loc3_ = this._textFlow.parentElement as TableCellElement;
            if(_loc3_)
            {
               do
               {
                  _loc4_ = new CellCoordinates(_loc3_.rowIndex,_loc3_.colIndex,_loc3_.getTable());
                  _loc5_ = computeCellCoordinates(_loc3_.getTextFlow(),param1.target,param1.currentTarget,param1.localX,param1.localY);
                  if(!_loc5_)
                  {
                     break;
                  }
                  if(CellCoordinates.areEqual(_loc4_,_loc5_) && (!this.superManager.activeCellPosition.isValid() || CellCoordinates.areEqual(_loc5_,this.superManager.activeCellPosition)))
                  {
                     break;
                  }
                  if(_loc5_.table != _loc4_.table)
                  {
                     break;
                  }
                  this.superManager = _loc3_.getTextFlow().interactionManager;
                  if(!CellCoordinates.areEqual(_loc5_,this.superManager.activeCellPosition))
                  {
                     this.allowOperationMerge = false;
                     this.superManager.selectCellRange(this.superManager.anchorCellPosition,_loc5_);
                     param1.stopPropagation();
                     return;
                  }
               }
               while(0);
               
            }
            if(this.superManager && this.superManager.getCellRange())
            {
               return;
            }
            this.handleMouseEventForSelection(param1,true,this._textFlow.parentElement != null);
         }
      }
      
      tlf_internal function handleMouseEventForSelection(param1:MouseEvent, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = this.hasSelection();
         if(this.setNewSelectionPoint(param1.currentTarget,param1.target as InteractiveObject,param1.localX,param1.localY,_loc4_ && param2))
         {
            if(_loc4_)
            {
               this.clearSelectionShapes();
            }
            if(this.hasSelection())
            {
               this.addSelectionShapes();
            }
         }
         this.allowOperationMerge = false;
         if(param3)
         {
            param1.stopPropagation();
         }
      }
      
      public function mouseUpHandler(param1:MouseEvent) : void
      {
         if(!this._mouseOverSelectionArea)
         {
            this.setMouseCursor(MouseCursor.AUTO);
         }
      }
      
      private function atBeginningWordPos(param1:ParagraphElement, param2:int) : Boolean
      {
         if(param2 == 0)
         {
            return true;
         }
         var _loc3_:Number = param1.getAbsoluteStart() + param1.textLength;
         param1.getTextFlow().flowComposer.composeToPosition(_loc3_);
         var _loc4_:int = param1.findNextWordBoundary(param2);
         _loc4_ = param1.findPreviousWordBoundary(_loc4_);
         return param2 == _loc4_;
      }
      
      public function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ParagraphElement = null;
         var _loc7_:int = 0;
         if(!this.hasSelection())
         {
            return;
         }
         var _loc2_:ParagraphElement = this._textFlow.findAbsoluteParagraph(this.activeMark.position);
         var _loc3_:int = _loc2_.getAbsoluteStart();
         if(this.anchorMark.position <= this.activeMark.position)
         {
            _loc4_ = _loc2_.findNextWordBoundary(this.activeMark.position - _loc3_) + _loc3_;
         }
         else
         {
            _loc4_ = _loc2_.findPreviousWordBoundary(this.activeMark.position - _loc3_) + _loc3_;
         }
         if(_loc4_ == _loc3_ + _loc2_.textLength)
         {
            _loc4_--;
         }
         if(param1.shiftKey)
         {
            _loc5_ = this.anchorMark.position;
         }
         else
         {
            _loc6_ = this._textFlow.findAbsoluteParagraph(this.anchorMark.position);
            _loc7_ = _loc6_.getAbsoluteStart();
            if(this.atBeginningWordPos(_loc6_,this.anchorMark.position - _loc7_))
            {
               _loc5_ = this.anchorMark.position;
            }
            else
            {
               if(this.anchorMark.position <= this.activeMark.position)
               {
                  _loc5_ = _loc6_.findPreviousWordBoundary(this.anchorMark.position - _loc7_) + _loc7_;
               }
               else
               {
                  _loc5_ = _loc6_.findNextWordBoundary(this.anchorMark.position - _loc7_) + _loc7_;
               }
               if(_loc5_ == _loc7_ + _loc6_.textLength)
               {
                  _loc5_--;
               }
            }
         }
         if(_loc5_ != this.anchorMark.position || _loc4_ != this.activeMark.position)
         {
            this.internalSetSelection(this._textFlow,_loc5_,_loc4_,null);
            this.selectionChanged();
            this.clearSelectionShapes();
            if(this.hasSelection())
            {
               this.addSelectionShapes();
            }
         }
         this.allowOperationMerge = false;
      }
      
      public function mouseOverHandler(param1:MouseEvent) : void
      {
         var _loc3_:TableCellElement = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:CellContainer = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         this._mouseOverSelectionArea = true;
         var _loc2_:String = this.textFlow.computedFormat.blockProgression;
         if(_loc2_ != BlockProgression.RL)
         {
            _loc3_ = this._textFlow.parentElement as TableCellElement;
            if(_loc3_)
            {
               _loc4_ = 5;
               _loc5_ = 5;
               _loc6_ = new Point(param1.stageX,param1.stageY);
               _loc7_ = param1.currentTarget as CellContainer;
               if(_loc7_)
               {
                  _loc9_ = _loc7_.localToGlobal(new Point());
                  _loc8_ = _loc6_.subtract(_loc9_);
               }
               if(useTableSelectionCursors)
               {
                  if(_loc3_.colIndex == 0 && _loc8_.x < _loc4_ && _loc8_.y > _loc5_)
                  {
                     param1.stopPropagation();
                     param1.stopImmediatePropagation();
                     this.setMouseCursor(SelectTableRow);
                  }
                  else if(_loc3_.rowIndex == 0 && _loc3_.colIndex == 0 && _loc8_.x < _loc4_ && _loc8_.y < _loc5_)
                  {
                     param1.stopPropagation();
                     param1.stopImmediatePropagation();
                     this.setMouseCursor(SelectTable);
                  }
                  else if(_loc3_.rowIndex == 0 && _loc8_.x > _loc4_ && _loc8_.y < _loc5_)
                  {
                     param1.stopPropagation();
                     param1.stopImmediatePropagation();
                     this.setMouseCursor(SelectTableColumn);
                  }
                  else
                  {
                     this.setMouseCursor(MouseCursor.IBEAM);
                  }
               }
               else
               {
                  this.setMouseCursor(MouseCursor.IBEAM);
               }
            }
            else
            {
               this.setMouseCursor(MouseCursor.IBEAM);
            }
         }
         else
         {
            this.setMouseCursor(MouseCursor.AUTO);
         }
      }
      
      public function mouseOutHandler(param1:MouseEvent) : void
      {
         this._mouseOverSelectionArea = false;
         this.setMouseCursor(MouseCursor.AUTO);
      }
      
      public function focusInHandler(param1:FocusEvent) : void
      {
         this._isActive = true;
         this.setSelectionFormatState(SelectionFormatState.FOCUSED);
      }
      
      public function focusOutHandler(param1:FocusEvent) : void
      {
         if(this._isActive)
         {
            this.setSelectionFormatState(SelectionFormatState.UNFOCUSED);
         }
      }
      
      public function activateHandler(param1:Event) : void
      {
         if(!this._isActive)
         {
            this._isActive = true;
            this.setSelectionFormatState(SelectionFormatState.UNFOCUSED);
         }
      }
      
      public function deactivateHandler(param1:Event) : void
      {
         if(this._isActive)
         {
            this._isActive = false;
            this.setSelectionFormatState(SelectionFormatState.INACTIVE);
         }
      }
      
      public function doOperation(param1:FlowOperation) : void
      {
         var opError:Error = null;
         var op:FlowOperation = param1;
         var opEvent:FlowOperationEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_BEGIN,false,true,op,0,null);
         this.textFlow.dispatchEvent(opEvent);
         if(!opEvent.isDefaultPrevented())
         {
            op = opEvent.operation;
            if(!(op is CopyOperation))
            {
               throw new IllegalOperationError(GlobalSettings.resourceStringFunction("illegalOperation",[getQualifiedClassName(op)]));
            }
            opError = null;
            try
            {
               op.doOperation();
            }
            catch(e:Error)
            {
               opError = e;
            }
            opEvent = new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_END,false,true,op,0,opError);
            this.textFlow.dispatchEvent(opEvent);
            opError = !!opEvent.isDefaultPrevented()?null:opEvent.error;
            if(opError)
            {
               throw opError;
            }
            this.textFlow.dispatchEvent(new FlowOperationEvent(FlowOperationEvent.FLOW_OPERATION_COMPLETE,false,false,op,0,null));
         }
      }
      
      public function editHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case Event.COPY:
               this.flushPendingOperations();
               this.doOperation(new CopyOperation(this.getSelectionState()));
               break;
            case Event.SELECT_ALL:
               this.flushPendingOperations();
               this.selectAll();
               this.refreshSelection();
         }
      }
      
      private function handleLeftArrow(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(this._textFlow.computedFormat.direction == Direction.LTR)
            {
               if(param1.ctrlKey || param1.altKey)
               {
                  NavigationUtil.previousWord(_loc2_,param1.shiftKey);
               }
               else
               {
                  NavigationUtil.previousCharacter(_loc2_,param1.shiftKey);
               }
            }
            else if(param1.ctrlKey || param1.altKey)
            {
               NavigationUtil.nextWord(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.nextCharacter(_loc2_,param1.shiftKey);
            }
         }
         else if(param1.altKey)
         {
            NavigationUtil.endOfParagraph(_loc2_,param1.shiftKey);
         }
         else if(param1.ctrlKey)
         {
            NavigationUtil.endOfDocument(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.nextLine(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handleUpArrow(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(param1.altKey)
            {
               NavigationUtil.startOfParagraph(_loc2_,param1.shiftKey);
            }
            else if(param1.ctrlKey)
            {
               NavigationUtil.startOfDocument(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.previousLine(_loc2_,param1.shiftKey);
            }
         }
         else if(this._textFlow.computedFormat.direction == Direction.LTR)
         {
            if(param1.ctrlKey || param1.altKey)
            {
               NavigationUtil.previousWord(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.previousCharacter(_loc2_,param1.shiftKey);
            }
         }
         else if(param1.ctrlKey || param1.altKey)
         {
            NavigationUtil.nextWord(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.nextCharacter(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handleRightArrow(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(this._textFlow.computedFormat.direction == Direction.LTR)
            {
               if(param1.ctrlKey || param1.altKey)
               {
                  NavigationUtil.nextWord(_loc2_,param1.shiftKey);
               }
               else
               {
                  NavigationUtil.nextCharacter(_loc2_,param1.shiftKey);
               }
            }
            else if(param1.ctrlKey || param1.altKey)
            {
               NavigationUtil.previousWord(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.previousCharacter(_loc2_,param1.shiftKey);
            }
         }
         else if(param1.altKey)
         {
            NavigationUtil.startOfParagraph(_loc2_,param1.shiftKey);
         }
         else if(param1.ctrlKey)
         {
            NavigationUtil.startOfDocument(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.previousLine(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handleDownArrow(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(this._textFlow.computedFormat.blockProgression != BlockProgression.RL)
         {
            if(param1.altKey)
            {
               NavigationUtil.endOfParagraph(_loc2_,param1.shiftKey);
            }
            else if(param1.ctrlKey)
            {
               NavigationUtil.endOfDocument(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.nextLine(_loc2_,param1.shiftKey);
            }
         }
         else if(this._textFlow.computedFormat.direction == Direction.LTR)
         {
            if(param1.ctrlKey || param1.altKey)
            {
               NavigationUtil.nextWord(_loc2_,param1.shiftKey);
            }
            else
            {
               NavigationUtil.nextCharacter(_loc2_,param1.shiftKey);
            }
         }
         else if(param1.ctrlKey || param1.altKey)
         {
            NavigationUtil.previousWord(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.previousCharacter(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handleHomeKey(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(param1.ctrlKey && !param1.altKey)
         {
            NavigationUtil.startOfDocument(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.startOfLine(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handleEndKey(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         if(param1.ctrlKey && !param1.altKey)
         {
            NavigationUtil.endOfDocument(_loc2_,param1.shiftKey);
         }
         else
         {
            NavigationUtil.endOfLine(_loc2_,param1.shiftKey);
         }
         return _loc2_;
      }
      
      private function handlePageUpKey(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         NavigationUtil.previousPage(_loc2_,param1.shiftKey);
         return _loc2_;
      }
      
      private function handlePageDownKey(param1:KeyboardEvent) : SelectionState
      {
         var _loc2_:SelectionState = this.getSelectionState();
         NavigationUtil.nextPage(_loc2_,param1.shiftKey);
         return _loc2_;
      }
      
      private function handleKeyEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:SelectionState = null;
         this.flushPendingOperations();
         switch(param1.keyCode)
         {
            case Keyboard.LEFT:
               _loc2_ = this.handleLeftArrow(param1);
               break;
            case Keyboard.UP:
               _loc2_ = this.handleUpArrow(param1);
               break;
            case Keyboard.RIGHT:
               _loc2_ = this.handleRightArrow(param1);
               break;
            case Keyboard.DOWN:
               _loc2_ = this.handleDownArrow(param1);
               break;
            case Keyboard.HOME:
               _loc2_ = this.handleHomeKey(param1);
               break;
            case Keyboard.END:
               _loc2_ = this.handleEndKey(param1);
               break;
            case Keyboard.PAGE_DOWN:
               _loc2_ = this.handlePageDownKey(param1);
               break;
            case Keyboard.PAGE_UP:
               _loc2_ = this.handlePageUpKey(param1);
         }
         if(_loc2_ != null)
         {
            param1.preventDefault();
            this.updateSelectionAndShapes(this._textFlow,_loc2_.anchorPosition,_loc2_.activePosition);
            if(this._textFlow.flowComposer && this._textFlow.flowComposer.numControllers != 0)
            {
               this._textFlow.flowComposer.getControllerAt(this._textFlow.flowComposer.numControllers - 1).scrollToRange(_loc2_.activePosition,_loc2_.activePosition);
            }
         }
         this.allowOperationMerge = false;
      }
      
      public function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(!this.hasSelection() || param1.isDefaultPrevented())
         {
            return;
         }
         if(param1.charCode == 0)
         {
            switch(param1.keyCode)
            {
               case Keyboard.LEFT:
               case Keyboard.UP:
               case Keyboard.RIGHT:
               case Keyboard.DOWN:
               case Keyboard.HOME:
               case Keyboard.END:
               case Keyboard.PAGE_DOWN:
               case Keyboard.PAGE_UP:
               case Keyboard.ESCAPE:
                  this.handleKeyEvent(param1);
            }
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.handleKeyEvent(param1);
         }
         if(this._textFlow.parentElement)
         {
            param1.stopPropagation();
         }
      }
      
      public function keyUpHandler(param1:KeyboardEvent) : void
      {
      }
      
      public function keyFocusChangeHandler(param1:FocusEvent) : void
      {
      }
      
      public function textInputHandler(param1:TextEvent) : void
      {
         this.ignoreNextTextEvent = false;
      }
      
      public function imeStartCompositionHandler(param1:IMEEvent) : void
      {
      }
      
      public function softKeyboardActivatingHandler(param1:Event) : void
      {
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         this.flushPendingOperations();
      }
      
      public function focusChangeHandler(param1:FocusEvent) : void
      {
      }
      
      public function menuSelectHandler(param1:ContextMenuEvent) : void
      {
         var _loc2_:ContextMenu = param1.target as ContextMenu;
         if(this.activePosition != this.anchorPosition)
         {
            _loc2_.clipboardItems.copy = true;
            _loc2_.clipboardItems.cut = this.editingMode == EditingMode.READ_WRITE;
            _loc2_.clipboardItems.clear = this.editingMode == EditingMode.READ_WRITE;
         }
         else
         {
            _loc2_.clipboardItems.copy = false;
            _loc2_.clipboardItems.cut = false;
            _loc2_.clipboardItems.clear = false;
         }
         var _loc3_:Clipboard = Clipboard.generalClipboard;
         if(this.activePosition != -1 && this.editingMode == EditingMode.READ_WRITE && (_loc3_.hasFormat(TextClipboard.TEXT_LAYOUT_MARKUP) || _loc3_.hasFormat(ClipboardFormats.TEXT_FORMAT)))
         {
            _loc2_.clipboardItems.paste = true;
         }
         else
         {
            _loc2_.clipboardItems.paste = false;
         }
         _loc2_.clipboardItems.selectAll = true;
      }
      
      public function mouseWheelHandler(param1:MouseEvent) : void
      {
      }
      
      public function flushPendingOperations() : void
      {
      }
      
      public function getCommonCharacterFormat(param1:TextRange = null) : TextLayoutFormat
      {
         if(!param1 && !this.hasSelection())
         {
            return null;
         }
         var _loc2_:ElementRange = ElementRange.createElementRange(this._textFlow,!!param1?int(param1.absoluteStart):int(this.absoluteStart),!!param1?int(param1.absoluteEnd):int(this.absoluteEnd));
         var _loc3_:TextLayoutFormat = _loc2_.getCommonCharacterFormat();
         if(_loc2_.absoluteEnd == _loc2_.absoluteStart && this.pointFormat)
         {
            _loc3_.apply(this.pointFormat);
         }
         return _loc3_;
      }
      
      public function getCommonParagraphFormat(param1:TextRange = null) : TextLayoutFormat
      {
         if(!param1 && !this.hasSelection())
         {
            return null;
         }
         return ElementRange.createElementRange(this._textFlow,!!param1?int(param1.absoluteStart):int(this.absoluteStart),!!param1?int(param1.absoluteEnd):int(this.absoluteEnd)).getCommonParagraphFormat();
      }
      
      public function getCommonContainerFormat(param1:TextRange = null) : TextLayoutFormat
      {
         if(!param1 && !this.hasSelection())
         {
            return null;
         }
         return ElementRange.createElementRange(this._textFlow,!!param1?int(param1.absoluteStart):int(this.absoluteStart),!!param1?int(param1.absoluteEnd):int(this.absoluteEnd)).getCommonContainerFormat();
      }
      
      private function updateSelectionAndShapes(param1:TextFlow, param2:int, param3:int) : void
      {
         this.internalSetSelection(param1,param2,param3);
         if(this._textFlow.flowComposer && this._textFlow.flowComposer.numControllers != 0)
         {
            this._textFlow.flowComposer.getControllerAt(this._textFlow.flowComposer.numControllers - 1).scrollToRange(this.activeMark.position,this.anchorMark.position);
         }
         this.selectionChanged();
         this.clearSelectionShapes();
         this.addSelectionShapes();
      }
      
      tlf_internal function createMark() : Mark
      {
         var _loc1_:Mark = new Mark(-1);
         this.marks.push(_loc1_);
         return _loc1_;
      }
      
      tlf_internal function removeMark(param1:Mark) : void
      {
         var _loc2_:int = this.marks.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.marks.splice(_loc2_,1);
         }
      }
      
      tlf_internal function createCellMark() : CellCoordinates
      {
         var _loc1_:CellCoordinates = new CellCoordinates(-1,-1);
         this.cellMarks.push(_loc1_);
         return _loc1_;
      }
      
      tlf_internal function removeCellMark(param1:CellCoordinates) : void
      {
         var _loc2_:int = this.cellMarks.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.marks.splice(_loc2_,1);
         }
      }
      
      public function notifyInsertOrDelete(param1:int, param2:int) : void
      {
         var _loc4_:Mark = null;
         if(param2 == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.marks.length)
         {
            _loc4_ = this.marks[_loc3_];
            if(_loc4_.position >= param1)
            {
               if(param2 < 0)
               {
                  _loc4_.position = _loc4_.position + param2 < param1?int(param1):int(_loc4_.position + param2);
               }
               else
               {
                  _loc4_.position = _loc4_.position + param2;
               }
            }
            _loc3_++;
         }
      }
      
      public function get subManager() : ISelectionManager
      {
         return this._subManager;
      }
      
      public function set subManager(param1:ISelectionManager) : void
      {
         if(param1 == this._subManager)
         {
            return;
         }
         if(this._subManager)
         {
            this._subManager.selectRange(-1,-1);
         }
         this._subManager = param1;
      }
      
      public function get superManager() : ISelectionManager
      {
         return this._superManager;
      }
      
      public function set superManager(param1:ISelectionManager) : void
      {
         this._superManager = param1;
      }
      
      public function get anchorCellPosition() : CellCoordinates
      {
         return this._anchorCellPosition;
      }
      
      public function set anchorCellPosition(param1:CellCoordinates) : void
      {
         this._anchorCellPosition = param1;
      }
      
      public function get activeCellPosition() : CellCoordinates
      {
         return this._activeCellPosition;
      }
      
      public function set activeCellPosition(param1:CellCoordinates) : void
      {
         this._activeCellPosition = param1;
      }
      
      public function createSelectTableCursor() : MouseCursorData
      {
         var _loc1_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,1);
         _loc2_.graphics.lineStyle(0,16777215,1,true);
         _loc2_.graphics.drawPath(this.selectTableCursorDrawCommands,this.selectTableCursorPoints);
         _loc2_.graphics.endFill();
         var _loc3_:Matrix = new Matrix();
         var _loc4_:BitmapData = new BitmapData(32,32,true,0);
         var _loc5_:int = 8;
         var _loc6_:Number = 0.785398163;
         _loc3_.translate(-_loc5_,-_loc5_);
         _loc3_.rotate(_loc6_);
         _loc3_.translate(_loc5_,_loc5_);
         _loc4_.draw(_loc2_,_loc3_);
         _loc1_.push(_loc4_);
         var _loc7_:MouseCursorData = new MouseCursorData();
         _loc7_.data = _loc1_;
         _loc7_.hotSpot = new Point(16,10);
         _loc7_.frameRate = 1;
         return _loc7_;
      }
      
      public function createSelectTableRowCursor() : MouseCursorData
      {
         var _loc1_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,1);
         _loc2_.graphics.lineStyle(0,16777215,1,true);
         _loc2_.graphics.drawPath(this.selectTableCursorDrawCommands,this.selectTableCursorPoints);
         _loc2_.graphics.endFill();
         var _loc3_:Matrix = new Matrix();
         var _loc4_:BitmapData = new BitmapData(32,32,true,0);
         _loc4_.draw(_loc2_,_loc3_);
         _loc1_.push(_loc4_);
         var _loc5_:MouseCursorData = new MouseCursorData();
         _loc5_.data = _loc1_;
         _loc5_.hotSpot = new Point(16,4);
         _loc5_.frameRate = 1;
         return _loc5_;
      }
      
      public function createSelectTableColumnCursor() : MouseCursorData
      {
         var _loc1_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,1);
         _loc2_.graphics.lineStyle(0,16777215,1,true);
         _loc2_.graphics.drawPath(this.selectTableCursorDrawCommands,this.selectTableCursorPoints);
         _loc2_.graphics.endFill();
         var _loc3_:Matrix = new Matrix();
         var _loc4_:BitmapData = new BitmapData(32,32,true,0);
         var _loc5_:int = 16;
         var _loc6_:Number = 0.785398163;
         _loc3_.translate(-_loc5_,-_loc5_);
         _loc3_.rotate(_loc6_ * 2);
         _loc3_.translate(_loc5_,_loc5_);
         _loc4_.draw(_loc2_,_loc3_);
         _loc1_.push(_loc4_);
         var _loc7_:MouseCursorData = new MouseCursorData();
         _loc7_.data = _loc1_;
         _loc7_.hotSpot = new Point(28,16);
         _loc7_.frameRate = 1;
         return _loc7_;
      }
   }
}
