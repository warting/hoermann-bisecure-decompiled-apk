package spark.skins.ios7
{
   import spark.skins.ios7.assets.ButtonBarMiddleButton_down;
   import spark.skins.ios7.assets.ButtonBarMiddleButton_up;
   
   public class ButtonBarMiddleButtonSkin extends IOS7ButtonBarButtonSkinBase
   {
       
      
      public function ButtonBarMiddleButtonSkin()
      {
         super();
         upBorderSkin = ButtonBarMiddleButton_up;
         downBorderSkin = ButtonBarMiddleButton_down;
         selectedBorderSkin = ButtonBarMiddleButton_down;
         selectedDownBorderSkin = ButtonBarMiddleButton_up;
      }
   }
}
