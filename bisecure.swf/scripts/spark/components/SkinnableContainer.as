package spark.components
{
   import mx.core.ContainerCreationPolicy;
   import mx.core.IDeferredContentOwner;
   import mx.core.IDeferredInstance;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.SkinnableContainerBase;
   import spark.events.ElementExistenceEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   use namespace mx_internal;
   
   public class SkinnableContainer extends SkinnableContainerBase implements IDeferredContentOwner, IVisualElementContainer
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
      
      private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
       
      
      private var _809612678contentGroup:Group;
      
      private var contentGroupProperties:Object;
      
      private var _placeHolderGroup:Group;
      
      private var creationPolicyNone:Boolean = false;
      
      private var _mxmlContent:Array;
      
      private var _contentModified:Boolean = false;
      
      private var _mxmlContentFactory:IDeferredInstance;
      
      private var mxmlContentCreated:Boolean = false;
      
      private var creatingDeferredContent:Boolean;
      
      private var _deferredContentCreated:Boolean;
      
      public function SkinnableContainer()
      {
         this.contentGroupProperties = {};
         super();
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         styleManager.registerInheritingStyle("_creationPolicy");
      }
      
      mx_internal function get currentContentGroup() : Group
      {
         this.createContentIfNeeded();
         if(!this.contentGroup)
         {
            if(!this._placeHolderGroup)
            {
               this._placeHolderGroup = new Group();
               if(this._mxmlContent)
               {
                  this._placeHolderGroup.mxmlContent = this._mxmlContent;
                  this._mxmlContent = null;
               }
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            }
            return this._placeHolderGroup;
         }
         return this.contentGroup;
      }
      
      public function get creationPolicy() : String
      {
         var _loc1_:String = getStyle("_creationPolicy");
         if(_loc1_ == null)
         {
            _loc1_ = ContainerCreationPolicy.AUTO;
         }
         if(this.creationPolicyNone)
         {
            _loc1_ = ContainerCreationPolicy.NONE;
         }
         return _loc1_;
      }
      
      public function set creationPolicy(param1:String) : void
      {
         if(param1 == ContainerCreationPolicy.NONE)
         {
            this.creationPolicyNone = true;
            param1 = ContainerCreationPolicy.AUTO;
         }
         else
         {
            this.creationPolicyNone = false;
         }
         setStyle("_creationPolicy",param1);
      }
      
      public function get autoLayout() : Boolean
      {
         var _loc1_:* = undefined;
         if(this.contentGroup)
         {
            return this.contentGroup.autoLayout;
         }
         _loc1_ = this.contentGroupProperties.autoLayout;
         return _loc1_ === undefined?true:Boolean(_loc1_);
      }
      
      public function set autoLayout(param1:Boolean) : void
      {
         if(this.contentGroup)
         {
            this.contentGroup.autoLayout = param1;
            this.contentGroupProperties = BitFlagUtil.update(this.contentGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties.autoLayout = param1;
         }
      }
      
      public function get layout() : LayoutBase
      {
         return !!this.contentGroup?this.contentGroup.layout:this.contentGroupProperties.layout;
      }
      
      public function set layout(param1:LayoutBase) : void
      {
         if(this.contentGroup)
         {
            this.contentGroup.layout = param1;
            this.contentGroupProperties = BitFlagUtil.update(this.contentGroupProperties as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties.layout = param1;
         }
      }
      
      public function set mxmlContent(param1:Array) : void
      {
         if(this.contentGroup)
         {
            this.contentGroup.mxmlContent = param1;
         }
         else if(this._placeHolderGroup)
         {
            this._placeHolderGroup.mxmlContent = param1;
         }
         else
         {
            this._mxmlContent = param1;
         }
         if(param1 != null)
         {
            this._contentModified = true;
         }
      }
      
      override protected function addMXMLChildren(param1:Array) : void
      {
         this.mxmlContent = param1;
      }
      
      public function set mxmlContentFactory(param1:IDeferredInstance) : void
      {
         if(param1 == this._mxmlContentFactory)
         {
            return;
         }
         this._mxmlContentFactory = param1;
         this.mxmlContentCreated = false;
      }
      
      public function get numElements() : int
      {
         return this.currentContentGroup.numElements;
      }
      
      public function getElementAt(param1:int) : IVisualElement
      {
         return this.currentContentGroup.getElementAt(param1);
      }
      
      public function getElementIndex(param1:IVisualElement) : int
      {
         return this.currentContentGroup.getElementIndex(param1);
      }
      
      public function addElement(param1:IVisualElement) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.addElement(param1);
      }
      
      public function addElementAt(param1:IVisualElement, param2:int) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.addElementAt(param1,param2);
      }
      
      public function removeElement(param1:IVisualElement) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.removeElement(param1);
      }
      
      public function removeElementAt(param1:int) : IVisualElement
      {
         this._contentModified = true;
         return this.currentContentGroup.removeElementAt(param1);
      }
      
      public function removeAllElements() : void
      {
         this._contentModified = true;
         this.currentContentGroup.removeAllElements();
      }
      
      public function setElementIndex(param1:IVisualElement, param2:int) : void
      {
         this._contentModified = true;
         this.currentContentGroup.setElementIndex(param1,param2);
      }
      
      public function swapElements(param1:IVisualElement, param2:IVisualElement) : void
      {
         this._contentModified = true;
         this.currentContentGroup.swapElements(param1,param2);
      }
      
      public function swapElementsAt(param1:int, param2:int) : void
      {
         this._contentModified = true;
         this.currentContentGroup.swapElementsAt(param1,param2);
      }
      
      override protected function generateMXMLInstances(param1:Object, param2:Array, param3:Boolean = true) : void
      {
         if(!this.creatingDeferredContent)
         {
            setMXMLDescriptor(param2);
            return;
         }
         super.generateMXMLInstances(param1,param2,param3);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createContentIfNeeded();
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         super.partAdded(param1,param2);
         if(param2 == this.contentGroup)
         {
            if(this._contentModified)
            {
               if(this._placeHolderGroup != null)
               {
                  _loc4_ = this._placeHolderGroup.getMXMLContent();
                  this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
                  _loc5_ = this._placeHolderGroup.numElements;
                  while(_loc5_ > 0)
                  {
                     this._placeHolderGroup.removeElementAt(0);
                     _loc5_--;
                  }
                  this.contentGroup.mxmlContent = !!_loc4_?_loc4_.slice():null;
               }
               else if(this._mxmlContent != null)
               {
                  this.contentGroup.mxmlContent = this._mxmlContent;
                  this._mxmlContent = null;
               }
            }
            _loc3_ = 0;
            if(this.contentGroupProperties.autoLayout !== undefined)
            {
               this.contentGroup.autoLayout = this.contentGroupProperties.autoLayout;
               _loc3_ = BitFlagUtil.update(_loc3_,AUTO_LAYOUT_PROPERTY_FLAG,true);
            }
            if(this.contentGroupProperties.layout !== undefined)
            {
               this.contentGroup.layout = this.contentGroupProperties.layout;
               _loc3_ = BitFlagUtil.update(_loc3_,LAYOUT_PROPERTY_FLAG,true);
            }
            this.contentGroupProperties = _loc3_;
            this.contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
            this.contentGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            if(this._placeHolderGroup)
            {
               this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
               this._placeHolderGroup = null;
            }
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         super.partRemoved(param1,param2);
         if(param2 == this.contentGroup)
         {
            this.contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
            this.contentGroup.removeEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            _loc3_ = {};
            if(BitFlagUtil.isSet(this.contentGroupProperties as uint,AUTO_LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.autoLayout = this.contentGroup.autoLayout;
            }
            if(BitFlagUtil.isSet(this.contentGroupProperties as uint,LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.layout = this.contentGroup.layout;
            }
            this.contentGroupProperties = _loc3_;
            _loc4_ = this.contentGroup.getMXMLContent();
            if(this._contentModified && _loc4_)
            {
               this._placeHolderGroup = new Group();
               this._placeHolderGroup.mxmlContent = _loc4_;
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_ADD,this.contentGroup_elementAddedHandler);
               this._placeHolderGroup.addEventListener(ElementExistenceEvent.ELEMENT_REMOVE,this.contentGroup_elementRemovedHandler);
            }
            this.contentGroup.mxmlContent = null;
            this.contentGroup.layout = null;
         }
      }
      
      public function createDeferredContent() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = this.MXMLDescriptor;
         if(_loc1_)
         {
            this.creatingDeferredContent = true;
            this.generateMXMLInstances(document,_loc1_);
            this.creatingDeferredContent = false;
            this.mxmlContentCreated = true;
            this._deferredContentCreated = true;
            dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
            return;
         }
         if(!this.mxmlContentCreated)
         {
            this.mxmlContentCreated = true;
            if(this._mxmlContentFactory)
            {
               _loc2_ = this._mxmlContentFactory.getInstance();
               this.mxmlContent = _loc2_ as Array;
               this._deferredContentCreated = true;
               dispatchEvent(new FlexEvent(FlexEvent.CONTENT_CREATION_COMPLETE));
            }
         }
      }
      
      public function get deferredContentCreated() : Boolean
      {
         return this._deferredContentCreated;
      }
      
      private function createContentIfNeeded() : void
      {
         if(!this.mxmlContentCreated && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createDeferredContent();
         }
      }
      
      private function contentGroup_elementAddedHandler(param1:ElementExistenceEvent) : void
      {
         param1.element.owner = this;
         dispatchEvent(param1);
      }
      
      private function contentGroup_elementRemovedHandler(param1:ElementExistenceEvent) : void
      {
         param1.element.owner = null;
         dispatchEvent(param1);
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      [SkinPart(required="false")]
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
   }
}
