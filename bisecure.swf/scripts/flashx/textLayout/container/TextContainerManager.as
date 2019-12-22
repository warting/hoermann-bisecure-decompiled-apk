package flashx.textLayout.container
{
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.IMEEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextLine;
   import flash.text.engine.TextLineValidity;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuClipboardItems;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.BaseCompose;
   import flashx.textLayout.compose.ISWFContext;
   import flashx.textLayout.compose.SimpleCompose;
   import flashx.textLayout.compose.StandardFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.compose.TextLineRecycler;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.IEditManager;
   import flashx.textLayout.edit.IInteractionEventHandler;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.DamageEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.SelectionEvent;
   import flashx.textLayout.events.StatusChangeEvent;
   import flashx.textLayout.events.TextLayoutEvent;
   import flashx.textLayout.events.UpdateCompleteEvent;
   import flashx.textLayout.factory.StringTextLineFactory;
   import flashx.textLayout.factory.TextLineFactoryBase;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.property.Property;
   import flashx.textLayout.tlf_internal;
   import flashx.undo.IUndoManager;
   import flashx.undo.UndoManager;
   
   use namespace tlf_internal;
   
   public class TextContainerManager extends EventDispatcher implements ISWFContext, IInteractionEventHandler, ISandboxSupport
   {
      
      private static const eventList:Array = [FlowOperationEvent.FLOW_OPERATION_BEGIN,FlowOperationEvent.FLOW_OPERATION_END,FlowOperationEvent.FLOW_OPERATION_COMPLETE,SelectionEvent.SELECTION_CHANGE,CompositionCompleteEvent.COMPOSITION_COMPLETE,MouseEvent.CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_OUT,StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,TextLayoutEvent.SCROLL,DamageEvent.DAMAGE,UpdateCompleteEvent.UPDATE_COMPLETE];
      
      private static var _defaultConfiguration:IConfiguration = null;
      
      private static var _inputManagerTextFlowFactory:TCMTextFlowTextLineFactory;
      
      private static var stringFactoryDictionary:Dictionary;
      
      tlf_internal static const editingModePropertyDefinition:Property = Property.NewEnumStringProperty("editingMode",EditingMode.READ_WRITE,false,null,EditingMode.READ_WRITE,EditingMode.READ_ONLY,EditingMode.READ_SELECT);
      
      tlf_internal static const SOURCE_STRING:int = 0;
      
      tlf_internal static const SOURCE_TEXTFLOW:int = 1;
      
      tlf_internal static const COMPOSE_FACTORY:int = 0;
      
      tlf_internal static const COMPOSE_COMPOSER:int = 1;
      
      tlf_internal static const HANDLERS_NOTADDED:int = 0;
      
      tlf_internal static const HANDLERS_NONE:int = 1;
      
      tlf_internal static const HANDLERS_CREATION:int = 2;
      
      tlf_internal static const HANDLERS_ACTIVE:int = 3;
      
      tlf_internal static const HANDLERS_MOUSEWHEEL:int = 4;
      
      private static var _expectedFactoryCompose:SimpleCompose;
       
      
      private var _container:Sprite;
      
      private var _compositionWidth:Number;
      
      private var _compositionHeight:Number;
      
      private var _text:String;
      
      private var _textDamaged:Boolean;
      
      private var _lastSeparator:String;
      
      private var _hostFormat:ITextLayoutFormat;
      
      private var _stringFactoryTextFlowFormat:ITextLayoutFormat;
      
      private var _contentTop:Number;
      
      private var _contentLeft:Number;
      
      private var _contentHeight:Number;
      
      private var _contentWidth:Number;
      
      private var _horizontalScrollPolicy:String;
      
      private var _verticalScrollPolicy:String;
      
      private var _swfContext:ISWFContext;
      
      private var _config:IConfiguration;
      
      private var _preserveSelectionOnSetText:Boolean = false;
      
      private var _sourceState:int;
      
      private var _composeState:int;
      
      private var _handlersState:int;
      
      private var _hasFocus:Boolean;
      
      private var _editingMode:String;
      
      private var _ibeamCursorSet:Boolean;
      
      private var _interactionCount:int;
      
      private var _damaged:Boolean;
      
      private var _textFlow:TextFlow;
      
      private var _needsRedraw:Boolean;
      
      tlf_internal var _composedLines:Array;
      
      private var _composeRecycledInPlaceLines:int;
      
      private var _composePushedLines:int;
      
      private var _contextMenu;
      
      private var _hasScrollRect:Boolean = false;
      
      public function TextContainerManager(param1:Sprite, param2:IConfiguration = null)
      {
         this._composedLines = [];
         super();
         this._container = param1;
         this._compositionWidth = 100;
         this._compositionHeight = 100;
         this._config = !!param2?customizeConfiguration(param2):defaultConfiguration;
         this._config = (this._config as Configuration).getImmutableClone();
         this._horizontalScrollPolicy = this._verticalScrollPolicy = String(ScrollPolicy.scrollPolicyPropertyDefinition.defaultValue);
         this._damaged = true;
         this._needsRedraw = false;
         this._text = "";
         this._textDamaged = false;
         this._sourceState = SOURCE_STRING;
         this._composeState = COMPOSE_FACTORY;
         this._handlersState = HANDLERS_NOTADDED;
         this._hasFocus = false;
         this._editingMode = editingModePropertyDefinition.defaultValue as String;
         this._ibeamCursorSet = false;
         this._interactionCount = 0;
         if(this._container is InteractiveObject)
         {
            this._container.doubleClickEnabled = true;
            this._container.mouseChildren = false;
            this._container.focusRect = false;
         }
      }
      
      public static function get defaultConfiguration() : IConfiguration
      {
         if(_defaultConfiguration == null)
         {
            _defaultConfiguration = customizeConfiguration(null);
         }
         return _defaultConfiguration;
      }
      
      tlf_internal static function customizeConfiguration(param1:IConfiguration) : IConfiguration
      {
         var _loc2_:Configuration = null;
         if(param1)
         {
            if(param1.flowComposerClass == TextLineFactoryBase.getDefaultFlowComposerClass())
            {
               return param1;
            }
            _loc2_ = (param1 as Configuration).clone();
         }
         else
         {
            _loc2_ = new Configuration();
         }
         _loc2_.flowComposerClass = TextLineFactoryBase.getDefaultFlowComposerClass();
         return _loc2_;
      }
      
      private static function inputManagerTextFlowFactory() : TCMTextFlowTextLineFactory
      {
         if(!_inputManagerTextFlowFactory)
         {
            _inputManagerTextFlowFactory = new TCMTextFlowTextLineFactory();
         }
         return _inputManagerTextFlowFactory;
      }
      
      private static function inputManagerStringFactory(param1:IConfiguration) : StringTextLineFactory
      {
         if(!stringFactoryDictionary)
         {
            stringFactoryDictionary = new Dictionary(true);
         }
         var _loc2_:StringTextLineFactory = stringFactoryDictionary[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new StringTextLineFactory(param1);
            stringFactoryDictionary[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      tlf_internal static function releaseReferences() : void
      {
         stringFactoryDictionary = null;
         _inputManagerTextFlowFactory = null;
      }
      
      tlf_internal function get sourceState() : int
      {
         return this._sourceState;
      }
      
      tlf_internal function get composeState() : int
      {
         return this._composeState;
      }
      
      tlf_internal function get handlersState() : int
      {
         return this._handlersState;
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function isDamaged() : Boolean
      {
         return this._composeState == COMPOSE_FACTORY?Boolean(this._damaged):Boolean(this._textFlow.flowComposer.isPotentiallyDamaged(this._textFlow.textLength));
      }
      
      public function get editingMode() : String
      {
         return this._editingMode;
      }
      
      public function set editingMode(param1:String) : void
      {
         var _loc2_:String = editingModePropertyDefinition.setHelper(this._editingMode,param1) as String;
         if(_loc2_ != this._editingMode)
         {
            if(this.composeState == COMPOSE_COMPOSER)
            {
               this._editingMode = _loc2_;
               this.invalidateInteractionManager();
            }
            else
            {
               this.removeActivationEventListeners();
               this._editingMode = _loc2_;
               if(this._editingMode == EditingMode.READ_ONLY)
               {
                  this.removeIBeamCursor();
               }
               this.addActivationEventListeners();
            }
         }
      }
      
      public function getText(param1:String = " ") : String
      {
         var _loc2_:FlowLeafElement = null;
         var _loc3_:ParagraphElement = null;
         var _loc4_:ParagraphElement = null;
         if(this._sourceState == SOURCE_STRING)
         {
            return this._text;
         }
         if(this._textDamaged || this._lastSeparator != param1)
         {
            this._text = "";
            _loc2_ = this._textFlow.getFirstLeaf();
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getParagraph();
               while(_loc3_)
               {
                  _loc4_ = _loc3_.getNextParagraph();
                  this._text = this._text + _loc3_.getText();
                  this._text = this._text + (!!_loc4_?param1:"");
                  _loc3_ = _loc4_;
               }
            }
            this._textDamaged = false;
            this._lastSeparator = param1;
         }
         return this._text;
      }
      
      public function setText(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:SelectionState = null;
         var _loc5_:int = -1;
         var _loc6_:int = -1;
         if(this._sourceState == SOURCE_TEXTFLOW)
         {
            if(this._textFlow.interactionManager && this._textFlow.interactionManager.hasSelection())
            {
               _loc2_ = true;
               if(this._preserveSelectionOnSetText && param1 != null)
               {
                  _loc5_ = Math.min(this._textFlow.interactionManager.anchorPosition,param1.length);
                  _loc6_ = Math.min(this._textFlow.interactionManager.activePosition,param1.length);
                  if(_loc5_ != this._textFlow.interactionManager.anchorPosition || _loc6_ != this._textFlow.interactionManager.activePosition)
                  {
                     _loc3_ = true;
                  }
               }
            }
            this.removeTextFlowListeners();
            if(this._textFlow.flowComposer)
            {
               this._textFlow.flowComposer.removeAllControllers();
            }
            this._textFlow.unloadGraphics();
            this._textFlow = null;
            this._sourceState = SOURCE_STRING;
            this._composeState = COMPOSE_FACTORY;
            if(this._container is InteractiveObject)
            {
               this._container.mouseChildren = false;
            }
            this.addActivationEventListeners();
         }
         this._text = !!param1?param1:"";
         this._damaged = true;
         this._textDamaged = false;
         if(hasEventListener(DamageEvent.DAMAGE))
         {
            this.dispatchEvent(new DamageEvent(DamageEvent.DAMAGE,false,false,null,0,this._text.length));
         }
         if(_loc2_)
         {
            if(this._preserveSelectionOnSetText)
            {
               if(this._composeState != COMPOSE_COMPOSER)
               {
                  this.convertToTextFlowWithComposer();
               }
               if(this._textFlow.interactionManager)
               {
                  this._textFlow.interactionManager.setSelectionState(new SelectionState(this._textFlow,_loc5_,_loc6_));
                  if(_loc3_)
                  {
                     this._textFlow.dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,this._textFlow.interactionManager.getSelectionState()));
                  }
               }
            }
            else if(hasEventListener(SelectionEvent.SELECTION_CHANGE))
            {
               this.dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGE,false,false,null));
            }
         }
         if(this._hasFocus)
         {
            this.requiredFocusInHandler(null);
         }
      }
      
      public function get hostFormat() : ITextLayoutFormat
      {
         return this._hostFormat;
      }
      
      public function set hostFormat(param1:ITextLayoutFormat) : void
      {
         this._hostFormat = param1;
         this._stringFactoryTextFlowFormat = null;
         if(this._sourceState == SOURCE_TEXTFLOW)
         {
            this._textFlow.hostFormat = this._hostFormat;
         }
         if(this._composeState == COMPOSE_FACTORY)
         {
            this._damaged = true;
         }
      }
      
      public function get compositionWidth() : Number
      {
         return this._compositionWidth;
      }
      
      public function set compositionWidth(param1:Number) : void
      {
         if(this._compositionWidth == param1 || isNaN(this._compositionWidth) && isNaN(param1))
         {
            return;
         }
         this._compositionWidth = param1;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().setCompositionSize(this._compositionWidth,this._compositionHeight);
         }
         else
         {
            this._damaged = true;
         }
      }
      
      public function get compositionHeight() : Number
      {
         return this._compositionHeight;
      }
      
      public function set compositionHeight(param1:Number) : void
      {
         if(this._compositionHeight == param1 || isNaN(this._compositionHeight) && isNaN(param1))
         {
            return;
         }
         this._compositionHeight = param1;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().setCompositionSize(this._compositionWidth,this._compositionHeight);
         }
         else
         {
            this._damaged = true;
         }
      }
      
      public function get configuration() : IConfiguration
      {
         return this._config;
      }
      
      public function getContentBounds() : Rectangle
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            return new Rectangle(this._contentLeft,this._contentTop,this._contentWidth,this._contentHeight);
         }
         var _loc1_:ContainerController = this.getController();
         return _loc1_.getContentBounds();
      }
      
      public function getTextFlow() : TextFlow
      {
         var _loc1_:Boolean = false;
         if(this._sourceState != SOURCE_TEXTFLOW)
         {
            _loc1_ = this.isDamaged();
            this.convertToTextFlow();
            if(!_loc1_)
            {
               this.updateContainer();
            }
         }
         return this._textFlow;
      }
      
      public function setTextFlow(param1:TextFlow) : void
      {
         var _loc2_:TMContainerController = null;
         if(param1 == this._textFlow)
         {
            return;
         }
         if(param1 == null)
         {
            this.setText(null);
            return;
         }
         if(param1.flowComposer && param1.flowComposer.numControllers > 0 && param1.flowComposer.getControllerAt(0) is TMContainerController)
         {
            _loc2_ = param1.flowComposer.getControllerAt(0) as TMContainerController;
            if(_loc2_.textContainerManager && _loc2_.textContainerManager.getTextFlow() == param1)
            {
               _loc2_.textContainerManager.setTextFlow(null);
            }
         }
         if(this._sourceState == SOURCE_TEXTFLOW)
         {
            this.removeTextFlowListeners();
            if(this._textFlow.flowComposer)
            {
               this._textFlow.flowComposer.removeAllControllers();
            }
            this._textFlow.unloadGraphics();
            this._textFlow = null;
         }
         this._textFlow = param1;
         this._textFlow.hostFormat = this.hostFormat;
         this._sourceState = SOURCE_TEXTFLOW;
         this._composeState = param1.interactionManager || param1.mustUseComposer()?int(COMPOSE_COMPOSER):int(COMPOSE_FACTORY);
         this._textDamaged = true;
         this.addTextFlowListeners();
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this._container.mouseChildren = true;
            this.clearContainerChildren(true);
            this.clearComposedLines();
            this._textFlow.flowComposer = new StandardFlowComposer();
            this._textFlow.flowComposer.swfContext = this._swfContext;
            this._textFlow.flowComposer.addController(new TMContainerController(this._container,this._compositionWidth,this._compositionHeight,this));
            this.invalidateInteractionManager();
            if(this._textFlow.interactionManager)
            {
               this._textFlow.interactionManager.selectRange(-1,-1);
            }
         }
         else
         {
            this._damaged = true;
         }
         if(this._hasFocus)
         {
            this.requiredFocusInHandler(null);
         }
         this.addActivationEventListeners();
      }
      
      public function get horizontalScrollPolicy() : String
      {
         return this._horizontalScrollPolicy;
      }
      
      public function set horizontalScrollPolicy(param1:String) : void
      {
         this._horizontalScrollPolicy = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(this._horizontalScrollPolicy,param1) as String;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().horizontalScrollPolicy = this._horizontalScrollPolicy;
         }
         else
         {
            this._damaged = true;
         }
      }
      
      public function get verticalScrollPolicy() : String
      {
         return this._verticalScrollPolicy;
      }
      
      public function set verticalScrollPolicy(param1:String) : void
      {
         this._verticalScrollPolicy = ScrollPolicy.scrollPolicyPropertyDefinition.setHelper(this._verticalScrollPolicy,param1) as String;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().verticalScrollPolicy = this._verticalScrollPolicy;
         }
         else
         {
            this._damaged = true;
         }
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._composeState == COMPOSE_COMPOSER?Number(this.getController().horizontalScrollPosition):Number(0);
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(param1 == 0 && this._composeState == COMPOSE_FACTORY)
         {
            return;
         }
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         this.getController().horizontalScrollPosition = param1;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._composeState == COMPOSE_COMPOSER?Number(this.getController().verticalScrollPosition):Number(0);
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(param1 == 0 && this._composeState == COMPOSE_FACTORY)
         {
            return;
         }
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         this.getController().verticalScrollPosition = param1;
      }
      
      public function getScrollDelta(param1:int) : Number
      {
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         return this.getController().getScrollDelta(param1);
      }
      
      public function scrollToRange(param1:int, param2:int) : void
      {
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         this.getController().scrollToRange(param1,param2);
      }
      
      public function get swfContext() : ISWFContext
      {
         return this._swfContext;
      }
      
      public function set swfContext(param1:ISWFContext) : void
      {
         this._swfContext = param1;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this._textFlow.flowComposer.swfContext = this._swfContext;
         }
         else
         {
            this._damaged = true;
         }
      }
      
      public function getBaseSWFContext() : ISWFContext
      {
         return this._swfContext;
      }
      
      public function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *
      {
         var _loc5_:TextBlock = param2 as TextBlock;
         if(_loc5_ && _expectedFactoryCompose == TextLineFactoryBase._factoryComposer)
         {
            if(param1 == _loc5_.createTextLine)
            {
               return this.createTextLine(_loc5_,param3);
            }
            if(Configuration.playerEnablesArgoFeatures && param1 == param2["recreateTextLine"])
            {
               return this.recreateTextLine(_loc5_,param3);
            }
         }
         var _loc6_:ISWFContext = !!this._swfContext?this._swfContext:BaseCompose.globalSWFContext;
         if(param4)
         {
            return _loc6_.callInContext(param1,param2,param3,param4);
         }
         _loc6_.callInContext(param1,param2,param3,param4);
      }
      
      public function resetLine(param1:TextLine) : void
      {
         if(param1 == this._composedLines[this._composeRecycledInPlaceLines - 1])
         {
            this._composeRecycledInPlaceLines--;
         }
      }
      
      private function createTextLine(param1:TextBlock, param2:Array) : TextLine
      {
         var _loc4_:TextLine = null;
         var _loc3_:ISWFContext = !!this._swfContext?this._swfContext:BaseCompose.globalSWFContext;
         if(this._composeRecycledInPlaceLines < this._composedLines.length && _expectedFactoryCompose == TextLineFactoryBase._factoryComposer)
         {
            _loc4_ = this._composedLines[this._composeRecycledInPlaceLines++];
            param2.splice(0,0,_loc4_);
            return _loc3_.callInContext(param1["recreateTextLine"],param1,param2);
         }
         return _loc3_.callInContext(param1.createTextLine,param1,param2);
      }
      
      private function recreateTextLine(param1:TextBlock, param2:Array) : TextLine
      {
         var _loc3_:ISWFContext = !!this._swfContext?this._swfContext:BaseCompose.globalSWFContext;
         if(this._composeRecycledInPlaceLines < this._composedLines.length)
         {
            TextLineRecycler.addLineForReuse(param2[0]);
            param2[0] = this._composedLines[this._composeRecycledInPlaceLines++];
         }
         return _loc3_.callInContext(param1["recreateTextLine"],param1,param2);
      }
      
      public function beginInteraction() : ISelectionManager
      {
         this._interactionCount++;
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         return this._textFlow.interactionManager;
      }
      
      public function endInteraction() : void
      {
         this._interactionCount--;
      }
      
      public function invalidateUndoManager() : void
      {
         if(this._editingMode == EditingMode.READ_WRITE)
         {
            this.invalidateInteractionManager(true);
         }
      }
      
      public function invalidateSelectionFormats() : void
      {
         this.invalidateInteractionManager();
      }
      
      private function invalidateInteractionManager(param1:Boolean = false) : void
      {
         var _loc2_:ISelectionManager = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            _loc2_ = this._textFlow.interactionManager;
            _loc3_ = !!_loc2_?int(_loc2_.activePosition):-1;
            _loc4_ = !!_loc2_?int(_loc2_.anchorPosition):-1;
            if(this._editingMode == EditingMode.READ_ONLY)
            {
               if(_loc2_)
               {
                  this._textFlow.interactionManager = null;
               }
            }
            else if(this._editingMode == EditingMode.READ_WRITE)
            {
               if(param1 || _loc2_ == null || _loc2_.editingMode == EditingMode.READ_SELECT)
               {
                  this._textFlow.interactionManager = this.createEditManager(this.getUndoManager());
                  if(this._textFlow.interactionManager is SelectionManager)
                  {
                     SelectionManager(this._textFlow.interactionManager).cloneSelectionFormatState(_loc2_);
                  }
               }
            }
            else if(this._editingMode == EditingMode.READ_SELECT)
            {
               if(param1 || _loc2_ == null || _loc2_.editingMode == EditingMode.READ_WRITE)
               {
                  this._textFlow.interactionManager = this.createSelectionManager();
                  if(this._textFlow.interactionManager is SelectionManager)
                  {
                     SelectionManager(this._textFlow.interactionManager).cloneSelectionFormatState(_loc2_);
                  }
               }
            }
            _loc2_ = this._textFlow.interactionManager;
            if(_loc2_)
            {
               _loc2_.unfocusedSelectionFormat = this.getUnfocusedSelectionFormat();
               _loc2_.focusedSelectionFormat = this.getFocusedSelectionFormat();
               _loc2_.inactiveSelectionFormat = this.getInactiveSelectionFormat();
               _loc2_.selectRange(_loc4_,_loc3_);
            }
         }
      }
      
      protected function createSelectionManager() : ISelectionManager
      {
         return new SelectionManager();
      }
      
      protected function createEditManager(param1:IUndoManager) : IEditManager
      {
         return new EditManager(param1);
      }
      
      private function getController() : TMContainerController
      {
         return this._textFlow.flowComposer.getControllerAt(0) as TMContainerController;
      }
      
      public function getLineAt(param1:int) : TextLine
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            if(this._sourceState == SOURCE_STRING && this._text.length == 0 && !this._damaged && this._composedLines.length == 0)
            {
               if(this._needsRedraw)
               {
                  this.compose();
               }
               else
               {
                  this.updateContainer();
               }
            }
            return this._composedLines[param1];
         }
         var _loc2_:TextFlowLine = this._textFlow.flowComposer.getLineAt(param1);
         return !!_loc2_?_loc2_.getTextLine(true):null;
      }
      
      public function get numLines() : int
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            return this._textFlow.flowComposer.numLines;
         }
         if(this._sourceState == SOURCE_STRING && this._text.length == 0)
         {
            return 1;
         }
         return this._composedLines.length;
      }
      
      tlf_internal function getActualNumLines() : int
      {
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.convertToTextFlowWithComposer();
         }
         this._textFlow.flowComposer.composeToPosition();
         return this._textFlow.flowComposer.numLines;
      }
      
      tlf_internal function clearComposedLines() : void
      {
         if(this._composedLines)
         {
            this._composedLines.length = 0;
         }
      }
      
      private function populateComposedLines(param1:DisplayObject) : void
      {
         this._composedLines.push(param1);
      }
      
      private function populateAndRecycleComposedLines(param1:DisplayObject) : void
      {
         var _loc2_:TextLine = param1 as TextLine;
         if(_loc2_)
         {
            if(this._composePushedLines >= this._composedLines.length)
            {
               this._composedLines.push(_loc2_);
            }
         }
         else
         {
            this._composedLines.splice(0,0,param1);
         }
         this._composePushedLines++;
      }
      
      public function compose() : void
      {
         var _loc1_:Function = null;
         var _loc2_:TextLineFactoryBase = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Object = null;
         var _loc5_:StringTextLineFactory = null;
         var _loc6_:TextLayoutFormat = null;
         var _loc7_:Object = null;
         var _loc8_:* = null;
         var _loc9_:* = undefined;
         var _loc10_:TCMTextFlowTextLineFactory = null;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this._textFlow.flowComposer.compose();
         }
         else if(this._damaged)
         {
            if(this._sourceState == SOURCE_TEXTFLOW && this._textFlow.mustUseComposer())
            {
               this.convertToTextFlowWithComposer(false);
               this._textFlow.flowComposer.compose();
               return;
            }
            if(Configuration.playerEnablesArgoFeatures)
            {
               while(true)
               {
                  _loc4_ = this._composedLines[0];
                  if(_loc4_ == null || _loc4_ is TextLine)
                  {
                     break;
                  }
                  this._composedLines.splice(0,1);
               }
               this._composeRecycledInPlaceLines = 0;
               this._composePushedLines = 0;
               _loc1_ = this.populateAndRecycleComposedLines;
            }
            else
            {
               this.clearComposedLines();
               _loc1_ = this.populateComposedLines;
            }
            _loc2_ = this._sourceState == SOURCE_STRING?inputManagerStringFactory(this._config):inputManagerTextFlowFactory();
            _loc2_.verticalScrollPolicy = this._verticalScrollPolicy;
            _loc2_.horizontalScrollPolicy = this._horizontalScrollPolicy;
            _loc2_.compositionBounds = new Rectangle(0,0,this._compositionWidth,this._compositionHeight);
            _loc2_.swfContext = !!Configuration.playerEnablesArgoFeatures?this:this._swfContext;
            _expectedFactoryCompose = TextLineFactoryBase.peekFactoryCompose();
            if(this._sourceState == SOURCE_STRING)
            {
               _loc5_ = _loc2_ as StringTextLineFactory;
               if(!this._stringFactoryTextFlowFormat)
               {
                  if(this._hostFormat == null)
                  {
                     this._stringFactoryTextFlowFormat = this._config.textFlowInitialFormat;
                  }
                  else
                  {
                     _loc6_ = new TextLayoutFormat(this._hostFormat);
                     TextLayoutFormat.resetModifiedNoninheritedStyles(_loc6_);
                     _loc7_ = (this._config.textFlowInitialFormat as TextLayoutFormat).getStyles();
                     for(_loc8_ in _loc7_)
                     {
                        _loc9_ = _loc7_[_loc8_];
                        _loc6_[_loc8_] = _loc9_ !== FormatValue.INHERIT?_loc9_:this._hostFormat[_loc8_];
                     }
                     this._stringFactoryTextFlowFormat = _loc6_;
                  }
               }
               if(!TextLayoutFormat.isEqual(_loc5_.textFlowFormat,this._stringFactoryTextFlowFormat))
               {
                  _loc5_.textFlowFormat = this._stringFactoryTextFlowFormat;
               }
               _loc5_.text = this._text;
               _loc5_.createTextLines(_loc1_);
            }
            else
            {
               _loc10_ = _loc2_ as TCMTextFlowTextLineFactory;
               _loc10_.tcm = this;
               _loc10_.createTextLines(_loc1_,this._textFlow);
               _loc10_.tcm = null;
            }
            _loc2_.swfContext = null;
            _expectedFactoryCompose = null;
            if(Configuration.playerEnablesArgoFeatures)
            {
               this._composedLines.length = this._composePushedLines;
            }
            _loc3_ = _loc2_.getContentBounds();
            this._contentLeft = _loc3_.x;
            this._contentTop = _loc3_.y;
            this._contentWidth = _loc3_.width;
            this._contentHeight = _loc3_.height;
            this._damaged = false;
            if(hasEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE))
            {
               this.dispatchEvent(new CompositionCompleteEvent(CompositionCompleteEvent.COMPOSITION_COMPLETE,false,false,this._textFlow,0,-1));
            }
            this._needsRedraw = true;
         }
      }
      
      public function updateContainer() : Boolean
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            return this._textFlow.flowComposer.updateAllControllers();
         }
         this.compose();
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this._textFlow.flowComposer.updateAllControllers();
            return true;
         }
         if(!this._needsRedraw)
         {
            return false;
         }
         this.factoryUpdateContainerChildren();
         this.drawBackgroundAndSetScrollRect(0,0);
         if(this._handlersState == HANDLERS_NOTADDED)
         {
            this.addActivationEventListeners();
         }
         if(hasEventListener(UpdateCompleteEvent.UPDATE_COMPLETE))
         {
            this.dispatchEvent(new UpdateCompleteEvent(UpdateCompleteEvent.UPDATE_COMPLETE,false,false,null));
         }
         this._needsRedraw = false;
         return true;
      }
      
      tlf_internal function factoryUpdateContainerChildren() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         var _loc3_:TextLine = null;
         if(Configuration.playerEnablesArgoFeatures)
         {
            while(this._container.numChildren != 0)
            {
               _loc1_ = this._container.getChildAt(0);
               if(_loc1_ is TextLine)
               {
                  break;
               }
               this._container.removeChildAt(0);
            }
            _loc2_ = 0;
            while(_loc2_ < this._composedLines.length)
            {
               _loc1_ = this._composedLines[_loc2_];
               if(_loc1_ is TextLine)
               {
                  break;
               }
               this._container.addChildAt(_loc1_,_loc2_);
               _loc2_++;
            }
            while(this._container.numChildren < this._composedLines.length)
            {
               this._container.addChild(this._composedLines[this._container.numChildren]);
            }
            while(this._container.numChildren > this._composedLines.length)
            {
               _loc3_ = this._container.getChildAt(this._composedLines.length) as TextLine;
               this._container.removeChildAt(this._composedLines.length);
               if(_loc3_)
               {
                  if(_loc3_.validity == TextLineValidity.VALID)
                  {
                     _loc3_.textBlock.releaseLines(_loc3_,_loc3_.textBlock.lastLine);
                  }
                  _loc3_.userData = null;
                  TextLineRecycler.addLineForReuse(_loc3_);
               }
            }
         }
         else
         {
            this.clearContainerChildren(false);
            for each(_loc1_ in this._composedLines)
            {
               this._container.addChild(_loc1_);
            }
            this.clearComposedLines();
         }
      }
      
      private function addActivationEventListeners() : void
      {
         var _loc1_:int = HANDLERS_NONE;
         if(this._composeState == COMPOSE_FACTORY)
         {
            if(this._editingMode == EditingMode.READ_ONLY)
            {
               _loc1_ = HANDLERS_MOUSEWHEEL;
            }
            else
            {
               _loc1_ = this._handlersState == HANDLERS_NOTADDED?int(HANDLERS_CREATION):int(HANDLERS_ACTIVE);
            }
         }
         if(_loc1_ == this._handlersState)
         {
            return;
         }
         this.removeActivationEventListeners();
         if(_loc1_ == HANDLERS_CREATION)
         {
            this._container.addEventListener(FocusEvent.FOCUS_IN,this.requiredFocusInHandler);
            this._container.addEventListener(MouseEvent.MOUSE_OVER,this.requiredMouseOverHandler);
         }
         else if(_loc1_ == HANDLERS_ACTIVE)
         {
            this._container.addEventListener(FocusEvent.FOCUS_IN,this.requiredFocusInHandler);
            this._container.addEventListener(MouseEvent.MOUSE_OVER,this.requiredMouseOverHandler);
            this._container.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._container.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            this._container.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
            this._container.addEventListener("imeStartComposition",this.imeStartCompositionHandler);
            if(this.getContextMenu() != null)
            {
               this._container.contextMenu = this._contextMenu;
            }
            if(this._container.contextMenu)
            {
               this._container.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,this.menuSelectHandler);
            }
            this._container.addEventListener(Event.SELECT_ALL,this.editHandler);
         }
         else if(_loc1_ == HANDLERS_MOUSEWHEEL)
         {
            this._container.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
         this._handlersState = _loc1_;
      }
      
      tlf_internal function getContextMenu() : ContextMenu
      {
         if(this._contextMenu === undefined)
         {
            this._contextMenu = this.createContextMenu();
         }
         return this._contextMenu;
      }
      
      private function removeActivationEventListeners() : void
      {
         if(this._handlersState == HANDLERS_CREATION)
         {
            this._container.removeEventListener(FocusEvent.FOCUS_IN,this.requiredFocusInHandler);
            this._container.removeEventListener(MouseEvent.MOUSE_OVER,this.requiredMouseOverHandler);
         }
         else if(this._handlersState == HANDLERS_ACTIVE)
         {
            this._container.removeEventListener(FocusEvent.FOCUS_IN,this.requiredFocusInHandler);
            this._container.removeEventListener(MouseEvent.MOUSE_OVER,this.requiredMouseOverHandler);
            this._container.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            this._container.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
            this._container.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
            this._container.removeEventListener("imeStartComposition",this.imeStartCompositionHandler);
            if(this._container.contextMenu)
            {
               this._container.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT,this.menuSelectHandler);
            }
            if(this._contextMenu)
            {
               this._container.contextMenu = null;
            }
            this._container.removeEventListener(Event.SELECT_ALL,this.editHandler);
         }
         else if(this._handlersState == HANDLERS_MOUSEWHEEL)
         {
            this._container.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         }
         this._handlersState = HANDLERS_NOTADDED;
      }
      
      private function addTextFlowListeners() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in eventList)
         {
            this._textFlow.addEventListener(_loc1_,this.dispatchEvent);
         }
      }
      
      private function removeTextFlowListeners() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in eventList)
         {
            this._textFlow.removeEventListener(_loc1_,this.dispatchEvent);
         }
         this._handlersState = HANDLERS_NONE;
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(param1.type == DamageEvent.DAMAGE)
         {
            this._textDamaged = true;
            if(this._composeState == COMPOSE_FACTORY)
            {
               this._damaged = true;
            }
         }
         else if(param1.type == FlowOperationEvent.FLOW_OPERATION_BEGIN)
         {
            if(this._container.mouseChildren == false)
            {
               this._container.mouseChildren = true;
            }
         }
         var _loc2_:Boolean = super.dispatchEvent(param1);
         if(!_loc2_)
         {
            param1.preventDefault();
         }
         return _loc2_;
      }
      
      tlf_internal function clearContainerChildren(param1:Boolean) : void
      {
         var _loc2_:TextLine = null;
         var _loc3_:TextBlock = null;
         while(this._container.numChildren)
         {
            _loc2_ = this._container.getChildAt(0) as TextLine;
            this._container.removeChildAt(0);
            if(_loc2_)
            {
               if(_loc2_.validity != TextLineValidity.INVALID && _loc2_.validity != TextLineValidity.STATIC)
               {
                  _loc3_ = _loc2_.textBlock;
                  _loc3_.releaseLines(_loc3_.firstLine,_loc3_.lastLine);
               }
               if(param1)
               {
                  _loc2_.userData = null;
                  TextLineRecycler.addLineForReuse(_loc2_);
               }
            }
         }
      }
      
      private function convertToTextFlow() : void
      {
         this._textFlow = new TextFlow(this._config);
         this._textFlow.hostFormat = this._hostFormat;
         if(this._swfContext)
         {
            this._textFlow.flowComposer.swfContext = this._swfContext;
         }
         var _loc1_:ParagraphElement = new ParagraphElement();
         this._textFlow.addChild(_loc1_);
         var _loc2_:SpanElement = new SpanElement();
         _loc2_.text = this._text;
         _loc1_.addChild(_loc2_);
         this._sourceState = SOURCE_TEXTFLOW;
         this.addTextFlowListeners();
      }
      
      tlf_internal function convertToTextFlowWithComposer(param1:Boolean = true) : void
      {
         var _loc2_:TMContainerController = null;
         this.removeActivationEventListeners();
         if(this._sourceState != SOURCE_TEXTFLOW)
         {
            this.convertToTextFlow();
         }
         if(this._composeState != COMPOSE_COMPOSER)
         {
            this.clearContainerChildren(true);
            this.clearComposedLines();
            _loc2_ = new TMContainerController(this._container,this._compositionWidth,this._compositionHeight,this);
            this._textFlow.flowComposer = new StandardFlowComposer();
            this._textFlow.flowComposer.addController(_loc2_);
            this._textFlow.flowComposer.swfContext = this._swfContext;
            this._composeState = COMPOSE_COMPOSER;
            this.invalidateInteractionManager();
            if(param1)
            {
               this.updateContainer();
            }
         }
      }
      
      private function get effectiveBlockProgression() : String
      {
         if(this._textFlow)
         {
            return this._textFlow.computedFormat.blockProgression;
         }
         return this._hostFormat && this._hostFormat.blockProgression && this._hostFormat.blockProgression != FormatValue.INHERIT?this._hostFormat.blockProgression:BlockProgression.TB;
      }
      
      private function removeIBeamCursor() : void
      {
         if(this._ibeamCursorSet)
         {
            Mouse.cursor = Configuration.getCursorString(this.configuration,MouseCursor.AUTO);
            this._ibeamCursorSet = false;
         }
      }
      
      private function get hasScrollRect() : Boolean
      {
         return this._hasScrollRect;
      }
      
      private function set hasScrollRect(param1:Boolean) : void
      {
         this._hasScrollRect = param1;
      }
      
      public function drawBackgroundAndSetScrollRect(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:ContainerController = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc3_:Sprite = this.container;
         if(this._composeState == COMPOSE_FACTORY)
         {
            _loc4_ = this._contentWidth;
            _loc5_ = this._contentHeight;
         }
         else
         {
            _loc9_ = this.getController();
            _loc4_ = _loc9_.contentWidth;
            _loc5_ = _loc9_.contentHeight;
         }
         if(isNaN(this.compositionWidth))
         {
            _loc10_ = this._composeState == COMPOSE_FACTORY?Number(this._contentLeft):Number(_loc9_.contentLeft);
            _loc6_ = _loc10_ + _loc4_ - param1;
         }
         else
         {
            _loc6_ = this.compositionWidth;
         }
         if(isNaN(this.compositionHeight))
         {
            _loc11_ = this._composeState == COMPOSE_FACTORY?Number(this._contentTop):Number(_loc9_.contentTop);
            _loc7_ = _loc11_ + _loc5_ - param2;
         }
         else
         {
            _loc7_ = this.compositionHeight;
         }
         if(param1 == 0 && param2 == 0 && _loc4_ <= _loc6_ && _loc5_ <= _loc7_)
         {
            if(this._hasScrollRect)
            {
               _loc3_.scrollRect = null;
               this._hasScrollRect = false;
            }
         }
         else
         {
            _loc3_.scrollRect = new Rectangle(param1,param2,_loc6_,_loc7_);
            this._hasScrollRect = true;
            param1 = _loc3_.scrollRect.x;
            param2 = _loc3_.scrollRect.y;
            _loc6_ = _loc3_.scrollRect.width;
            _loc7_ = _loc3_.scrollRect.height;
         }
         var _loc8_:Sprite = _loc3_ as Sprite;
         if(_loc8_)
         {
            _loc8_.graphics.clear();
            _loc8_.graphics.beginFill(0,0);
            _loc8_.graphics.drawRect(param1,param2,_loc6_,_loc7_);
            _loc8_.graphics.endFill();
         }
         return this._hasScrollRect;
      }
      
      protected function getFocusedSelectionFormat() : SelectionFormat
      {
         return this._config.focusedSelectionFormat;
      }
      
      protected function getInactiveSelectionFormat() : SelectionFormat
      {
         return this._config.inactiveSelectionFormat;
      }
      
      protected function getUnfocusedSelectionFormat() : SelectionFormat
      {
         return this._config.unfocusedSelectionFormat;
      }
      
      protected function getUndoManager() : IUndoManager
      {
         return new UndoManager();
      }
      
      protected function createContextMenu() : ContextMenu
      {
         return ContainerController.createDefaultContextMenu();
      }
      
      public function editHandler(param1:Event) : void
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.convertToTextFlowWithComposer();
            this.getController().editHandler(param1);
            this._textFlow.interactionManager.setFocus();
         }
         else
         {
            this.getController().editHandler(param1);
         }
      }
      
      public function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().keyDownHandler(param1);
         }
      }
      
      public function keyUpHandler(param1:KeyboardEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().keyUpHandler(param1);
         }
      }
      
      public function keyFocusChangeHandler(param1:FocusEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().keyFocusChangeHandler(param1);
         }
      }
      
      public function textInputHandler(param1:TextEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().textInputHandler(param1);
         }
      }
      
      public function imeStartCompositionHandler(param1:IMEEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().imeStartCompositionHandler(param1);
         }
      }
      
      public function softKeyboardActivatingHandler(param1:Event) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().softKeyboardActivatingHandler(param1);
         }
      }
      
      public function mouseDownHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.convertToTextFlowWithComposer();
            this.getController().requiredFocusInHandler(null);
            this.getController().requiredMouseOverHandler(param1.target != this.container?new RemappedMouseEvent(param1):param1);
            if(this._hasFocus)
            {
               this.getController().requiredFocusInHandler(null);
            }
            this.getController().requiredMouseDownHandler(param1);
         }
         else
         {
            this.getController().mouseDownHandler(param1);
         }
      }
      
      public function mouseMoveHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseMoveHandler(param1);
         }
      }
      
      public function mouseUpHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseUpHandler(param1);
         }
      }
      
      public function mouseDoubleClickHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseDoubleClickHandler(param1);
         }
      }
      
      tlf_internal final function requiredMouseOverHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.mouseOverHandler(param1);
         }
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().requiredMouseOverHandler(param1);
         }
      }
      
      public function mouseOverHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseOverHandler(param1);
         }
         else
         {
            if(this.effectiveBlockProgression != BlockProgression.RL)
            {
               Mouse.cursor = MouseCursor.IBEAM;
               this._ibeamCursorSet = true;
            }
            this.addActivationEventListeners();
         }
      }
      
      public function mouseOutHandler(param1:MouseEvent) : void
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.removeIBeamCursor();
         }
         else
         {
            this.getController().mouseOutHandler(param1);
         }
      }
      
      public function focusInHandler(param1:FocusEvent) : void
      {
         this._hasFocus = true;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().focusInHandler(param1);
         }
      }
      
      tlf_internal function requiredFocusOutHandler(param1:FocusEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().requiredFocusOutHandler(param1);
         }
      }
      
      public function focusOutHandler(param1:FocusEvent) : void
      {
         this._hasFocus = false;
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().focusOutHandler(param1);
         }
      }
      
      public function activateHandler(param1:Event) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().activateHandler(param1);
         }
      }
      
      public function deactivateHandler(param1:Event) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().deactivateHandler(param1);
         }
      }
      
      public function focusChangeHandler(param1:FocusEvent) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().focusChangeHandler(param1);
         }
      }
      
      public function menuSelectHandler(param1:ContextMenuEvent) : void
      {
         var _loc2_:ContextMenu = null;
         var _loc3_:ContextMenuClipboardItems = null;
         if(this._composeState == COMPOSE_FACTORY)
         {
            _loc2_ = this._container.contextMenu as ContextMenu;
            if(_loc2_)
            {
               _loc3_ = _loc2_.clipboardItems;
               _loc3_.selectAll = this._editingMode != EditingMode.READ_ONLY;
               _loc3_.clear = false;
               _loc3_.copy = false;
               _loc3_.cut = false;
               _loc3_.paste = false;
            }
         }
         else
         {
            this.getController().menuSelectHandler(param1);
         }
      }
      
      public function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.convertToTextFlowWithComposer();
            this.getController().requiredMouseOverHandler(param1);
         }
         this.getController().mouseWheelHandler(param1);
      }
      
      tlf_internal final function requiredFocusInHandler(param1:FocusEvent) : void
      {
         if(this._composeState == COMPOSE_FACTORY)
         {
            this.addActivationEventListeners();
            this.focusInHandler(param1);
         }
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().requiredFocusInHandler(param1);
         }
      }
      
      public function beginMouseCapture() : void
      {
      }
      
      public function endMouseCapture() : void
      {
      }
      
      public function mouseUpSomewhere(param1:Event) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseUpSomewhere(param1);
         }
      }
      
      public function mouseMoveSomewhere(param1:Event) : void
      {
         if(this._composeState == COMPOSE_COMPOSER)
         {
            this.getController().mouseUpSomewhere(param1);
         }
      }
      
      tlf_internal function getFirstTextLineChildIndex() : int
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._container.numChildren)
         {
            if(this._container.getChildAt(_loc1_) is TextLine)
            {
               break;
            }
            _loc1_++;
         }
         return _loc1_;
      }
      
      tlf_internal function addTextLine(param1:TextLine, param2:int) : void
      {
         this._container.addChildAt(param1,param2);
      }
      
      tlf_internal function removeTextLine(param1:TextLine) : void
      {
         if(this._container.contains(param1))
         {
            this._container.removeChild(param1);
         }
      }
      
      tlf_internal function addBackgroundShape(param1:Shape) : void
      {
         this._container.addChildAt(param1,this.getFirstTextLineChildIndex());
      }
      
      tlf_internal function removeBackgroundShape(param1:Shape) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      tlf_internal function addSelectionContainer(param1:DisplayObjectContainer) : void
      {
         if(param1.blendMode == BlendMode.NORMAL && param1.alpha == 1)
         {
            this._container.addChildAt(param1,this.getFirstTextLineChildIndex());
         }
         else
         {
            this._container.addChild(param1);
         }
      }
      
      tlf_internal function removeSelectionContainer(param1:DisplayObjectContainer) : void
      {
         param1.parent.removeChild(param1);
      }
      
      tlf_internal function addInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject, param3:int) : void
      {
         if(param1)
         {
            param1.addChildAt(param2,param3);
         }
      }
      
      tlf_internal function removeInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject) : void
      {
         if(param1 && param2.parent == param1)
         {
            param1.removeChild(param2);
         }
      }
      
      public function get preserveSelectionOnSetText() : Boolean
      {
         return this._preserveSelectionOnSetText;
      }
      
      public function set preserveSelectionOnSetText(param1:Boolean) : void
      {
         this._preserveSelectionOnSetText = param1;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.engine.TextLine;
import flash.ui.ContextMenu;
import flashx.textLayout.container.ContainerController;
import flashx.textLayout.container.ScrollPolicy;
import flashx.textLayout.container.TextContainerManager;
import flashx.textLayout.edit.IInteractionEventHandler;
import flashx.textLayout.formats.BlockProgression;
import flashx.textLayout.tlf_internal;

use namespace tlf_internal;

class TMContainerController extends ContainerController
{
    
   
   private var _inputManager:TextContainerManager;
   
   function TMContainerController(param1:Sprite, param2:Number, param3:Number, param4:TextContainerManager)
   {
      super(param1,param2,param3);
      this._inputManager = param4;
      verticalScrollPolicy = param4.verticalScrollPolicy;
      horizontalScrollPolicy = param4.horizontalScrollPolicy;
   }
   
   public function get textContainerManager() : TextContainerManager
   {
      return this._inputManager;
   }
   
   override protected function createContextMenu() : ContextMenu
   {
      return this._inputManager.getContextMenu();
   }
   
   override protected function get attachTransparentBackground() : Boolean
   {
      return false;
   }
   
   tlf_internal function doUpdateVisibleRectangle() : void
   {
      this.updateVisibleRectangle();
   }
   
   override protected function updateVisibleRectangle() : void
   {
      var _loc1_:Number = NaN;
      var _loc2_:Number = NaN;
      _loc1_ = horizontalScrollPosition;
      if(effectiveBlockProgression == BlockProgression.RL && (verticalScrollPolicy != ScrollPolicy.OFF || horizontalScrollPolicy != ScrollPolicy.OFF))
      {
         _loc1_ = _loc1_ - (!isNaN(compositionWidth)?compositionWidth:contentWidth);
      }
      _loc2_ = verticalScrollPosition;
      _hasScrollRect = this._inputManager.drawBackgroundAndSetScrollRect(_loc1_,_loc2_);
   }
   
   override tlf_internal function getInteractionHandler() : IInteractionEventHandler
   {
      return this._inputManager;
   }
   
   override tlf_internal function attachContextMenu() : void
   {
      if(this._inputManager.getContextMenu() != null)
      {
         super.attachContextMenu();
      }
   }
   
   override tlf_internal function removeContextMenu() : void
   {
      if(this._inputManager.getContextMenu())
      {
         super.removeContextMenu();
      }
   }
   
   override protected function getFirstTextLineChildIndex() : int
   {
      return this._inputManager.getFirstTextLineChildIndex();
   }
   
   override protected function addTextLine(param1:TextLine, param2:int) : void
   {
      this._inputManager.addTextLine(param1,param2);
   }
   
   override protected function removeTextLine(param1:TextLine) : void
   {
      this._inputManager.removeTextLine(param1);
   }
   
   override protected function addBackgroundShape(param1:Shape) : void
   {
      this._inputManager.addBackgroundShape(param1);
   }
   
   override protected function removeBackgroundShape(param1:Shape) : void
   {
      this._inputManager.removeBackgroundShape(param1);
   }
   
   override protected function addSelectionContainer(param1:DisplayObjectContainer) : void
   {
      this._inputManager.addSelectionContainer(param1);
   }
   
   override protected function removeSelectionContainer(param1:DisplayObjectContainer) : void
   {
      this._inputManager.removeSelectionContainer(param1);
   }
   
   override protected function addInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject, param3:int) : void
   {
      this._inputManager.addInlineGraphicElement(param1,param2,param3);
   }
   
   override protected function removeInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject) : void
   {
      this._inputManager.removeInlineGraphicElement(param1,param2);
   }
}

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

