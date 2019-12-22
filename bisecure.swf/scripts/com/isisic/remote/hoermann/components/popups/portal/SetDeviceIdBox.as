package com.isisic.remote.hoermann.components.popups.portal
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.components.popups.Toast;
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.PortalData;
   import com.isisic.remote.hoermann.net.portal.PortalCommunicator;
   import com.isisic.remote.hoermann.net.portal.PortalDataValidateEvent;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AutoCapitalize;
   import flash.text.ReturnKeyLabel;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.events.PopUpEvent;
   
   public class SetDeviceIdBox extends Popup
   {
       
      
      private var lblContent:Label;
      
      private var sp1:Spacer;
      
      private var lblUsername:Label;
      
      private var txtUsername:TextInput;
      
      private var sp2:Spacer;
      
      private var lblPassword:Label;
      
      private var txtPassword:TextInput;
      
      private var sp3:Spacer;
      
      private var lblId:Label;
      
      private var txtId:TextInput;
      
      private var sp4:Spacer;
      
      private var buttonBar:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var presenterListener:Function = null;
      
      public function SetDeviceIdBox()
      {
         super();
         this.title = Lang.getString("PORTAL_SET_ID_DIALOG");
      }
      
      public function set deviceId(param1:String) : void
      {
         if(!this.txtId)
         {
            Debug.warning("[SetPortalIdBox] NOT INITIALIZED!");
            return;
         }
         this.txtId.text = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.txtId.text = this.txtId.text + param1.substr(_loc2_,1);
            if((_loc2_ + 1) % 4 == 0 && _loc2_ + 1 < param1.length)
            {
               this.txtId.text = this.txtId.text + "-";
            }
            _loc2_++;
         }
      }
      
      public function get deviceId() : String
      {
         var _loc3_:String = null;
         if(!this.txtId)
         {
            Debug.warning("[SetPortalIdBox] NOT INITIALIZED!");
            return null;
         }
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.txtId.text.length)
         {
            _loc3_ = this.txtId.text.substr(_loc2_,1);
            if(_loc3_ != "-")
            {
               _loc1_ = _loc1_ + _loc3_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         this.changeInputState(true);
         var _loc3_:Object = HoermannRemote.appData.portalData;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:String = _loc3_.deviceId;
         this.deviceId = _loc3_.deviceId;
         this.txtUsername.text = _loc3_.username;
         this.txtPassword.text = _loc3_.password;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.lblContent = new Label();
         this.lblContent.text = Lang.getString("PORTAL_SET_ID_DIALOG_CONTENT");
         this.addElement(this.lblContent);
         this.sp1 = new Spacer();
         this.addElement(this.sp1);
         this.lblId = new Label();
         this.lblId.text = Lang.getString("GENERAL_PORTAL_ID");
         this.lblId.styleName = "title";
         this.addElement(this.lblId);
         this.txtId = new TextInput();
         this.txtId.autoCorrect = false;
         this.txtId.autoCapitalize = AutoCapitalize.ALL;
         this.txtId.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.txtId.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.addElement(this.txtId);
         this.sp4 = new Spacer();
         this.addElement(this.sp4);
         this.lblUsername = new Label();
         this.lblUsername.text = Lang.getString("GENERAL_USERNAME");
         this.lblUsername.styleName = "title";
         this.txtUsername = new TextInput();
         this.sp2 = new Spacer();
         this.addElement(this.sp2);
         this.lblPassword = new Label();
         this.lblPassword.text = Lang.getString("GENERAL_PASSWORD");
         this.lblPassword.styleName = "title";
         this.addElement(this.lblPassword);
         this.txtPassword = new TextInput();
         this.txtPassword.displayAsPassword = true;
         this.txtPassword.returnKeyLabel = ReturnKeyLabel.DONE;
         this.txtPassword.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.addElement(this.txtPassword);
         this.sp3 = new Spacer();
         this.addElement(this.sp3);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancel);
         this.buttonBar = new HGroup();
         this.buttonBar.addElement(this.btnCancel);
         this.buttonBar.addElement(this.btnSubmit);
         this.addElement(this.buttonBar);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         if(param1.currentTarget == this.txtId)
         {
            stage.focus = this.txtPassword;
         }
         else
         {
            stage.focus = null;
         }
      }
      
      protected function onSubmit(param1:MouseEvent) : void
      {
         if(Features.presenterVersion)
         {
            Toast.show(Lang.getString("GENERAL_PRESENTER_ACTIVE"),Toast.DURATION_LONG);
            return;
         }
         if(this.deviceId == "")
         {
            HoermannRemote.appData.portalData = null;
            this.close();
            return;
         }
         if(!StringValidator.checkDeviceID(this.deviceId))
         {
            Debug.debug("[SetDeviceIdBox] validation failed (Invalide ID)");
            HoermannRemote.errorBox.title = Lang.getString("PORTAL_AUTHENTICATION_FAILED");
            HoermannRemote.errorBox.contentText = Lang.getString("PORTAL_AUTHENTICATION_FAILED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         Debug.debug("[SetDeviceIdBox] Valid ID");
         this.checkUser();
      }
      
      protected function changeInputState(param1:Boolean = true) : void
      {
         this.txtId.enabled = param1;
         this.txtPassword.enabled = param1;
         this.txtUsername.enabled = param1;
         this.buttonBar.enabled = param1;
      }
      
      protected function checkUser() : void
      {
         var pdata:PortalData = null;
         var self:SetDeviceIdBox = null;
         var val:Function = null;
         var fail:Function = null;
         var auth:Function = null;
         pdata = new PortalData();
         pdata.username = this.txtUsername.text;
         pdata.password = this.txtPassword.text;
         pdata.deviceId = this.deviceId;
         self = this;
         var c:PortalCommunicator = PortalCommunicator.defaultCommunicator;
         this.changeInputState(false);
         c.addEventListener(PortalDataValidateEvent.VALIDATED,val = function(param1:Event):void
         {
            var onInfoClose:* = undefined;
            var event:Event = param1;
            event.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATED,val);
            event.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATION_FAILED,fail);
            event.currentTarget.removeEventListener(PortalDataValidateEvent.AUTH_FAILED,auth);
            Debug.debug("Communicator VALIDATED");
            HoermannRemote.appData.portalData = pdata;
            Logicware.API.clientId = pdata.deviceId;
            HoermannRemote.errorBox.title = Lang.getString("PORTAL_VALIDATION_SUCCEEDED");
            HoermannRemote.errorBox.contentText = Lang.getString("PORTAL_VALIDATION_SUCCEEDED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.addEventListener(PopUpEvent.CLOSE,onInfoClose = function(param1:Event):void
            {
               HoermannRemote.errorBox.removeEventListener(PopUpEvent.CLOSE,onInfoClose);
               self.close(true,pdata);
            });
            HoermannRemote.errorBox.open(HoermannRemote.app.navigator);
            changeInputState(true);
         });
         c.addEventListener(PortalDataValidateEvent.VALIDATION_FAILED,fail = function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATED,val);
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATION_FAILED,fail);
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.AUTH_FAILED,auth);
            HoermannRemote.errorBox.title = Lang.getString("PORTAL_VALIDATION_FAILED");
            HoermannRemote.errorBox.contentText = Lang.getString("PORTAL_VALIDATION_FAILED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            changeInputState(true);
            Debug.debug("Communicator VALIDATION FAILED (invalid ID)");
         });
         c.addEventListener(PortalDataValidateEvent.AUTH_FAILED,auth = function(param1:Event):void
         {
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATED,val);
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.VALIDATION_FAILED,fail);
            param1.currentTarget.removeEventListener(PortalDataValidateEvent.AUTH_FAILED,auth);
            HoermannRemote.errorBox.title = Lang.getString("PORTAL_AUTHENTICATION_FAILED");
            HoermannRemote.errorBox.contentText = Lang.getString("PORTAL_AUTHENTICATION_FAILED_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            this.enabled = true;
            changeInputState(true);
            Debug.debug("Communicator AUTHENTICATION FAILED");
         });
         c.validatePortalData(pdata);
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
      
      override public function close(param1:Boolean = false, param2:* = null) : void
      {
         this.changeInputState(false);
         super.close(param1,param2);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.content.width - innerPadding * 2;
         this.lblContent.width = _loc3_;
         this.sp1.height = innerPadding;
         this.lblUsername.width = _loc3_;
         this.txtUsername.width = _loc3_;
         this.sp2.height = innerPadding;
         this.lblPassword.width = _loc3_;
         this.txtPassword.width = _loc3_;
         this.sp3.height = innerPadding;
         this.lblId.width = _loc3_;
         this.txtId.width = _loc3_;
         this.sp4.height = innerPadding;
         this.buttonBar.width = _loc3_;
         this.btnSubmit.percentWidth = 50;
         this.btnCancel.percentWidth = 50;
      }
   }
}
