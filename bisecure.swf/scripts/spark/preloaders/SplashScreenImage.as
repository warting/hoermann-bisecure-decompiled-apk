package spark.preloaders
{
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SplashScreenImage implements IMXMLObject
   {
       
      
      private var _mxmlContent:Array;
      
      public function SplashScreenImage()
      {
         super();
      }
      
      public function get mxmlContent() : Array
      {
         return this._mxmlContent;
      }
      
      public function set mxmlContent(param1:Array) : void
      {
         this._mxmlContent = param1;
      }
      
      public function getImageClass(param1:String, param2:Number, param3:Number) : Class
      {
         var _loc4_:SplashScreenImageSource = null;
         var _loc7_:SplashScreenImageSource = null;
         if(!this._mxmlContent)
         {
            return null;
         }
         var _loc5_:int = this._mxmlContent.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._mxmlContent[_loc6_] as SplashScreenImageSource;
            if(_loc7_ && _loc7_.matches(param1,param2,param3) && (!_loc4_ || _loc7_.betterThan(_loc4_)))
            {
               _loc4_ = _loc7_;
            }
            _loc6_++;
         }
         return !!_loc4_?_loc4_.source:null;
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
      }
   }
}
