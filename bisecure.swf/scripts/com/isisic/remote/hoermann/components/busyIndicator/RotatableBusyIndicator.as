package com.isisic.remote.hoermann.components.busyIndicator
{
   import spark.core.SpriteVisualElement;
   
   public class RotatableBusyIndicator extends CustomBusyIndicator
   {
       
      
      private var _contentRotate:Number = 0;
      
      public function RotatableBusyIndicator()
      {
         super();
      }
      
      public function get contentRotate() : Number
      {
         return this._contentRotate;
      }
      
      public function set contentRotate(param1:Number) : void
      {
         if(param1 == this._contentRotate)
         {
            return;
         }
         this._contentRotate = param1;
         if(icon != null)
         {
            this.applyIconProperties();
         }
      }
      
      override protected function applyIconProperties() : void
      {
         var _loc1_:SpriteVisualElement = null;
         super.applyIconProperties();
         if(icon is SpriteVisualElement)
         {
            _loc1_ = icon as SpriteVisualElement;
            _loc1_.transformX = _loc1_.width / 2;
            _loc1_.transformY = _loc1_.height / 2;
            _loc1_.rotation = this.contentRotate;
         }
      }
   }
}
