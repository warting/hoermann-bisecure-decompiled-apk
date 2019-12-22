package spark.skins.mobile.supportClasses
{
   import flash.display.DisplayObject;
   import flash.text.TextLineMetrics;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import spark.components.Group;
   import spark.components.IconPlacement;
   import spark.components.ResizeMode;
   import spark.components.supportClasses.ButtonBase;
   import spark.components.supportClasses.StyleableTextField;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class ButtonSkinBase extends MobileSkin
   {
       
      
      private var iconChanged:Boolean = false;
      
      private var iconInstance:Object;
      
      private var iconHolder:Group;
      
      private var _icon:Object;
      
      private var enabledChanged:Boolean = false;
      
      public var labelDisplay:StyleableTextField;
      
      protected var useIconStyle:Boolean = true;
      
      protected var useCenterAlignment:Boolean = true;
      
      private var _hostComponent:ButtonBase;
      
      protected var layoutBorderSize:uint;
      
      protected var layoutGap:int;
      
      protected var layoutPaddingLeft:int;
      
      protected var layoutPaddingRight:int;
      
      protected var layoutPaddingTop:int;
      
      protected var layoutPaddingBottom:int;
      
      public function ButtonSkinBase()
      {
         super();
      }
      
      public function get hostComponent() : ButtonBase
      {
         return this._hostComponent;
      }
      
      public function set hostComponent(param1:ButtonBase) : void
      {
         this._hostComponent = param1;
      }
      
      override public function set currentState(param1:String) : void
      {
         var _loc2_:Boolean = currentState && currentState.indexOf("disabled") >= 0;
         super.currentState = param1;
         if(_loc2_ != currentState.indexOf("disabled") >= 0)
         {
            this.enabledChanged = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         this.labelDisplay = StyleableTextField(createInFontContext(StyleableTextField));
         this.labelDisplay.styleName = this;
         this.labelDisplay.addEventListener(FlexEvent.VALUE_COMMIT,this.labelDisplay_valueCommitHandler);
         addChild(this.labelDisplay);
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "iconPlacement")
         {
            invalidateSize();
            invalidateDisplayList();
         }
         if(this.useIconStyle && (_loc2_ || param1 == "icon"))
         {
            this.iconChanged = true;
            invalidateProperties();
         }
         if(param1 == "textShadowAlpha")
         {
            invalidateDisplayList();
         }
         super.styleChanged(param1);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.useIconStyle && this.iconChanged)
         {
            this.enabledChanged = true;
            this.iconChanged = false;
            this.setIcon(getStyle("icon"));
         }
         if(this.enabledChanged)
         {
            this.commitDisabled();
            this.enabledChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         var _loc6_:Number = NaN;
         var _loc11_:Number = NaN;
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:DisplayObject = this.getIconDisplay();
         if(this.hostComponent && this.labelDisplay.isTruncated)
         {
            this.labelDisplay.text = this.hostComponent.label;
         }
         if(this.labelDisplay.text != "" || !_loc4_)
         {
            _loc1_ = getElementPreferredWidth(this.labelDisplay);
            _loc2_ = getElementPreferredHeight(this.labelDisplay);
            _loc3_ = this.labelDisplay.getLineMetrics(0).descent;
         }
         var _loc5_:Number = this.layoutPaddingLeft + this.layoutPaddingRight;
         _loc6_ = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(_loc4_)
         {
            _loc7_ = getElementPreferredWidth(_loc4_);
            _loc8_ = getElementPreferredHeight(_loc4_);
         }
         var _loc9_:String = getStyle("iconPlacement");
         var _loc10_:Number = this.layoutPaddingBottom;
         if(_loc9_ == IconPlacement.LEFT || _loc9_ == IconPlacement.RIGHT)
         {
            _loc5_ = _loc5_ + (_loc1_ + _loc7_);
            if(_loc1_ && _loc7_)
            {
               _loc5_ = _loc5_ + this.layoutGap;
            }
            _loc11_ = Math.max(_loc2_,_loc8_);
            _loc6_ = _loc6_ + _loc11_;
         }
         else
         {
            _loc5_ = _loc5_ + Math.max(_loc1_,_loc7_);
            _loc6_ = _loc6_ + (_loc2_ + _loc8_);
            _loc10_ = this.layoutPaddingBottom;
            if(_loc2_ && _loc8_)
            {
               if(_loc9_ == IconPlacement.BOTTOM)
               {
                  _loc6_ = _loc6_ + Math.max(_loc3_,this.layoutGap);
               }
               else
               {
                  _loc10_ = Math.max(this.layoutPaddingBottom,_loc3_);
                  _loc6_ = _loc6_ + this.layoutGap;
               }
            }
         }
         _loc6_ = _loc6_ + (this.layoutPaddingTop + _loc10_);
         measuredMinWidth = _loc6_;
         measuredMinHeight = _loc6_;
         measuredWidth = _loc5_;
         measuredHeight = _loc6_;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc24_:TextLineMetrics = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Boolean = this.hostComponent && this.hostComponent.label != "";
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:String = getStyle("iconPlacement");
         var _loc12_:Boolean = _loc11_ == IconPlacement.LEFT || _loc11_ == IconPlacement.RIGHT;
         var _loc13_:Number = 0;
         var _loc14_:Number = 0;
         var _loc15_:Number = 0;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = this.layoutPaddingBottom;
         if(this.hostComponent && this.labelDisplay.isTruncated)
         {
            this.labelDisplay.text = this.hostComponent.label;
         }
         if(_loc3_)
         {
            _loc24_ = this.labelDisplay.getLineMetrics(0);
            _loc8_ = getElementPreferredWidth(this.labelDisplay);
            _loc9_ = getElementPreferredHeight(this.labelDisplay);
            _loc10_ = _loc24_.descent;
         }
         var _loc19_:DisplayObject = this.getIconDisplay();
         if(_loc19_)
         {
            _loc15_ = getElementPreferredWidth(_loc19_);
            _loc16_ = getElementPreferredHeight(_loc19_);
            _loc17_ = !!_loc3_?Number(this.layoutGap):Number(0);
         }
         if(_loc11_ == IconPlacement.BOTTOM)
         {
            _loc18_ = this.layoutPaddingBottom;
         }
         else if(_loc11_ == IconPlacement.TOP)
         {
            _loc18_ = Math.max(this.layoutPaddingBottom,_loc10_);
         }
         var _loc20_:Number = Math.max(param1 - this.layoutPaddingLeft - this.layoutPaddingRight,0);
         var _loc21_:Number = Math.max(param2 - this.layoutPaddingTop - _loc18_,0);
         var _loc22_:Number = Math.min(_loc15_,_loc20_);
         var _loc23_:Number = Math.min(_loc16_,_loc21_);
         _loc6_ = _loc20_;
         _loc7_ = Math.min(_loc21_,_loc9_);
         _loc5_ = (_loc21_ - _loc7_) / 2;
         if(_loc12_)
         {
            _loc6_ = Math.max(Math.min(_loc20_ - _loc22_ - _loc17_,_loc8_),0);
            if(this.useCenterAlignment)
            {
               _loc4_ = (_loc20_ - _loc6_ - _loc22_ - _loc17_) / 2;
            }
            else
            {
               _loc4_ = 0;
            }
            if(_loc11_ == IconPlacement.LEFT)
            {
               _loc13_ = _loc4_;
               _loc4_ = _loc4_ + (_loc22_ + _loc17_);
            }
            else
            {
               _loc13_ = _loc4_ + _loc6_ + _loc17_;
            }
            _loc14_ = (_loc21_ - _loc23_) / 2;
         }
         else if(_loc23_)
         {
            _loc7_ = Math.min(Math.max(_loc21_ - _loc23_ - _loc17_,0),_loc9_);
            if(_loc3_ && _loc11_ == IconPlacement.BOTTOM)
            {
               _loc17_ = Math.max(_loc17_,_loc10_);
            }
            if(this.useCenterAlignment)
            {
               _loc4_ = 0;
               _loc5_ = (_loc21_ - _loc7_ - _loc23_ - _loc17_) / 2;
            }
            else
            {
               _loc6_ = Math.min(_loc8_,_loc20_);
               _loc4_ = (_loc20_ - _loc6_) / 2;
            }
            _loc13_ = (_loc20_ - _loc22_) / 2;
            _loc25_ = _loc21_ - _loc7_ - _loc17_;
            if(_loc11_ == IconPlacement.TOP)
            {
               if(this.useCenterAlignment)
               {
                  _loc14_ = _loc5_;
                  _loc5_ = _loc14_ + _loc17_ + _loc23_;
               }
               else
               {
                  if(_loc16_ >= _loc25_)
                  {
                     _loc14_ = 0;
                  }
                  else
                  {
                     _loc14_ = (_loc25_ + this.layoutPaddingTop + _loc17_ - _loc16_) / 2 - this.layoutPaddingTop;
                  }
                  _loc5_ = _loc21_ - _loc7_;
               }
            }
            else if(this.useCenterAlignment)
            {
               _loc14_ = _loc5_ + _loc7_ + _loc17_;
            }
            else
            {
               if(_loc16_ >= _loc25_)
               {
                  _loc14_ = _loc21_ - _loc23_;
               }
               else
               {
                  _loc14_ = (_loc25_ + _loc18_ + _loc17_ - _loc16_) / 2 + _loc7_;
               }
               _loc5_ = 0;
            }
         }
         if(_loc12_ && _loc7_ < _loc9_)
         {
            _loc26_ = Math.min(param2 - this.layoutPaddingTop - _loc5_ - _loc10_ + StyleableTextField.TEXT_HEIGHT_PADDING / 2,_loc9_);
            _loc7_ = Math.max(_loc26_,_loc7_);
         }
         _loc4_ = Math.max(0,Math.round(_loc4_)) + this.layoutPaddingLeft;
         _loc5_ = Math.max(0,Math.floor(_loc5_)) + this.layoutPaddingTop;
         _loc13_ = Math.max(0,Math.round(_loc13_)) + this.layoutPaddingLeft;
         _loc14_ = Math.max(0,Math.round(_loc14_)) + this.layoutPaddingTop;
         setElementSize(this.labelDisplay,_loc6_,_loc7_);
         setElementPosition(this.labelDisplay,_loc4_,_loc5_);
         if(_loc8_ > _loc6_)
         {
            this.labelDisplay.truncateToFit();
         }
         if(_loc19_)
         {
            setElementSize(_loc19_,_loc22_,_loc23_);
            setElementPosition(_loc19_,_loc13_,_loc14_);
         }
      }
      
      protected function commitDisabled() : void
      {
         alpha = !!this.hostComponent.enabled?Number(1):Number(0.5);
      }
      
      protected function getIconDisplay() : DisplayObject
      {
         return !!this.iconHolder?this.iconHolder:this.iconInstance as DisplayObject;
      }
      
      protected function setIcon(param1:Object) : void
      {
         if(this._icon == param1)
         {
            return;
         }
         this._icon = param1;
         if(this.iconInstance)
         {
            if(this.iconHolder)
            {
               this.iconHolder.removeAllElements();
            }
            else
            {
               this.removeChild(this.iconInstance as DisplayObject);
            }
         }
         this.iconInstance = null;
         var _loc2_:Boolean = param1 && !(param1 is Class) && !(param1 is DisplayObject);
         if(_loc2_ && !this.iconHolder)
         {
            this.iconHolder = new Group();
            this.iconHolder.resizeMode = ResizeMode.SCALE;
            addChild(this.iconHolder);
         }
         else if(!_loc2_ && this.iconHolder)
         {
            this.removeChild(this.iconHolder);
            this.iconHolder = null;
         }
         if(param1)
         {
            if(_loc2_)
            {
               this.iconInstance = new BitmapImage();
               this.iconInstance.source = param1;
               this.iconHolder.addElementAt(this.iconInstance as BitmapImage,0);
            }
            else
            {
               if(param1 is Class)
               {
                  this.iconInstance = new Class(param1)();
               }
               else
               {
                  this.iconInstance = param1;
               }
               addChild(this.iconInstance as DisplayObject);
            }
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      protected function labelDisplay_valueCommitHandler(param1:FlexEvent) : void
      {
         invalidateSize();
         invalidateDisplayList();
      }
   }
}
