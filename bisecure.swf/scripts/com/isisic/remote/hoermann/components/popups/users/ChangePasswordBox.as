package com.isisic.remote.hoermann.components.popups.users
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.hoermann.net.dao.users.GatewayUsers;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import me.mweber.basic.helper.StringHelper;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   
   public class ChangePasswordBox extends Popup
   {
       
      
      private var _user:User = null;
      
      private var lblUsername:Label;
      
      private var tmpUsername:String;
      
      private var lblPassword:Label;
      
      private var txtPassword:TextInput;
      
      private var lblRetype:Label;
      
      private var txtRetype:TextInput;
      
      private var grpButtons:Group;
      
      private var btnCancel:Button;
      
      private var btnSubmit:Button;
      
      public function ChangePasswordBox()
      {
         super();
         this.title = Lang.getString("OPTIONS_CHANGE_PASSWORD");
      }
      
      public function set user(param1:User) : void
      {
         this._user = param1;
         this.tmpUsername = this.user.name;
         if(this.lblUsername != null)
         {
            this.onUsernameComplete(null);
         }
      }
      
      public function get user() : User
      {
         return this._user;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblUsername = new Label();
         this.lblUsername.addEventListener(FlexEvent.CREATION_COMPLETE,this.onUsernameComplete);
         this.lblPassword = new Label();
         this.lblPassword.text = Lang.getString("CHANGE_PWD_NEW_PASSWORD");
         this.txtPassword = new TextInput();
         this.txtPassword.percentWidth = 100;
         this.txtPassword.displayAsPassword = true;
         this.txtPassword.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.txtPassword.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.lblRetype = new Label();
         this.lblRetype.text = Lang.getString("GENERAL_RETYPE");
         this.txtRetype = new TextInput();
         this.txtRetype.percentWidth = 100;
         this.txtRetype.displayAsPassword = true;
         this.txtRetype.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtRetype.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.grpButtons = new HGroup();
         this.grpButtons.percentWidth = 100;
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.percentWidth = 100;
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.percentWidth = 100;
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.grpButtons.addElement(this.btnCancel);
         this.grpButtons.addElement(this.btnSubmit);
         this.addElement(this.lblUsername);
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 30;
         this.addElement(_loc1_);
         this.addElement(this.lblPassword);
         this.addElement(this.txtPassword);
         _loc1_ = new Spacer();
         _loc1_.height = 15;
         this.addElement(_loc1_);
         this.addElement(this.lblRetype);
         this.addElement(this.txtRetype);
         _loc1_ = new Spacer();
         _loc1_.height = 30;
         this.addElement(_loc1_);
         this.addElement(this.grpButtons);
      }
      
      private function onKeyboardEnter(param1:FlexEvent) : void
      {
         if(param1.currentTarget == this.txtPassword)
         {
            stage.focus = this.txtRetype;
         }
         else
         {
            stage.focus = null;
            this.onSubmit(param1);
         }
      }
      
      private function onCancel(param1:Event) : void
      {
         this.close(false);
      }
      
      private function onSubmit(param1:Event) : void
      {
         var self:ChangePasswordBox = null;
         var event:Event = param1;
         if(!StringValidator.checkPasswd(this.txtPassword.text))
         {
            this.presentError(Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID"),Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID_CONTENT"));
            return;
         }
         if(this.txtPassword.text != this.txtRetype.text)
         {
            this.presentError(Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL"),Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL_CONTENT"));
            return;
         }
         HoermannRemote.loadBox.title = Lang.getString("CHANGE_PWD_SETTING_PASSWORD");
         HoermannRemote.loadBox.contentText = Lang.getString("CHANGE_PWD_SETTING_PASSWORD_CONTENT");
         HoermannRemote.loadBox.open(null);
         self = this;
         this.user.password = this.txtPassword.text;
         GatewayUsers.instance.updatePassword(this.user,function(param1:User, param2:Error):void
         {
            HoermannRemote.loadBox.close();
            if(param2 != null)
            {
               presentError(Lang.getString("CHANGE_PWD_FAILED") + "(" + StringHelper.fillWith(param2.errorID.toString(16),"0",2) + ")",Lang.getString("CHANGE_PWD_FAILED_CONTENT"));
            }
            else
            {
               self.close(true);
            }
         });
      }
      
      private function onUsernameComplete(param1:FlexEvent) : void
      {
         if(this.tmpUsername != null)
         {
            this.lblUsername.text = Lang.getString("CHANGE_PWD_USERNAME") + " " + this.tmpUsername;
         }
      }
      
      private function presentError(param1:String, param2:String) : void
      {
         HoermannRemote.errorBox.title = param1;
         HoermannRemote.errorBox.contentText = param2;
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
      }
   }
}