class RemappedMouseEvent extends MouseEvent
{
    
   
   private var _event:MouseEvent;
   
   function RemappedMouseEvent(param1:MouseEvent, param2:Boolean = false)
   {
      var _loc3_:Point = null;
      if(!param2)
      {
         _loc3_ = DisplayObject(param1.target).localToGlobal(new Point(param1.localX,param1.localY));
         _loc3_ = DisplayObject(param1.currentTarget).globalToLocal(_loc3_);
      }
      else
      {
         _loc3_ = new Point();
      }
      super(param1.type,param1.bubbles,param1.cancelable,_loc3_.x,_loc3_.y,param1.relatedObject,param1.ctrlKey,param1.altKey,param1.shiftKey,param1.buttonDown,param1.delta);
      this._event = param1;
   }
   
   override public function get target() : Object
   {
      return this._event.currentTarget;
   }
   
   override public function get currentTarget() : Object
   {
      return this._event.currentTarget;
   }
   
   override public function get eventPhase() : uint
   {
      return this._event.eventPhase;
   }
   
   override public function get isRelatedObjectInaccessible() : Boolean
   {
      return this._event.isRelatedObjectInaccessible;
   }
   
   override public function get stageX() : Number
   {
      return this._event.stageX;
   }
   
   override public function get stageY() : Number
   {
      return this._event.stageY;
   }
   
