package spark.skins.ios7
{
   import spark.skins.ios7.assets.ButtonBarLastButton_down;
   import spark.skins.ios7.assets.ButtonBarLastButton_up;
   
   public class ButtonBarLastButtonSkin extends IOS7ButtonBarButtonSkinBase
   {
       
      
      public function ButtonBarLastButtonSkin()
      {
         super();
         upBorderSkin = ButtonBarLastButton_up;
         downBorderSkin = ButtonBarLastButton_down;
         selectedBorderSkin = ButtonBarLastButton_down;
         selectedDownBorderSkin = ButtonBarLastButton_up;
      }
   }
}
