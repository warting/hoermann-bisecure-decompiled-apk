package me.mweber.views
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.LocationChangeEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.StageWebView;
   import mx.core.FlexGlobals;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   
   public class WebView extends UIComponent
   {
       
      
      private var wrappedContent:String;
      
      public var htmlWrapper:String = "<!DOCTYPE HTML><html><body>[content]</body></html>";
      
      private var _1438492469autoLoad:Boolean = true;
      
      private var _content:String;
      
      private var _1381097348isSnapshotVisible:Boolean;
      
      public var snapshotBitmapData:BitmapData;
      
      public var webViewBitmap:Bitmap;
      
      private var _webView:StageWebView;
      
      private var _source:String;
      
      public var navigationSupport:Boolean;
      
      public var addKeyHandlerToStage:Boolean;
      
      public var backKeyCode:int = 16777238;
      
      public var forwardKeyCode:int = 16777247;
      
      private var contentChanged:Boolean;
      
      private var _mimeType:String = "text/html";
      
      private var sourceChanged:Boolean;
      
      public function WebView()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      public function assignFocus(param1:String = "none") : void
      {
         this.webView.assignFocus(param1);
      }
      
      public function dispose() : void
      {
         this.webView.dispose();
      }
      
      public function hideWebView() : void
      {
         this.webView.stage = null;
      }
      
      public function showWebView() : void
      {
         this.webView.stage = stage;
      }
      
      public function load(param1:String = "") : void
      {
         if(param1)
         {
            this.webView.loadURL(param1);
            this._source = param1;
         }
         else if(this.source)
         {
            this.webView.loadURL(this.source);
         }
      }
      
      public function loadString(param1:String, param2:String = "text/html") : void
      {
         this.content = param1;
         if(this.webView)
         {
            if(param1 && param1.indexOf("<html") >= 0)
            {
               this.webView.loadString(param1,param2);
            }
            else
            {
               this.wrappedContent = this.htmlWrapper.replace("[content]",param1 || "");
               this.webView.loadString(this.wrappedContent,param2);
            }
         }
      }
      
      public function drawViewPortToBitmapData(param1:BitmapData) : void
      {
         this.webView.drawViewPortToBitmapData(param1);
      }
      
      public function takeSnapshot() : BitmapData
      {
         this.destroySnapshot();
         this.snapshotBitmapData = new BitmapData(unscaledWidth,unscaledHeight);
         this.webView.drawViewPortToBitmapData(this.snapshotBitmapData);
         this.webViewBitmap = new Bitmap(this.snapshotBitmapData);
         addChild(this.webViewBitmap);
         this.hideWebView();
         this.isSnapshotVisible = true;
         return this.snapshotBitmapData;
      }
      
      public function removeSnapshot() : void
      {
         this.destroySnapshot();
         this.showWebView();
      }
      
      private function destroySnapshot() : void
      {
         if(this.webViewBitmap)
         {
            if(this.webViewBitmap.parent)
            {
               removeChild(this.webViewBitmap);
            }
            if(this.webViewBitmap.bitmapData)
            {
               this.webViewBitmap.bitmapData.dispose();
            }
            this.webViewBitmap = null;
         }
         if(this.snapshotBitmapData)
         {
            this.snapshotBitmapData.dispose();
            this.snapshotBitmapData = null;
         }
         this.isSnapshotVisible = false;
      }
      
      public function historyBack() : void
      {
         this.webView.historyBack();
      }
      
      public function historyForward() : void
      {
         this.webView.historyForward();
      }
      
      public function reload() : void
      {
         this.webView.reload();
      }
      
      public function stop() : void
      {
         this.webView.stop();
      }
      
      private function set _951530617content(param1:String) : void
      {
         this._content = param1;
         this.contentChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get snapshotMode() : Boolean
      {
         return this.isSnapshotVisible;
      }
      
      public function set snapshotMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.takeSnapshot();
         }
         else
         {
            this.removeSnapshot();
         }
      }
      
      public function get webView() : StageWebView
      {
         return this._webView;
      }
      
      private function set _1223471129webView(param1:StageWebView) : void
      {
         this._webView = param1;
         if(!this._webView.stage && stage)
         {
            this._webView.stage = stage;
         }
      }
      
      public function get source() : String
      {
         return this._source;
      }
      
      private function set _896505829source(param1:String) : void
      {
         this._source = param1;
         this.sourceChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      public function get mimeType() : String
      {
         return this._mimeType;
      }
      
      public function set mimeType(param1:String) : void
      {
         this._mimeType = param1;
      }
      
      public function get viewPort() : Rectangle
      {
         return !!this.webView?this.webView.viewPort:null;
      }
      
      public function get title() : String
      {
         return !!this.webView?this.webView.title:null;
      }
      
      public function get isHistoryBackEnabled() : Boolean
      {
         return !!this.webView?Boolean(this.webView.isHistoryBackEnabled):false;
      }
      
      public function get isHistoryForwardEnabled() : Boolean
      {
         return !!this.webView?Boolean(this.webView.isHistoryForwardEnabled):false;
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = 480;
         measuredMinWidth = 120;
         measuredHeight = 320;
         measuredMinHeight = 160;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.webView)
         {
            this.webView = new StageWebView();
            this.webView.addEventListener(Event.COMPLETE,this.completeHandler);
            this.webView.addEventListener(ErrorEvent.ERROR,this.errorHandler);
            this.webView.addEventListener(FocusEvent.FOCUS_IN,this.focusInViewHandler);
            this.webView.addEventListener(FocusEvent.FOCUS_OUT,this.focusOutViewHandler);
            this.webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING,this.locationChangingHandler);
            this.webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,this.locationChangeHandler);
            if(this.autoLoad && this.source)
            {
               this.webView.loadURL(this.source);
            }
            else if(this.content)
            {
               this.webView.loadString(this.content,this.mimeType);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.contentChanged)
         {
            if(this._content && this._content.indexOf("<html") >= 0)
            {
               this.webView.loadString(this._content,this.mimeType);
            }
            else
            {
               this.wrappedContent = this.htmlWrapper.replace("[content]",this._content || "");
               this.webView.loadString(this.wrappedContent,this.mimeType);
            }
            this.contentChanged = false;
         }
         if(this.sourceChanged)
         {
            if(this.autoLoad)
            {
               this.webView.loadURL(this.source);
            }
            this.sourceChanged = false;
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = null;
         super.updateDisplayList(param1,param2);
         if(this.webView)
         {
            _loc3_ = localToGlobal(new Point());
            this.resizeWebView(new Rectangle(_loc3_.x,_loc3_.y,param1,param2));
         }
      }
      
      private function resizeWebView(param1:Rectangle) : void
      {
         var _loc2_:Number = FlexGlobals.topLevelApplication.runtimeDPI / FlexGlobals.topLevelApplication.applicationDPI;
         if(this.webView != null)
         {
            this.webView.viewPort = new Rectangle(param1.x,param1.y,width * _loc2_,height * _loc2_);
         }
      }
      
      public function addedToStageHandler(param1:Event) : void
      {
         if(this.webView)
         {
            this.webView.stage = stage;
         }
         invalidateDisplayList();
         if(this.navigationSupport && this.addKeyHandlerToStage)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         }
      }
      
      protected function removedFromStageHandler(param1:Event) : void
      {
         this.destroySnapshot();
         this.hideWebView();
         if(this.navigationSupport && this.addKeyHandlerToStage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         }
      }
      
      protected function focusInViewHandler(param1:FocusEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      protected function focusOutViewHandler(param1:FocusEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.navigationSupport)
         {
            if(param1.keyCode == this.backKeyCode && this.webView.isHistoryBackEnabled)
            {
               this.webView.historyBack();
               param1.preventDefault();
            }
            if(this.navigationSupport && param1.keyCode == this.forwardKeyCode && this.webView.isHistoryForwardEnabled)
            {
               this.webView.historyForward();
            }
         }
      }
      
      protected function completeHandler(param1:Event) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      protected function locationChangingHandler(param1:Event) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      protected function locationChangeHandler(param1:Event) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      protected function errorHandler(param1:ErrorEvent) : void
      {
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get autoLoad() : Boolean
      {
         return this._1438492469autoLoad;
      }
      
      public function set autoLoad(param1:Boolean) : void
      {
         var _loc2_:Object = this._1438492469autoLoad;
         if(_loc2_ !== param1)
         {
            this._1438492469autoLoad = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"autoLoad",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set content(param1:String) : void
      {
         var _loc2_:Object = this.content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isSnapshotVisible() : Boolean
      {
         return this._1381097348isSnapshotVisible;
      }
      
      public function set isSnapshotVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1381097348isSnapshotVisible;
         if(_loc2_ !== param1)
         {
            this._1381097348isSnapshotVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSnapshotVisible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set webView(param1:StageWebView) : void
      {
         var _loc2_:Object = this.webView;
         if(_loc2_ !== param1)
         {
            this._1223471129webView = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"webView",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set source(param1:String) : void
      {
         var _loc2_:Object = this.source;
         if(_loc2_ !== param1)
         {
            this._896505829source = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"source",_loc2_,param1));
            }
         }
      }
   }
}
