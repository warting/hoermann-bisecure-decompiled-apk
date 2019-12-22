package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectManager;
   
   use namespace mx_internal;
   
   public class RotateInstance extends TweenEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var centerX:Number;
      
      private var centerY:Number;
      
      private var newX:Number;
      
      private var newY:Number;
      
      private var originalOffsetX:Number;
      
      private var originalOffsetY:Number;
      
      public var angleFrom:Number = 0;
      
      public var angleTo:Number = 360;
      
      public var originX:Number;
      
      public var originY:Number;
      
      public function RotateInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function play() : void
      {
         super.play();
         var _loc1_:Number = Math.PI * target.rotation / 180;
         if(isNaN(this.originX))
         {
            this.originX = target.width / 2;
         }
         if(isNaN(this.originY))
         {
            this.originY = target.height / 2;
         }
         this.centerX = target.x + this.originX * Math.cos(_loc1_) - this.originY * Math.sin(_loc1_);
         this.centerY = target.y + this.originX * Math.sin(_loc1_) + this.originY * Math.cos(_loc1_);
         if(isNaN(this.angleFrom))
         {
            this.angleFrom = target.rotation;
         }
         if(isNaN(this.angleTo))
         {
            this.angleTo = target.rotation == 0?this.angleFrom > 180?Number(360):Number(0):Number(target.rotation);
         }
         tween = createTween(this,this.angleFrom,this.angleTo,duration);
         target.rotation = this.angleFrom;
         _loc1_ = Math.PI * this.angleFrom / 180;
         EffectManager.suspendEventHandling();
         this.originalOffsetX = this.originX * Math.cos(_loc1_) - this.originY * Math.sin(_loc1_);
         this.originalOffsetY = this.originX * Math.sin(_loc1_) + this.originY * Math.cos(_loc1_);
         this.newX = Number((this.centerX - this.originalOffsetX).toFixed(1));
         this.newY = Number((this.centerY - this.originalOffsetY).toFixed(1));
         target.move(this.newX,this.newY);
         EffectManager.resumeEventHandling();
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         if(Math.abs(this.newX - target.x) > 0.1)
         {
            this.centerX = target.x + this.originalOffsetX;
         }
         if(Math.abs(this.newY - target.y) > 0.1)
         {
            this.centerY = target.y + this.originalOffsetY;
         }
         var _loc2_:Number = Number(param1);
         var _loc3_:Number = Math.PI * _loc2_ / 180;
         EffectManager.suspendEventHandling();
         target.rotation = _loc2_;
         this.newX = this.centerX - this.originX * Math.cos(_loc3_) + this.originY * Math.sin(_loc3_);
         this.newY = this.centerY - this.originX * Math.sin(_loc3_) - this.originY * Math.cos(_loc3_);
         this.newX = Number(this.newX.toFixed(1));
         this.newY = Number(this.newY.toFixed(1));
         target.move(this.newX,this.newY);
         EffectManager.resumeEventHandling();
      }
   }
}
