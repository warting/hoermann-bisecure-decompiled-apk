package com.isisic.remote.hoermann.skins
{
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderDown;
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderDownSelected;
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderUp;
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderUpSelected;
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_SymbolDown;
   import com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_SymbolUp;
   import mx.core.DPIClassification;
   import spark.skins.mobile.CheckBoxSkin;
   
   public class CheckboxSkin extends CheckBoxSkin
   {
       
      
      public function CheckboxSkin()
      {
         super();
         layoutPaddingLeft = 0;
         layoutPaddingRight = 0;
         layoutPaddingTop = 0;
         layoutPaddingBottom = 0;
         switch(applicationDPI)
         {
            case DPIClassification.DPI_320:
               upIconClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderUp;
               upSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderUpSelected;
               downIconClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderDown;
               downSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_BorderDownSelected;
               upSymbolIconClass = null;
               upSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_SymbolUp;
               downSymbolIconClass = null;
               downSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.moblie_320.Checkbox_SymbolDown;
               layoutGap = 20;
               minWidth = 64;
               minHeight = 64;
               layoutBorderSize = 4;
               break;
            case DPIClassification.DPI_240:
               upIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_BorderUp;
               upSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_BorderUpSelected;
               downIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_BorderDown;
               downSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_BorderDownSelected;
               upSymbolIconClass = null;
               upSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_SymbolUp;
               downSymbolIconClass = null;
               downSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_240.Checkbox_SymbolDown;
               layoutGap = 15;
               minWidth = 48;
               minHeight = 48;
               layoutBorderSize = 2;
               break;
            default:
               upIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_BorderUp;
               upSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_BorderUpSelected;
               downIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_BorderDown;
               downSelectedIconClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_BorderDownSelected;
               upSymbolIconClass = null;
               upSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_SymbolUp;
               downSymbolIconClass = null;
               downSymbolIconSelectedClass = com.isisic.remote.hoermann.assets.images.checkBox.mobile_160.Checkbox_SymbolDown;
               layoutGap = 10;
               minWidth = 32;
               minHeight = 32;
               layoutBorderSize = 2;
         }
      }
      
      override protected function drawBackground(param1:Number, param2:Number) : void
      {
      }
   }
}
