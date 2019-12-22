package spark.skins.mobile
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import mx.core.DPIClassification;
   import spark.components.BusyIndicator;
   import spark.components.Group;
   import spark.components.Image;
   import spark.primitives.BitmapImage;
   import spark.skins.mobile.supportClasses.MobileSkin;
   import spark.skins.mobile640.assets.ImageInvalid;
   
   public class ImageSkin extends MobileSkin
   {
       
      
      public var hostComponent:Image;
      
      public var imageDisplay:BitmapImage;
      
      protected var imageHolder:Group;
      
      private var currentImage:DisplayObject;
      
      protected var imageInvalidClass:Class;
      
      private var imageInvalid:DisplayObject;
      
      protected var loadingIndicator:BusyIndicator = null;
      
      public function ImageSkin()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               this.imageInvalidClass = spark.skins.mobile640.assets.ImageInvalid;
               break;
            case DPIClassification.DPI_480:
               this.imageInvalidClass = spark.skins.mobile480.assets.ImageInvalid;
               break;
            case DPIClassification.DPI_320:
               this.imageInvalidClass = spark.skins.mobile320.assets.ImageInvalid;
               break;
            case DPIClassification.DPI_240:
               this.imageInvalidClass = spark.skins.mobile240.assets.ImageInvalid;
               break;
            case DPIClassification.DPI_120:
               this.imageInvalidClass = spark.skins.mobile120.assets.ImageInvalid;
               break;
            default:
               this.imageInvalidClass = spark.skins.mobile160.assets.ImageInvalid;
         }
      }
      
      override protected function commitCurrentState() : void
      {
         var _loc1_:Number = 1;
         if(currentState == "uninitialized")
         {
            if(this.imageInvalid)
            {
               removeChild(this.imageInvalid);
               this.imageInvalid = null;
            }
            if(this.loadingIndicator)
            {
               removeChild(this.loadingIndicator);
               this.loadingIndicator = null;
            }
            this.currentImage = null;
         }
         else if(currentState == "loading")
         {
            if(this.imageInvalid)
            {
               removeChild(this.imageInvalid);
               this.imageInvalid = null;
            }
            if(!this.loadingIndicator)
            {
               this.loadingIndicator = new BusyIndicator();
               addChild(this.loadingIndicator);
            }
            this.currentImage = this.loadingIndicator;
         }
         else if(currentState == "ready")
         {
            if(this.imageInvalid)
            {
               removeChild(this.imageInvalid);
               this.imageInvalid = null;
            }
            if(this.loadingIndicator)
            {
               removeChild(this.loadingIndicator);
               this.loadingIndicator = null;
            }
            this.currentImage = this.imageHolder;
         }
         else if(currentState == "invalid")
         {
            if(this.loadingIndicator)
            {
               removeChild(this.loadingIndicator);
               this.loadingIndicator = null;
            }
            if(!this.imageInvalid)
            {
               this.imageInvalid = new this.imageInvalidClass();
               addChild(this.imageInvalid);
            }
            this.currentImage = this.imageInvalid;
         }
         else if(currentState == "disabled")
         {
            _loc1_ = 0.5;
            if(this.imageInvalid)
            {
               removeChild(this.imageInvalid);
               this.imageInvalid = null;
            }
            if(this.loadingIndicator)
            {
               removeChild(this.loadingIndicator);
               this.loadingIndicator = null;
            }
            this.currentImage = this.imageHolder;
         }
         alpha = _loc1_;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function createChildren() : void
      {
         this.imageHolder = new Group();
         addChild(this.imageHolder);
         this.imageDisplay = new BitmapImage();
         this.imageDisplay.left = 0;
         this.imageDisplay.right = 0;
         this.imageDisplay.top = 0;
         this.imageDisplay.bottom = 0;
         this.imageHolder.addElement(this.imageDisplay);
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.currentImage)
         {
            measuredHeight = getElementPreferredHeight(this.currentImage);
            measuredWidth = getElementPreferredWidth(this.currentImage);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.updateDisplayList(param1,param2);
         if(this.loadingIndicator && this.currentImage == this.loadingIndicator)
         {
            _loc3_ = this.loadingIndicator.getPreferredBoundsWidth();
            _loc4_ = this.loadingIndicator.getPreferredBoundsHeight();
            setElementSize(this.loadingIndicator,Math.min(param1,_loc3_),Math.min(param2,_loc4_));
            setElementPosition(this.loadingIndicator,Math.max((param1 - _loc3_) / 2,0),Math.max((param2 - _loc4_) / 2,0));
         }
         else if(this.imageInvalid && this.currentImage == this.imageInvalid)
         {
            _loc3_ = getElementPreferredWidth(this.imageInvalid);
            _loc4_ = getElementPreferredHeight(this.imageInvalid);
            setElementSize(this.imageInvalid,Math.min(_loc3_,param1),Math.min(_loc4_,param2));
            setElementPosition(this.imageInvalid,Math.max((param1 - _loc3_) / 2,0),Math.max((param2 - _loc4_) / 2,0));
         }
         else if(this.currentImage == this.imageHolder)
         {
            setElementSize(this.imageHolder,param1,param2);
         }
         var _loc5_:Graphics = graphics;
         _loc5_.clear();
         if(!isNaN(getStyle("backgroundColor")))
         {
            _loc5_.beginFill(getStyle("backgroundColor"),getStyle("backgroundAlpha"));
            _loc5_.drawRect(0,0,param1,param2);
         }
      }
   }
}
