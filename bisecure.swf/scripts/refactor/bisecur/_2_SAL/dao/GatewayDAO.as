package refactor.bisecur._2_SAL.dao
{
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class GatewayDAO
   {
      
      private static const TABLE_NAME:String = "Gateways";
      
      private static const SELECT_STATEMENT:String = "SELECT mac, name FROM " + TABLE_NAME;
      
      private static const INSERT_STATEMENT:String = "INSERT INTO " + TABLE_NAME + " (mac, name) VALUES (:mac, :name)";
      
      private static const UPDATE_STATEMENT:String = "UPDATE " + TABLE_NAME + " SET name=:name";
      
      private static const DELETE_STATEMENT:String = "DELETE FROM " + TABLE_NAME;
       
      
      private var database:SQLiteDatabase;
      
      public function GatewayDAO(param1:ConstructorLock#87, param2:SQLiteDatabase)
      {
         super();
         this.database = param2;
         this.createTable();
      }
      
      static function create(param1:SQLiteDatabase) : GatewayDAO
      {
         return new GatewayDAO(null,param1);
      }
      
      function createTable() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" + "       mac TEXT," + "       name TEXT" + ")");
         _loc1_.execute();
      }
      
      public function setGateway(param1:Gateway) : void
      {
         if(this.gatewayExists(param1))
         {
            this.updateGateway(param1);
            return;
         }
         var _loc2_:SQLStatement = this.database.createStatement(INSERT_STATEMENT);
         this.setParameters(_loc2_,param1);
         _loc2_.execute();
      }
      
      public function numberOfGateways() : uint
      {
         var _loc1_:SQLStatement = this.database.createStatement(SELECT_STATEMENT);
         return this.database.countResults(_loc1_);
      }
      
      public function gatewayExists(param1:Gateway) : Boolean
      {
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE mac = :mac");
         _loc2_.parameters[":mac"] = param1.mac;
         return this.database.countResults(_loc2_) > 0;
      }
      
      public function getGateway(param1:String) : Gateway
      {
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE mac = :mac");
         _loc2_.parameters[":mac"] = param1;
         _loc2_.execute();
         var _loc3_:SQLResult = _loc2_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            return this.createGateway(_loc3_.data[0]);
         }
         return null;
      }
      
      public function getGateways() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc1_:SQLStatement = this.database.createStatement(SELECT_STATEMENT);
         _loc1_.execute();
         var _loc2_:SQLResult = _loc1_.getResult();
         if(!this.database.isResultEmpty(_loc2_))
         {
            _loc3_ = [];
            for each(_loc4_ in _loc2_.data)
            {
               _loc3_.push(this.createGateway(_loc4_));
            }
            return _loc3_;
         }
         return [];
      }
      
      public function updateGateway(param1:Gateway) : Gateway
      {
         if(!this.gatewayExists(param1))
         {
            this.setGateway(param1);
            return this.getGateway(param1.mac);
         }
         var _loc2_:SQLStatement = this.database.createStatement(UPDATE_STATEMENT + " WHERE mac=:mac");
         this.setParameters(_loc2_,param1);
         _loc2_.execute();
         return this.getGateway(param1.mac);
      }
      
      public function removeGateway(param1:Gateway) : Gateway
      {
         var _loc2_:Gateway = this.getGateway(param1.mac);
         var _loc3_:SQLStatement = this.database.createStatement(DELETE_STATEMENT + " WHERE mac=:mac");
         _loc3_.parameters[":mac"] = param1.mac;
         _loc3_.execute();
         return _loc2_;
      }
      
      public function clear() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement(DELETE_STATEMENT);
         _loc1_.execute();
      }
      
      private function createGateway(param1:Object) : Gateway
      {
         var _loc2_:Gateway = new Gateway();
         _loc2_.mac = param1["mac"];
         _loc2_.name = param1["name"];
         return _loc2_;
      }
      
      private function setParameters(param1:SQLStatement, param2:Gateway) : void
      {
         param1.parameters[":mac"] = param2.mac;
         param1.parameters[":name"] = param2.name;
      }
   }
}

class ConstructorLock#87
{
    
   
   function ConstructorLock#87()
   {
      super();
   }
}
