package refactor.bisecur._2_SAL.appUpgrades
{
   import avmplus.getQualifiedClassName;
   import flash.events.TimerEvent;
   import me.mweber.basic.AutoDisposeTimer;
   import refactor.bisecur._2_SAL.appUpgrades.base.IUpgradeCommand;
   import refactor.bisecur._2_SAL.appUpgrades.upgrades.Version_1_3_0;
   import refactor.bisecur._5_UTIL.CallbackHelper;
   import refactor.logicware._5_UTIL.Log;
   
   public class AppUpgrader
   {
      
      private static const UPGRADES:Vector.<IUpgradeCommand> = new <IUpgradeCommand>[new Version_1_3_0()];
       
      
      public function AppUpgrader(param1:ConstructorLock#50)
      {
         super();
         throw new Error("this class may not be initialized!");
      }
      
      public static function UpgradeApp(param1:Function) : void
      {
         var callback:Function = param1;
         new AutoDisposeTimer(0,function(param1:TimerEvent):void
         {
            var _loc2_:* = undefined;
            Log.info("[AppUpgrader] Starting Upgrades..");
            for each(_loc2_ in UPGRADES)
            {
               if(!UpgradeConfig.wasUpgradeExecuted(_loc2_))
               {
                  Log.info("\t[AppUpgrader] executing " + getQualifiedClassName(_loc2_));
                  _loc2_.execute();
                  UpgradeConfig.saveUpgradeExecuted(_loc2_);
               }
            }
            Log.info("[AppUpgrader] upgrade complete ");
            CallbackHelper.callCallback(callback,[]);
         }).start();
      }
   }
}

class ConstructorLock#50
{
    
   
   function ConstructorLock#50()
   {
      super();
   }
}

import avmplus.getQualifiedClassName;
import flash.filesystem.File;
import me.mweber.basic.helper.ArrayHelper;
import me.mweber.storage.StorageFactory;
import me.mweber.storage.StorageTypes;
import me.mweber.storage.iStorage;
import refactor.bisecur._2_SAL.appUpgrades.base.IUpgradeCommand;

class UpgradeConfig
{
   
   private static const UPGRADE_CONFIG:File = File.applicationStorageDirectory.resolvePath("upgrade_config.json");
   
   private static const KEY_EXECUTED_COMMANDS:String = "executedCommands";
    
   
   function UpgradeConfig()
   {
      super();
   }
   
   public static function wasUpgradeExecuted(param1:IUpgradeCommand) : Boolean
   {
      var _loc2_:iStorage = StorageFactory.createStorage(StorageTypes.JSON_STORAGE);
      _loc2_.open(UPGRADE_CONFIG);
      var _loc3_:Array = _loc2_.getArray(KEY_EXECUTED_COMMANDS);
      if(_loc3_ == null)
      {
         _loc3_ = [];
      }
      var _loc4_:Boolean = ArrayHelper.in_array(getQualifiedClassName(param1),_loc3_);
      _loc2_.close();
      return _loc4_;
   }
   
   public static function saveUpgradeExecuted(param1:IUpgradeCommand) : void
   {
      var _loc2_:iStorage = StorageFactory.createStorage(StorageTypes.JSON_STORAGE);
      _loc2_.open(UPGRADE_CONFIG);
      var _loc3_:Array = _loc2_.getArray(KEY_EXECUTED_COMMANDS);
      if(_loc3_ == null)
      {
         _loc3_ = [];
      }
      _loc3_.push(getQualifiedClassName(param1));
      _loc2_.setArray(KEY_EXECUTED_COMMANDS,_loc3_);
      _loc2_.save();
      _loc2_.close();
   }
}
