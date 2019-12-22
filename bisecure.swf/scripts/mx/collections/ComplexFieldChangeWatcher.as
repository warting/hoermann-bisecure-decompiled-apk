package mx.collections
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.binding.utils.ChangeWatcher;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   public class ComplexFieldChangeWatcher extends EventDispatcher
   {
       
      
      private var _complexFieldWatchers:Dictionary;
      
      private var _list:IList;
      
      private var _listCollection:ICollectionView;
      
      public function ComplexFieldChangeWatcher()
      {
         this._complexFieldWatchers = new Dictionary(true);
         super();
      }
      
      public function stopWatchingForComplexFieldChanges() : void
      {
         this.unwatchListForChanges();
         this.unwatchAllItems();
      }
      
      private function unwatchAllItems() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._complexFieldWatchers)
         {
            this.unwatchItem(_loc1_);
            delete this._complexFieldWatchers[_loc1_];
         }
      }
      
      private function unwatchArrayOfItems(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.unwatchItem(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function unwatchItem(param1:Object) : void
      {
         var _loc3_:ChangeWatcher = null;
         var _loc2_:Array = this._complexFieldWatchers[param1] as Array;
         while(_loc2_ && _loc2_.length)
         {
            _loc3_ = _loc2_.pop() as ChangeWatcher;
            if(_loc3_)
            {
               _loc3_.unwatch();
            }
         }
      }
      
      public function startWatchingForComplexFieldChanges() : void
      {
         this.watchListForChanges();
         this.watchAllItems();
      }
      
      private function watchAllItems() : void
      {
         this.watchItems(this.list);
      }
      
      private function watchItems(param1:IList) : void
      {
         var _loc2_:int = 0;
         if(this.sortFields)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.watchItem(param1.getItemAt(_loc2_),this.sortFields);
               _loc2_++;
            }
         }
      }
      
      private function watchArrayOfItems(param1:Array) : void
      {
         var _loc2_:int = 0;
         if(this.sortFields)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.watchItem(param1[_loc2_],this.sortFields);
               _loc2_++;
            }
         }
      }
      
      private function watchItem(param1:Object, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:IComplexSortField = null;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.length)
            {
               _loc4_ = param2[_loc3_] as IComplexSortField;
               if(_loc4_ && _loc4_.nameParts)
               {
                  this.watchItemForField(param1,_loc4_.nameParts);
               }
               _loc3_++;
            }
         }
      }
      
      private function watchItemForField(param1:Object, param2:Array) : void
      {
         var _loc3_:ChangeWatcher = ChangeWatcher.watch(param1,param2,new Closure(param1,this.onComplexValueChanged).callFunctionOnObject,false,true);
         if(_loc3_)
         {
            this.addWatcher(_loc3_,param1);
         }
      }
      
      private function addWatcher(param1:ChangeWatcher, param2:Object) : void
      {
         if(!this._complexFieldWatchers[param2])
         {
            this._complexFieldWatchers[param2] = [];
         }
         (this._complexFieldWatchers[param2] as Array).push(param1);
      }
      
      private function onComplexValueChanged(param1:Object) : void
      {
         dispatchEvent(PropertyChangeEvent.createUpdateEvent(param1,null,null,null));
      }
      
      private function get sortFields() : Array
      {
         return this._listCollection && this._listCollection.sort?this._listCollection.sort.fields:null;
      }
      
      mx_internal function set list(param1:IList) : void
      {
         if(this._list != param1)
         {
            this.stopWatchingForComplexFieldChanges();
            this._list = param1;
            this._listCollection = param1 as ICollectionView;
         }
      }
      
      protected function get list() : IList
      {
         return this._list;
      }
      
      private function watchListForChanges() : void
      {
         if(this.list)
         {
            this.list.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChanged,false,0,true);
         }
      }
      
      private function unwatchListForChanges() : void
      {
         if(this.list)
         {
            this.list.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onCollectionChanged);
         }
      }
      
      private function onCollectionChanged(param1:CollectionEvent) : void
      {
         switch(param1.kind)
         {
            case CollectionEventKind.ADD:
               this.watchArrayOfItems(param1.items);
               break;
            case CollectionEventKind.REMOVE:
               this.unwatchArrayOfItems(param1.items);
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.reset();
         }
      }
      
      private function reset() : void
      {
         this.unwatchAllItems();
         this.watchAllItems();
      }
   }
}

import flash.events.Event;

class Closure
{
    
   
   private var _object:Object;
   
   private var _function:Function;
   
   function Closure(param1:Object, param2:Function)
   {
      super();
      this._object = param1;
      this._function = param2;
   }
   
   public function callFunctionOnObject(param1:Event) : void
   {
      this._function.apply(null,[this._object]);
   }
}
