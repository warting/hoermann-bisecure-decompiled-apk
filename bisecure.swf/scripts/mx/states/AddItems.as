package mx.states
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.binding.BindingManager;
   import mx.collections.IList;
   import mx.core.ContainerCreationPolicy;
   import mx.core.IChildList;
   import mx.core.IDeferredContentOwner;
   import mx.core.IMXMLObject;
   import mx.core.ITransientDeferredInstance;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AddItems extends OverrideBase implements IMXMLObject
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      public static const FIRST:String = "first";
      
      public static const LAST:String = "last";
      
      public static const BEFORE:String = "before";
      
      public static const AFTER:String = "after";
       
      
      private var document:Object;
      
      private var added:Boolean = false;
      
      private var startIndex:int;
      
      private var numAdded:int;
      
      private var instanceCreated:Boolean = false;
      
      private var _creationPolicy:String = "auto";
      
      private var _destructionPolicy:String = "never";
      
      public var destination:Object;
      
      private var _items;
      
      private var _itemsDescriptor:Array;
      
      private var _itemsFactory:ITransientDeferredInstance;
      
      public var position:String = "last";
      
      public var isStyle:Boolean = false;
      
      public var isArray:Boolean = false;
      
      public var vectorClass:Class;
      
      public var propertyName:String;
      
      public var relativeTo:Object;
      
      private var _waitingForDeferredContent:Boolean = false;
      
      public function AddItems()
      {
         super();
      }
      
      public function get creationPolicy() : String
      {
         return this._creationPolicy;
      }
      
      public function set creationPolicy(param1:String) : void
      {
         this._creationPolicy = param1;
         if(this._creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      public function get destructionPolicy() : String
      {
         return this._destructionPolicy;
      }
      
      public function set destructionPolicy(param1:String) : void
      {
         this._destructionPolicy = param1;
      }
      
      public function get items() : *
      {
         if(!this._items && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createInstance();
         }
         return this._items;
      }
      
      public function set items(param1:*) : void
      {
         this._items = param1;
      }
      
      public function get itemsDescriptor() : Array
      {
         return this._itemsDescriptor;
      }
      
      public function set itemsDescriptor(param1:Array) : void
      {
         this._itemsDescriptor = param1;
         if(this.creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      public function get itemsFactory() : ITransientDeferredInstance
      {
         return this._itemsFactory;
      }
      
      public function set itemsFactory(param1:ITransientDeferredInstance) : void
      {
         this._itemsFactory = param1;
         if(this.creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      public function createInstance() : void
      {
         if(!this.instanceCreated && !this._items && this.itemsFactory && !this._itemsDescriptor)
         {
            this.instanceCreated = true;
            this.items = this.itemsFactory.getInstance();
         }
         else if(!this.instanceCreated && !this._items && !this.itemsFactory && this._itemsDescriptor)
         {
            this.instanceCreated = true;
            this.items = this.generateMXMLArray(this.document,this.itemsDescriptor,false);
         }
      }
      
      protected function generateMXMLObject(param1:Object, param2:Array) : Object
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:* = undefined;
         var _loc10_:Object = null;
         var _loc11_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Class = param2[_loc3_++];
         var _loc5_:Object = new _loc4_();
         _loc6_ = param2[_loc3_++];
         _loc7_ = 0;
         for(; _loc7_ < _loc6_; _loc7_++)
         {
            _loc8_ = param2[_loc3_++];
            _loc9_ = param2[_loc3_++];
            _loc10_ = param2[_loc3_++];
            if(_loc9_ === null)
            {
               _loc10_ = this.generateMXMLArray(param1,_loc10_ as Array);
            }
            else if(_loc9_ === undefined)
            {
               _loc10_ = this.generateMXMLVector(param1,_loc10_ as Array);
            }
            else if(_loc9_ == false)
            {
               _loc10_ = this.generateMXMLObject(param1,_loc10_ as Array);
            }
            if(_loc8_ == "id")
            {
               param1[_loc10_] = _loc5_;
               _loc11_ = _loc10_ as String;
               if(_loc5_ is IMXMLObject)
               {
                  continue;
               }
               if(!("id" in _loc5_))
               {
                  continue;
               }
            }
            else if(_loc8_ == "_id")
            {
               param1[_loc10_] = _loc5_;
               _loc11_ = _loc10_ as String;
               continue;
            }
            _loc5_[_loc8_] = _loc10_;
         }
         _loc6_ = param2[_loc3_++];
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param2[_loc3_++];
            _loc9_ = param2[_loc3_++];
            _loc10_ = param2[_loc3_++];
            if(_loc9_ == null)
            {
               _loc10_ = this.generateMXMLArray(param1,_loc10_ as Array);
            }
            else if(_loc9_ == false)
            {
               _loc10_ = this.generateMXMLObject(param1,_loc10_ as Array);
            }
            _loc5_.setStyle(_loc8_,_loc10_);
            _loc7_++;
         }
         _loc6_ = param2[_loc3_++];
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param2[_loc3_++];
            _loc9_ = param2[_loc3_++];
            _loc10_ = param2[_loc3_++];
            if(_loc9_ == null)
            {
               _loc10_ = this.generateMXMLArray(param1,_loc10_ as Array);
            }
            else if(_loc9_ == false)
            {
               _loc10_ = this.generateMXMLObject(param1,_loc10_ as Array);
            }
            _loc5_.setStyle(_loc8_,_loc10_);
            _loc7_++;
         }
         _loc6_ = param2[_loc3_++];
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param2[_loc3_++];
            _loc10_ = param2[_loc3_++];
            _loc5_.addEventListener(_loc8_,_loc10_);
            _loc7_++;
         }
         if(_loc5_ is IUIComponent)
         {
            if(_loc5_.document == null)
            {
               _loc5_.document = param1;
            }
         }
         var _loc12_:Array = param2[_loc3_++];
         if(_loc12_)
         {
            _loc5_.generateMXMLInstances(param1,_loc12_);
         }
         if(_loc11_)
         {
            param1[_loc11_] = _loc5_;
            BindingManager.executeBindings(param1,_loc11_,_loc5_);
         }
         if(_loc5_ is IMXMLObject)
         {
            _loc5_.initialized(param1,_loc11_);
         }
         return _loc5_;
      }
      
      public function generateMXMLVector(param1:Object, param2:Array, param3:Boolean = true) : *
      {
         var _loc4_:Array = null;
         var _loc5_:int = param2.length;
         var _loc6_:* = param2.shift();
         var _loc7_:Function = param2.shift();
         _loc4_ = this.generateMXMLArray(param1,param2,param3);
         return _loc7_(_loc4_);
      }
      
      public function generateMXMLArray(param1:Object, param2:Array, param3:Boolean = true) : Array
      {
         var cls:Class = null;
         var comp:Object = null;
         var m:int = 0;
         var j:int = 0;
         var name:String = null;
         var simple:* = undefined;
         var value:Object = null;
         var id:String = null;
         var children:Array = null;
         var document:Object = param1;
         var data:Array = param2;
         var recursive:Boolean = param3;
         var comps:Array = [];
         var n:int = data.length;
         var i:int = 0;
         while(i < n)
         {
            cls = data[i++];
            comp = new cls();
            id = null;
            m = data[i++];
            j = 0;
            for(; j < m; j++)
            {
               name = data[i++];
               simple = data[i++];
               value = data[i++];
               if(simple === null)
               {
                  value = this.generateMXMLArray(document,value as Array,recursive);
               }
               else if(simple === undefined)
               {
                  value = this.generateMXMLVector(document,value as Array,recursive);
               }
               else if(simple == false)
               {
                  value = this.generateMXMLObject(document,value as Array);
               }
               if(name == "id")
               {
                  document[value] = comp;
                  id = value as String;
                  if(comp is IMXMLObject)
                  {
                     continue;
                  }
                  try
                  {
                     if(!("id" in comp))
                     {
                        continue;
                     }
                  }
                  catch(e:Error)
                  {
                     continue;
                  }
               }
               if(name == "document" && !comp.document)
               {
                  comp.document = document;
               }
               else if(name == "_id")
               {
                  id = value as String;
               }
               else
               {
                  comp[name] = value;
               }
            }
            m = data[i++];
            j = 0;
            while(j < m)
            {
               name = data[i++];
               simple = data[i++];
               value = data[i++];
               if(simple == null)
               {
                  value = this.generateMXMLArray(document,value as Array,recursive);
               }
               else if(simple == false)
               {
                  value = this.generateMXMLObject(document,value as Array);
               }
               comp.setStyle(name,value);
               j++;
            }
            m = data[i++];
            j = 0;
            while(j < m)
            {
               name = data[i++];
               simple = data[i++];
               value = data[i++];
               if(simple == null)
               {
                  value = this.generateMXMLArray(document,value as Array,recursive);
               }
               else if(simple == false)
               {
                  value = this.generateMXMLObject(document,value as Array);
               }
               comp.setStyle(name,value);
               j++;
            }
            m = data[i++];
            j = 0;
            while(j < m)
            {
               name = data[i++];
               value = data[i++];
               comp.addEventListener(name,value);
               j++;
            }
            if(comp is IUIComponent)
            {
               if(comp.document == null)
               {
                  comp.document = document;
               }
            }
            children = data[i++];
            if(children)
            {
               if(recursive)
               {
                  comp.generateMXMLInstances(document,children,recursive);
               }
               else
               {
                  comp.setMXMLDescriptor(children);
               }
            }
            if(id)
            {
               document[id] = comp;
               BindingManager.executeBindings(document,id,comp);
            }
            if(comp is IMXMLObject)
            {
               comp.initialized(document,id);
            }
            comps.push(comp);
         }
         return comps;
      }
      
      override public function initialize() : void
      {
         if(this.creationPolicy == ContainerCreationPolicy.AUTO)
         {
            this.createInstance();
         }
      }
      
      override public function apply(param1:UIComponent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:* = getOverrideContext(this.destination,param1);
         this.added = false;
         parentContext = param1;
         if(!_loc2_)
         {
            if(this.destination != null && !applied)
            {
               addContextListener(this.destination);
            }
            applied = true;
            return;
         }
         applied = true;
         this.destination = _loc2_;
         if(this.items is Array && !this.isArray)
         {
            _loc3_ = this.items;
         }
         else
         {
            _loc3_ = [this.items];
         }
         switch(this.position)
         {
            case FIRST:
               this.startIndex = 0;
               break;
            case LAST:
               this.startIndex = -1;
               break;
            case BEFORE:
               this.startIndex = this.getRelatedIndex(param1,_loc2_);
               break;
            case AFTER:
               this.startIndex = this.getRelatedIndex(param1,_loc2_) + 1;
         }
         if((this.propertyName == null || this.propertyName == "mxmlContent") && _loc2_ is IVisualElementContainer)
         {
            if(!this.addItemsToContentHolder(_loc2_ as IVisualElementContainer,_loc3_))
            {
               return;
            }
         }
         else if(this.propertyName == null && _loc2_ is IChildList)
         {
            this.addItemsToContainer(_loc2_ as IChildList,_loc3_);
         }
         else if(this.propertyName != null && !this.isStyle && _loc2_[this.propertyName] is IList)
         {
            this.addItemsToIList(_loc2_[this.propertyName],_loc3_);
         }
         else if(this.vectorClass)
         {
            this.addItemsToVector(_loc2_,this.propertyName,_loc3_);
         }
         else
         {
            this.addItemsToArray(_loc2_,this.propertyName,_loc3_);
         }
         this.added = true;
         this.numAdded = _loc3_.length;
      }
      
      override public function remove(param1:UIComponent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc2_:* = getOverrideContext(this.destination,param1);
         if(!this.added)
         {
            if(_loc2_ == null)
            {
               removeContextListener();
            }
            else if(this._waitingForDeferredContent)
            {
               this.removeCreationCompleteListener();
            }
            applied = false;
            parentContext = null;
            return;
         }
         if(this.items is Array && !this.isArray)
         {
            _loc3_ = this.items;
         }
         else
         {
            _loc3_ = [this.items];
         }
         if((this.propertyName == null || this.propertyName == "mxmlContent") && _loc2_ is IVisualElementContainer)
         {
            _loc4_ = 0;
            while(_loc4_ < this.numAdded)
            {
               if(IVisualElementContainer(_loc2_).numElements > this.startIndex)
               {
                  IVisualElementContainer(_loc2_).removeElementAt(this.startIndex);
               }
               _loc4_++;
            }
         }
         else if(this.propertyName == null && _loc2_ is IChildList)
         {
            _loc4_ = 0;
            while(_loc4_ < this.numAdded)
            {
               if(IChildList(_loc2_).numChildren > this.startIndex)
               {
                  IChildList(_loc2_).removeChildAt(this.startIndex);
               }
               _loc4_++;
            }
         }
         else if(this.propertyName != null && !this.isStyle && _loc2_[this.propertyName] is IList)
         {
            this.removeItemsFromIList(_loc2_[this.propertyName] as IList);
         }
         else if(this.vectorClass)
         {
            _loc5_ = !!this.isStyle?_loc2_.getStyle(this.propertyName):_loc2_[this.propertyName];
            if(this.numAdded < _loc5_.length)
            {
               _loc5_.splice(this.startIndex,this.numAdded);
               this.assign(_loc2_,this.propertyName,_loc5_);
            }
            else
            {
               this.assign(_loc2_,this.propertyName,new this.vectorClass());
            }
         }
         else
         {
            _loc6_ = !!this.isStyle?_loc2_.getStyle(this.propertyName):_loc2_[this.propertyName];
            if(this.numAdded < _loc6_.length)
            {
               _loc6_.splice(this.startIndex,this.numAdded);
               this.assign(_loc2_,this.propertyName,_loc6_);
            }
            else
            {
               this.assign(_loc2_,this.propertyName,[]);
            }
         }
         if(this.destructionPolicy == "auto")
         {
            this.destroyInstance();
         }
         this.added = false;
         applied = false;
         parentContext = null;
      }
      
      private function destroyInstance() : void
      {
         if(this._itemsFactory)
         {
            this.instanceCreated = false;
            this.items = null;
            this._itemsFactory.reset();
         }
      }
      
      protected function getObjectIndex(param1:Object, param2:Object) : int
      {
         try
         {
            if((this.propertyName == null || this.propertyName == "mxmlContent") && param2 is IVisualElementContainer)
            {
               return IVisualElementContainer(param2).getElementIndex(param1 as IVisualElement);
            }
            if(this.propertyName == null && param2 is IChildList)
            {
               return IChildList(param2).getChildIndex(DisplayObject(param1));
            }
            if(this.propertyName != null && !this.isStyle && param2[this.propertyName] is IList)
            {
               return IList(param2[this.propertyName].list).getItemIndex(param1);
            }
            if(this.propertyName != null && this.isStyle)
            {
               return param2.getStyle(this.propertyName).indexOf(param1);
            }
            return param2[this.propertyName].indexOf(param1);
         }
         catch(e:Error)
         {
         }
         return -1;
      }
      
      protected function getRelatedIndex(param1:UIComponent, param2:Object) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:int = -1;
         if(this.relativeTo is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < this.relativeTo.length && _loc3_ < 0)
            {
               _loc5_ = getOverrideContext(this.relativeTo[_loc4_],param1);
               _loc3_ = this.getObjectIndex(_loc5_,param2);
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = getOverrideContext(this.relativeTo,param1);
            _loc3_ = this.getObjectIndex(_loc5_,param2);
         }
         return _loc3_;
      }
      
      protected function addItemsToContentHolder(param1:IVisualElementContainer, param2:Array) : Boolean
      {
         var _loc4_:IDeferredContentOwner = null;
         if(param1 is IDeferredContentOwner && param1 is IEventDispatcher)
         {
            _loc4_ = param1 as IDeferredContentOwner;
            if(!_loc4_.deferredContentCreated)
            {
               IEventDispatcher(param1).addEventListener("contentCreationComplete",this.onDestinationContentCreated);
               this._waitingForDeferredContent = true;
               return false;
            }
         }
         if(this.startIndex == -1)
         {
            this.startIndex = param1.numElements;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.addElementAt(param2[_loc3_],this.startIndex + _loc3_);
            _loc3_++;
         }
         return true;
      }
      
      protected function addItemsToContainer(param1:IChildList, param2:Array) : void
      {
         if(this.startIndex == -1)
         {
            this.startIndex = param1.numChildren;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.addChildAt(param2[_loc3_],this.startIndex + _loc3_);
            _loc3_++;
         }
      }
      
      protected function addItemsToArray(param1:Object, param2:String, param3:Array) : void
      {
         var _loc4_:Array = !!this.isStyle?param1.getStyle(param2):param1[param2];
         if(!_loc4_)
         {
            _loc4_ = [];
         }
         if(this.startIndex == -1)
         {
            this.startIndex = _loc4_.length;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param3.length)
         {
            _loc4_.splice(this.startIndex + _loc5_,0,param3[_loc5_]);
            _loc5_++;
         }
         this.assign(param1,param2,_loc4_);
      }
      
      protected function addItemsToVector(param1:Object, param2:String, param3:Array) : void
      {
         var _loc4_:Object = !!this.isStyle?param1.getStyle(param2):param1[param2];
         if(!_loc4_)
         {
            _loc4_ = new this.vectorClass();
         }
         if(this.startIndex == -1)
         {
            this.startIndex = _loc4_.length;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param3.length)
         {
            _loc4_.splice(this.startIndex + _loc5_,0,param3[_loc5_]);
            _loc5_++;
         }
         this.assign(param1,param2,_loc4_);
      }
      
      protected function addItemsToIList(param1:IList, param2:Array) : void
      {
         if(this.startIndex == -1)
         {
            this.startIndex = param1.length;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.addItemAt(param2[_loc3_],this.startIndex + _loc3_);
            _loc3_++;
         }
      }
      
      protected function removeItemsFromIList(param1:IList) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.numAdded)
         {
            param1.removeItemAt(this.startIndex);
            _loc2_++;
         }
      }
      
      protected function assign(param1:Object, param2:String, param3:Object) : void
      {
         if(this.isStyle)
         {
            param1.setStyle(param2,param3);
            param1.styleChanged(param2);
            param1.notifyStyleChangeInChildren(param2,true);
         }
         else
         {
            param1[param2] = param3;
         }
      }
      
      private function onDestinationContentCreated(param1:Event) : void
      {
         if(parentContext)
         {
            this.removeCreationCompleteListener();
            this.apply(parentContext);
         }
      }
      
      private function removeCreationCompleteListener() : void
      {
         if(parentContext)
         {
            parentContext.removeEventListener("contentCreationComplete",this.onDestinationContentCreated);
            this._waitingForDeferredContent = false;
         }
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this.document = param1;
      }
   }
}
