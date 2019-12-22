package refactor.bisecur._2_SAL.dao
{
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import flash.utils.Dictionary;
   import refactor.bisecur._2_SAL.gatewayData.Scenario;
   import refactor.bisecur._2_SAL.gatewayData.ScenarioAction;
   import refactor.bisecur._2_SAL.gatewayData.User;
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   import refactor.logicware._5_UTIL.Log;
   import refactor.logicware._5_UTIL.StringHelper;
   
   public class ScenarioDAO
   {
      
      private static const SCENARIO_TABLE_NAME:String = "Scenarios";
      
      private static const ACTIONS_TABLE_NAME:String = "Scenario_Actions";
      
      private static const SELECT_STATEMENT:String = "SELECT s.ROWID as scenarioId, s.name, s.userId, s.gatewayMac, sa.actionId, sa.groupId, sa.actionType " + "FROM " + SCENARIO_TABLE_NAME + " as s " + "LEFT JOIN " + ACTIONS_TABLE_NAME + " as sa ON s.ROWID = sa.scenarioId";
      
      private static const INSERT_SCENARIO:String = "INSERT INTO " + SCENARIO_TABLE_NAME + " (userId, gatewayMac, name) " + "VALUES (:userId, :gatewayMac, :name)";
      
      private static const INSERT_ACTION:String = "INSERT INTO " + ACTIONS_TABLE_NAME + " (scenarioId, actionId, groupId, actionType) " + "VALUES (:scenarioId, :actionId, :groupId, :actionType)";
      
      private static const UPDATE_SCENARIO:String = "UPDATE " + SCENARIO_TABLE_NAME + " SET name=:name";
      
      private static const DELETE_SCENARIO:String = "DELETE FROM " + SCENARIO_TABLE_NAME;
      
      private static const DELETE_ACTION:String = "DELETE FROM " + ACTIONS_TABLE_NAME;
       
      
      private var database:SQLiteDatabase;
      
      public function ScenarioDAO(param1:ConstructorLock#91, param2:SQLiteDatabase)
      {
         super();
         this.database = param2;
         this.createTable();
      }
      
      static function create(param1:SQLiteDatabase) : ScenarioDAO
      {
         return new ScenarioDAO(null,param1);
      }
      
      function createTable() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + SCENARIO_TABLE_NAME + " (" + "       userId INTEGER," + "       gatewayMac TEXT," + "       name TEXT" + ")");
         _loc1_.execute();
         _loc1_ = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + ACTIONS_TABLE_NAME + " (" + "       scenarioId INTEGER," + "       groupId INTEGER," + "       actionType INTEGER," + "       actionId INTEGER" + ")");
         _loc1_.execute();
      }
      
      public function addScenario(param1:User, param2:Gateway, param3:String) : Scenario
      {
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] adding Scenario failed! (invalid user id \'" + param1.id + "\')");
            return null;
         }
         if(StringHelper.IsNullOrEmpty(param2.mac))
         {
            Log.error("[ScenarioDAO] adding Scenario failed! (invalid gateway mac \'" + param2.mac + "\')");
            return null;
         }
         var _loc4_:SQLStatement = this.database.createStatement(INSERT_SCENARIO);
         _loc4_.parameters[":userId"] = param1.id;
         _loc4_.parameters[":gatewayMac"] = param2.mac;
         _loc4_.parameters[":name"] = param3;
         _loc4_.execute();
         _loc4_ = this.database.createStatement(SQLiteDatabase.STATEMENT_LAST_ID);
         _loc4_.execute();
         var _loc5_:int = -1;
         var _loc6_:SQLResult = _loc4_.getResult();
         if(!this.database.isResultEmpty(_loc6_))
         {
            _loc5_ = _loc6_.data[0]["ID"];
         }
         if(_loc5_ < 0)
         {
            Log.error("[ScenarioDAO] adding Scenario failed! (reading back id failed)");
            return null;
         }
         return this.getScenarioById(_loc5_);
      }
      
      public function addAction(param1:Scenario, param2:uint, param3:uint, param4:uint) : Scenario
      {
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] adding device action to scenario failed! (invalid scenario id \'" + param1.id + "\')");
            return null;
         }
         if(this.scenarioHasAction(param1,param3))
         {
            Log.error("[ScenarioDAO] adding device action to scenario failed! (action already added)");
            return null;
         }
         var _loc5_:SQLStatement = this.database.createStatement(INSERT_ACTION);
         _loc5_.parameters[":scenarioId"] = param1.id;
         _loc5_.parameters[":actionId"] = param3;
         _loc5_.parameters[":groupId"] = param2;
         _loc5_.parameters[":actionType"] = param4;
         _loc5_.execute();
         var _loc6_:ScenarioAction = new ScenarioAction();
         _loc6_.deviceAction = param3;
         _loc6_.groupId = param2;
         _loc6_.actionType = param4;
         param1.actions.push(_loc6_);
         return param1;
      }
      
      public function getScenariosForUser(param1:User, param2:Gateway) : Array
      {
         var _loc8_:Scenario = null;
         var _loc9_:Object = null;
         var _loc10_:Scenario = null;
         var _loc11_:ScenarioAction = null;
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] reading Scenario failed! (invalid user id \'" + param1.id + "\')");
            return null;
         }
         if(StringHelper.IsNullOrEmpty(param2.mac))
         {
            Log.error("[ScenarioDAO] reading Scenario failed! (invalid gateway mac \'" + param2.mac + "\')");
            return null;
         }
         var _loc3_:* = SELECT_STATEMENT + " WHERE s.userId=:userId AND s.gatewayMac=:gatewayMac";
         var _loc4_:SQLStatement = this.database.createStatement(_loc3_);
         _loc4_.parameters[":userId"] = param1.id;
         _loc4_.parameters[":gatewayMac"] = param2.mac;
         _loc4_.execute();
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:SQLResult = _loc4_.getResult();
         if(!this.database.isResultEmpty(_loc6_))
         {
            for each(_loc9_ in _loc6_.data)
            {
               if(_loc5_[_loc9_["scenarioId"]] === undefined)
               {
                  _loc5_[_loc9_["scenarioId"]] = this.createScenario(_loc9_);
               }
               _loc10_ = _loc5_[_loc9_["scenarioId"]];
               if(_loc10_.actions == null)
               {
                  _loc10_.actions = [];
               }
               _loc11_ = new ScenarioAction();
               _loc11_.groupId = _loc9_["groupId"];
               _loc11_.deviceAction = _loc9_["actionId"];
               _loc11_.actionType = _loc9_["actionType"];
               _loc10_.actions.push(_loc11_);
            }
         }
         var _loc7_:Array = [];
         for each(_loc8_ in _loc5_)
         {
            _loc7_.push(_loc8_);
         }
         return _loc7_;
      }
      
      public function getScenarios() : Array
      {
         var _loc5_:Scenario = null;
         var _loc6_:Object = null;
         var _loc7_:Scenario = null;
         var _loc8_:ScenarioAction = null;
         var _loc1_:SQLStatement = this.database.createStatement(SELECT_STATEMENT);
         _loc1_.execute();
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:SQLResult = _loc1_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            for each(_loc6_ in _loc3_.data)
            {
               if(_loc2_[_loc6_["scenarioId"]] === undefined)
               {
                  _loc2_[_loc6_["scenarioId"]] = this.createScenario(_loc6_);
               }
               _loc7_ = _loc2_[_loc6_["scenarioId"]];
               if(_loc7_.actions == null)
               {
                  _loc7_.actions = [];
               }
               _loc8_ = new ScenarioAction();
               _loc8_.groupId = _loc6_["groupId"];
               _loc8_.deviceAction = _loc6_["actionId"];
               _loc8_.actionType = _loc6_["actionType"];
               _loc7_.actions.push(_loc8_);
            }
         }
         var _loc4_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            _loc4_.push(_loc5_);
         }
         return _loc4_;
      }
      
      public function getScenarioById(param1:uint) : Scenario
      {
         var _loc4_:Scenario = null;
         var _loc5_:Object = null;
         var _loc6_:ScenarioAction = null;
         var _loc2_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE s.rowid=:scenarioId");
         _loc2_.parameters[":scenarioId"] = param1;
         _loc2_.execute();
         var _loc3_:SQLResult = _loc2_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            _loc4_ = this.createScenario(_loc3_.data[0]);
            if(_loc4_.actions == null)
            {
               _loc4_.actions = [];
            }
            for each(_loc5_ in _loc3_.data)
            {
               if(_loc5_["groupId"] != null)
               {
                  _loc6_ = new ScenarioAction();
                  _loc6_.groupId = _loc5_["groupId"];
                  _loc6_.deviceAction = _loc5_["actionId"];
                  _loc6_.actionType = _loc5_["actionType"];
                  _loc4_.actions.push(_loc6_);
               }
            }
            return _loc4_;
         }
         return null;
      }
      
      public function scenarioHasAction(param1:Scenario, param2:uint) : Boolean
      {
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] Finding action for scenario failed! (invalid scenario id \'" + param1.id + "\')");
            return false;
         }
         var _loc3_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE sa.scenarioId = :scenarioId AND sa.actionId = :actionId");
         _loc3_.parameters[":scenarioId"] = param1.id;
         _loc3_.parameters[":actionId"] = param2;
         return this.database.countResults(_loc3_) > 0;
      }
      
      public function upadateScenarioName(param1:Scenario, param2:String) : Scenario
      {
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] updating scenario failed! (invalid scenario id \'" + param1.id + "\')");
            return null;
         }
         var _loc3_:SQLStatement = this.database.createStatement(UPDATE_SCENARIO + " WHERE rowid=:scenarioId");
         _loc3_.parameters[":scenarioId"] = param1.id;
         _loc3_.parameters[":name"] = param2;
         _loc3_.execute();
         param1.name = param2;
         return param1;
      }
      
      public function removeScenario(param1:Scenario) : Boolean
      {
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] deleting scenario failed! (invalid scenario id \'" + param1.id + "\')");
            return false;
         }
         var _loc2_:SQLStatement = this.database.createStatement(DELETE_SCENARIO + " WHERE rowid=:scenarioId");
         _loc2_.parameters[":scenarioId"] = param1.id;
         _loc2_.execute();
         _loc2_ = this.database.createStatement(DELETE_ACTION + " WHERE scenarioId=:scenarioId");
         _loc2_.parameters[":scenarioId"] = param1.id;
         _loc2_.execute();
         return true;
      }
      
      public function removeActionFromAll(param1:uint) : void
      {
         var _loc2_:SQLStatement = this.database.createStatement(DELETE_ACTION + " WHERE actionId=:actionId");
         _loc2_.parameters[":actionId"] = param1;
         _loc2_.execute();
      }
      
      public function removeActionFromScenario(param1:Scenario, param2:uint) : Scenario
      {
         var _loc4_:int = 0;
         if(param1.id < 0)
         {
            Log.error("[ScenarioDAO] deleting scenario failed! (invalid scenario id \'" + param1.id + "\')");
            return null;
         }
         var _loc3_:SQLStatement = this.database.createStatement(DELETE_ACTION + " WHERE scenarioId=:scenarioId AND actionId=:actionId");
         _loc3_.parameters[":scenarioId"] = param1.id;
         _loc3_.parameters[":actionId"] = param2;
         _loc3_.execute();
         if(param1.actions != null)
         {
            _loc4_ = param1.actions.indexOf(param2);
            if(_loc4_ >= 0)
            {
               param1.actions.splice(_loc4_,1);
            }
         }
         return param1;
      }
      
      public function clear() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement(DELETE_ACTION);
         _loc1_.execute();
         _loc1_ = this.database.createStatement(DELETE_SCENARIO);
         _loc1_.execute();
      }
      
      private function createScenario(param1:Object) : Scenario
      {
         var _loc2_:Scenario = new Scenario(param1["userId"],param1["gatewayMac"]);
         _loc2_.id = param1["scenarioId"];
         _loc2_.name = param1["name"];
         _loc2_.userId = param1["userId"];
         _loc2_.gatewayMac = param1["gatewayMac"];
         return _loc2_;
      }
   }
}

class ConstructorLock#91
{
    
   
   function ConstructorLock#91()
   {
      super();
   }
}
