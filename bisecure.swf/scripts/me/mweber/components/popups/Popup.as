package me.mweber.components.popups
{
   import com.isisic.remote.lw.Debug;
   import flash.display.DisplayObjectContainer;
   import flash.events.StageOrientationEvent;
   import mx.core.EventPriority;
   import mx.core.IVisualElement;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.SkinnablePopUpContainer;
   import spark.layouts.VerticalLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class Popup extends SkinnablePopUpContainer
   {
      
      protected static var popupWidth:Number = 0.9;
      
      protected static const innerPadding:Number = 15;
       
      
      protected var content:SkinnableContainer;
      
      protected var titleBar:SkinnableContainer;
      
      protected var titleDisplay:Label;
      
      private var tempTitle:String = "";
      
      private var tempLayout:LayoutBase;
      
      public function Popup()
      {
         super();
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.paddingLeft = innerPadding;
         _loc1_.paddingRight = innerPadding;
         _loc1_.paddingTop = innerPadding;
         _loc1_.paddingBottom = innerPadding;
         this.layout = _loc1_;
      }
      
      public function set title(param1:String) : void
      {
         this.tempTitle = param1;
         if(this.titleDisplay)
         {
            this.onTitleReady(null);
         }
      }
      
      public function get title() : String
      {
         return this.tempTitle;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(param1 is UIComponent)
         {
            this.styleName = (param1 as UIComponent).styleName;
         }
         super.open(param1,param2);
         this.width = param1.width;
         this.height = param1.height;
         stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.onOrientationChanged);
      }
      
      override public function close(param1:Boolean = false, param2:* = null) : void
      {
         stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.onOrientationChanged);
         super.close(param1,param2);
      }
      
      protected function onBackKey(param1:FlexEvent) : void
      {
         param1.preventDefault();
         this.close();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.titleBar = new SkinnableContainer();
         this.titleBar.styleName = "titleContainer";
         this.titleDisplay = new Label();
         this.titleBar.addElement(this.titleDisplay);
         this.titleDisplay.addEventListener(FlexEvent.CREATION_COMPLETE,this.onTitleReady,false,EventPriority.EFFECT,true);
         super.addElement(this.titleBar);
         this.content = new SkinnableContainer();
         this.content.addEventListener(FlexEvent.CREATION_COMPLETE,this.onContentReady);
         this.content.styleName = "contentContainer";
         super.addElement(this.content);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.content.width = param1 * popupWidth;
         this.content.x = param1 * ((1 - popupWidth) / 2);
         this.content.y = param2 / 2 - this.content.measuredHeight / 2;
         this.titleBar.width = this.content.width;
         this.titleBar.height = this.titleDisplay.height * 2;
         this.titleBar.x = this.content.x;
         this.titleBar.y = this.content.y - this.titleBar.height;
         this.titleDisplay.y = this.titleBar.height / 2 - this.titleDisplay.height / 2;
         this.titleDisplay.x = this.titleDisplay.height / 2;
         this.titleDisplay.width = this.content.width - innerPadding * 2;
      }
      
      override public function addElement(param1:IVisualElement) : IVisualElement
      {
         return this.content.addElement(param1);
      }
      
      override public function get layout() : LayoutBase
      {
         return this.tempLayout;
      }
      
      override public function set layout(param1:LayoutBase) : void
      {
         this.tempLayout = param1;
         if(this.content)
         {
            this.onContentReady(null);
         }
      }
      
      private function onTitleReady(param1:FlexEvent) : void
      {
         this.titleDisplay.text = this.tempTitle;
      }
      
      private function onContentReady(param1:FlexEvent) : void
      {
         if(this.tempLayout)
         {
            this.content.layout = this.tempLayout;
         }
      }
      
      private function onOrientationChanged(param1:StageOrientationEvent) : void
      {
         invalidateDisplayList();
         Debug.debug("[Popup] Orientation changed!");
      }
   }
}
