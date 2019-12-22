package spark.skins.mobile
{
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import spark.components.ViewMenu;
   import spark.components.ViewNavigator;
   import spark.components.ViewNavigatorApplication;
   import spark.skins.mobile.supportClasses.MobileSkin;
   
   public class ViewNavigatorApplicationSkin extends MobileSkin
   {
       
      
      public var navigator:ViewNavigator;
      
      public var viewMenu:IFactory;
      
      public var hostComponent:ViewNavigatorApplication;
      
      public function ViewNavigatorApplicationSkin()
      {
         super();
         this.viewMenu = new ClassFactory(ViewMenu);
      }
      
      override protected function createChildren() : void
      {
         this.navigator = new ViewNavigator();
         this.navigator.id = "navigator";
         addChild(this.navigator);
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = this.navigator.getPreferredBoundsWidth();
         measuredHeight = this.navigator.getPreferredBoundsHeight();
      }
      
      override protected function layoutContents(param1:Number, param2:Number) : void
      {
         super.layoutContents(param1,param2);
         var _loc3_:Number = Number(getStyle("osStatusBarHeight"));
         if(isNaN(_loc3_))
         {
            _loc3_ = 0;
         }
         this.navigator.setLayoutBoundsSize(param1,param2 - _loc3_);
         this.navigator.setLayoutBoundsPosition(0,_loc3_);
      }
   }
}