   override public function clone() : Event
   {
      var _loc1_:RemappedMouseEvent = new RemappedMouseEvent(this._event,true);
      _loc1_.localX = localX;
      _loc1_.localY = localY;
      return _loc1_;
   }
   
   override public function updateAfterEvent() : void
   {
      this._event.updateAfterEvent();
   }
   
   override public function isDefaultPrevented() : Boolean
   {
      return this._event.isDefaultPrevented();
   }
   
   override public function preventDefault() : void
   {
      this._event.preventDefault();
   }
   
   override public function stopImmediatePropagation() : void
   {
      this._event.stopImmediatePropagation();
   }
   
   override public function stopPropagation() : void
   {
      this._event.stopPropagation();
   }
}

import flashx.textLayout.compose.IFlowComposer;
import flashx.textLayout.container.TextContainerManager;
import flashx.textLayout.factory.TextFlowTextLineFactory;
import flashx.textLayout.tlf_internal;

class TCMTextFlowTextLineFactory extends TextFlowTextLineFactory
{
    
   
   private var _tcm:TextContainerManager;
   
   function TCMTextFlowTextLineFactory()
   {
      super();
   }
   
   override tlf_internal function createFlowComposer() : IFlowComposer
   {
      return new TCMFactoryDisplayComposer(this._tcm);
   }
   
   public function get tcm() : TextContainerManager
   {
      return this._tcm;
   }
   
   public function set tcm(param1:TextContainerManager) : void
   {
      this._tcm = param1;
   }
}

import flashx.textLayout.compose.SimpleCompose;
import flashx.textLayout.container.ContainerController;
import flashx.textLayout.container.TextContainerManager;
import flashx.textLayout.factory.FactoryDisplayComposer;
import flashx.textLayout.factory.TextLineFactoryBase;
import flashx.textLayout.tlf_internal;

use namespace tlf_internal;

class TCMFactoryDisplayComposer extends FactoryDisplayComposer
{
    
   
   tlf_internal var _tcm:TextContainerManager;
   
   function TCMFactoryDisplayComposer(param1:TextContainerManager)
   {
      super();
      this._tcm = param1;
   }
   
   override tlf_internal function callTheComposer(param1:int, param2:int) : ContainerController
   {
      clearCompositionResults();
      var _loc3_:SimpleCompose = TextLineFactoryBase._factoryComposer;
      _loc3_.resetLineHandler = this._tcm.resetLine;
      _loc3_.composeTextFlow(textFlow,-1,-1);
      _loc3_.releaseAnyReferences();
      return getControllerAt(0);
   }
}
