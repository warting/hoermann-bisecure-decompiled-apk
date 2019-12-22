package refactor.bisecur._1_APP.components.popups
{
   import com.isisic.remote.hoermann.components.SelectBoxList;
   import com.isisic.remote.hoermann.components.VLine;
   import com.isisic.remote.hoermann.renderer.SelectBoxItemRenderer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayList;
   import mx.core.ClassFactory;
   import mx.events.FlexEvent;
   import refactor.logicware._5_UTIL.IDisposable;
   import spark.components.Button;
   import spark.events.IndexChangeEvent;
   import spark.layouts.BasicLayout;
   
   public class SelectBox extends Popup implements IDisposable
   {
       
      
      private var selected:Object;
      
      private var items:ArrayList;
      
      private var vLine:VLine;
      
      private var lstItems:SelectBoxList;
      
      private var measureRenderer:SelectBoxItemRenderer;
      
      private var _tmpItemDisabledFunction:Function;
      
      private var _tmpLabelField:String;
      
      private var _tmpLabelFunction:Function;
      
      private var btnClose:Button;
      
      public function SelectBox(param1:Array, param2:Object = null)
      {
         super();
         this.items = new ArrayList(param1);
         this.layout = new BasicLayout();
         this.selected = param2;
      }
      
      public function dispose() : void
      {
         this.selected = null;
         this.items = null;
         this.vLine = null;
         this.lstItems.removeEventListener(IndexChangeEvent.CHANGE,this.onSelect);
         this.lstItems.removeEventListener(FlexEvent.CREATION_COMPLETE,this.onListComplete);
         this.lstItems.labelField = null;
         this.lstItems.labelFunction = null;
         this.lstItems.dispose();
         this.lstItems = null;
         this._tmpItemDisabledFunction = null;
         this._tmpLabelField = null;
         this._tmpLabelFunction = null;
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onClose);
         this.btnClose = null;
      }
      
      public function set itemDisabledFunction(param1:Function) : void
      {
         if(this._tmpItemDisabledFunction == param1)
         {
            return;
         }
         this._tmpItemDisabledFunction = param1;
         if(this.lstItems)
         {
            this.onListComplete();
         }
      }
      
      public function get itemDisabledFunction() : Function
      {
         return this._tmpItemDisabledFunction;
      }
      
      public function set labelField(param1:String) : void
      {
         this._tmpLabelField = param1;
         if(this.lstItems)
         {
            this.onListComplete();
         }
      }
      
      public function get labelField() : String
      {
         return this._tmpLabelField;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._tmpLabelFunction = param1;
         if(this.lstItems)
         {
            this.onListComplete();
         }
      }
      
      public function get labelFunction() : Function
      {
         return this._tmpLabelFunction;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.btnClose = new Button();
         this.btnClose.label = "X";
         this.btnClose.setStyle("color",2302755);
         this.btnClose.setStyle("backgroundColor",16777215);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.titleBar.addElement(this.btnClose);
         this.vLine = new VLine();
         this.vLine.setStyle("backgroundColor",10027025);
         this.vLine.setStyle("backgroundAlpha",0.5);
         this.lstItems = new SelectBoxList();
         this.lstItems.dataProvider = this.items;
         this.lstItems.itemRenderer = new ClassFactory(SelectBoxItemRenderer);
         this.lstItems.addEventListener(IndexChangeEvent.CHANGE,this.onSelect);
         this.lstItems.selectedItem = this.selected;
         this.lstItems.addEventListener(FlexEvent.CREATION_COMPLETE,this.onListComplete);
         this.addElement(this.lstItems);
         this.measureRenderer = new SelectBoxItemRenderer();
         this.measureRenderer.includeInLayout = false;
         this.measureRenderer.visible = false;
         this.measureRenderer.data = "Lerum Ipsum";
         addElement(this.measureRenderer);
      }
      
      protected function onClose(param1:MouseEvent) : void
      {
         this.close();
      }
      
      protected function updateItemStates() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.items.length)
         {
            this.itemDisabledFunction.call(null,this.items[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      protected function onListComplete(param1:FlexEvent = null) : void
      {
         if(this._tmpLabelField != null)
         {
            this.lstItems.labelField = this._tmpLabelField;
         }
         if(this._tmpLabelFunction != null)
         {
            this.lstItems.labelFunction = this._tmpLabelFunction;
         }
         if(this._tmpItemDisabledFunction != null)
         {
            this.lstItems.itemDisabledFunction = this._tmpItemDisabledFunction;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.btnClose.right = 0;
         this.btnClose.width = this.titleBar.height;
         this.vLine.width = this.content.width;
         this.lstItems.y = 5;
         this.lstItems.width = this.content.width;
         this.lstItems.height = this.itemMinHeight * this.items.length;
         this.lstItems.maxHeight = param2 / 3 * 2;
         if(this.lstItems.height > this.lstItems.maxHeight)
         {
            this.lstItems.height = this.lstItems.maxHeight;
         }
      }
      
      private function onSelect(param1:Event) : void
      {
         this.close(true,this.lstItems.selectedItem);
      }
      
      private function get itemMinHeight() : Number
      {
         return this.measureRenderer.measuredHeight;
      }
   }
}
