package com.isisic.remote.hoermann.components.popups
{
   import com.isisic.remote.hoermann.components.Popup;
   import com.isisic.remote.hoermann.global.helper.InfoCenter;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.ReturnKeyLabel;
   import flash.utils.Timer;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   
   public class ChangePwdBox extends Popup
   {
      
      private static const TIMEOUT_DELAY:int = 20000;
       
      
      private var desc:Label;
      
      private var sp1:Spacer;
      
      private var lblNewPwd:Label;
      
      private var newPasswd:TextInput;
      
      private var lblRetype:Label;
      
      private var sp3:Spacer;
      
      private var retype:TextInput;
      
      private var sp2:Spacer;
      
      private var btnGroup:HGroup;
      
      private var btnSubmit:Button;
      
      private var btnCancel:Button;
      
      private var timeoutTimer:Timer;
      
      public function ChangePwdBox()
      {
         super();
         this.title = Lang.getString("OPTIONS_CHANGE_PASSWORD");
         this.timeoutTimer = new Timer(TIMEOUT_DELAY,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
      }
      
      override protected function createChildren() : void
      {
         var self:ChangePwdBox = null;
         super.createChildren();
         this.desc = new Label();
         this.desc.percentWidth = 100;
         this.desc.text = Lang.getString("CHANGE_PWD_FIRST_START");
         this.addElement(this.desc);
         this.sp1 = new Spacer();
         this.sp1.height = 15;
         this.addElement(this.sp1);
         this.lblNewPwd = new Label();
         this.lblNewPwd.text = Lang.getString("CHANGE_PWD_NEW_PASSWORD");
         this.addElement(this.lblNewPwd);
         this.newPasswd = new TextInput();
         this.newPasswd.percentWidth = 100;
         this.newPasswd.displayAsPassword = true;
         this.newPasswd.returnKeyLabel = ReturnKeyLabel.NEXT;
         this.newPasswd.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.addElement(this.newPasswd);
         this.sp3 = new Spacer();
         this.sp3.height = 15;
         this.addElement(this.sp3);
         this.lblRetype = new Label();
         this.lblRetype.text = Lang.getString("GENERAL_RETYPE");
         this.addElement(this.lblRetype);
         this.retype = new TextInput();
         this.retype.percentWidth = 100;
         this.retype.displayAsPassword = true;
         this.retype.returnKeyLabel = ReturnKeyLabel.DONE;
         this.retype.addEventListener(FlexEvent.ENTER,this.onKeyboardEnter);
         this.addElement(this.retype);
         this.sp2 = new Spacer();
         this.sp2.height = 15;
         this.addElement(this.sp2);
         this.btnGroup = new HGroup();
         this.btnGroup.percentWidth = 100;
         self = this;
         this.btnCancel = new Button();
         this.btnCancel.label = Lang.getString("GENERAL_CANCEL");
         this.btnCancel.percentWidth = 100;
         this.btnCancel.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            self.close();
         });
         this.btnGroup.addElement(this.btnCancel);
         this.btnSubmit = new Button();
         this.btnSubmit.label = Lang.getString("GENERAL_SUBMIT");
         this.btnSubmit.percentWidth = 100;
         this.btnSubmit.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.btnGroup.addElement(this.btnSubmit);
         this.addElement(this.btnGroup);
      }
      
      protected function onKeyboardEnter(param1:Event) : void
      {
         if(param1.currentTarget == this.newPasswd)
         {
            stage.focus = this.retype;
         }
         else
         {
            stage.focus = null;
         }
      }
      
      private function onSubmit(param1:MouseEvent) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var event:MouseEvent = param1;
         var error:String = null;
         if(!StringValidator.checkPasswd(this.newPasswd.text))
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         if(this.newPasswd.text != this.retype.text)
         {
            HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL");
            HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL_CONTENT");
            HoermannRemote.errorBox.closeable = true;
            HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            HoermannRemote.errorBox.open(null);
            return;
         }
         HoermannRemote.loadBox.title = Lang.getString("CHANGE_PWD_SETTING_PASSWORD");
         HoermannRemote.loadBox.contentText = Lang.getString("CHANGE_PWD_SETTING_PASSWORD_CONTENT");
         HoermannRemote.loadBox.open(null);
         loader = Logicware.initMCPLoader(HoermannRemote.appData.activeConnection,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            if(loader.data.command == Commands.ERROR)
            {
               HoermannRemote.errorBox.title = Lang.getString("CHANGE_PWD_PASSWORD_INVALID");
               HoermannRemote.errorBox.contentText = Lang.getString("CHANGE_PWD_PASSWORD_INVALID_CONTENT");
               HoermannRemote.errorBox.closeable = true;
               HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
               HoermannRemote.errorBox.open(null);
               if(HoermannRemote.loadBox.isOpen)
               {
                  HoermannRemote.loadBox.close();
               }
            }
            else if(loader.data.command == Commands.CHANGE_PASSWD)
            {
               for each(_loc2_ in HoermannRemote.appData.activeGateway.users)
               {
                  if(_loc2_.id == HoermannRemote.appData.userId)
                  {
                     if(_loc2_.password)
                     {
                        _loc2_.password = newPasswd.text;
                     }
                  }
               }
               if(HoermannRemote.appData.autoLogin && HoermannRemote.appData.autoLogin.password != null)
               {
                  HoermannRemote.appData.autoLogin.password = newPasswd.text;
               }
               HoermannRemote.appData.save();
               HoermannRemote.loadBox.close();
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
            close(true);
         },loaderFailed = function(param1:Event):void
         {
            InfoCenter.onNetTimeout();
            Debug.warning("[ChangePasswordBox] sending ChangePassword failed!\n" + param1);
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         loader.request(MCPBuilder.buildMCP(Commands.CHANGE_PASSWD,MCPBuilder.payloadChangePassword(this.newPasswd.text)));
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         HoermannRemote.loadBox.close();
         HoermannRemote.errorBox.title = Lang.getString("ERROR_TIMEOUT");
         HoermannRemote.errorBox.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         HoermannRemote.errorBox.closeable = true;
         HoermannRemote.errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
         HoermannRemote.errorBox.open(null);
      }
   }
}
