package com.isisic.remote.hoermann.global
{
   import flash.filesystem.File;
   import me.mweber.basic.helper.DateHelper;
   import me.mweber.storage.StorageFactory;
   import me.mweber.storage.iStorage;
   import mx.utils.ObjectUtil;
   
   public class UserDataStorage
   {
      
      private static var singleton:UserDataStorage;
      
      protected static const FILE:File = File.applicationStorageDirectory.resolvePath("usage.json");
       
      
      private var viewActions:Object;
      
      private var appActions:Object;
      
      private var actors:Object;
      
      private var portRequests:Object;
      
      private var storage:iStorage;
      
      public function UserDataStorage(param1:SingletonEnforcer#92)
      {
         var enforcer:SingletonEnforcer = param1;
         super();
         this.storage = StorageFactory.openStorage(FILE,function(param1:iStorage):void
         {
            param1.setProperty("data",new Object());
         });
         this.load();
      }
      
      public static function get currentStorage() : UserDataStorage
      {
         if(singleton == null)
         {
            singleton = new UserDataStorage(null);
         }
         return singleton;
      }
      
      public function save() : void
      {
         var _loc1_:Object = new Object();
         _loc1_["viewActions"] = this.viewActions;
         _loc1_["appActions"] = this.appActions;
         _loc1_["actors"] = this.actors;
         _loc1_["portRequests"] = this.portRequests;
         this.storage.setProperty("data",_loc1_);
         this.storage.save();
      }
      
      public function load() : void
      {
         var _loc1_:Object = this.storage.getProperty("data");
         if(_loc1_ != null)
         {
            this.viewActions = _loc1_["viewActions"] != null?_loc1_["viewActions"]:new Object();
            this.appActions = _loc1_["appActions"] != null?_loc1_["appActions"]:new Object();
            this.actors = _loc1_["actors"] != null?_loc1_["actors"]:new Object();
            this.portRequests = _loc1_["portRequests"] != null?_loc1_["portRequests"]:new Object();
         }
         else
         {
            this.viewActions = new Object();
            this.appActions = new Object();
            this.actors = new Object();
            this.portRequests = new Object();
         }
      }
      
      public function viewOpened(param1:String) : void
      {
         this.setViewAction("open",param1);
      }
      
      public function viewClosed(param1:String) : void
      {
         this.setViewAction("close",param1);
      }
      
      protected function setViewAction(param1:String, param2:String) : void
      {
         if(this.viewActions[param1] == null)
         {
            this.viewActions[param1] = new Object();
         }
         if(this.viewActions[param1][param2] == null)
         {
            this.viewActions[param1][param2] = 1;
         }
         else
         {
            this.viewActions[param1][param2] = this.viewActions[param1][param2] + 1;
         }
         this.storage.save();
      }
      
      public function appActivated() : void
      {
         this.setAppAction("activate");
      }
      
      public function appDeactivated() : void
      {
         this.setAppAction("deactivate");
      }
      
      protected function setAppAction(param1:String) : void
      {
         var _loc2_:Date = DateHelper.roundToMinutes(new Date(),15);
         var _loc3_:String = _loc2_.hours + ":" + _loc2_.minutes;
         if(this.appActions[param1] == null)
         {
            this.appActions[param1] = new Object();
         }
         if(this.appActions[param1][_loc3_] == null)
         {
            this.appActions[param1][_loc3_] = 1;
         }
         else
         {
            this.appActions[param1][_loc3_] = this.appActions[param1][_loc3_] + 1;
         }
         this.storage.save();
      }
      
      public function setActors(param1:Array) : void
      {
         var _loc2_:Object = null;
         param1 = ObjectUtil.clone(param1) as Array;
         for each(_loc2_ in param1)
         {
            delete _loc2_.state;
            delete _loc2_.stateValue;
         }
         this.actors = param1;
         this.storage.save();
      }
      
      public function setPortRequest(param1:Object, param2:Object) : void
      {
      }
   }
}

class SingletonEnforcer#92
{
    
   
   function SingletonEnforcer#92()
   {
      super();
   }
}
