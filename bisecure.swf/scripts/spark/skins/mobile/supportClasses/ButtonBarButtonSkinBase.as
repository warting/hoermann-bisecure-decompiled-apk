package spark.skins.mobile.supportClasses
{
   import spark.skins.mobile.ButtonSkin;
   
   public class ButtonBarButtonSkinBase extends ButtonSkin
   {
       
      
      protected var cornerRadius:int;
      
      protected var selectedBorderSkin:Class;
      
      public function ButtonBarButtonSkinBase()
      {
         super();
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         var _loc1_:* = currentState.indexOf("Selected") >= 0;
         if(_loc1_ && this.selectedBorderSkin)
         {
            return this.selectedBorderSkin;
         }
         if(_loc1_ || currentState.indexOf("down") >= 0)
         {
            return downBorderSkin;
         }
         return upBorderSkin;
      }
   }
}
