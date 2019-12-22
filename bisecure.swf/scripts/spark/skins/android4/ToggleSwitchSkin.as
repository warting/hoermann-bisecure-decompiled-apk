package spark.skins.android4
{
   import flash.display.BlendMode;
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import spark.components.ToggleSwitch;
   import spark.core.SpriteVisualElement;
   import spark.skins.android4.assets.ToggleSwitchBackground;
   import spark.skins.android4.assets.ToggleSwitchThumb_off;
   import spark.skins.android4.assets.ToggleSwitchThumb_on;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class ToggleSwitchSkin extends MobileSkin
   {
       
      
      public var thumb:IVisualElement;
      
      public var track:IVisualElement;
      
      private var _hostComponent:ToggleSwitch;
      
      public var selectedLabelDisplay:LabelDisplayComponent#770;
      
      private var _selectedLabel:String;
      
      private var _unselectedLabel:String;
      
      private var contents:UIComponent;
      
      private var switchTrack:Class;
      
      private var switchOff:Class;
      
      private var switchOn:Class;
      
      protected var trackWidth:Number;
      
      protected var trackHeight:Number;
      
      protected var layoutThumbWidth:Number;
      
      protected var layoutThumbHeight:Number;
      
      private var thumbOn:IVisualElement;
      
      private var thumbOff:IVisualElement;
      
      public function ToggleSwitchSkin()
      {
         super();
         this.switchTrack = ToggleSwitchBackground;
         this.switchOn = ToggleSwitchThumb_on;
         this.switchOff = ToggleSwitchThumb_off;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.layoutThumbWidth = 188;
               this.layoutThumbHeight = 96;
               this.trackWidth = 388;
               this.trackHeight = 96;
               break;
            case DPIClassification.DPI_480:
               this.layoutThumbWidth = 140;
               this.layoutThumbHeight = 72;
               this.trackWidth = 291;
               this.trackHeight = 72;
               break;
            case DPIClassification.DPI_320:
               this.layoutThumbWidth = 94;
               this.layoutThumbHeight = 48;
               this.trackWidth = 194;
               this.trackHeight = 48;
               break;
            case DPIClassification.DPI_240:
               this.layoutThumbWidth = 70;
               this.layoutThumbHeight = 36;
               this.trackWidth = 146;
               this.trackHeight = 36;
               break;
            case DPIClassification.DPI_120:
               this.layoutThumbWidth = 35;
               this.layoutThumbHeight = 18;
               this.trackWidth = 73;
               this.trackHeight = 18;
               break;
            default:
               this.layoutThumbWidth = 47;
               this.layoutThumbHeight = 24;
               this.trackWidth = 97;
               this.trackHeight = 24;
         }
         this.selectedLabel = resourceManager.getString("components","toggleSwitchSelectedLabel");
         this.unselectedLabel = resourceManager.getString("components","toggleSwitchUnselectedLabel");
      }
      
      public function get hostComponent() : ToggleSwitch
      {
         return this._hostComponent;
      }
      
      public function set hostComponent(param1:ToggleSwitch) : void
      {
         if(this._hostComponent)
         {
            this._hostComponent.removeEventListener("thumbPositionChanged",this.thumbPositionChanged_handler);
         }
         this._hostComponent = param1;
         if(this._hostComponent)
         {
            this._hostComponent.addEventListener("thumbPositionChanged",this.thumbPositionChanged_handler);
         }
      }
      
      protected function get selectedLabel() : String
      {
         return this._selectedLabel;
      }
      
      protected function set selectedLabel(param1:String) : void
      {
         this._selectedLabel = param1;
      }
      
      protected function get unselectedLabel() : String
      {
         return this._unselectedLabel;
      }
      
      protected function set unselectedLabel(param1:String) : void
      {
         this._unselectedLabel = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.contents = new UIComponent();
         this.contents.blendMode = BlendMode.LAYER;
         addChild(this.contents);
         this.drawTrack();
         this.drawThumbs();
         this.drawLabel();
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = this.layoutThumbWidth;
         measuredMinHeight = this.layoutThumbHeight;
         var _loc1_:Number = getElementPreferredWidth(this.selectedLabelDisplay);
         measuredWidth = this.layoutThumbWidth + _loc1_;
         measuredHeight = this.layoutThumbHeight;
      }
      
      override protected function commitCurrentState() : void
      {
         this.toggleSelectionState();
         this.layoutThumbs();
         this.layoutLabel();
      }
      
      protected function drawLabel() : void
      {
         this.selectedLabelDisplay = new LabelDisplayComponent#770();
         this.selectedLabelDisplay.id = "selectedLabelDisplay";
         this.selectedLabelDisplay.text = this.selectedLabel;
         setElementSize(this.selectedLabelDisplay,this.thumb.width,this.thumb.height);
         this.contents.addChild(this.selectedLabelDisplay);
      }
      
      protected function drawTrack() : void
      {
         if(this.track == null)
         {
            this.track = new this.switchTrack();
            this.track.width = this.trackWidth;
            this.track.height = this.trackHeight;
            this.contents.addChildAt(SpriteVisualElement(this.track),0);
         }
      }
      
      protected function drawThumbs() : void
      {
         this.drawThumbOff();
         this.drawThumbOn();
         if(this.thumb == null)
         {
            this.thumb = this.thumbOff;
         }
      }
      
      protected function layoutThumbs() : void
      {
         setElementPosition(this.thumbOn,this.trackWidth / 2,0);
         setElementPosition(this.thumbOff,0,0);
      }
      
      protected function layoutLabel() : void
      {
         if(this.selectedLabelDisplay != null)
         {
            if(currentState.indexOf("AndSelected") != -1)
            {
               setElementPosition(this.selectedLabelDisplay,this.trackWidth / 2,0);
            }
            else
            {
               setElementPosition(this.selectedLabelDisplay,0,0);
            }
         }
      }
      
      protected function toggleSelectionState() : void
      {
         if(currentState.indexOf("AndSelected") != -1)
         {
            this.thumbOn.visible = true;
            this.thumbOff.visible = false;
            this.thumb = this.thumbOn;
            this.selectedLabelDisplay.text = this.selectedLabel;
         }
         else
         {
            this.thumbOff.visible = true;
            this.thumbOn.visible = false;
            this.thumb = this.thumbOff;
            this.selectedLabelDisplay.text = this.unselectedLabel;
         }
      }
      
      protected function drawThumbOn() : void
      {
         this.thumbOn = new this.switchOn();
         this.thumbOn.width = this.layoutThumbWidth;
         this.thumbOn.height = this.layoutThumbHeight;
         this.contents.addChildAt(SpriteVisualElement(this.thumbOn),1);
      }
      
      protected function drawThumbOff() : void
      {
         this.thumbOff = new this.switchOff();
         this.thumbOff.width = this.layoutThumbWidth;
         this.thumbOff.height = this.layoutThumbHeight;
         this.contents.addChildAt(SpriteVisualElement(this.thumbOff),1);
      }
      
      protected function thumbPositionChanged_handler(param1:Event) : void
      {
         this.moveSlidingContent();
      }
      
      protected function moveSlidingContent() : void
      {
         if(!this.hostComponent)
         {
            return;
         }
         var _loc1_:Number = (this.track.getLayoutBoundsWidth() - this.thumb.getLayoutBoundsWidth()) * this.hostComponent.thumbPosition + this.track.getLayoutBoundsX();
         var _loc2_:Number = this.thumb.getLayoutBoundsY();
         setElementPosition(this.thumb,_loc1_,_loc2_);
         setElementPosition(this.selectedLabelDisplay,_loc1_,_loc2_);
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

class LabelDisplayComponent#770 extends UIComponent implements IDisplayText
{
    
   
   public var shadowYOffset:Number = 0;
   
   private var labelChanged:Boolean = false;
   
   private var labelDisplay:StyleableTextField;
   
   private var labelDisplayShadow:StyleableTextField;
   
   private var _text:String;
   
   function LabelDisplayComponent#770()
   {
      super();
      this._text = "";
   }
   
   override public function get baselinePosition() : Number
   {
      return this.labelDisplay.baselinePosition;
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      this.labelDisplay = StyleableTextField(createInFontContext(StyleableTextField));
      this.labelDisplay.styleName = this;
      this.labelDisplay.editable = false;
      this.labelDisplay.selectable = false;
      this.labelDisplay.multiline = false;
      this.labelDisplay.wordWrap = false;
      this.labelDisplay.addEventListener(FlexEvent.VALUE_COMMIT,this.labelDisplay_valueCommitHandler);
      this.labelDisplayShadow = StyleableTextField(createInFontContext(StyleableTextField));
      this.labelDisplayShadow.styleName = this;
      this.labelDisplayShadow.colorName = "textShadowColor";
      this.labelDisplayShadow.editable = false;
      this.labelDisplayShadow.selectable = false;
      this.labelDisplayShadow.multiline = false;
      this.labelDisplayShadow.wordWrap = false;
      addChild(this.labelDisplayShadow);
      addChild(this.labelDisplay);
   }
   
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if(this.labelChanged)
      {
         this.labelDisplay.text = this.text;
         invalidateSize();
         invalidateDisplayList();
         this.labelChanged = false;
      }
   }
   
   override protected function measure() : void
   {
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplay.text = this.text;
      }
      this.labelDisplay.commitStyles();
      measuredWidth = this.labelDisplay.getPreferredBoundsWidth();
      measuredHeight = this.labelDisplay.getPreferredBoundsHeight();
   }
   
   override protected function updateDisplayList(param1:Number, param2:Number) : void
   {
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplay.text = this.text;
      }
      this.labelDisplay.commitStyles();
      var _loc3_:Number = this.labelDisplay.getPreferredBoundsHeight();
      var _loc4_:Number = (param2 - _loc3_) / 2;
      var _loc5_:Number = Math.min(param1,this.labelDisplay.getPreferredBoundsWidth());
      var _loc6_:Number = (param1 - _loc5_) / 2;
      this.labelDisplay.setLayoutBoundsSize(_loc5_,_loc3_);
      this.labelDisplay.setLayoutBoundsPosition(_loc6_,_loc4_);
      this.labelDisplay.truncateToFit();
      this.labelDisplayShadow.commitStyles();
      this.labelDisplayShadow.setLayoutBoundsSize(_loc5_,_loc3_);
      this.labelDisplayShadow.setLayoutBoundsPosition(_loc6_,_loc4_ + this.shadowYOffset);
      this.labelDisplayShadow.alpha = getStyle("textShadowAlpha");
      if(this.labelDisplay.isTruncated)
      {
         this.labelDisplayShadow.text = this.labelDisplay.text;
      }
   }
   
   private function labelDisplay_valueCommitHandler(param1:Event) : void
   {
      this.labelDisplayShadow.text = this.labelDisplay.text;
   }
   
   public function get text() : String
   {
      return this._text;
   }
   
   public function set text(param1:String) : void
   {
      this._text = param1;
      this.labelChanged = true;
      invalidateProperties();
   }
   
   public function get isTruncated() : Boolean
   {
      return this.labelDisplay.isTruncated;
   }
   
   public function showShadow(param1:Boolean) : void
   {
      this.labelDisplayShadow.visible = param1;
   }
}
