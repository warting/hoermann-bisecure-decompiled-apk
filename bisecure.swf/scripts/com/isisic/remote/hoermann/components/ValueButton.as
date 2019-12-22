package com.isisic.remote.hoermann.components
{
   import com.isisic.remote.hoermann.global.Features;
   import com.isisic.remote.hoermann.global.PortTypes;
   import flash.utils.getDefinitionByName;
   import spark.components.Button;
   import spark.core.SpriteVisualElement;
   
   public class ValueButton extends Button
   {
       
      
      public var showDown:Boolean = false;
      
      public var value:Object;
      
      public function ValueButton()
      {
         super();
      }
      
      public static function fromPort(param1:Object, param2:Boolean = false) : ValueButton
      {
         var _loc3_:ValueButton = new ValueButton();
         _loc3_.value = param1;
         if(param2 || Features.showChannelOnButton)
         {
            _loc3_.label = param1.id;
         }
         _loc3_.setStyle("icon",getImageForPort(param1));
         return _loc3_;
      }
      
      public static function getImageForPort(param1:Object) : SpriteVisualElement
      {
         var _loc4_:Class = null;
         var _loc2_:String = "com.isisic.remote.hoermann.assets.images.ports.";
         var _loc3_:String = PortTypes.NAMES[param1.type];
         if(_loc3_ != null)
         {
            _loc4_ = getDefinitionByName(_loc2_ + _loc3_) as Class;
            return new _loc4_();
         }
         return null;
      }
   }
}
