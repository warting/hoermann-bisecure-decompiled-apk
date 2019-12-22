package spark.utils
{
   import mx.core.DPIClassification;
   import mx.core.FlexGlobals;
   import mx.core.mx_internal;
   import mx.utils.DensityUtil;
   
   use namespace mx_internal;
   
   public class MultiDPIBitmapSource
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public var source120dpi:Object;
      
      public var source160dpi:Object;
      
      public var source240dpi:Object;
      
      public var source320dpi:Object;
      
      public var source480dpi:Object;
      
      public var source640dpi:Object;
      
      public function MultiDPIBitmapSource()
      {
         super();
      }
      
      public function getMultiSource() : Object
      {
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc1_:Object = FlexGlobals.topLevelApplication;
         if("runtimeDPI" in _loc1_)
         {
            _loc2_ = _loc1_["runtimeDPI"];
         }
         else
         {
            _loc2_ = DensityUtil.getRuntimeDPI();
         }
         _loc3_ = this.getSource(_loc2_);
         return _loc3_;
      }
      
      public function getSource(param1:Number) : Object
      {
         var _loc2_:Object = this.source160dpi;
         switch(param1)
         {
            case DPIClassification.DPI_640:
               _loc2_ = this.source640dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source480dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source320dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source240dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source160dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source120dpi;
               }
               break;
            case DPIClassification.DPI_480:
               _loc2_ = this.source480dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source640dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source320dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source240dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source160dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source120dpi;
               }
               break;
            case DPIClassification.DPI_320:
               _loc2_ = this.source320dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source480dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source640dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source240dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source160dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source120dpi;
               }
               break;
            case DPIClassification.DPI_240:
               _loc2_ = this.source240dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source320dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source480dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source640dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source160dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source120dpi;
               }
               break;
            case DPIClassification.DPI_160:
               _loc2_ = this.source160dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source240dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source320dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source480dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source640dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source120dpi;
               }
               break;
            case DPIClassification.DPI_120:
               _loc2_ = this.source120dpi;
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source160dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source240dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source320dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source480dpi;
               }
               if(!_loc2_ || _loc2_ == "")
               {
                  _loc2_ = this.source640dpi;
               }
         }
         return _loc2_;
      }
   }
}
