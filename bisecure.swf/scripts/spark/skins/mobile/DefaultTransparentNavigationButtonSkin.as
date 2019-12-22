package spark.skins.mobile
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DefaultTransparentNavigationButtonSkin extends TransparentNavigationButtonSkin
   {
       
      
      public function DefaultTransparentNavigationButtonSkin()
      {
         super();
         fillColorStyleName = "accentColor";
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
         graphics.beginFill(getStyle(fillColorStyleName));
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
   }
}
