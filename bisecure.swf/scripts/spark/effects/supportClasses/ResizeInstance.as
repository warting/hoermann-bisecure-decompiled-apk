package spark.effects.supportClasses
{
   import mx.core.mx_internal;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   
   use namespace mx_internal;
   
   public class ResizeInstance extends AnimateInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var heightSet:Boolean;
      
      private var widthSet:Boolean;
      
      private var explicitWidthSet:Boolean;
      
      private var explicitHeightSet:Boolean;
      
      private var _heightBy:Number;
      
      public var heightFrom:Number;
      
      private var _heightTo:Number;
      
      private var _widthBy:Number;
      
      public var widthFrom:Number;
      
      private var _widthTo:Number;
      
      public function ResizeInstance(param1:Object)
      {
         super(param1);
      }
      
      public function get heightBy() : Number
      {
         return this._heightBy;
      }
      
      public function set heightBy(param1:Number) : void
      {
         this._heightBy = param1;
         this.heightSet = !isNaN(param1);
      }
      
      public function get heightTo() : Number
      {
         return this._heightTo;
      }
      
      public function set heightTo(param1:Number) : void
      {
         this._heightTo = param1;
         this.heightSet = !isNaN(param1);
      }
      
      public function get widthBy() : Number
      {
         return this._widthBy;
      }
      
      public function set widthBy(param1:Number) : void
      {
         this._widthBy = param1;
         this.widthSet = !isNaN(param1);
      }
      
      public function get widthTo() : Number
      {
         return this._widthTo;
      }
      
      public function set widthTo(param1:Number) : void
      {
         this._widthTo = param1;
         this.widthSet = !isNaN(param1);
      }
      
      override public function play() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.calculateDimensionChanges();
         motionPaths = new <MotionPath>[new MotionPath("width"),new MotionPath("height")];
         motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,this.widthFrom),new Keyframe(duration,this.widthTo,this.widthBy)];
         motionPaths[1].keyframes = new <Keyframe>[new Keyframe(0,this.heightFrom),new Keyframe(duration,this.heightTo,this.heightBy)];
         if(propertyChanges && !disableLayout)
         {
            _loc1_ = propertyChanges.start["width"];
            _loc2_ = propertyChanges.end["width"];
            _loc3_ = propertyChanges.start["height"];
            _loc4_ = propertyChanges.end["height"];
            if(_loc1_ !== undefined && _loc2_ != undefined && _loc1_ != _loc2_)
            {
               setupConstraintAnimation("left");
               setupConstraintAnimation("right");
            }
            if(_loc3_ !== undefined && _loc4_ != undefined && _loc3_ != _loc4_)
            {
               setupConstraintAnimation("top");
               setupConstraintAnimation("bottom");
            }
         }
         super.play();
      }
      
      private function calculateDimensionChanges() : void
      {
         var _loc1_:* = !!propertyChanges?propertyChanges.end["explicitWidth"]:undefined;
         var _loc2_:* = !!propertyChanges?propertyChanges.end["explicitHeight"]:undefined;
         var _loc3_:* = !!propertyChanges?propertyChanges.end["percentWidth"]:undefined;
         var _loc4_:* = !!propertyChanges?propertyChanges.end["percentHeight"]:undefined;
         if(isNaN(this.widthFrom))
         {
            if(!isNaN(this.widthTo) && !isNaN(this.widthBy))
            {
               this.widthFrom = this.widthTo - this.widthBy;
            }
         }
         if(isNaN(this.widthTo))
         {
            if(isNaN(this.widthBy) && propertyChanges && (propertyChanges.end["width"] !== undefined && propertyChanges.end["width"] != propertyChanges.start["width"] || _loc1_ !== undefined && !isNaN(_loc1_)))
            {
               if(_loc1_ !== undefined && !isNaN(_loc1_))
               {
                  this.explicitWidthSet = true;
                  this._widthTo = _loc1_;
               }
               else
               {
                  this._widthTo = propertyChanges.end["width"];
               }
            }
            else if(!isNaN(this.widthBy) && !isNaN(this.widthFrom))
            {
               this._widthTo = this.widthFrom + this.widthBy;
            }
         }
         if(isNaN(this.heightFrom))
         {
            if(!isNaN(this.heightTo) && !isNaN(this.heightBy))
            {
               this.heightFrom = this.heightTo - this.heightBy;
            }
         }
         if(isNaN(this.heightTo))
         {
            if(isNaN(this.heightBy) && propertyChanges && (propertyChanges.end["height"] !== undefined && propertyChanges.end["height"] != propertyChanges.start["height"] || _loc2_ !== undefined && !isNaN(_loc2_)))
            {
               if(_loc2_ !== undefined && !isNaN(_loc2_))
               {
                  this.explicitHeightSet = true;
                  this._heightTo = _loc2_;
               }
               else
               {
                  this._heightTo = propertyChanges.end["height"];
               }
            }
            else if(!isNaN(this.heightBy) && !isNaN(this.heightFrom))
            {
               this._heightTo = this.heightFrom + this.heightBy;
            }
         }
      }
   }
}
