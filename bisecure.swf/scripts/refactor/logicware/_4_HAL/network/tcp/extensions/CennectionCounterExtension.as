package refactor.logicware._4_HAL.network.tcp.extensions
{
   import refactor.logicware._4_HAL.network.tcp.Client;
   import refactor.logicware._5_UTIL.ArrayHelper;
   import refactor.logicware._5_UTIL.Log;
   
   public class CennectionCounterExtension implements IClientExtension
   {
      
      public static var connectedClients:Array = [];
       
      
      private var client:Client;
      
      public function CennectionCounterExtension()
      {
         super();
      }
      
      public function initialize(param1:Client) : void
      {
         this.client = param1;
      }
      
      public function onAction(param1:String, param2:Boolean, param3:Array = null) : Boolean
      {
         switch(param1)
         {
            case ExtensionActionNames.BEFORE_CONNECTING:
               break;
            case ExtensionActionNames.AFTER_CONNECTING:
               break;
            case ExtensionActionNames.AFTER_CONNECT:
               this.setConnected();
               break;
            case ExtensionActionNames.AFTER_CONNECT_FAIL:
               this.setDisconnected();
               break;
            case ExtensionActionNames.BEFORE_SEND:
               break;
            case ExtensionActionNames.AFTER_SEND:
               break;
            case ExtensionActionNames.BEFORE_RECEIVE:
               break;
            case ExtensionActionNames.AFTER_RECEIVE:
               break;
            case ExtensionActionNames.BEFORE_CLOSING:
               break;
            case ExtensionActionNames.AFTER_CLOSING:
               this.setDisconnected();
               break;
            case ExtensionActionNames.BEFORE_DESTRUCT:
         }
         return true;
      }
      
      private function setConnected() : *
      {
         if(ArrayHelper.in_array(this.client,connectedClients))
         {
            Log.error("[ConnectionCounterExtension] counting Connection failed! (already Connected) ########################################################");
            return;
         }
         connectedClients.push(this.client);
         Log.debug("[ConnectionCounterExtension] Client Connected - " + connectedClients.length + " connected Clients");
      }
      
      private function setDisconnected() : *
      {
         if(!ArrayHelper.in_array(this.client,connectedClients))
         {
            Log.error("[ConnectionCounterExtension] counting Disconnection failed! (not Connected) ########################################################");
            return;
         }
         ArrayHelper.removeItem(this.client,connectedClients);
         Log.debug("[ConnectionCounterExtension] Client Disconnected - " + connectedClients.length + " connected Clients");
      }
      
      public function dispose() : void
      {
         this.client = null;
      }
   }
}
