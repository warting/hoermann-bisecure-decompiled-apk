package spark.components
{
   import flash.display.GradientType;
   import flash.events.Event;
   import flash.geom.Matrix;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.IDataRenderer;
   import mx.core.IFlexDisplayObject;
   import mx.core.ILayoutElement;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import spark.components.supportClasses.InteractionState;
   import spark.components.supportClasses.InteractionStateDetector;
   import spark.components.supportClasses.StyleableTextField;
   
   use namespace mx_internal;
   
   public class LabelItemRenderer extends UIComponent implements IDataRenderer, IItemRenderer
   {
       
      
      private var interactionStateDetector:InteractionStateDetector;
      
      mx_internal var isLastItem:Boolean = false;
      
      private var _data:Object;
      
      private var _down:Boolean = false;
      
      private var _hovered:Boolean = false;
      
      private var _itemIndex:int;
      
      private var _label:String = "";
      
      protected var labelDisplay:StyleableTextField;
      
      private var _showsCaret:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragging:Boolean = false;
      
      public function LabelItemRenderer()
      {
         super();
         switch(this.applicationDPI)
         {
            case DPIClassification.DPI_640:
               minHeight = 176;
               break;
            case DPIClassification.DPI_480:
               minHeight = 132;
               break;
            case DPIClassification.DPI_320:
               minHeight = 88;
               break;
            case DPIClassification.DPI_240:
               minHeight = 66;
               break;
            case DPIClassification.DPI_120:
               minHeight = 33;
               break;
            default:
               minHeight = 44;
         }
         this.interactionStateDetector = new InteractionStateDetector(this);
         this.interactionStateDetector.addEventListener(Event.CHANGE,this.interactionStateDetector_changeHandler);
         cacheAsBitmap = true;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!parent)
         {
            return NaN;
         }
         return this.labelDisplay.baselinePosition;
      }
      
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         if(hasEventListener(FlexEvent.DATA_CHANGE))
         {
            dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
         }
      }
      
      protected function get down() : Boolean
      {
         return this._down;
      }
      
      protected function set down(param1:Boolean) : void
      {
         if(param1 == this._down)
         {
            return;
         }
         this._down = param1;
         invalidateDisplayList();
      }
      
      protected function get hovered() : Boolean
      {
         return this._hovered;
      }
      
      protected function set hovered(param1:Boolean) : void
      {
         if(param1 == this._hovered)
         {
            return;
         }
         this._hovered = param1;
         invalidateDisplayList();
      }
      
      public function get itemIndex() : int
      {
         return this._itemIndex;
      }
      
      public function set itemIndex(param1:int) : void
      {
         var _loc2_:Boolean = this.isLastItem;
         var _loc3_:DataGroup = parent as DataGroup;
         this.isLastItem = _loc3_ && param1 == _loc3_.numElements - 1;
         if(_loc2_ != this.isLastItem)
         {
            invalidateDisplayList();
         }
         if(param1 == this._itemIndex)
         {
            return;
         }
         this._itemIndex = param1;
         if(getStyle("alternatingItemColors") !== undefined)
         {
            invalidateDisplayList();
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         if(param1 == this._label)
         {
            return;
         }
         this._label = param1;
         if(this.labelDisplay)
         {
            this.labelDisplay.text = this._label;
            invalidateSize();
         }
      }
      
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(param1:Boolean) : void
      {
         if(param1 == this._showsCaret)
         {
            return;
         }
         this._showsCaret = param1;
         invalidateDisplayList();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1 == this._selected)
         {
            return;
         }
         this._selected = param1;
         invalidateDisplayList();
      }
      
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function set dragging(param1:Boolean) : void
      {
         this._dragging = param1;
      }
      
      public function get applicationDPI() : Number
      {
         return FlexGlobals.topLevelApplication.applicationDPI;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.labelDisplay)
         {
            this.createLabelDisplay();
            this.labelDisplay.text = this._label;
         }
      }
      
      protected function createLabelDisplay() : void
      {
         this.labelDisplay = StyleableTextField(createInFontContext(StyleableTextField));
         this.labelDisplay.styleName = this;
         this.labelDisplay.editable = false;
         this.labelDisplay.selectable = false;
         this.labelDisplay.multiline = false;
         this.labelDisplay.wordWrap = false;
         addChild(this.labelDisplay);
      }
      
      protected function destroyLabelDisplay() : void
      {
         removeChild(this.labelDisplay);
         this.labelDisplay = null;
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         super.measure();
         if(this.labelDisplay)
         {
            if(this.labelDisplay.isTruncated)
            {
               this.labelDisplay.text = this.label;
            }
            _loc1_ = getStyle("paddingLeft") + getStyle("paddingRight");
            _loc2_ = getStyle("paddingTop") + getStyle("paddingBottom");
            this.labelDisplay.commitStyles();
            measuredWidth = this.getElementPreferredWidth(this.labelDisplay) + _loc1_;
            measuredHeight = this.getElementPreferredHeight(this.labelDisplay) + _loc2_;
         }
         measuredMinWidth = 0;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         graphics.clear();
         super.updateDisplayList(param1,param2);
         this.drawBackground(param1,param2);
         this.layoutContents(param1,param2);
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:* = undefined;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Matrix = null;
         var _loc13_:* = undefined;
         var _loc4_:* = getStyle("downColor");
         var _loc5_:Boolean = true;
         var _loc6_:* = undefined;
         if(this.down && _loc4_ !== undefined)
         {
            _loc3_ = _loc4_;
         }
         else if(this.selected)
         {
            _loc3_ = getStyle("selectionColor");
         }
         else if(this.hovered)
         {
            _loc3_ = getStyle("rollOverColor");
         }
         else if(this.showsCaret)
         {
            _loc3_ = getStyle("selectionColor");
         }
         else
         {
            _loc8_ = getStyle("alternatingItemColors");
            if(_loc8_)
            {
               _loc7_ = _loc8_ is Array?_loc8_ as Array:[_loc8_];
            }
            if(_loc7_ && _loc7_.length > 0)
            {
               styleManager.getColorNames(_loc7_);
               _loc3_ = _loc7_[this.itemIndex % _loc7_.length];
            }
            else
            {
               _loc5_ = false;
            }
         }
         graphics.beginFill(_loc3_,!!_loc5_?Number(1):Number(0));
         graphics.lineStyle();
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
         if(this.selected || this.down)
         {
            _loc9_ = [0,0];
            _loc10_ = [0.2,0.1];
            _loc11_ = [0,255];
            _loc12_ = new Matrix();
            _loc12_.createGradientBox(param1,param2,Math.PI / 2,0,0);
            graphics.beginGradientFill(GradientType.LINEAR,_loc9_,_loc10_,_loc11_,_loc12_);
            graphics.drawRect(0,0,param1,param2);
            graphics.endFill();
         }
         else if(_loc5_)
         {
            _loc13_ = getStyle("useOpaqueBackground");
            if(_loc13_ == undefined || _loc13_ == true)
            {
               _loc6_ = _loc3_;
            }
         }
         this.drawBorder(param1,param2);
         opaqueBackground = _loc6_;
      }
      
      protected function drawBorder(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         _loc3_ = 16777215;
         _loc4_ = 0.3;
         _loc5_ = 0;
         _loc6_ = 0.3;
         if(!(this.selected || this.down))
         {
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,0,param1,1);
            graphics.endFill();
         }
         graphics.beginFill(_loc5_,_loc6_);
         graphics.drawRect(0,param2 - (!!this.isLastItem?0:1),param1,1);
         graphics.endFill();
         if(this.itemIndex == 0)
         {
            graphics.beginFill(_loc5_,_loc6_);
            graphics.drawRect(0,-1,param1,1);
            graphics.endFill();
         }
         if(this.isLastItem)
         {
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,param2 + 1,param1,1);
            graphics.endFill();
         }
      }
      
      protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc10_:Number = NaN;
         if(!this.labelDisplay)
         {
            return;
         }
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingRight");
         var _loc5_:Number = getStyle("paddingTop");
         var _loc6_:Number = getStyle("paddingBottom");
         var _loc7_:String = getStyle("verticalAlign");
         var _loc8_:Number = param1 - _loc3_ - _loc4_;
         var _loc9_:Number = param2 - _loc5_ - _loc6_;
         if(_loc7_ == "top")
         {
            _loc10_ = 0;
         }
         else if(_loc7_ == "bottom")
         {
            _loc10_ = 1;
         }
         else
         {
            _loc10_ = 0.5;
         }
         var _loc11_:Number = Math.max(_loc8_,0);
         var _loc12_:Number = 0;
         if(this.label != "")
         {
            this.labelDisplay.commitStyles();
            if(this.labelDisplay.isTruncated)
            {
               this.labelDisplay.text = this.label;
            }
            _loc12_ = this.getElementPreferredHeight(this.labelDisplay);
         }
         this.setElementSize(this.labelDisplay,_loc11_,_loc12_);
         var _loc13_:Number = Math.round(_loc10_ * (_loc9_ - _loc12_)) + _loc5_;
         this.setElementPosition(this.labelDisplay,_loc3_,_loc13_);
         this.labelDisplay.truncateToFit();
      }
      
      protected function setElementPosition(param1:Object, param2:Number, param3:Number) : void
      {
         if(param1 is ILayoutElement)
         {
            ILayoutElement(param1).setLayoutBoundsPosition(param2,param3,false);
         }
         else if(param1 is IFlexDisplayObject)
         {
            IFlexDisplayObject(param1).move(param2,param3);
         }
         else
         {
            param1.x = param2;
            param1.y = param3;
         }
      }
      
      protected function setElementSize(param1:Object, param2:Number, param3:Number) : void
      {
         if(param1 is ILayoutElement)
         {
            ILayoutElement(param1).setLayoutBoundsSize(param2,param3,false);
         }
         else if(param1 is IFlexDisplayObject)
         {
            IFlexDisplayObject(param1).setActualSize(param2,param3);
         }
         else
         {
            param1.width = param2;
            param1.height = param3;
         }
      }
      
      protected function getElementPreferredWidth(param1:Object) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 is ILayoutElement)
         {
            _loc2_ = ILayoutElement(param1).getPreferredBoundsWidth();
         }
         else if(param1 is IFlexDisplayObject)
         {
            _loc2_ = IFlexDisplayObject(param1).measuredWidth;
         }
         else
         {
            _loc2_ = param1.width;
         }
         return Math.round(_loc2_);
      }
      
      protected function getElementPreferredHeight(param1:Object) : Number
      {
         var _loc2_:Number = NaN;
         if(param1 is ILayoutElement)
         {
            _loc2_ = ILayoutElement(param1).getPreferredBoundsHeight();
         }
         else if(param1 is IFlexDisplayObject)
         {
            _loc2_ = IFlexDisplayObject(param1).measuredHeight;
         }
         else
         {
            _loc2_ = param1.height;
         }
         return Math.ceil(_loc2_);
      }
      
      private function interactionStateDetector_changeHandler(param1:Event) : void
      {
         this.down = this.interactionStateDetector.state == InteractionState.DOWN;
         this.hovered = this.interactionStateDetector.state == InteractionState.OVER;
      }
   }
}
