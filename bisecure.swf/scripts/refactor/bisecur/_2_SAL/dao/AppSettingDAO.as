package refactor.bisecur._2_SAL.dao
{
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import refactor.bisecur._2_SAL.portal.PortalCredentials;
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class AppSettingDAO
   {
      
      private static const TABLE_NAME:String = "AppSettings";
      
      private static const SELECT_STATEMENT:String = "SELECT key, value FROM " + TABLE_NAME;
      
      private static const INSERT_STATEMENT:String = "INSERT INTO " + TABLE_NAME + " (key, value) VALUES (:key, :value)";
      
      private static const UPDATE_STATEMENT:String = "UPDATE " + TABLE_NAME + " SET value=:value";
      
      private static const DELETE_STATEMENT:String = "DELETE FROM " + TABLE_NAME;
      
      private static const KEY_CONFIG_VERSION:String = "config_version";
      
      private static const KEY_PORTAL_ID:String = "portal_clientId";
      
      private static const KEY_PORTAL_PWD:String = "portal_pwd";
      
      private static const KEY_TERMS_ACCEPTED:String = "terms_accepted";
      
      private static const KEY_DEFAULT_GATEWAY:String = "default_gateway";
      
      private static const KEY_SUPPRESS_GATE_OUT_OF_VIEW:String = "suppress_gate_out_of_view";
      
      private static const KEY_SUPPRESS_GATE_NOT_RESPONSIBLE:String = "suppress_gate_not_responsible";
      
      private static const KEY_HELP_OVERLAY_SHOWN:String = "help_overlay_shown";
       
      
      private var database:SQLiteDatabase;
      
      public function AppSettingDAO(param1:ConstructorLock#88, param2:SQLiteDatabase)
      {
         super();
         this.database = param2;
         this.createTable();
      }
      
      static function create(param1:SQLiteDatabase) : AppSettingDAO
      {
         return new AppSettingDAO(null,param1);
      }
      
      function createTable() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" + "       key TEXT," + "       value TEXT" + ")");
         _loc1_.execute();
      }
      
      public function getConfigVersion() : int
      {
         return parseInt(this.getSetting(KEY_CONFIG_VERSION));
      }
      
      public function setConfigVersion(param1:int) : void
      {
         this.setSetting(KEY_CONFIG_VERSION,param1.toString());
      }
      
      public function getPortalCredentials() : PortalCredentials
      {
         var _loc1_:PortalCredentials = new PortalCredentials();
         _loc1_.clientId = this.getSetting(KEY_PORTAL_ID);
         _loc1_.password = this.getSetting(KEY_PORTAL_PWD);
         return _loc1_;
      }
      
      public function setPortalCredentials(param1:String, param2:String) : void
      {
         this.setSetting(KEY_PORTAL_ID,param1);
         this.setSetting(KEY_PORTAL_PWD,param2);
      }
      
      public function getTermsAccepted() : Boolean
      {
         var _loc1_:String = this.getSetting(KEY_TERMS_ACCEPTED);
         return _loc1_ == "TRUE";
      }
      
      public function setTermsAccepted() : void
      {
         this.setSetting(KEY_TERMS_ACCEPTED,"TRUE");
      }
      
      public function getDefaultGateway() : Gateway
      {
         var _loc1_:String = this.getSetting(KEY_DEFAULT_GATEWAY);
         if(_loc1_ == null || _loc1_ == "NULL")
         {
            return null;
         }
         var _loc2_:GatewayDAO = DAOFactory.getGatewayDAO();
         return _loc2_.getGateway(_loc1_);
      }
      
      public function setDefaultGateway(param1:Gateway) : void
      {
         var _loc2_:String = param1 != null?param1.mac:"NULL";
         this.setSetting(KEY_DEFAULT_GATEWAY,_loc2_);
      }
      
      public function getSuppressGateOutOfView() : Boolean
      {
         var _loc1_:String = this.getSetting(KEY_SUPPRESS_GATE_OUT_OF_VIEW);
         return _loc1_ == "TRUE";
      }
      
      public function setSuppressGateOutOfView(param1:Boolean) : void
      {
         var _loc2_:String = !!param1?"TRUE":"FALSE";
         this.setSetting(KEY_SUPPRESS_GATE_OUT_OF_VIEW,_loc2_);
      }
      
      public function getSuppressGateNotResponsible() : Boolean
      {
         var _loc1_:String = this.getSetting(KEY_SUPPRESS_GATE_NOT_RESPONSIBLE);
         return _loc1_ == "TRUE";
      }
      
      public function setSuppressGateNotResponsible(param1:Boolean) : void
      {
         var _loc2_:String = !!param1?"TRUE":"FALSE";
         this.setSetting(KEY_SUPPRESS_GATE_NOT_RESPONSIBLE,_loc2_);
      }
      
      public function getHelpOverlayShown() : Boolean
      {
         var _loc1_:String = this.getSetting(KEY_HELP_OVERLAY_SHOWN);
         return _loc1_ == "TRUE";
      }
      
      public function setHelpOverlayShown(param1:Boolean) : void
      {
         var _loc2_:String = !!param1?"TRUE":"FALSE";
         this.setSetting(KEY_HELP_OVERLAY_SHOWN,_loc2_);
      }
      
      public function clear() : void
      {
         this.database.createStatement(DELETE_STATEMENT).execute();
      }
      
      private function getSetting(param1:String) : String
      {
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE key=:key");
         _loc2_.parameters[":key"] = param1;
         _loc2_.execute();
         var _loc3_:SQLResult = _loc2_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            return _loc3_.data[0].value;
         }
         return null;
      }
      
      private function setSetting(param1:String, param2:String) : void
      {
         if(this.hasSetting(param1))
         {
            this.updateSetting(param1,param2);
            return;
         }
         var _loc3_:SQLStatement = this.database.createStatement(INSERT_STATEMENT);
         _loc3_.parameters[":key"] = param1;
         _loc3_.parameters[":value"] = param2;
         _loc3_.execute();
      }
      
      private function updateSetting(param1:String, param2:String) : void
      {
         if(!this.hasSetting(param1))
         {
            this.setSetting(param1,param2);
            return;
         }
         var _loc3_:SQLStatement = this.database.createStatement(UPDATE_STATEMENT + " WHERE key=:key");
         _loc3_.parameters[":key"] = param1;
         _loc3_.parameters[":value"] = param2;
         _loc3_.execute();
      }
      
      private function hasSetting(param1:String) : Boolean
      {
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE key=:key");
         _loc2_.parameters[":key"] = param1;
         _loc2_.execute();
         var _loc3_:SQLResult = _loc2_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            return true;
         }
         return false;
      }
   }
}

class ConstructorLock#88
{
    
   
   function ConstructorLock#88()
   {
      super();
   }
}
