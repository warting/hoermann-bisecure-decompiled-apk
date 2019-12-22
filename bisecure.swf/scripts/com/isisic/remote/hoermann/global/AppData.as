package com.isisic.remote.hoermann.global
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.valueObjects.localStorage.AutoLoginData;
   import com.isisic.remote.hoermann.net.HmProcessor;
   import com.isisic.remote.lw.ConnectionContext;
   import com.isisic.remote.lw.IDisposable;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AppData extends EventDispatcher implements IDisposable
   {
      
      public static const MAX_PORTS:int = 16;
       
      
      public var activeLogin:AutoLoginData;
      
      public var useAutoLogin:Boolean = true;
      
      private var _activeConnection:ConnectionContext;
      
      private var config:AsConfig;
      
      private var _244878312mcpProcessor:HmProcessor = null;
      
      private var _2054074437isAdmin:Boolean = false;
      
      private var _836030906userId:int = -1;
      
      public var username:String = null;
      
      public function AppData(param1:AsConfig)
      {
         super();
         this.config = param1;
      }
      
      [Bindable(event="connectionChanged")]
      public function get activeConnection() : ConnectionContext
      {
         return this._activeConnection;
      }
      
      public function set activeConnection(param1:ConnectionContext) : void
      {
         if(this._activeConnection == param1)
         {
            return;
         }
         this._activeConnection = param1;
         dispatchEvent(new Event("connectionChanged"));
      }
      
      public function save() : void
      {
         this.config.save();
      }
      
      public function get autoLogin() : Object
      {
         return this.config.getProperty(AsConfig.AUTO_LOGIN);
      }
      
      public function set autoLogin(param1:Object) : void
      {
         this.config.setProperty(AsConfig.AUTO_LOGIN,param1);
         this.config.save();
      }
      
      public function get portalData() : Object
      {
         return this.config.getProperty(AsConfig.PORTAL_DATA);
      }
      
      public function set portalData(param1:Object) : void
      {
         this.config.setProperty(AsConfig.PORTAL_DATA,param1);
         this.config.save();
      }
      
      public function get gateways() : Array
      {
         return this.config.getProperty(AsConfig.GATEWAYS) as Array;
      }
      
      public function set gateways(param1:Array) : void
      {
         this.config.setProperty(AsConfig.GATEWAYS,param1);
      }
      
      public function get scenarios() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.activeGateway;
         if(!_loc1_)
         {
            return null;
         }
         for each(_loc2_ in _loc1_.users)
         {
            if(_loc2_.id == this.userId)
            {
               return _loc2_.scenarios;
            }
         }
         return null;
      }
      
      [Bindable(event="connectionChanged")]
      public function get activeGateway() : Object
      {
         var _loc1_:Object = null;
         if(!this.activeConnection || !this.activeConnection.mac)
         {
            return null;
         }
         for each(_loc1_ in this.gateways)
         {
            if(_loc1_.mac == this.activeConnection.mac)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function get isGateOutOfViewSuppressed() : Boolean
      {
         return this.config.getProperty(AsConfig.SUPPRESS_GATE_OUT_OF_VIEW) as Boolean;
      }
      
      public function set isGateOutOfViewSuppressed(param1:Boolean) : void
      {
         this.config.setProperty(AsConfig.SUPPRESS_GATE_OUT_OF_VIEW,param1);
         this.config.save();
      }
      
      public function get isGateNotResponsableSuppressed() : Boolean
      {
         return this.config.getProperty(AsConfig.SUPPRESS_GATE_NOT_RESPONSABLE) as Boolean;
      }
      
      public function set isGateNotResponsableSuppressed(param1:Boolean) : void
      {
         this.config.setProperty(AsConfig.SUPPRESS_GATE_NOT_RESPONSABLE,param1);
         this.config.save();
      }
      
      public function get showAdminChangePwd() : Boolean
      {
         return this.config.getProperty(AsConfig.SHOW_ADMIN_CHPWD) as Boolean;
      }
      
      public function set showAdminChangePwd(param1:Boolean) : void
      {
         this.config.setProperty(AsConfig.SHOW_ADMIN_CHPWD,param1);
         this.config.save();
      }
      
      public function get shownOverlays() : Array
      {
         return this.config.getProperty(AsConfig.SHOWN_OVERLAYS) as Array;
      }
      
      public function set shownOverlays(param1:Array) : void
      {
         this.config.setProperty(AsConfig.SHOWN_OVERLAYS,param1);
         this.config.save();
      }
      
      public function get acceptedTermsOfUse() : Boolean
      {
         return this.config.getProperty(AsConfig.TERMS_OF_USE_ACCEPTED) as Boolean;
      }
      
      public function set acceptedTermsOfUse(param1:Boolean) : void
      {
         this.config.setProperty(AsConfig.TERMS_OF_USE_ACCEPTED,param1);
         this.config.save();
      }
      
      public function get acceptedTermsOfPrivacy() : Boolean
      {
         return this.config.getProperty(AsConfig.TERMS_OF_PRIVACY_ACCEPTED) as Boolean;
      }
      
      public function set acceptedTermsOfPrivacy(param1:Boolean) : void
      {
         this.config.setProperty(AsConfig.TERMS_OF_PRIVACY_ACCEPTED,param1);
         this.config.save();
      }
      
      public function dispose() : void
      {
         if(this.activeLogin)
         {
            this.activeLogin.dispose();
            this.activeLogin = null;
         }
         if(this.activeConnection)
         {
            this.activeConnection.dispose();
            this.activeConnection = null;
         }
         if(this.config)
         {
            this.config.dispose();
            this.config = null;
         }
         if(this.mcpProcessor)
         {
            this.mcpProcessor.dispose();
            this.mcpProcessor = null;
         }
         this.isAdmin = false;
         this.userId = -1;
         this.username = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get mcpProcessor() : HmProcessor
      {
         return this._244878312mcpProcessor;
      }
      
      public function set mcpProcessor(param1:HmProcessor) : void
      {
         var _loc2_:Object = this._244878312mcpProcessor;
         if(_loc2_ !== param1)
         {
            this._244878312mcpProcessor = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mcpProcessor",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isAdmin() : Boolean
      {
         return this._2054074437isAdmin;
      }
      
      public function set isAdmin(param1:Boolean) : void
      {
         var _loc2_:Object = this._2054074437isAdmin;
         if(_loc2_ !== param1)
         {
            this._2054074437isAdmin = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isAdmin",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : int
      {
         return this._836030906userId;
      }
      
      public function set userId(param1:int) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
            }
         }
      }
   }
}
