package spark.skins.android4
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Timer;
   import mx.core.DPIClassification;
   import spark.components.BusyIndicator;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class BusyIndicatorSkin extends MobileSkin
   {
      
      private static const DEFAULT_ROTATION_INTERVAL:Number = 50;
       
      
      private var busyIndicatorClass:Class;
      
      private var busyIndicator:DisplayObject;
      
      private var busyIndicatorDiameter:Number;
      
      private var rotationTimer:Timer;
      
      private var rotationInterval:Number;
      
      private var currentRotation:Number = 0;
      
      private var symbolColor:uint;
      
      private var symbolColorChanged:Boolean = false;
      
      private var _hostComponent:spark.components.BusyIndicator;
      
      private var rotationMatrix:Matrix;
      
      public function BusyIndicatorSkin()
      {
         super();
         this.busyIndicatorClass = spark.skins.android4.assets.BusyIndicator;
         this.rotationInterval = getStyle("rotationInterval");
         if(isNaN(this.rotationInterval))
         {
            this.rotationInterval = DEFAULT_ROTATION_INTERVAL;
         }
         if(this.rotationInterval < 16.6)
         {
            this.rotationInterval = 16.6;
         }
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.busyIndicatorDiameter = 144;
               break;
            case DPIClassification.DPI_480:
               this.busyIndicatorDiameter = 108;
               break;
            case DPIClassification.DPI_320:
               this.busyIndicatorDiameter = 72;
               break;
            case DPIClassification.DPI_240:
               this.busyIndicatorDiameter = 54;
               break;
            case DPIClassification.DPI_120:
               this.busyIndicatorDiameter = 27;
               break;
            default:
               this.busyIndicatorDiameter = 36;
         }
      }
      
      public function get hostComponent() : spark.components.BusyIndicator
      {
         return this._hostComponent;
      }
      
      public function set hostComponent(param1:spark.components.BusyIndicator) : void
      {
         this._hostComponent = param1;
      }
      
      override protected function createChildren() : void
      {
         this.busyIndicator = new this.busyIndicatorClass();
         this.busyIndicator.width = this.busyIndicator.height = this.busyIndicatorDiameter;
         addChild(this.busyIndicator);
      }
      
      override protected function measure() : void
      {
         measuredWidth = this.busyIndicatorDiameter;
         measuredHeight = this.busyIndicatorDiameter;
         measuredMinHeight = this.busyIndicatorDiameter;
         measuredMinWidth = this.busyIndicatorDiameter;
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
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "symbolColor")
         {
            this.symbolColor = getStyle("symbolColor");
            this.symbolColorChanged = true;
            invalidateDisplayList();
         }
         super.styleChanged(param1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.symbolColorChanged)
         {
            this.colorizeSymbol();
            this.symbolColorChanged = false;
         }
      }
      
      private function colorizeSymbol() : void
      {
         super.applyColorTransform(this.busyIndicator,0,this.symbolColor);
      }
      
      private function startRotation() : void
      {
         this.rotationTimer = new Timer(this.rotationInterval);
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
      
      private function timerHandler(param1:TimerEvent) : void
      {
         this.currentRotation = this.currentRotation + this.rotationInterval;
         if(this.currentRotation >= 360)
         {
            this.currentRotation = 0;
         }
         this.rotate(this.busyIndicator,this.currentRotation,width / 2,height / 2);
         param1.updateAfterEvent();
      }
      
      private function rotate(param1:DisplayObject, param2:Number, param3:Number, param4:Number) : void
      {
         this.rotationMatrix = new Matrix();
         this.rotationMatrix.translate(-param3,-param4);
         this.rotationMatrix.rotate(Math.PI * param2 / 180);
         this.rotationMatrix.translate(param3,param4);
         param1.transform.matrix = this.rotationMatrix;
      }
   }
}
