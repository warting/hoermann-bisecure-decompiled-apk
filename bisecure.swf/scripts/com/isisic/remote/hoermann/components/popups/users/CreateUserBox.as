package com.isisic.remote.hoermann.components.popups.users
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.layouts.HorizontalAlign;
   
   public class CreateUserBox extends Popup
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
      
      private var lblReType:Label;
      
      private var txtReType:TextInput;
      
      private var grpButtons:HGroup;
      
      private var btnOk:Button;
      
      private var btnCancel:Button;
      
      private var tmpName:String;
      
      private var tmpPassword:String;
      
      public function CreateUserBox()
      {
         super();
         this.title = Lang.getString("CREATE_USER_TITLE");
      }
      
      public function get username() : String
      {
         if(this.txtName)
         {
            return this.txtName.text;
         }
         return "";
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
         return "";
      }
      
      public function set password(param1:String) : void
      {
         this.tmpPassword = param1;
         if(this.txtPassword)
         {
            this.onPasswordComplete(null);
         }
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         this.username = "";
         this.password = "";
         if(this.txtReType)
         {
            this.txtReType.text = "";
         }
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
         this.txtName.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.txtName.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtName.addEventListener(FlexEvent.CREATION_COMPLETE,this.onNameComplete);
         this.lblPassword = new Label();
         this.lblPassword.text = Lang.getString("GENERAL_PASSWORD");
         this.txtPassword = new TextInput();
         this.txtPassword.displayAsPassword = true;
         this.txtPassword.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.txtPassword.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtPassword.addEventListener(FlexEvent.CREATION_COMPLETE,this.onPasswordComplete);
         this.lblReType = new Label();
         this.lblReType.text = Lang.getString("GENERAL_RETYPE");
         this.txtReType = new TextInput();
         this.txtReType.displayAsPassword = true;
         this.txtReType.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtReType.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
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
         this.addElement(this.lblError);
         this.addElement(this.spacer0);
         this.addElement(this.lblName);
         this.addElement(this.txtName);
         this.addElement(this.spacer1);
         this.addElement(this.lblPassword);
         this.addElement(this.txtPassword);
         this.addElement(this.spacer2);
         this.addElement(this.lblReType);
         this.addElement(this.txtReType);
         this.addElement(this.spacer3);
         this.addElement(this.grpButtons);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         if(param1.currentTarget == this.txtName)
         {
            stage.focus = this.txtPassword;
         }
         else if(param1.currentTarget == this.txtPassword)
         {
            stage.focus = this.txtReType;
         }
         else
         {
            stage.focus = null;
         }
      }
      
      private function onOkClick(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         this.lblError.text = "";
         if(!StringValidator.checkUsername(this.txtName.text))
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_USER_INVALID");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_USER_INVALID_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         if(this.password.length < MIN_PASSWORD_LENGTH)
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         if(this.password != this.txtReType.text)
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         this.dispatchEvent(new Event(Event.COMPLETE));
         this.close(true);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.lblError.text = "";
         this.dispatchEvent(new Event(Event.CLOSE));
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
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.spacer0.height = innerPadding;
         this.spacer1.height = innerPadding;
         this.spacer2.height = innerPadding;
         this.spacer3.height = innerPadding;
         this.spacerBtn.height = innerPadding * 2;
         this.lblName.width = this.content.width - innerPadding * 2;
         this.txtName.width = this.content.width - innerPadding * 2;
         this.lblPassword.width = this.content.width - innerPadding * 2;
         this.txtPassword.width = this.content.width - innerPadding * 2;
         this.lblReType.width = this.content.width - innerPadding * 2;
         this.txtReType.width = this.content.width - innerPadding * 2;
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.grpButtons.width = _loc3_;
         this.btnOk.width = _loc3_ * 0.5;
         this.btnCancel.width = _loc3_ * 0.5;
      }
   }
}
