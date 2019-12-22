package spark.formatters
{
   import mx.core.mx_internal;
   import mx.formatters.IFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.globalization.LastOperationStatus;
   import spark.globalization.supportClasses.GlobalizationBase;
   
   use namespace mx_internal;
   
   public class DateTimeFormatter extends GlobalizationBase implements IFormatter
   {
      
      private static const DATE_STYLE:String = "dateStyle";
      
      private static const TIME_STYLE:String = "timeStyle";
      
      private static const DATE_TIME_PATTERN:String = "dateTimePattern";
      
      private static const UNDEFINED_DATE:Date = new Date(undefined);
       
      
      private var resourceManager:IResourceManager;
      
      private var timeStyleOverride:String = "long";
      
      private var dateStyleOverride:String = "long";
      
      private var dateTimePatternOverride:String = null;
      
      private var fallbackFormatter:FallbackDateTimeFormatter = null;
      
      private var _g11nWorkingInstance:flash.globalization.DateTimeFormatter = null;
      
      private var _errorText:String;
      
      private var _useUTC:Boolean = false;
      
      public function DateTimeFormatter()
      {
         this.resourceManager = ResourceManager.getInstance();
         super();
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var _loc1_:Vector.<String> = flash.globalization.DateTimeFormatter.getAvailableLocaleIDNames();
         return !!_loc1_?_loc1_:new Vector.<String>["en-US"]();
      }
      
      private function get g11nWorkingInstance() : flash.globalization.DateTimeFormatter
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      private function set g11nWorkingInstance(param1:flash.globalization.DateTimeFormatter) : void
      {
         this._g11nWorkingInstance = param1;
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.actualLocaleIDName;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return "en-US";
      }
      
      [Bindable("change")]
      override public function get lastOperationStatus() : String
      {
         return !!this.g11nWorkingInstance?this.g11nWorkingInstance.lastOperationStatus:fallbackLastOperationStatus;
      }
      
      [Bindable("change")]
      override mx_internal function get useFallback() : Boolean
      {
         return this.g11nWorkingInstance == null;
      }
      
      [Bindable("change")]
      public function get dateStyle() : String
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getDateStyle();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.dateStyle;
      }
      
      public function set dateStyle(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.dateStyleOverride && this.dateStyleOverride == param1)
         {
            return;
         }
         this.dateStyleOverride = param1;
         if(this.g11nWorkingInstance)
         {
            this.g11nWorkingInstance.setDateTimeStyles(param1,this.timeStyleOverride);
            this.dateTimePatternOverride = null;
         }
         else
         {
            if(!FallbackDateTimeFormatter.validDateTimeStyle(param1))
            {
               _loc2_ = this.resourceManager.getString("core","badParameter",[this.dateStyle]);
               throw new ArgumentError(_loc2_);
            }
            if(this.fallbackFormatter)
            {
               this.fallbackFormatter.dateStyle = param1;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get dateTimePattern() : String
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getDateTimePattern();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.dateTimePattern;
      }
      
      public function set dateTimePattern(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.dateTimePatternOverride && this.dateTimePatternOverride == param1)
         {
            return;
         }
         this.dateTimePatternOverride = param1;
         if(this.g11nWorkingInstance)
         {
            this.g11nWorkingInstance.setDateTimePattern(param1);
         }
         else
         {
            if(!param1)
            {
               _loc2_ = this.resourceManager.getString("core","nullParameter",[this.dateTimePattern]);
               throw new TypeError(_loc2_);
            }
            if(this.fallbackFormatter)
            {
               this.fallbackFormatter.dateTimePattern = param1;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get errorText() : String
      {
         return this._errorText;
      }
      
      public function set errorText(param1:String) : void
      {
         if(this._errorText == param1)
         {
            return;
         }
         this._errorText = param1;
         update();
      }
      
      [Bindable("change")]
      public function get timeStyle() : String
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getTimeStyle();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return this.fallbackFormatter.timeStyle;
      }
      
      public function set timeStyle(param1:String) : void
      {
         var _loc2_:String = null;
         if(this.timeStyleOverride && this.timeStyleOverride == param1)
         {
            return;
         }
         this.timeStyleOverride = param1;
         if(this.g11nWorkingInstance)
         {
            this.g11nWorkingInstance.setDateTimeStyles(this.dateStyleOverride,param1);
            this.dateTimePatternOverride = null;
         }
         else
         {
            if(!FallbackDateTimeFormatter.validDateTimeStyle(param1))
            {
               _loc2_ = this.resourceManager.getString("core","badParameter",[this.timeStyle]);
               throw new ArgumentError(_loc2_);
            }
            if(this.fallbackFormatter)
            {
               this.fallbackFormatter.timeStyle = param1;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get useUTC() : Boolean
      {
         return this._useUTC;
      }
      
      public function set useUTC(param1:Boolean) : void
      {
         this._useUTC = param1;
         update();
      }
      
      override mx_internal function createWorkingInstance() : void
      {
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            this.g11nWorkingInstance = null;
            properties = null;
            return;
         }
         if(enforceFallback)
         {
            this.fallbackInstantiate();
            this.g11nWorkingInstance = null;
            return;
         }
         this.g11nWorkingInstance = new flash.globalization.DateTimeFormatter(localeStyle,this.dateStyleOverride,this.timeStyleOverride);
         if(this.g11nWorkingInstance && this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            if(this.dateTimePatternOverride)
            {
               this.g11nWorkingInstance.setDateTimePattern(this.dateTimePatternOverride);
            }
            properties = this.g11nWorkingInstance;
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
         this.fallbackInstantiate();
         this.g11nWorkingInstance = null;
         if(this.fallbackFormatter.fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
         {
            this.fallbackFormatter.fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         }
      }
      
      [Bindable("change")]
      public function format(param1:Object) : String
      {
         var _loc3_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Date = param1 is Date?param1 as Date:new Date(param1);
         if(_loc2_ == UNDEFINED_DATE)
         {
            if(this.g11nWorkingInstance)
            {
               this.g11nWorkingInstance.setDateTimeStyles(null,null);
            }
            else
            {
               fallbackLastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
            }
            return this.errorText;
         }
         if(this.g11nWorkingInstance)
         {
            _loc3_ = !!this._useUTC?this.g11nWorkingInstance.formatUTC(_loc2_):this.g11nWorkingInstance.format(_loc2_);
            return this.errorText && LastOperationStatus.isError(this.g11nWorkingInstance.lastOperationStatus)?this.errorText:_loc3_;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return this.errorText;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return !!this._useUTC?this.fallbackFormatter.formatUTC(_loc2_):this.fallbackFormatter.format(_loc2_);
      }
      
      [Bindable("change")]
      public function getMonthNames(param1:String = "full", param2:String = "standalone") : Vector.<String>
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getMonthNames(param1,param2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this.fallbackFormatter.getMonthNames(param1,param2);
      }
      
      [Bindable("change")]
      public function getWeekdayNames(param1:String = "full", param2:String = "standalone") : Vector.<String>
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getWeekdayNames(param1,param2);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this.fallbackFormatter.getWeekdayNames(param1,param2);
      }
      
      [Bindable("change")]
      public function getFirstWeekday() : int
      {
         if(this.g11nWorkingInstance)
         {
            return this.g11nWorkingInstance.getFirstWeekday();
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return 0;
      }
      
      private function fallbackInstantiate() : void
      {
         this.fallbackFormatter = new FallbackDateTimeFormatter();
         if(this.dateStyleOverride)
         {
            this.fallbackFormatter.dateStyle = this.dateStyleOverride;
         }
         if(this.timeStyleOverride)
         {
            this.fallbackFormatter.timeStyle = this.timeStyleOverride;
         }
         if(this.dateTimePatternOverride)
         {
            this.fallbackFormatter.dateTimePattern = this.dateTimePatternOverride;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
      }
   }
}

import flash.globalization.DateTimeNameStyle;
import flash.globalization.DateTimeStyle;
import spark.globalization.LastOperationStatus;

final class FallbackDateTimeFormatter
{
   
   private static const SHORT_DATE_PATTERN:String = "m/d/yyyy";
   
   private static const MEDIUM_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
   
   private static const LONG_DATE_PATTERN:String = "dddd, mmmm d, yyyy";
   
   private static const NONE_DATE_PATTERN:String = "";
   
   private static const SHORT_TIME_PATTERN:String = "hh:mm a";
   
   private static const MEDIUM_TIME_PATTERN:String = "hh:mm:ss a";
   
   private static const LONG_TIME_PATTERN:String = "hh:mm:ss a";
   
   private static const NONE_TIME_PATTERN:String = "";
   
   private static const WEEKDAY_LABELS:Vector.<String> = new <String>["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
   
   private static const WEEKDAY_LABELS_LONG_ABB:Vector.<String> = new <String>["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
   
   private static const WEEKDAY_LABELS_SHORT_ABB:Vector.<String> = new <String>["S","M","T","W","T","F","S"];
   
   private static const MONTH_LABELS:Vector.<String> = new <String>["January","February","March","April","May","June","July","August","September","October","November","December"];
   
   private static const MONTH_LABELS_LONG_ABB:Vector.<String> = new <String>["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
   
   private static const MONTH_LABELS_SHORT_ABB:Vector.<String> = new <String>["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    
   
   private var utc:Boolean;
   
   private var dateString:String;
   
   private var timeString:String;
   
   private var localTime:String;
   
   private var thisDate:Date;
   
   public var fallbackLastOperationStatus:String;
   
   private var _timeStyle:String;
   
   private var _dateStyle:String;
   
   private var _dateTimePatternString:String;
   
   function FallbackDateTimeFormatter()
   {
      super();
   }
   
   public static function validDateTimeStyle(param1:String) : Boolean
   {
      return param1 && (param1 == DateTimeStyle.LONG || param1 == DateTimeStyle.MEDIUM || param1 == DateTimeStyle.SHORT || param1 == DateTimeStyle.NONE);
   }
   
   public function set timeStyle(param1:String) : void
   {
      if(param1)
      {
         this._timeStyle = param1;
      }
   }
   
   public function get timeStyle() : String
   {
      return this._timeStyle;
   }
   
   public function set dateStyle(param1:String) : void
   {
      if(param1)
      {
         this._dateStyle = param1;
      }
   }
   
   public function get dateStyle() : String
   {
      return this._dateStyle;
   }
   
   public function get dateTimePattern() : String
   {
      switch(this.dateStyle)
      {
         case DateTimeStyle.SHORT:
            this.dateString = SHORT_DATE_PATTERN;
            break;
         case DateTimeStyle.MEDIUM:
            this.dateString = LONG_DATE_PATTERN;
            break;
         case DateTimeStyle.NONE:
            this.dateString = NONE_DATE_PATTERN;
            break;
         default:
            this.dateString = LONG_DATE_PATTERN;
      }
      switch(this.timeStyle)
      {
         case DateTimeStyle.SHORT:
            this.timeString = SHORT_TIME_PATTERN;
            break;
         case DateTimeStyle.MEDIUM:
            this.timeString = LONG_TIME_PATTERN;
            break;
         case DateTimeStyle.NONE:
            this.timeString = NONE_TIME_PATTERN;
            break;
         default:
            this.timeString = LONG_TIME_PATTERN;
      }
      return this.dateString + this.returnSpace() + this.timeString;
   }
   
   public function set dateTimePattern(param1:String) : void
   {
      this._dateTimePatternString = param1;
      this.fallbackLastOperationStatus = LastOperationStatus.UNSUPPORTED_ERROR;
   }
   
   public function format(param1:Date) : String
   {
      this.thisDate = param1;
      this.utc = false;
      return this.returnDate(param1) + this.returnSpace() + this.returnTime(param1);
   }
   
   public function formatUTC(param1:Date) : String
   {
      this.thisDate = param1;
      this.utc = true;
      return this.returnDate(param1) + this.returnSpace() + this.returnTime(param1);
   }
   
   public function getMonthNames(param1:String = "full", param2:String = "standalone") : Vector.<String>
   {
      switch(param1)
      {
         case DateTimeNameStyle.SHORT_ABBREVIATION:
            return MONTH_LABELS_SHORT_ABB;
         case DateTimeNameStyle.LONG_ABBREVIATION:
            return MONTH_LABELS_LONG_ABB;
         default:
            return MONTH_LABELS;
      }
   }
   
   public function getWeekdayNames(param1:String = "full", param2:String = "standalone") : Vector.<String>
   {
      switch(param1)
      {
         case DateTimeNameStyle.SHORT_ABBREVIATION:
            return WEEKDAY_LABELS_SHORT_ABB;
         case DateTimeNameStyle.LONG_ABBREVIATION:
            return WEEKDAY_LABELS_LONG_ABB;
         default:
            return WEEKDAY_LABELS;
      }
   }
   
   private function returnSpace() : String
   {
      var _loc1_:Boolean = this.thisDate && isNaN(this.thisDate.fullYear);
      var _loc2_:Boolean = this.dateStyle == DateTimeStyle.NONE || this.timeStyle == DateTimeStyle.NONE;
      return _loc1_ || _loc2_?"":" ";
   }
   
   private function returnDate(param1:Date) : String
   {
      if(isNaN(param1.fullYear))
      {
         return "";
      }
      switch(this.dateStyle)
      {
         case DateTimeStyle.SHORT:
            return this.shortDate(param1);
         case DateTimeStyle.MEDIUM:
            return this.longDate(param1);
         case DateTimeStyle.NONE:
            return "";
         default:
            return this.longDate(param1);
      }
   }
   
   private function returnTime(param1:Date) : String
   {
      if(isNaN(param1.hours))
      {
         return "";
      }
      switch(this.timeStyle)
      {
         case DateTimeStyle.SHORT:
            return this.shortTime(param1);
         case DateTimeStyle.MEDIUM:
            return this.longTime(param1);
         case DateTimeStyle.NONE:
            return "";
         default:
            return this.longTime(param1);
      }
   }
   
   private function shortDate(param1:Date) : String
   {
      if(this.utc)
      {
         return param1.getUTCMonth() + 1 + "/" + param1.getUTCDate() + "/" + param1.getUTCFullYear();
      }
      return param1.getMonth() + 1 + "/" + param1.getDate() + "/" + param1.getFullYear();
   }
   
   private function longDate(param1:Date) : String
   {
      if(this.utc)
      {
         return WEEKDAY_LABELS[param1.getUTCDay()] + "," + " " + MONTH_LABELS[param1.getUTCMonth()] + " " + param1.getUTCDate() + "," + " " + param1.getUTCFullYear();
      }
      return WEEKDAY_LABELS[param1.getDay()] + "," + " " + MONTH_LABELS[param1.getMonth()] + " " + param1.getDate() + "," + " " + param1.getFullYear();
   }
   
   private function shortTime(param1:Date) : String
   {
      this.localTime = !!this.utc?this.getUSClockTime(param1.getUTCHours(),param1.getUTCMinutes()):this.getUSClockTime(param1.getHours(),param1.getMinutes());
      return this.localTime + " " + this.formatAMPM(param1);
   }
   
   private function longTime(param1:Date) : String
   {
      var _loc2_:Number = NaN;
      if(this.utc)
      {
         this.localTime = this.getUSClockTime(param1.getUTCHours(),param1.getUTCMinutes());
         _loc2_ = param1.getUTCSeconds();
      }
      else
      {
         this.localTime = this.getUSClockTime(param1.getHours(),param1.getMinutes());
         _loc2_ = param1.getSeconds();
      }
      return this.localTime + ":" + this.doubleDigitFormat(_loc2_) + " " + this.formatAMPM(param1);
   }
   
   private function getUSClockTime(param1:uint, param2:uint) : String
   {
      var _loc3_:String = this.doubleDigitFormat(param2);
      param1 = param1 % 12;
      param1 = !!param1?uint(param1):uint(12);
      return param1 + ":" + _loc3_;
   }
   
   private function doubleDigitFormat(param1:uint) : String
   {
      return (param1 < 10?"0":"") + String(param1);
   }
   
   private function formatAMPM(param1:Date) : String
   {
      var _loc2_:Number = !!this.utc?Number(param1.getUTCHours()):Number(param1.getHours());
      return _loc2_ < 12?"AM":"PM";
   }
}
