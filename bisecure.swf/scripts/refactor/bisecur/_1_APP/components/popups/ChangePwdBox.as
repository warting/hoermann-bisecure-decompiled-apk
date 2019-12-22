package refactor.bisecur._1_APP.components.popups
{
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.hoermann.global.helper.StringValidator;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.ReturnKeyLabel;
   import flash.utils.Timer;
   import mx.controls.Spacer;
   import mx.events.FlexEvent;
   import refactor.bisecur._2_SAL.AppCache;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.net.cache.users.GatewayUsers;
   import refactor.bisecur._5_UTIL.InfoCenter;
   import refactor.logicware._5_UTIL.Log;
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
         var loadBox:LoadBox = null;
         var event:MouseEvent = param1;
         var errorBox:ErrorBox = ErrorBox.sharedBox;
         var error:String = null;
         if(!StringValidator.checkPasswd(this.newPasswd.text))
         {
            errorBox.title = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID");
            errorBox.contentText = Lang.getString("CHANGE_PWD_NEW_PASSWORD_INVALID_CONTENT");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         if(this.newPasswd.text != this.retype.text)
         {
            errorBox.title = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL");
            errorBox.contentText = Lang.getString("CHANGE_PWD_PASSWORD_NOT_EQUAL_CONTENT");
            errorBox.closeable = true;
            errorBox.closeTitle = Lang.getString("GENERAL_SUBMIT");
            errorBox.open(null);
            return;
         }
         loadBox = LoadBox.sharedBox;
         loadBox.title = Lang.getString("CHANGE_PWD_SETTING_PASSWORD");
         loadBox.contentText = Lang.getString("CHANGE_PWD_SETTING_PASSWORD_CONTENT");
         loadBox.open(null);
         var activeUser:User = AppCache.sharedCache.loggedInUser;
         activeUser.password = this.newPasswd.text;
         GatewayUsers.instance.updatePassword(activeUser,function(param1:User, param2:Error):void
         {
            if(param2 != null)
            {
               Log.error("[ChangePwdBox] Updating Password failed! " + param2);
               InfoCenter.onNetTimeout();
               return;
            }
            loadBox.close();
            close();
         });
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         LoadBox.sharedBox.close();
         var _loc2_:ErrorBox = ErrorBox.sharedBox;
         _loc2_.title = Lang.getString("ERROR_TIMEOUT");
         _loc2_.contentText = Lang.getString("ERROR_TIMEOUT_CONTENT");
         _loc2_.closeable = true;
         _loc2_.closeTitle = Lang.getString("GENERAL_SUBMIT");
         _loc2_.open(null);
      }
   }
}
