package spark.preloaders
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.StageAspectRatio;
   import flash.events.Event;
   import flash.events.StageOrientationEvent;
   import flash.geom.Matrix;
   import flash.utils.getTimer;
   import mx.core.RuntimeDPIProvider;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.managers.SystemManager;
   import mx.preloaders.IPreloaderDisplay;
   import mx.preloaders.Preloader;
   
   use namespace mx_internal;
   
   public class SplashScreen extends Sprite implements IPreloaderDisplay
   {
       
      
      private var splashImage:DisplayObject;
      
      private var splashImageWidth:Number;
      
      private var splashImageHeight:Number;
      
      private var SplashImageClass:Class;
      
      private var dynamicSourceAttempted:Boolean = false;
      
      private var dynamicSource:SplashScreenImage;
      
      private var info:Object = null;
      
      private var scaleMode:String = "none";
      
      private var minimumDisplayTime:Number = 1000;
      
      private var checkWaitTime:Boolean = false;
      
      private var displayTimeStart:int = -1;
      
      private var _stageHeight:Number;
      
      private var _stageWidth:Number;
      
      public function SplashScreen()
      {
         super();
      }
      
      public function get backgroundAlpha() : Number
      {
         return 0;
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
      }
      
      public function get backgroundColor() : uint
      {
         return 0;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
      }
      
      public function get backgroundImage() : Object
      {
         return null;
      }
      
      public function set backgroundImage(param1:Object) : void
      {
      }
      
      public function get backgroundSize() : String
      {
         return null;
      }
      
      public function set backgroundSize(param1:String) : void
      {
      }
      
      public function set preloader(param1:Sprite) : void
      {
         param1.addEventListener(FlexEvent.INIT_COMPLETE,this.preloader_initCompleteHandler,false,0,true);
      }
      
      public function get stageHeight() : Number
      {
         return this._stageHeight;
      }
      
      public function set stageHeight(param1:Number) : void
      {
         this._stageHeight = param1;
      }
      
      public function get stageWidth() : Number
      {
         return this._stageWidth;
      }
      
      public function set stageWidth(param1:Number) : void
      {
         this._stageWidth = param1;
      }
      
      public function initialize() : void
      {
         var _loc1_:SystemManager = this.parent.loaderInfo.content as SystemManager;
         if(!_loc1_)
         {
            return;
         }
         this.info = _loc1_.info();
         if(!this.info)
         {
            return;
         }
         this.stage.addEventListener(Event.RESIZE,this.Stage_resizeHandler,false,0,true);
      }
      
      mx_internal function getImageClass(param1:String, param2:Number, param3:Number) : Class
      {
         var _loc4_:Class = null;
         if(!this.dynamicSource)
         {
            _loc4_ = this.info["splashScreenImage"];
            if(_loc4_ && !this.dynamicSourceAttempted)
            {
               this.dynamicSourceAttempted = true;
               this.dynamicSource = new _loc4_() as SplashScreenImage;
            }
         }
         return !!this.dynamicSource?this.dynamicSource.getImageClass(param1,param2,param3):_loc4_;
      }
      
      private function prepareSplashScreen() : void
      {
         var _loc1_:RuntimeDPIProvider = "runtimeDPIProvider" in this.info?new this.info["runtimeDPIProvider"]():new RuntimeDPIProvider();
         var _loc2_:Number = _loc1_.runtimeDPI;
         var _loc3_:String = stage.stageWidth < stage.stageHeight?StageAspectRatio.PORTRAIT:StageAspectRatio.LANDSCAPE;
         var _loc4_:Class = this.getImageClass(_loc3_,_loc2_,Math.max(stage.stageWidth,stage.stageHeight));
         if(_loc4_ && _loc4_ != this.SplashImageClass)
         {
            if(!this.SplashImageClass)
            {
               if("splashScreenScaleMode" in this.info)
               {
                  this.scaleMode = this.info["splashScreenScaleMode"];
               }
               if("splashScreenMinimumDisplayTime" in this.info)
               {
                  this.minimumDisplayTime = this.info["splashScreenMinimumDisplayTime"];
               }
               this.checkWaitTime = this.minimumDisplayTime > 0;
               if(this.checkWaitTime)
               {
                  this.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               }
            }
            this.SplashImageClass = _loc4_;
            if(this.splashImage)
            {
               removeChild(this.splashImage);
            }
            this.splashImage = new this.SplashImageClass();
            this.splashImageWidth = this.splashImage.width;
            this.splashImageHeight = this.splashImage.height;
            addChildAt(this.splashImage as DisplayObject,0);
         }
      }
      
      private function get currentDisplayTime() : int
      {
         if(-1 == this.displayTimeStart)
         {
            return -1;
         }
         return getTimer() - this.displayTimeStart;
      }
      
      private function Stage_resizeHandler(param1:Event) : void
      {
         this.prepareSplashScreen();
         if(!this.splashImage)
         {
            return;
         }
         var _loc2_:String = stage.orientation;
         var _loc3_:Number = this.root.scaleX;
         var _loc4_:Number = stage.stageWidth / _loc3_;
         var _loc5_:Number = stage.stageHeight / _loc3_;
         var _loc6_:Number = this.splashImageWidth;
         var _loc7_:Number = this.splashImageHeight;
         var _loc8_:Matrix = new Matrix();
         var _loc9_:Number = 1;
         var _loc10_:Number = 1;
         switch(this.scaleMode)
         {
            case "zoom":
               _loc9_ = Math.max(_loc4_ / _loc6_,_loc5_ / _loc7_);
               _loc10_ = _loc9_;
               break;
            case "letterbox":
               _loc9_ = Math.min(_loc4_ / _loc6_,_loc5_ / _loc7_);
               _loc10_ = _loc9_;
               break;
            case "stretch":
               _loc9_ = _loc4_ / _loc6_;
               _loc10_ = _loc5_ / _loc7_;
               break;
            case "none":
               if(this.dynamicSource)
               {
                  _loc9_ = 1 / _loc3_;
                  _loc10_ = 1 / _loc3_;
               }
         }
         if(_loc9_ != 1 || _loc10_ != 1)
         {
            _loc6_ = _loc6_ * _loc9_;
            _loc7_ = _loc7_ * _loc10_;
            _loc8_.scale(_loc9_,_loc10_);
         }
         _loc8_.translate(-_loc6_ / 2,-_loc7_ / 2);
         _loc8_.translate(_loc4_ / 2,_loc5_ / 2);
         this.splashImage.transform.matrix = _loc8_;
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         this.displayTimeStart = getTimer();
         this.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function preloader_initCompleteHandler(param1:Event) : void
      {
         if(this.checkWaitTime && this.currentDisplayTime < this.minimumDisplayTime)
         {
            this.addEventListener(Event.ENTER_FRAME,this.initCompleteEnterFrameHandler);
         }
         else
         {
            this.dispatchComplete();
         }
      }
      
      private function initCompleteEnterFrameHandler(param1:Event) : void
      {
         if(this.currentDisplayTime <= this.minimumDisplayTime)
         {
            return;
         }
         this.dispatchComplete();
      }
      
      private function dispatchComplete() : void
      {
         var _loc1_:Preloader = this.parent as Preloader;
         _loc1_.removeEventListener(FlexEvent.INIT_COMPLETE,this.preloader_initCompleteHandler,false);
         this.removeEventListener(Event.ENTER_FRAME,this.initCompleteEnterFrameHandler);
         this.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.stage.removeEventListener(Event.RESIZE,this.Stage_resizeHandler,false);
         this.stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE,this.Stage_resizeHandler,false);
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
