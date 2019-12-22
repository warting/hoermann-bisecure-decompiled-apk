package refactor.bisecur._1_APP.views.viewActions.forward
{
   public class ForwardViewActionItem
   {
      
      public static const FORWARD_ACTION_PUSH:String = "push";
      
      public static const FORWARD_ACTION_REPLACE:String = "replace";
       
      
      public var destinationView:Class;
      
      public var forwardAction:String;
      
      public function ForwardViewActionItem(param1:Class, param2:String)
      {
         super();
         this.destinationView = param1;
         this.forwardAction = param2;
      }
   }
}
