package com.isisic.remote.hoermann.global.helper
{
   import com.isisic.remote.lw.Debug;
   import flash.system.Capabilities;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public final class Lang
   {
      
      private static const BUNDLE_ID:String = "LocalizedStrings";
      
      private static var _resourceManager:IResourceManager;
      
      private static var _preferredLocale:String = "";
       
      
      public function Lang()
      {
         super();
      }
      
      public static function get preferedLocale() : String
      {
         return _preferredLocale;
      }
      
      public static function init() : void
      {
         resourceManager.getLocales();
      }
      
      private static function get resourceManager() : IResourceManager
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(!_resourceManager)
         {
            _resourceManager = ResourceManager.getInstance();
            _loc1_ = Capabilities.languages[0];
            Debug.info("[Lang] Preferred Locale: " + _loc1_);
            if(_loc1_ && _loc1_.indexOf("-") >= 0)
            {
               _loc1_ = _loc1_.substring(0,_loc1_.indexOf("-"));
            }
            _preferredLocale = _loc1_;
            _loc2_ = searchLocale(_loc1_,_resourceManager.localeChain);
            if(_loc2_ != null)
            {
               _resourceManager.localeChain[0] = _loc2_;
            }
            else
            {
               _resourceManager.localeChain[0] = "en_US";
            }
            Debug.info("[Lang] Selected Locale: " + _resourceManager.localeChain[0]);
         }
         return _resourceManager;
      }
      
      private static function searchLocale(param1:String, param2:Array) : String
      {
         var _loc3_:* = param1.indexOf("_") < 0;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(_loc3_)
            {
               if(param2[_loc4_].substr(0,param1.length) == param1)
               {
                  return param2[_loc4_];
               }
            }
            else if(param2[_loc4_] == param1)
            {
               return param2[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      public static function getString(param1:String) : String
      {
         var _loc2_:String = resourceManager.getString(BUNDLE_ID,param1);
         return !!_loc2_?_loc2_:param1;
      }
   }
}
