package com.isisic.remote.hoermann.events
{
   import flash.events.Event;
   
   public class BottomBarEvent extends Event
   {
      
      public static const REFRESH:String = "BOTTOMBAR_REFRESH";
      
      public static const HELP:String = "BOTTOMBAR_HELP";
      
      public static const ONLINE_HELP:String = "BOTTOM_BAR_ONLINE_HELP";
      
      public static const NOTIFICATIONS:String = "BOTTOM_BAR_NOTIFICATIONS";
      
      public static const LOGOUT:String = "BOTTOMBAR_LOGOUT";
       
      
      protected var _altKey:Boolean;
      
      protected var _ctrlKey:Boolean;
      
      protected var _shiftKey:Boolean;
      
      public function BottomBarEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         this._altKey = param2;
         this._ctrlKey = param3;
         this._shiftKey = param4;
      }
      
      public function get altKey() : Boolean
      {
         return this._altKey;
      }
      
      public function get ctrlKey() : Boolean
      {
         return this._ctrlKey;
      }
      
      public function get shiftKey() : Boolean
      {
         return this._shiftKey;
      }
   }
}
