package spark.skins.ios7
{
   import flash.text.TextFormatAlign;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.ActionBar;
   import spark.components.Group;
   import spark.core.SpriteVisualElement;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.skins.ios7.assets.ActionBarBackground;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   use namespace mx_internal;
   
   public class ActionBarSkin extends MobileSkin
   {
      
      mx_internal static const ACTIONBAR_CHROME_COLOR_RATIOS:Array = [0,80];
       
      
      protected var borderClass:Class;
      
      private var borderSize:uint;
      
      protected var layoutContentGroupHeight:uint;
      
      protected var layoutTitleGroupHorizontalPadding:uint;
      
      public var hostComponent:ActionBar;
      
      private var _navigationVisible:Boolean = false;
      
      private var _titleContentVisible:Boolean = false;
      
      private var _actionVisible:Boolean = false;
      
      private var border:SpriteVisualElement;
      
      public var navigationGroup:Group;
      
      public var titleGroup:Group;
      
      public var actionGroup:Group;
      
      public var titleDisplay:TitleDisplayComponent#684;
      
      public function ActionBarSkin()
      {
         super();
         this.borderClass = ActionBarBackground;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.borderSize = 2;
               this.layoutContentGroupHeight = 172;
               this.layoutTitleGroupHorizontalPadding = 52;
               break;
            case DPIClassification.DPI_480:
               this.borderSize = 2;
               this.layoutContentGroupHeight = 130;
               this.layoutTitleGroupHorizontalPadding = 40;
               break;
            case DPIClassification.DPI_320:
               this.borderSize = 2;
               this.layoutContentGroupHeight = 86;
               this.layoutTitleGroupHorizontalPadding = 26;
               break;
            case DPIClassification.DPI_240:
               this.borderSize = 1;
               this.layoutContentGroupHeight = 65;
               this.layoutTitleGroupHorizontalPadding = 20;
               break;
            case DPIClassification.DPI_120:
               this.borderSize = 1;
               this.layoutContentGroupHeight = 32;
               this.layoutTitleGroupHorizontalPadding = 10;
               break;
            default:
               this.borderSize = 1;
               this.layoutContentGroupHeight = 43;
               this.layoutTitleGroupHorizontalPadding = 13;
         }
      }
      
      override protected function createChildren() : void
      {
         if(this.borderClass)
         {
            this.border = new this.borderClass();
            addChild(this.border);
         }
         this.navigationGroup = new Group();
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.LEFT;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.gap = 0;
         _loc1_.paddingLeft = _loc1_.paddingTop = _loc1_.paddingRight = _loc1_.paddingBottom = 0;
         this.navigationGroup.layout = _loc1_;
         this.navigationGroup.id = "navigationGroup";
         this.titleGroup = new Group();
         _loc1_ = new HorizontalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.LEFT;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.gap = 0;
         _loc1_.paddingLeft = _loc1_.paddingRight = this.layoutTitleGroupHorizontalPadding;
         _loc1_.paddingTop = _loc1_.paddingBottom = 0;
         this.titleGroup.layout = _loc1_;
         this.titleGroup.id = "titleGroup";
         this.actionGroup = new Group();
         _loc1_ = new HorizontalLayout();
         _loc1_.horizontalAlign = HorizontalAlign.RIGHT;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         _loc1_.gap = 0;
         _loc1_.paddingLeft = _loc1_.paddingTop = _loc1_.paddingRight = _loc1_.paddingBottom = 0;
         this.actionGroup.layout = _loc1_;
         this.actionGroup.id = "actionGroup";
         this.titleDisplay = new TitleDisplayComponent#684();
         this.titleDisplay.id = "titleDisplay";
         var _loc2_:String = getStyle("titleAlign");
         _loc2_ = _loc2_ == "center"?TextFormatAlign.LEFT:_loc2_;
         this.titleDisplay.setStyle("textAlign",_loc2_);
         addChild(this.navigationGroup);
         addChild(this.titleGroup);
         addChild(this.actionGroup);
         addChild(this.titleDisplay);
      }
      
      override protected function measure() : void
      {
         var _loc3_:Object = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         if(this._titleContentVisible)
         {
            _loc1_ = this.titleGroup.getPreferredBoundsWidth();
            _loc2_ = this.titleGroup.getPreferredBoundsHeight();
         }
         else
         {
            _loc3_ = this.hostComponent.titleLayout;
            _loc1_ = (!!_loc3_.paddingLeft?Number(_loc3_.paddingLeft):0) + (!!_loc3_.paddingRight?Number(_loc3_.paddingRight):0) + this.titleDisplay.getPreferredBoundsWidth();
            _loc2_ = this.titleDisplay.getPreferredBoundsHeight();
         }
         measuredWidth = getStyle("paddingLeft") + this.navigationGroup.getPreferredBoundsWidth() + _loc1_ + this.actionGroup.getPreferredBoundsWidth() + getStyle("paddingRight");
         measuredHeight = getStyle("paddingTop") + Math.max(this.layoutContentGroupHeight,this.navigationGroup.getPreferredBoundsHeight(),this.actionGroup.getPreferredBoundsHeight(),_loc2_) + getStyle("paddingBottom");
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         this._titleContentVisible = currentState.indexOf("titleContent") >= 0;
         this._navigationVisible = currentState.indexOf("Navigation") >= 0;
         this._actionVisible = currentState.indexOf("Action") >= 0;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(this.titleDisplay)
         {
            _loc2_ = !param1 || param1 == "styleName";
            if(_loc2_ || param1 == "titleAlign")
            {
               _loc3_ = getStyle("titleAlign");
               if(_loc3_ == "center")
               {
                  this.titleDisplay.setStyle("textAlign",TextFormatAlign.LEFT);
               }
               else
               {
                  this.titleDisplay.setStyle("textAlign",_loc3_);
               }
            }
         }
         super.styleChanged(param1);
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         var _loc13_:Object = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         super.layoutContents(param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = getStyle("paddingLeft");
         var _loc5_:Number = getStyle("paddingRight");
         var _loc6_:Number = getStyle("paddingTop");
         var _loc7_:Number = getStyle("paddingBottom");
         var _loc8_:Number = _loc4_;
         var _loc9_:Number = 0;
         var _loc10_:Number = param1;
         var _loc11_:Number = 0;
         var _loc12_:Number = Math.max(0,param2 - _loc6_ - _loc7_);
         if(this.border)
         {
            setElementSize(this.border,param1,param2);
         }
         if(this._navigationVisible)
         {
            _loc3_ = this.navigationGroup.getPreferredBoundsWidth();
            _loc8_ = _loc8_ + _loc3_;
            setElementSize(this.navigationGroup,_loc3_,_loc12_);
            setElementPosition(this.navigationGroup,_loc4_,_loc6_);
         }
         if(this._actionVisible)
         {
            _loc11_ = this.actionGroup.getPreferredBoundsWidth();
            _loc10_ = param1 - _loc11_ - _loc5_;
            setElementSize(this.actionGroup,_loc11_,_loc12_);
            setElementPosition(this.actionGroup,_loc10_,_loc6_);
         }
         _loc9_ = param1 - _loc3_ - _loc11_ - _loc4_ - _loc5_;
         if(_loc9_ <= 0)
         {
            this.titleDisplay.visible = false;
            this.titleGroup.visible = false;
         }
         else if(this._titleContentVisible)
         {
            this.titleDisplay.visible = false;
            this.titleGroup.visible = true;
            setElementSize(this.titleGroup,_loc9_,_loc12_);
            setElementPosition(this.titleGroup,_loc8_,_loc6_);
         }
         else
         {
            this.titleGroup.visible = false;
            _loc13_ = this.hostComponent.titleLayout;
            _loc14_ = !!_loc13_.paddingLeft?Number(Number(_loc13_.paddingLeft)):Number(0);
            _loc15_ = !!_loc13_.paddingRight?Number(Number(_loc13_.paddingRight)):Number(0);
            _loc16_ = getStyle("titleAlign");
            if(_loc9_ - _loc14_ - _loc15_ <= 0)
            {
               _loc8_ = 0;
               _loc9_ = 0;
            }
            else if(_loc16_ == "center")
            {
               _loc9_ = this.titleDisplay.getExplicitOrMeasuredWidth();
               _loc8_ = Math.round((param1 - _loc9_) / 2);
               _loc17_ = _loc3_ + _loc14_ - _loc8_;
               _loc18_ = _loc8_ + _loc9_ + _loc15_ - _loc10_;
               if(_loc17_ > 0 && _loc18_ > 0)
               {
                  _loc8_ = _loc3_ + _loc14_;
                  _loc9_ = param1 - _loc3_ - _loc11_ - _loc14_ - _loc15_;
               }
               else if(_loc17_ > 0 || _loc18_ > 0)
               {
                  if(_loc17_ > 0)
                  {
                     _loc8_ = _loc8_ + _loc17_;
                  }
                  else if(_loc18_ > 0)
                  {
                     _loc8_ = _loc8_ - _loc18_;
                     if(_loc8_ < _loc3_ + _loc14_)
                     {
                        _loc8_ = _loc3_ + _loc14_;
                     }
                  }
                  _loc18_ = _loc8_ + _loc9_ + _loc15_ - _loc10_;
                  if(_loc18_ > 0)
                  {
                     _loc9_ = _loc9_ - _loc18_;
                  }
               }
            }
            else
            {
               _loc8_ = _loc8_ + _loc14_;
               _loc9_ = _loc9_ - _loc14_ - _loc15_;
            }
            _loc9_ = _loc9_ < 0?Number(0):Number(_loc9_);
            setElementSize(this.titleDisplay,_loc9_,_loc12_);
            setElementPosition(this.titleDisplay,_loc8_,_loc6_);
            this.titleDisplay.visible = true;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         super.drawBackground(param1,param2);
         var _loc3_:uint = getStyle("chromeColor");
         var _loc4_:Number = getStyle("backgroundAlpha");
         applyColorTransform(this.border,16777215,_loc3_);
      }
   }
}

import flash.events.Event;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import spark.components.supportClasses.StyleableTextField;
import spark.core.IDisplayText;

use namespace mx_internal;

class TitleDisplayComponent#684 extends UIComponent implements IDisplayText
{
    
   
   private var titleDisplay:StyleableTextField;
   
   private var titleDisplayShadow:StyleableTextField;
   
   private var title:String;
   
   private var titleChanged:Boolean;
   
   function TitleDisplayComponent#684()
   {
      super();
      this.title = "";
   }
   
   override public function get baselinePosition() : Number
   {
      return this.titleDisplay.baselinePosition;
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      this.titleDisplay = StyleableTextField(createInFontContext(StyleableTextField));
      this.titleDisplay.styleName = this;
      this.titleDisplay.editable = false;
      this.titleDisplay.selectable = false;
      this.titleDisplay.multiline = false;
      this.titleDisplay.wordWrap = false;
      this.titleDisplay.addEventListener(FlexEvent.VALUE_COMMIT,this.titleDisplay_valueCommitHandler);
      this.titleDisplayShadow = StyleableTextField(createInFontContext(StyleableTextField));
      this.titleDisplayShadow.styleName = this;
      this.titleDisplayShadow.colorName = "textShadowColor";
      this.titleDisplayShadow.editable = false;
      this.titleDisplayShadow.selectable = false;
      this.titleDisplayShadow.multiline = false;
      this.titleDisplayShadow.wordWrap = false;
      addChild(this.titleDisplayShadow);
      addChild(this.titleDisplay);
   }
   
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if(this.titleChanged)
      {
         this.titleDisplay.text = this.title;
         invalidateSize();
         invalidateDisplayList();
         this.titleChanged = false;
      }
   }
   
   override protected function measure() : void
   {
      if(this.titleDisplay.isTruncated)
      {
         this.titleDisplay.text = this.title;
      }
      measuredWidth = this.titleDisplay.getPreferredBoundsWidth();
      measuredHeight = this.titleDisplay.getPreferredBoundsHeight();
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      super.updateDisplayList(param1,param2);
      if(this.titleDisplay.isTruncated)
      {
         this.titleDisplay.text = this.title;
      }
      this.titleDisplay.commitStyles();
      var _loc3_:Number = this.titleDisplay.getPreferredBoundsHeight();
      var _loc4_:Number = (param2 - _loc3_) / 2;
      this.titleDisplay.setLayoutBoundsSize(param1,_loc3_);
      this.titleDisplay.setLayoutBoundsPosition(0,(param2 - _loc3_) / 2);
      this.titleDisplay.truncateToFit();
      this.titleDisplayShadow.commitStyles();
      this.titleDisplayShadow.setLayoutBoundsSize(param1,_loc3_);
      this.titleDisplayShadow.setLayoutBoundsPosition(0,_loc4_ + 1);
      this.titleDisplayShadow.alpha = getStyle("textShadowAlpha");
      if(this.titleDisplay.isTruncated)
      {
         this.titleDisplayShadow.text = this.titleDisplay.text;
      }
   }
   
   private function titleDisplay_valueCommitHandler(param1:Event) : void
   {
      this.titleDisplayShadow.text = this.titleDisplay.text;
   }
   
   public function get text() : String
   {
      return this.title;
   }
   
   public function set text(param1:String) : void
   {
      this.title = param1;
      this.titleChanged = true;
      invalidateProperties();
   }
   
   public function get isTruncated() : Boolean
   {
      return this.titleDisplay.isTruncated;
   }
}
