package com.isisic.remote.hoermann.components
{
   import com.isisic.remote.hoermann.skins.VLineSkin;
   import spark.components.supportClasses.SkinnableComponent;
   
   public class VLine extends SkinnableComponent
   {
       
      
      public function VLine()
      {
         super();
         this.setStyle("skinClass",VLineSkin);
      }
   }
}
