package spark.utils
{
   import flash.text.TextFormat;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.ISWFContext;
   import mx.core.IEmbeddedFontRegistry;
   import mx.core.IFlexModuleFactory;
   import mx.core.IUIComponent;
   import mx.core.Singleton;
   import mx.core.mx_internal;
   import mx.managers.ISystemManager;
   import mx.styles.IStyleClient;
   
   use namespace mx_internal;
   
   public class FTETextUtil
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      private static var staticTextFormat:TextFormat;
      
      private static var noEmbeddedFonts:Boolean;
      
      private static var _embeddedFontRegistry:IEmbeddedFontRegistry;
       
      
      public function FTETextUtil()
      {
         super();
      }
      
      private static function get embeddedFontRegistry() : IEmbeddedFontRegistry
      {
         if(!_embeddedFontRegistry && !noEmbeddedFonts)
         {
            try
            {
               _embeddedFontRegistry = IEmbeddedFontRegistry(Singleton.getInstance("mx.core::IEmbeddedFontRegistry"));
            }
            catch(e:Error)
            {
               noEmbeddedFonts = true;
            }
         }
         return _embeddedFontRegistry;
      }
      
      public static function calculateFontBaseline(param1:IStyleClient, param2:Number, param3:IFlexModuleFactory) : Number
      {
         var _loc5_:IFlexModuleFactory = null;
         var _loc6_:String = null;
         var _loc10_:TextLine = null;
         var _loc11_:ISWFContext = null;
         var _loc4_:FontDescription = new FontDescription();
         _loc6_ = param1.getStyle("cffHinting");
         if(_loc6_ != null)
         {
            _loc4_.cffHinting = _loc6_;
         }
         _loc6_ = param1.getStyle("fontFamily");
         if(_loc6_ != null)
         {
            _loc4_.fontName = _loc6_;
         }
         _loc6_ = param1.getStyle("fontLookup");
         if(_loc6_ != null)
         {
            if(_loc6_ == "auto")
            {
               _loc5_ = getEmbeddedFontContext(param1,param3);
               _loc6_ = !!_loc5_?FontLookup.EMBEDDED_CFF:FontLookup.DEVICE;
            }
            _loc4_.fontLookup = _loc6_;
         }
         _loc6_ = param1.getStyle("fontStyle");
         if(_loc6_ != null)
         {
            _loc4_.fontPosture = _loc6_;
         }
         _loc6_ = param1.getStyle("fontWeight");
         if(_loc6_ != null)
         {
            _loc4_.fontWeight = _loc6_;
         }
         var _loc7_:ElementFormat = new ElementFormat();
         _loc7_.fontDescription = _loc4_;
         _loc7_.fontSize = param1.getStyle("fontSize");
         var _loc8_:TextElement = new TextElement();
         _loc8_.elementFormat = _loc7_;
         _loc8_.text = "Wj";
         var _loc9_:TextBlock = new TextBlock();
         _loc9_.content = _loc8_;
         if(_loc5_)
         {
            _loc11_ = ISWFContext(_loc5_);
            _loc10_ = _loc11_.callInContext(_loc9_.createTextLine,_loc9_,[null,1000]);
         }
         else
         {
            _loc10_ = _loc9_.createTextLine(null,1000);
         }
         if(param2 < 2 + _loc10_.ascent + 2)
         {
            return int(param2 + (_loc10_.ascent - param2) / 2);
         }
         return 2 + _loc10_.ascent;
      }
      
      private static function getEmbeddedFontContext(param1:IStyleClient, param2:IFlexModuleFactory) : IFlexModuleFactory
      {
         var _loc3_:IFlexModuleFactory = null;
         var _loc5_:String = null;
         var _loc6_:* = false;
         var _loc7_:* = false;
         var _loc8_:ISystemManager = null;
         var _loc9_:IUIComponent = null;
         var _loc4_:String = param1.getStyle("fontLookup");
         if(_loc4_ != FontLookup.DEVICE)
         {
            _loc5_ = param1.getStyle("fontFamily");
            _loc6_ = param1.getStyle("fontWeight") == "bold";
            _loc7_ = param1.getStyle("fontStyle") == "italic";
            if(param2 != null && param2 is ISystemManager)
            {
               _loc8_ = ISystemManager(param2);
            }
            else if(param1 is IUIComponent)
            {
               _loc9_ = IUIComponent(param1);
               if(_loc9_.parent is IUIComponent)
               {
                  _loc8_ = IUIComponent(_loc9_.parent).systemManager;
               }
            }
            if(embeddedFontRegistry)
            {
               _loc3_ = embeddedFontRegistry.getAssociatedModuleFactory(_loc5_,_loc6_,_loc7_,param1,param2,_loc8_,true);
            }
         }
         if(!_loc3_ && _loc4_ == FontLookup.EMBEDDED_CFF)
         {
            _loc3_ = param2;
         }
         return _loc3_;
      }
   }
}
