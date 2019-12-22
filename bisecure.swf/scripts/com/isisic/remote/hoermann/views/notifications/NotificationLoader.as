package com.isisic.remote.hoermann.views.notifications
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.helper.ArrayHelper;
   import com.isisic.remote.hoermann.global.helper.Lang;
   import com.isisic.remote.lw.Debug;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import me.mweber.basic.helper.ApplicationHelper;
   import me.mweber.storage.StorageFactory;
   import me.mweber.storage.iStorage;
   import mx.utils.StringUtil;
   
   public class NotificationLoader
   {
      
      private static const REQUEST_URI:String = "http://hoe-ast.de/BisecurNotifications/?version={0}&platform={1}&portalId={2}&dataType=json&action={3}&lang={4}";
      
      private static const NOTIFICATION_CACHE:File = File.applicationStorageDirectory.resolvePath("notifications.jcache");
      
      private static var singleton:NotificationLoader = null;
       
      
      public var notifications:Array;
      
      public var seenNotifications:Array;
      
      public function NotificationLoader()
      {
         super();
         if(Features.presenterVersion)
         {
            this.notifications = [];
            this.seenNotifications = [];
            return;
         }
         this.loadCache();
      }
      
      public static function get instance() : NotificationLoader
      {
         if(singleton == null)
         {
            singleton = new NotificationLoader();
         }
         return singleton;
      }
      
      public function update(param1:Function = null) : void
      {
         var loaderComplete:Function = null;
         var loader:URLLoader = null;
         var callback:Function = param1;
         if(Features.presenterVersion)
         {
            return;
         }
         loader = new URLLoader();
         var request:URLRequest = new URLRequest(this.requestURI);
         loader.addEventListener(Event.COMPLETE,loaderComplete = function(param1:Event):void
         {
            var data:* = undefined;
            var e:Event = param1;
            loader.removeEventListener(Event.COMPLETE,loaderComplete);
            try
            {
               data = JSON.parse(loader.data);
               notifications = data["notifications"];
               writeCache();
               if(callback != null)
               {
                  callback.call();
               }
               return;
            }
            catch(error:Error)
            {
               Debug.error("[NotificationCenter] can not parse JSON: " + error + "\n" + loader.data);
               if(callback != null)
               {
                  callback.call();
               }
               return;
            }
         });
         loader.load(request);
      }
      
      private function get requestURI() : String
      {
         var _loc1_:String = ApplicationHelper.applicationVersion();
         var _loc2_:String = ApplicationHelper.currentOS();
         var _loc3_:String = "none";
         if(HoermannRemote.appData != null && HoermannRemote.appData.portalData != null && HoermannRemote.appData.portalData.deviceId != null && HoermannRemote.appData.portalData.deviceId != "")
         {
            _loc3_ = HoermannRemote.appData.portalData.deviceId;
         }
         return StringUtil.substitute(REQUEST_URI,_loc1_,_loc2_,_loc3_,"getList",Lang.preferedLocale);
      }
      
      private function loadCache() : void
      {
         var _loc2_:int = 0;
         var _loc1_:iStorage = StorageFactory.openStorage(NOTIFICATION_CACHE);
         if(_loc1_.getArray("notifications") == null)
         {
            _loc1_.setArray("notifications",[]);
         }
         if(_loc1_.getArray("seen") == null)
         {
            _loc1_.setArray("seen",[]);
         }
         this.notifications = _loc1_.getArray("notifications");
         this.seenNotifications = [];
         for each(_loc2_ in _loc1_.getArray("seen"))
         {
            this.seenNotifications.push(ArrayHelper.findByProperty("id",_loc2_,this.notifications));
         }
         _loc1_.close();
      }
      
      private function writeCache() : void
      {
         var _loc3_:Object = null;
         var _loc1_:iStorage = StorageFactory.openStorage(NOTIFICATION_CACHE);
         _loc1_.setArray("notifications",this.notifications);
         var _loc2_:Array = [];
         for each(_loc3_ in this.seenNotifications)
         {
            if(ArrayHelper.property_in_array("id",_loc3_.id,this.notifications))
            {
               _loc2_.push(_loc3_.id);
            }
            else
            {
               Debug.info("[NotificationLoader] Dropping seen notification (seems deleted): \n" + JSON.stringify(_loc3_,null,4));
            }
         }
         _loc1_.setArray("seen",_loc2_);
         _loc1_.close();
      }
   }
}
