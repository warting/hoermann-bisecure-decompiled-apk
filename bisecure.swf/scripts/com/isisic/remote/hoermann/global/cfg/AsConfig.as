package com.isisic.remote.hoermann.global.cfg
{
   import com.isisic.remote.lw.Debug;
   import com.isisic.remote.lw.IDisposable;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import spark.managers.PersistenceManager;
   
   public class AsConfig implements IDisposable
   {
      
      public static const CONFIG_VERSION:String = "CONFIG_VERSION";
      
      public static const GATEWAYS:String = "GATEWAYS";
      
      public static const SCENARIOS:String = "SCENARIOS";
      
      public static const PORTAL_DATA:String = "PORTAL_DATA";
      
      public static const AUTO_LOGIN:String = "AUTO_LOGIN";
      
      public static const SUPPRESS_GATE_OUT_OF_VIEW:String = "SUPPRESS_GATE_OUT_OF_VIEW";
      
      public static const SUPPRESS_GATE_NOT_RESPONSABLE:String = "SUPPRESS_GATE_NOT_RESPONSABLE";
      
      public static const SHOW_ADMIN_CHPWD:String = "SHOW_ADMIN_CHPWD";
      
      public static const SHOWN_OVERLAYS:String = "SHOWN_OVERLAYS";
      
      public static const TERMS_OF_USE_ACCEPTED:String = "TERMS_OF_USE_ACCEPTED";
      
      public static const TERMS_OF_PRIVACY_ACCEPTED:String = "TERMS_OF_PRIVACY_ACCEPTED";
      
      public static const ACTUAL_CONFIG_VERSION:int = 8;
       
      
      private var propManager:PersistenceManager;
      
      public function AsConfig(param1:Boolean = false)
      {
         super();
         if(param1)
         {
            return;
         }
         this.propManager = new PersistenceManager();
         this.reload();
         if(this.propManager.getProperty(CONFIG_VERSION) == null)
         {
            this.propManager.setProperty(CONFIG_VERSION,0);
         }
         if(this.checkUpdates())
         {
            this.updateConfig();
         }
      }
      
      public function dispose() : void
      {
         this.propManager = null;
      }
      
      public function reload() : void
      {
         this.propManager.load();
      }
      
      public function save() : void
      {
         this.propManager.save();
      }
      
      public function getProperty(param1:String) : Object
      {
         return this.propManager.getProperty(param1);
      }
      
      public function setProperty(param1:String, param2:Object) : void
      {
         this.propManager.setProperty(param1,param2);
         this.save();
      }
      
      private function checkUpdates() : Boolean
      {
         var _loc1_:int = this.propManager.getProperty(CONFIG_VERSION) as int;
         Debug.info("[AsConfig] running version: " + _loc1_);
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
         var _loc1_:int = this.propManager.getProperty(CONFIG_VERSION) as int;
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
         this.propManager.setProperty(CONFIG_VERSION,--_loc1_);
         this.propManager.save();
         return true;
      }
   }
}
