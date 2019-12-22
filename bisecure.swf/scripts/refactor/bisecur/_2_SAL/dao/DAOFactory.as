package refactor.bisecur._2_SAL.dao
{
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   
   public class DAOFactory
   {
      
      private static var _gatewayInfoDAO:GatewayDAO;
      
      private static var _appSettingDAO:AppSettingDAO;
      
      private static var _gatewaySettingsDAO:GatewaySettingsDAO;
      
      private static var _userLoginDAO:UserLoginDAO;
      
      private static var _scenarioDAO:ScenarioDAO;
       
      
      public function DAOFactory()
      {
         super();
      }
      
      public static function getGatewayDAO() : GatewayDAO
      {
         if(_gatewayInfoDAO == null)
         {
            _gatewayInfoDAO = GatewayDAO.create(_getDatabase());
         }
         return _gatewayInfoDAO;
      }
      
      public static function getAppSettingDAO() : AppSettingDAO
      {
         if(_appSettingDAO == null)
         {
            _appSettingDAO = AppSettingDAO.create(_getDatabase());
         }
         return _appSettingDAO;
      }
      
      public static function getGatewaySettingsDAO() : GatewaySettingsDAO
      {
         if(_gatewaySettingsDAO == null)
         {
            _gatewaySettingsDAO = GatewaySettingsDAO.create(_getDatabase());
         }
         return _gatewaySettingsDAO;
      }
      
      public static function getUserLoginDAO() : UserLoginDAO
      {
         if(_userLoginDAO == null)
         {
            _userLoginDAO = UserLoginDAO.create(_getDatabase());
         }
         return _userLoginDAO;
      }
      
      public static function getScenarioDAO() : ScenarioDAO
      {
         if(_scenarioDAO == null)
         {
            _scenarioDAO = ScenarioDAO.create(_getDatabase());
         }
         return _scenarioDAO;
      }
      
      public static function createDAOS() : void
      {
         getGatewayDAO();
         getAppSettingDAO();
         getGatewaySettingsDAO();
         getUserLoginDAO();
      }
      
      private static function _getDatabase() : SQLiteDatabase
      {
         var _loc1_:SQLiteDatabase = SQLiteDatabase.sharedDB;
         if(_loc1_.connectionState == SQLiteDatabase.CONNECTION_STATE_CLOSED)
         {
            _loc1_.open();
         }
         return _loc1_;
      }
   }
}

class ConstructorLock#986
{
    
   
   function ConstructorLock#986()
   {
      super();
   }
}
