package spark.skins.android4
{
   import spark.skins.android4.assets.ButtonBarFirstButton_down;
   import spark.skins.android4.assets.ButtonBarFirstButton_selectedDown;
   import spark.skins.android4.assets.ButtonBarFirstButton_selectedUp;
   import spark.skins.android4.assets.ButtonBarFirstButton_up;
   import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;
   
   public class ButtonBarFirstButtonSkin extends ButtonBarButtonSkinBase
   {
       
      
      protected var selectedDownBorderSkin:Class;
      
      public function ButtonBarFirstButtonSkin()
      {
         super();
         upBorderSkin = ButtonBarFirstButton_up;
         downBorderSkin = ButtonBarFirstButton_down;
         selectedBorderSkin = ButtonBarFirstButton_selectedUp;
         this.selectedDownBorderSkin = ButtonBarFirstButton_selectedDown;
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         var _loc1_:* = currentState.indexOf("Selected") >= 0;
         var _loc2_:* = currentState.indexOf("down") >= 0;
         if(_loc1_ && !_loc2_)
         {
            return selectedBorderSkin;
         }
         if(_loc1_ && _loc2_)
         {
            return this.selectedDownBorderSkin;
         }
         if(!_loc1_ && !_loc2_)
         {
            return upBorderSkin;
         }
         return downBorderSkin;
      }
   }
}
