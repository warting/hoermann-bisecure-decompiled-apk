package spark.components
{
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.utils.BitFlagUtil;
   import spark.components.supportClasses.SkinnableComponent;
   import spark.core.IDisplayText;
   import spark.layouts.supportClasses.LayoutBase;
   
   use namespace mx_internal;
   
   public class ActionBar extends SkinnableComponent
   {
      
      mx_internal static const CONTENT_PROPERTY_FLAG:uint = 1 << 0;
      
      mx_internal static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
      
      mx_internal static const NAVIGATION_GROUP_PROPERTIES_INDEX:uint = 0;
      
      mx_internal static const TITLE_GROUP_PROPERTIES_INDEX:uint = 1;
      
      mx_internal static const ACTION_GROUP_PROPERTIES_INDEX:uint = 2;
       
      
      mx_internal var contentGroupProperties:Array;
      
      mx_internal var contentGroupLayouts:Array;
      
      [SkinPart(required="false")]
      public var navigationGroup:Group;
      
      [SkinPart(required="false")]
      public var titleGroup:Group;
      
      [SkinPart(required="false")]
      public var actionGroup:Group;
      
      [SkinPart(required="false")]
      public var titleDisplay:IDisplayText;
      
      private var _title:String = "";
      
      public function ActionBar()
      {
         this.contentGroupProperties = [{},{},{}];
         this.contentGroupLayouts = [null,null,null];
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : String
      {
         return this._title;
      }
      
      private function set _110371416title(param1:String) : void
      {
         if(param1 == this._title)
         {
            return;
         }
         this._title = param1;
         if(this.titleDisplay)
         {
            this.titleDisplay.text = this.title;
         }
         invalidateSkinState();
      }
      
      public function get navigationContent() : Array
      {
         if(this.navigationGroup)
         {
            return this.navigationGroup.getMXMLContent();
         }
         return this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX].content;
      }
      
      public function set navigationContent(param1:Array) : void
      {
         if(this.navigationGroup)
         {
            this.navigationGroup.mxmlContent = param1;
            this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX] as uint,CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX].content = param1;
         }
         invalidateSkinState();
      }
      
      public function get navigationLayout() : LayoutBase
      {
         if(this.navigationGroup)
         {
            return this.navigationGroup.layout;
         }
         return this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX].layout;
      }
      
      public function set navigationLayout(param1:LayoutBase) : void
      {
         if(this.navigationGroup)
         {
            this.navigationGroup.layout = !!param1?param1:this.contentGroupLayouts[NAVIGATION_GROUP_PROPERTIES_INDEX];
            this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX] as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties[NAVIGATION_GROUP_PROPERTIES_INDEX].layout = param1;
         }
      }
      
      public function get titleContent() : Array
      {
         if(this.titleGroup)
         {
            return this.titleGroup.getMXMLContent();
         }
         return this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX].content;
      }
      
      public function set titleContent(param1:Array) : void
      {
         if(this.titleGroup)
         {
            this.titleGroup.mxmlContent = param1;
            this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX] as uint,CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX].content = param1;
         }
         invalidateSkinState();
      }
      
      public function get titleLayout() : LayoutBase
      {
         if(this.titleGroup)
         {
            return this.titleGroup.layout;
         }
         return this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX].layout;
      }
      
      public function set titleLayout(param1:LayoutBase) : void
      {
         if(this.titleGroup)
         {
            this.titleGroup.layout = !!param1?param1:this.contentGroupLayouts[TITLE_GROUP_PROPERTIES_INDEX];
            this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX] as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties[TITLE_GROUP_PROPERTIES_INDEX].layout = param1;
         }
      }
      
      public function get actionContent() : Array
      {
         if(this.actionGroup)
         {
            return this.actionGroup.getMXMLContent();
         }
         return this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX].content;
      }
      
      public function set actionContent(param1:Array) : void
      {
         if(this.actionGroup)
         {
            this.actionGroup.mxmlContent = param1;
            this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX] as uint,CONTENT_PROPERTY_FLAG,param1 != null);
         }
         else
         {
            this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX].content = param1;
         }
         invalidateSkinState();
      }
      
      public function get actionLayout() : LayoutBase
      {
         if(this.actionGroup)
         {
            return this.actionGroup.layout;
         }
         return this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX].layout;
      }
      
      public function set actionLayout(param1:LayoutBase) : void
      {
         if(this.actionGroup)
         {
            this.actionGroup.layout = !!param1?param1:this.contentGroupLayouts[ACTION_GROUP_PROPERTIES_INDEX];
            this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX] = BitFlagUtil.update(this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX] as uint,LAYOUT_PROPERTY_FLAG,true);
         }
         else
         {
            this.contentGroupProperties[ACTION_GROUP_PROPERTIES_INDEX].layout = param1;
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(!param1 || param1 == "styleName" || param1 == "defaultButtonAppearance")
         {
            _loc2_ = !!(styleName as String)?String(styleName):"";
            _loc3_ = _loc2_.indexOf(" ");
            _loc4_ = _loc3_ > 0?_loc2_.substring(0,_loc3_):_loc2_;
            _loc5_ = getStyle("defaultButtonAppearance");
            if(_loc4_ != _loc5_)
            {
               if(_loc4_ == ActionBarDefaultButtonAppearance.BEVELED || _loc4_ == ActionBarDefaultButtonAppearance.NORMAL)
               {
                  if(_loc3_ < 0)
                  {
                     _loc2_ = "";
                  }
                  else
                  {
                     _loc2_ = " " + _loc2_.substr(_loc3_ + 1);
                  }
               }
               styleName = _loc5_ + _loc2_;
            }
         }
         super.styleChanged(param1);
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.titleDisplay as IVisualElement);
      }
      
      override protected function getCurrentSkinState() : String
      {
         var _loc1_:* = !!this.titleContent?"titleContent":"title";
         if(this.actionContent && this.navigationContent)
         {
            _loc1_ = _loc1_ + "WithActionAndNavigation";
         }
         else if(this.actionContent)
         {
            _loc1_ = _loc1_ + "WithAction";
         }
         else if(this.navigationContent)
         {
            _loc1_ = _loc1_ + "WithNavigation";
         }
         return _loc1_;
      }
      
      override protected function partAdded(param1:String, param2:Object) : void
      {
         var _loc3_:Group = null;
         var _loc5_:uint = 0;
         super.partAdded(param1,param2);
         var _loc4_:int = -1;
         if(param2 == this.navigationGroup)
         {
            _loc3_ = this.navigationGroup;
            _loc4_ = NAVIGATION_GROUP_PROPERTIES_INDEX;
         }
         else if(param2 == this.titleGroup)
         {
            _loc3_ = this.titleGroup;
            _loc4_ = TITLE_GROUP_PROPERTIES_INDEX;
         }
         else if(param2 == this.actionGroup)
         {
            _loc3_ = this.actionGroup;
            _loc4_ = ACTION_GROUP_PROPERTIES_INDEX;
         }
         else if(param2 == this.titleDisplay)
         {
            this.titleDisplay.text = this.title;
         }
         if(_loc4_ > -1)
         {
            this.contentGroupLayouts[_loc4_] = _loc3_.layout;
            _loc5_ = 0;
            if(this.contentGroupProperties[_loc4_].content != null)
            {
               _loc3_.mxmlContent = this.contentGroupProperties[_loc4_].content;
               _loc5_ = BitFlagUtil.update(_loc5_,CONTENT_PROPERTY_FLAG,true);
            }
            if(this.contentGroupProperties[_loc4_].layout != null)
            {
               _loc3_.layout = this.contentGroupProperties[_loc4_].layout;
               _loc5_ = BitFlagUtil.update(_loc5_,LAYOUT_PROPERTY_FLAG,true);
            }
            this.contentGroupProperties[_loc4_] = _loc5_;
         }
      }
      
      override protected function partRemoved(param1:String, param2:Object) : void
      {
         var _loc3_:Group = null;
         var _loc5_:Object = null;
         super.partRemoved(param1,param2);
         var _loc4_:int = -1;
         if(param2 == this.navigationGroup)
         {
            _loc3_ = this.navigationGroup;
            _loc4_ = NAVIGATION_GROUP_PROPERTIES_INDEX;
         }
         else if(param2 == this.titleGroup)
         {
            _loc3_ = this.titleGroup;
            _loc4_ = TITLE_GROUP_PROPERTIES_INDEX;
         }
         else if(param2 == this.actionGroup)
         {
            _loc3_ = this.actionGroup;
            _loc4_ = ACTION_GROUP_PROPERTIES_INDEX;
         }
         if(_loc4_ > -1)
         {
            _loc5_ = {};
            if(BitFlagUtil.isSet(this.contentGroupProperties[_loc4_] as uint,CONTENT_PROPERTY_FLAG))
            {
               _loc5_.content = _loc3_.getMXMLContent();
            }
            if(BitFlagUtil.isSet(this.contentGroupProperties[_loc4_] as uint,LAYOUT_PROPERTY_FLAG))
            {
               _loc5_.layout = _loc3_.layout;
            }
            this.contentGroupProperties[_loc4_] = _loc5_;
            _loc3_.mxmlContent = null;
            _loc3_.layout = null;
         }
      }
      
      public function set title(param1:String) : void
      {
         var _loc2_:Object = this.title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}
