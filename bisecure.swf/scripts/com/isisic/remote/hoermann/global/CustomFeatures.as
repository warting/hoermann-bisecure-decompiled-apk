package com.isisic.remote.hoermann.global
{
   import com.isisic.remote.lw.IDisposable;
   import flash.filesystem.File;
   import me.mweber.basic.helper.ApplicationHelper;
   import me.mweber.storage.StorageFactory;
   import me.mweber.storage.iStorage;
   
   public class CustomFeatures implements IDisposable
   {
      
      private static const FEATURE_FILE:File = File.applicationStorageDirectory.resolvePath("features.jcfg");
       
      
      private var storage:iStorage;
      
      public function CustomFeatures()
      {
         super();
      }
      
      public function load() : CustomFeatures
      {
         this.storage = StorageFactory.openStorage(FEATURE_FILE,this.writeDefaults);
         var _loc1_:String = ApplicationHelper.applicationVersion();
         var _loc2_:String = this.storage.getString("appVersion");
         if(_loc1_ != _loc2_)
         {
            this.writeDefaults(this.storage);
         }
         return this;
      }
      
      public function apply() : CustomFeatures
      {
         Features.writeError = this.storage.getBoolean("writeError");
         Features.writeWarning = this.storage.getBoolean("writeWarning");
         Features.writeInfo = this.storage.getBoolean("writeInfo");
         Features.writeDebug = this.storage.getBoolean("writeDebug");
         Features.traceIn = this.storage.getBoolean("traceIn");
         Features.traceOut = this.storage.getBoolean("traceOut");
         Features.useDevPortal = this.storage.getBoolean("useDevPortal");
         Features.enableDdnsDialog = this.storage.getBoolean("enableDdnsDialog");
         Features.addDevicePortal = this.storage.getBoolean("addDevicePortal");
         Features.scenarioHotfix = this.storage.getBoolean("scenarioHotfix");
         Features.presenterVersion = this.storage.getBoolean("presenterVersion");
         Features.showChannelOnButton = this.storage.getBoolean("showChannelOnButton");
         return this;
      }
      
      public function write() : CustomFeatures
      {
         this.writeDefaults(this.storage);
         this.storage.save();
         return this;
      }
      
      public function dispose() : void
      {
         this.storage.close();
         this.storage = null;
      }
      
      private function writeDefaults(param1:iStorage) : void
      {
         param1.setString("appVersion",ApplicationHelper.applicationVersion());
         param1.setBoolean("writeError",Features.writeError);
         param1.setBoolean("writeWarning",Features.writeWarning);
         param1.setBoolean("writeInfo",Features.writeInfo);
         param1.setBoolean("writeDebug",Features.writeDebug);
         param1.setBoolean("traceIn",Features.traceIn);
         param1.setBoolean("traceOut",Features.traceOut);
         param1.setBoolean("useDevPortal",Features.useDevPortal);
         param1.setBoolean("enableDdnsDialog",Features.enableDdnsDialog);
         param1.setBoolean("addDevicePortal",Features.addDevicePortal);
         param1.setBoolean("scenarioHotfix",Features.scenarioHotfix);
         param1.setBoolean("presenterVersion",Features.presenterVersion);
         param1.setBoolean("showChannelOnButton",Features.showChannelOnButton);
      }
   }
}
