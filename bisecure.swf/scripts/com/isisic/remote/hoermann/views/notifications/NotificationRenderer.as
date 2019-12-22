package com.isisic.remote.hoermann.views.notifications
{
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgNotificationInfo;
   import com.isisic.remote.hoermann.assets.images.thumbs.ImgNotificationWarn;
   import flashx.textLayout.formats.VerticalAlign;
   import me.mweber.itemRenderer.BetterItemRenderer;
   import mx.controls.Spacer;
   import mx.core.IVisualElement;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.layouts.HorizontalLayout;
   
   public class NotificationRenderer extends BetterItemRenderer
   {
       
      
      private var iconDisplay:Group;
      
      private var iconSpacer:Spacer;
      
      private var textGroup:VGroup;
      
      private var titleDisplay:Label;
      
      private var contentDisplay:Label;
      
      public function NotificationRenderer()
      {
         super();
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.paddingLeft = 10;
         _loc1_.paddingRight = 10;
         _loc1_.paddingTop = 10;
         _loc1_.paddingBottom = 10;
         _loc1_.verticalAlign = VerticalAlign.MIDDLE;
         layout = _loc1_;
      }
      
      private function updateIcon(param1:String = "") : void
      {
         var _loc2_:IVisualElement = null;
         this.iconDisplay.removeAllElements();
         switch(param1.toUpperCase())
         {
            case "INFO":
               _loc2_ = new ImgNotificationInfo();
               break;
            case "WARNING":
               _loc2_ = new ImgNotificationWarn();
         }
         if(_loc2_ != null)
         {
            _loc2_.percentHeight = 100;
            _loc2_.percentWidth = 100;
            this.iconDisplay.addElement(_loc2_);
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(data != null)
         {
            this.titleDisplay.text = param1.title;
            this.contentDisplay.text = param1.content;
            this.updateIcon(param1.type);
         }
         else
         {
            this.updateIcon();
            this.iconDisplay = null;
            this.titleDisplay = null;
            this.contentDisplay = null;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.iconDisplay = new Group();
         this.iconDisplay.percentHeight = 60;
         this.iconSpacer = new Spacer();
         this.iconSpacer.width = 10;
         this.textGroup = new VGroup();
         this.textGroup.percentWidth = 100;
         this.titleDisplay = new Label();
         this.titleDisplay.percentWidth = 100;
         this.titleDisplay.styleName = "title";
         this.contentDisplay = new Label();
         this.contentDisplay.percentWidth = 100;
         this.contentDisplay.maxDisplayedLines = 1;
         addElement(this.iconDisplay);
         addElement(this.iconSpacer);
         this.textGroup.addElement(this.titleDisplay);
         this.textGroup.addElement(this.contentDisplay);
         addElement(this.textGroup);
      }
      
      override protected function layoutComponents(param1:Number, param2:Number) : void
      {
         super.layoutComponents(param1,param2);
         this.iconDisplay.width = this.iconDisplay.height;
      }
   }
}
