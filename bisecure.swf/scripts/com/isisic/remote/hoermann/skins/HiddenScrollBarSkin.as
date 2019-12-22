package com.isisic.remote.hoermann.skins
{
   import spark.skins.mobile.HScrollBarSkin;
   
   public class HiddenScrollBarSkin extends HScrollBarSkin
   {
       
      
      public function HiddenScrollBarSkin()
      {
         super();
         alpha = 0;
         visible = false;
      }
   }
}
