package refactor.bisecur._2_SAL.dao
{
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import refactor.bisecur._3_PAL.SQLiteDatabase;
   import refactor.logicware._3_PAL.GatewayDiscover.Gateway;
   
   public class GatewaySettingsDAO
   {
      
      private static const TABLE_NAME:String = "GatewaySettings";
      
      private static const SELECT_STATEMENT:String = "SELECT key, value, mac FROM " + TABLE_NAME;
      
      private static const INSERT_STATEMENT:String = "INSERT INTO " + TABLE_NAME + " (key, value, mac) VALUES (:key, :value, :mac)";
      
      private static const UPDATE_STATEMENT:String = "UPDATE " + TABLE_NAME + " SET value=:value";
      
      private static const DELETE_STATEMENT:String = "DELETE FROM " + TABLE_NAME;
      
      private static const KEY_DEFAULT_LOGIN_CHANGED:String = "defaultLoginChanged";
       
      
      private var database:SQLiteDatabase;
      
      public function GatewaySettingsDAO(param1:ConstructorLock#85, param2:SQLiteDatabase)
      {
         super();
         this.database = param2;
         this.createTable();
      }
      
      static function create(param1:SQLiteDatabase) : GatewaySettingsDAO
      {
         return new GatewaySettingsDAO(null,param1);
      }
      
      function createTable() : void
      {
         var _loc1_:SQLStatement = this.database.createStatement("CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " (" + "       key TEXT," + "       value TEXT," + "       mac TEXT" + ")");
         _loc1_.execute();
      }
      
      public function dump() : String
      {
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc1_:SQLStatement = this.database.createStatement(SELECT_STATEMENT);
         _loc1_.execute();
         var _loc2_:* = "";
         var _loc3_:SQLResult = _loc1_.getResult();
         if(!this.database.isResultEmpty(_loc3_))
         {
            for each(_loc4_ in _loc3_.data)
            {
               _loc2_ = _loc2_ + "[dataset: ";
               for(_loc5_ in _loc4_)
               {
                  _loc2_ = _loc2_ + (_loc5_ + "=\'" + _loc4_[_loc5_] + " ");
               }
               _loc2_ = _loc2_ + "]\n";
            }
         }
         return _loc2_;
      }
      
      public function getDefaultLoginChanged(param1:Gateway) : Boolean
      {
         var _loc2_:String = this.getSetting(KEY_DEFAULT_LOGIN_CHANGED,param1.mac);
         return _loc2_ == "TRUE";
      }
      
      public function setDefaultLoginChanged(param1:Gateway) : void
      {
         this.setSetting(KEY_DEFAULT_LOGIN_CHANGED,"TRUE",param1.mac);
      }
      
      public function clearSettingsForGateway(param1:Gateway) : void
      {
         var _loc2_:SQLStatement = this.database.createStatement(DELETE_STATEMENT + " WHERE mac=:mac");
         _loc2_.parameters[":mac"] = param1.mac;
         _loc2_.execute();
      }
      
      public function clear() : void
      {
         this.database.createStatement(DELETE_STATEMENT).execute();
      }
      
      private function getSetting(param1:String, param2:String) : String
      {
         var _loc3_:SQLStatement = this.database.createStatement(SELECT_STATEMENT + " WHERE key=:key AND mac=:mac");
         _loc3_.parameters[":key"] = param1;
         _loc3_.parameters[":mac"] = param2;
         _loc3_.execute();
         var _loc4_:SQLResult = _loc3_.getResult();
         if(!this.database.isResultEmpty(_loc4_))
         {
            return _loc4_.data[0].value;
         }
         return null;
      }
      
      private function setSetting(param1:String, param2:String, param3:String) : void
      {
         if(this.hasSetting(param1,param3))
         {
            this.updateSetting(param1,param2,param3);
            return;
         }
         var _loc4_:SQLStatement = this.database.createStatement(INSERT_STATEMENT);
         _loc4_.parameters[":key"] = param1;
         _loc4_.parameters[":value"] = param2;
         _loc4_.parameters[":mac"] = param3;
         _loc4_.execute();
      }
      
      private function updateSetting(param1:String, param2:String, param3:String) : void
      {
         if(!this.hasSetting(param1,param3))
         {
            this.setSetting(param1,param2,param3);
            return;
         }
         var _loc4_:SQLStatement = this.database.createStatement(UPDATE_STATEMENT + " WHERE key=:key AND mac=:mac");
         _loc4_.parameters[":key"] = param1;
         _loc4_.parameters[":value"] = param2;
         _loc4_.parameters[":mac"] = param3;
         _loc4_.execute();
      }
      
      private function hasSetting(param1:String, param2:String) : Boolean
      {
         return this.getSetting(param1,param2) != null;
      }
   }
}

class ConstructorLock#85
{
    
   
   function ConstructorLock#85()
   {
      super();
   }
}
