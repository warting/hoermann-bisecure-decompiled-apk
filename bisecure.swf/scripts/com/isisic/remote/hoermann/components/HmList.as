package com.isisic.remote.hoermann.components
{
   import spark.components.List;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class HmList extends List
   {
       
      
      public function HmList()
      {
         super();
         this.layout = defaultLayout;
      }
      
      public static function get defaultLayout() : LayoutBase
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         _loc1_.paddingTop = 25;
         _loc1_.paddingBottom = 25;
         _loc1_.paddingLeft = 0;
         _loc1_.paddingRight = 0;
         _loc1_.variableRowHeight = true;
         _loc1_.horizontalAlign = HorizontalAlign.JUSTIFY;
         return _loc1_;
      }
   }
}
