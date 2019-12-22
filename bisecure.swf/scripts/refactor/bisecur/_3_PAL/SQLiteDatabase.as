package refactor.bisecur._3_PAL
{
   import flash.data.SQLConnection;
   import flash.data.SQLMode;
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import flash.events.SQLErrorEvent;
   import flash.events.SQLEvent;
   import flash.filesystem.File;
   import flash.net.Responder;
   import refactor.logicware._5_UTIL.IDisposable;
   import refactor.logicware._5_UTIL.Log;
   
   public class SQLiteDatabase implements IDisposable
   {
      
      private static var singleton:SQLiteDatabase;
      
      public static const CONNECTION_STATE_OPEN:int = 1;
      
      public static const CONNECTION_STATE_PENDING:int = 0;
      
      public static const CONNECTION_STATE_CLOSED:int = -1;
      
      public static const STATEMENT_LAST_ID:String = "SELECT last_insert_rowid() as ID";
       
      
      private var file:File;
      
      private var connection:SQLConnection;
      
      private var _connectionState:int = -1;
      
      private var _openCallbacks:Vector.<Function>;
      
      public function SQLiteDatabase(param1:String)
      {
         this._openCallbacks = new Vector.<Function>(0);
         super();
         this.file = File.applicationStorageDirectory.resolvePath(param1);
         this.connection = new SQLConnection();
         this.connection.addEventListener(SQLEvent.OPEN,this.sqlite_openHandler);
         this.connection.addEventListener(SQLErrorEvent.ERROR,this.sqlite_errorHandler);
      }
      
      public static function get sharedDB() : SQLiteDatabase
      {
         if(singleton == null)
         {
            singleton = new SQLiteDatabase("storage.db");
         }
         return singleton;
      }
      
      public function get connectionState() : int
      {
         return this._connectionState;
      }
      
      public function addOpenCallback(param1:Function) : void
      {
         this._openCallbacks.push(param1);
      }
      
      public function open(param1:Function = null) : void
      {
         this._connectionState = CONNECTION_STATE_PENDING;
         var _loc2_:SQLiteDatabase = this;
         this.connection.open(this.file,SQLMode.CREATE);
      }
      
      public function close(param1:Function = null) : void
      {
         var callback:Function = param1;
         this._connectionState = CONNECTION_STATE_PENDING;
         this.connection.close(new Responder(function(param1:SQLEvent):void
         {
            _connectionState = CONNECTION_STATE_CLOSED;
            if(callback != null)
            {
               callback(this);
            }
         },function(param1:SQLErrorEvent):void
         {
            Log.error("Failed to clode Database connection: " + param1);
         }));
      }
      
      public function createStatement(param1:String) : SQLStatement
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.connection;
         _loc2_.text = param1;
         return _loc2_;
      }
      
      public function countResults(param1:SQLStatement) : uint
      {
         param1.execute();
         var _loc2_:SQLResult = param1.getResult();
         if(_loc2_.data)
         {
            return _loc2_.data.length;
         }
         return 0;
      }
      
      public function isResultEmpty(param1:SQLResult) : Boolean
      {
         return param1 == null || param1.data == null || param1.data.length <= 0;
      }
      
      public function dispose() : void
      {
         this.connection.removeEventListener(SQLEvent.OPEN,this.sqlite_openHandler);
         this.connection.removeEventListener(SQLErrorEvent.ERROR,this.sqlite_errorHandler);
      }
      
      private function sqlite_openHandler(param1:SQLEvent) : void
      {
         var _loc3_:Function = null;
         var _loc2_:SQLiteDatabase = this;
         for each(_loc3_ in this._openCallbacks)
         {
            if(_loc3_.length == 0)
            {
               _loc3_();
            }
            else
            {
               _loc3_(_loc2_);
            }
         }
         this._openCallbacks = new Vector.<Function>(0);
      }
      
      private function sqlite_errorHandler(param1:SQLErrorEvent) : void
      {
         Log.error("[SQLiteDatabase] SQLError: <" + param1.error.errorID + "> " + param1.error.message + "\n" + "Details: \n" + "<" + param1.error.detailID + "> " + param1.error.details + "\n" + "\t" + param1.error.operation + " / " + param1.error.detailArguments);
      }
   }
}
