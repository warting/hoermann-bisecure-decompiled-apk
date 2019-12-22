package spark.skins.mobile.supportClasses
{
   import mx.core.ILayoutElement;
   import spark.components.supportClasses.GroupBase;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class TabbedViewNavigatorTabBarHorizontalLayout extends LayoutBase
   {
       
      
      public function TabbedViewNavigatorTabBarHorizontalLayout()
      {
         super();
      }
      
      override public function measure() : void
      {
         var _loc7_:ILayoutElement = null;
         super.measure();
         var _loc1_:GroupBase = target;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = _loc1_.numElements;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc1_.getElementAt(_loc6_);
            if(!(!_loc7_ || !_loc7_.includeInLayout))
            {
               _loc3_ = _loc3_ + _loc7_.getPreferredBoundsWidth();
               _loc2_++;
               _loc4_ = Math.max(_loc4_,_loc7_.getPreferredBoundsHeight());
            }
            _loc6_++;
         }
         _loc1_.measuredWidth = _loc3_;
         _loc1_.measuredHeight = _loc4_;
      }
      
      override public function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc7_:ILayoutElement = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:GroupBase = target;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:int = _loc3_.numElements;
         var _loc6_:int = _loc5_;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc7_ = _loc3_.getElementAt(_loc8_);
            if(!_loc7_ || !_loc7_.includeInLayout)
            {
               _loc6_--;
            }
            _loc8_++;
         }
         _loc3_.setContentSize(param1,param2);
         var _loc9_:Number = Math.max(Math.floor(param1 / _loc6_),1);
         var _loc10_:Number = param1 - _loc9_ * _loc6_;
         var _loc11_:Number = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc7_ = _loc3_.getElementAt(_loc8_);
            if(!(!_loc7_ || !_loc7_.includeInLayout))
            {
               _loc11_ = _loc10_ > 0?Number(_loc9_ + 1):Number(_loc9_);
               _loc7_.setLayoutBoundsSize(_loc11_,param2);
               _loc7_.setLayoutBoundsPosition(_loc4_,0);
               _loc4_ = _loc4_ + _loc11_;
               _loc10_--;
            }
            _loc8_++;
         }
      }
   }
}
