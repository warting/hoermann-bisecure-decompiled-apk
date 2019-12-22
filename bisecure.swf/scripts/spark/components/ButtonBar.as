package spark.components
{
   import flash.events.Event;
   import mx.collections.IList;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.managers.IFocusManagerComponent;
   import spark.components.supportClasses.ButtonBarBase;
   
   use namespace mx_internal;
   
   public class ButtonBar extends ButtonBarBase implements IFocusManagerComponent
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      [SkinPart(type="mx.core.IVisualElement",required="false")]
      public var firstButton:IFactory;
      
      [SkinPart(type="mx.core.IVisualElement",required="false")]
      public var lastButton:IFactory;
      
      [SkinPart(type="mx.core.IVisualElement",required="true")]
      public var middleButton:IFactory;
      
      public function ButtonBar()
      {
         super();
         itemRendererFunction = this.defaultButtonBarItemRendererFunction;
      }
      
      override public function set dataProvider(param1:IList) : void
      {
         if(dataProvider)
         {
            dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.resetCollectionChangeHandler);
         }
         if(param1)
         {
            param1.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.resetCollectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
         }
         super.dataProvider = param1;
      }
      
      private function resetCollectionChangeHandler(param1:Event) : void
      {
         var _loc2_:CollectionEvent = null;
         if(param1 is CollectionEvent)
         {
            _loc2_ = CollectionEvent(param1);
            if(_loc2_.kind == CollectionEventKind.ADD || _loc2_.kind == CollectionEventKind.REMOVE)
            {
               if(dataGroup)
               {
                  dataGroup.layout.useVirtualLayout = true;
                  dataGroup.layout.useVirtualLayout = false;
               }
            }
         }
      }
      
      override mx_internal function setCurrentCaretIndex(param1:Number) : void
      {
         if(param1 == -1)
         {
            return;
         }
         super.setCurrentCaretIndex(param1);
      }
      
      private function defaultButtonBarItemRendererFunction(param1:Object) : IFactory
      {
         var _loc2_:int = dataProvider.getItemIndex(param1);
         if(_loc2_ == 0)
         {
            return !!this.firstButton?this.firstButton:this.middleButton;
         }
         var _loc3_:int = dataProvider.length - 1;
         if(_loc2_ == _loc3_)
         {
            return !!this.lastButton?this.lastButton:this.middleButton;
         }
         return this.middleButton;
      }
   }
}
