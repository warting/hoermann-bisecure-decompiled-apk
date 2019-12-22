package flashx.textLayout.conversion
{
   import flashx.textLayout.tlf_internal;
   
   public class ConverterBase
   {
      
      public static const MERGE_TO_NEXT_ON_PASTE:String = "mergeToNextOnPaste";
       
      
      private var _errors:Vector.<String> = null;
      
      private var _throwOnError:Boolean = false;
      
      private var _useClipboardAnnotations:Boolean = false;
      
      private var _config:ImportExportConfiguration;
      
      public function ConverterBase()
      {
         super();
      }
      
      public function get errors() : Vector.<String>
      {
         return this._errors;
      }
      
      public function get throwOnError() : Boolean
      {
         return this._throwOnError;
      }
      
      public function set throwOnError(param1:Boolean) : void
      {
         this._throwOnError = param1;
      }
      
      tlf_internal function clear() : void
      {
         this._errors = null;
      }
      
      tlf_internal function reportError(param1:String) : void
      {
         if(this._throwOnError)
         {
            throw new Error(param1);
         }
         if(!this._errors)
         {
            this._errors = new Vector.<String>();
         }
         this._errors.push(param1);
      }
      
      public function get useClipboardAnnotations() : Boolean
      {
         return this._useClipboardAnnotations;
      }
      
      public function set useClipboardAnnotations(param1:Boolean) : void
      {
         this._useClipboardAnnotations = param1;
      }
      
      public function get config() : ImportExportConfiguration
      {
         return this._config;
      }
      
      public function set config(param1:ImportExportConfiguration) : void
      {
         this._config = param1;
      }
   }
}
