package spark.skins.mobile.supportClasses
{
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import mx.core.mx_internal;
   import spark.skins.ActionScriptSkinBase;
   
   use namespace mx_internal;
   
   public class MobileSkin extends ActionScriptSkinBase
   {
      
      mx_internal static const MOBILE_THEME_DARK_COLOR:uint = 4737096;
      
      mx_internal static const MOBILE_THEME_LIGHT_COLOR:uint = 13421772;
      
      mx_internal static const DEFAULT_SYMBOL_COLOR_VALUE:uint = 0;
      
      private static var _colorMatrix:Matrix = new Matrix();
      
      private static var _colorTransform:ColorTransform;
       
      
      public function MobileSkin()
      {
         super();
         useMinimumHitArea = true;
      }
      
      mx_internal static function get colorMatrix() : Matrix
      {
         if(!_colorMatrix)
         {
            _colorMatrix = new Matrix();
         }
         return _colorMatrix;
      }
      
      mx_internal static function get colorTransform() : ColorTransform
      {
         if(!_colorTransform)
         {
            _colorTransform = new ColorTransform();
         }
         return _colorTransform;
      }
   }
}
