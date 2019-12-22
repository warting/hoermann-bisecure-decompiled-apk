package mx.core
{
   import flash.display.DisplayObject;
   import flash.system.Capabilities;
   import mx.managers.SystemManager;
   import mx.utils.Platform;
   
   use namespace mx_internal;
   
   public class RuntimeDPIProvider
   {
      
      mx_internal static const IPAD_MAX_EXTENT:int = 1024;
      
      mx_internal static const IPAD_RETINA_MAX_EXTENT:int = 2048;
       
      
      public function RuntimeDPIProvider()
      {
         super();
      }
      
      mx_internal static function classifyDPI(param1:Number) : Number
      {
         if(param1 <= 140)
         {
            return DPIClassification.DPI_120;
         }
         if(param1 <= 200)
         {
            return DPIClassification.DPI_160;
         }
         if(param1 <= 280)
         {
            return DPIClassification.DPI_240;
         }
         if(param1 <= 400)
         {
            return DPIClassification.DPI_320;
         }
         if(param1 <= 560)
         {
            return DPIClassification.DPI_480;
         }
         return DPIClassification.DPI_640;
      }
      
      public function get runtimeDPI() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:DisplayObject = null;
         if(Platform.isIOS)
         {
            _loc1_ = Capabilities.screenResolutionX;
            _loc2_ = Capabilities.screenResolutionY;
            if(Capabilities.isDebugger)
            {
               _loc3_ = SystemManager.getSWFRoot(this);
               if(_loc3_ && _loc3_.stage)
               {
                  _loc1_ = _loc3_.stage.fullScreenWidth;
                  _loc2_ = _loc3_.stage.fullScreenHeight;
               }
            }
            if(_loc1_ == IPAD_MAX_EXTENT || _loc2_ == IPAD_MAX_EXTENT)
            {
               return DPIClassification.DPI_160;
            }
            if(_loc1_ == IPAD_RETINA_MAX_EXTENT || _loc2_ == IPAD_RETINA_MAX_EXTENT)
            {
               return DPIClassification.DPI_320;
            }
         }
         return classifyDPI(Capabilities.screenDPI);
      }
   }
}
