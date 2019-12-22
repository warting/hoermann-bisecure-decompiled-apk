package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.events.MouseEvent;
   import flashx.textLayout.formats.LineBreak;
   import me.mweber.basic.helper.StringHelper;
   import mx.controls.Spacer;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.Scroller;
   import spark.layouts.HorizontalAlign;
   
   public class NotifictionBox extends Popup
   {
       
      
      public var data:Object;
      
      private var scroller:Scroller;
      
      private var lblContent:Label;
      
      private var sp2:Spacer;
      
      private var grpButtons:HGroup;
      
      private var btnClose:Button;
      
      private var tempContent:String;
      
      private var tempCloseTitle:String;
      
      private var tempCloseVisible:Boolean = false;
      
      private var tempSuppressVisible:Boolean = false;
      
      public function NotifictionBox(param1:Object)
      {
         super();
         this.contentText = StringHelper.unescapeString(param1.content);
         this.title = StringHelper.unescapeString(param1.title);
         this.closeable = true;
         this.closeTitle = Lang.getString("GENERAL_SUBMIT");
      }
      
      public function set contentText(param1:String) : void
      {
         this.tempContent = param1;
         if(this.lblContent)
         {
            this.onContentReady(null);
         }
      }
      
      public function get contentText() : String
      {
         return this.tempContent;
      }
      
      public function set closeable(param1:Boolean) : void
      {
         this.tempCloseVisible = param1;
         if(this.btnClose)
         {
            this.onCloseReady(null);
         }
      }
      
      public function get closeable() : Boolean
      {
         return this.tempCloseVisible;
      }
      
      public function set closeTitle(param1:String) : void
      {
         this.tempCloseTitle = param1;
         if(this.btnClose)
         {
            this.onCloseReady(null);
         }
      }
      
      public function get closeTitle() : String
      {
         return this.tempCloseTitle;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.scroller = new Scroller();
         this.scroller.percentWidth = 100;
         this.scroller.percentHeight = 100;
         this.lblContent = new Label();
         this.lblContent.percentWidth = 100;
         this.lblContent.setStyle("lineBreak",LineBreak.TO_FIT);
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.addElement(this.lblContent);
         this.scroller.viewport = _loc1_;
         this.lblContent.addEventListener(FlexEvent.CREATION_COMPLETE,this.onContentReady,false,EventPriority.EFFECT,true);
         addElement(this.scroller);
         this.sp2 = new Spacer();
         this.addElement(this.sp2);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.CENTER;
         this.addElement(this.grpButtons);
         this.btnClose = new Button();
         this.btnClose.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCloseReady);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose);
         this.grpButtons.addElement(this.btnClose);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.lblContent.width = this.content.width - innerPadding * 2;
         this.grpButtons.width = this.lblContent.width;
         this.btnClose.width = this.content.width / 2;
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.close(true,this.data);
      }
      
      private function onCloseReady(param1:FlexEvent) : void
      {
         this.btnClose.label = this.tempCloseTitle;
         this.btnClose.visible = this.tempCloseVisible;
      }
      
      private function onContentReady(param1:FlexEvent) : void
      {
         this.lblContent.text = this.tempContent;
      }
   }
}
