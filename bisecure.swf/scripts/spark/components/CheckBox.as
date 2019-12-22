package spark.components
{
   import mx.core.mx_internal;
   import spark.components.supportClasses.ToggleButtonBase;
   
   use namespace mx_internal;
   
   public class CheckBox extends ToggleButtonBase
   {
      
      mx_internal static const VERSION:String = "4.16.1.0";
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      private static const focusExclusions:Array = ["labelDisplay"];
       
      
      public function CheckBox()
      {
         super();
      }
      
      public function get gap() : int
      {
         return int(getStyle("gap"));
      }
      
      public function set gap(param1:int) : void
      {
         setStyle("gap",param1);
      }
      
      public function get labelPlacement() : String
      {
         return String(getStyle("labelPlacement"));
      }
      
      public function set labelPlacement(param1:String) : void
      {
         setStyle("labelPlacement",param1);
      }
      
      override public function get suggestedFocusSkinExclusions() : Array
      {
         return focusExclusions;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CheckBox.createAccessibilityImplementation != null)
         {
            CheckBox.createAccessibilityImplementation(this);
         }
      }
   }
}
