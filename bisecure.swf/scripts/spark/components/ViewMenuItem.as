package spark.components
{
   import mx.core.mx_internal;
   import spark.components.supportClasses.ButtonBase;
   
   use namespace mx_internal;
   
   public class ViewMenuItem extends ButtonBase
   {
       
      
      private var _showsCaret:Boolean = false;
      
      public function ViewMenuItem()
      {
         super();
         skinDestructionPolicy = "auto";
      }
      
      public function get showsCaret() : Boolean
      {
         return this._showsCaret;
      }
      
      public function set showsCaret(param1:Boolean) : void
      {
         if(param1 == this._showsCaret)
         {
            return;
         }
         this._showsCaret = param1;
         invalidateSkinState();
         invalidateDisplayList();
      }
      
      override protected function getCurrentSkinState() : String
      {
         var _loc1_:String = super.getCurrentSkinState();
         if(this.showsCaret && enabled && _loc1_ != "down")
         {
            return "showsCaret";
         }
         return _loc1_;
      }
   }
}
