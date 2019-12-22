package spark.effects.supportClasses
{
   import mx.core.mx_internal;
   import spark.effects.animation.Keyframe;
   import spark.effects.animation.MotionPath;
   
   use namespace mx_internal;
   
   public class FadeInstance extends AnimateInstance
   {
       
      
      private var origAlpha:Number = NaN;
      
      private var makeInvisible:Boolean;
      
      private var restoreAlpha:Boolean;
      
      public var alphaFrom:Number;
      
      public var alphaTo:Number;
      
      public function FadeInstance(param1:Object)
      {
         super(param1);
         autoRemoveTarget = true;
      }
      
      override public function play() : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:* = false;
         var _loc1_:Number = this.alphaFrom;
         var _loc2_:Number = this.alphaTo;
         if(propertyChanges)
         {
            if(isNaN(_loc1_))
            {
               _loc1_ = propertyChanges.start["alpha"] !== undefined?Number(propertyChanges.start["alpha"]):Number(target.alpha);
            }
            if(isNaN(_loc2_))
            {
               _loc2_ = propertyChanges.end["alpha"] !== undefined?Number(propertyChanges.end["alpha"]):Number(target.alpha);
            }
            _loc3_ = propertyChanges.end["visible"] !== undefined && propertyChanges.end["visible"] != propertyChanges.start["visible"];
            _loc4_ = propertyChanges.end["parent"] !== undefined && propertyChanges.end["parent"] != propertyChanges.start["parent"];
            if(_loc3_ || _loc4_)
            {
               _loc5_ = Boolean(_loc3_ && propertyChanges.end["visible"] || _loc4_ && propertyChanges.end["parent"]);
               if(playReversed)
               {
                  _loc5_ = !_loc5_;
               }
               if(_loc5_)
               {
                  if(isNaN(this.alphaFrom))
                  {
                     this.alphaFrom = !playReversed?Number(0):Number(_loc2_);
                  }
                  if(this.alphaFrom == 0)
                  {
                     target.alpha = 0;
                  }
                  this.alphaTo = !playReversed?Number(_loc2_):Number(0);
                  if("visible" in target)
                  {
                     target.visible = true;
                  }
               }
               else if(isNaN(this.alphaTo))
               {
                  this.restoreAlpha = true;
                  this.origAlpha = propertyChanges.end["alpha"] !== undefined?Number(propertyChanges.end["alpha"]):Number(target.alpha);
                  if(_loc3_)
                  {
                     this.makeInvisible = true;
                  }
                  if(!playReversed)
                  {
                     this.alphaTo = 0;
                  }
                  else
                  {
                     if(isNaN(this.alphaFrom))
                     {
                        target.alpha = 0;
                        this.alphaFrom = 0;
                     }
                     this.alphaTo = 1;
                  }
               }
            }
         }
         if("visible" in target && !target.visible)
         {
            if(isNaN(_loc1_))
            {
               _loc1_ = target.alpha;
            }
            if(isNaN(_loc2_))
            {
               _loc2_ = target.alpha;
            }
            if(_loc1_ == 0 && _loc2_ != 0)
            {
               target.alpha = 0;
               target.visible = true;
            }
         }
         motionPaths = new <MotionPath>[new MotionPath("alpha")];
         motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0,this.alphaFrom),new Keyframe(duration,this.alphaTo)];
         super.play();
      }
      
      override public function finishEffect() : void
      {
         super.finishEffect();
         if(this.restoreAlpha)
         {
            target.alpha = this.origAlpha;
         }
         if(this.makeInvisible)
         {
            target.visible = false;
         }
      }
   }
}
