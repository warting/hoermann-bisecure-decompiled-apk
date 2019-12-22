package refactor.bisecur._2_SAL.appUpgrades.upgrades
{
   import com.isisic.remote.hoermann.global.cfg.AsConfig;
   import com.isisic.remote.hoermann.global.cfg.JSONConfig;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import refactor.bisecur._1_APP.components.popups.ErrorBox;
   import refactor.bisecur._2_SAL.appUpgrades.base.IUpgradeCommand;
   import refactor.bisecur._2_SAL.dao.AppSettingDAO;
   import refactor.bisecur._2_SAL.dao.DAOFactory;
   import refactor.bisecur._2_SAL.dao.GatewayDAO;
   import refactor.bisecur._2_SAL.dao.GatewaySettingsDAO;
   import refactor.bisecur._2_SAL.dao.ScenarioDAO;
   import refactor.bisecur._2_SAL.dao.UserLoginDAO;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._2_SAL.portal.PortalCredentials;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._5_UTIL.Log;
   
   public class Version_1_3_0 implements IUpgradeCommand
   {
      
      private static const KEY_PORTAL_CLIENT_ID:String = "deviceId";
      
      private static const KEY_PORTAL_PASSWORD:String = "password";
      
      private static const KEY_AUTO_LOGIN_USER:String = "username";
      
      private static const KEY_AUTO_LOGIN_PASSWORD:String = "password";
      
      private static const KEY_AUTO_LOGIN_DEFAULT_GATEWAY:String = "mac";
      
      private static const KEY_GATEWAY_NAME:String = "name";
      
      private static const KEY_GATEWAY_MAC:String = "mac";
      
      private static const KEY_GATEWAY_DEFAULT_LOGIN_CHANGED:String = "adminPwdChanged";
      
      private static const KEY_GATEWAY_USER_LOGIN_ID:String = "lastUser";
      
      private static const KEY_GATEWAY_USER_DATA:String = "users";
      
      private static const KEY_GATEWAY_USER_DATA_ID:String = "id";
      
      private static const KEY_GATEWAY_USER_DATA_NAME:String = "name";
      
      private static const KEY_GATEWAY_USER_DATA_PASSWORD:String = "password";
      
      private static const KEY_GATEWAY_USER_DATA_TMP_PASSWORD:String = "tmpPwd";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS:String = "scenarios";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS_NAME:String = "name";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS:String = "actions";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_GROUP_ID:String = "groupId";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_ACTION_ID:String = "portId";
      
      private static const KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_ACTION_TYPE:String = "portType";
      
      private static const LEGACY_CONFIG_EXAMPLE:Object = {
         "TERMS_OF_PRIVACY_ACCEPTED":true,
         "SUPPRESS_GATE_OUT_OF_VIEW":true,
         "CONFIG_VERSION":8,
         "SUPPRESS_GATE_NOT_RESPONSABLE":true,
         "GATEWAYS":[{
            "isPortal":false,
            "mac":"D88039BD47D8",
            "available":false,
            "localIp":"192.168.201.53",
            "name":"BiSecur Gateway",
            "localPort":4000,
            "lastUser":2,
            "adminPwdChanged":true,
            "host":"192.168.201.53",
            "users":[{
               "scenarios":[{
                  "name":"Nach hause kommen",
                  "actions":[{
                     "groupId":0,
                     "portId":0,
                     "portType":3
                  },{
                     "groupId":1,
                     "portId":1,
                     "portType":1
                  }]
               },{
                  "name":"Zuhause verlassen",
                  "actions":[{
                     "groupId":0,
                     "portId":0,
                     "portType":3
                  },{
                     "groupId":1,
                     "portId":1,
                     "portType":1
                  }]
               }],
               "id":0,
               "password":null,
               "name":"admin",
               "tmpPwd":"1234"
            },{
               "scenarios":[{
                  "name":"Gast Funktion",
                  "actions":[{
                     "groupId":0,
                     "portId":0,
                     "portType":3
                  }]
               },{
                  "name":"Anderes Szenario",
                  "actions":[{
                     "groupId":1,
                     "portId":2,
                     "portType":8
                  },{
                     "groupId":0,
                     "portId":0,
                     "portType":3
                  }]
               }],
               "id":1,
               "password":null,
               "name":"gast",
               "tmpPwd":"1234"
            },{
               "scenarios":[{
                  "name":"Garten Aus!",
                  "actions":[{
                     "groupId":0,
                     "portId":0,
                     "portType":3
                  }]
               }],
               "id":2,
               "password":null,
               "name":"gärtner",
               "tmpPwd":"1234"
            }],
            "port":4000
         },{
            "isPortal":false,
            "mac":"0004A3C9FB50",
            "available":false,
            "localIp":null,
            "name":null,
            "localPort":0,
            "lastUser":0,
            "adminPwdChanged":false,
            "host":null,
            "users":null,
            "port":0
         },{
            "isPortal":false,
            "mac":"0004A3F43334",
            "available":false,
            "localIp":null,
            "name":"Gateway 0004A3F43334",
            "localPort":0,
            "lastUser":0,
            "adminPwdChanged":false,
            "host":null,
            "users":null,
            "port":0
         }],
         "SHOWN_OVERLAYS":["com.isisic.remote.hoermann.views.gateways::GatewayScreen"],
         "PORTAL_DATA":{
            "deviceId":"1E6925001445",
            "username":"",
            "password":"00Home"
         },
         "TERMS_OF_USE_ACCEPTED":true
      };
       
      
      private var appSettings:AppSettingDAO;
      
      private var gatewayDao:GatewayDAO;
      
      private var gatewaySettings:GatewaySettingsDAO;
      
      private var scenarioDao:ScenarioDAO;
      
      private var userLogins:UserLoginDAO;
      
      public function Version_1_3_0()
      {
         super();
      }
      
      public function execute() : void
      {
         var stream:FileStream = null;
         var cfgString:String = null;
         var cfgObject:Object = null;
         var errorBox:ErrorBox = null;
         if(JSONConfig.CONFIG_FILE.exists)
         {
            this.loadDAOs();
            try
            {
               stream = new FileStream();
               stream.open(JSONConfig.CONFIG_FILE,FileMode.READ);
               cfgString = stream.readUTFBytes(stream.bytesAvailable);
               stream.close();
               cfgObject = JSON.parse(cfgString);
               this.writePopupSettings(cfgObject);
               this.writeTermsAccepted(cfgObject);
               this.writeConfigVersion(cfgObject);
               this.writePortalData(cfgObject);
               this.writeGateways(cfgObject);
               this.writeAutoLogin(cfgObject);
               JSONConfig.CONFIG_FILE.deleteFile();
               return;
            }
            catch(e:Error)
            {
               Log.error("[Version_1_3_0] Failed to load outdated config! " + e);
               errorBox = ErrorBox.sharedBox;
               errorBox.title = "Parsing Error";
               errorBox.contentText = e.message + "\n" + e.getStackTrace();
               errorBox.open(null);
               return;
            }
         }
      }
      
      private function loadDAOs() : void
      {
         this.appSettings = DAOFactory.getAppSettingDAO();
         this.gatewayDao = DAOFactory.getGatewayDAO();
         this.gatewaySettings = DAOFactory.getGatewaySettingsDAO();
         this.scenarioDao = DAOFactory.getScenarioDAO();
         this.userLogins = DAOFactory.getUserLoginDAO();
      }
      
      private function writeTermsAccepted(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(param1.hasOwnProperty(AsConfig.TERMS_OF_PRIVACY_ACCEPTED))
         {
            _loc2_ = param1[AsConfig.TERMS_OF_PRIVACY_ACCEPTED];
         }
         if(param1.hasOwnProperty(AsConfig.TERMS_OF_USE_ACCEPTED))
         {
            _loc3_ = param1[AsConfig.TERMS_OF_USE_ACCEPTED];
         }
         if(_loc2_ && _loc3_)
         {
            this.appSettings.setTermsAccepted();
         }
      }
      
      private function writePopupSettings(param1:Object) : void
      {
         if(param1.hasOwnProperty(AsConfig.SUPPRESS_GATE_NOT_RESPONSABLE))
         {
            this.appSettings.setSuppressGateNotResponsible(param1[AsConfig.SUPPRESS_GATE_NOT_RESPONSABLE]);
         }
         if(param1.hasOwnProperty(AsConfig.SUPPRESS_GATE_OUT_OF_VIEW))
         {
            this.appSettings.setSuppressGateOutOfView(param1[AsConfig.SUPPRESS_GATE_OUT_OF_VIEW]);
         }
      }
      
      private function writeConfigVersion(param1:Object) : void
      {
         this.appSettings.setConfigVersion(9);
      }
      
      private function writePortalData(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:PortalCredentials = new PortalCredentials();
         if(param1.hasOwnProperty(AsConfig.PORTAL_DATA))
         {
            _loc3_ = param1[AsConfig.PORTAL_DATA];
            if(_loc3_ == null)
            {
               return;
            }
            if(_loc3_.hasOwnProperty(KEY_PORTAL_CLIENT_ID))
            {
               _loc2_.clientId = _loc3_[KEY_PORTAL_CLIENT_ID];
            }
            if(_loc3_.hasOwnProperty(KEY_PORTAL_PASSWORD))
            {
               _loc2_.password = _loc3_[KEY_PORTAL_PASSWORD];
            }
         }
         this.appSettings.setPortalCredentials(_loc2_.clientId,_loc2_.password);
      }
      
      private function writeAutoLogin(param1:Object) : void
      {
         var _loc5_:String = null;
         if(!param1.hasOwnProperty(AsConfig.AUTO_LOGIN))
         {
            return;
         }
         var _loc2_:Object = param1[AsConfig.AUTO_LOGIN];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Gateway = null;
         var _loc4_:User = null;
         if(_loc2_.hasOwnProperty(KEY_AUTO_LOGIN_USER) && _loc2_.hasOwnProperty(KEY_AUTO_LOGIN_PASSWORD) && _loc2_.hasOwnProperty(KEY_AUTO_LOGIN_DEFAULT_GATEWAY))
         {
            _loc5_ = _loc2_[KEY_AUTO_LOGIN_DEFAULT_GATEWAY];
            _loc3_ = this.gatewayDao.getGateway(_loc5_);
            if(_loc3_ == null)
            {
               _loc3_ = new Gateway();
               _loc3_.name = "";
               _loc3_.mac = _loc2_[KEY_AUTO_LOGIN_DEFAULT_GATEWAY];
            }
            _loc4_ = User.createByCredentials(_loc2_[KEY_AUTO_LOGIN_USER],_loc2_[KEY_AUTO_LOGIN_PASSWORD],_loc3_);
            this.userLogins.setUser(_loc4_);
            this.appSettings.setDefaultGateway(_loc3_);
         }
      }
      
      private function writeGateways(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Gateway = null;
         var _loc5_:Boolean = false;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:User = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:User = null;
         var _loc15_:Array = null;
         var _loc16_:Object = null;
         var _loc17_:String = null;
         var _loc18_:Scenario = null;
         var _loc19_:Array = null;
         var _loc20_:Object = null;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         if(!param1.hasOwnProperty(AsConfig.GATEWAYS))
         {
            return;
         }
         var _loc2_:Array = param1[AsConfig.GATEWAYS];
         if(_loc2_ == null)
         {
            return;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new Gateway();
            _loc4_.name = _loc3_[KEY_GATEWAY_NAME];
            _loc4_.mac = _loc3_[KEY_GATEWAY_MAC];
            this.gatewayDao.setGateway(_loc4_);
            _loc5_ = false;
            if(_loc3_.hasOwnProperty(KEY_GATEWAY_DEFAULT_LOGIN_CHANGED))
            {
               _loc5_ = _loc3_[KEY_GATEWAY_DEFAULT_LOGIN_CHANGED];
            }
            if(_loc5_)
            {
               this.gatewaySettings.setDefaultLoginChanged(_loc4_);
            }
            _loc6_ = [];
            if(_loc3_.hasOwnProperty(KEY_GATEWAY_USER_DATA))
            {
               _loc9_ = _loc3_[KEY_GATEWAY_USER_DATA];
               if(_loc9_ != null)
               {
                  for each(_loc10_ in _loc9_)
                  {
                     if(_loc10_ != null)
                     {
                        _loc11_ = _loc10_[KEY_GATEWAY_USER_DATA_ID];
                        _loc12_ = _loc10_[KEY_GATEWAY_USER_DATA_NAME];
                        _loc13_ = _loc10_[KEY_GATEWAY_USER_DATA_PASSWORD];
                        _loc14_ = User.createByCredentials(_loc12_,_loc13_,_loc4_);
                        _loc14_.id = _loc11_;
                        this.userLogins.setUser(_loc14_);
                        _loc6_.push(_loc14_);
                        if(_loc10_.hasOwnProperty(KEY_GATEWAY_USER_DATA_SCENARIOS))
                        {
                           _loc15_ = _loc10_[KEY_GATEWAY_USER_DATA_SCENARIOS];
                           if(_loc15_ != null)
                           {
                              for each(_loc16_ in _loc15_)
                              {
                                 _loc17_ = _loc16_[KEY_GATEWAY_USER_DATA_SCENARIOS_NAME];
                                 _loc18_ = this.scenarioDao.addScenario(_loc14_,_loc4_,_loc17_);
                                 if(_loc16_.hasOwnProperty(KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS))
                                 {
                                    _loc19_ = _loc16_[KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS];
                                    if(_loc19_ != null)
                                    {
                                       for each(_loc20_ in _loc19_)
                                       {
                                          if(_loc20_ != null)
                                          {
                                             _loc21_ = _loc20_[KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_GROUP_ID];
                                             _loc22_ = _loc20_[KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_ACTION_ID];
                                             _loc23_ = _loc20_[KEY_GATEWAY_USER_DATA_SCENARIOS_ACTIONS_ACTION_TYPE];
                                             this.scenarioDao.addAction(_loc18_,_loc21_,_loc22_,_loc23_);
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            _loc7_ = 0;
            if(_loc3_.hasOwnProperty(KEY_GATEWAY_USER_LOGIN_ID))
            {
               _loc7_ = _loc3_[KEY_GATEWAY_USER_LOGIN_ID];
            }
            for each(_loc8_ in _loc6_)
            {
               if(_loc8_.id == _loc7_)
               {
                  this.userLogins.setUser(_loc8_);
                  break;
               }
            }
         }
      }
   }
}
