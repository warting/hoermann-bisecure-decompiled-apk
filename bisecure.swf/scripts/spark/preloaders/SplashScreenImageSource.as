package spark.preloaders
{
   import mx.core.mx_internal;
   
   public class SplashScreenImageSource
   {
       
      
      public var aspectRatio:String = null;
      
      public var dpi:Number = NaN;
      
      public var minResolution:Number = NaN;
      
      public var source:Class;
      
      public function SplashScreenImageSource()
      {
         super();
      }
      
      mx_internal function matches(param1:String, param2:Number, param3:Number) : Boolean
      {
         return (!this.aspectRatio || this.aspectRatio == param1) && (isNaN(this.dpi) || this.dpi == param2) && (isNaN(this.minResolution) || this.minResolution <= param3);
      }
      
      mx_internal function betterThan(param1:SplashScreenImageSource) : Boolean
      {
         if(this.specificity() != param1.specificity())
         {
            return this.specificity() > param1.specificity();
         }
         return this.getMinResolution() > param1.getMinResolution();
      }
      
      private function getMinResolution() : Number
      {
         return !!isNaN(this.minResolution)?Number(0):Number(this.minResolution);
      }
      
      private function specificity() : int
      {
         var _loc1_:int = 0;
         if(this.aspectRatio)
         {
            _loc1_++;
         }
         if(!isNaN(this.dpi))
         {
            _loc1_++;
         }
         if(!isNaN(this.minResolution))
         {
            _loc1_++;
         }
         return _loc1_;
      }
   }
}
