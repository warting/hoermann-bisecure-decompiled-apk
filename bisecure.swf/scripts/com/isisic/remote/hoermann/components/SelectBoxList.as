package com.isisic.remote.hoermann.components
{
   import com.isisic.remote.lw.IDisposable;
   import flash.events.Event;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import spark.components.LabelItemRenderer;
   import spark.components.List;
   import spark.components.supportClasses.ItemRenderer;
   import spark.events.IndexChangeEvent;
   
   public class SelectBoxList extends List implements IDisposable
   {
       
      
      private var _itemDisabledFunction:Function;
      
      public function SelectBoxList()
      {
         super();
         this.addEventListener(IndexChangeEvent.CHANGING,this.onIndexChangeing,false,EventPriority.BINDING);
      }
      
      public function dispose() : void
      {
         this.removeEventListener(IndexChangeEvent.CHANGING,this.onIndexChangeing);
         this._itemDisabledFunction = null;
      }
      
      public function set itemDisabledFunction(param1:Function) : void
      {
         if(this._itemDisabledFunction == param1)
         {
            return;
         }
         this._itemDisabledFunction = param1;
         var _loc2_:IFactory = itemRenderer;
         itemRenderer = null;
         itemRenderer = _loc2_;
      }
      
      public function get itemDisabledFunction() : Function
      {
         return this._itemDisabledFunction;
      }
      
      protected function onIndexChangeing(param1:IndexChangeEvent) : void
      {
         var _loc2_:UIComponent = dataGroup.getElementAt(param1.newIndex) as UIComponent;
         if(_loc2_.enabled == false)
         {
            param1.preventDefault();
         }
         else
         {
            this.updateRendererEnabled();
         }
      }
      
      override protected function dataProvider_collectionChangeHandler(param1:Event) : void
      {
         super.dataProvider_collectionChangeHandler(param1);
         this.updateRendererEnabled();
      }
      
      override public function updateRenderer(param1:IVisualElement, param2:int, param3:Object) : void
      {
         super.updateRenderer(param1,param2,param3);
         this.updateRendererProperties(param1,param3,param2);
      }
      
      public function updateRendererEnabled() : void
      {
         var _loc2_:IVisualElement = null;
         var _loc1_:int = 0;
         while(_loc1_ < dataGroup.numElements)
         {
            _loc2_ = dataGroup.getElementAt(_loc1_);
            this.updateRendererProperties(_loc2_,dataProvider.getItemAt(_loc1_),_loc1_);
            _loc1_++;
         }
      }
      
      protected function updateRendererProperties(param1:IVisualElement, param2:Object, param3:int) : void
      {
         var _loc4_:* = true;
         if(this.itemDisabledFunction != null)
         {
            _loc4_ = !this.itemDisabledFunction.call(null,param2,param3);
         }
         if(param1 is ItemRenderer)
         {
            (param1 as ItemRenderer).enabled = _loc4_;
         }
         if(param1 is LabelItemRenderer)
         {
            (param1 as LabelItemRenderer).enabled = _loc4_;
         }
      }
   }
}
