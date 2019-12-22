package spark.globalization.supportClasses
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import mx.core.FlexGlobals;
   import mx.core.mx_internal;
   import mx.styles.AdvancedStyleClient;
   import spark.globalization.LastOperationStatus;
   
   use namespace mx_internal;
   
   public class GlobalizationBase extends AdvancedStyleClient
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
       
      
      private var basicProperties:Object = null;
      
      mx_internal var properties:Object = null;
      
      mx_internal var localeStyle;
      
      mx_internal var fallbackLastOperationStatus:String = "noError";
      
      private var _enforceFallback:Boolean = false;
      
      public function GlobalizationBase()
      {
         super();
      }
      
      [Bindable("change")]
      public function get actualLocaleIDName() : String
      {
         throw new IllegalOperationError();
      }
      
      mx_internal function get enforceFallback() : Boolean
      {
         return this._enforceFallback;
      }
      
      mx_internal function set enforceFallback(param1:Boolean) : void
      {
         if(this._enforceFallback == param1)
         {
            return;
         }
         this._enforceFallback = param1;
         if(this.localeStyle == null)
         {
            return;
         }
         this.createWorkingInstance();
         this.update();
      }
      
      [Bindable("change")]
      public function get lastOperationStatus() : String
      {
         throw new IllegalOperationError();
      }
      
      [Bindable("change")]
      mx_internal function get useFallback() : Boolean
      {
         throw new IllegalOperationError();
      }
      
      override public function getStyle(param1:String) : *
      {
         if(param1 != "locale")
         {
            return super.getStyle(param1);
         }
         if(this.localeStyle !== undefined && this.localeStyle !== null)
         {
            return this.localeStyle;
         }
         if(styleParent)
         {
            return styleParent.getStyle(param1);
         }
         if(FlexGlobals.topLevelApplication)
         {
            return FlexGlobals.topLevelApplication.getStyle(param1);
         }
         return undefined;
      }
      
      override public function setStyle(param1:String, param2:*) : void
      {
         super.setStyle(param1,param2);
         if(param1 != "locale")
         {
            return;
         }
         this.localeChanged();
      }
      
      override public function styleChanged(param1:String) : void
      {
         this.localeChanged();
         super.styleChanged(param1);
      }
      
      mx_internal function createWorkingInstance() : void
      {
         throw new IllegalOperationError();
      }
      
      mx_internal function ensureStyleSource() : void
      {
         if(!styleParent && (this.localeStyle === undefined || this.localeStyle === null))
         {
            if(FlexGlobals.topLevelApplication)
            {
               FlexGlobals.topLevelApplication.addStyleClient(this);
            }
         }
      }
      
      mx_internal function propagateBasicProperties(param1:Object) : void
      {
         var _loc2_:* = null;
         if(this.basicProperties)
         {
            for(_loc2_ in this.basicProperties)
            {
               param1[_loc2_] = this.basicProperties[_loc2_];
            }
         }
      }
      
      mx_internal function getBasicProperty(param1:Object, param2:String) : *
      {
         this.ensureStyleSource();
         if(param1)
         {
            return param1[param2];
         }
         if(this.properties)
         {
            return this.properties[param2];
         }
         if(this.localeStyle === undefined || this.localeStyle === null)
         {
            this.fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
         }
         return undefined;
      }
      
      mx_internal function setBasicProperty(param1:Object, param2:String, param3:*) : void
      {
         this.fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         if(this.basicProperties)
         {
            if(this.basicProperties[param2] == param3)
            {
               return;
            }
         }
         else
         {
            this.basicProperties = new Object();
         }
         this.basicProperties[param2] = param3;
         if(param1)
         {
            param1[param2] = param3;
         }
         this.update();
      }
      
      mx_internal function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function localeChanged() : void
      {
         var _loc1_:* = super.getStyle("locale");
         if(this.localeStyle === _loc1_)
         {
            return;
         }
         this.localeStyle = _loc1_;
         this.createWorkingInstance();
         this.update();
      }
   }
}
