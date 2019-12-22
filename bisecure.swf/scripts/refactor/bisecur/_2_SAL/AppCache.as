package refactor.bisecur._2_SAL
{
   import refactor.bisecur._1_APP.components.bottom_bar.BottomBar;
   import refactor.bisecur._1_APP.components.popups.Popup;
   import refactor.bisecur._1_APP.views.bootloader.Bootloader;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.net.HmProcessor;
   import refactor.bisecur._2_SAL.net.cache.groups.GatewayGroups;
   import refactor.bisecur._2_SAL.net.cache.keyValues.GatewayValues;
   import refactor.bisecur._2_SAL.net.cache.metadata.GatewayMetadata;
   import refactor.bisecur._2_SAL.net.cache.ports.GatewayPorts;
   import refactor.bisecur._2_SAL.net.cache.userRights.GatewayUserRights;
   import refactor.bisecur._2_SAL.net.cache.users.GatewayUsers;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.bisecur._5_UTIL.FlexHelper;
   import refactor.logicware._1_APP.commands.CommunicationResult;
   import refactor.logicware._1_APP.commands.LoginCommand;
   import refactor.logicware._2_SAL.ConnectionContext;
   import refactor.logicware._2_SAL.mcp.MCPBuilder;
   import refactor.logicware._2_SAL.mcp.MCPLoader;
   import refactor.logicware._2_SAL.mcp.MCPPackage;
   import refactor.logicware._3_PAL.GatewayDiscover.GatewayInfos;
   import refactor.logicware._5_UTIL.StringHelper;
   import spark.components.ViewNavigator;
   import spark.transitions.ViewTransitionBase;
   
   public class AppCache
   {
      
      private static var singleton:AppCache;
       
      
      private var _connection:ConnectionContext;
      
      private var _connectedGateway:GatewayInfos;
      
      private var _loggedInUser:User;
      
      private var _hmProcessor:HmProcessor;
      
      public function AppCache()
      {
         super();
      }
      
      public static function get sharedCache() : AppCache
      {
         if(singleton == null)
         {
            singleton = new AppCache();
         }
         return singleton;
      }
      
      [Bindable(event="none")]
      public function get connection() : ConnectionContext
      {
         return this._connection;
      }
      
      public function get loggedIn() : Boolean
      {
         return this._loggedInUser != null;
      }
      
      public function get loggedInUser() : User
      {
         return this._loggedInUser;
      }
      
      public function get connectedGateway() : GatewayInfos
      {
         return this._connectedGateway;
      }
      
      public function get hmProcessor() : HmProcessor
      {
         return this._hmProcessor;
      }
      
      public function relogin(param1:Function = null) : void
      {
         var self:AppCache = null;
         var callback:Function = param1;
         if(this.loggedInUser != null && !StringHelper.IsNullOrEmpty(this.loggedInUser.name) && !StringHelper.IsNullOrEmpty(this.loggedInUser.password) && this.connection != null)
         {
            self = this;
            new LoginCommand(this.loggedInUser,this.connection).execute(function(param1:LoginCommand, param2:String):void
            {
               var _loc3_:* = param2 == CommunicationResult.SUCCESS;
               if(_loc3_)
               {
                  login(loggedInUser,connectedGateway,connection);
               }
               CallbackHelper.callCallback(callback,[self,_loc3_]);
            });
            return;
         }
         return CallbackHelper.callCallback(callback,[this,false]);
      }
      
      public function login(param1:User, param2:GatewayInfos, param3:ConnectionContext) : void
      {
         this._connection = param3;
         this._connectedGateway = param2;
         this._loggedInUser = param1;
         this._hmProcessor = new HmProcessor(this._connection);
         GatewayGroups.instance.invalidateCache();
         GatewayValues.instance.invalidateCache();
         GatewayMetadata.instance.invalidateCache();
         GatewayPorts.instance.invalidateCache();
         GatewayUserRights.instance.invalidateCache();
         GatewayUsers.instance.invalidateCache();
         this._hmProcessor.requestTransition();
      }
      
      public function logout() : void
      {
         if(!this.loggedIn)
         {
            return;
         }
         if(this.connection && this.connection.connected)
         {
            new MCPLoader(this.connection).load(MCPBuilder.createLogout(MCPPackage.getFromPool()));
            this.connection.disconnect();
            this.finalizeLogout();
         }
         else
         {
            this.finalizeLogout();
         }
         var _loc1_:ViewNavigator = FlexHelper.getNavigator();
         _loc1_.popAll(new ViewTransitionBase());
         Bootloader.useAutoLogin = false;
         _loc1_.replaceView(Bootloader,null,null,new ViewTransitionBase());
         Popup.closeAll();
         BottomBar.username = "";
      }
      
      private function finalizeLogout() : *
      {
         if(this.connection)
         {
            this.connection.dispose();
         }
         if(this.hmProcessor)
         {
            this.hmProcessor.dispose();
         }
         this.dispose();
      }
      
      private function dispose() : void
      {
         this._connection = null;
         this._connectedGateway = null;
         this._loggedInUser = null;
      }
   }
}
