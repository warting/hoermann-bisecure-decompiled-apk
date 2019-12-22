package refactor.bisecur._2_SAL.dao
{
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class UserLoginDAO
   {
      
      private static const TABLE_NAME:String = "UsersLogin";
      
      private static const SELECT_STATEMENT:String = "SELECT id, name, password, gatewayMac FROM " + TABLE_NAME;
      
      private static const INSERT_STATEMENT:String = "INSERT INTO " + TABLE_NAME + " (id, name, password, gatewayMac) VALUES (:id,:name, :password, :gatewayMac)";
      
      private static const UPDATE_STATEMENT:String = "UPDATE " + TABLE_NAME + " SET id=:id, name=:name, password=:password";
      
      private static const DELETE_STATEMENT:String = "DELETE FROM " + TABLE_NAME;
       
      
      private var database:SQLiteDatabase;
      
      public function UserLoginDAO(param1:ConstructorLock#90, param2:SQLiteDatabase)
      {
         super();
         this.database = param2;
         this.createTable();
      }
      
      static function create(param1:SQLiteDatabase) : UserLoginDAO
      {
         return new UserLoginDAO(null,param1);
      }
      
      function createTable() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" + "       id INTEGER," + "       name TEXT," + "       password TEXT," + "       gatewayMac TEXT" + ")");
         _loc1_.execute();
      }
      
      public function setUser(param1:User) : void
      {
         if(this.userExists(param1))
         {
            this.updateUser(param1);
            return;
         }
         var _loc2_:GatewayDAO = DAOFactory.getGatewayDAO();
         _loc2_.setGateway(param1.gateway);
         var _loc3_:SQLStatement = this.database.createStatement(INSERT_STATEMENT);
         _loc3_.parameters[":id"] = param1.id;
         _loc3_.parameters[":name"] = param1.name;
         _loc3_.parameters[":password"] = param1.password;
         _loc3_.parameters[":gatewayMac"] = param1.gateway.mac;
         _loc3_.execute();
      }
      
      public function updateUser(param1:User) : void
      {
         if(!this.userExists(param1))
         {
            this.setUser(param1);
            return;
         }
         var _loc2_:GatewayDAO = DAOFactory.getGatewayDAO();
         _loc2_.updateGateway(param1.gateway);
         var _loc3_:SQLStatement = this.database.createStatement(UPDATE_STATEMENT + " WHERE gatewayMac=:gatewayMac");
         _loc3_.parameters[":id"] = param1.id;
         _loc3_.parameters[":name"] = param1.name;
         _loc3_.parameters[":password"] = param1.password;
         _loc3_.parameters[":gatewayMac"] = param1.gateway.mac;
         _loc3_.execute();
      }
      
      public function userExists(param1:User) : Boolean
      {
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE gatewayMac=:gatewayMac");
         _loc2_.parameters[":gatewayMac"] = param1.gateway.mac;
         return this.database.countResults(_loc2_) > 0;
      }
      
      public function getUserForGateway(param1:Gateway) : User
      {
         var _loc4_:User = null;
         var _loc5_:GatewayDAO = null;
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE gatewayMac=:gatewayMac");
         _loc2_.parameters[":gatewayMac"] = param1.mac;
         _loc2_.execute();
         var _loc3_:SQLResult = _loc2_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            _loc4_ = new User();
            _loc4_.id = _loc3_.data[0].id;
            _loc4_.name = _loc3_.data[0].name;
            _loc4_.password = _loc3_.data[0].password;
            _loc5_ = DAOFactory.getGatewayDAO();
            _loc4_.gateway = _loc5_.getGateway(_loc3_.data[0].gatewayMac);
            return _loc4_;
         }
         return null;
      }
      
      public function getUsers() : User
      {
         var _loc3_:User = null;
         var _loc4_:GatewayDAO = null;
         var _loc1_:SQLStatement = this.database.createStatement(SELECT_STATEMENT);
         _loc1_.execute();
         var _loc2_:SQLResult = _loc1_.getResult();
         if(!this.database.isResultEmpty(_loc2_))
         {
            _loc3_ = new User();
            _loc3_.id = _loc2_.data[0].id;
            _loc3_.name = _loc2_.data[0].name;
            _loc3_.password = _loc2_.data[0].password;
            _loc4_ = DAOFactory.getGatewayDAO();
            _loc3_.gateway = _loc4_.getGateway(_loc2_.data[0].gatewayMac);
            return _loc3_;
         }
         return null;
      }
      
      public function removeUserForGateway(param1:Gateway) : void
      {
         var _loc2_:SQLStatement = this.database.createStatement(DELETE_STATEMENT + " WHERE gatewayMac=:gatewayMac");
         _loc2_.parameters[":gatewayMac"] = param1.mac;
         _loc2_.execute();
      }
   }
}

class ConstructorLock#90
{
    
   
   function ConstructorLock#90()
   {
      super();
   }
}
