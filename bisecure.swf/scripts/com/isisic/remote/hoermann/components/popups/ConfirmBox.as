package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   
   public class ConfirmBox extends Popup
   {
       
      
      public var data:Object;
      
      private var lblContent:Label;
      
      private var grpButtons:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var tempContent:String;
      
      private var tempCancel:String;
      
      private var tempSubmit:String;
      
      public function ConfirmBox()
      {
         super();
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
      
      public function set submitTitle(param1:String) : void
      {
         this.tempSubmit = param1;
         if(this.btnSubmit)
         {
            this.onSubmitReady(null);
         }
      }
      
      public function get submitTitle() : String
      {
         return this.tempSubmit;
      }
      
      public function set cancelTitle(param1:String) : void
      {
         this.tempCancel = param1;
         if(this.btnCancel)
         {
            this.onCancelReady(null);
         }
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblContent = new Label();
         this.lblContent.addEventListener(FlexEvent.CREATION_COMPLETE,this.onContentReady,false,EventPriority.EFFECT,true);
         this.addElement(this.lblContent);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.CENTER;
         this.addElement(this.grpButtons);
         this.btnSubmit = new Button();
         this.btnSubmit.addEventListener(FlexEvent.CREATION_COMPLETE,this.onSubmitReady);
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.grpButtons.addElement(this.btnSubmit);
         this.btnCancel = new Button();
         this.btnCancel.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCancelReady);
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onClose);
         this.grpButtons.addElement(this.btnCancel);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.lblContent.width = this.content.width - innerPadding * 2;
         this.grpButtons.width = this.lblContent.width;
         this.btnSubmit.width = (this.content.width - innerPadding) / 3;
         this.btnCancel.width = (this.content.width - innerPadding) / 3;
      }
      
      private function onSubmit(param1:MouseEvent) : void
      {
         this.close(true,this.data);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.close(false,this.data);
      }
      
      private function onCancelReady(param1:FlexEvent) : void
      {
         if(this.tempCancel)
         {
            this.btnCancel.label = this.tempCancel;
         }
      }
      
      private function onSubmitReady(param1:FlexEvent) : void
      {
         if(this.tempSubmit)
         {
            this.btnSubmit.label = this.tempSubmit;
         }
      }
      
      private function onContentReady(param1:FlexEvent) : void
      {
         this.lblContent.text = this.tempContent;
      }
   }
}
