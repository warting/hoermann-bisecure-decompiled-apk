package spark.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   import mx.utils.MatrixUtil;
   
   use namespace mx_internal;
   
   public class BitmapUtil
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function BitmapUtil()
      {
         super();
      }
      
      public static function getSnapshotWithPadding(param1:IUIComponent, param2:int = 4, param3:Boolean = false, param4:Rectangle = null) : BitmapData
      {
         var _loc5_:Number = param1.width;
         var _loc6_:Number = param1.height;
         var _loc7_:Matrix = MatrixUtil.getConcatenatedComputedMatrix(param1 as DisplayObject,null);
         var _loc8_:Point = new Point(-param2,-param2);
         var _loc9_:Point = MatrixUtil.transformBounds(_loc5_ + param2 * 2,_loc6_ + param2 * 2,_loc7_,_loc8_);
         _loc8_.x = Math.floor(_loc8_.x);
         _loc8_.y = Math.floor(_loc8_.y);
         _loc7_.translate(-_loc8_.x,-_loc8_.y);
         if(!param4)
         {
            param4 = new Rectangle();
         }
         param4.x = _loc8_.x;
         param4.y = _loc8_.y;
         param4.width = Math.ceil(_loc9_.x);
         param4.height = Math.ceil(_loc9_.y);
         var _loc10_:BitmapData = new BitmapData(param4.width,param4.height,true,0);
         _loc10_.draw(IBitmapDrawable(param1),_loc7_,!!param3?param1.transform.colorTransform:null);
         return _loc10_;
      }
      
      public static function getSnapshot(param1:IUIComponent, param2:Rectangle = null, param3:Boolean = false) : BitmapData
      {
         var _loc4_:Matrix = MatrixUtil.getConcatenatedComputedMatrix(param1 as DisplayObject,null);
         var _loc5_:Rectangle = getRealBounds(DisplayObject(param1),_loc4_);
         if(param2 != null)
         {
            param2.x = _loc5_.x - param1.x;
            param2.y = _loc5_.y - param1.y;
            param2.width = _loc5_.width;
            param2.height = _loc5_.height;
         }
         if(_loc5_.width == 0 || _loc5_.height == 0)
         {
            return null;
         }
         if(_loc4_)
         {
            _loc4_.translate(-Math.floor(_loc5_.x),-Math.floor(_loc5_.y));
         }
         var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,true,0);
         _loc6_.draw(IBitmapDrawable(param1),_loc4_,!!param3?param1.transform.colorTransform:null);
         return _loc6_;
      }
      
      private static function getRealBounds(param1:DisplayObject, param2:Matrix = null, param3:int = 10) : Rectangle
      {
         var _loc9_:int = 0;
         var _loc4_:BitmapData = new BitmapData(param1.width + 2 * param3,param1.height + 2 * param3,true,0);
         if(!param2)
         {
            param2 = new Matrix();
         }
         var _loc5_:Number = param2.tx;
         var _loc6_:Number = param2.ty;
         param2.translate(-_loc5_ + param3,-_loc6_ + param3);
         var _loc7_:Object = param1.opaqueBackground;
         param1.opaqueBackground = 4294967295;
         _loc4_.draw(param1,param2);
         param2.translate(_loc5_ - param3,_loc6_ - param3);
         param1.opaqueBackground = _loc7_;
         var _loc8_:Rectangle = _loc4_.getColorBoundsRect(4278190080,0,false);
         if(_loc8_.width == 0 || _loc8_.height == 0 || _loc8_.x > 0 && _loc8_.y > 0 && _loc8_.right < _loc4_.width && _loc8_.bottom < _loc4_.height)
         {
            _loc8_.x = _loc8_.x + _loc5_ - param3;
            _loc8_.y = _loc8_.y + _loc6_ - param3;
            _loc4_.dispose();
            return _loc8_;
         }
         _loc9_ = param3 == 0?10:int(2 * param3);
         _loc4_.dispose();
         return getRealBounds(param1,param2,_loc9_);
      }
   }
}
