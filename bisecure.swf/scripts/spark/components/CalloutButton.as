package spark.components
{
   import flash.events.Event;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.mx_internal;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.DropDownController;
   import spark.core.ContainerDestructionPolicy;
   import spark.events.DropDownEvent;
   import spark.events.PopUpEvent;
   import spark.layouts.supportClasses.LayoutBase;
   
   use namespace mx_internal;
   
   public class CalloutButton extends Button
   {
      
      mx_internal static const CALLOUT_CONTENT_PROPERTY_FLAG:uint = 1 << 0;
      
      mx_internal static const CALLOUT_LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      mx_internal static const HORIZONTAL_POSITION_PROPERTY_FLAG:uint = 1 << 2;
      
      mx_internal static const VERTICAL_POSITION_PROPERTY_FLAG:uint = 1 << 3;
       
      
      [SkinPart(required="false")]
      public var dropDown:IFactory;
      
      mx_internal var calloutProperties:Object;
      
      private var _callout:Callout;
      
      private var _dropDownController:DropDownController;
      
      private var _calloutDestructionPolicy:String = "auto";
      
      public function CalloutButton()
      {
         this.calloutProperties = {};
         super();
         this.dropDownController = new DropDownController();
      }
      
      public function get calloutContent() : Array
      {
         if(this.callout && this.callout.contentGroup)
         {
            return this.callout.contentGroup.getMXMLContent();
         }
         return this.calloutProperties.calloutContent;
      }
      
      public function set calloutContent(param1:Array) : void
      {
         if(this.callout)
         {
            this.callout.mxmlContent = param1;
            this.calloutProperties = BitFlagUtil.update(this.calloutProperties as uint,CALLOUT_CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.calloutProperties.calloutContent = param1;
         }
      }
      
      public function get calloutLayout() : LayoutBase
      {
         return !!this.callout?this.callout.layout:this.calloutProperties.calloutLayout;
      }
      
      public function set calloutLayout(param1:LayoutBase) : void
      {
         if(this.callout)
         {
            this.callout.layout = param1;
            this.calloutProperties = BitFlagUtil.update(this.calloutProperties as uint,CALLOUT_LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.calloutProperties.calloutLayout = param1;
         }
      }
      
      public function get horizontalPosition() : String
      {
         if(this.callout)
         {
            return this.callout.horizontalPosition;
         }
         return this.calloutProperties.horizontalPosition;
      }
      
      public function set horizontalPosition(param1:String) : void
      {
         if(this.callout)
         {
            this.callout.horizontalPosition = param1;
            this.calloutProperties = BitFlagUtil.update(this.calloutProperties as uint,HORIZONTAL_POSITION_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.calloutProperties.horizontalPosition = param1;
         }
      }
      
      public function get verticalPosition() : String
      {
         if(this.callout)
         {
            return this.callout.verticalPosition;
         }
         return this.calloutProperties.verticalPosition;
      }
      
      public function set verticalPosition(param1:String) : void
      {
         if(this.callout)
         {
            this.callout.verticalPosition = param1;
            this.calloutProperties = BitFlagUtil.update(this.calloutProperties as uint,VERTICAL_POSITION_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.calloutProperties.verticalPosition = param1;
         }
      }
      
      [Bindable("calloutChanged")]
      public function get callout() : Callout
      {
         return this._callout;
      }
      
      mx_internal function setCallout(param1:Callout) : void
      {
         if(this._callout == param1)
         {
            return;
         }
         this._callout = param1;
         if(hasEventListener("calloutChanged"))
         {
            dispatchEvent(new Event("calloutChanged"));
         }
      }
      
      protected function get dropDownController() : DropDownController
      {
         return this._dropDownController;
      }
      
      protected function set dropDownController(param1:DropDownController) : void
      {
         if(this._dropDownController == param1)
         {
            return;
         }
         this._dropDownController = param1;
         this._dropDownController.closeOnResize = false;
         this._dropDownController.addEventListener(DropDownEvent.OPEN,this.dropDownController_openHandler);
         this._dropDownController.addEventListener(DropDownEvent.CLOSE,this.dropDownController_closeHandler);
         this._dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
         this._dropDownController.openButton = this;
         if(this.callout)
         {
            this._dropDownController.dropDown = this.callout;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         var _loc2_:Boolean = param1 == null || param1 == "styleName";
         if(_loc2_ || param1 == "rollOverOpenDelay")
         {
            if(this.dropDownController)
            {
               this.dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
            }
         }
      }
      
      public function get isDropDownOpen() : Boolean
      {
         if(this.dropDownController)
         {
            return this.dropDownController.isOpen;
         }
         return false;
      }
      
      public function get calloutDestructionPolicy() : String
      {
         return this._calloutDestructionPolicy;
      }
      
      public function set calloutDestructionPolicy(param1:String) : void
      {
         if(this._calloutDestructionPolicy == param1)
         {
            return;
         }
         this._calloutDestructionPolicy = param1;
         if(!this.isDropDownOpen && this.calloutDestructionPolicy == ContainerDestructionPolicy.AUTO)
         {
            this.destroyCallout();
         }
      }
      
      override protected function attachSkin() : void
      {
         super.attachSkin();
         if(!this.dropDown && !("dropDown" in skin))
         {
            this.dropDown = new ClassFactory(Callout);
         }
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Callout = null;
         super.partAdded(param1,param2);
         if(param1 == "dropDown")
         {
            _loc3_ = 0;
            _loc4_ = param2 as Callout;
            if(_loc4_ && this.dropDownController)
            {
               _loc4_.id = "callout";
               this.dropDownController.dropDown = _loc4_;
               _loc4_.addEventListener(PopUpEvent.OPEN,this.callout_openHandler);
               _loc4_.addEventListener(PopUpEvent.CLOSE,this.callout_closeHandler);
               if(this.calloutProperties.calloutContent !== undefined)
               {
                  _loc4_.mxmlContent = this.calloutProperties.calloutContent;
                  _loc3_ = BitFlagUtil.update(_loc3_,CALLOUT_CONTENT_PROPERTY_FLAG,true);
               }
               if(this.calloutProperties.calloutLayout !== undefined)
               {
                  _loc4_.layout = this.calloutProperties.calloutLayout;
                  _loc3_ = BitFlagUtil.update(_loc3_,CALLOUT_LAYOUT_PROPERTY_FLAG,true);
               }
               if(this.calloutProperties.horizontalPosition !== undefined)
               {
                  _loc4_.horizontalPosition = this.calloutProperties.horizontalPosition;
                  _loc3_ = BitFlagUtil.update(_loc3_,HORIZONTAL_POSITION_PROPERTY_FLAG,true);
               }
               if(this.calloutProperties.verticalPosition !== undefined)
               {
                  _loc4_.verticalPosition = this.calloutProperties.verticalPosition;
                  _loc3_ = BitFlagUtil.update(_loc3_,VERTICAL_POSITION_PROPERTY_FLAG,true);
               }
               this.calloutProperties = _loc3_;
            }
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         if(this.dropDownController && param2 == this.callout)
         {
            this.dropDownController.dropDown = null;
         }
         if(param1 == "dropDown")
         {
            this.callout.removeEventListener(PopUpEvent.OPEN,this.callout_openHandler);
            this.callout.removeEventListener(PopUpEvent.CLOSE,this.callout_closeHandler);
            _loc3_ = {};
            if(BitFlagUtil.isSet(this.calloutProperties as uint,CALLOUT_CONTENT_PROPERTY_FLAG) && this.callout.contentGroup)
            {
               _loc3_.calloutContent = this.callout.contentGroup.getMXMLContent();
               this.callout.contentGroup.mxmlContent = null;
            }
            if(BitFlagUtil.isSet(this.calloutProperties as uint,CALLOUT_LAYOUT_PROPERTY_FLAG))
            {
               _loc3_.calloutLayout = this.callout.layout;
               this.callout.layout = null;
            }
            if(BitFlagUtil.isSet(this.calloutProperties as uint,HORIZONTAL_POSITION_PROPERTY_FLAG))
            {
               _loc3_.horizontalPosition = this.callout.horizontalPosition;
            }
            if(BitFlagUtil.isSet(this.calloutProperties as uint,VERTICAL_POSITION_PROPERTY_FLAG))
            {
               _loc3_.verticalPosition = this.callout.verticalPosition;
            }
            this.calloutProperties = _loc3_;
         }
         super.partRemoved(param1,param2);
      }
      
      public function openDropDown() : void
      {
         this.dropDownController.openDropDown();
      }
      
      public function closeDropDown() : void
      {
         this.dropDownController.closeDropDown(false);
      }
      
      private function destroyCallout() : void
      {
         removeDynamicPartInstance("dropDown",this.callout);
         this.setCallout(null);
      }
      
      mx_internal function dropDownController_openHandler(param1:DropDownEvent) : void
      {
         if(!this.callout)
         {
            this.setCallout(createDynamicPartInstance("dropDown") as Callout);
         }
         if(this.callout)
         {
            addEventListener(Event.REMOVED_FROM_STAGE,this.button_removedFromStage);
            this.callout.open(this,false);
         }
      }
      
      mx_internal function dropDownController_closeHandler(param1:DropDownEvent) : void
      {
         if(this.callout)
         {
            removeEventListener(Event.REMOVED_FROM_STAGE,this.button_removedFromStage);
            this.callout.close();
         }
      }
      
      private function callout_openHandler(param1:PopUpEvent) : void
      {
         dispatchEvent(new DropDownEvent(DropDownEvent.OPEN));
      }
      
      private function callout_closeHandler(param1:PopUpEvent) : void
      {
         if(this.dropDownController.isOpen)
         {
            this.closeDropDown();
         }
         if(this.calloutDestructionPolicy == ContainerDestructionPolicy.AUTO)
         {
            this.destroyCallout();
         }
         dispatchEvent(new DropDownEvent(DropDownEvent.CLOSE));
      }
      
      private function button_removedFromStage(param1:Event) : void
      {
         if(!this.isDropDownOpen)
         {
            return;
         }
         this.callout.visible = false;
         this.closeDropDown();
      }
   }
}
