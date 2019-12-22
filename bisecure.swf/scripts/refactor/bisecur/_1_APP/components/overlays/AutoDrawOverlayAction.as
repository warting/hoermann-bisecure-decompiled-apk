package refactor.bisecur._1_APP.components.overlays
{
   import mx.core.IVisualElement;
   
   public final class AutoDrawOverlayAction
   {
       
      
      public var from:IVisualElement;
      
      public var to:IVisualElement;
      
      public var fromDirection:String;
      
      public var toDirection:String;
      
      public function AutoDrawOverlayAction(param1:IVisualElement = null, param2:IVisualElement = null, param3:String = "auto", param4:String = "auto")
      {
         this.fromDirection = AutoDrawOverlayDirection.AUTO;
         this.toDirection = AutoDrawOverlayDirection.AUTO;
         super();
         this.from = param1;
         this.to = param2;
         this.fromDirection = param3;
         this.toDirection = param4;
      }
   }
}
