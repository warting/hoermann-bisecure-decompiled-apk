package flashx.textLayout.events
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.Dictionary;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.elements.TextRange;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.tlf_internal;
   import flashx.textLayout.utils.GeometryUtil;
   import flashx.textLayout.utils.HitTestArea;
   
   use namespace tlf_internal;
   
   public class FlowElementMouseEventManager
   {
       
      
      private var _container:DisplayObjectContainer;
      
      private var _hitTests:HitTestArea = null;
      
      private var _currentElement:FlowElement = null;
      
      private var _mouseDownElement:FlowElement = null;
      
      private var _needsCtrlKey:Boolean = false;
      
      private var _ctrlKeyState:Boolean = false;
      
      private var _lastMouseEvent:MouseEvent = null;
      
      private var _blockInteraction:Boolean = false;
      
      private const OWNER_HANDLES_EVENT:int = 0;
      
      private const THIS_HANDLES_EVENT:int = 1;
      
      private const THIS_LISTENS_FOR_EVENTS:int = 2;
      
      private var _eventListeners:Object;
      
      private var _hitRects:Object = null;
      
      public function FlowElementMouseEventManager(param1:DisplayObjectContainer, param2:Array)
      {
         var _loc3_:String = null;
         super();
         this._container = param1;
         this._eventListeners = {};
         this._eventListeners[MouseEvent.MOUSE_OVER] = this._eventListeners[MouseEvent.MOUSE_OUT] = this._eventListeners[MouseEvent.MOUSE_DOWN] = this._eventListeners[MouseEvent.MOUSE_UP] = this._eventListeners[MouseEvent.MOUSE_MOVE] = this._eventListeners[KeyboardEvent.KEY_DOWN] = this._eventListeners[KeyboardEvent.KEY_UP] = this.THIS_HANDLES_EVENT;
         for each(_loc3_ in param2)
         {
            this._eventListeners[_loc3_] = this.OWNER_HANDLES_EVENT;
         }
      }
      
      public function mouseToContainer(param1:MouseEvent) : Point
      {
         var _loc4_:Matrix = null;
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         var _loc3_:Point = new Point(param1.localX,param1.localY);
         while(_loc2_ != this._container)
         {
            _loc4_ = _loc2_.transform.matrix;
            _loc3_.offset(_loc4_.tx,_loc4_.ty);
            _loc2_ = _loc2_.parent;
            if(!_loc2_)
            {
               break;
            }
         }
         return _loc3_;
      }
      
      public function get needsCtrlKey() : Boolean
      {
         return this._needsCtrlKey;
      }
      
      public function set needsCtrlKey(param1:Boolean) : void
      {
         this._needsCtrlKey = param1;
      }
      
      public function updateHitTests(param1:Number, param2:Rectangle, param3:TextFlow, param4:int, param5:int, param6:ContainerController, param7:Boolean = false) : void
      {
         var _loc8_:Rectangle = null;
         var _loc9_:Object = null;
         var _loc11_:Object = null;
         var _loc13_:Dictionary = null;
         var _loc14_:Object = null;
         var _loc15_:FlowElement = null;
         var _loc16_:Array = null;
         var _loc17_:FlowElement = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:TextFlow = null;
         var _loc21_:Array = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:String = null;
         var _loc25_:Boolean = false;
         var _loc26_:Number = NaN;
         var _loc27_:String = null;
         var _loc28_:Object = null;
         this._needsCtrlKey = param7;
         var _loc10_:Array = [];
         if(param3.interactiveObjectCount != 0 && param4 != param5)
         {
            _loc13_ = param6.interactiveObjects;
            for each(_loc14_ in _loc13_)
            {
               _loc15_ = _loc14_ as FlowElement;
               if(_loc15_ && _loc15_.getAbsoluteStart() < param5 && _loc15_.getAbsoluteStart() + _loc15_.textLength >= param4)
               {
                  _loc10_.push(_loc14_);
               }
            }
            _loc16_ = param6.oldInteractiveObjects;
            for each(_loc14_ in _loc16_)
            {
               _loc15_ = _loc14_ as FlowElement;
               if(_loc15_ && _loc15_.getAbsoluteStart() < param5 && _loc15_.getAbsoluteStart() + _loc15_.textLength >= param4)
               {
                  _loc10_.push(_loc14_);
                  _loc13_[_loc14_] = _loc14_;
               }
            }
         }
         var _loc12_:int = 0;
         if(_loc10_.length != 0)
         {
            _loc11_ = {};
            for each(_loc17_ in _loc10_)
            {
               _loc18_ = _loc17_.getAbsoluteStart();
               _loc19_ = Math.min(_loc18_ + _loc17_.textLength,param5);
               _loc20_ = _loc17_.getTextFlow();
               if(_loc20_)
               {
                  _loc21_ = GeometryUtil.getHighlightBounds(new TextRange(_loc20_,_loc18_,_loc19_));
                  for each(_loc9_ in _loc21_)
                  {
                     _loc8_ = _loc9_.rect;
                     _loc22_ = param2.x;
                     _loc23_ = param2.y;
                     _loc24_ = _loc17_.computedFormat.blockProgression;
                     _loc25_ = false;
                     _loc25_ = _loc24_ == BlockProgression.RL && (param6.horizontalScrollPolicy == ScrollPolicy.OFF && param6.verticalScrollPolicy == ScrollPolicy.OFF);
                     if(_loc25_)
                     {
                        _loc26_ = !!param6.measureWidth?Number(param2.width):Number(param6.compositionWidth);
                        _loc22_ = param2.x - _loc26_ + param6.horizontalScrollPosition + param2.width;
                     }
                     if(_loc24_ == BlockProgression.TB)
                     {
                        _loc22_ = 0;
                        _loc23_ = 0;
                     }
                     else
                     {
                        _loc23_ = 0;
                     }
                     _loc8_.x = _loc22_ + _loc9_.textLine.x + _loc8_.x + param1;
                     _loc8_.y = _loc23_ + _loc9_.textLine.y + _loc8_.y;
                     _loc8_ = _loc8_.intersection(param2);
                     if(!_loc8_.isEmpty())
                     {
                        _loc8_.x = int(_loc8_.x);
                        _loc8_.y = int(_loc8_.y);
                        _loc8_.width = int(_loc8_.width);
                        _loc8_.height = int(_loc8_.height);
                        _loc27_ = _loc8_.toString();
                        _loc28_ = _loc11_[_loc27_];
                        if(!_loc28_ || _loc28_.owner != _loc17_)
                        {
                           _loc11_[_loc27_] = {
                              "rect":_loc8_,
                              "owner":_loc17_
                           };
                           _loc12_++;
                        }
                     }
                  }
               }
            }
         }
         if(_loc12_ > 0)
         {
            if(!this._hitTests)
            {
               this.startHitTests();
            }
            this._hitRects = _loc11_;
            this._hitTests = new HitTestArea(_loc11_);
         }
         else
         {
            this.stopHitTests();
         }
      }
      
      tlf_internal function startHitTests() : void
      {
         this._currentElement = null;
         this._mouseDownElement = null;
         this._ctrlKeyState = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,false);
         this.addEventListener(MouseEvent.MOUSE_OUT,false);
         this.addEventListener(MouseEvent.MOUSE_DOWN,false);
         this.addEventListener(MouseEvent.MOUSE_UP,false);
         this.addEventListener(MouseEvent.MOUSE_MOVE,false);
      }
      
      public function stopHitTests() : void
      {
         this.removeEventListener(MouseEvent.MOUSE_OVER,false);
         this.removeEventListener(MouseEvent.MOUSE_OUT,false);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,false);
         this.removeEventListener(MouseEvent.MOUSE_UP,false);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,false);
         this.removeEventListener(KeyboardEvent.KEY_DOWN,true);
         this.removeEventListener(KeyboardEvent.KEY_UP,true);
         this._hitRects = null;
         this._hitTests = null;
         this._currentElement = null;
         this._mouseDownElement = null;
         this._ctrlKeyState = false;
      }
      
      private function addEventListener(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:Function = null;
         if(this._eventListeners[param1] === this.THIS_HANDLES_EVENT)
         {
            if(param2)
            {
               _loc3_ = this._container.stage;
               if(!_loc3_)
               {
                  _loc3_ = this._container;
               }
               _loc4_ = this.hitTestKeyEventHandler;
            }
            else
            {
               _loc3_ = this._container;
               _loc4_ = this.hitTestMouseEventHandler;
            }
            _loc3_.addEventListener(param1,_loc4_,false,1);
            this._eventListeners[param1] = this.THIS_LISTENS_FOR_EVENTS;
         }
      }
      
      private function removeEventListener(param1:String, param2:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:Function = null;
         if(this._eventListeners[param1] === this.THIS_LISTENS_FOR_EVENTS)
         {
            if(param2)
            {
               _loc3_ = this._container.stage;
               if(!_loc3_)
               {
                  _loc3_ = this._container;
               }
               _loc4_ = this.hitTestKeyEventHandler;
            }
            else
            {
               _loc3_ = this._container;
               _loc4_ = this.hitTestMouseEventHandler;
            }
            _loc3_.removeEventListener(param1,_loc4_);
            this._eventListeners[param1] = this.THIS_HANDLES_EVENT;
         }
      }
      
      tlf_internal function collectElements(param1:FlowGroupElement, param2:int, param3:int, param4:Array) : void
      {
         var _loc6_:FlowElement = null;
         var _loc7_:FlowGroupElement = null;
         var _loc5_:int = param1.findChildIndexAtPosition(param2);
         while(_loc5_ < param1.numChildren)
         {
            _loc6_ = param1.getChildAt(_loc5_);
            if(_loc6_.parentRelativeStart >= param3)
            {
               break;
            }
            if(_loc6_.hasActiveEventMirror() || _loc6_ is LinkElement)
            {
               param4.push(_loc6_);
            }
            _loc7_ = _loc6_ as FlowGroupElement;
            if(_loc7_)
            {
               this.collectElements(_loc7_,Math.max(param2 - _loc7_.parentRelativeStart,0),param3 - _loc7_.parentRelativeStart,param4);
            }
            _loc5_++;
         }
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         var _loc3_:KeyboardEvent = null;
         var _loc2_:MouseEvent = param1 as MouseEvent;
         if(_loc2_)
         {
            this.hitTestMouseEventHandler(_loc2_);
         }
         else
         {
            _loc3_ = param1 as KeyboardEvent;
            if(_loc3_)
            {
               this.hitTestKeyEventHandler(_loc3_);
            }
         }
      }
      
      private function hitTestKeyEventHandler(param1:KeyboardEvent) : void
      {
         if(!this._blockInteraction)
         {
            this.checkCtrlKeyState(param1.ctrlKey);
         }
      }
      
      private function checkCtrlKeyState(param1:Boolean) : void
      {
         var _loc2_:LinkElement = this._currentElement as LinkElement;
         if(!_loc2_ || !this._needsCtrlKey || !this._lastMouseEvent || param1 == this._ctrlKeyState)
         {
            return;
         }
         this._ctrlKeyState = param1;
         if(this._ctrlKeyState)
         {
            _loc2_.mouseOverHandler(this,this._lastMouseEvent);
         }
         else
         {
            _loc2_.mouseOutHandler(this,this._lastMouseEvent);
         }
      }
      
      private function hitTestMouseEventHandler(param1:MouseEvent) : void
      {
         if(!this._hitTests)
         {
            return;
         }
         this._lastMouseEvent = param1;
         var _loc2_:Point = this.mouseToContainer(param1);
         var _loc3_:FlowElement = this._hitTests.hitTest(_loc2_.x,_loc2_.y);
         if(_loc3_ != this._currentElement)
         {
            this._mouseDownElement = null;
            if(this._currentElement)
            {
               this.localDispatchEvent(FlowElementMouseEvent.ROLL_OUT,param1);
            }
            else if(param1.buttonDown)
            {
               this._blockInteraction = true;
            }
            this._currentElement = _loc3_;
            if(this._currentElement)
            {
               this.localDispatchEvent(FlowElementMouseEvent.ROLL_OVER,param1);
            }
            else
            {
               this._blockInteraction = false;
            }
         }
         var _loc4_:* = false;
         var _loc5_:String = null;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_MOVE:
               _loc5_ = FlowElementMouseEvent.MOUSE_MOVE;
               if(!this._blockInteraction)
               {
                  this.checkCtrlKeyState(param1.ctrlKey);
               }
               break;
            case MouseEvent.MOUSE_DOWN:
               this._mouseDownElement = this._currentElement;
               _loc5_ = FlowElementMouseEvent.MOUSE_DOWN;
               break;
            case MouseEvent.MOUSE_UP:
               _loc5_ = FlowElementMouseEvent.MOUSE_UP;
               _loc4_ = this._currentElement == this._mouseDownElement;
               this._mouseDownElement = null;
         }
         if(this._currentElement && _loc5_)
         {
            this.localDispatchEvent(_loc5_,param1);
            if(_loc4_)
            {
               this.localDispatchEvent(FlowElementMouseEvent.CLICK,param1);
            }
         }
      }
      
      tlf_internal function dispatchFlowElementMouseEvent(param1:String, param2:MouseEvent) : Boolean
      {
         if(this._needsCtrlKey && !param2.ctrlKey && param1 != FlowElementMouseEvent.ROLL_OUT)
         {
            return false;
         }
         var _loc3_:Boolean = this._currentElement.hasActiveEventMirror();
         var _loc4_:TextFlow = this._currentElement.getTextFlow();
         var _loc5_:Boolean = false;
         if(_loc4_)
         {
            _loc5_ = _loc4_.hasEventListener(param1);
         }
         if(!_loc3_ && !_loc5_)
         {
            return false;
         }
         var _loc6_:FlowElementMouseEvent = new FlowElementMouseEvent(param1,false,true,this._currentElement,param2);
         if(_loc3_)
         {
            this._currentElement.getEventMirror().dispatchEvent(_loc6_);
            if(_loc6_.isDefaultPrevented())
            {
               return true;
            }
         }
         if(_loc5_)
         {
            _loc4_.dispatchEvent(_loc6_);
            if(_loc6_.isDefaultPrevented())
            {
               return true;
            }
         }
         return false;
      }
      
      private function localDispatchEvent(param1:String, param2:MouseEvent) : void
      {
         if(this._blockInteraction || !this._currentElement)
         {
            return;
         }
         if(this._needsCtrlKey)
         {
            switch(param1)
            {
               case FlowElementMouseEvent.ROLL_OVER:
                  this.addEventListener(KeyboardEvent.KEY_DOWN,true);
                  this.addEventListener(KeyboardEvent.KEY_UP,true);
                  break;
               case FlowElementMouseEvent.ROLL_OUT:
                  this.removeEventListener(KeyboardEvent.KEY_DOWN,true);
                  this.removeEventListener(KeyboardEvent.KEY_UP,true);
            }
         }
         if(this.dispatchFlowElementMouseEvent(param1,param2))
         {
            return;
         }
         var _loc3_:LinkElement = !this._needsCtrlKey || param2.ctrlKey?this._currentElement as LinkElement:null;
         if(!_loc3_)
         {
            return;
         }
         switch(param1)
         {
            case FlowElementMouseEvent.MOUSE_DOWN:
               _loc3_.mouseDownHandler(this,param2);
               break;
            case FlowElementMouseEvent.MOUSE_MOVE:
               _loc3_.mouseMoveHandler(this,param2);
               break;
            case FlowElementMouseEvent.ROLL_OUT:
               _loc3_.mouseOutHandler(this,param2);
               break;
            case FlowElementMouseEvent.ROLL_OVER:
               _loc3_.mouseOverHandler(this,param2);
               break;
            case FlowElementMouseEvent.MOUSE_UP:
               _loc3_.mouseUpHandler(this,param2);
               break;
            case FlowElementMouseEvent.CLICK:
               _loc3_.mouseClickHandler(this,param2);
         }
      }
      
      tlf_internal function setHandCursor(param1:Boolean = true) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:String = null;
         if(this._currentElement == null)
         {
            return;
         }
         var _loc2_:TextFlow = this._currentElement.getTextFlow();
         if(_loc2_ != null && _loc2_.flowComposer && _loc2_.flowComposer.numControllers)
         {
            _loc3_ = this._container as Sprite;
            if(_loc3_)
            {
               _loc3_.buttonMode = param1;
               _loc3_.useHandCursor = param1;
            }
            if(param1)
            {
               Mouse.cursor = MouseCursor.BUTTON;
            }
            else
            {
               _loc4_ = _loc2_.computedFormat.blockProgression;
               if(_loc2_.interactionManager && _loc4_ != BlockProgression.RL)
               {
                  Mouse.cursor = MouseCursor.IBEAM;
               }
               else
               {
                  Mouse.cursor = Configuration.getCursorString(_loc2_.configuration,MouseCursor.AUTO);
               }
            }
            Mouse.hide();
            Mouse.show();
         }
      }
   }
}
