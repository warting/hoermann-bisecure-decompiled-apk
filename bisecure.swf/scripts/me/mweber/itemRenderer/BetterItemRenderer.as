package me.mweber.itemRenderer
{
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import spark.components.DataGroup;
   import spark.components.supportClasses.InteractionState;
   import spark.components.supportClasses.InteractionStateDetector;
   import spark.components.supportClasses.ItemRenderer;
   
   public class BetterItemRenderer extends ItemRenderer
   {
       
      
      protected var isLastItem:Boolean = false;
      
      protected var interactionStateDetector:InteractionStateDetector;
      
      public function BetterItemRenderer()
      {
         super();
         this.interactionStateDetector = new InteractionStateDetector(this);
         this.interactionStateDetector.addEventListener(Event.CHANGE,this.interactionStateChanged);
         this.autoDrawBackground = false;
         this.minHeight = this.preferedMinHeight;
      }
      
      public function enableDragDrop() : void
      {
      }
      
      protected function disableDragDrop() : void
      {
      }
      
      public function get preferedMinHeight() : Number
      {
         switch(this.applicationDPI)
         {
            case DPIClassification.DPI_320:
               return 88;
            case DPIClassification.DPI_240:
               return 66;
            default:
               return 44;
         }
      }
      
      override public function set itemIndex(param1:int) : void
      {
         var _loc2_:Boolean = this.isLastItem;
         var _loc3_:DataGroup = this.parent as DataGroup;
         this.isLastItem = _loc3_ && param1 == _loc3_.numElements - 1;
         if(_loc2_ != this.isLastItem)
         {
            invalidateDisplayList();
         }
         super.itemIndex = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         this.graphics.clear();
         super.updateDisplayList(param1,param2);
         this.drawBackground(param1,param2);
         this.drawBorder(param1,param2);
         this.layoutComponents(param1,param2);
      }
      
      override protected function set down(param1:Boolean) : void
      {
         super.down = param1;
         this.invalidateDisplayList();
      }
      
      override protected function set hovered(param1:Boolean) : void
      {
         super.hovered = param1;
         this.invalidateDisplayList();
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.invalidateDisplayList();
      }
      
      override public function set showsCaret(param1:Boolean) : void
      {
         super.showsCaret = param1;
         this.invalidateDisplayList();
      }
      
      public function get applicationDPI() : Number
      {
         return FlexGlobals.topLevelApplication.applicationDPI;
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc4_:Boolean = true;
         var _loc5_:* = getStyle("downColor");
         if(this.interactionStateDetector.state == InteractionState.DOWN && _loc5_ !== undefined)
         {
            _loc3_ = _loc5_;
         }
         else if(selected)
         {
            _loc3_ = getStyle("selectionColor");
         }
         else if(this.interactionStateDetector.state == InteractionState.OVER)
         {
            _loc3_ = getStyle("rollOverColor");
         }
         else
         {
            _loc7_ = getStyle("alternatingItemColors");
            if(_loc7_)
            {
               _loc6_ = _loc7_ is Array?_loc7_ as Array:[_loc7_];
            }
            if(_loc6_ && _loc6_.length > 0)
            {
               styleManager.getColorNames(_loc6_);
               _loc3_ = _loc6_[itemIndex % _loc6_.length];
            }
            else
            {
               _loc4_ = false;
            }
         }
         graphics.beginFill(_loc3_,!!_loc4_?Number(1):Number(0));
         if(showsCaret)
         {
            graphics.lineStyle(1,getStyle("selectionColor"));
            graphics.drawRect(0.5,0.5,param1 - 1,param2 - 1);
         }
         else
         {
            graphics.lineStyle();
            graphics.drawRect(0,0,param1,param2);
         }
         graphics.endFill();
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
         if(!(selected || down))
         {
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,0,param1,1);
            graphics.endFill();
         }
         graphics.beginFill(_loc5_,_loc6_);
         graphics.drawRect(0,param2 - (!!this.isLastItem?0:1),param1,1);
         graphics.endFill();
         if(itemIndex == 0)
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
      
      protected function layoutComponents(param1:Number, param2:Number) : void
      {
      }
      
      protected function interactionStateChanged(param1:Event) : void
      {
         invalidateDisplayList();
      }
      
      protected function readStyle(param1:String, param2:*) : *
      {
         return getStyle(param1) === undefined?param2:getStyle(param1);
      }
   }
}
