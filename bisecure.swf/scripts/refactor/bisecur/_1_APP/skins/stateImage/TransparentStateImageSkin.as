package refactor.bisecur._1_APP.skins.stateImage
{
   import refactor.bisecur._1_APP.components.stateImages.StateImageBase;
   
   public class TransparentStateImageSkin extends StateImageSkin
   {
       
      
      public function TransparentStateImageSkin()
      {
         super();
         setStyle("backgroundAlpha",0);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(imageRect != (hostComponent as StateImageBase).imageRect)
         {
            imageRect = (hostComponent as StateImageBase).imageRect;
         }
         super.updateDisplayList(param1,param2);
         graphics.clear();
         var _loc3_:Number = (param1 - (imageRect.x + imageRect.width)) * 2;
         if(param1 < _loc3_ + imageRect.width)
         {
            (hostComponent as StateImageBase).stateHeight = (param1 - _loc3_) * (imageRect.height / imageRect.width);
         }
      }
   }
}
