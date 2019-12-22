package com.isisic.remote.hoermann.global.cfg
{
   import com.isisic.remote.lw.Debug;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class JSONConfig extends AsConfig
   {
      
      public static const CONFIG_FILE:File = File.applicationStorageDirectory.resolvePath("config.json");
       
      
      private var data:Object;
      
      public function JSONConfig()
      {
         super(true);
         this.reload();
         if(this.getProperty(CONFIG_VERSION) == null)
         {
            this.setProperty(CONFIG_VERSION,0);
         }
         if(this.checkUpdates())
         {
            this.updateConfig();
         }
      }
      
      override public function dispose() : void
      {
         this.data = null;
      }
      
      override public function reload() : void
      {
         var stream:FileStream = null;
         if(!CONFIG_FILE.exists)
         {
            stream = new FileStream();
            stream.open(CONFIG_FILE,FileMode.WRITE);
            stream.close();
            this.data = new Object();
            return;
         }
         stream = new FileStream();
         stream.open(CONFIG_FILE,FileMode.READ);
         try
         {
            this.data = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
         }
         catch(error:Error)
         {
            stream.position = 0;
            Debug.warning("[JSONConfig] Can not parse config:\n" + stream.readUTFBytes(stream.bytesAvailable));
            this.data = new Object();
         }
         stream.close();
      }
      
      override public function save() : void
      {
         var _loc1_:FileStream = new FileStream();
         _loc1_.open(CONFIG_FILE,FileMode.WRITE);
         _loc1_.writeUTFBytes(JSON.stringify(this.data,null,4));
         _loc1_.close();
      }
      
      override public function getProperty(param1:String) : Object
      {
         return this.data[param1];
      }
      
      override public function setProperty(param1:String, param2:Object) : void
      {
         if(param2 == null)
         {
            delete this.data[param1];
         }
         else
         {
            this.data[param1] = param2;
         }
      }
      
      private function checkUpdates() : Boolean
      {
         var _loc1_:int = this.getProperty(CONFIG_VERSION) as int;
         Debug.info("[JSONConfig] running version: " + _loc1_);
         if(_loc1_ < ACTUAL_CONFIG_VERSION)
         {
            return true;
         }
         return false;
      }
      
      private function updateConfig() : Boolean
      {
         var _loc3_:Class = null;
         var _loc4_:ConfigUpdate = null;
         var _loc1_:int = this.getProperty(CONFIG_VERSION) as int;
         var _loc2_:String = getQualifiedClassName(this);
         _loc2_ = _loc2_.substr(0,_loc2_.lastIndexOf("::"));
         _loc1_++;
         while(_loc1_ <= ACTUAL_CONFIG_VERSION)
         {
            _loc3_ = getDefinitionByName(_loc2_ + ".updates::Update_" + _loc1_) as Class;
            _loc4_ = new _loc3_();
            _loc4_.runUpdate(this);
            _loc1_++;
         }
         this.setProperty(CONFIG_VERSION,--_loc1_);
         this.save();
         return true;
      }
   }
}
