package me.mweber.components.popups
{
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import mx.core.EventPriority;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.layouts.HorizontalAlign;
   
   public class InputBox extends Popup
   {
       
      
      private var lblContent:Label;
      
      private var txtInput:TextInput;
      
      private var grpButtons:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var tempContent:String;
      
      private var tempInput:String;
      
      private var tempCancel:String;
      
      private var tempSubmit:String;
      
      public function InputBox()
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
      
      public function set inputText(param1:String) : void
      {
         this.tempInput = param1;
         if(this.txtInput)
         {
            this.onInputReady(null);
         }
      }
      
      public function get inputText() : String
      {
         return this.tempInput;
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
         this.txtInput = new TextInput();
         this.txtInput.addEventListener(FlexEvent.CREATION_COMPLETE,this.onInputReady,false,EventPriority.EFFECT,true);
         this.addElement(this.txtInput);
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.CENTER;
         this.addElement(this.grpButtons);
         this.btnSubmit = new Button();
         this.btnSubmit.addEventListener(FlexEvent.CREATION_COMPLETE,this.onSubmitReady);
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.btnSubmit.percentWidth = 50;
         this.grpButtons.addElement(this.btnSubmit);
         this.btnCancel = new Button();
         this.btnCancel.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCancelReady);
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onClose);
         this.btnCancel.percentWidth = 50;
         this.grpButtons.addElement(this.btnCancel);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.lblContent.width = this.content.width - innerPadding * 2;
         this.txtInput.width = this.content.width - innerPadding * 2;
         this.grpButtons.width = this.lblContent.width;
      }
      
      private function onSubmit(param1:MouseEvent) : void
      {
         this.close(true,this.txtInput.text);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.close(false,this.txtInput.text);
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
      
      private function onInputReady(param1:FlexEvent) : void
      {
         this.txtInput.text = this.tempInput;
      }
   }
}
