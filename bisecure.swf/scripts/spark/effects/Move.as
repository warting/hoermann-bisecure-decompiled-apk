package spark.effects
{
   import mx.core.mx_internal;
   import mx.effects.IEffectInstance;
   import spark.effects.animation.MotionPath;
   import spark.effects.supportClasses.AnimateTransformInstance;
   
   use namespace mx_internal;
   
   public class Move extends AnimateTransform
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var AFFECTED_PROPERTIES:Array = ["translationX","translationY","postLayoutTranslationX","postLayoutTranslationY","left","right","top","bottom","horizontalCenter","verticalCenter","baseline","width","height"];
      
      private static var RELEVANT_STYLES:Array = ["left","right","top","bottom","horizontalCenter","verticalCenter","baseline"];
       
      
      public var yBy:Number;
      
      public var yFrom:Number;
      
      public var yTo:Number;
      
      public var xBy:Number;
      
      public var xFrom:Number;
      
      public var xTo:Number;
      
      public function Move(param1:Object = null)
      {
         super(param1);
         instanceClass = AnimateTransformInstance;
         transformEffectSubclass = true;
      }
      
      override public function get relevantStyles() : Array
      {
         return RELEVANT_STYLES;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override public function createInstance(param1:Object = null) : IEffectInstance
      {
         motionPaths = new Vector.<MotionPath>();
         return super.createInstance(param1);
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         var _loc2_:String = !!applyChangesPostLayout?"postLayoutTranslationX":"translationX";
         var _loc3_:String = !!applyChangesPostLayout?"postLayoutTranslationY":"translationY";
         addMotionPath(_loc2_,this.xFrom,this.xTo,this.xBy);
         addMotionPath(_loc3_,this.yFrom,this.yTo,this.yBy);
         super.initInstance(param1);
      }
   }
}
