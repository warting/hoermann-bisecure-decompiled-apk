package spark.skins.ios7
{
   import mx.core.DPIClassification;
   import spark.skins.mobile.supportClasses.ButtonBarButtonSkinBase;
   
   public class IOS7ButtonBarButtonSkinBase extends ButtonBarButtonSkinBase
   {
       
      
      protected var selectedDownBorderSkin:Class;
      
      public function IOS7ButtonBarButtonSkinBase()
      {
         super();
         switch(applicationDPI)
         {
            case DPIClassification.DPI_640:
               measuredDefaultHeight = 116;
               measuredDefaultWidth = 400;
               break;
            case DPIClassification.DPI_480:
               measuredDefaultHeight = 88;
               measuredDefaultWidth = 300;
               break;
            case DPIClassification.DPI_320:
               measuredDefaultHeight = 58;
               measuredDefaultWidth = 200;
               break;
            case DPIClassification.DPI_240:
               measuredDefaultHeight = 44;
               measuredDefaultWidth = 150;
               break;
            case DPIClassification.DPI_120:
               measuredDefaultHeight = 22;
               measuredDefaultWidth = 75;
               break;
            default:
               measuredDefaultHeight = 29;
               measuredDefaultWidth = 100;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
      }
      
      override protected function getBorderClassForCurrentState() : Class
      {
         var _loc1_:* = currentState.indexOf("Selected") >= 0;
         var _loc2_:* = currentState.indexOf("down") >= 0;
         if(_loc1_ && !_loc2_)
         {
            return selectedBorderSkin;
         }
         if(_loc1_ && _loc2_)
         {
            return this.selectedDownBorderSkin;
         }
         if(!_loc1_ && !_loc2_)
         {
            return upBorderSkin;
         }
         return downBorderSkin;
      }
      
      override protected function commitCurrentState() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.commitCurrentState();
         var _loc1_:* = currentState.indexOf("Selected") >= 0;
         var _loc2_:* = currentState.indexOf("down") >= 0;
         if(this.xor(_loc1_,_loc2_))
         {
            _loc3_ = getStyle("highlightTextColor");
            labelDisplay.setStyle("color",_loc3_);
         }
         else
         {
            _loc4_ = getStyle("color");
            labelDisplay.setStyle("color",_loc4_);
         }
      }
      
      private function xor(param1:Boolean, param2:Boolean) : Boolean
      {
         return !(param1 && param2) && (param1 || param2);
      }
   }
}
