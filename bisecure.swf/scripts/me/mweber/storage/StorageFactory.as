package me.mweber.storage
{
   import flash.filesystem.File;
   import me.mweber.basic.Debug;
   import me.mweber.basic.helper.ArrayHelper;
   
   public class StorageFactory
   {
       
      
      public function StorageFactory()
      {
         super();
      }
      
      public static function createStorage(param1:String) : iStorage
      {
         switch(param1)
         {
            case StorageTypes.JSON_STORAGE:
               return new JSONStorage();
            default:
               Debug.error("[StorageFactory] unknown cfg type: \'" + param1 + "\'");
               return null;
         }
      }
      
      public static function openStorage(param1:File, param2:Function = null) : iStorage
      {
         var _loc3_:iStorage = null;
         var _loc4_:Boolean = false;
         if(!param1.exists)
         {
            _loc4_ = true;
         }
         switch(true)
         {
            case ArrayHelper.in_array(param1.extension.toLowerCase(),JSONStorage.EXTENSIONS):
               _loc3_ = createStorage(StorageTypes.JSON_STORAGE);
               _loc3_.open(param1);
               break;
            default:
               Debug.error("[StorageFactory] unknown cfg extension: \'" + param1.extension + "\'");
               _loc4_ = false;
               _loc3_ = null;
         }
         if(_loc4_ && param2 != null)
         {
            param2.call(null,_loc3_);
            _loc3_.save();
         }
         return _loc3_;
      }
      
      public static function openJSONConfig(param1:Function = null) : iStorage
      {
         var _loc2_:File = File.applicationStorageDirectory.resolvePath("config." + JSONStorage.EXTENSIONS[0]);
         return openStorage(_loc2_,param1);
      }
   }
}
