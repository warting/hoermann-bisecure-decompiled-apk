package com.isisic.remote.hoermann.skins
{
   import com.isisic.remote.hoermann.components.BiSecurViewNavigator;
   import spark.skins.mobile.ViewNavigatorApplicationSkin;
   
   public class BiSecurViewNavigatorApplicationSkin extends ViewNavigatorApplicationSkin
   {
       
      
      public function BiSecurViewNavigatorApplicationSkin()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         navigator = new BiSecurViewNavigator();
         navigator.id = "navigator";
         addChild(navigator);
      }
   }
}
