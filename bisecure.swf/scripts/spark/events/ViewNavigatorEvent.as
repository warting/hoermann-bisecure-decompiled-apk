package spark.events
{
   import flash.events.Event;
   
   public class ViewNavigatorEvent extends Event
   {
      
      public static const REMOVING:String = "removing";
      
      public static const VIEW_ACTIVATE:String = "viewActivate";
      
      public static const VIEW_DEACTIVATE:String = "viewDeactivate";
       
      
      public var action:String;
      
      public function ViewNavigatorEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:String = null)
      {
         super(param1,param2,param3);
         this.action = param4;
      }
      
      override public function clone() : Event
      {
         return new ViewNavigatorEvent(type,bubbles,cancelable,this.action);
      }
   }
}
