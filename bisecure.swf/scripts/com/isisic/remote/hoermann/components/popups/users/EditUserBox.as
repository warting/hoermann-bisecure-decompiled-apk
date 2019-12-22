package com.isisic.remote.hoermann.components.popups.users
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.hoermann.net.dao.users.GatewayUsers;
   import com.isisic.remote.lw.Debug;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import flash.text.ReturnKeyLabel;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import mx.graphics.SolidColorStroke;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.events.PopUpEvent;
   import spark.primitives.Line;
   
   public class EditUserBox extends Popup
   {
       
      
      private var _user:User = null;
      
      private var lblUserName:Label;
      
      private var txtUserName:TextInput;
      
      private var tmpUserName:String;
      
      private var btnChangePassword:Button;
      
      private var btnDelete:Button;
      
      private var grpControllButtons:Group;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      public function EditUserBox()
      {
         super();
         this.title = Lang.getString("EDIT_USER_TITLE");
      }
      
      public function set user(param1:User) : void
      {
         this._user = param1;
         this.tmpUserName = this.user.name;
         if(this.txtUserName != null)
         {
            this.onUserNameComplete(null);
         }
      }
      
      public function get user() : User
      {
         return this._user;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(this.user == null)
         {
            Debug.error("[EditUserScreen] Failed to open Popup (No user to edit)!");
            return;
         }
         super.open(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblUserName = new Label();
         this.lblUserName.text = Lang.getString("GENERAL_USERNAME");
         this.txtUserName = new TextInput();
         this.txtUserName.autoCorrect = false;
         this.txtUserName.percentWidth = 100;
         this.txtUserName.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtUserName.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.txtUserName.addEventListener(FlexEvent.CREATION_COMPLETE,this.onUserNameComplete);
         this.btnChangePassword = new Button();
         this.btnChangePassword.percentWidth = 100;
         this.btnChangePassword.label = Lang.getString("OPTIONS_CHANGE_PASSWORD");
         this.btnChangePassword.addEventListener(MouseEvent.CLICK,this.onChangePasswordClick);
         this.btnDelete = new Button();
         this.btnDelete.percentWidth = 100;
         this.btnDelete.label = Lang.getString("GENERAL_DELETE");
         this.btnDelete.addEventListener(MouseEvent.CLICK,this.onDeleteClick);
         this.btnSubmit = new Button();
         this.btnSubmit.percentWidth = 100;
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmitClick);
         this.btnCancel = new Button();
         this.btnCancel.percentWidth = 100;
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.addElement(this.lblUserName);
         this.addElement(this.txtUserName);
         var _loc1_:Spacer = new Spacer();
         _loc1_.height = 15;
         this.addElement(_loc1_);
         this.addElement(this.btnChangePassword);
         this.addElement(this.btnDelete);
         _loc1_ = new Spacer();
         _loc1_.height = 7;
         this.addElement(_loc1_);
         var _loc2_:Line = new Line();
         _loc2_.percentWidth = 100;
         _loc2_.stroke = new SolidColorStroke(13421772,2);
         this.addElement(_loc2_);
         _loc1_ = new Spacer();
         _loc1_.height = 7;
         this.addElement(_loc1_);
         this.grpControllButtons = new HGroup();
         this.grpControllButtons.percentWidth = 100;
         this.grpControllButtons.addElement(this.btnCancel);
         this.grpControllButtons.addElement(this.btnSubmit);
         this.addElement(this.grpControllButtons);
      }
      
      private function presentError(param1:String, param2:String) : void
      {
         HoermannRemote.errorBox.title = param1;
         HoermannRemote.errorBox.contentText = param2;
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
      }
      
      private function onKeyboardEnter(param1:FlexEvent) : void
      {
         stage.focus = null;
      }
      
      private function onChangePasswordClick(param1:MouseEvent) : void
      {
         var _loc2_:ChangePasswordBox = new ChangePasswordBox();
         _loc2_.user = this.user;
         _loc2_.open(null);
      }
      
      private function onDeleteClick(param1:MouseEvent) : void
      {
         HoermannRemote.confirmBox.title = Lang.getString("CONFIRM_DELETE_USER");
         HoermannRemote.confirmBox.contentText = Lang.getString("CONFIRM_DELETE_USER_CONTENT");
         HoermannRemote.confirmBox.submitTitle = Lang.getString("GENERAL_YES");
         HoermannRemote.confirmBox.cancelTitle = Lang.getString("GENERAL_NO");
         HoermannRemote.confirmBox.data = this.user;
         HoermannRemote.confirmBox.addEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         HoermannRemote.confirmBox.open(null);
      }
      
      private function onDeleteCommit(param1:PopUpEvent) : void
      {
         var self:EditUserBox = null;
         var event:PopUpEvent = param1;
         if(!event.commit)
         {
            return;
         }
         HoermannRemote.confirmBox.removeEventListener(PopUpEvent.CLOSE,this.onDeleteCommit);
         self = this;
         GatewayUsers.instance.deleteUser(event.data,function(param1:User, param2:Error):void
         {
            if(param2 == null)
            {
               self.close(true);
            }
            else
            {
               self.presentError(Lang.getString("ERROR_REMOVE_USER"),Lang.getString("ERROR_REMOVE_USER_CONTENT"));
            }
         });
      }
      
      private function onSubmitClick(param1:MouseEvent) : void
      {
         var self:EditUserBox = null;
         var event:MouseEvent = param1;
         if(this.user.name == this.txtUserName.text)
         {
            Debug.info("[EditUserScreen] Nothing to update (Username didn\'t change)");
            this.close(true);
            return;
         }
         self = this;
         this.user.name = this.txtUserName.text;
         GatewayUsers.instance.updateName(this.user,function(param1:User, param2:Error):void
         {
            if(param2 == null)
            {
               self.close(true);
            }
            else
            {
               self.presentError(Lang.getString("ERROR_CHANGE_USERNAME"),Lang.getString("ERROR_CHANGE_USERNAME_CONTENT"));
            }
         });
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         this.close(false);
      }
      
      private function onUserNameComplete(param1:FlexEvent) : void
      {
         if(this.tmpUserName != null)
         {
            this.txtUserName.text = this.tmpUserName;
         }
      }
   }
}
