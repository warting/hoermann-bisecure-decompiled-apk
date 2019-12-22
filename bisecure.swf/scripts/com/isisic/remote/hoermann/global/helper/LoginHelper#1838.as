package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.AutoLoginData;
   import com.isisic.remote.hoermann.global.valueObjects.remoteObjects.User;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import com.isisic.remote.lw.Logicware;
   import com.isisic.remote.lw.mcp.Commands;
   import com.isisic.remote.lw.mcp.Errors;
   import com.isisic.remote.lw.mcp.MCPBuilder;
   import com.isisic.remote.lw.mcp.MCPLoader;
   import com.isisic.remote.lw.net.HTTPClient;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LoginHelper#1838 extends EventDispatcher implements IDisposable
   {
       
      
      public var context:ConnectionContext;
      
      public var gateway:Object;
      
      private var timeoutTimer:Timer;
      
      public function LoginHelper#1838(param1:ConnectionContext, param2:Object, param3:int = 12000)
      {
         super();
         this.context = param1;
         this.gateway = param2;
         this.timeoutTimer = new Timer(param3,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         HoermannRemote.appData.username = null;
         var _loc2_:int = 255;
         var _loc3_:String = "ERROR_CONNECTION_CLOSED_CONTENT";
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,_loc3_,_loc2_));
      }
      
      public function login(param1:String, param2:String, param3:Boolean) : void
      {
         var loaderComplete:Function = null;
         var loaderFailed:Function = null;
         var loader:MCPLoader = null;
         var username:String = param1;
         var password:String = param2;
         var savePasswd:Boolean = param3;
         if(HoermannRemote.appData.portalData)
         {
            Logicware.API.clientId = HoermannRemote.appData.portalData.deviceId;
            this.context.httpAutentication = HTTPClient.createBasicAuth(HoermannRemote.appData.portalData.deviceId,HoermannRemote.appData.portalData.password);
         }
         if(!this.context.connected)
         {
            Logicware.API.connect(this.context);
         }
         loader = Logicware.initMCPLoader(this.context,loaderComplete = function(param1:Event):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            if(!timeoutTimer || !timeoutTimer.running)
            {
               return;
            }
            if(loader.data.command == Commands.LOGIN && loader.data.response)
            {
               _loc2_ = loader.data.payload.readUnsignedByte();
               saveUser(_loc2_,username,password,savePasswd);
               HoermannRemote.appData.activeConnection = context;
               HoermannRemote.appData.isAdmin = _loc2_ < 1;
               HoermannRemote.appData.userId = _loc2_;
               HoermannRemote.appData.activeLogin = new AutoLoginData();
               HoermannRemote.appData.activeLogin.mac = context.mac;
               HoermannRemote.appData.activeLogin.username = username;
               HoermannRemote.appData.activeLogin.password = password;
               HoermannRemote.app.login(context);
               timeoutTimer.reset();
               dispatchEvent(new Event(Event.COMPLETE));
            }
            else if(loader.data.command == Commands.ERROR)
            {
               HoermannRemote.appData.username = null;
               _loc3_ = loader.data.payload.readUnsignedByte();
               _loc4_ = null;
               switch(_loc3_)
               {
                  case Errors.GATEWAY_BUSY:
                     _loc4_ = "LOGIN_FAILED_GATEWAY_BUSY";
                     break;
                  case Errors.LOGIN_FAILED:
                     _loc4_ = "LOGIN_FAILED_WRONG_DATA";
                     break;
                  default:
                     _loc4_ = "LOGIN_FAILED_UNKNOWN";
               }
               timeoutTimer.reset();
               dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,_loc4_,_loc3_));
            }
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         },loaderFailed = function(param1:Event):void
         {
            Debug.warning("[LoginHelper] Login request failed!\n" + param1);
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"POPUP_INET_SPEED_LOW",-1));
            Logicware.finalizeMCPLoader(loader,loaderComplete,loaderFailed);
         });
         Debug.debug("[LoginHelper] loginRequest send:\ncontext:" + this.context + "\nuser:" + username + "\npwd:" + password);
         loader.request(MCPBuilder.buildMCP(Commands.LOGIN,MCPBuilder.payloadLogin(username,password)));
         this.timeoutTimer.start();
      }
      
      private function saveUser(param1:int, param2:String, param3:String, param4:Boolean) : void
      {
         var _loc5_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:User = null;
         var _loc6_:Boolean = false;
         for each(_loc7_ in this.gateway.users)
         {
            if(_loc7_.id == param1)
            {
               _loc5_ = _loc7_;
               _loc6_ = true;
            }
         }
         if(!_loc6_)
         {
            _loc8_ = new User();
            _loc8_.id = param1;
            _loc8_.name = param2;
            _loc8_.scenarios = new Array();
            _loc5_ = _loc8_;
            if(this.gateway.hasOwnProperty("users") == false || this.gateway.users == null)
            {
               this.gateway.users = new Array();
            }
            this.gateway.users.push(_loc5_);
         }
         else if(_loc5_.name != param2)
         {
            _loc5_.name = param2;
            _loc5_.scenarios = new Array();
         }
         this.gateway.lastUser = param1;
         _loc5_.tmpPwd = param3;
         if(param4)
         {
            _loc5_.password = param3;
            if(HoermannRemote.appData.autoLogin && this.gateway.mac == HoermannRemote.appData.autoLogin.mac)
            {
               HoermannRemote.appData.autoLogin.password = param3;
               HoermannRemote.appData.autoLogin.username = param2;
            }
         }
         else
         {
            _loc5_.password = null;
            if(HoermannRemote.appData.autoLogin && this.gateway.mac == HoermannRemote.appData.autoLogin.mac)
            {
               HoermannRemote.appData.autoLogin = null;
            }
         }
         HoermannRemote.appData.save();
      }
      
      public function dispose() : void
      {
         this.context = null;
         this.gateway = null;
      }
   }
}
