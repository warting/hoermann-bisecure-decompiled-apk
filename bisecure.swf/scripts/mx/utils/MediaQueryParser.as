package mx.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.Capabilities;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.styles.CSSDimension;
   import mx.styles.CSSOSVersion;
   import mx.styles.IStyleManager2;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class MediaQueryParser extends EventDispatcher
   {
      
      public static var platformMap:Object = {
         "AND":"android",
         "IOS":"ios",
         "MAC":"macintosh",
         "WIN":"windows",
         "LNX":"linux",
         "QNX":"qnx"
      };
      
      private static var _instance:MediaQueryParser;
       
      
      mx_internal var goodQueries:Object;
      
      mx_internal var badQueries:Object;
      
      private var sm:ISystemManager;
      
      private var usesDeviceWidth:Boolean = false;
      
      private var usesDeviceHeight:Boolean = false;
      
      private var usesDeviceDiagonal:Boolean = false;
      
      private var deviceDPI:Number;
      
      public var type:String = "screen";
      
      public var applicationDpi:Number;
      
      public var osPlatform:String;
      
      public var osVersion:CSSOSVersion;
      
      private var _1550605040deviceWidth:CSSDimension;
      
      private var _1257110755deviceHeight:CSSDimension;
      
      public var flexDeviceDiagonal:CSSDimension;
      
      public function MediaQueryParser(param1:IFlexModuleFactory = null)
      {
         this.goodQueries = {};
         this.badQueries = {};
         super();
         this.applicationDpi = DensityUtil.getRuntimeDPI();
         if(param1)
         {
            if(param1.info()["applicationDPI"] != null)
            {
               this.applicationDpi = param1.info()["applicationDPI"];
            }
            if(param1 is ISystemManager)
            {
               this.sm = ISystemManager(param1);
               if(this.sm.stage)
               {
                  this.sm.stage.addEventListener(Event.RESIZE,this.stage_resizeHandler,false);
               }
            }
         }
         this.osPlatform = this.getPlatform();
         this.osVersion = this.getOSVersion();
         this.deviceDPI = Capabilities.screenDPI;
         this.computeDeviceDimensions();
      }
      
      public static function get instance() : MediaQueryParser
      {
         return _instance;
      }
      
      public static function set instance(param1:MediaQueryParser) : void
      {
         if(!_instance)
         {
            _instance = param1;
         }
      }
      
      public function parse(param1:String) : Boolean
      {
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         param1 = StringUtil.trim(param1);
         if(param1 == "")
         {
            return true;
         }
         if(this.goodQueries[param1])
         {
            return true;
         }
         if(this.badQueries[param1])
         {
            return false;
         }
         var _loc2_:String = param1;
         param1 = param1.toLowerCase();
         if(param1 == "all")
         {
            return true;
         }
         var _loc3_:Array = param1.split(", ");
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = _loc3_[_loc5_];
            _loc8_ = false;
            if(_loc7_.indexOf("only ") == 0)
            {
               _loc7_ = _loc7_.substr(5);
            }
            if(_loc7_.indexOf("not ") == 0)
            {
               _loc8_ = true;
               _loc7_ = _loc7_.substr(4);
            }
            _loc9_ = this.tokenizeMediaQuery(_loc7_);
            _loc10_ = _loc9_.length;
            if(_loc9_[0] == "all" || _loc9_[0] == this.type)
            {
               if(_loc10_ == 1 && !_loc8_)
               {
                  this.goodQueries[_loc2_] = true;
                  return true;
               }
               if(_loc10_ == 2)
               {
                  return false;
               }
               _loc9_.shift();
               _loc9_.shift();
               _loc6_ = this.evalExpressions(_loc9_);
               if(_loc6_ && !_loc8_ || !_loc6_ && _loc8_)
               {
                  this.goodQueries[_loc2_] = true;
                  return true;
               }
            }
            else if(_loc8_)
            {
               this.goodQueries[_loc2_] = true;
               return true;
            }
            _loc5_++;
         }
         this.badQueries[_loc2_] = true;
         return false;
      }
      
      private function tokenizeMediaQuery(param1:String) : Array
      {
         var _loc9_:String = null;
         var _loc2_:Array = [];
         var _loc3_:int = param1.indexOf("(");
         if(_loc3_ == 0)
         {
            _loc2_.push("all");
            _loc2_.push("and");
         }
         else if(_loc3_ == -1)
         {
            return [param1];
         }
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = param1.length;
         var _loc7_:Array = [];
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc9_ = param1.charAt(_loc8_);
            if(!(StringUtil.isWhitespace(_loc9_) && _loc7_.length == 0))
            {
               if(_loc9_ == "/" && _loc8_ < _loc6_ - 1 && param1.charAt(_loc8_ + 1) == "*")
               {
                  _loc5_ = true;
                  _loc8_++;
               }
               else if(_loc5_)
               {
                  if(_loc9_ == "*" && _loc8_ < _loc6_ - 1 && param1.charAt(_loc8_ + 1) == "/")
                  {
                     _loc5_ = false;
                     _loc8_++;
                  }
               }
               else
               {
                  if(_loc9_ == "(")
                  {
                     _loc4_++;
                  }
                  else if(_loc9_ == ")")
                  {
                     _loc4_--;
                  }
                  else
                  {
                     _loc7_.push(_loc9_);
                  }
                  if(_loc4_ == 0 && (StringUtil.isWhitespace(_loc9_) || _loc9_ == ")"))
                  {
                     if(_loc9_ != ")")
                     {
                        _loc7_.length--;
                     }
                     _loc2_.push(_loc7_.join(""));
                     _loc7_.length = 0;
                  }
               }
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      private function evalExpressions(param1:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ != "and")
            {
               _loc5_ = _loc4_.split(":");
               _loc6_ = _loc5_[0];
               _loc7_ = false;
               _loc8_ = false;
               _loc9_ = false;
               if(_loc6_.indexOf("-flex-") == 0)
               {
                  _loc9_ = true;
                  _loc6_ = _loc6_.substr(6);
               }
               if(_loc6_.indexOf("min-") == 0)
               {
                  _loc7_ = true;
                  _loc6_ = _loc6_.substr(4);
               }
               else if(_loc6_.indexOf("max-") == 0)
               {
                  _loc8_ = true;
                  _loc6_ = _loc6_.substr(4);
               }
               if(_loc6_.indexOf("-") > 0)
               {
                  _loc6_ = this.deHyphenate(_loc6_,_loc9_);
               }
               if(_loc6_ == "deviceWidth")
               {
                  this.usesDeviceWidth = true;
               }
               else if(_loc6_ == "deviceHeight")
               {
                  this.usesDeviceHeight = true;
               }
               else if(_loc6_ == "flexDeviceDiagonal")
               {
                  this.usesDeviceDiagonal = true;
               }
               if(_loc5_.length == 1)
               {
                  if(!(_loc6_ in this))
                  {
                     return false;
                  }
               }
               if(_loc5_.length == 2)
               {
                  if(!(_loc6_ in this))
                  {
                     return false;
                  }
                  _loc10_ = this.normalize(_loc5_[1],this[_loc6_]);
                  _loc11_ = this.compareValues(this[_loc6_],_loc10_);
                  if(_loc7_)
                  {
                     if(_loc11_ < 0)
                     {
                        return false;
                     }
                  }
                  else if(_loc8_)
                  {
                     if(_loc11_ > 0)
                     {
                        return false;
                     }
                  }
                  else if(_loc11_ != 0)
                  {
                     return false;
                  }
               }
            }
            _loc3_++;
         }
         return true;
      }
      
      private function normalize(param1:String, param2:Object) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(param1.charAt(0) == " ")
         {
            param1 = param1.substr(1);
         }
         if(param2 is Number)
         {
            _loc3_ = param1.indexOf("dpi");
            if(_loc3_ != -1)
            {
               param1 = param1.substr(0,_loc3_);
            }
            return Number(param1);
         }
         if(param2 is int)
         {
            return int(param1);
         }
         if(param1.indexOf("\"") == 0)
         {
            if(param1.lastIndexOf("\"") == param1.length - 1)
            {
               param1 = param1.substr(1,param1.length - 2);
            }
            else
            {
               param1 = param1.substr(1);
            }
         }
         if(param2 is String)
         {
            return param1;
         }
         if(param2 is CSSOSVersion)
         {
            return new CSSOSVersion(param1);
         }
         if(param2 is CSSDimension)
         {
            _loc4_ = param1.match(/([\d\.]+)(in|cm|dp|pt|px|)$/);
            if(_loc4_ != null && _loc4_.length == 3)
            {
               _loc5_ = _loc4_[2];
               _loc6_ = _loc5_ == CSSDimension.UNIT_DP?Number(this.applicationDpi):Number(this.deviceDPI);
               return new CSSDimension(Number(_loc4_[1]),_loc6_,_loc5_);
            }
            throw new Error("Unknown unit in css media query:" + param1);
         }
         return param1;
      }
      
      private function compareValues(param1:Object, param2:Object) : int
      {
         if(param1 is CSSOSVersion)
         {
            return CSSOSVersion(param1).compareTo(CSSOSVersion(param2));
         }
         if(param1 is CSSDimension)
         {
            return CSSDimension(param1).compareTo(CSSDimension(param2));
         }
         if(param1 == param2)
         {
            return 0;
         }
         if(param1 < param2)
         {
            return -1;
         }
         return 1;
      }
      
      private function deHyphenate(param1:String, param2:Boolean) : String
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:int = param1.indexOf("-");
         while(_loc3_ > 0)
         {
            _loc4_ = param1.substr(_loc3_ + 1);
            param1 = param1.substr(0,_loc3_);
            _loc5_ = _loc4_.charAt(0).toUpperCase();
            param1 = param1 + (_loc5_ + _loc4_.substr(1));
            _loc3_ = param1.indexOf("-");
         }
         if(param2)
         {
            _loc5_ = param1.charAt(0).toUpperCase();
            param1 = "flex" + _loc5_ + param1.substr(1);
         }
         return param1;
      }
      
      private function getPlatform() : String
      {
         var _loc1_:String = Capabilities.version.substr(0,3);
         if(platformMap.hasOwnProperty(_loc1_))
         {
            return platformMap[_loc1_] as String;
         }
         return _loc1_.toLowerCase();
      }
      
      private function getOSVersion() : CSSOSVersion
      {
         return new CSSOSVersion(Platform.osVersion);
      }
      
      private function computeDeviceDimensions() : Boolean
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         if(this.sm)
         {
            _loc1_ = this.sm.stage.stageWidth;
            _loc2_ = this.sm.stage.stageHeight;
            _loc3_ = Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_);
            _loc4_ = this.usesDeviceWidth && _loc1_ != this.deviceWidth.pixelValue || this.usesDeviceHeight && _loc2_ != this.deviceHeight.pixelValue;
            this.deviceWidth = new CSSDimension(_loc1_,this.deviceDPI);
            this.deviceHeight = new CSSDimension(_loc2_,this.deviceDPI);
            this.flexDeviceDiagonal = new CSSDimension(_loc3_,this.deviceDPI);
            return _loc4_;
         }
         return false;
      }
      
      private function stage_resizeHandler(param1:Event) : void
      {
         if(this.computeDeviceDimensions())
         {
            this.goodQueries = {};
            this.badQueries = {};
            this.reinitApplicationStyles();
         }
      }
      
      private function reinitApplicationStyles() : void
      {
         var _loc4_:int = 0;
         var _loc5_:ISystemManager = null;
         var _loc6_:Object = null;
         var _loc1_:IStyleManager2 = StyleManager.getStyleManager(this.sm);
         _loc1_.stylesRoot = null;
         _loc1_.initProtoChainRoots();
         var _loc2_:Array = SystemManagerGlobals.topLevelSystemManagers;
         var _loc3_:int = _loc2_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.getImplementation("mx.managers::ISystemManagerChildManager");
            _loc6_.regenerateStyleCache(true);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.getImplementation("mx.managers::ISystemManagerChildManager");
            _loc6_.notifyStyleChangeInChildren(null,true);
            _loc4_++;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deviceWidth() : CSSDimension
      {
         return this._1550605040deviceWidth;
      }
      
      public function set deviceWidth(param1:CSSDimension) : void
      {
         var _loc2_:Object = this._1550605040deviceWidth;
         if(_loc2_ !== param1)
         {
            this._1550605040deviceWidth = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deviceWidth",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deviceHeight() : CSSDimension
      {
         return this._1257110755deviceHeight;
      }
      
      public function set deviceHeight(param1:CSSDimension) : void
      {
         var _loc2_:Object = this._1257110755deviceHeight;
         if(_loc2_ !== param1)
         {
            this._1257110755deviceHeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deviceHeight",_loc2_,param1));
            }
         }
      }
   }
}
