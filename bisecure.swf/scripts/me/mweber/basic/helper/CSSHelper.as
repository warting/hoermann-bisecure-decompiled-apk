package me.mweber.basic.helper
{
   import me.mweber.basic.Debug;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   
   public class CSSHelper
   {
       
      
      public function CSSHelper()
      {
         super();
      }
      
      public static function applyForStylename(param1:String, param2:*, param3:String, param4:UIComponent) : Boolean
      {
         var _loc5_:CSSStyleDeclaration = param4.styleManager.getStyleDeclaration(param3);
         if(_loc5_)
         {
            _loc5_.setStyle(param1,param2);
            return true;
         }
         Debug.warning("[CSSHelper] styleName \'" + param3 + "\' not found");
         return false;
      }
   }
}
