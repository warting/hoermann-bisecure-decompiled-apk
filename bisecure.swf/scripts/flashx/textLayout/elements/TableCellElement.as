package flashx.textLayout.elements
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.IEditManager;
   import flashx.textLayout.events.DamageEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public final class TableCellElement extends TableFormattedElement
   {
       
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _parcelIndex:int;
      
      private var _container:CellContainer;
      
      private var _enableIME:Boolean = true;
      
      private var _damaged:Boolean = true;
      
      private var _controller:ContainerController;
      
      private var _rowSpan:uint = 1;
      
      private var _columnSpan:uint = 1;
      
      private var _rowIndex:int = -1;
      
      private var _colIndex:int = -1;
      
      private var _includeDescentInCellBounds:Boolean;
      
      private var _savedPaddingTop:Number = 0;
      
      private var _savedPaddingBottom:Number = 0;
      
      private var _savedPaddingLeft:Number = 0;
      
      private var _savedPaddingRight:Number = 0;
      
      protected var _textFlow:TextFlow;
      
      public function TableCellElement()
      {
         super();
         this._controller = new ContainerController(this.container,NaN,NaN);
      }
      
      override protected function get abstract() : Boolean
      {
         return false;
      }
      
      override tlf_internal function get defaultTypeName() : String
      {
         return "td";
      }
      
      override tlf_internal function canOwnFlowElement(param1:FlowElement) : Boolean
      {
         return param1 is FlowElement;
      }
      
      public function isDamaged() : Boolean
      {
         return this._damaged || this._textFlow && this._textFlow.flowComposer.isPotentiallyDamaged(this._textFlow.textLength);
      }
      
      public function compose() : Boolean
      {
         var _loc1_:Number = getEffectivePaddingTop();
         var _loc2_:Number = getEffectivePaddingBottom();
         var _loc3_:Number = getEffectivePaddingLeft();
         var _loc4_:Number = getEffectivePaddingRight();
         if(_loc1_ != this._savedPaddingTop)
         {
            this._controller.paddingTop = this._savedPaddingTop = _loc1_;
         }
         if(_loc2_ != this._savedPaddingBottom)
         {
            this._controller.paddingBottom = this._savedPaddingBottom = _loc2_;
         }
         if(_loc3_ != this._savedPaddingLeft)
         {
            this._controller.paddingLeft = this._savedPaddingLeft = _loc3_;
         }
         if(_loc4_ != this._savedPaddingRight)
         {
            this._controller.paddingRight = this._savedPaddingRight = _loc4_;
         }
         var _loc5_:TableElement = getTable();
         this._damaged = false;
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this.columnSpan)
         {
            if(_loc5_ && _loc5_.getColumnAt(this.colIndex + _loc7_))
            {
               _loc6_ = _loc6_ + _loc5_.getColumnAt(this.colIndex + _loc7_).columnWidth;
            }
            _loc7_++;
         }
         this.width = _loc6_;
         if(this._textFlow && this._textFlow.flowComposer)
         {
            return this._textFlow.flowComposer.compose();
         }
         return false;
      }
      
      public function update() : Boolean
      {
         if(this._textFlow && this._textFlow.flowComposer)
         {
            return this._textFlow.flowComposer.updateAllControllers();
         }
         return false;
      }
      
      public function get parcelIndex() : int
      {
         return this._parcelIndex;
      }
      
      public function set parcelIndex(param1:int) : void
      {
         this._parcelIndex = param1;
      }
      
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(param1:int) : void
      {
         this._rowIndex = param1;
      }
      
      public function get colIndex() : int
      {
         return this._colIndex;
      }
      
      public function set colIndex(param1:int) : void
      {
         this._colIndex = param1;
      }
      
      public function get textFlow() : TextFlow
      {
         var _loc1_:TextFlow = null;
         var _loc2_:Class = null;
         if(this._textFlow == null)
         {
            _loc1_ = new TextFlow();
            if(table && table.getTextFlow() && table.getTextFlow().interactionManager is IEditManager)
            {
               _loc1_.interactionManager = new EditManager(IEditManager(this._textFlow.interactionManager).undoManager);
            }
            else if(table && table.getTextFlow() && table.getTextFlow().interactionManager)
            {
               _loc2_ = getDefinitionByName(getQualifiedClassName(table.getTextFlow().interactionManager)) as Class;
               _loc1_.interactionManager = new _loc2_();
            }
            else
            {
               _loc1_.normalize();
            }
            this.textFlow = _loc1_;
         }
         return this._textFlow;
      }
      
      public function set textFlow(param1:TextFlow) : void
      {
         if(this._textFlow)
         {
            this._textFlow.removeEventListener(DamageEvent.DAMAGE,this.handleCellDamage);
            this._textFlow.flowComposer.removeAllControllers();
         }
         this._textFlow = param1;
         this._textFlow.parentElement = this;
         this._textFlow.flowComposer.addController(this._controller);
         this._textFlow.addEventListener(DamageEvent.DAMAGE,this.handleCellDamage);
      }
      
      public function get controller() : ContainerController
      {
         return this._controller;
      }
      
      private function handleCellDamage(param1:DamageEvent) : void
      {
         this.damage();
      }
      
      public function get enableIME() : Boolean
      {
         return this._enableIME;
      }
      
      public function set enableIME(param1:Boolean) : void
      {
         this._enableIME = param1;
      }
      
      public function get container() : CellContainer
      {
         if(!this._container)
         {
            this._container = new CellContainer(this.enableIME);
            this._container.element = this;
         }
         return this._container;
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         if(this._width != param1)
         {
            this._damaged = true;
         }
         this._width = param1;
         this._controller.setCompositionSize(this._width,this._controller.compositionHeight);
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(param1:Number) : void
      {
         if(this._height != param1)
         {
            this._damaged = true;
         }
         this._height = param1;
         this._controller.setCompositionSize(this._controller.compositionWidth,this._height);
      }
      
      public function getComposedHeight() : Number
      {
         var _loc2_:TextFlowLine = null;
         var _loc1_:Number = 0;
         if(!this.includeDescentInCellBounds)
         {
            if(this._textFlow.flowComposer && this._textFlow.flowComposer.numLines)
            {
               _loc2_ = this._textFlow.flowComposer.getLineAt(this._textFlow.flowComposer.numLines - 1);
               if(_loc2_)
               {
                  _loc1_ = _loc2_.descent;
               }
            }
         }
         return this._controller.getContentBounds().height - _loc1_;
      }
      
      public function getRowHeight() : Number
      {
         return !!this.getRow()?Number(this.getRow().composedHeight):Number(NaN);
      }
      
      public function get rowSpan() : uint
      {
         return this._rowSpan;
      }
      
      public function set rowSpan(param1:uint) : void
      {
         if(param1 >= 1)
         {
            this._rowSpan = param1;
         }
      }
      
      public function get columnSpan() : uint
      {
         return this._columnSpan;
      }
      
      public function set columnSpan(param1:uint) : void
      {
         if(param1 >= 1)
         {
            this._columnSpan = param1;
         }
      }
      
      public function updateCompositionShapes() : void
      {
         this._controller.updateCompositionShapes();
      }
      
      public function getRow() : TableRowElement
      {
         return !!table?table.getRowAt(this.rowIndex):null;
      }
      
      public function getNextCell() : TableCellElement
      {
         return !!table?table.getNextCell(this):null;
      }
      
      public function getPreviousCell() : TableCellElement
      {
         return !!table?table.getPreviousCell(this):null;
      }
      
      public function get x() : Number
      {
         return this.container.x;
      }
      
      public function set x(param1:Number) : void
      {
         this.container.x = param1;
      }
      
      public function get y() : Number
      {
         return this.container.y;
      }
      
      public function set y(param1:Number) : void
      {
         this.container.y = param1;
      }
      
      public function damage() : void
      {
         if(table)
         {
            table.hasCellDamage = true;
         }
         this._damaged = true;
      }
      
      public function getTotalPaddingWidth() : Number
      {
         var _loc1_:Number = 0;
         if(!this.textFlow)
         {
            return 0;
         }
         if(table && table.cellSpacing != undefined)
         {
            _loc1_ = _loc1_ + table.cellSpacing;
         }
         if(this.textFlow.computedFormat.blockProgression == BlockProgression.RL)
         {
            _loc1_ = _loc1_ + Math.max(getEffectivePaddingTop() + getEffectivePaddingBottom(),getEffectiveBorderTopWidth() + getEffectiveBorderBottomWidth());
         }
         else
         {
            _loc1_ = _loc1_ + Math.max(getEffectivePaddingLeft() + getEffectivePaddingRight(),getEffectiveBorderLeftWidth() + getEffectiveBorderRightWidth());
         }
         return _loc1_;
      }
      
      public function getTotalPaddingHeight() : Number
      {
         var _loc1_:Number = 0;
         if(!this.textFlow)
         {
            return 0;
         }
         if(table && table.cellSpacing != undefined)
         {
            _loc1_ = _loc1_ + table.cellSpacing;
         }
         if(this.textFlow.computedFormat.blockProgression == BlockProgression.RL)
         {
            _loc1_ = _loc1_ + Math.max(getEffectivePaddingLeft() + getEffectivePaddingRight(),getEffectiveBorderLeftWidth() + getEffectiveBorderRightWidth());
         }
         else
         {
            _loc1_ = _loc1_ + Math.max(getEffectivePaddingTop() + getEffectivePaddingBottom(),getEffectiveBorderTopWidth() + getEffectiveBorderBottomWidth());
         }
         return _loc1_;
      }
      
      public function get includeDescentInCellBounds() : Boolean
      {
         return this._includeDescentInCellBounds;
      }
      
      public function set includeDescentInCellBounds(param1:Boolean) : void
      {
         this._includeDescentInCellBounds = param1;
      }
   }
}
