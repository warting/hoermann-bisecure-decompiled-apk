package spark.skins.mobile
{
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   import spark.components.BusyIndicator;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class BusyIndicatorSkin extends MobileSkin
   {
      
      private static const DEFAULT_ROTATION_INTERVAL:Number = 50;
      
      private static const DEFAULT_MINIMUM_SIZE:Number = 20;
      
      private static const RADIANS_PER_DEGREE:Number = Math.PI / 180;
       
      
      private var _hostComponent:BusyIndicator;
      
      private var oldUnscaledHeight:Number;
      
      private var oldUnscaledWidth:Number;
      
      private var rotationTimer:Timer;
      
      private var currentRotation:Number = 0;
      
      private var spinnerDiameter:int;
      
      private var spokeColor:uint;
      
      public function BusyIndicatorSkin()
      {
         super();
         alpha = 0.6;
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
      }
      
      public function get hostComponent() : BusyIndicator
      {
         return this._hostComponent;
      }
      
      public function set hostComponent(param1:BusyIndicator) : void
      {
         this._hostComponent = param1;
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "rotationInterval")
         {
            if(this.isRotating())
            {
               this.stopRotation();
               this.startRotation();
            }
         }
         if(_loc2_ || param1 == "symbolColor")
         {
            this.updateSpinner(this.spinnerDiameter);
         }
      }
      
      override protected function measure() : void
      {
         if(applicationDPI == DPIClassification.DPI_640)
         {
            measuredWidth = 104;
            measuredHeight = 104;
         }
         else if(applicationDPI == DPIClassification.DPI_480)
         {
            measuredWidth = 80;
            measuredHeight = 80;
         }
         else if(applicationDPI == DPIClassification.DPI_320)
         {
            measuredWidth = 52;
            measuredHeight = 52;
         }
         else if(applicationDPI == DPIClassification.DPI_240)
         {
            measuredWidth = 40;
            measuredHeight = 40;
         }
         else if(applicationDPI == DPIClassification.DPI_160)
         {
            measuredWidth = 26;
            measuredHeight = 26;
         }
         else if(applicationDPI == DPIClassification.DPI_120)
         {
            measuredWidth = 20;
            measuredHeight = 20;
         }
         else
         {
            measuredWidth = DEFAULT_MINIMUM_SIZE;
            measuredHeight = DEFAULT_MINIMUM_SIZE;
         }
         measuredMinWidth = DEFAULT_MINIMUM_SIZE;
         measuredMinHeight = DEFAULT_MINIMUM_SIZE;
      }
      
      override protected function commitCurrentState() : void
      {
         super.commitCurrentState();
         if(currentState == "rotatingState")
         {
            this.startRotation();
         }
         else
         {
            this.stopRotation();
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(this.oldUnscaledWidth != param1 || this.oldUnscaledHeight != param2)
         {
            _loc3_ = this.calculateSpinnerDiameter(param1,param2);
            this.updateSpinner(_loc3_);
            this.oldUnscaledWidth = param1;
            this.oldUnscaledHeight = param2;
         }
      }
      
      private function calculateSpinnerDiameter(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.min(param1,param2);
         _loc3_ = Math.max(DEFAULT_MINIMUM_SIZE,_loc3_);
         if(_loc3_ % 2 != 0)
         {
            _loc3_--;
         }
         return _loc3_;
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         measuredHeight = param2;
         measuredWidth = param1;
      }
      
      private function updateSpinner(param1:Number) : void
      {
         var _loc2_:Boolean = this.isRotating();
         if(_loc2_)
         {
            this.stopRotation();
         }
         this.spinnerDiameter = param1;
         this.spokeColor = getStyle("symbolColor");
         mx_internal::drawSpinner();
         if(_loc2_)
         {
            this.startRotation();
         }
      }
      
      mx_internal function drawSpinner() : void
      {
         var _loc1_:Graphics = graphics;
         var _loc2_:int = this.spinnerDiameter / 2;
         var _loc3_:int = this.spinnerDiameter;
         var _loc4_:Number = this.spinnerDiameter / 3.7;
         var _loc5_:Number = this.spinnerDiameter - _loc4_ * 2;
         var _loc6_:Number = _loc5_ / 5;
         var _loc7_:Number = _loc6_ / 2;
         var _loc8_:Number = 0;
         _loc1_.clear();
         this.drawSpoke(0.2,this.currentRotation + 300,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.25,this.currentRotation + 330,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.3,this.currentRotation,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.35,this.currentRotation + 30,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.4,this.currentRotation + 60,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.45,this.currentRotation + 90,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.5,this.currentRotation + 120,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.6,this.currentRotation + 150,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.7,this.currentRotation + 180,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.8,this.currentRotation + 210,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(0.9,this.currentRotation + 240,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
         this.drawSpoke(1,this.currentRotation + 270,_loc6_,_loc4_,this.spokeColor,_loc2_,_loc7_,_loc8_);
      }
      
      private function drawSpoke(param1:Number, param2:int, param3:Number, param4:Number, param5:uint, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc9_:Graphics = graphics;
         _loc9_.lineStyle(param3,param5,param1,false,LineScaleMode.NORMAL,CapsStyle.ROUND);
         var _loc10_:Point = this.calculatePointOnCircle(param6,param6 - param7 - param8,param2);
         var _loc11_:Point = this.calculatePointOnCircle(param6,param6 - param4 + param7 - param8,param2);
         _loc9_.moveTo(_loc10_.x,_loc10_.y);
         _loc9_.lineTo(_loc11_.x,_loc11_.y);
      }
      
      private function calculatePointOnCircle(param1:Number, param2:Number, param3:Number) : Point
      {
         var _loc4_:Point = new Point();
         var _loc5_:Number = param3 * RADIANS_PER_DEGREE;
         _loc4_.x = param1 + param2 * Math.cos(_loc5_);
         _loc4_.y = param1 + param2 * Math.sin(_loc5_);
         return _loc4_;
      }
      
      private function startRotation() : void
      {
         var _loc1_:Number = NaN;
         if(!this.rotationTimer)
         {
            _loc1_ = getStyle("rotationInterval");
            if(isNaN(_loc1_))
            {
               _loc1_ = DEFAULT_ROTATION_INTERVAL;
            }
            if(_loc1_ < 16.6)
            {
               _loc1_ = 16.6;
            }
            this.rotationTimer = new Timer(_loc1_);
         }
         if(!this.rotationTimer.hasEventListener(TimerEvent.TIMER))
         {
            this.rotationTimer.addEventListener(TimerEvent.TIMER,this.timerHandler);
            this.rotationTimer.start();
         }
      }
      
      private function stopRotation() : void
      {
         if(this.rotationTimer)
         {
            this.rotationTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this.rotationTimer.stop();
            this.rotationTimer = null;
         }
      }
      
      private function isRotating() : Boolean
      {
         return this.rotationTimer != null;
      }
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.currentRotation = this.currentRotation + 30;
         if(this.currentRotation >= 360)
         {
            this.currentRotation = 0;
         }
         mx_internal::drawSpinner();
         param1.updateAfterEvent();
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         this.stopRotation();
      }
   }
}
