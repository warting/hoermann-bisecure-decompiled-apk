package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.text.AutoCapitalize;
   import flash.text.ReturnKeyLabel;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.layouts.HorizontalAlign;
   
   public class LoginBox extends Popup
   {
      
      private static const MIN_PASSWORD_LENGTH:int = 4;
       
      
      private var lblError:Label;
      
      private var lblName:Label;
      
      private var txtName:TextInput;
      
      private var spacer0:Spacer;
      
      private var spacer1:Spacer;
      
      private var spacer2:Spacer;
      
      private var spacer3:Spacer;
      
      private var spacerBtn:Spacer;
      
      private var lblPassword:Label;
      
      private var txtPassword:TextInput;
      
      private var chkSave:CheckBox;
      
      private var grpButtons:HGroup;
      
      private var btnOk:Button;
      
      private var btnCancel:Button;
      
      private var tmpName:String;
      
      private var tmpPassword:String;
      
      private var tmpShouldSave:Boolean;
      
      public function LoginBox()
      {
         super();
         this.title = Lang.getString("LOGIN_TITLE");
      }
      
      public function get username() : String
      {
         if(this.txtName)
         {
            return this.txtName.text;
         }
         return this.tmpName;
      }
      
      public function set username(param1:String) : void
      {
         this.tmpName = param1;
         if(this.txtName)
         {
            this.onNameComplete(null);
         }
      }
      
      public function get password() : String
      {
         if(this.txtPassword)
         {
            return this.txtPassword.text;
         }
         return this.tmpPassword;
      }
      
      public function set password(param1:String) : void
      {
         this.tmpPassword = param1;
         if(this.txtPassword)
         {
            this.onPasswordComplete(null);
         }
      }
      
      public function get shouldSave() : Boolean
      {
         if(this.chkSave)
         {
            return this.chkSave.selected;
         }
         return this.tmpShouldSave;
      }
      
      public function set shouldSave(param1:Boolean) : void
      {
         this.tmpShouldSave = param1;
         if(this.chkSave)
         {
            this.onChkComplete(null);
         }
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblError = new Label();
         this.lblError.styleName = "error";
         this.lblName = new Label();
         this.lblName.text = Lang.getString("GENERAL_USERNAME");
         this.txtName = new TextInput();
         this.txtName.autoCorrect = false;
         this.txtName.autoCapitalize = AutoCapitalize.NONE;
         this.txtName.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.txtName.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtName.addEventListener(FlexEvent.CREATION_COMPLETE,this.onNameComplete);
         this.lblPassword = new Label();
         this.lblPassword.text = Lang.getString("GENERAL_PASSWORD");
         this.txtPassword = new TextInput();
         this.txtPassword.displayAsPassword = true;
         this.txtPassword.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtPassword.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtPassword.addEventListener(FlexEvent.CREATION_COMPLETE,this.onPasswordComplete);
         this.chkSave = new CheckBox();
         this.chkSave.addEventListener(FlexEvent.CREATION_COMPLETE,this.onChkComplete);
         this.chkSave.label = Lang.getString("LOGIN_SHOULD_SAVE");
         this.grpButtons = new HGroup();
         this.grpButtons.horizontalAlign = HorizontalAlign.CENTER;
         this.btnOk = new Button();
         this.btnOk.label = Lang.getString("GENERAL_SUBMIT");
         this.btnOk.addEventListener(MouseEvent.CLICK,this.onOkClick);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.spacerBtn = new Spacer();
         this.grpButtons.addElement(this.btnCancel);
         this.grpButtons.addElement(this.spacerBtn);
         this.grpButtons.addElement(this.btnOk);
         this.spacer0 = new Spacer();
         this.spacer1 = new Spacer();
         this.spacer2 = new Spacer();
         this.spacer3 = new Spacer();
         this.addElement(this.spacer0);
         this.addElement(this.lblName);
         this.addElement(this.txtName);
         this.addElement(this.spacer1);
         this.addElement(this.lblPassword);
         this.addElement(this.txtPassword);
         this.addElement(this.spacer2);
         this.addElement(this.chkSave);
         this.addElement(this.spacer3);
         this.addElement(this.grpButtons);
      }
      
      private function onKeyboardEnter(param1:FlexEvent) : void
      {
         if(param1.currentTarget == this.txtName)
         {
            stage.focus = this.txtPassword;
         }
         else
         {
            stage.focus = null;
         }
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         this.lblError.text = "";
         this.close(true);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.lblError.text = "";
         this.close(false);
      }
      
      private function onNameComplete(param1:FlexEvent) : void
      {
         if(this.tmpName != null)
         {
            this.txtName.text = this.tmpName;
         }
      }
      
      private function onPasswordComplete(param1:FlexEvent) : void
      {
         if(this.tmpPassword != null)
         {
            this.txtPassword.text = this.tmpPassword;
         }
      }
      
      protected function onChkComplete(param1:FlexEvent) : void
      {
         this.chkSave.selected = this.tmpShouldSave;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         this.spacer0.height = innerPadding;
         this.spacer1.height = innerPadding;
         this.spacer2.height = innerPadding;
         this.spacer3.height = innerPadding;
         this.spacerBtn.height = innerPadding * 2;
         this.lblName.width = this.content.width - innerPadding * 2;
         this.txtName.width = this.content.width - innerPadding * 2;
         this.lblPassword.width = this.content.width - innerPadding * 2;
         this.txtPassword.width = this.content.width - innerPadding * 2;
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.grpButtons.width = _loc3_;
         this.btnOk.width = _loc3_ * 0.4;
         this.btnCancel.width = _loc3_ * 0.4;
         super.updateDisplayList(param1,param2);
      }
   }
}
