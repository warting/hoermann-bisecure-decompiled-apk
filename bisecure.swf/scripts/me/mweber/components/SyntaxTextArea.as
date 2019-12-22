package me.mweber.components
{
   import flash.events.TimerEvent;
   import flash.text.engine.FontWeight;
   import flash.utils.Timer;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.operations.ApplyFormatOperation;
   import flashx.textLayout.operations.CompositeOperation;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.TextArea;
   import spark.events.TextOperationEvent;
   
   public class SyntaxTextArea extends TextArea
   {
      
      protected static const MAX_TOKEN_LOOPS:Number = 100000;
      
      protected static const RECOLORIZE_DELAY:uint = 200;
       
      
      private var _661233029useTabulator:Boolean = true;
      
      private var _756041931defaultLayout:TextLayoutFormat;
      
      protected var _colorizeTimer:Timer;
      
      protected var _elements:Array;
      
      public function SyntaxTextArea()
      {
         super();
         this._colorizeTimer = new Timer(RECOLORIZE_DELAY,1);
         this.defaultLayout = new TextLayoutFormat();
         this.defaultLayout.color = 15658734;
         this.defaultLayout.fontWeight = FontWeight.NORMAL;
         this.xml = <?xml version="1.0" encoding="UTF-8"?><Elements><Comments color="0x11FF33"><SingleLineComment pattern="--.*$" /><MultiLineComment pattern=" --[[ .* ]]" color="0x22DD11" /></Comments><Function pattern="function" color="0x0000FF" /></Elements>;
         this.addListeners();
      }
      
      public function set xml(param1:XML) : void
      {
         this._elements = new Array();
         this.writeXml(param1.children());
      }
      
      protected function writeXml(param1:XMLList, param2:TextLayoutFormat = null) : void
      {
         var _loc4_:XML = null;
         var _loc5_:TextLayoutFormat = null;
         var _loc6_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length())
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new TextLayoutFormat();
            _loc5_.copy(param2);
            if(_loc4_.attribute("color").length() > 0)
            {
               _loc5_.color = uint(_loc4_.attribute("color"));
            }
            if(_loc4_.attribute("fontStyle").length() > 0)
            {
               _loc5_.fontStyle = _loc4_.attribute("fontStyle");
            }
            if(_loc4_.attribute("fontWeight").length() > 0)
            {
               _loc5_.fontWeight = _loc4_.attribute("fontWeight");
            }
            if(_loc4_.attribute("fontSize").length() > 0)
            {
               _loc5_.fontSize = _loc4_.attribute("fontSize");
            }
            if(_loc4_.children().length() == 0)
            {
               _loc6_ = new Object();
               _loc6_.name = _loc4_.name().toString();
               if(param1.attributes.pattern != null)
               {
                  _loc6_.pattern = new RegExp(_loc4_.attribute("pattern").toString(),"gm");
                  _loc6_.layout = _loc5_;
                  this._elements.push(_loc6_);
               }
            }
            else
            {
               this.writeXml(_loc4_.children(),_loc5_);
            }
            _loc3_++;
         }
      }
      
      protected function addListeners() : void
      {
         this.addEventListener(FlexEvent.CREATION_COMPLETE,this.onCreationComplete);
         this.addEventListener(TextOperationEvent.CHANGING,this.onChange);
         this.addEventListener(TextOperationEvent.CHANGE,this.onChanged);
         this._colorizeTimer.addEventListener(TimerEvent.TIMER,this.onColorizeTimer);
      }
      
      protected function colorize() : void
      {
         var _loc5_:Object = null;
         var _loc6_:RegExp = null;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         var _loc1_:Number = new Date().time;
         var _loc2_:CompositeOperation = new CompositeOperation();
         var _loc3_:SelectionState = new SelectionState(this.textFlow,0,this.text.length);
         var _loc4_:ApplyFormatOperation = new ApplyFormatOperation(_loc3_,this.defaultLayout,null);
         _loc2_.addOperation(_loc4_);
         for each(_loc5_ in this._elements)
         {
            _loc6_ = _loc5_.pattern as RegExp;
            _loc7_ = _loc6_.exec(this.text);
            _loc8_ = 0;
            while(_loc7_)
            {
               _loc10_ = _loc7_[0];
               _loc3_ = new SelectionState(this.textFlow,_loc7_.index,_loc7_.index + _loc10_.length);
               _loc4_ = new ApplyFormatOperation(_loc3_,_loc5_.layout,null);
               _loc2_.addOperation(_loc4_);
               _loc6_.lastIndex = _loc7_.index + _loc10_.length;
               _loc7_ = _loc6_.exec(this.text);
               if(_loc8_ >= MAX_TOKEN_LOOPS)
               {
                  break;
               }
               _loc8_++;
            }
            _loc9_ = _loc2_.doOperation();
         }
      }
      
      protected function onCreationComplete(param1:FlexEvent) : void
      {
         Configuration(textFlow.configuration).manageTabKey = this.useTabulator;
      }
      
      protected function onColorizeTimer(param1:TimerEvent) : void
      {
         this.colorize();
         this._colorizeTimer.reset();
      }
      
      protected function onChange(param1:TextOperationEvent) : void
      {
         if(!this._colorizeTimer.running)
         {
            this._colorizeTimer.start();
         }
      }
      
      protected function onChanged(param1:TextOperationEvent) : void
      {
         this.colorize();
      }
      
      [Bindable(event="propertyChange")]
      public function get useTabulator() : Boolean
      {
         return this._661233029useTabulator;
      }
      
      public function set useTabulator(param1:Boolean) : void
      {
         var _loc2_:Object = this._661233029useTabulator;
         if(_loc2_ !== param1)
         {
            this._661233029useTabulator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useTabulator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get defaultLayout() : TextLayoutFormat
      {
         return this._756041931defaultLayout;
      }
      
      public function set defaultLayout(param1:TextLayoutFormat) : void
      {
         var _loc2_:Object = this._756041931defaultLayout;
         if(_loc2_ !== param1)
         {
            this._756041931defaultLayout = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"defaultLayout",_loc2_,param1));
            }
         }
      }
   }
}
