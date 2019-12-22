package spark.events
{
   import flash.events.Event;
   
   public class PopUpEvent extends Event
   {
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
       
      
      public var commit:Boolean;
      
      public var data;
      
      public function PopUpEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:* = undefined)
      {
         super(param1,param2,param3);
         this.commit = param4;
         this.data = param5;
      }
      
      override public function clone() : Event
      {
         return new PopUpEvent(type,bubbles,cancelable,this.commit,this.data);
      }
   }
}
