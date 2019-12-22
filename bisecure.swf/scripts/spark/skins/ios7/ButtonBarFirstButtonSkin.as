package spark.skins.ios7
{
   import spark.skins.ios7.assets.ButtonBarFirstButton_down;
   import spark.skins.ios7.assets.ButtonBarFirstButton_up;
   
   public class ButtonBarFirstButtonSkin extends IOS7ButtonBarButtonSkinBase
   {
       
      
      public function ButtonBarFirstButtonSkin()
      {
         super();
         upBorderSkin = ButtonBarFirstButton_up;
         downBorderSkin = ButtonBarFirstButton_down;
         selectedBorderSkin = ButtonBarFirstButton_down;
         selectedDownBorderSkin = ButtonBarFirstButton_up;
      }
   }
}
