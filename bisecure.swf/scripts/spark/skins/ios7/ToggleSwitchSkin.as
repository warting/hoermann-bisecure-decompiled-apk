package spark.skins.ios7
{
   import flash.events.Event;
   import mx.core.DPIClassification;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import spark.components.ToggleSwitch;
   import spark.core.SpriteVisualElement;
   import spark.skins.ios7.assets.ToggleSwitchBackground_off;
   import spark.skins.ios7.assets.ToggleSwitchBackground_on;
   import spark.skins.ios7.assets.ToggleSwitchThumb_off;
   import spark.skins.ios7.assets.ToggleSwitchThumb_on;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class ToggleSwitchSkin extends MobileSkin
   {
       
      
      public var thumb:IVisualElement;
      
      public var track:IVisualElement;
      
      private var _hostComponent:ToggleSwitch;
      
      public var selectedLabelDisplay:LabelDisplayComponent#701;
      
      private var contents:UIComponent;
      
      private var switchTrackOn:Class;
      
      private var switchTrackOff:Class;
      
      private var switchOff:Class;
      
      private var switchOn:Class;
      
      protected var trackWidth:Number;
      
      protected var trackHeight:Number;
      
      protected var layoutThumbWidth:Number;
      
      protected var layoutThumbHeight:Number;
      
      private var thumbOn:IVisualElement;
      
      private var thumbOff:IVisualElement;
      
      private var trackOn:IVisualElement;
      
      private var trackOff:IVisualElement;
      
      public function ToggleSwitchSkin()
      {
         super();
         this.switchTrackOn = ToggleSwitchBackground_on;
         this.switchTrackOff = ToggleSwitchBackground_off;
         this.switchOn = ToggleSwitchThumb_on;
         this.switchOff = ToggleSwitchThumb_off;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.layoutThumbWidth = 108;
               this.layoutThumbHeight = 108;
               this.trackWidth = 224;
               this.trackHeight = 124;
               break;
            case DPIClassification.DPI_480:
               this.layoutThumbWidth = 80;
               this.layoutThumbHeight = 80;
               this.trackWidth = 168;
               this.trackHeight = 92;
               break;
            case DPIClassification.DPI_320:
               this.layoutThumbWidth = 54;
               this.layoutThumbHeight = 54;
               this.trackWidth = 112;
               this.trackHeight = 62;
               break;
            case DPIClassification.DPI_240:
               this.layoutThumbWidth = 40;
               this.layoutThumbHeight = 40;
               this.trackWidth = 84;
               this.trackHeight = 46;
               break;
            case DPIClassification.DPI_120:
               this.layoutThumbWidth = 20;
               this.layoutThumbHeight = 20;
               this.trackWidth = 42;
               this.trackHeight = 23;
               break;
            default:
               this.layoutThumbWidth = 27;
               this.layoutThumbHeight = 27;
               this.trackWidth = 56;
               this.trackHeight = 31;
         }
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.contents = new UIComponent();
         addChild(this.contents);
         this.drawTracks();
         this.drawThumbs();
      }
      
      override protected function measure() : void
      {
         measuredMinWidth = this.trackWidth;
         measuredMinHeight = this.trackHeight;
         measuredWidth = this.trackWidth;
         measuredHeight = this.trackHeight;
      }
      
      override protected function commitCurrentState() : void
      {
         this.toggleSelectionState();
         this.layoutThumbs();
      }
      
      protected function drawTracks() : void
      {
         this.drawTrackOff();
         this.drawTrackOn();
         if(this.track == null)
         {
            this.track = this.trackOff;
         }
      }
      
      protected function drawTrackOn() : void
      {
         this.trackOn = new this.switchTrackOn();
         this.trackOn.width = this.trackWidth;
         this.trackOn.height = this.trackHeight;
         this.contents.addChildAt(SpriteVisualElement(this.trackOn),0);
      }
      
      protected function drawTrackOff() : void
      {
         this.trackOff = new this.switchTrackOff();
         this.trackOff.width = this.trackWidth;
         this.trackOff.height = this.trackHeight;
         this.contents.addChildAt(SpriteVisualElement(this.trackOff),0);
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
         setElementPosition(this.thumbOn,this.trackWidth / 2,this.trackHeight / 2 - this.thumbOn.height / 2);
         setElementPosition(this.thumbOff,0,this.trackHeight / 2 - this.thumbOff.height / 2);
      }
      
      protected function toggleSelectionState() : void
      {
         if(currentState.indexOf("AndSelected") != -1)
         {
            this.thumbOn.visible = true;
            this.thumbOff.visible = false;
            this.thumb = this.thumbOn;
            this.trackOn.visible = true;
            this.trackOff.visible = false;
            this.track = this.trackOn;
         }
         else
         {
            this.thumbOff.visible = true;
            this.thumbOn.visible = false;
            this.thumb = this.thumbOff;
            this.trackOff.visible = true;
            this.trackOn.visible = false;
            this.track = this.trackOff;
         }
      }
      
      protected function drawThumbOn() : void
      {
         this.thumbOn = new this.switchOn();
         this.thumbOn.width = this.layoutThumbWidth;
         this.thumbOn.height = this.layoutThumbHeight;
         this.contents.addChildAt(SpriteVisualElement(this.thumbOn),2);
      }
      
      protected function drawThumbOff() : void
      {
         this.thumbOff = new this.switchOff();
         this.thumbOff.width = this.layoutThumbWidth;
         this.thumbOff.height = this.layoutThumbHeight;
         this.contents.addChildAt(SpriteVisualElement(this.thumbOff),2);
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

class LabelDisplayComponent#701 extends UIComponent implements IDisplayText
{
    
   
   public var shadowYOffset:Number = 0;
   
   private var labelChanged:Boolean = false;
   
   private var labelDisplay:StyleableTextField;
   
   private var labelDisplayShadow:StyleableTextField;
   
   private var _text:String;
   
   function LabelDisplayComponent#701()
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
