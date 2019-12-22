package mx.effects
{
   import mx.core.mx_internal;
   import mx.effects.effectClasses.ParallelInstance;
   
   use namespace mx_internal;
   
   public class Parallel extends CompositeEffect
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      public function Parallel(param1:Object = null)
      {
         super(param1);
         instanceClass = ParallelInstance;
      }
      
      override public function get compositeDuration() : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Effect = null;
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < children.length)
         {
            _loc4_ = Effect(children[_loc2_]);
            if(_loc4_ is CompositeEffect)
            {
               _loc3_ = CompositeEffect(_loc4_).compositeDuration;
            }
            else
            {
               _loc3_ = _loc4_.duration;
            }
            _loc3_ = _loc3_ * _loc4_.repeatCount + _loc4_.repeatDelay * (_loc4_.repeatCount - 1) + _loc4_.startDelay;
            _loc1_ = Math.max(_loc1_,_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
