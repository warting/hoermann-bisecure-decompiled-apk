package spark.effects
{
   import mx.core.mx_internal;
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.ResizeInstance;
   
   use namespace mx_internal;
   
   public class Resize extends Animate
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var AFFECTED_PROPERTIES:Array = ["width","height","explicitWidth","explicitHeight","percentWidth","percentHeight","left","right","top","bottom"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","percentWidth","percentHeight"];
       
      
      public var heightBy:Number;
      
      public var heightFrom:Number;
      
      public var heightTo:Number;
      
      public var widthBy:Number;
      
      public var widthFrom:Number;
      
      public var widthTo:Number;
      
      public function Resize(param1:Object = null)
      {
         super(param1);
         instanceClass = ResizeInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         var _loc2_:ResizeInstance = ResizeInstance(param1);
         if(!isNaN(this.widthFrom))
         {
            _loc2_.widthFrom = this.widthFrom;
         }
         if(!isNaN(this.widthTo))
         {
            _loc2_.widthTo = this.widthTo;
         }
         if(!isNaN(this.widthBy))
         {
            _loc2_.widthBy = this.widthBy;
         }
         if(!isNaN(this.heightFrom))
         {
            _loc2_.heightFrom = this.heightFrom;
         }
         if(!isNaN(this.heightTo))
         {
            _loc2_.heightTo = this.heightTo;
         }
         if(!isNaN(this.heightBy))
         {
            _loc2_.heightBy = this.heightBy;
         }
      }
      
      override mx_internal function captureValues(param1:Array, param2:Boolean, param3:Array = null) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:Array = super.captureValues(param1,param2,param3);
         if(param2)
         {
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(param3 == null || param3.length == 0 || param3.indexOf(_loc4_[_loc6_].target) >= 0)
               {
                  _loc4_[_loc6_].stripUnchangedValues = false;
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
   }
}
